movi r0, 0
movi r1, 1
movi r2, 2
bz r1, a
st 0(r0), r1
a: st 2(r0), r2 
bz r0, b
st 4(r0), r1
b: bnz  r1, c
st 6(r0), r2
c: bnz  r0, d
st 8(r0), r1
d: halt
