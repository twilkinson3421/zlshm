const std = @import("std");

const win32 = @import("win32");
const winmem = win32.system.memory;
const winf = win32.foundation;
const FALSE = win32.zig.FALSE;

const log = std.log.scoped(.zlshm);

export fn open(name: [*:0]const u8, log_err: bool) ?winf.HANDLE {
    return winmem.OpenFileMappingA(@bitCast(winmem.FILE_MAP_ALL_ACCESS), FALSE, name) orelse {
        if (log_err) log.err("OpenFileMapping failed with error {}", .{winf.GetLastError()});
        return null;
    };
}

export fn close(handle: ?winf.HANDLE) i32 {
    return winf.CloseHandle(handle);
}

export fn read(handle: ?winf.HANDLE, buf: [*:0]u8, len: usize, log_err: bool) i32 {
    const mapbufptr = winmem.MapViewOfFile(handle, winmem.FILE_MAP_ALL_ACCESS, 0, 0, len) orelse {
        if (log_err) log.err("MapViewOfFile failed with error {}", .{winf.GetLastError()});
        return -1;
    };

    var ptr: []u8 = undefined;
    ptr.ptr = @alignCast(@ptrCast(mapbufptr));
    ptr.len = len;

    const data: []u8 = ptr[0..@as(usize, len)];
    std.mem.copyForwards(u8, buf[0..len], data[0..len]);
    return winmem.UnmapViewOfFile(mapbufptr);
}
