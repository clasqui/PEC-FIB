movi r0, 0
movi r1, 1
movi r2, 2
add r3, r1, r2
st 0(r0), r3 ; 3
movi r2, 0xff
movhi r2, 0x7f
add r3, r2, r1
st 2(r0), r3 ; 0x8000
movhi r2, 0xff
add r3, r1, r2
st 4(r0), r3 ; 0
movi r1, 0xff
add r3, r1, r2
st 6(r0), r3 ; 0xfffe
movi r1, 0
movhi r1, 0x80
add r3, r1, r2
st 8(r0), r3 ; 0x7fff
halt
