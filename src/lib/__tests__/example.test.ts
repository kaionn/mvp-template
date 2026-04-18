import { describe, expect, it } from "vitest";

import { greet } from "../example";

describe("greet", () => {
  it("greets the given name", () => {
    expect(greet("World")).toBe("Hello, World");
  });
});
