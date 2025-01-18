const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "hello",
        .root_source_file = b.path("src/hello.zig"), // ⚠ does not work with `lib/hello.zig`
        .target = target,
        .optimize = optimize,
    });

    const hello = b.addModule("hello", .{
        .root_source_file = b.path("src/hello.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.root_module.addImport("hello", hello);

    b.installArtifact(lib);
}
