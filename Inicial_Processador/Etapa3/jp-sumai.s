movi r0, 0
movi r1, -1
addi r1, r1, -1
st 0(r0), r1 ; -2
addi r2, r1, -2
st 2(r0), r2 ; -4
addi r3, r1, 1
st 4(r0), r3 ; -1
addi r4, r1, 3
st 6(r0), r4 ; 1
addi r1, r1, 0
st 8(r0), r1 ; -2
addi r5, r1, 0
st 10(r0), r5 ; -2
halt
