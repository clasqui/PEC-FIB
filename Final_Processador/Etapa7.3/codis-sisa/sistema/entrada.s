.include "macros.s"

.set PILA_SISTEMA, 0x9000
; entry.s de zeos para SISA por Zeus Gómez Marmolejo

.data

    codi_crida: .word 0 ; codi de la crida a sistema que sha fet
    flag_dades: .word 0 ; senyalem quan excepcio dades protegides
    flag_inst:  .word 0 ; senyalem quan excepcio instruccio protegida
    flag_int:   .word 0 ; senyalem quan interrupcio

    .balign 2
    interrupts_vector:
        .word RSI_default_resume ; timer
        .word RSI_default_resume ; pulsadors
        .word RSI_default_resume ; switches
        .word RSI_default_resume ; Teclat

    exceptions_vector:
        .word RSE_default_halt   ; Inst ilegal
        .word RSE_default_halt   ; acces no alineat
        .word RSE_default_resume ; 2 overflow FP
        .word RSE_default_resume ; divisio 0 FP
        .word RSE_default_halt   ; divisio 0
        .word RSE_default_halt   ;  no definit
        .word RSE_excepcio_TLB   ; miss TLB instruccions
        .word RSE_excepcio_TLB   ; miss TLB dades
        .word RSE_excepcio_TLB   ; pag invalid TLB inst
        .word RSE_excepcio_TLB   ; pag invalid TLB dades
        .word RSE_default_halt   ; pag protegida TLB inst
        .word RSE_mem_protegida  ; 11 pag protegida TLB dades
        .word RSE_default_halt   ; pag readonly
        .word RSE_inst_protegida ; 13 Excepcio instruccio protegida

    call_sys_vector:
        .word syscall_default
        .word syscall_default
        .word syscall_default
        .word syscall_default
        .word syscall_default
        .word syscall_default
        .word syscall_default
        .word syscall_default


.text

; ---------------
; Inicialitzacio
; ---------------

 di ; inicialitzacio amb les interrupcions desactivades

 ;movi  r7, 0x00 ; Pila de sist: decreix en
 ;movhi r7, 0x82 ;  RAM: 0x81fe, 0x81fc, ...
$movei r7, PILA_SISTEMA
 wrs   s6, r7   ; a s6: la pila de sistema

 $movei r6, RSG
 wrs s5, r6  ; Direccio de la RSG

 ; El retorn de la rutina principal
 movi  r5, lo( __exit )
 movhi r5, hi( __exit )

 ; Start main rutine (USER SPACE)
 movi  r6, lo( main )
 movhi r6, hi( main )
 wrs s1, r6

 ; Posem paraula d'estat futura (amb mode usuari)
 movi r6, 0x02 ; mode usuari, interrupcions activades, overflow fp ens es igual
 wrs s0, r6
 
 ; posem l'adreça de la pila dusuari a r3
 $movei r3, PILA_USUARI

 reti ; Simulem una crida a sistema i retornem a codi d'usuari

; --------
; Rutines gestio
; --------


RSI_default_resume:
    $movei r2, flag_int
    movi   r1, 1
    st     (r2), r1
    jmp r6

RSE_default_resume:
    jmp r6

RSE_default_halt:
    halt

RSE_excepcio_TLB:
    halt

syscall_default:
    ; Aqui podem fer coses per comprovar que les crides a sistema funcionen be.
    ; Per exemple escriure a posicions de memoria del sistema.
    $movei r1, codi_crida
    st (r1), r4 ; guardem el codi de la crida
    jmp r6
    
RSE_mem_protegida: ; posem el flag per comprovar
    $movei r1, flag_dades
    movi   r2, 1
    st     (r1), r2
    jmp    r6

RSE_inst_protegida:
    $movei r1, flag_inst
    movi   r2, 1
    st     (r1), r2
    jmp    r6
 
__exit:
 ; Parem la CPU
 halt


RSG:
    rds r7, s6
    ;salvem nomes r2, r3 i r6 per utilitzarlos de forma segura
    st (r7), r2
    addi r7, r7, -2
    st (r7), r3
    addi r7, r7, -2
    st (r7), r6
    addi r7, r7, -2


    ; Comencem rutina segons tipus 
    rds r1, s2
    movi r2, 14
    cmpeq r3, r2, r1 ; comprovem si es syscall
    bnz r3, __call_sistema
    movi r2, 15
    cmpeq r3, r2, r1
    bnz r3, __interrupcion
__excepcion:
    $movei r2, exceptions_vector
    add r1, r1, r1 ; utilitzarem el num dexcepcio com a index, per tant multipliquem per2
    add r2, r2, r1
    ld r2, (r2)
    jal r6, r2 ; saltem a la gestio de la excepcio corresponent
    bz  r3, __finrsg 
__call_sistema:
    rds r1, s3
    rds r4, s3
    movi r2, 7
    and r1, r1, r2 ; mascara 3 bits (8 elements)
    add r1, r1, r1 ; num com a index, mult per 2
    $movei r2, call_sys_vector
    add r2, r2, r1
    ld r2, (r2)
    jal r6, r2
    bnz r3, __finrsg
__interrupcion:
    getiid r1
    add r1, r1, r1
    $movei r2, interrupts_vector
    add r2, r2, r1
    ld r2, (r2)
    jal r6, r2

__finrsg:
    ; Restaurem els 3 registres abans de tornar
    $ppt r7, r6
    $ppt r7, r3
    $ppt r7, r2
    wrs s6, r7
    reti
