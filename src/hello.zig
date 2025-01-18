const std = @import("std");
const testing = std.testing;

pub fn world() []const u8 {
    return "hello world";
}

test "basic" {
    try testing.expect(std.mem.eql(u8, world(), "hello world"));
}
