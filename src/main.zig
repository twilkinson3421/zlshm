const std = @import("std");
const W = std.unicode.utf8ToUtf16LeAlloc;

const win32 = @import("win32");
const winmem = win32.system.memory;
const winf = win32.foundation;
const FALSE = win32.zig.FALSE;

pub const UNICODE = true;

const log = std.log.scoped(.zlshm);

export fn open(name: [*:0]const u8, log_err: bool) ?winf.HANDLE {
    const zigname: []const u8 = std.mem.span(name);
    const u16name: []const u16 = (W(std.heap.c_allocator, zigname) catch return null);
    const u16nameptr: [*:0]const u16 = @ptrCast(u16name.ptr);
    return winmem.OpenFileMapping(@bitCast(winmem.FILE_MAP_ALL_ACCESS), FALSE, u16nameptr) orelse {
        if (log_err) log.err("OpenFileMapping failed with error {}\n", .{winf.GetLastError()});
        return null;
    };
}

export fn close(handle: ?winf.HANDLE) i32 {
    return winf.CloseHandle(handle);
}

export fn read(handle: ?winf.HANDLE, buf: [*:0]u8, len: usize, log_err: bool) i32 {
    const mapbufptr = winmem.MapViewOfFile(handle, winmem.FILE_MAP_ALL_ACCESS, 0, 0, len) orelse {
        if (log_err) log.err("MapViewOfFile failed with error {}\n", .{winf.GetLastError()});
        return -1;
    };

    var ptr: []u8 = undefined;
    ptr.ptr = @alignCast(@ptrCast(mapbufptr));
    ptr.len = len;

    const data: []u8 = ptr[0..@as(usize, len)];
    std.mem.copyForwards(u8, buf[0..len], data[0..len]);
    return winmem.UnmapViewOfFile(mapbufptr);
}
