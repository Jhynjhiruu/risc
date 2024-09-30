    la x1, after
    lw s2, %lo(word)(x0)
    sw s2, 0(x1)
    mv s2, zero
    lhu s2, %lo(half)(x0)
    sh s2, 4(x1)
    mv s2, zero
    lbu s2, %lo(byte)(x0)
    sb s2, 6(x1)
    j .
    
word:
    .word 0x01234567
half:
    .half 0x0123
    .half 0xBAAD
byte:
    .byte 0x01
    .byte 0xFF
    .byte 0xFF
    .byte 0xFF
after:
