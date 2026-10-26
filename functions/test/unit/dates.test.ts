import { describe, expect, it } from "vitest";
import { dayKey, endOfLocalDay, fromLocal, localWeekday, monthKey, nextMonthly, nextWeekly } from "../../src/dates.js";
import { advance } from "../../src/recurring.js";

const local = (y: number, m: number, d: number, h = 0) => fromLocal({ year: y, month: m, day: d }, h);

describe("dates (Europe/Istanbul)", () => {
  it("monthly uses the last day in short months", () => {
    expect(nextMonthly(local(2026, 1, 31), 31)).toEqual(local(2026, 2, 28));
    expect(nextMonthly(local(2026, 2, 28), 31)).toEqual(local(2026, 3, 31));
    expect(nextMonthly(local(2028, 1, 31), 31)).toEqual(local(2028, 2, 29));
  });

  it("monthly is strictly after the given instant", () => {
    expect(nextMonthly(local(2026, 10, 5), 5)).toEqual(local(2026, 11, 5));
    expect(nextMonthly(local(2026, 10, 4, 23), 5)).toEqual(local(2026, 10, 5));
    expect(nextMonthly(local(2026, 12, 15), 1)).toEqual(local(2027, 1, 1));
  });

  it("weekly", () => {
    // 2026-10-26 is a Monday.
    expect(localWeekday(local(2026, 10, 26, 1))).toBe(1);
    expect(nextWeekly(local(2026, 10, 26), 1)).toEqual(local(2026, 11, 2));
    expect(nextWeekly(local(2026, 10, 26), 3)).toEqual(local(2026, 10, 28));
    expect(advance({ frequency: "weekly", dayOfWeek: 7 }, local(2026, 10, 26))).toEqual(local(2026, 11, 1));
  });

  it("keys use local time, not UTC", () => {
    // 2026-10-31 22:30 UTC is already 1 November in Istanbul.
    const d = new Date(Date.UTC(2026, 9, 31, 22, 30));
    expect(monthKey(d)).toBe("2026-11");
    expect(dayKey(d)).toBe("2026-11-01");
    expect(endOfLocalDay(d)).toEqual(new Date(local(2026, 11, 2).getTime() - 1));
  });
});
