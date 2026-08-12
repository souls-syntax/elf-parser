// os.zig: thin platform shim exposing mmap/mprotect to tsundere-runtime.
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
const builtin = @import("builtin");
const baka = @import("baka");


const PROT = std.posix.PROT;
const page_size_min = std.heap.page_size_min; 
const MAP = std.posix.MAP;
const fd_t = std.posix.fd_t;
const MMapError = std.posix.MMapError;

pub fn os_mprotect(address: [*]const u8, length: usize, protection: PROT) !void {

    if ( builtin.target.os.tag  == .linux) {
        _ = std.os.linux.mprotect(@alignCast(address), length, protection);
        return;
    } else if (builtin.target.os.tag == .windows) {
        return baka.BakaErr.NotImplementedYet;
    }

    return baka.BakaErr.NotImplementedYet;
}

pub fn os_mmap(ptr: ?[*]align(page_size_min) u8, length: usize, prot: PROT, flags: MAP, fd: fd_t, offset: u64) baka.BakaErr![]align(page_size_min) u8 {
    if (builtin.target.os.tag == .linux) {
        return std.posix.mmap(ptr, length, prot, flags, fd, offset) catch return baka.BakaErr.MMapFailed;
    }
    return baka.BakaErr.MMapFailed;
}
