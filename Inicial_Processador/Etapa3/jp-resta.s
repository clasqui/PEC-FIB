movi r0, 0
movi r1, 1
movi r2, 2
sub r3, r1, r2
st 0(r0), r3 ; 0xffff
movi r1, 0xff
movi r2, 0xff
sub r3, r1, r2
st 2(r0), r3 ; 0
movi r2, 0xfe
sub r3, r1, r2
st 4(r0), r3 ; 1
movi r1, 0
movhi r1, 0x80
movi r2, 1
sub r3, r1, r2 ; 0x7fff
st 6(r0), r3
halt
