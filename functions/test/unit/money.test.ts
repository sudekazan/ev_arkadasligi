import { describe, expect, it } from "vitest";
import { allocateByWeights, computeNets, computeShares } from "../../src/money.js";

describe("money (mirror of lib/core/money)", () => {
  it("T1 equal split gives the extra kuruş to the first uid", () => {
    expect(computeShares("equal", 10000, { C: 1, A: 1, B: 1 })).toEqual({ A: 3334, B: 3333, C: 3333 });
  });

  it("T2 rent by weights", () => {
    expect(allocateByWeights(1500000, { A: 3, B: 2, C: 2 })).toEqual({ A: 642857, B: 428572, C: 428571 });
  });

  it("T4 percent with remainder", () => {
    expect(computeShares("percent", 10001, { A: 3333, B: 3333, C: 3334 })).toEqual({ A: 3333, B: 3333, C: 3335 });
  });

  it("rejects invalid sums", () => {
    expect(() => computeShares("percent", 100, { A: 5000 })).toThrow("percent-sum");
    expect(() => computeShares("exact", 100, { A: 50 })).toThrow("exact-sum");
    expect(() => allocateByWeights(100, { A: 0 })).toThrow("no-participants");
  });

  it("T6/T7/T9 nets ignore pending bills and sum to zero", () => {
    const equal = { A: 1, B: 1, C: 1 };
    const expenses = [
      { paidBy: "A", amountMinor: 90000, shares: computeShares("equal", 90000, equal), status: "final" },
      { paidBy: "B", amountMinor: 30000, shares: computeShares("equal", 30000, equal), status: "final" },
      { paidBy: "C", amountMinor: 0, shares: {}, status: "pendingAmount" },
    ];
    expect(computeNets(expenses, [])).toEqual({ A: 50000, B: -10000, C: -40000 });
    const nets = computeNets(expenses, [{ fromUid: "C", toUid: "A", amountMinor: 40000 }]);
    expect(nets).toEqual({ A: 10000, B: -10000, C: 0 });
    expect(Object.values(nets).reduce((a, b) => a + b, 0)).toBe(0);
  });
});
