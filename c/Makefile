TARGET := test

BUILD_DIR := build
SRC_DIR := src

default: $(TARGET).img

.PHONY: default print_files clean

DEBUG := 0

ifeq ($(DEBUG),0)
	OPTFLAGS := -O3
	DEBUGFLAGS :=
else
	OPTFLAGS := -Og
	DEBUGFLAGS := -g
endif

PREFIX := riscv64-unknown-elf-

AS := $(PREFIX)as
CC := $(PREFIX)gcc
LD := $(PREFIX)ld
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump

RV32I_FLAGS := -march=rv32i -mabi=ilp32
AS_FLAGS := $(RV32I_FLAGS) $(DEBUGFLAGS)
C_FLAGS := $(RV32I_FLAGS) $(OPTFLAGS) $(DEBUGFLAGS)

PYTHON := py

ROM2IMAGE := $(PYTHON) ../rom2image.py

LINKER_SCRIPT := linker.ld

$(shell mkdir -p $(BUILD_DIR))

SRC_FILES := test.s

S_FILES := 	$(filter %.s,$(SRC_FILES))
C_FILES := 	$(filter %.c,$(SRC_FILES))

ifneq ($(C_FILES),)
	S_FILES += crt0.s
endif

O_FILES := 	$(foreach file,$(S_FILES),$(BUILD_DIR)/$(file:.s=.s.o)) \
			$(foreach file,$(C_FILES),$(BUILD_DIR)/$(file:.c=.c.o))

$(TARGET).img: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $(BUILD_DIR)/$(TARGET).bin
	$(ROM2IMAGE) $(BUILD_DIR)/$(TARGET).bin $@

$(BUILD_DIR)/$(TARGET).elf: $(LINKER_SCRIPT) $(O_FILES)
	$(LD) -o $@ $(filter %.o,$^) -T $(LINKER_SCRIPT)

$(BUILD_DIR)/%.s.o: $(SRC_DIR)/%.s
	$(AS) -o $@ -c $< $(AS_FLAGS)

$(BUILD_DIR)/%.c.o: $(SRC_DIR)/%.c
	$(CC) -o $@ -c $< $(C_FLAGS)

print_files:
	@echo $(O_FILES)

clean:
	$(RM) $(TARGET) $(TARGET).img
	$(RM) -r $(BUILD_DIR)
