import { describe, expect, it } from "vitest";
import { blockingBalances } from "../../src/account.js";

describe("blockingBalances", () => {
  it("keeps only households with a non-zero balance", () => {
    const rows = [
      { name: "Moda", currency: "TRY", balanceMinor: -25000 },
      { name: "Kadıköy", currency: "TRY", balanceMinor: 0 },
      { name: "Berlin", currency: "EUR", balanceMinor: 1200 },
    ];
    expect(blockingBalances(rows)).toEqual([rows[0], rows[2]]);
  });

  it("returns nothing when everything is settled", () => {
    expect(blockingBalances([{ name: "Moda", currency: "TRY", balanceMinor: 0 }])).toEqual([]);
    expect(blockingBalances([])).toEqual([]);
  });
});
