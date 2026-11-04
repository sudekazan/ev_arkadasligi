import { FieldValue, Timestamp, Transaction } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { logger } from "firebase-functions/v2";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import {
  FREE_HOUSEHOLD_LIMIT,
  JOIN_FAILURES_PER_HOUR,
  MAX_MEMBERS,
  REGION,
  activityDoc,
  db,
  generateInviteCode,
  loadHousehold,
  recomputeHouseholdPro,
  requireAdmin,
  requireAuth,
  requireMember,
  requireString,
} from "./common.js";
import { dropFromRotation } from "./chores.js";
import { hourKey } from "./dates.js";
import { notifyUsers } from "./notify.js";
import { revenueCatApiKey, userIsProFresh } from "./revenuecat.js";
import { ExpenseLike, SettlementLike, computeNets } from "./money.js";

const SUPPORTED_CURRENCIES = ["TRY", "EUR", "USD", "GBP"];

async function reserveInviteCode(tx: Transaction, hid: string): Promise<string> {
  for (let attempt = 0; attempt < 10; attempt++) {
    const code = generateInviteCode();
    const ref = db.collection("inviteCodes").doc(code);
    const snap = await tx.get(ref);
    if (!snap.exists) {
      tx.set(ref, { householdId: hid, createdAt: Timestamp.now() });
      return code;
    }
  }
  throw new HttpsError("internal", "invite-code-exhausted");
}

async function assertCanJoinAnother(uid: string) {
  const user = await db.collection("users").doc(uid).get();
  const count = ((user.get("householdIds") as string[]) ?? []).length;
  if (count >= FREE_HOUSEHOLD_LIMIT && !(await userIsProFresh(uid))) {
    throw new HttpsError("failed-precondition", "household-limit");
  }
  return user;
}

export async function balanceOf(hid: string, uid: string): Promise<number> {
  const ref = db.collection("households").doc(hid);
  const [expenses, settlements] = await Promise.all([
    ref.collection("expenses").get(),
    ref.collection("settlements").get(),
  ]);
  const nets = computeNets(
    expenses.docs.map((d) => d.data() as ExpenseLike),
    settlements.docs.map((d) => d.data() as SettlementLike),
  );
  return nets[uid] ?? 0;
}

/** Removes [uid] from [hid]; shared by leave, remove and account deletion. */
export async function detachMember(
  hid: string,
  uid: string,
  activityType: string,
  actorUid: string,
  extraMemberFields: Record<string, unknown> = {},
) {
  const hRef = db.collection("households").doc(hid);
  const emptied = await db.runTransaction(async (tx) => {
    const snap = await tx.get(hRef);
    if (!snap.exists) return false;
    // Transactions need every read before the first write.
    const chores = await tx.get(
      hRef.collection("chores").where("rotation", "array-contains", uid),
    );
    const memberIds = (snap.get("memberIds") as string[]).filter((m) => m !== uid);
    let adminIds = (snap.get("adminIds") as string[]).filter((m) => m !== uid);
    if (adminIds.length === 0 && memberIds.length > 0) adminIds = [memberIds[0]];
    tx.update(hRef, { memberIds, adminIds });
    for (const chore of chores.docs) {
      tx.update(
        chore.ref,
        dropFromRotation(
          (chore.get("rotation") as string[]) ?? [],
          (chore.get("currentIndex") as number) ?? 0,
          uid,
        ),
      );
    }
    if (memberIds.length === 0) {
      tx.delete(db.collection("inviteCodes").doc(snap.get("inviteCode") as string));
    }
    tx.set(
      hRef.collection("members").doc(uid),
      { active: false, ...extraMemberFields },
      { merge: true },
    );
    tx.set(
      db.collection("users").doc(uid),
      { householdIds: FieldValue.arrayRemove(hid) },
      { merge: true },
    );
    tx.create(
      hRef.collection("activity").doc(),
      activityDoc(activityType, actorUid, uid),
    );
    return memberIds.length === 0;
  });
  if (emptied) {
    await purgeHousehold(hid);
  } else {
    await recomputeHouseholdPro(hid);
  }
}

/** Deletes a household nobody belongs to any more, with its receipt photos. */
async function purgeHousehold(hid: string) {
  await db.recursiveDelete(db.collection("households").doc(hid));
  await getStorage().bucket().deleteFiles({ prefix: `receipts/${hid}/` });
}

export const createHousehold = onCall({ region: REGION, secrets: [revenueCatApiKey] }, async (req) => {
  const uid = requireAuth(req);
  const name = requireString(req.data?.name, "name").slice(0, 60);
  const currency = String(req.data?.currency ?? "TRY");
  if (!SUPPORTED_CURRENCIES.includes(currency)) {
    throw new HttpsError("invalid-argument", "currency-unsupported");
  }
  const user = await assertCanJoinAnother(uid);
  const hRef = db.collection("households").doc();
  const inviteCode = await db.runTransaction(async (tx) => {
    const code = await reserveInviteCode(tx, hRef.id);
    const now = Timestamp.now();
    tx.create(hRef, {
      name,
      currency,
      createdBy: uid,
      adminIds: [uid],
      memberIds: [uid],
      inviteCode: code,
      proUntil: user.get("proUntil") ?? null,
      createdAt: now,
    });
    tx.create(hRef.collection("members").doc(uid), {
      displayName: user.get("displayName") ?? "",
      avatarEmoji: user.get("avatarEmoji") ?? "🙂",
      iban: user.get("iban") ?? null,
      rentWeight: 1,
      joinedAt: now,
      active: true,
    });
    tx.set(
      db.collection("users").doc(uid),
      { householdIds: FieldValue.arrayUnion(hRef.id) },
      { merge: true },
    );
    tx.create(
      hRef.collection("activity").doc(),
      activityDoc("householdCreated", uid, hRef.id, { name }),
    );
    return code;
  });
  return { householdId: hRef.id, inviteCode };
});

