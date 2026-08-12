# Makefile: builds the example baka guest from main.c via gcc + ld + objcopy.
# Copyright (C) 2026  Aakarsh Kashyap
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

CC      := gcc
LD      := ld
OBJCOPY := objcopy

CFLAGS  := -ffreestanding -fPIC -Wall -Wextra -O2
LDFLAGS := -T linker.lds

SRC     := main.c
OBJ     := main.o
ELF     := app.elf
TARGET  := app.baka

all: $(TARGET)

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(TARGET): $(ELF)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f $(OBJ) $(ELF) $(TARGET)

.PHONY: all clean
