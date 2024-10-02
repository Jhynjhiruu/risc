TTY = 0x80000000
KEY = 0xC0000000

TTY_WRITE = 0

KEY_NEXTC = 0
KEY_HAS_C = 0
KEY_READC = 1

# void print_char(char c);
print_char:
    sw a0, TTY_WRITE(s10)
    ret

# void print_str(char const * s);
print_str:
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

# void print_u4(uint8_t x);
print_u4:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    andi a0, a0, 0x0F
    li t0, 10
    bge a0, t0, 1f
    
    add a0, a0, 0x30
    j 2f
    
1:
    add a0, a0, 'A' - 10
2:
    jal print_char
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# void print_u8(uint8_t x);
print_u8:
    addi sp, sp, -8
    sw ra, 4(sp)
    
    sw a0, 0(sp)
    srli a0, a0, 4
    jal print_u4
    
    lw a0, 0(sp)
    jal print_u4
    
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

# void print_u16(uint16_t x);
print_u16:
    addi sp, sp, -8
    sw ra, 4(sp)
    
    sw a0, 0(sp)
    srli a0, a0, 8
    jal print_u8
    
    lw a0, 0(sp)
    jal print_u8
    
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

# void print_u32(uint32_t x);
print_u32:
    addi sp, sp, -8
    sw ra, 4(sp)
    
    sw a0, 0(sp)
    srli a0, a0, 16
    jal print_u16
    
    lw a0, 0(sp)
    jal print_u16
    
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

# bool get_ready(void);
get_ready:
    lw a0, KEY_HAS_C(s11)
    ret

# char get_char
get_char:
    addi sp, sp, -4
    sw ra, 0(sp)
    
1:
    jal get_ready
    beqz a0, 1b
    
    lw a0, KEY_READC(s11)
    sw zero, KEY_NEXTC(s11)
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# ---------------------------------

BS  = 0x08
CR  = 0x0A
ESC = 0x0C

WIDTH   = 32

XAM     = 0
STOR    = 1
BLOKXAM = 2

.global main
main:
    addi sp, sp, -4
    sw ra, 0(sp)

    la s11, KEY
    la s10, TTY
    
    la s7, in
    
drawprompt:
    li a0, '\\'
    jal print_char
    
nextline:
    li a0, '\n'
    jal print_char
    
    # length in buffer
    li s9, 0
    
nextchar:
    jal get_char
    
    li t0, BS
    beq a0, t0, backspace
    
    li t0, ESC
    beq a0, t0, escape
    
    add t0, s7, s9
    sb a0, 0(t0)
    addi s9, s9, 1
    
    li t0, CR
    beq a0, t0, cr
    
    jal print_char
    slti t0, s9, WIDTH
    beqz t0, escape
    j nextchar

backspace:
    addi s9, s9, -1
    bltz s9, 1f
    jal print_char
    j nextchar
1:
    addi s9, s9, 1
    j nextchar

escape:
    li a0, '\n'
    jal print_char
    j drawprompt

cr:
    # mode
    li s0, XAM
   
    # cur
    li s1, 0
 
    # index into buffer
    li s8, 0
    
parseloop:
    beq s8, s9, escape
    
    li s6, 0

    add t0, s7, s8
    lbu t1, 0(t0)
    
    li t0, '.'
    blt t1, t0, parsenext
    
    beq t1, t0, examine
    
    li t0, ':'
    beq t1, t0, store
    
    li t0, 'R'
    beq t1, t0, run
    
nexthex:
    xori t2, t1, 0x30
    li t0, 10
    blt t2, t0, digit
    
    andi t2, t1, ~0x20
    li t0, 'A'
    blt t2, t0, nothex
    li t0, 'F'
    bgt t2, t0, nothex
    addi t2, t2, -('A' - 10)
    
digit:
    li s6, 1

    slli s1, s1, 4
    or s1, s1, t2
    addi s8, s8, 1
    
    add t0, s7, s8
    lbu t1, 0(t0)
    j nexthex

parsenext:
    addi s8, s8, 1
    j parseloop

nothex:
    beqz s6, escape
    beqz s8, escape
    
    li t0, STOR
    beq s0, t0, stor
    
    li t0, BLOKXAM
    beq s0, t0, blokxam
    
    mv s2, s1
    mv s3, s1
    
    j print_addr
    
stor:
    sb s1, 0(s2)
    addi s2, s2, 1
    j parseloop
    
print_addr:
    li a0, '\n'
    jal print_char
    
    mv a0, s3
    jal print_u32
    
    li a0, ':'
    jal print_char

print_data:
    li a0, ' '
    jal print_char
    
    lbu a0, 0(s3)
    jal print_u8
    
blokxam:
    li s0, XAM
    
    bge s3, s1, parseloop
    
    addi s3, s3, 1
    
    andi t0, s3, 0x03
    beqz t0, print_addr
    j print_data
    

examine:
    li s0, BLOKXAM
    j parsenext

store:
    li s0, STOR
    j parsenext

run:
    beqz s8, escape
    
    jalr s2
    
    
    li a0, 0
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

.section .data

in:     .ds 0x80
