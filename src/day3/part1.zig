const std = @import("std");

pub fn ParseInputs(file: []const u8) ![][]u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var outp = try std.ArrayList([]u8).initCapacity(alloc, 0);

    const fprt = try std.fs.cwd().openFile(file, .{});
    defer fprt.close();

    var buf: [8192]u8 = undefined;
    var reader = fprt.reader(&buf);
    while (try reader.interface.takeDelimiter('\n')) |line| {
        var list = try std.ArrayList(u8).initCapacity(alloc, line.len);
        // defer list.deinit(alloc);
        for (line) |char| {
            const num = char - '0';
            try list.append(alloc, num);
        }
        try outp.append(alloc, list.items);
    }

    return outp.items;
}

pub fn Solvept1(input: [][]u8) u64 {
    var outp: u64 = 0;
    for (input) |line| {
        // We don't use the last one in teh sequence in case the outp is the last symbol
        const firstMaxIndex: usize = getFirstMaxIndex(line[0..line.len - 1]); 
        const secondMaxIndex = getFirstMaxIndex(line[firstMaxIndex+1..]); 
        outp += line[firstMaxIndex] * 10 + line[secondMaxIndex + firstMaxIndex + 1];
    }
    return outp;
}

pub fn getFirstMaxIndex(vals: []u8) usize {
    var outp: usize = 0;
    var max: u8 = 0;
    for (vals, 0..) |inp, i| {
        if (inp > max) {
            max = inp;
            outp = i;
        }
    }
    return outp;
}

pub fn generateTestInp(alloc: std.mem.Allocator) ![][]u8 {
    var line1 = try alloc.alloc(u8, 15);
    line1.* = [_]u8 { 9,8,7,6,5,4,3,2,1,1,1,1,1,1,1 };
    var line2 = try alloc.alloc(u8, 15);
    line2.* = [_]u8 { 8,1,1,1,1,1,1,1,1,1,1,1,1,1,9 };
    var line3 = try alloc.alloc(u8, 15);
    line3.* = [_]u8 { 2,3,4,2,3,4,2,3,4,2,3,4,2,7,8 };
    var line4 = try alloc.alloc(u8, 15);
    line4.* = [_]u8 { 8,1,8,1,8,1,9,1,1,1,1,2,1,1,1 };
    var outp = [_][]u8 {
        &line1,
        &line2,
        &line3,
        &line4,
    };
    return &outp;
}

// 
// test "Part 1 solve" {
    // const expected: u64 = 357;
    // const result = Solvept1(generateTestInp());
    // try std.testing.expect(expected == result);
// }
