.org 0
.global _start
.set SYSEXIT, 93
.set SYSWRITE, 64

.data
num1: .word 0xf1ac,0x123
num2: .word 0x1ac,0x12123489
num3: .word 0x0,0x32498
and_mask: .word 0x55555555, 0x33333333, 0x0f0f0f0f, 0x7f

.text
_start:
    li s7, 4 
    la a0, num1
    jal ra, counting_zero
    jal ra, print_result

    li s7, 8
    la a0, num2
    jal ra, counting_zero
    jal ra, print_result    
    
    li s7, 12
    la a0, num3
    jal ra, counting_zero
    jal ra, print_result    
    j exit_program

print_result:
    sw t0, 0(s7)
    ret

exit_program:
    li a7, SYSEXIT
    ecall

counting_zero:
    lw s0, 0(a0)
    lw s1, 4(a0)
    mv t6, x0     # this is res return value
    
    bnez s0, start_count
    addi t6, t6, 32
    mv s0, s1
    
start_count:
    la t1, and_mask
    lw t2, 0(t1)
    lw t3, 4(t1)
    lw t4, 8(t1)
    lw t5, 12(t1)

    # count leading zero in s0
    srli s1, s0, 1
    or s0, s0, s1
    srli s1, s0, 2
    or s0, s0, s1
    srli s1, s0, 4
    or s0, s0, s1
    srli s1, s0, 8
    or s0, s0, s1
    srli s1, s0, 16
    or s0, s0, s1

    srli s1, s0, 1
    and s1, s1, t2
    sub s0, s0, s1

    srli s1, s0, 2
    and s1, s1, t3
    and s2, s0, t3
    add s0, s1, s2

    srli s1, s0, 4
    add s1, s1, s0
    and s0, s1, t4

    srli s1, s0, 8
    add s0, s0, s1

    srli s1, s0, 16
    add s0, s0, s1

    and s0, s0, t5
    addi t6, t6, 32
    sub t0, t6, s0
    ret
