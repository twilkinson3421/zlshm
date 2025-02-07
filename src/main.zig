const std = @import("std");
const W = std.unicode.utf8ToUtf16LeAlloc;

const win32 = @import("win32");
const winmem = win32.system.memory;
const winf = win32.foundation;
const FALSE = win32.zig.FALSE;

pub const UNICODE = true;

export fn read(path: [*:0]const u8, buf: [*:0]u8, len: usize) u32 {
    const zigpath: []const u8 = std.mem.span(path);
    const u16path: []const u16 = (W(std.heap.c_allocator, zigpath) catch return 1);
    const u16pathptr: [*:0]const u16 = @ptrCast(u16path.ptr);

    const pmap = winmem.OpenFileMapping(@bitCast(winmem.FILE_MAP_ALL_ACCESS), FALSE, u16pathptr) orelse {
        std.debug.print("OpenFileMapping failed with error {}\n", .{winf.GetLastError()});
        return 2;
    };
    defer std.debug.print("CloseHandle returned {}\n", .{winf.CloseHandle(pmap)});

    const pbuf = winmem.MapViewOfFile(pmap, winmem.FILE_MAP_ALL_ACCESS, 0, 0, len) orelse {
        std.debug.print("MapViewOfFile failed with error {}\n", .{winf.GetLastError()});
        return 3;
    };
    defer std.debug.print("UnmapViewOfFile returned {}\n", .{winmem.UnmapViewOfFile(pbuf)});

    var ptr: []u8 = undefined;
    ptr.ptr = @alignCast(@ptrCast(pbuf));
    ptr.len = len;

    const data: []u8 = ptr[0..@as(usize, len)];
    std.mem.copyForwards(u8, buf[0..len], data[0..len]);

    return 0;
}
