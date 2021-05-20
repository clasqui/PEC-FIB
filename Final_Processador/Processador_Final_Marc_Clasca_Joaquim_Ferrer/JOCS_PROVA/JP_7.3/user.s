.include "macros.s"

.set PILA_USUARI, 0x1000

.global main
.global PILA_USUARI

.text

main: ; punt d'entrada d'usuari
    
    ; fem crida a sistema
    movi r1, 5
    calls r1

    ; intenem accedir a una posicio de memoria protegida
    movi r1, 0
    movhi r1, 0x80
    ld r2, (r1)
    
    ; intentem cridar instruccio ilegal
    di

    ; fem un bucle infinit per esperar interrupcions
__bucle:
    $movei r1, 0xF000
    movi r0, 0
    addi r0, r0, 1
    cmpleu r2, r0, r1
    bnz r1, __bucle 

    halt
