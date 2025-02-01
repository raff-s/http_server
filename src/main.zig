const std = @import("std");
const SocketConf = @import("config.zig").Socket;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket = try SocketConf.init();
    try stdout.print("Server running at: {}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    const connection = try server.accept();
    _ = try connection;
}
