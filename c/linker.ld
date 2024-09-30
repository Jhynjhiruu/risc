OUTPUT_FORMAT ("elf32-littleriscv")
OUTPUT_ARCH (riscv:rv32)

ENTRY(_start)

MEMORY {
    RAM : ORIGIN = 0x00000000, LENGTH = 0x04000000
}

SECTIONS {
    __romPos = 0;
    
    crt0_ROM_START = __romPos;
    .crt0 ORIGIN(RAM) : AT(crt0_ROM_START) {
        __crt0_start = .;
        KEEP(*(.crt0*));
        . = ALIGN(16);
        __crt0_end = .;
    } > RAM
    __romPos += SIZEOF(.crt0);
    __romPos = ALIGN(__romPos, 16);
    crt0_ROM_END = __romPos;

    text_ROM_START = __romPos;
    .text ALIGN(16) : AT(text_ROM_START) {
        __text_start = .;
        *(.text*);
        . = ALIGN(16);
        __text_end = .;
    } > RAM
    __romPos += SIZEOF(.text);
    __romPos = ALIGN(__romPos, 16);
    text_ROM_END = __romPos;

    data_ROM_START = __romPos;
    .data ALIGN(16) : AT(data_ROM_START) {
        __data_start = .;
        *(.data*);
        . = ALIGN(16);
        __data_end = .;
    } > RAM
    __romPos += SIZEOF(.data);
    __romPos = ALIGN(__romPos, 16);
    data_ROM_END = __romPos;

    rodata_ROM_START = __romPos;
    .rodata ALIGN(16) : AT(rodata_ROM_START) SUBALIGN(16) {
        __rodata_start = .;
        *(.rodata*);
        . = ALIGN(16);
        __rodata_end = .;
    } > RAM
    __romPos += SIZEOF(.rodata);
    __romPos = ALIGN(__romPos, 16);
    rodata_ROM_END = __romPos;

    . = ALIGN(16);
    .bss (NOLOAD) : {
        __bss_start = .;
        *(.bss)
        *(.bss*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(16);
         __bss_end = .;
    } > RAM

    __heap_start = __bss_end;
    __heap_len = (ORIGIN(RAM) + LENGTH(RAM)) - __bss_end - SIZEOF(.stack);

    .stack __heap_start + __heap_len (NOLOAD) : {
        __stack_start = .;
        KEEP(*(.stack));
        KEEP(*(.stack*));
        . = ALIGN(16);
        __stack_end = .;
    } > RAM

    /DISCARD/ : {
        *(.MIPS.*)
        *(.comment)
        *(.mdebug.*)
        *(.pdr)
        *(.reginfo)
        *(.eh_frame)

        /*
         * We may need the global offset table some day.
         * Our target is currently set with a static relocation-model, so this
         * might not be needed after all.
         */
        *(.got)
    }
}
