import { getAuth } from "firebase-admin/auth";
import { onCall } from "firebase-functions/v2/https";
import { REGION, db, requireAuth } from "./common.js";
import { detachMember } from "./household.js";

/**
 * Deletes the caller's account. Past expenses keep the uid; the member
 * document is flagged `deleted` so clients show "Deleted user".
 */
export const deleteAccount = onCall({ region: REGION }, async (req) => {
  const uid = requireAuth(req);
  const userRef = db.collection("users").doc(uid);
  const snap = await userRef.get();
  for (const hid of (snap.get("householdIds") as string[]) ?? []) {
    await detachMember(hid, uid, "memberLeft", uid, {
      deleted: true,
      displayName: "",
      avatarEmoji: "👤",
    });
  }
  await db.recursiveDelete(userRef);
  await db.collection("usage").doc(uid).delete();
  await getAuth().deleteUser(uid);
  return { ok: true };
});
