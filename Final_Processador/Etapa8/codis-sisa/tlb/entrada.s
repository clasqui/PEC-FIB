.include "macros.s"

.set PILA_SISTEMA, 0x8E00
; entry.s de zeos para SISA por Zeus Gómez Marmolejo

.data

    codi_crida: .word 0 ; codi de la crida a sistema que sha fet
    flag_dades_pro: .word 0 ; senyalem quan excepcio TLBd pag protegida
    flag_inst_pro:  .word 0 ; senyalem quan excepcio TLBi pag protegida
    flag_readonly:  .word   ; senyalem quan s'intenta escriure una pagina RO
    flag_inst_ill:  .word 0 ; senyalem quan excepcio instruccio protegida
    flag_int:   .word 0 ; senyalem quan interrupcio

    tlbd_index_count : .word 0
    tlbi_index_count : .word 0
    
    .balign 2
    interrupts_vector:
        .word RSI_default_resume ; timer
        .word RSI_default_resume ; pulsadors
        .word RSI_default_resume ; switches
        .word RSI_default_resume ; Teclat

    exceptions_vector:
        .word RSE_default_halt   ; 0  Inst ilegal
        .word RSE_default_halt   ; 1  acces no alineat
        .word RSE_default_resume ; 2  overflow FP
        .word RSE_default_resume ; 3  divisio 0 FP
        .word RSE_default_halt   ; 4  divisio 0
        .word RSE_default_halt   ; 5  no definit
        .word RSE_TLB_miss_i     ; 6  miss TLB instruccions
        .word RSE_TLB_miss_d     ; 7  miss TLB dades
        .word RSE_TLB_miss_i     ; 8  pag invalid TLB inst
        .word RSE_TLB_miss_d     ; 9  pag invalid TLB dades
        .word RSE_TLB_pro_i      ; 10 pag protegida TLB inst
        .word RSE_TLB_pro_d      ; 11 pag protegida TLB dades
        .word RSE_TLB_readonly   ; 12 pag readonly
        .word RSE_inst_protegida ; 13 Excepcio instruccio protegida

    call_sys_vector:
        .word syscall_default
        .word syscall_flush   ; 1 Flush TLB
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

; --------------------------------
;       CONFIGURACIÓ TLB
; processador inicialitzat amb 
; la seguent taula de pagines a 
; les dues TLB:
; 
;    0: 0 -> 0 ; usuari dades
;    1: 1 -> 1 ; usuari dades
;    2: 2 -> 2 ; usuari dades
;    3: 8 -> 8 ; sistema dades
;    4: C -> C ; sistema codi
;    5: D -> D ; sistema codi
;    6: E -> E ; sistema codi
;    7: F -> F ; sistema codi
;
; Cal inicialitzar les pagines de
; la VGA per escriure a pantalla
; i les pagines de codi d'usuari
; que vulguem utilitzar. Tambe 
; posem una pagina de dades a RO
; per provar la excepcio.
; 
; Les pàgines de sistema les deixarem
; per que ja ens van bé així.
; --------------------------------

 di ; inicialitzacio amb les interrupcions desactivades


 ; Inicialitzem pantalla
 movi r1, 0x0A ; primera pagina de VGA
 movi r2, 0x04 ; la posem a la posicio 4 dels tags virtuals del TLBd (inicialitzada amb codi sistema, no ens serveix per res)
 wrvd r2, r1   ; escrivim tag virtual
 movi r1, 0x2A ; el mateix que abans pero amb el bit de valid
 wrpd r2, r1   ; escrivim la mateixa posicio tags fisics
 movi r1, 0x0B ; segona pagina de VGA
 addi r2, r2, 1; la posem a la seguent posicio
 wrvd r2, r1
 movi r1, 0x2B
 wrpd r2, r1

 ; Posem comptador index de reemplazo de TLBd a 6 (seguent)
 $movei r1, tlbd_index_count 
 movi   r2, 6
 st     (r1), r2

 ; Posem la traduccio de la pagina 2 (0x2000) al TLBd a readonly per provar excepcio
 ; que, curiosament, el procesador ens la inicialitza a la posicio 2 :)
 ; per tant sobreescrivim
 movi r2, 2 
 wrvd r2, r2
 movi r1, 0x32 ; per la tag fisica, el mateix pero amb bit Read Only i valid
 wrpd r2, r1

 ; La pila de sistema la tenim a 8E00 i va cap avall, per tant ja ens entra a 

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
 ; El codi d'usuari (main) esta a 4000, no esta a TLB per tant quan entrem en
 ; mode usuari amb el reti saltara un miss de TLB instruccions
 ; i haurem de portar la pagina 4 al TLBi

 ; Posem paraula d'estat futura (amb mode usuari)
 movi r6, 0x02 ; mode usuari, interrupcions activades, overflow fp ens es igual
 wrs s0, r6
 
 ; posem l'adreça de la pila dusuari a r7
 ; aixi estem llestos per començar execucio
 $movei r7, PILA_USUARI ; la pila usuari esta a 1000, la tenim la tlb

 reti ; Simulem una crida a sistema i retornem a codi d'usuari

