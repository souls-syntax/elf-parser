//! baka.h the C side api
/* tsundere-runtime baka SDK — C-side API header.
 *
 * Copyright (C) 2026  Aakarsh Kashyap
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
#ifndef BAKA_H
#define BAKA_H

#include <stdint.h>

typedef struct {
	uint32_t magic_number;
	uint32_t version;
	uint32_t memory_mb;
	uint32_t binary_size;
	uint32_t entry_offset;
	char name[32];
	char padding[12];
} BakaHeader ;

typedef struct {
    unsigned char e_ident[16];
    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    uint64_t e_entry;
    uint64_t e_phoff;
    uint64_t e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
} BakaElfHeader ;

typedef struct {
	void (*text_render)(int x, int y, const char* text);
} API;

#endif
