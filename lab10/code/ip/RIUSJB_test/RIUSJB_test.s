main:
    addi  a0,  zero,  0x10
    ori   a1,  zero,  3
    xori  a2,  zero,  0x30
    jal   BankSum
    lw    s0,  0(a2)
    add   zero,zero,  zero
    add   zero,zero,  zero

BankSum:
    add   t0,  a0,    zero
    or    t1,  a1,    zero
    and   t2,  zero,  zero
L:  lw    t3,  0(t0)
    add   t2,  t2,    t3
    addi  t0,  t0,    4
    addi  t1,  t1,    -1
    beq   t1,  zero,  exit
    j     L
exit: sw  t2,  0(a2)
      jr  ra  