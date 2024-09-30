.global _start
_start:
    li s0, 0
    li s1, 1

loop:
    add s2, s1, s0
    mv s0, s1
    mv s1, s2
    j loop
