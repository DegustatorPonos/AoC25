const std = @import("std");
const AoC25 = @import("AoC25");
const d1 = @import("day1/p1.zig");
const d2 = @import("day2/part1.zig");

pub fn main() !void {
    // try solveDay1();
    try solveDay2();
}

fn solveDay1() !void {
    const inputs = try d1.ParseInputs("input1.txt");
    const pt1res = d1.Solvept1(inputs);
    const pt2res = d1.Solvept2(inputs);
    std.debug.print("Day 1 part 1 result: {d}\n", .{pt1res});
    std.debug.print("Day 1 part 2 result: {d}\n", .{pt2res});
}

fn solveDay2() !void {
    const inp = try d2.ParseInputs("input2.txt");
    const p1res = d2.SolvePart1(inp);
    const p2res = try d2.SolvePart2(inp);
    std.debug.print("Day 2 part 1 result: {d}\n", .{p1res});
    std.debug.print("Day 2 part 2 result: {d}\n", .{p2res});
}

test {
    _ = d1;
    _ = d2;
}
