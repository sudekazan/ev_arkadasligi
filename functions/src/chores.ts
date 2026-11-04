import { Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { REGION, TIME_ZONE, db } from "./common.js";
import { endOfLocalDay } from "./dates.js";
import { notifyUsers } from "./notify.js";

/**
 * Removes [uid] from a chore rotation and returns the new rotation with an
 * index that is always in range (0 when the rotation ends up empty).
 *
 * Whose turn it is stays the same person, unless [uid] had the turn: then it
 * passes to the next person in line (wrapping to the start). A rotation that
 * does not contain [uid] comes back as it was.
 */
export function dropFromRotation(
  rotation: string[],
  currentIndex: number,
  uid: string,
): { rotation: string[]; currentIndex: number } {
  if (!rotation.includes(uid)) return { rotation, currentIndex };
  const remaining = rotation.filter((m) => m !== uid);
  if (remaining.length === 0) return { rotation: remaining, currentIndex: 0 };
  const turn = ((currentIndex % rotation.length) + rotation.length) % rotation.length;
  // People still in the rotation who sit before the current position; that is
  // where the current person (or, if they left, the next one) ends up.
  const before = rotation.slice(0, turn).filter((m) => m !== uid).length;
  return { rotation: remaining, currentIndex: before % remaining.length };
}

export async function choreRemindersOnce(now = new Date()): Promise<number> {
  const due = await db
    .collectionGroup("chores")
    .where("nextDueAt", "<=", Timestamp.fromDate(endOfLocalDay(now)))
    .get();
  let sent = 0;
  for (const doc of due.docs) {
    const rotation = (doc.get("rotation") as string[]) ?? [];
    if (rotation.length === 0) continue;
    const index = ((doc.get("currentIndex") as number) ?? 0) % rotation.length;
    const hSnap = await doc.ref.parent.parent!.get();
    if (!hSnap.exists) continue;
    await notifyUsers([rotation[index]], "chores", "chore", () => ({
      household: hSnap.get("name") as string,
      chore: doc.get("name") as string,
    }), { type: "chore", hid: hSnap.id, id: doc.id });
    sent++;
  }
  logger.info("choreReminders", { sent });
  return sent;
}

export const choreReminders = onSchedule(
  { schedule: "0 9 * * *", timeZone: TIME_ZONE, region: REGION },
  async () => {
    await choreRemindersOnce();
  },
);
