// baka_sdk build: emits a freestanding app.baka guest from the baka SDK.
// Copyright (C) 2026  Aakarsh Kashyap
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

const std = @import("std");
pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
    });

    const baka_mod = b.addModule("baka", .{
        .root_source_file = b.path("baka.zig"),
        .target = target,
    });

    const exe = b.addExecutable(.{
        .name = "app.baka",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "baka", .module = baka_mod },
            },
        }),
    });
    exe.setLinkerScript(b.path("linker.lds"));
    exe.entry = .disabled;
    b.installArtifact(exe);
}
