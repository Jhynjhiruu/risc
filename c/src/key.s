TTY = 0x80000000
KEY = 0xC0000000

TTY_WRITE = 0

KEY_NEXTC = 0
KEY_EMPTY = 0
KEY_READC = 1

.global _start
_start:
    la sp, __stack_end
    la s0, TTY
    la s1, KEY
    
loop:
    lbu t0, KEY_EMPTY(s1)
    beqz t0, loop
    
    lbu a0, KEY_READC(s1)
    jal print_char
    sb zero, KEY_NEXTC(s1)
    j loop

print_char:
    sw a0, TTY_WRITE(s0)
    ret
