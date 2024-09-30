all: img

TARGET := rstest

IMG := $(TARGET).img

DEBUG := 0

ifeq ($(DEBUG),0)
	MODE_STR := release
	MODE_FLAG := --release
else
	MODE_STR := debug
	MODE_FLAG := 
endif

OBJCOPY := llvm-objcopy
CARGO := cargo
CARGOFLAGS := 

CWD := $(shell pwd)
TARGET_DIR := $(CWD)/target
BUILD_DIR := $(TARGET_DIR)/riscv32i-unknown-none-elf/$(MODE_STR)
RUST_OBJ := $(BUILD_DIR)/$(TARGET)

PYTHON := py

ROM2IMAGE := $(PYTHON) ../rom2image.py

%.img: $(TARGET_DIR)/%.bin
	$(ROM2IMAGE) $< $@

$(TARGET_DIR)/%.bin: $(RUST_OBJ)
	$(OBJCOPY) -O binary $< $@

$(RUST_OBJ): linker.ld Cargo.toml build.rs src/main.rs
	$(CARGO) build $(MODE_FLAG) $(CARGOFLAGS)

img: $(IMG)

clean:
	$(CARGO) clean
	$(RM) -f $(IMG)

.PHONY: img all clean

.DEFAULT: all

-include $(RUST_OBJ).d
