const std = @import("std");
const expect = std.testing.expect;

const Compile = std.Build.Step.Compile;

const ArrayList = std.ArrayList;
// const gpa = std.heap.GeneralPurposeAllocator(.{}){};
// const allocator = gpa.allocator();

pub fn build(b: *std.Build) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
    }

    const name = b.option(
        []const u8,
        "name",
        "Name of the executable",
    ) orelse "all";

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    var executables = ArrayList(*Compile).init(allocator);
    defer executables.deinit();

    if (std.mem.eql(u8, name, "all")) {
        // build all files

        std.debug.print("build all\n", .{});
        const echo = b.addExecutable(.{ .name = "echo", .root_source_file = b.path("./echo/echo.zig"), .target = target, .optimize = optimize });
        try executables.append(echo);

        const ls = b.addExecutable(.{ .name = "ls", .root_source_file = b.path("./ls/ls.zig"), .target = target, .optimize = optimize });
        try executables.append(ls);
    } else if (std.mem.eql(u8, name, "echo")) {
        std.debug.print("build echo\n", .{});
        const echo = b.addExecutable(.{ .name = "echo", .root_source_file = b.path("./echo/echo.zig"), .target = target, .optimize = optimize });
        try executables.append(echo);
    } else if (std.mem.eql(u8, name, "ls")) {
        std.debug.print("build ls\n", .{});
        const ls = b.addExecutable(.{ .name = "ls", .root_source_file = b.path("./ls/ls.zig"), .target = target, .optimize = optimize });
        try executables.append(ls);
    }

    // const exe = b.addExecutable(.{
    //     .name = "hello",

    //     .root_source_file = b.path("project_hello.zig"),
    //     .target = b.standardTargetOptions(.{}),
    //     .optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.Debug }),
    // });

    // b.installArtifact(exe);

    for (executables.items) |exe| {
        b.installArtifact(exe);
        //_ = exe;
    }

    std.debug.print("test build \n", .{});
}
