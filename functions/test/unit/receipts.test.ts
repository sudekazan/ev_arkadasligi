import { describe, expect, it } from "vitest";
import { scanDecision } from "../../src/receipts.js";

describe("scanDecision", () => {
  it("rejects when the monthly quota is used up", () => {
    expect(scanDecision({ used: 5, limit: 5, failures: 0 })).toBe("receipt-quota");
  });

  it("rejects after 20 unreadable scans today", () => {
    expect(scanDecision({ used: 1, limit: 5, failures: 20 })).toBe("receipt-failures");
  });

  it("allows 19 failures", () => {
    expect(scanDecision({ used: 1, limit: 5, failures: 19 })).toBe("ok");
  });
});
