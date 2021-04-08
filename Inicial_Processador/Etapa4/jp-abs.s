movi r0, 0
movi r1, 1
movi r2, 14
movi r3, 3
shl r3, r3, r2
movi r5, 32 ; @ s2
movi r4, 40 ; @ s1
movi r7, 48 ; @ s4
movi r6, 56 ; @ s3
or r4, r4, r3
or r5, r5, r3
or r6, r6, r3
or r7, r7, r3
movi r2, 64
jz r0, r4 ; Salta a s1
halt

.org 32

s2:
st 2(r2), r1
addi r1, r1, 1
jmp r6 ; Salta a s3
halt

s1: 
st 0(r2), r1
addi r1, r1, 1
jnz r1, r5 ; Salta a s2
halt

s4:
st 6(r2), r1
st 8(r2), r3
st 0(r0), r1
halt
; Fin del programa

s3:
st 4(r2), r1
addi r1, r1, 1
jal r3, r7 ; Salta a s4
halt
