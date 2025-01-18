const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // lib
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

    // exe
    const exe = b.addExecutable(.{
        .name = "nop",
        .root_source_file = b.path("src/nop.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "No operations (NOP)");
    run_step.dependOn(&run_cmd.step);

    // test
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/hello.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
