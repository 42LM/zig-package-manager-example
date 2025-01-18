const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "hello",
        .root_source_file = b.path("lib/hello.zig"),
        .target = target,
        .optimize = optimize,
    });

    const hello = b.addModule("hello", .{
        .root_source_file = b.path("lib/hello.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.root_module.addImport("hello", hello);

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "nop",
        .root_source_file = b.path("src/nop.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "No operations (NOP)");
    run_step.dependOn(&run_cmd.step);
}
