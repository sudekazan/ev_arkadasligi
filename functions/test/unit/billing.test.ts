import { describe, expect, it } from "vitest";
import { proUntilFor } from "../../src/billing.js";

describe("RevenueCat events", () => {
  it("grants until expiration", () => {
    const at = Date.UTC(2026, 11, 1);
    expect(proUntilFor({ type: "INITIAL_PURCHASE", app_user_id: "u", expiration_at_ms: at })).toEqual(new Date(at));
    expect(proUntilFor({ type: "RENEWAL", app_user_id: "u", expiration_at_ms: at })).toEqual(new Date(at));
  });

  it("expiration revokes, cancellation keeps access", () => {
    expect(proUntilFor({ type: "EXPIRATION", app_user_id: "u" })).toBeNull();
    expect(proUntilFor({ type: "CANCELLATION", app_user_id: "u" })).toBeUndefined();
    expect(proUntilFor({ type: "TEST", app_user_id: "u" })).toBeUndefined();
  });

  it("non-expiring purchases get a far future date", () => {
    const now = Date.UTC(2026, 0, 1);
    const r = proUntilFor({ type: "NON_RENEWING_PURCHASE", app_user_id: "u", expiration_at_ms: null }, now);
    expect(r!.getTime()).toBeGreaterThan(now + 50 * 365 * 864e5);
  });
});
