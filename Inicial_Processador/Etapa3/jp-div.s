movi r0, 0
movi r1, 1
movi r2, 2
div r3, r2, r1 ; 0002
divu r4, r2, r1 ; 0002
st 0(r0), r3
st 2(r0), r4
movi r2, 0xff
movhi r2, 0x7f
div r3, r1, r2 ; 0000
divu r4, r1, r2 ; 0000
st 4(r0), r3
st 6(r0), r4
movhi r2, 0xff
div r3, r1, r2 ; ffff
divu r4, r1, r2 ; 0000
st 8(r0), r3
st 10(r0), r4
movi r1, 0xff
div r3, r1, r2 ; 0001
divu r4, r1, r2 ; 0001
st 12(r0), r3
st 14(r0), r4
movi r1, 0
movhi r1, 0x80
div r3, r1, r2 ; 0000
divu r4, r1, r2 ; 0000
st 16(r0), r3
st 18(r0), r4
halt
