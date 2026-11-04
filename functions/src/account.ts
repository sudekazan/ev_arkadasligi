import { getAuth } from "firebase-admin/auth";
import { logger } from "firebase-functions/v2";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { CALLABLE, db, requireAuth } from "./common.js";
import { balanceOf, detachMember } from "./household.js";
import { deleteSubscriber, revenueCatApiKey } from "./revenuecat.js";

export interface HouseholdBalance {
  name: string;
  currency: string;
  balanceMinor: number;
}

/** The households where the user is not settled up (balance is not zero). */
export function blockingBalances(rows: HouseholdBalance[]): HouseholdBalance[] {
  return rows.filter((row) => row.balanceMinor !== 0);
}

/**
 * Deletes the caller's account. Past expenses keep the uid; the member
 * document is flagged `deleted` so clients show "Deleted user".
 * Without `force`, refuses while the user has an open balance anywhere, so
 * the app can warn first. The RevenueCat record is removed last and a failure
 * there is only logged: the account is already gone by then.
 */
export const deleteAccount = onCall(
  { ...CALLABLE, secrets: [revenueCatApiKey] },
  async (req) => {
    const uid = requireAuth(req);
    const force = req.data?.force === true;
    const userRef = db.collection("users").doc(uid);
    const snap = await userRef.get();
    const householdIds = (snap.get("householdIds") as string[]) ?? [];
    if (!force) {
      const rows: HouseholdBalance[] = [];
      for (const hid of householdIds) {
        // A household that no longer exists cannot hold a balance.
        const h = (await db.collection("households").doc(hid).get()).data();
        if (!h) continue;
        rows.push({
          name: h.name,
          currency: h.currency,
          balanceMinor: await balanceOf(hid, uid),
        });
      }
      const households = blockingBalances(rows);
      if (households.length > 0) {
        throw new HttpsError("failed-precondition", "balance-not-zero", { households });
      }
    }
    for (const hid of householdIds) {
      await detachMember(hid, uid, "memberLeft", uid, {
        deleted: true,
        displayName: "",
        avatarEmoji: "👤",
        iban: null,
      });
    }
    await db.recursiveDelete(userRef);
    await db.collection("usage").doc(uid).delete();
    await getAuth().deleteUser(uid);
    try {
      await deleteSubscriber(uid);
    } catch (err) {
      logger.warn("revenuecat delete failed", { uid, err: String(err) });
    }
    return { ok: true };
  },
);
