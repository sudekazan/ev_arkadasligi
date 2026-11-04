import { describe, expect, it } from "vitest";
import { proUntilFromSubscriber, uidsFromEvent } from "../../src/revenuecat.js";

describe("proUntilFromSubscriber", () => {
  it("active entitlement returns its expiration date", () => {
    const body = {
      subscriber: {
        entitlements: {
          pro: { expires_date: "2026-12-01T10:00:00Z", product_identifier: "pro_monthly" },
        },
      },
    };
    expect(proUntilFromSubscriber(body)).toEqual(new Date("2026-12-01T10:00:00Z"));
  });

  it("non-expiring entitlement gets a far future date", () => {
    const now = Date.UTC(2026, 0, 1);
    const body = { subscriber: { entitlements: { pro: { expires_date: null } } } };
    const r = proUntilFromSubscriber(body, now);
    expect(r!.getTime()).toBeGreaterThan(now + 50 * 365 * 864e5);
  });

  it("no pro entitlement returns null", () => {
    expect(proUntilFromSubscriber({ subscriber: { entitlements: {} } })).toBeNull();
    expect(proUntilFromSubscriber({ subscriber: { entitlements: { other: {} } } })).toBeNull();
    expect(proUntilFromSubscriber({})).toBeNull();
  });
});

describe("uidsFromEvent", () => {
  it("TRANSFER covers both accounts", () => {
    expect(
      uidsFromEvent({ type: "TRANSFER", transferred_from: ["old"], transferred_to: ["new"] }),
    ).toEqual(["old", "new"]);
  });

  it("filters anonymous ids and duplicates", () => {
    expect(
      uidsFromEvent({
        type: "TRANSFER",
        app_user_id: "u",
        transferred_from: ["$RCAnonymousID:abc", "u"],
        transferred_to: ["u"],
      }),
    ).toEqual(["u"]);
    expect(uidsFromEvent({ type: "INITIAL_PURCHASE", app_user_id: "$RCAnonymousID:x" })).toEqual([]);
  });

  it("INITIAL_PURCHASE returns app_user_id", () => {
    expect(uidsFromEvent({ type: "INITIAL_PURCHASE", app_user_id: "u1" })).toEqual(["u1"]);
  });
});
