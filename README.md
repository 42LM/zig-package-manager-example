# zig-package-manager-example
This is a small and simple example/demonstration of the zig package manager aka `zig.zon`.

It provides an example on how to provide a zig ligrary and how to use it in a different project.

> [!IMPORTANT]
> 🚨 Does **not work** on **zig versions below `< v0.14.0`**!
>
> The example works on the current **zig version** `0.16.0-dev.1859+212968c57`.
>
> If you search for examples for older zig versions check out the older releases/tags. The releases/tags in this repo are sorted by zig version.

> [!TIP]
> If you are looking for minimal setup of a zig library please check out the [minimal](https://github.com/42LM/zig-package-manager-example/tree/minimal) branch.

## Using it
Create a new zig project:
```sh
mkdir zig-package-manager-example
cd zig-package-manager-example
zig init
```

In your zig project folder (where `build.zig` is located), run:

```sh
zig fetch --save "git+https://github.com/42LM/zig-package-manager-example"
```

> [!TIP]
> You can also fetch the lib/repo via tag/release. Check out the [v0.0.0 release](https://github.com/42LM/zig-package-manager-example/releases/tag/v0.0.0).

Then, in your `build.zig`'s `build` function, add the following before
`b.installArtifact(exe)`:

```zig
    const hello = b.dependency("zig_package_manager_example", .{
        .target = target,
        .optimize = optimize,
    });
```

Add the module as import:
```zig
    const exe = b.addExecutable(.{
        .name = "foo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "foo", .module = mod },
                .{ .name = "hello", .module = hello.module("hello") }, // <<<
            },
        }),
    });
```

In your projects `main.zig` file import the hello module:
```zig
const std = @import("std");
const hello = @import("hello");

pub fn main() !void {
    std.debug.print("{s}\n", .{hello.world()});
}
```

> [!NOTE]
> Add the module as import to your lib:
> ```zig
>     const root = b.addModule("root", .{
>         .root_source_file = b.path("src/root.zig"),
>         .target = target,
>         .optimize = optimize,
>         .imports = &.{
>             .{ .name = "hello", .module = hello.module("hello") }, // <<<
>         },
>     });
>
>     const lib = b.addLibrary(.{
>         .linkage = .static,
>         .name = "root",
>         .root_module = root,
>     });
> ```

Run the project:
```sh
zig build run
```

> Does not do much, only prints out `no operations`

Run the tests:
```sh
zig build test
```

> Run the tests of the lib

## Troubleshoot
> [!WARNING]
> Handle with care: Delete the cache of zig:
> ```
> rm -rf ~/.cache/zig
> ```
