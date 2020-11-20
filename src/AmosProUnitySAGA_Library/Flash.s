;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         INITIALISATION DU FLASHEUR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FlInit: clr     T_nbflash(a5)
        move     #lflash*FlMax-1,d0
        lea    T_tflash(a5),a0
razfl1: clr.b     (a0)+
        dbra     d0,razfl1
        rts

; FLASH OFF: arrete les flash de l''ecran active
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FlStop:    move.l    T_EcCourant(a5),d0
    addq.b    #1,T_NbFlash+1(a5)    Inhibe les interruptions
    moveq    #FlMax-1,d1
    lea    T_TFlash(a5),a0
FlS1    tst.w    (a0)
    beq.s    FlS3
    cmp.l    4(a0),d0
    bne.s    FlS3
    clr.w    (a0)
FlS3    lea    LFlash(a0),a0
    dbra    d1,FlS1
FlSx    bsr    FlCalc            Nombre de flash reels
    subq.b    #1,T_NbFlash+1(a5)    Redemarre
    rts
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       FLASH X,A$     d1=numero de la couleur, a1=adresse de la chaine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FlStart    movem.l    a2-a6/d2-d7,-(sp)
    cmp.b    #FlMax,T_NbFlash(a5)
    bcc    FlToo
    addq.b    #1,T_NbFlash+1(a5)    ;Arrete les flashes
        clr     d5
; Trouve une position dans la table
        lea    T_tflash(a5),a0           ;trouve la position dans la table
    moveq    #FlMax-1,d0
        addq     #1,d1
        lsl     #1,d1
    move.l    T_EcCourant(a5),d2    ;ecran ouvert!
flshi1: tst.w     (a0)                ;premiere place libre
        beq.s     flspoke
        cmp.w     (a0),d1             ;Meme couleur Meme ecran
        bne.s    flshi0
    cmp.l    4(a0),d2
    beq.s    flspoke
flshi0: lea     lflash(a0),a0
    dbra    d0,flshi1
        bra.s     flsont              ;par securite
flsynt    clr.w     (a0)                  ;arrete la couleur
flsont    moveq     #8,d0
flout    bsr    FlCalc            ;Nombre de flash REEL
    subq.b    #1,T_NbFlash+1(a5)    ;Deshinibe
    tst.w    d0
FlExit    movem.l    (sp)+,d2-d7/a2-a6
    rts
; Place trouvee: poke dans la table
flspoke    moveq     #lflash-1,d0          ;nettoie la table
        move.l     a0,a2
flshi3: clr.b     (a2)+
        dbra     d0,flshi3
        moveq    #0,d0
        tst.b     (a1)                  ;flash 1,"": arret de la couleur
        beq.s     flout
    move.l    a0,a2
    move.w    d1,(a2)+        ;Numero de la couleur
    move.w    #1,(a2)+        ;Compteur
        move.l     d2,(a2)+            ;Adresse de l''ecran
    clr.w    (a2)+            ;Position
        moveq     #-1,d4
flshi4: move.b    (a1)+,d0
        cmp.b     #"(",d0
        bne     flshi5
        addq.l     #1,d4
        cmp     #16,d4                 ;16 couleurs autorisees!
        bcc     flsynt
    moveq    #12,d2
    clr.l    d1
    bsr    GetHexa
    beq    FlSynt
    lsl.w    d2,d1
    lsl.l    #4,d1
    bsr    GetHexa
    beq    FlSynt
    lsl.w    d2,d1
    lsl.l    #4,d1
    bsr    GetHexa
    beq    FlSynt
    lsl.w    d2,d1
    lsl.l    #4,d1
    swap    d1
        move.w     d1,2(a2)          ;poke la couleur!
        cmp.b     #",",(a1)+
        bne     flsynt
        bsr     dechexa
        bne     flsynt
        tst     d1
        beq     flsynt
        move.w     d1,(a2)               ;poke la vitesse
    addq.l    #4,a2
        cmp.b     #")",d0
        bne     flsynt
        bra     flshi4
flshi5: tst.b     d0                    ;la chaine doit etre finie!
        bne     flsynt
        clr.l     d0                    ;pas d''erreur
        bra     flout
; Erreurs flash
FlToo    moveq    #7,d0            * Too many flash
    bra    FlExit

;     Calcule le nombre exact de flash
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FlCalc    movem.l    a0-a1/d0-d1,-(sp)
    addq.b    #1,T_NbFlash+1(a5)
    moveq    #0,d0
    moveq    #FlMax-1,d1
        lea    T_tflash(a5),a0           ;trouve la position dans la table
.Loop    tst.w    (a0)
    beq.s    .Next
    addq.w    #1,d0
.Next    lea    lflash(a0),a0
    dbra    d1,.Loop
    move.b    d0,T_NbFlash(a5)
    subq.b    #1,T_NbFlash+1(a5)
    movem.l    (sp)+,a0-a1/d0-d1
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       INTERRUPTIONS FLASHEUR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FlInt:
    tst.b    T_NbFlash+1(a5)        Autorisee?
    bne.s    FlShXX
    move.b     T_NbFlash(a5),d7    Nombre en route
    beq.s    FlShXX
    addq.b    #1,T_NbFlash+1(a5)    Inhibe!
    lea    T_tflash-lflash+2(a5),a0
FlShLL:
    lea    lflash-2(a0),a0
FlShL:
    move.w     (a0)+,d0
    beq.s     FlShLL
; Flashe!
    sub.w     #1,(a0)            * Compteur
    bne.s     FlShN
    lea    2(a0),a1
    move.l    (a1)+,a2        * Adresse de l''ecran
    add.w    (a1)+,a1        * Pointe
    move.w    (a1)+,(a0)
    bne.s    Flsh4
    lea    6(a0),a1
    clr.w    (a1)+
    move.w    (a1)+,(a0)
FlSh4:    addq.w    #4,6(a0)        * Pointe le suivant
    move.w    (a1),d2
    move.w    d2,EcPal-2(a2,d0.w)    * Change dans la definition
    lsl.w    #1,d0
    move.w    EcNumber(a2),d1
    lsl.w    #7,d1
    lea    0(a3,d1.w),a2
    cmp.w    #PalMax*4+4,d0
    bcs.s    FlSh5
    lea    64(a2),a2
FlSh5:
    move.l    (a2)+,d1        * Change toutes les definitions
    beq.s    FlShN
FlSh6:
    move.l    d1,a1
    move.w    d2,2-4(a1,d0.w)
    move.l    (a2)+,d1
    bne.s    FlSh6
; Encore un actif?
FlShN:
    subq.b    #1,d7
    bne.s    FlShLL
; Fini!
FlShX:
    subq.b    #1,T_NbFlash+1(a5)    Retabli les interruptions
FlShXX:
    rts
