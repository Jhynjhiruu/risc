.global _start
_start:
    la sp, __stack_end
    la s0, 0x80000000
    la a0, string
    jal print_string
    j .
    
print_string:
    addi sp, sp, -4
    sw ra, 0(sp)
    mv t0, a0
    
1:
    lbu a0, 0(t0)
    beqz a0, 1f
    jal print_char
    addi t0, t0, 1
    j 1b
    
1:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

print_char:
    sw a0, 0(s0)
    ret

string:
    .ascii "Hello, World!\n"
