const std = @import("std");
const zaudio = @import("zaudio");

fn data_callback(device: *zaudio.Device, output: ?*anyopaque, input: ?*const anyopaque, frame_count: u32) callconv(.C) void {
    _ = frame_count;
    _ = input;
    _ = output;
    _ = device;
    std.log.info("here", .{});
}

fn create() !void {
    var cfg = zaudio.Device.Config.init(.playback);
    cfg.playback.format = .float32;
    cfg.playback.channels = 2;
    cfg.sample_rate = 48_000;
    cfg.data_callback = data_callback;

    const device = try zaudio.Device.create(null, cfg);
    try device.start();

    std.time.sleep(1_000_000_000);

    try device.stop();
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    try create();
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
