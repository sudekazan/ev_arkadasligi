import { describe, expect, it } from "vitest";
import { dropFromRotation } from "../../src/chores.js";

describe("dropFromRotation", () => {
  it("keeps the turn on the same person when someone else before them leaves", () => {
    expect(dropFromRotation(["a", "b", "c"], 2, "a")).toEqual({
      rotation: ["b", "c"],
      currentIndex: 1,
    });
  });

  it("hands the turn to the next person when the current one leaves", () => {
    expect(dropFromRotation(["a", "b", "c"], 1, "b")).toEqual({
      rotation: ["a", "c"],
      currentIndex: 1,
    });
  });

  it("keeps the index when someone after the current person leaves", () => {
    expect(dropFromRotation(["a", "b", "c"], 0, "c")).toEqual({
      rotation: ["a", "b"],
      currentIndex: 0,
    });
  });

  it("wraps to the start when the last person in turn leaves", () => {
    expect(dropFromRotation(["a", "b", "c"], 2, "c")).toEqual({
      rotation: ["a", "b"],
      currentIndex: 0,
    });
  });

  it("leaves an empty rotation with index 0 when the only person leaves", () => {
    expect(dropFromRotation(["a"], 0, "a")).toEqual({ rotation: [], currentIndex: 0 });
  });

  it("returns the input unchanged when the uid is not in the rotation", () => {
    expect(dropFromRotation(["a", "b", "c"], 1, "x")).toEqual({
      rotation: ["a", "b", "c"],
      currentIndex: 1,
    });
  });

  it("removes every occurrence of a uid listed more than once", () => {
    expect(dropFromRotation(["a", "b", "a", "c"], 3, "a")).toEqual({
      rotation: ["b", "c"],
      currentIndex: 1,
    });
  });

  it("reads an index past the end as wrapped, so the same person keeps the turn", () => {
    // 4 % 3 = 1, so it is b's turn; c leaving does not change that.
    expect(dropFromRotation(["a", "b", "c"], 4, "c")).toEqual({
      rotation: ["a", "b"],
      currentIndex: 1,
    });
  });

  it("hands over to the next person when the wrapped current one leaves", () => {
    // 5 % 3 = 2, so it is c's turn; with c gone it wraps to a.
    expect(dropFromRotation(["a", "b", "c"], 5, "c")).toEqual({
      rotation: ["a", "b"],
      currentIndex: 0,
    });
  });
});
