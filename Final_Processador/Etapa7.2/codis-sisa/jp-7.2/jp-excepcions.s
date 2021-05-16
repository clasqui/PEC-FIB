.macro $movei p1 imm16
    movi  \p1, lo(\imm16)
    movhi \p1, hi(\imm16)
.endm


.data

    codi_ilegal: .word 0
    codi_unaligned: .word 0
    codi_divzero: .word 0

    addr_unaligned: .word 0

    resultat_final: .word 0

.text
; Inicialitzacio
    $movei r1, RSG
    wrs    s5, r1

inici: 
; Divisio per 0
    $movei r0, 0x0000
    add r4, r0, r0
    movi r2, 0x04
    div r1, r2, r0 ; no shauria de produir
    addi r4, r4, 1

; Acces mal alineat load
    addi r2, r2, 1
    ld r1, (r2) ; no shauria de produir
    addi r4, r4, 1

; Acces mal alineat PC
    movi  r2, lo(inici)
    movhi r2, hi(inici)
    addi  r2, r2, 1
    jmp r2 ; no hauria de saltar
    addi r4, r4, 1

; Instruccio ilegal
    add r0, r0, r0 ; es codifica com tot 0, cal subsituirla un cop compilat per algo que no tingui sentit 
    addi r4, r4, 1
    $movei r2, resultat_final
    st 0(r2), r4
    halt


RSG:
    rds r7, s2    ; obtenim codi excpecio
    movi r6, 0    ; excepcio ilegal instr
    cmpeq r2, r7, r6 
    bz r2, __div_zero
    $movei r2, codi_ilegal
    st 0(r2), r7 ; Aixo hauria de guardar el codi de excpecio a memoria
__div_zero:
    movi r6, 4    ; excepcio ilegal instr
    cmpeq r2, r7, r6
    bz r2, __unaligned
    $movei r2, codi_divzero
    st 0(r2), r7
__unaligned:
    movi r6, 1
    cmpeq r2, r7, r6
    bz r2, __final_rsg
    $movei r2, codi_unaligned ; Aixo hauria de guardar el codi de excepcio a memoria
    st 0(r2), r7
    rds r3, s3 ; pillem ladreça efectiva desalineada del registre de sistema
    $movei r2, addr_unaligned
    st 0(r2), r3 ; Aixo hauria de guardar la direccio efectiva a memoria 
__final_rsg:
    reti

