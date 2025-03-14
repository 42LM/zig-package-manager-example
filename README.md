# zig-package-manager-example
## Minimal lib setup
This branch shows the minimal setup needed for providing and using a zig library.

## Using it
In your zig project folder (where `build.zig` is located), run:

```sh
zig fetch --save "git+https://github.com/42LM/zig-package-manager-example#3198f56a617c66ac6077da8c991a2f31a1fefbea"
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