; ----------------
;  Rutines gestio
; ----------------


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
    
RSE_TLB_miss_d:
    rds    r1, s3 ; adreça que ha causat el miss
    movi   r2, 0x14 ; 10100, 12 en ca2
    shl    r3, r1, r2 ; desplacem a la dreta, pillem els 4 bits de la pag
    $movei r1, tlbd_index_count ; pillem lindex on toca guardar
    ld     r4, (r1)
    wrvd   r4, r3
    movi   r2, 0x20 ; mascara per fer bits valid i ro (0010 0000)
    add    r3, r3, r2
    wrpd   r4, r3
    addi   r4, r4, 1 ; augmentem comptador index tlbd reemplazo
    movi   r2, 0x07
    and    r4, r4, r2 ; mascara per fer modul 8
    st     (r1), r4
    rds    r7, s6
    ld     r1,  (r7)
    addi   r1, r1, -2
    st     (r7), r1
    jmp r6

RSE_TLB_miss_i:
    rds    r1, s3 ; adreça que ha causat el miss
    movi   r2, 0x14 ; 10100, 12 en ca2
    shl    r3, r1, r2 ; desplacem a la dreta, pillem els 4 bits de la pag
    $movei r1, tlbi_index_count ; pillem lindex on toca guardar
    ld     r4, (r1)
    wrvi   r4, r3
    movi   r2, 0x30 ; mascara per fer bits valid i ro (0011 0000)
    add    r3, r3, r2
    wrpi   r4, r3
    addi   r4, r4, 1 ; augmentem comptador index tlbi reemplazo
    movi   r2, 0x03
    and    r4, r4, r2
    st     (r1), r4
    rds    r7, s6
    ld     r1,  (r7)
    addi   r1, r1, -2
    st     (r7), r1
    jmp r6

RSE_TLB_pro_d: ; posem el flag per comprovar
    $movei r1, flag_dades_pro
    movi   r2, 1
    st     (r1), r2
    jmp    r6

RSE_TLB_pro_i: ; posem el flag per comprovar
    $movei r1, flag_inst_pro
    movi   r2, 1
    st     (r1), r2
    halt        ; Si intentem executar codi privilegiat, el proces
                ; shauria d'acabar, com que es un JP senzill parem el proc
                ; aqui i aquest sera lultim test
    jmp    r6

RSE_TLB_readonly:
   $movei r1, flag_readonly 
   movi   r2, 1
   st     (r1), r2
   jmp    r6


syscall_flush:
    movi   r1, 2
    flush  r1  ; fem flush del TLBd
    ; Aqui es torna tot loco per que de cop no coneix cap pagina de dades,
    ; per tant quan torni a usuari haurà de tornar a posar les pàgines on toqui.
    ; hi ha un problema, però, i és que sempre volem tenir la pagina de dades de sistema
    ; on hi ha la pila de sistema carregada, ja que sinó no es pot entrar/sortir de la RSG
    ; (ja que és necessari poder accedir a aquella zona de memòria per salvar registres)
    ; Per tant, ara just a continuació del flush carreguem manualment la pagina de les dades
    ; de sistema (pagina 8)
    movi   r1, 8
    movi   r2, 0
    wrvd   r2, r1
    movi   r1, 0x28 ; el mateix 8 pero amb el bit de valid a 1 i de RO a 0 davant
    wrpd   r2, r1
    ; a partir daquest punt ja tenim acces a dades de sistema
    ; i ara actualitzem el comptador que fem servir de index per reemplaçar les entrades del TLB
    ; el posem a 1 perque a 0 hi hem posat la pagina que necessitavem
    $movei r1, tlbd_index_count
    movi   r0, 1
    st     (r1), r0
    
    jmp    r6

RSE_inst_protegida:
    $movei r1, flag_inst_ill
    movi   r2, 1
    st     (r1), r2
    jmp    r6
 
__exit:
 ; Parem la CPU
 halt



; --------------------
;   RUTINA DE SERVEI 
;       GENERAL
; --------------------

RSG:
    wrs s4, r7
    rds r7, s6
    ;salvem nomes r1, r2, r3, r4 i r6 per utilitzarlos de forma segura
    $pst r7, r1
    $pst r7, r2
    $pst r7, r3
    $pst r7, r4
    $pst r7, r6
    rds r1, s0
    $pst r7, r1 ; salvem paraula destat de retorn
    rds r1, s1
    $pst r7, r1 ; salvem direccio de retorn


    ; salvem el SST a S6 per que a partir d'aqui ja
    ; poden saltar mes excepcions o interrupcions
    wrs s6, r7
    ei

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
    ; recuperem el SST per si ha passat alguna cosa
    di
    rds r7, s6
    ; Restaurem els 5 registres abans de tornar
    $ppt r7, r1
    wrs s1, r1
    $ppt r7, r1
    wrs s0, r1
    $ppt r7, r6
    $ppt r7, r4
    $ppt r7, r3
    $ppt r7, r2
    $ppt r7, r1
    wrs s6, r7
    rds r7, s4
    reti
