movi r0, 0
movi r1, 2
movi r2, 2
movi r3, 3
movi r4, -1


; cmplt


cmplt r5, r2, r3 ; 1
st 0(r0), r5


cmplt r5, r4, r2 ; 1
st 2(r0), r5


cmplt r5, r1, r2 ; 0
st 4(r0), r5


cmplt r5, r3, r0 ; 0
st 6(r0), r5


; cmple


cmple r5, r2, r3 ; 1
st 8(r0), r5


cmple r5, r4, r2 ; 1
st 10(r0), r5

cmple r5, r1, r2 ; 1
st 12(r0), r5

cmple r5, r3, r0 ; 0
st 14(r0), r5

; cmpeq


cmpeq r5, r2, r3 ; 0
st 16(r0), r5

cmpeq r5, r4, r2 ; 0
st 18(r0), r5

cmpeq r5, r1, r2 ; 1
st 20(r0), r5

cmpeq r5, r3, r0 ; 0
st 22(r0), r5

; cmpltu


cmpltu r5, r2, r3
; 1
st 24(r0), r5

cmpltu r5, r4, r2
; 0
st 26(r0), r5

cmpltu r5, r1, r2
; 0
st 28(r0), r5

cmpltu r5, r3, r0
; 0
st 30(r0), r5

; cmpleu


cmpleu r5, r2, r3
; 1
st 32(r0), r5

cmpleu r5, r4, r2
; 0
st 34(r0), r5

cmpleu r5, r1, r2
; 1
st 36(r0), r5

cmpleu r5, r3, r0
; 0
st 38(r0), r5

halt
