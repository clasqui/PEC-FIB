movi r0, 0xbc
movhi r0, 0xa5
movi r1, 0x22
movhi r1, 0x40
movi r2, 3
movi r3, -2
sha r4, r0, r2 ; 2de0
sha r5, r0, r3 ; e96f
shl r6, r1, r2 ; 0110
shl r7, r1, r3 ; 1008
movi r0, 0
st 0(r0), r4
st 2(r0), r5
st 4(r0), r6
st 6(r0), r7
halt
