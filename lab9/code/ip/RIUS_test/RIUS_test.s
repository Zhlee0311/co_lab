main:
    addi x31,x0,16
    lw   x26,0(x31)
    lw   x27,4(x31)
    sw   x27,0(x31)
    sw   x26,4(x31)    
    lw   x26,0(x31)
    lw   x27,4(x31)
    add  x28,x26,x27
    sw   x28,16(x0)
    lw   x29,16(x0)
    addi x1,x0,-0x78A
    addi x2,x0,4
    add  x3,x1,x2
    sub  x4,x1,x2
    sll  x5,x1,x2
    srl  x6,x1,x2
    sra  x7,x1,x2
    slt  x8,x1,x2
    sltu x9,x1,x2
    and  x10,x5,x6
    or   x11,x5,x6
    xor  x12,x5,x6
    lui  x13,0x80000
    addi x14,x13,-1
    addi x15,x14,0x123
    slli x16,x15,3
    srli x17,x15,3
    srai x18,x15,3
    slti x19,x18,-1
    sltiu x20,x18,-1
    slti x21,x18,1
    sltiu x22,x18,1
    andi x23,x12,0xFF
    ori  x23,x12,0xFF
    lui  x24,0x00010
    addi x24,x24,-1
    xori x25,x24,-1
 
 