const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "zlshm",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    {
        const zigwin32 = b.dependency("zigwin32", .{});
        lib.root_module.addImport("win32", zigwin32.module("win32"));
    }

    b.installArtifact(lib);
}
