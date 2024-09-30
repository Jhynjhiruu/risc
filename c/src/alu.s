    li s0, 50
    sltiu s2, s0, 49
    sltiu s2, s0, 51
    sltiu s2, s0, 50
    sltiu s2, s0, -10
    slti s2, s0, -10
    
    li s1, -10
    mv s2, s1
    slli s2, s1, 1
    srli s2, s1, 1
    srai s2, s1, 1
    j .
