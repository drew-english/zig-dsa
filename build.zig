const std = @import("std");
const fs = std.fs;
const path = fs.path;

const target_dirs: [1][]const u8 = .{"sorting"};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var target_files = std.ArrayList([]const u8).init(b.allocator);
    defer target_files.deinit();

    for (target_dirs) |dir_name| {
        const target_dir = try std.mem.concat(b.allocator, u8, &.{ "src/", dir_name });
        const dir = try fs.cwd().openDir(target_dir, .{ .iterate = true });
        var file_iter = dir.iterate();

        while (try file_iter.next()) |file| {
            if (file.kind != .file) {
                continue;
            }

            try target_files.append(try std.mem.concat(b.allocator, u8, &.{ target_dir, "/", file.name }));
        }
    }

    for (target_files.items) |target_file_path| {
        const fname = path.stem(target_file_path);
        const type_name = path.stem(path.dirname(target_file_path).?);
        const exe_tests = b.addTest(.{
            .name = fname,
            .root_source_file = b.path(target_file_path),
            .target = target,
            .optimize = optimize,
        });

        b.installArtifact(exe_tests);
        const run_tests = b.addRunArtifact(exe_tests);
        const test_step = b.step(fname, try std.mem.concat(b.allocator, u8, &.{ "(", type_name, ") Test ", fname }));
        test_step.dependOn(&run_tests.step);
    }
}
