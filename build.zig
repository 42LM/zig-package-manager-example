const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    if (target.result.os.tag == .windows) {
        std.log.err("\x1b[31mWindows Platform Not Supported\x1b[0m\n", .{});
        std.process.exit(1);
    }
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

    // define run step to print no operations as it is not set up
    // there is no executable to run
    const run_step = b.step("run", "No operations (NOP)");
    const my_cmd = b.addSystemCommand(&[_][]const u8{ "echo", "\x1b[31mno operations\x1b[0m" });
    run_step.dependOn(&my_cmd.step);

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
