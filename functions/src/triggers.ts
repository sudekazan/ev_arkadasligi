import { Timestamp } from "firebase-admin/firestore";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { REGION, db, loadHousehold, requireAuth, requireMember, requireString } from "./common.js";
import { dayKey } from "./dates.js";
import { balanceOf } from "./household.js";
import { formatAmount, notifyUsers } from "./notify.js";

async function memberName(hid: string, uid: string): Promise<string> {
  const snap = await db.doc(`households/${hid}/members/${uid}`).get();
  return (snap.get("displayName") as string) || "?";
}

// Activity entries are written by the client in the same batch as the change
// (so the actor is known, also for deletes); triggers only notify.
export const onExpenseWritten = onDocumentWritten(
  { document: "households/{hid}/expenses/{eid}", region: REGION },
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    if (!after?.exists || before?.exists) return;
    const e = after.data()!;
    if (e.status !== "final") return;
    const hid = event.params.hid;
    const { data: h } = await loadHousehold(hid);
    const actor = await memberName(hid, e.createdBy);
    await notifyUsers(
      h.memberIds.filter((m) => m !== e.createdBy),
      "newExpense",
      "newExpense",
      (lang) => ({
        household: h.name,
        actor,
        description: e.description,
        amount: formatAmount(e.amountMinor, h.currency, lang),
      }),
      { type: "expense", hid, id: event.params.eid },
    );
  },
);

export const onSettlementWritten = onDocumentWritten(
  { document: "households/{hid}/settlements/{sid}", region: REGION },
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    if (!after?.exists || before?.exists) return;
    const s = after.data()!;
    const hid = event.params.hid;
    const { data: h } = await loadHousehold(hid);
    const actor = await memberName(hid, s.fromUid);
    const recipients = [s.toUid, s.fromUid].filter((u) => u !== s.createdBy);
    await notifyUsers(
      recipients,
      "reminders",
      "settlement",
      (lang) => ({
        household: h.name,
        actor,
        amount: formatAmount(s.amountMinor, h.currency, lang),
      }),
      { type: "settlement", hid, id: event.params.sid },
    );
  },
);

export const sendReminder = onCall({ region: REGION }, async (req) => {
  const uid = requireAuth(req);
  const hid = requireString(req.data?.hid, "hid");
  const toUid = requireString(req.data?.toUid, "toUid");
  const { data: h } = await loadHousehold(hid);
  requireMember(h, uid);
  requireMember(h, toUid);
  const owed = -(await balanceOf(hid, toUid));
  if (owed <= 0) throw new HttpsError("failed-precondition", "nothing-owed");

  const logRef = db.collection("reminders").doc(`${hid}_${uid}_${toUid}`);
  const today = dayKey(new Date());
  await db.runTransaction(async (tx) => {
    const log = await tx.get(logRef);
    if (log.get("day") === today) {
      throw new HttpsError("resource-exhausted", "reminder-already-sent");
    }
    tx.set(logRef, { day: today, sentAt: Timestamp.now() });
  });

  const actor = await memberName(hid, uid);
  const myBalance = await balanceOf(hid, uid);
  const amount = Math.min(owed, Math.max(myBalance, 0)) || owed;
  await notifyUsers(
    [toUid],
    "reminders",
    "reminder",
    (lang) => ({ household: h.name, actor, amount: formatAmount(amount, h.currency, lang) }),
    { type: "reminder", hid },
  );
  return { ok: true };
});
