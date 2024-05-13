const std = @import("std");

const BasicTarget = struct {
    name: []const u8,
};

const exec_targets: [1]BasicTarget = .{
    .{ .name = "heap_sort" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    inline for (exec_targets) |exec_target| {
        const exe_tests = b.addTest(.{
            .name = exec_target.name,
            .root_source_file = b.path("src/" ++ exec_target.name ++ "/" ++ exec_target.name ++ ".zig"),
            .target = target,
            .optimize = optimize,
        });

        const run_tests = b.addRunArtifact(exe_tests);
        const test_step = b.step(exec_target.name, "Test " ++ exec_target.name);
        test_step.dependOn(&run_tests.step);
    }
}
