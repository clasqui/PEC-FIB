movi r0, 0
movi r1, 0x7d
movhi r1, 0x33
movi r2, 0x68
movhi r2, 0x43
and r3, r1, r2
st 0(r0), r3 ; 0x0368
or r4, r1, r2
st 2(r0), r4 ; 0x737d
not r5, r2
st 4(r0), r5 ; 0xbc97
xor r6, r1, r2
st 6(r0), r6 ; 0x7015
halt
