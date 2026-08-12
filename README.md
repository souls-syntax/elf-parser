# tsundere-runtime

A minimalist userspace runtime that loads and executes **baka** binaries — a
freestanding ELF-derived binary format designed for self-contained, relocatable
applications.

`tsundere-runtime` reads a compiled `.baka` artifact, validates its header,
maps it into memory with appropriate permissions (executable `.text`, readable
`.data`), resolves the `baka_main` entry symbol, and transfers control. It
ships with a small SDK (`baka_sdk`) for authoring baka applications in C or Zig.

The project is written entirely in [Zig](https://ziglang.org) and targets
Linux on x86_64 in its current prototype stage.

---

## Features

- **Custom binary loader.** Parses raw ELF headers, walks the section header
  table, the string table, and the symbol table to locate sections and
  entry symbols at runtime.
- **Two input shapes.** Accepts either a native baka binary (magic
  `0x62616B61`) or a standard ELF executable carrying a `.baka_header`
  section, resolving the entry point via the `.symtab` symbol table.
- **Memory-mapped execution.** Uses `mmap`/`mprotect` to map binaries
  read-only and selectively promote the `.text` section to `READ|EXEC`
  on page boundaries.
- **baka SDK.** A header (`baka.h`) and Zig module (`baka.zig`) defining
  the `BakaHeader`, `BakaElfHeader`, `BakaElfSection`, and `BakaElfSymbol`
  layouts, plus an `API` struct exposing host-provided functions (e.g.
  `text_render`) to guest applications.
- **Freestanding guest toolchain.** A linker script (`linker.lds`) places
  the baka header at offset `0x0` and `.text` at `0x40`, producing raw
  position-independent blobs suitable for direct execution.

---

## Repository layout

```
.
├── build.zig              # Top-level build: emits the `tsundere` executable
├── build.zig.zon          # Zig package manifest
├── src/
│   ├── tsundere_runtime.zig   # Entry point: arg parse, mmap, mprotect, run
│   ├── loader/
│   │   ├── loader.zig         # baka header validation + baka_main dispatch
│   │   └── elf_loader.zig     # ELF section / symbol resolution
│   └── os/
│       └── os.zig             # Thin mmap / mprotect platform layer
└── baka_sdk/
    ├── baka.h                 # C API and struct definitions for guests
    ├── baka.zig               # Zig API and struct definitions for guests
    ├── build.zig              # Build for a freestanding baka guest
    ├── linker.lds             # Linker script for baka binaries
    └── example/
        ├── main.c             # Example guest application
        ├── Makefile           # gcc + ld + objcopy build for the example
        └── linker.lds
```

---

## Building

### Prerequisites

- **Zig 0.16.0** or later (the runtime build).
- **gcc / ld / objcopy** (only if you wish to build the C example guest with
  the provided Makefile).

### Runtime

```sh
zig build          # produces zig-out/bin/tsundere
zig build run -- path/to/app.baka
```

### Example guest (C)

```sh
cd baka_sdk/example
make              # produces app.baka from main.c
```

### Example guest (Zig)

```sh
cd baka_sdk
zig build          # produces app.baka
```

---

## Usage

```
tsundere <app.baka>
```

The runtime opens the given path, `mmap`s it privately, aligns the `.text`
section to the page boundary, marks it executable, and jumps to `baka_main`.
A guest application receives a pointer to an `API` struct and may invoke
host-provided callbacks:

```c
void baka_main(const API* api) {
    api->text_render(0, 0, "hello from baka");
}
```

---

## Status

This is a **prototype**. The loader is intentionally naive: it identifies the
`baka_main` symbol, maps the binary, and runs it. Open work tracked in the
source includes:

1. Routing all baka loads (including child baka) through the IO thread, with
   the first baka becoming the process-zero/root.
2. Assembling a baka from multiple smol-baka fragments fetched over the Baka
   Delivery Network, requiring dynamic linking and relocation resolution.
3. A controlled export mechanism so a parent baka can expose `AppBehaviour`
   APIs to child baka without breaching the per-arena sandboxing contract.

---

## Vision

`tsundere-runtime` is the host half of a "baka" application ecosystem. Baka
apps are small, freestanding, self-describing binaries that declare their
memory and version requirements in a header the runtime can cheaply validate.
The long-term goal is a networked runtime where baka binaries are fetched,
assembled, sandboxed, and executed on demand — closer in spirit to a dynamic
linker fused with an HTTP client than to a traditional process loader.

---

## Contributing

To view the development source code and contribute, contact the author at:

```
souls.syntax [at] gmail [dot] com
```

---

## License

Copyright (C) 2026 souls-syntax (Aakarsh).

This program is free software: you can redistribute it and/or modify it
under the terms of the **GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at your
option) any later version**.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

### Additional terms — no AI training consent

The author does **not** consent to the use of this project, its source code,
its binary artifacts, or any derivative work thereof for the training,
fine-tuning, evaluation, distillation, or benchmarking of machine learning
models, large language models, or any other artificial intelligence system,
whether for commercial, academic, or personal purposes. This prohibition
applies regardless of license grants above and survives any redistribution
or modification of the work. If the law of your jurisdiction treats such a
clause as a non-negotiable term, then the license granted herein is void as
to you and you must refrain from all use of the work.