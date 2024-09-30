.global _start
_start:
    # setup stack
    la sp, __stack_end
    
    # clear bss
    la t0, __bss_start
    la t1, __bss_end
    beq t0, t1, 2f
    
1:
    sw zero, 0(t0)
    addi t0, t0, 4
    bne t0, t1, 1b

2:
    # argc = 0
    mv a0, zero
    # argv = NULL
    mv a1, zero
    # envp = NULL
    mv a2, zero
    
    call main
    
    # display return code
    mv s2, a0
    j .
