const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Register the library as a module within the zig build system.
    const hello = b.addModule("hello", .{
        .root_source_file = b.path("src/hello.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Create the actual compiled library artifact.
    // This is the binary that other projects will eventually link against.
    // Zig fetch needs this to provide the compiled library to the other project.
    const lib = b.addLibrary(.{
        .linkage = .static, // or .dynamic
        .name = "hello",
        .root_module = hello,
    });

    b.installArtifact(lib);

    // Define run step to print no operations as it is not set up.
    // There is no executable to run.
    const run_step = b.step("run", "No operations (NOP)");
    const my_cmd = b.addSystemCommand(&[_][]const u8{ "echo", "\x1b[31mno operations\x1b[0m" });
    run_step.dependOn(&my_cmd.step);

    // Add tests.
    const lib_unit_tests = b.addTest(.{
        .root_module = hello,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