export const joinHousehold = onCall({ region: REGION, secrets: [revenueCatApiKey] }, async (req) => {
  const uid = requireAuth(req);
  const code = requireString(req.data?.code, "code").toUpperCase();
  const usageRef = db.collection("usage").doc(uid);
  const hour = hourKey(new Date());
  const failures = ((await usageRef.get()).get(`joinFailures.${hour}`) as number) ?? 0;
  if (failures >= JOIN_FAILURES_PER_HOUR) {
    throw new HttpsError("resource-exhausted", "too-many-attempts");
  }
  const codeSnap = await db.collection("inviteCodes").doc(code).get();
  if (!codeSnap.exists) {
    // Only unknown codes count; a correct code below the limit always works.
    await usageRef.set({ joinFailures: { [hour]: FieldValue.increment(1) } }, { merge: true });
    throw new HttpsError("not-found", "invite-code-invalid");
  }
  const hid = codeSnap.get("householdId") as string;
  const { ref: hRef, data: h } = await loadHousehold(hid);
  if (h.memberIds.includes(uid)) return { householdId: hid };
  if (h.memberIds.length >= MAX_MEMBERS) {
    throw new HttpsError("failed-precondition", "household-full");
  }
  const user = await assertCanJoinAnother(uid);
  await db.runTransaction(async (tx) => {
    const memberRef = hRef.collection("members").doc(uid);
    const existing = await tx.get(memberRef);
    tx.update(hRef, { memberIds: FieldValue.arrayUnion(uid) });
    tx.set(
      memberRef,
      {
        displayName: user.get("displayName") ?? "",
        avatarEmoji: user.get("avatarEmoji") ?? "🙂",
        iban: user.get("iban") ?? null,
        rentWeight: existing.exists ? (existing.get("rentWeight") ?? 1) : 1,
        joinedAt: Timestamp.now(),
        active: true,
      },
      { merge: true },
    );
    tx.set(
      db.collection("users").doc(uid),
      { householdIds: FieldValue.arrayUnion(hid) },
      { merge: true },
    );
    tx.create(hRef.collection("activity").doc(), activityDoc("memberJoined", uid, uid));
  });
  await recomputeHouseholdPro(hid);
  try {
    await notifyUsers(
      h.adminIds.filter((a) => a !== uid),
      "newExpense",
      "memberJoined",
      () => ({ household: h.name, actor: String(user.get("displayName") ?? "") }),
      { type: "member", hid },
    );
  } catch (err) {
    // The join already succeeded; a failed push must not undo it.
    logger.warn("member joined push failed", { hid, err: String(err) });
  }
  return { householdId: hid };
});

export const leaveHousehold = onCall({ region: REGION }, async (req) => {
  const uid = requireAuth(req);
  const hid = requireString(req.data?.hid, "hid");
  const { data: h } = await loadHousehold(hid);
  requireMember(h, uid);
  const balance = await balanceOf(hid, uid);
  if (balance !== 0) {
    throw new HttpsError("failed-precondition", "balance-not-zero", { balanceMinor: balance });
  }
  await detachMember(hid, uid, "memberLeft", uid);
  return { ok: true };
});

export const removeMember = onCall({ region: REGION }, async (req) => {
  const uid = requireAuth(req);
  const hid = requireString(req.data?.hid, "hid");
  const target = requireString(req.data?.uid, "uid");
  const { data: h } = await loadHousehold(hid);
  requireAdmin(h, uid);
  if (target === uid) throw new HttpsError("invalid-argument", "use-leave");
  requireMember(h, target);
  const balance = await balanceOf(hid, target);
  if (balance !== 0) {
    throw new HttpsError("failed-precondition", "balance-not-zero", { balanceMinor: balance });
  }
  await detachMember(hid, target, "memberRemoved", uid);
  return { ok: true };
});

export const regenerateInviteCode = onCall({ region: REGION }, async (req) => {
  const uid = requireAuth(req);
  const hid = requireString(req.data?.hid, "hid");
  const { ref: hRef, data: h } = await loadHousehold(hid);
  requireAdmin(h, uid);
  const inviteCode = await db.runTransaction(async (tx) => {
    const code = await reserveInviteCode(tx, hid);
    tx.delete(db.collection("inviteCodes").doc(h.inviteCode));
    tx.update(hRef, { inviteCode: code });
    return code;
  });
  return { inviteCode };
});
