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
        const exe = b.addExecutable(.{
            .name = exec_target.name,
            .root_source_file = b.path("src/" ++ exec_target.name ++ "/" ++ exec_target.name ++ ".zig"),
            .target = target,
            .optimize = optimize,
        });

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);

        run_cmd.step.dependOn(b.getInstallStep());

        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step(exec_target.name, "Run" ++ exec_target.name);
        run_step.dependOn(&run_cmd.step);
    }

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
