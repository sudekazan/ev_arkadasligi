import { Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { REGION, TIME_ZONE, db } from "./common.js";
import { endOfLocalDay } from "./dates.js";
import { notifyUsers } from "./notify.js";

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
