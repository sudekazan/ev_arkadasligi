// Calendar helpers in Europe/Istanbul. Turkey has used a fixed UTC+3 offset
// since 2016, so a constant offset is exact.

const OFFSET_MS = 3 * 60 * 60 * 1000;
const DAY_MS = 24 * 60 * 60 * 1000;

export interface LocalDate {
  year: number;
  month: number; // 1-12
  day: number;
}

export function toLocal(date: Date): LocalDate {
  const d = new Date(date.getTime() + OFFSET_MS);
  return {
    year: d.getUTCFullYear(),
    month: d.getUTCMonth() + 1,
    day: d.getUTCDate(),
  };
}

/** Istanbul local midnight + [hour] of the given local date, as an instant. */
export function fromLocal(local: LocalDate, hour = 0): Date {
  return new Date(
    Date.UTC(local.year, local.month - 1, local.day, hour) - OFFSET_MS,
  );
}

export function daysInMonth(year: number, month: number): number {
  return new Date(Date.UTC(year, month, 0)).getUTCDate();
}

/** Monday = 1 … Sunday = 7, as Dart's DateTime.weekday. */
export function localWeekday(date: Date): number {
  const d = new Date(date.getTime() + OFFSET_MS).getUTCDay();
  return d === 0 ? 7 : d;
}

/**
 * Next monthly occurrence strictly after [after] on [dayOfMonth]; months
 * without that day use their last day.
 */
export function nextMonthly(after: Date, dayOfMonth: number): Date {
  const l = toLocal(after);
  let year = l.year;
  let month = l.month;
  for (let i = 0; i < 3; i++) {
    const day = Math.min(dayOfMonth, daysInMonth(year, month));
    const candidate = fromLocal({ year, month, day });
    if (candidate.getTime() > after.getTime()) return candidate;
    month += 1;
    if (month > 12) {
      month = 1;
      year += 1;
    }
  }
  throw new Error("unreachable");
}

/** Next weekly occurrence strictly after [after] on [dayOfWeek] (1-7). */
export function nextWeekly(after: Date, dayOfWeek: number): Date {
  const l = toLocal(after);
  const midnight = fromLocal(l);
  const today = localWeekday(after);
  let delta = (dayOfWeek - today + 7) % 7;
  let candidate = new Date(midnight.getTime() + delta * DAY_MS);
  if (candidate.getTime() <= after.getTime()) {
    delta += 7;
    candidate = new Date(midnight.getTime() + delta * DAY_MS);
  }
  return candidate;
}

export function addDays(date: Date, days: number): Date {
  return new Date(date.getTime() + days * DAY_MS);
}

/** End of the local Istanbul day containing [date]. */
export function endOfLocalDay(date: Date): Date {
  return new Date(fromLocal(toLocal(date)).getTime() + DAY_MS - 1);
}

/** "2026-10" style key for the local month of [date]. */
export function monthKey(date: Date): string {
  const l = toLocal(date);
  return `${l.year}-${String(l.month).padStart(2, "0")}`;
}

/** "2026-10-26" style key for the local day of [date]. */
export function dayKey(date: Date): string {
  const l = toLocal(date);
  return `${monthKey(date)}-${String(l.day).padStart(2, "0")}`;
}
