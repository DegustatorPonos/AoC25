const std = @import("std");
const math = std.math;

const Span = struct {
    Start: u64,
    End: u64,
};

pub fn ParseInputs(file: []const u8) ![]Span {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var outp = try std.ArrayList(Span).initCapacity(alloc, 0);

    const fprt = try std.fs.cwd().openFile(file, .{});
    defer fprt.close();

    var buf: [1024]u8 = undefined;
    var reader = fprt.reader(&buf);
    while (try reader.interface.takeDelimiter(',')) |line| {
        var parts = std.mem.splitScalar(u8, line, '-');
        const startUnparsed = parts.next().?;
        var endUnparsed = parts.next().?;
        // Edge case in the last element in sequence
        if (endUnparsed[endUnparsed.len - 1] == '\n') 
            endUnparsed = endUnparsed[0..endUnparsed.len - 1];
        std.debug.print("Start: '{s}', End: '{s}'\n", .{startUnparsed, endUnparsed});
        const start = try std.fmt.parseInt(u64, startUnparsed, 10);
        const end = try std.fmt.parseInt(u64, endUnparsed, 10);
        try outp.append(alloc, Span {
            .Start = start,
            .End = end,
        });
    }
    return outp.items;
}


pub fn SolvePart1(inputs: []const Span) u64 {
    var outp: u64 = 0;
    for (inputs) |inp| {
        const len = getSymbolsAmount(inp.Start);
        var startIterator = @divFloor(inp.Start, math.pow(u64, 10, divCelling(len, 2)));
        var iteration = combineNumTwice(startIterator);
        // std.debug.print("Start: {d}\tLen: {d}\tStart: {d}\t", .{inp.Start, len, startIterator});
        while (iteration <= inp.End) {
            if (iteration >= inp.Start) {
                outp += iteration;
                // std.debug.print("Add {d}\t", .{iteration});
            }
            startIterator += 1;
            iteration = combineNumTwice(startIterator);
            // std.debug.print("Testing {d}<{d}\t", .{iteration, inp.End});
        }
        // std.debug.print("\n", .{});
    }
    return outp;
}

fn combineNumTwice(num: u64) u64 {
    return num + num * math.pow(u64, 10, getSymbolsAmount(num));
}

fn divCelling(num: u64, denom: u64) u64 {
    var outp = @divFloor(num, denom);
    if (@rem(num, denom) != 0)
        outp += 1;
    return outp;
}

fn getSymbolsAmount(num: u64) u64 {
    var outp: u64 = 1;
    while (@divFloor(num, math.pow(u64, 10, outp)) != 0) 
        outp += 1;
    return outp;
}

test "comb" {
    try std.testing.expect(combineNumTwice(12345) == 1234512345);
}

test "Part 1 solve" {
    const expected: u64 = 1227775554;
    const inputs = [_]Span {
        .{.Start = 11, .End = 22 },
        .{.Start = 95, .End = 115 },
        .{.Start = 998, .End = 1012 },
        .{.Start = 1188511880, .End = 1188511890 },
        .{.Start = 222220, .End = 222224 },
        .{.Start = 1698522, .End = 1698528 },
        .{.Start = 446443, .End = 446449 },
        .{.Start = 38593856, .End = 38593862 },
    };
    const result = SolvePart1(&inputs);
    std.debug.print("Result: {d}, expected: {d} (diff= {d})\n", .{result, expected, @abs(expected - result)});
    try std.testing.expect(result == expected);
}
