.include "macros.s"

.set PILA_USUARI, 0x1000

.global main
.global PILA_USUARI

.text

main: ; punt d'entrada d'usuari
    
    ; La primera pagina de codi de usuari no esta
    ; carregada a la TLB, per tant el fetch d'aquesta 
    ; primera instruccio fallarà i anem a miss TLBi
    movi r0, 15 
    $pst r7, r0 ; provem un acces a memoria que SI que esta a TLB

    ; Ara fem acces a dades d'usuari fora d'aquesta pagina
    ; per exemple, provem d'escriure 1 byte  la posicio 
    ; 0x3003 (pg 3). Això fara saltar excepcio miss TLBd
    movi r3, 0
    movhi r3, 0x30
    movi r4, 0xAA
    stb 3(r3), r4

    ; intenem accedir a una posicio de memoria protegida
    movi r1, 0
    movhi r1, 0x80
    ld r2, (r1)
    addi r4, r0, 4

    ; Intentem escriure a pagina d'usuari pero readonly
    movi r1, 1
    $movei r2, 0x2004
    st (r2), r1 ; intentem escriure un 1 a la posicio 2004, no s'hauria descriure
    addi r4, r4, 4
    
    ; Ara provarem de fer flush de la TLB de dades
    ; per fer-ho, fem una crida a sistema
    ; ja que la instruccio flush es privilegiada
    calls r1 
    ; ara fem un acces que hauria de donar fallada de pagina de dades
    ; concretament a la pila de usuari (addr 0x1000)
    movi r1, 0xAA
    $pst r7, r1
    

    ; Finalment, intentem executar codi de sistema (protegit)
    ; quan es produeixi el jmp, en el seguent cicle de fetch
    ; saltara excepcio de proteccio TLB instruccions
    ; En aquesta excepcio es pararà l'execució del processador perquè
    ; considerem que no es pot recuperar
    $movei r1, 0xC000  
    jmp r1
    ; El joc de proves acaba aquí, no hauria d'executar més enllà

    halt
