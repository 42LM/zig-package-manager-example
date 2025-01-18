# zig-package-manager-example
This is a small and simple example/demonstration of the zig package manager aka `zig.zon`.

It provides an example on how to provide a zig ligrary and how to use it in a different project.

> [!TIP]
> The `main` branch provides some convenient features like a nop executable and tests. That way the `zig build run` and `zig build test` commands do not raise errors.
>
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

Then, in your `build.zig`'s `build` function, add the following before
`b.installArtifact(exe)`:

```zig
    const hello = b.dependency("hello", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("hello", hello.module("hello"));
```

In your projects `main.zig` file import the hello module:
```zig
const std = @import("std");
const hello = @import("hello");

pub fn main() !void {
    std.debug.print("{s}\n", .{hello.world()});
}
```

Run the project:
```sh
zig build run
```

Run the tests:
```sh
zig build test
```
