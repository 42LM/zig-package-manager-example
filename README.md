[![ubuntu-latest](https://github.com/42LM/zig-package-manager-example/actions/workflows/ubuntu-latest.yml/badge.svg)](https://github.com/42LM/zig-package-manager-example/actions/workflows/ubuntu-latest.yml) [![macos-latest](https://github.com/42LM/zig-package-manager-example/actions/workflows/macos-latest.yml/badge.svg)](https://github.com/42LM/zig-package-manager-example/actions/workflows/macos-latest.yml) [![windows-latest](https://github.com/42LM/zig-package-manager-example/actions/workflows/windows-latest.yml/badge.svg)](https://github.com/42LM/zig-package-manager-example/actions/workflows/windows-latest.yml)

[![v0.12.0](https://github.com/42LM/zig-package-manager-example/actions/workflows/v0.12.0.yml/badge.svg)](https://github.com/42LM/zig-package-manager-example/actions/workflows/v0.12.0.yml) [![v0.13.0](https://github.com/42LM/zig-package-manager-example/actions/workflows/v0.13.0.yml/badge.svg)](https://github.com/42LM/zig-package-manager-example/actions/workflows/v0.13.0.yml) [![v0.14.0](https://github.com/42LM/zig-package-manager-example/actions/workflows/v0.14.0.yml/badge.svg)](https://github.com/42LM/zig-package-manager-example/actions/workflows/v0.14.0.yml)

# zig-package-manager-example
This is a small and simple example/demonstration of the zig package manager aka `zig.zon`.

It provides an example on how to provide a zig ligrary and how to use it in a different project.

> [!IMPORTANT]
> 🛟 Does **not work** on **zig versions below `< v0.12.0`**!  
> ⚠️ Does **not work** on **windows**!

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

> Does not do much, only prints out `no operations`

Run the tests:
```sh
zig build test
```

> Run the tests of the lib
