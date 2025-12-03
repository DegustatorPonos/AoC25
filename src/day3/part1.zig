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


pub fn Solvept2(input: [][]u8) u64 {
    var outp: u64 = 0;
    for (input) |line| {
        const lineValue = processLinept2(line);
        outp += lineValue;
    }
    return outp;
}

fn processLinept2(inp: []u8) u64 {
    var outp: u64 = 0;
    var startIndex: usize = 0;
    for (0..12) |i| {
        const maxIndex: usize = getFirstMaxIndex(inp[startIndex..inp.len - (11 - i)]);
        startIndex += maxIndex + 1;
        outp += inp[startIndex-1] * std.math.pow(u64, 10, 11 - i);
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
