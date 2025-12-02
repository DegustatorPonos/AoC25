const std = @import("std");
const AoC25 = @import("AoC25");
const d1p1 = @import("day1/p1.zig");

pub fn main() !void {
    try solveDay1();
}

fn solveDay1() !void {
    const inputs = try d1p1.ParseInputs("input1.txt");
    const pt1res = d1p1.Solvept1(inputs);
    const pt2res = d1p1.Solvept2(inputs);
    std.debug.print("Day 1 part 1 reresult: {d}\n", .{pt1res});
    std.debug.print("Day 1 part 2 reresult: {d}\n", .{pt2res});
}

test {
    _ = d1p1;
}
