# zig-package-manager-example
## Minimal lib setup
This branch shows the minimal setup needed for providing and using a zig library.

## Using it
In your zig project folder (where `build.zig` is located), run:

```sh
zig fetch --save "git+https://github.com/42LM/zig-package-manager-example#minimal"
```

Then, in your `build.zig`'s `build` function, add the following before
`b.installArtifact(exe)`:

```zig
    const hello = b.dependency("zig_package_manager_example", .{
        .target = target,
        .optimize = optimize,
    });
```

exe
```zig
    const exe = b.addExecutable(.{
        .name = "foo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "hello", .module = hello.module("hello") },
            },
        }),
    });
```

lib
```zig
    const foo_lib = b.addModule("root", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "hello", .module = hello.module("hello") },
        },
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "root",
        .root_module = root,
    });
```
