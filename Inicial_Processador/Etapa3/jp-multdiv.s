movi r0, 64
movi r1, 3
movi r2, 4
movi r3, -2
movi r4, -7
mul r5, r1, r2
st 0(r0), r5
mul r5, r1, r3
st 2(r0), r5
mulh r5, r1, r2
st 4(r0), r5
mulh r5, r1, r3
st 6(r0), r5
mulhu r5, r1, r2
st 8(r0), r5
mulhu r5, r1, r3
st 10(r0), r5
div r5, r2, r1
st 12(r0), r5
div r5, r0, r3
st 14(r0), r5
divu r5, r4, r2
st 16(r0), r5
divu r5, r0, r3
st 18(r0), r5
halt
