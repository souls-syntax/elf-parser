//! main.c the entry point for the application built
/* Copyright (C) 2026  Aakarsh Kashyap
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include "../baka.h"


__attribute__((section(".baka_header")))
BakaHeader header = {
	.magic_number = 0x62616B61,
	.version = 1,
	.memory_mb = 4096,
	.binary_size = 0,
	.entry_offset = 0x40,
	.name = "hello",
	.padding = {0}
};

void baka_main(const API* api) {
	api->text_render(0,0, "humpf, reeee.. i don't want to talk to you. baka.");
}
