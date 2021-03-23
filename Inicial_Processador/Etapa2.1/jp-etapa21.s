.data

valor: .space 1

.text

movi r0, lo(valor)
movhi r0, hi(valor)

movi r1, 0xCD
movhi r1, 0xAB

st 0(r0), r1

ldb r2, 0(r0)
ldb r3, 1(r0)

stb 3(r0), r2
stb 2(r0), r3

ld r7, 2(r0)

.end
