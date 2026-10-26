import { Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";
import {
  FREE_RECURRING_LIMIT,
  REGION,
  TIME_ZONE,
  activityDoc,
  db,
  isActivePro,
} from "./common.js";
import { nextMonthly, nextWeekly } from "./dates.js";
import { SplitType, computeShares } from "./money.js";
import { notifyUsers } from "./notify.js";

export interface RecurringTemplate {
  description: string;
  amountMinor: number;
  paidBy: string;
  category: string;
  splitType: SplitType;
  splitInput: Record<string, number>;
  note?: string;
  frequency: "monthly" | "weekly";
  dayOfMonth?: number;
  dayOfWeek?: number;
  fixedAmount: boolean;
  nextRunAt: Timestamp;
  active: boolean;
  createdBy: string;
}

export function advance(t: Pick<RecurringTemplate, "frequency" | "dayOfMonth" | "dayOfWeek">, from: Date): Date {
  return t.frequency === "monthly"
    ? nextMonthly(from, t.dayOfMonth ?? 1)
    : nextWeekly(from, t.dayOfWeek ?? 1);
}

/** Builds the expense document a template produces for [runAt]. */
export function buildExpense(
  t: RecurringTemplate,
  rid: string,
  runAt: Date,
  memberIds: string[],
): Record<string, unknown> | null {
  if (!memberIds.includes(t.paidBy)) return null;
  const splitInput: Record<string, number> = {};
  for (const [uid, v] of Object.entries(t.splitInput ?? {})) {
    if (memberIds.includes(uid)) splitInput[uid] = v;
  }
  if (Object.keys(splitInput).length === 0) return null;
  const now = Timestamp.now();
  const base = {
    description: t.description,
    paidBy: t.paidBy,
    date: Timestamp.fromDate(runAt),
    category: t.category,
    splitType: t.splitType,
    splitInput,
    recurringId: rid,
    note: t.note ?? "",
    createdBy: t.createdBy,
    createdAt: now,
    updatedAt: now,
  };
  if (!t.fixedAmount) {
    return { ...base, amountMinor: 0, shares: {}, status: "pendingAmount" };
  }
  try {
    const shares = computeShares(t.splitType, t.amountMinor, splitInput);
    return { ...base, amountMinor: t.amountMinor, shares, status: "final" };
  } catch {
    // Split no longer valid (e.g. a member left an exact split): ask for input.
    return { ...base, amountMinor: 0, shares: {}, status: "pendingAmount" };
  }
}

export async function runRecurringOnce(now = new Date()): Promise<number> {
  const due = await db
    .collectionGroup("recurring")
    .where("active", "==", true)
    .where("nextRunAt", "<=", Timestamp.fromDate(now))
    .get();
  const allowedCache = new Map<string, Set<string> | null>();
  let created = 0;
  for (const doc of due.docs) {
    const hRef = doc.ref.parent.parent!;
    const hSnap = await hRef.get();
    if (!hSnap.exists) continue;
    const memberIds = (hSnap.get("memberIds") as string[]) ?? [];
    if (!allowedCache.has(hRef.id)) {
      if (isActivePro(hSnap.get("proUntil"))) {
        allowedCache.set(hRef.id, null);
      } else {
        const first = await hRef
          .collection("recurring")
          .where("active", "==", true)
          .orderBy("createdAt")
          .limit(FREE_RECURRING_LIMIT)
          .get();
        allowedCache.set(hRef.id, new Set(first.docs.map((d) => d.id)));
      }
    }
    const allowed = allowedCache.get(hRef.id);
    if (allowed && !allowed.has(doc.id)) continue;

    const t = doc.data() as RecurringTemplate;
    const runAt = t.nextRunAt.toDate();
    let next = advance(t, runAt);
    while (next.getTime() <= now.getTime()) next = advance(t, next);
    const expense = buildExpense(t, doc.id, runAt, memberIds);
    const batch = db.batch();
    if (expense) {
      const eRef = hRef.collection("expenses").doc();
      batch.create(eRef, expense);
      batch.create(
        hRef.collection("activity").doc(),
        activityDoc("recurringCreated", t.createdBy, eRef.id, {
          description: t.description,
          amountMinor: expense.amountMinor as number,
          pending: expense.status === "pendingAmount",
        }),
      );
      created++;
    }
    batch.update(doc.ref, { nextRunAt: Timestamp.fromDate(next), active: expense !== null });
    await batch.commit();
    if (expense?.status === "pendingAmount") {
      await notifyUsers([t.paidBy], "bills", "pendingBill", () => ({
        household: hSnap.get("name") as string,
        description: t.description,
      }), { type: "pendingBill", hid: hRef.id });
    }
  }
  logger.info("runRecurring", { due: due.size, created });
  return created;
}

export const runRecurring = onSchedule(
  { schedule: "0 3 * * *", timeZone: TIME_ZONE, region: REGION },
  async () => {
    await runRecurringOnce();
  },
);
