const std = @import("std");
const SocketConf = @import("config.zig").Socket;
const Request = @import("request.zig");
const Response = @import("response.zig");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket = try SocketConf.init();
    try stdout.print("Server running at: {}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    while (true) {
        std.debug.print("Waiting for connection\n", .{});
        const connection = try server.accept();
        var buffer: [1000]u8 = undefined;

        const buffer_slice = buffer[0..];
        @memset(&buffer, 0);

        try Request.read_request(connection, buffer_slice);
        const request = try Request.parse_request(buffer_slice);

        if (request.method == Request.Method.GET) {
            if (std.mem.eql(u8, request.uri, "/")) {
                try Response.send_200(connection);
            } else {
                try Response.send_404(connection);
            }
        }
    }
}
