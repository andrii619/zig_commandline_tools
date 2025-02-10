const std = @import("std");

pub fn main() void {
    std.io.getStdOut().writeAll(
        "Hello World ls!",
    ) catch unreachable;
}
