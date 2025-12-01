const std = @import("std");

const startPos = 50;
const base = 100;

pub fn ParseInputs(file: []const u8) ![]const i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var outp = try std.ArrayList(i32).initCapacity(alloc, 0);

    const fprt = try std.fs.cwd().openFile(file, .{});
    defer fprt.close();

    var buf: [1024]u8 = undefined;
    var reader = fprt.reader(&buf);
    while (try reader.interface.takeDelimiter('\n')) |line| {
        const slice = line[1..line.len];
        var clean_num = try std.fmt.parseInt(i32, slice, 10);
        if (line[0] == 'L') {
            clean_num *= -1;
        }
        try outp.append(alloc, clean_num);
    }
    return outp.items;
}

pub fn Solvept1(inputs: []const i32) u16 {
    var currentPtr: i64 = startPos;
    var outp: u16 = 0;
    for (inputs) |v| {
        currentPtr += v;
        currentPtr = @rem(currentPtr, base);
        if (currentPtr == 0) {
            outp += 1;
        }
    }
    return outp;
}


pub fn Solvept2(inputs: []const i32) u64 {
    var currentPtr: i64 = startPos;
    var outp: u64 = 0;
    for (inputs) |v| {
        if (v == 0) continue;

        var delta = v;
        if (@divFloor(@abs(delta), base) > 0) {
            outp += @divFloor(@abs(delta), base);
            delta = @rem(v, base);
        }

        currentPtr += delta;
        if (currentPtr < 0 and currentPtr != delta) {
            currentPtr += base;
            outp += 1;
        } else {
            if (currentPtr == 0) {
                outp += 1;
            }
            outp += @abs(@divTrunc(currentPtr, base));
        }

        currentPtr = @mod(currentPtr, base);

    }
    return outp;
}

test "Solver Day1" {
    const expexted = 3;
    var inputs = [_]i32 {
        -68,
        -30,
        48,
        -5,
        60,
        -55,
        -1,
        -99,
        14,
        -82,
    };
    const result = Solvept1(&inputs);
    try std.testing.expect(result == expexted);
}


test "Solver Day2" {
    const expexted = 7;
    var inputs = [_]i32 {
        -168,
        -30,
        48,
        -5,
        60,
        -55,
        -1,
        -99,
        14,
        -82,
    };
    const result = Solvept2(&inputs);
    std.debug.print("value: {d}\n", .{result});
    try std.testing.expect(result == expexted);
}
