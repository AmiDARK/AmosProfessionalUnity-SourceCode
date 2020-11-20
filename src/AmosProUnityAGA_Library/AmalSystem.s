;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * AMAL
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------

    IFEQ    EZFlag
***************************** FORMAT D''UNE SEQUENCE
NbInterne:    equ 10
AmPrev:        equ 0
AmNext:        equ 4
AmLong:        equ 8
AmNb:        equ 10
AmPos:        equ 12
AmAuto:        equ 16
AmAct:        equ 20
AmBit:        equ 24
AmCpt:        equ 26
AmDeltX:    equ 28
AmDeltY:    equ 32
AmVirgX:    equ 36
AmVirgY:    equ 38
AmFin:        equ 40
AmAJsr:        equ 44
AmAAd:        equ 48
AmAALoop:    equ 52
AmACLoop:    equ 56
AmACpt:        equ 58
AmIRegs:    equ 60
AmStart:    equ 60+NbInterne*2

***********************************************************
*    TOKENISATEUR AMAL
******* ENTREE
*    D3==> Type 0=Anim / 1= Move / 2= Move X / 3= Move Y
*    A1==> Chaine
*    A2/D2==> Buffer tokenisation
*    D1==> Buffer variables
******* SORTIE
*    D0==> ERREUR?
*    A0==> Longueur chaine
TokAMAL:
********
    movem.l    d1-d7/a1-a6,-(sp)
    move.l    sp,T_AMALSp(a5)
    move.l    d7,-(sp)
    move.l    d7,T_AmBank(a5)

    move.l    a1,a0            * Debut chaine!
    move.l    d1,a1
    move.l    a2,d7            * Bas du buffer
    lea    0(a2,d2.w),a5        * Fin du buffer
    moveq    #0,d6
    move.l    d6,a6
    moveq    #0,d5            * Pas d''autotest
    moveq    #0,d4            * Pas d''erreur
* Init de la table des labels
    move.l    a1,a3
    moveq    #26/2,d0
    moveq    #-1,d1
InA0:    move.l    d1,(a3)+
    dbra    d0,InA0
* Table des FOR/NEXT
    lea    26*2+26*4(a1),a3    * 256 Octets de plus!
    move.l    #-1,(a3)+
    lea    AmJumps(pc),a4        * Table des decalages
* Stos type?
    tst.w    d3
    bne    AniStos

* Boucle d''interpretation
AniLoop    cmp.l    a5,a2
    bcc    AniTrop
    bsr    AniChr
    beq    AnPasse2
    move.w    d0,d1
    bsr    AniChr
    cmp.b    #":",d0
    beq    AnLab
    subq.l    #1,a0
    cmp.b    #"J",d1
    beq    AnJmp
    cmp.b    #"L",d1
    beq    AnLet
    cmp.b    #"M",d1
    beq    AnMove
    cmp.b    #"F",d1
    beq    AnFor
    cmp.b    #"N",d1
    beq    AnNext
    cmp.b    #"I",d1
    beq    AnIf
    cmp.b    #"W",d1
    beq    AnWait
    cmp.b    #"P",d1
    beq    AnPose
    cmp.b    #"E",d1
    beq    AnStop
    cmp.b    #"A",d1
    beq    AnAni
    cmp.b    #"D",d1
    beq    AnDirect
    cmp.b    #"X",d1
    beq    AnExit
    cmp.b     #")",d1
    beq    AnAutOf
    bra    AniLoop
******* Trop long! Marque et boucle!
AniTrop:sub.l    d7,a2
    add.l    a2,a6
    move.l    d7,a2
    bra    AniLoop

******* AUto test
AnAutOn:addq.l    #1,a0
    bsr    AniChr
    tst.w    d5
    bne    AniE5
    cmp.b    #"(",d0
    bne    AniE1
    bsr    AniChr
    cmp.b    #")",d0
    beq.s    AnAu1
    subq.l    #1,a0
    move.w    $60/2(a4),(a2)+
    move.l    a2,d5
    sub.l    d7,d5
    swap    d5
    move.w    #1,d5
    clr.w    (a2)+
    bra    AniLoop
AnAu1:    move.w    $64/2(a4),(a2)+
    bra    AniLoop
******* FIN AUTOTEST / EXIT
AnExit:    tst.w    d5
    beq    AniE6
    move.w    $68/2(a4),(a2)+
    clr.w    (a2)+
    bra    AniLoop
AnAutOf    tst.w    d5
    beq    AniE6
    move.w    $68/2(a4),(a2)+
    move.l    a2,d0
    sub.l    d7,d0
    swap    d5
    sub.w    d5,d0
    move.l    a0,-(sp)
    move.l    d7,a0
    move.w    d0,0(a0,d5.w)
    move.l    (sp)+,a0
    moveq    #0,d5
    bra    AniLoop
******* DIRECT label EXTERNE!
AnDirect:
    tst.w    d5
    beq    AniE6
    move.w    $6C/2(a4),(a2)+
    bsr    AniChr
    sub.b    #"A",d0
    bcs    AniE1
    cmp.b    #26,d0
    bhi    AniE1
    lsl.w    #1,d0
    move.l    a2,d1
    sub.l    d7,d1
    move.w    d1,26*2(a1,d6.w)
    move.w    d0,26*2+2(a1,d6.w)
    addq.w    #4,d6
    move.w    #-1,26*2(a1,d6.w)
    clr.w    (a2)+
    bra    AniLoop

******* Un LABEL!
AnLab:    sub.b    #"A",d1
    bcs    AniE1
    cmp.b    #26,d1
    bhi    AniE1
    lsl.w     #1,d1
    tst.w    0(a1,d1.w)
    bpl    AniE8
    move.l    a2,d0
    sub.l    d7,d0
    or.w    d5,d0
    move.w    d0,0(a1,d1.w)
    bra    AniLoop
******* Un BRANCHEMENT
AnJmp:    move.w    $1C/2(a4),(a2)+
    bsr    AniChr
    sub.b    #"A",d0
    bcs    AniE1
    cmp.b    #26,d0
    bhi    AniE1
    lsl.w    #1,d0
    move.l    a2,d1
    sub.l    d7,d1
    or.w    d5,d1
    move.w    d1,26*2(a1,d6.w)
    move.w    d0,26*2+2(a1,d6.w)
    addq.w    #4,d6
    move.w    #-1,26*2(a1,d6.w)
    clr.w    (a2)+
    bra    AniLoop

*******    For RA=deb To end 
AnFor:    tst.w    d5
    bne    AniE9
    move.w    $28/2(a4),(a2)+
    bsr    AniReg
    beq    AniE1
    cmp.w    #$000C/2,d1
    bne    AniE1
    swap    d2
    move.w    d2,-(sp)        * Poke le debut
    bsr    AniChr
    cmp.b    #"=",d0
    bne    AniE1
    bsr    AniExp
    bsr    AniChr            * Poke le TO
    cmp.b    #"T",d0
    bne    AniE1
    bsr    AniExp
    move.l    a2,(a3)+
    move.w    (sp)+,d2        * Poke la variable
    move.w    d2,(a3)+
    move.w    d2,(a2)+
    clr.w    (a2)+            * Place pour le TO!
    bra    AniLoop
******* NEXT RA
AnNext:    tst.w    d5
    bne    AniE9
    move.w    $2C/2(a4),(a2)+
    bsr    AniReg
    beq    AniE1
    cmp.w    #$000C/2,d1
    bne    AniE1
    swap    d2
    cmp.w    -(a3),d2
    bne    AniE2
    move.l    -(a3),d0
    sub.l    a2,d0
    move.w    d0,(a2)+
    bra    AniLoop

******* LET 
AnLet:    move.w    $20/2(a4),(a2)+
    bsr    AniReg
    beq    AniE1
    add.w    #$0030/2,d1
    movem.l    d1-d3,-(sp)
    bsr    AniChr
    cmp.b    #"=",d0
    bne    AniE1
    bsr    AniExp
    movem.l    (sp)+,d1-d3
    move.w    0(a4,d1.w),(a2)
    move.l    d2,2(a2)
    add.w    d3,a2
    bra    AniLoop

******* TESTS
AnIf:    move.w    $24/2(a4),(a2)+
    bsr    AniExp
    bsr    AniChr
    cmp.b    #"J",d0
    beq    AnJmp
    cmp.b    #"D",d0
    beq    AnDirect
    cmp.b    #"X",d0
    beq    AnExit
    bra    AniE1

******* MOVE DeltaX,DeltaY,Nbstep
AnMove:    tst.w    d5
    bne    AniE9
    move.w    $18/2(a4),(a2)+
    bsr    AniExp
    bsr    AniChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniExp
    bsr    AniChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniExp
    bra    AniLoop


******* PAUSE
AnPose:    cmp.b     #"L",(a0)
    beq.s    AnPlay
    move.w    $0014/2(a4),(a2)+
    bra    AniLoop
******* END
AnStop:    move.w    $0000/2(a4),(a2)+
    bra    AniLoop
******* WAIT
AnWait:    tst.w    d5
    bne    AniE9
    move.w    $0010/2(a4),(a2)+
    bra    AniLoop
******* PLay Exp
AnPlay:    addq.l    #1,a0
    tst.l    (sp)
    beq    AniE10
    move.w    $00C0/2(a4),(a2)+
    bsr    AniExp
    bra    AniLoop
******* Anim 
AnAni:    cmp.b    #"U",(a0)
    beq    AnAutOn
    move.w    $CC/2(a4),(a2)+
    bsr    AniExp
    move.l    a2,-(sp)
    clr.w    (a2)+
    bsr    AniChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniChr
    cmp.b    #"(",d0
    bne    AniE1
AnAni1    bsr    AniExp
    bsr    AniChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniExp
    bsr    AniChr
    cmp.b    #")",d0
    bne    AniE1
    bsr    AniChr
    cmp.b    #"(",d0
    beq.s    AnAni1
    subq.l    #1,a0
    clr.w    (a2)+
    move.l    (sp),d0
    move.l    a2,(sp)
    exg    d0,a2
    sub.l    a2,d0
    move.w    d0,(a2)
    move.l    (sp)+,a2
    bra    AniLoop

***********************************************************
*    COMPATIBLE STOS!
AniStos    move.l    a0,-(sp)
    move.l    (sp)+,a0
    cmp.w    #1,d3
    bne.s    AnMve
******* ANIMATION!
    move.w    $04/2(a4),(a2)+
    bsr    StChr
    cmp.b    #"(",d0
    bne    AniE1
AnSt0    bsr    AniLong
    move.w    d0,(a2)+
    bsr    StChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniLong
    move.w    d0,(a2)+
    bmi    AniE1
    bsr    StChr
    cmp.b    #")",d0
    bne    AniE1
AnSt1:    bsr    StChr
    beq.s    AnSt2
    cmp.b    #"L",d0
    beq.s    AnSt3
    cmp.b    #"(",d0
    beq.s    AnSt0
    bra    AniE1
AnSt2    move.w    #-1,(a2)+
    bra    AnPasse2
AnSt3    move.w    #-2,(a2)+
    bra    AnPasse2
* Mouvement X ou Y!
AnMve:    move.w    $08/2(a4),d0
    cmp.w    #2,d3
    beq.s    AnMv1
    move.w    $0C/2(a4),d0
AnMv1    move.w    d0,(a2)+
    move.l    a2,a3
    move.w    #$8000,(a2)+        * Debut
    clr.w    (a2)+            * Loop/End
    move.w    #$8000,(a2)+        * End
    bsr    StChr
    beq    AniE1
    cmp.b    #"(",d0
    beq.s    AnMv2
    subq.l    #1,a0
    bsr    AniLong
    move.w    d0,(a3)
    bsr    StChr
    cmp.b    #"(",d0
    bne    AniE1
AnMv2    bsr    AniLong
    move.w    d0,(a2)+
    ble    AniE1
0    bsr    StChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniLong
    move.w    d0,(a2)+
    bsr    StChr
    cmp.b    #",",d0
    bne    AniE1
    bsr    AniLong
    move.w    d0,(a2)+
    bmi    AniE1
    bsr    StChr
    cmp.b    #")",d0
    bne    AniE1
    bsr    StChr
    cmp.b    #"(",d0
    beq.s    AnMv2
    clr.w    (a2)+
    tst.b    d0
    beq    AnPasse2
    cmp.b    #"L",d0
    bne.s    AnMv3
    move.w    #-1,2(a3)
    bra.s    AnMv4
AnMv3    cmp.b    #"E",d0
    bne    AniE1
AnMv4    bsr    StChr
    beq    AnPasse2
    subq.l    #1,a0
    bsr    AniLong
    move.w    d0,4(a3)
    bra    AnPasse2
******* Chrget pour stos type!
StChr:    moveq    #0,d0
StChr1    move.b    (a0)+,d0
    beq.s    StChr2
    cmp.b    #32,d0
    beq.s    StChr1
    cmp.b    #"a",d0
    bcs.s    StChr2
    cmp.b    #"z",d0
    bhi.s    StChr2
    sub.b    #32,d0
StChr2    rts

***********************************************************    
*     DEUXIEME PASSE: affecte les labels!
AnPasse2:
    move.w    $00/2(a4),(a2)+
    sub.l    d7,a2
    exg.l    d7,a2
    lea    26*2(a1),a0
    moveq    #0,d0
AnLoop2    move.w    (a0)+,d0
    bmi.s    AniX
    move.w    d0,d2
    and.w    #$0001,d2
    and.w    #$FFFE,d0
    move.w    (a0)+,d1
    move.w    0(a1,d1.w),d1
    bmi    Aniee3
    move.w    d1,d3
    and.w    #$0001,d3
    and.w    #$FFFE,d1
    cmp.w    d2,d3
    bne    Aniee4
    sub.w    d0,d1
    move.w    d1,0(a2,d0.w)
    bra.s    AnLoop2
******* Tout est fini!
AniX:    addq.l    #4,sp
    cmp.l    #0,a6
    bne.s    AniX2
    move.l    d7,a0
    movem.l    (sp)+,d1-d7/a1-a6
    moveq    #0,d0
    rts
AniX2:    move.l    a6,a0
    add.l    d7,a0
    movem.l    (sp)+,d1-d7/a1-a6    * -1-> Pas assez de place!
    moveq    #-1,d0            * A0= longueur necessaire!
    rts
Aniee3:    lea    0(a2,d0.w),a0
    bra.s    Anie3
Aniee4:    lea    0(a2,d0.w),a0
    bra.s    Anie4    
    ENDC

******* ERREUR!
AniE10:
    addq.w    #1,d4            * PLay only with bank
AniE9:
    addq.w    #1,d4            * Not authorised during autotest
AniE8:
    addq.w    #1,d4            * Label already def            
AniE7:
    addq.w    #1,d4            * String too long
AniE6:
    addq.w    #1,d4            * Autotest not opened
AniE5:
    addq.w    #1,d4            * Autotest already on
AniE4:
    addq.w    #1,d4            * Jump To/Within AUTOTEST
AniE3:
    addq.w    #1,d4            * Label not defined
AniE2:
    addq.w    #1,d4            * Next /For
AniE1:
    move.l     W_Base(pc),a5           ; load a5=W_Base(pc)
    move.l     T_AMALSp(a5),d1         ; D1 = T_AMALSp(a5) 
    beq        RainExecutiveError      ; if D1=0 Then Came from Rainbow System (not Amal), Jump RainExecutiveError
    move.l     d1,sp
    addq.w     #1,d4            * Syntax error
    move.l     d4,d0
    movem.l    (sp)+,d1-d7/a1-a6
    sub.l      a1,a0            * Offset de l''erreur
    tst.w      d0
    rts

    IFEQ    EZFlag

***********************************************************
*    ROUTINES INTERPRETATION
******* Prend X/Y/A/ ou REG
AniReg:    bsr    AniChr
AniR:    moveq    #$00/2,d1
    cmp.b    #"A",d0
    beq.s    AniRx
    moveq    #$04/2,d1
    cmp.b    #"X",d0
    beq.s    AniRx
    moveq    #$08/2,d1
    cmp.b    #"Y",d0
    beq.s    AniRx
    cmp.b    #"R",d0
    bne.s    AniRe
* R
    moveq    #$0C/2,d1
    bsr    AniChr
    sub.b    #"0",d0
    bcs    AniRe
    cmp.b    #NbInterne,d0
    bcc.s    AniR0    
    addq.w    #1,d0
    neg.w    d0
    bra.s    AniR1
AniR0:    sub.b    #"A"-"0",d0
    bcs    AniRe
    cmp.b    #26,d0
    bhi    AniRe
AniR1:    lsl.w    #1,d0
    move.w    d0,d2
    swap     d2
    moveq    #4,d3
    rts
* Autres
AniRx:    moveq    #2,d3
    rts
* Pas un registre
AniRe:    subq.l    #1,a0
    moveq    #0,d3
    rts

******* Operande!
AniOpe:    bsr    AniChr
    cmp.b    #"K",d0
    beq.s    AniMou
    cmp.b    #"J",d0
    beq.s    AniJoy
    cmp.b    #"O",d0
    beq.s    AniOn
    cmp.b    #"S",d0
    beq    AniSCol
    cmp.b     #"B",d0
    beq    AniBCol
    cmp.b     #"C",d0
    beq    AniCol
    cmp.b    #"Z",d0
    beq    AniHaz
    cmp.b    #"V",d0
    beq    AniVu
    cmp.b    #"-",d0
    beq.s    AniOc
    cmp.b    #"$",d0
    beq.s    AniOc
    cmp.b    #"0",d0
    bcs.s    AniO1
    cmp.b    #"9",d0
    bhi.s    AniO1
* Chiffre!
AniOc:    subq.l    #1,a0
    bsr    AniLong
    move.w    $70/2(a4),(a2)+
    move.w    d0,(a2)+
    rts
* =On
AniOn:    move.w    $50/2(a4),(a2)+
    rts
* Saisie du joystick!
AniJoy:    bsr    AniChr
    move.w    $80/2(a4),d1
    cmp.b    #"0",d0
    beq.s    AniO0
    move.w    $84/2(a4),d1
    cmp.b    #"1",d0
    bne    AniE1
AniO0:    move.w    d1,(a2)+
    rts
* Saisie touches souris!
AniMou:    bsr    AniChr
    move.w    $88/2(a4),d1
    cmp.b    #"1",d0
    beq.s    AniO0
    move.w    $8C/2(a4),d1
    cmp.b    #"2",d0
    beq.s    AniO0
    bra    AniE1
* Autres registres
AniO1:    bsr    AniR
    beq    AniE1
    cmp.w    #$04/2,d1
    beq.s    AniO4
    cmp.w    #$08/2,d1
    beq.s    AniO4
* Un registre normal
AniO2:    add.w    #$0040/2,d1
    bra    AniO5
* X-Y  MOUSE/SCREEN/HARD
AniO4:    bsr    AniChr
    subq.l    #1,a0
    cmp.b    #"S",d0
    beq.s    AniO4a
    cmp.b    #"H",d0
    beq.s    AniO4b
    cmp.b    #"M",d0
    bne.s    AniO2
    add.w    #$0070/2,d1
    addq.l    #1,a0
    bra    AniO5
AniO4a:    add.w    #$0050/2,d1
    bra.s    AniO4c
AniO4b    add.w    #$00C0/2,d1
AniO4c:    addq.l    #1,a0
    move.w    0(a4,d1.w),(a2)+
AniPp2:    bsr    AniChr
    cmp.b    #"(",d0
    bne    AniRe
    bra.s    AniP2
* = Col(n)
AniCol:    move.w    $005C/2(a4),(a2)+
AniPp1:    bsr    AniChr
    cmp.b    #"(",d0
    bne    AniRe
    bsr    AniExp
    bsr    AniChr
    cmp.b    #")",d0
    bne    AniRe
    rts
* = Spr Col(n,x,y)
AniSCol    move.w    $00B8/2(a4),(a2)+
    bra.s    AniCo
* = Bob Col(n,x,y)
AniBCol:move.w    $00BC/2(a4),(a2)+
AniCo:    bsr    AniChr
    cmp.b    #"C",d0
    bne    AniRe
AniPp3:    bsr    AniChr
    cmp.b    #"(",d0
    bne    AniRe
    bsr    AniExp
    bsr    AniChr
    cmp.b    #",",d0
    bne    AniRe
AniP2:    bsr    AniExp
    bsr    AniChr
    cmp.b    #",",d0
    bne    AniRe
    bsr    AniExp
    bsr    AniChr
    cmp.b    #")",d0
    bne    AniRe
    rts
* Poke!
AniO5:    move.w    0(a4,d1.w),(a2)
    move.l    d2,2(a2)
    add.w    d3,a2
    rts
* =H(xx)
AniHaz    move.w    $D0/2(a4),(a2)+
    bra    AniPp1
* =V(xx)
AniVu    move.w    $D4/2(a4),(a2)+
    bra    AniPp1

******* EXPRESSION
AniExp:    bsr    AniOpe
AniE0:    bsr    AniChr
    moveq    #$0090/2,d1
    cmp.b    #"=",d0
    beq.s    AniEx1
    addq.w    #4,d1
    cmp.b    #"<",d0
    bne.s    AniEx0
    cmp.b    #">",(a0)
    bne.s    AniEx1
    subq.w    #2,d1
    addq.l    #1,a0
    bra.s    AniEx1
AniEx0:    addq.w    #2,d1
    cmp.b    #">",d0
    beq.s    AniEx1
    addq.w    #2,d1
    cmp.b    #"+",d0
    beq.s    AniEx1
    addq.w    #2,d1
    cmp.b    #"-",d0
    beq.s    AniEx1
    addq.w    #2,d1
    cmp.b    #"/",d0
    beq.s    AniEx1
    addq.w    #2,d1
    cmp.b    #"*",d0
    beq.s    AniEx1
    addq.w    #2,d1
    cmp.b    #"|",d0
    beq.s    AniEx1
    addq.w    #2,d1
    cmp.b    #"&",d0
    beq.s    AniEx1
    cmp.b    #"!",d0
    beq.s    AniXor
* Fin de l''expression
    move.w    $7c/2(a4),(a2)+
    subq.l    #1,a0
    rts
* Special pour XOR
AniXor    moveq    #$00D8/2,d1
* Cherche le deuxieme operande
AniEx1    move.w    0(a4,d1.w),-(sp)
    bsr    AniOpe
    move.w    (sp)+,(a2)+
    bra    AniE0

***********************************************************
*    INITIALISATION AMAL
AMALInit:
********
    clr.l    T_AmDeb(a5)
    clr.l    T_AmChaine(a5)
    move.w    #$1234,T_AmSeed(a5)
***********************************************************
*    CLEAR AMAL
ClrAMAL:
*******
    bsr    DAllAMAL
    lea    T_AmRegs(a5),a0
    moveq    #26/2-1,d0
ClAm:    clr.l    (a0)+
    dbra    d0,ClAm
    moveq    #0,d0
    rts

***********************************************************
*    SYNCHRO: D1= on/off 
SyncO:
    move.w    d1,T_SyncOff(a5)
    moveq    #0,d0
    rts
Sync:
    tst    T_SyncOff(a5)
    beq.s    Sync1
    movem.l    d2-d7/a2-a6,-(sp)
    bsr    Animeur
    movem.l    (sp)+,d2-d7/a2-a6
Sync1:    rts

***********************************************************
*    RAMENE L''ADRESSE UN REGISTRE
*    D1= -1-> generaux / # du mouvement
*    D2= type du mouvement
*    D3= numero du registre
RegAMAL:
*******
    lea    T_AmRegs(a5),a0
    lsl.w    #1,d3
    tst.w    d1
    bmi.s    RgA3
* Registres internes
    move.l    T_AmDeb(a5),d0
    beq.s    RgA1
    lsl.w    #2,d1
    add.w    d2,d1
RgA0    move.l    d0,a1
    cmp.w    AmNb(a1),d1
    beq.s    RgA2
    bcs.s    RgA1
    move.l    AMNext(a1),d0
    bne.s    RgA0
RgA1    moveq    #-1,d0
    rts
RgA2:    lea    AmIRegs+NbInterne*2-2(a1),a0
    neg.w    d3
RgA3:    add.w    d3,a0
    moveq    #0,d0
    rts

***********************************************************
*    AMAL PLAY
*    D1= Debut
*    D2= Fin
*    D3= Speed (R0)
*    D4= Direction (R1)
SetPlay:
*******
    move.l    T_AmDeb(a5),d0
    beq.s    StPx
    lsl.w    #2,d1
    lsl.w    #2,d2
    move.l    #EntNul,d5
StP1:    move.l    d0,a1
    move.w    AmNb(a1),d0
    cmp.w    d2,d0
    bhi.s    StPx
    cmp.w    d1,d0
    bcs.s    StP3
    cmp.l    d5,d3
    beq.s    StP2
    move.w    d3,AmIRegs+NbInterne*2-2(a1)
StP2:    cmp.l    d5,d4
    beq.s    StP3
    move.w    d4,AmIRegs+NbInterne*2-4(a1)
StP3:    move.l    AMNext(a1),d0
    bne.s    StP1
StPx:    moveq    #0,d0
    rts

***********************************************************
*    CREATION / REMPLACEMENT D''UNE ANIMATION
*    A1=    Chaine a tokeniser
*    A2/D2=    Buffer de tokenisation
*    D1=    Buffer variables
*    D3=     0-> Amal / 1-> Anim / 2-> X / 3-> Y
*    D4=     0-> Sprite / 1-> Bobs / 2-> Ecrans / 3-> Adresse
*    D5=     # De l''objet
*    D6=     # du Canal
CreAMAL:
********
******* Va tokeniser!
    bsr    TokAMAL
    tst.w    d0
    beq.s    CreA0
    bpl    CreAmE
* Pas assez de place! Reserve et RE-tokenise!
    add.w    #AmStart+4,a0
    move.l    a0,d0
    move.l    d0,d2
    bsr    FastMm
    beq    CreME
    move.l    d0,a2
    move.w    d2,AmLong(a2)
    sub.l    #AmStart+4,d2
    lea    AmStart(a2),a2
    bsr    TokAMAL
    lea    -AmStart(a2),a2
    sub.l    a0,a0
* Ok!
CreA0:    move.l    a0,d1
    move.w    d6,d2

******* Insere dans la liste
    clr.l    T_AmChaine(a5)
    clr.l    T_AmFreeze(a5)
******* ID complet!
    lsl.w    #2,d2
    add.w    d3,d2

******* Efface l''ancienne - SI PRESENT -
    move.l    a1,a0
    move.l    T_AmDeb(a5),d0
    beq.s    CreAm1
CreAm0:    move.l    d0,a1
    cmp.w    AmNb(a1),d2
    beq.s    CreAm2
    bcs.s    CreAm5
    move.l    AmNext(a1),d0
    bne.s    CreAm0
* Met a la fin!
    bsr    ResAMAL
    bne    CreAmE
    move.l    a1,AmPrev(a0)
    move.l    a0,AmNext(a1)
    bra.s    CreAm10
* Au tout debut
CreAm1:    bsr    ResAMAL
    bne    CreAmE
    move.l    a0,T_AmDeb(a5)
    bra.s    CreAm10
* Remplace l''ancienne chaine
CreAm2:    move.l    AmPrev(a1),d6
    move.l    AmNext(a1),d7
    moveq    #0,d0
    move.w    AmLong(a1),d0
    bsr    FreeMm
    bsr    ResAMAL
    move.w    d0,-(sp)
    move.l    d6,AmPrev(a0)
    move.l    d7,AmNext(a0)
    beq.s    CreAm3
    move.l    d7,a1
    move.l    a0,AmPrev(a1)
CreAm3:    tst.l    d6
    bne.s    CreAm4
    move.l    a0,T_AmDeb(a5)
    bra.s    CreAm4a
CreAm4:    move.l    d6,a1
    move.l    a0,AmNext(a1)
CreAm4a    move.w    (sp)+,d0
    beq.s    CreAm10
    bra.s    CreAmE
* Insere la nouvelle
CreAm5:    bsr    ResAMAL
    bne    CreAmE
    move.l    AmPrev(a1),d0
    move.l    a0,AmPrev(a1)
    move.l    d0,AmPrev(a0)
    bne.s    CreAm6
    move.l    T_AmDeb(a5),d3
    move.l    a0,T_AmDeb(a5)
    bra.s    CreAm7
CreAm6:    move.l    d0,a2
    move.l    AmNext(a2),d3
    move.l    a0,AmNext(a2)
CreAm7:    move.l    d3,AmNext(a0)
******* Pas d''erreur!
CreAm10    move.l    T_AmDeb(a5),T_AmChaine(a5)
    moveq    #0,d0
    rts
******* Erreur!
CreAmE:    tst.w    d0
    rts
CreME:    moveq    #-1,d0
    bra.s    CreAME

******* CREATION DE LA TABLE!
ResAMAL:
    tst.l    d1
    beq.s    ResDeja
* Reserve la memoire pour la table, et copie le buffer!
    move.l    a2,a0
    add.w    #AmStart+4,d1
    moveq    #0,d0
    move.w    d1,d0
    bsr    FastMm
    beq    ResAErr
    move.l    d0,a2
    move.w    d1,AmLong(a2)
    move.w    d2,AmNb(a2)
    move.l    a1,-(sp)        * Copie la table
    lea    AmStart(a2),a1
    move.l    a1,AmPos(a2)
    sub.w    #AmStart+4,d1
    lsr.w    #2,d1
ResAc:    move.l    (a0)+,(a1)+
    dbra    d1,ResAc
    move.l    (sp)+,a1
    bra.s    ResPas

* Table deja reservee!
ResDeja:
    move.w    d2,AmNb(a2)
    lea    AmStart(a2),a0
    move.l    a0,AmPos(a2)

* Calcule l''adresse ACT
ResPas:
    move.l    a2,a0
    cmp.w    #6,d4
    beq    ResRain
    cmp.w    #5,d4
    beq    ResAdd
    subq.w    #1,d4
    bmi.s    ResAs
    beq.s    ResAb

******* Creation ECRANS
    lsl.w    #2,d5
    lea    T_EcAdr(a5),a2
    move.l    0(a2,d5.w),d5
    beq.s    ResAee
    move.l    d5,a2
    subq.w    #2,d4
    bmi.s    ResAe3
    beq.s    ResAe2
* Ecrans OFFSET
    add.w    #EcAV,a2
    bra.s    ResAe4
* Ecrans TAILLE
ResAe2:    add.w    #EcAWT,a2
    bra.s    ResAe4
* Ecrans position
ResAe3:    add.w    #EcAW,a2
ResAe4:    move.l    a2,AmAct(a0)
    move.w    #$8000+BitEcrans,AmBit(a0)
    moveq    #0,d0
    rts
* Erreur! Screen not opened
ResAee:    moveq    #-3,d0
    bra.s    ResAEx

******* Creation BOBS
ResAb:    move.w    d5,d1
    movem.l    a0/a1,-(sp)
    bsr    BobAd
    bne.s    ResAbe
    lea    BbAct(a1),a2
    movem.l    (sp)+,a0/a1
    move.l    a2,AmAct(a0)
    move.w    #$8000+BitBobs,AmBit(a0)
    moveq    #0,d0
    rts
* Erreur! BOB not defined
ResAbe:    movem.l    (sp)+,a0/a1
    moveq    #-24,d0
    bra.s    ResAEx

******* Creation SPRITES
ResAs:    lsl.w    #3,d5
    lea    T_HsTAct(a5),a2
    add.w    d5,a2
    move.l    a2,AmAct(a0)
    move.w    #$8000+BitSprites,AmBit(a0)
    moveq    #0,d0
    rts

******* Creation ADRESSE
ResAdd:    move.l    d5,AmAct(a0)
    move.l    d4,d0
    swap    d0
    and.w    #$00FF,d0
    add.w    #$8000,d0
    move.w    d0,AmBit(a0)
    moveq    #0,d0
    rts

******* Creation RAINBOW
ResRain    lea    T_RainTable(a5),a2
    mulu    #RainLong,d5
    lea    RnAct(a2,d5.w),a2
    move.l    a2,AmAct(a0)
    move.w    #$8000+BitEcrans,AmBit(a0)
    moveq    #0,d0
    rts

******* Erreur memoire!
ResAErr    moveq    #-1,d0
    rts
******* Efface la table si ERREUR!
ResAex:    move.l    d0,-(sp)
    move.l    a0,a1
    moveq    #0,d0
    move.w    AmLong(a1),d0
    bsr    FreeMm
    move.l    (sp)+,d0
    rts

***********************************************************
*    ARRET D''UN CANAL avec une adresse ACTUALISATION
*    A0= Adresse ACTUALISATION
DAdAMAL:
********
    movem.l    d1-d7/a0-a2,-(sp)
    move.l    T_AmDeb(a5),d6
    clr.l    T_AmChaine(a5)
    clr.l    T_AmFreeze(a5)
    move.l    d6,d5
    beq    MvOx    
    move.l    a0,d7
DAdAM1:    move.l    d5,a1
    cmp.l    AmAct(a1),d7
    beq.s    DAdAM2
    move.l    AmNext(a1),d5
    bne.s    DAdAM1
    bra    MvOx
DAdAM2:    move.l    AmNext(a1),d5
    bsr    DAMAL
    tst.l    d5
    bne.s    DAdAM1
    bra    MvOx

***********************************************************
*    ADRESSE D''UN CANAL: D1= Numero!
*    D6= AmDeb!
AdAMAL:
*******
    move.l    d6,d5
    beq.s    AdAmal1
    lsl.w    #2,d1
AdAmal0    move.l    d5,a1
    move.w    AmNb(a1),d0
    and.w    #$FFFC,d0
    cmp.w    d0,d1
    beq.s    AdAmal2
    bcs.s    AdAmal3
    move.l    AMNext(a1),d5
    bne.s    AdAmal0
AdAmal1 rts
AdAmal2 move.l    AmNext(a1),d5
    move.w    AmNb(a1),d7
    and.w    #$0003,d7
    moveq    #-1,d0
    rts
AdAmNx:    tst.l    d5
    bne.s    AdAmal0
    rts
AdAmal3 moveq    #0,d0
    rts

***********************************************************
*    =AMAL ADRESSE
*    D1= #
TAmAd:    move.l    T_AmDeb(a5),d6
    bsr    AdAmal
    move.l    a1,d1
    tst.w    d0
    rts
***********************************************************
*    =MOVON
*    D1= #
TMovon    move.l    T_AmDeb(a5),d6
    bsr    AdAmal
    beq.s    TMvo1
TMvo0    cmp.w    #2,d7
    beq.s    TMvo3
    cmp.w    #3,d7
    beq.s    TMvo3
    bsr    AdAmNx
    bne.s    TMvo0
TMvo1    moveq    #0,d1
    rts
TMvo3    tst.w    AmBit(a1)
    bmi.s    TMvo1
    tst.l    AmAJsr(a1)
    beq.s    TMvo1
TMvo2    moveq    #-1,d1
    rts
***********************************************************
*    = CHANAN
*    D1= #
RChan    move.l    T_AmDeb(a5),d6
    bsr    AdAmal
    beq.s    RChan1
    tst.w    AmBit(a1)
    bpl.s    RChan2
RChan1    addq.l    #4,sp
    moveq    #0,d1
RChan2    rts
TChanA    bsr    RChan
    tst.l    AmAJsr(a1)
    beq.s    TMvo1
    bne.s    TMvo2
TChanM    bsr    RChan
    tst.l    AmPos(a1)
    beq.s    TMvo1
    bne.s    TMvo2
    
***********************************************************
*    OFF/ON/FREEZE 
*    D1= -1 -> TOUS / D1=#
*    D2= Bit a 1--> A Changer
*    D3= -1-> OFF / 0-> Freeze / 1-> On
MvOAMAL:
*******
    movem.l    d1-d7/a0-a2,-(sp)
    move.l    T_AmDeb(a5),d6
    clr.l    T_AmFreeze(a5)
    clr.l    T_AmChaine(a5)

    tst.w    d1
    bmi.s    MvOAll
    bsr    AdAMAL
    beq.s    MvOx
******* Efface
MvO1:    btst    d7,d2
    beq.s    MvO2
    bsr    OnOfFrz
MvO2:    bsr    AdAMNx
    bne.s    MvO1

* FINI!
MvOx:    move.l    d6,T_AmDeb(a5)
    move.l    d6,T_AmChaine(a5)
    movem.l    (sp)+,d1-d7/a0-a2
    moveq    #0,d0
    rts

******* ARRETE TOUT!
MvOAll:    move.l    d6,d5
    beq.s    MvOx    
MvOA1:    move.l    d5,a1
    move.l    AmNext(a1),d5
    move.w    AmNb(a1),d7
    and.w    #$0003,d7
    btst    d7,d2
    beq.s    MvOA2
    bsr    OnOfFrz
MvOA2:    tst.l    d5
    bne.s    MvOA1
    bra    MvOx

******************************************* ENLEVE / MET / FREEZE
OnOfFrz    tst.w    d3
    bmi.s    DAMAL
    beq.s    OoF
* On!
    and.w    #$7FFF,AmBit(a1)
    rts
* Freeze
OoF:    or.w    #$8000,AmBit(a1)
    rts
****************************************** Enleve!
*    D6= AmDeb!
DAMAL:    movem.l    d0-d3,-(sp)
    move.l    AmNext(a1),d3
    move.l    AmPrev(a1),d2
    beq.s    DAMAL3
    move.l    d2,a0
    move.l    d3,AmNext(a0)
    bra.s    DAMAL4
DAMAL3:    move.l    d3,d6
DAMAL4:    tst.l    d3
    beq.s    DAMAL5
    move.l    d3,a0
    move.l    d2,AmPrev(a0)
DAMAL5:    move.w    AmLong(a1),d0
    ext.l    d0
    bsr    FreeMm
    movem.l    (sp)+,d0-d3
    rts

***********************************************************
*    EFFACEMENT TOUS CANAUX
DAllAMAL:
AMALEnd:
********
    moveq    #-1,d1
    moveq    #%1111,d2
    moveq    #-1,d3
    bra    MvOAMAL

***********************************************************
*    FREEZE AMAL
FrzAMAL:
********
    tst.l    T_AmFreeze(a5)
    bne.s    FrzA
    move.l    T_AmChaine(a5),T_AmFreeze(a5)
    clr.l    T_AmChaine(a5)
FrzA:    moveq    #0,d0
    rts
**********************
*    UNFREEZE AMAL
********
UFrzAMAL:
    tst.l    T_AmChaine(a5)
    bne.s    UFrzA
    move.l    T_AmFreeze(a5),d0
    beq.s    FrzA
    move.l    d0,T_AmChaine(a5)
UFrzA:    clr.l    T_AmFreeze(a5)
    bra.s    FrzA
    

******* BRANCHEMENT AUX FONCTIONS
AmJumps    dc.w     AmStop-AmJumps            * 00
    dc.w    AmAnim-AmJumps            * 04
    dc.w    AmMvtX-AmJumps            * 08
    dc.w     AmMvtY-AmJumps            * 0C
    dc.w    AmWait-AmJumps            * 10
    dc.w    AmPose-AmJumps            * 14
    dc.w    AmMove-AmJumps            * 18
    dc.w    AmJump-AmJumps            * 1C
    dc.w    AmLet-AmJumps            * 20
    dc.w    AmIf-AmJumps            * 24
    dc.w    AmFor-AmJumps            * 28
    dc.w    AmNxt-AmJumps            * 2C
    dc.w    AmAEg-AmJumps            * 30
    dc.w    AmXEg-AmJumps            * 34
    dc.w    AmYEg-AmJumps            * 38
    dc.w    AmREg-AmJumps            * 3C
    dc.w    AmEgA-AmJumps            * 40
    dc.w    AmEgX-AmJumps            * 44
    dc.w    AmEgY-AmJumps            * 48
    dc.w    AmEgR-AmJumps            * 4C
    dc.w    AmOn-AmJumps            * 50
    dc.w    AmXS-AmJumps            * 54
    dc.w    AmYS-AmJumps            * 58
    dc.w    AmCol-AmJumps            * 5C
    dc.w    AmAOn-AmJumps            * 60
    dc.w    AmAOff-AmJumps            * 64
    dc.w    AmAExit-AmJumps            * 68
    dc.w    AmDirect-AmJumps        * 6C
    dc.w    AmChif-AmJumps            * 70
    dc.w    AmXMou-AmJumps            * 74
    dc.w    AmYMou-AmJumps            * 78
    dc.w    AmSExp-AmJumps            * 7C
    dc.w    AmJ0-AmJumps            * 80
    dc.w    AmJ1-AmJumps            * 84
    dc.w    AmM1-AmJumps            * 88
    dc.w    AmM2-AmJumps            * 8C
    dc.w    AmEg-AmJumps            * 90
    dc.w    AmDif-AmJumps            * 94
    dc.w    AmInf-AmJumps            * 98
    dc.w    AmSup-AmJumps            * 9C
    dc.w    AmPlus-AmJumps            * A0
    dc.w    AmMoins-AmJumps            * A4
    dc.w    AmDiv-AmJumps            * A8
    dc.w    AmMult-AmJumps            * AC
    dc.w    AmOr-AmJumps            * B0
    dc.w    AmAnd-AmJumps            * B4
    dc.w    AmSCol-AmJumps            * B8
    dc.w    AmBCol-AmJumps            * BC
    dc.w    AmPlay-AmJumps            * C0
    dc.w    AmXH-AmJumps            * C4
    dc.w    AmYH-AmJumps            * C8
    dc.w    AmAni-AmJumps            * CC
    dc.w     AmHaz-AmJumps            * D0
    dc.w    AmVu-AmJumps            * D4
    dc.w    AmXor-AmJumps            * D8

***********************************************************
*    ANIMEUR / DEPLACEUR
Animeur:
********
    lea    AMJumps(pc),a4
    move.l    T_AMChaine(a5),d7
    beq.s    AMX
    move.l    d7,d0
    clr.l    T_AMChaine(a5)
    move.w    T_Actualise(a5),d5

******* Depart animation!
AmRE:    move.l    d0,a6
    move.w    AmBit(a6),d4
    bmi.s    AmL2

******* Boucle de l''autotest
    move.l    AmAuto(a6),d0
    beq.s    AmL1
    move.l    d0,a3
    moveq    #20,d6
    move.w    (a3)+,d0    
    jsr    0(a4,d0.w)

******* Boucle normale
AmL1:    move.l    AmPos(a6),d0
    beq.s    AmRet
    move.l    d0,a3
    moveq    #10,d6
    move.w    (a3)+,d0    
    jsr    0(a4,d0.w)

******* Appel de l''animation?
AmRet:    move.l    AmAJsr(a6),d0
    beq.s    AmL2
    move.l    d0,a0
    jsr    (a0)

******* Un Autre?
AmL2:    move.l    AmNext(a6),d0
    bne.s    AmRE

* Rebranche les inters
    move.w    d5,T_Actualise(a5)
    move.l    d7,T_AmChaine(a5)
AmX:    rts

******* MOVE x,y,step
AmMove:    subq.w    #1,AmCpt(a6)
    bmi.s    AmMvI
    beq.s    AmMvX
* Un cran
    move.l    AmAct(a6),a0
    move.w    2(a0),d0
    move.w    d0,d2
    swap    d0
    move.w    AmVirgX(a6),d0
    move.w    4(a0),d1
    move.w    d1,d3
    swap    d1
    move.w    AmVirgY(a6),d1
    add.l    AmDeltX(a6),d0
    add.l    AmDeltY(a6),d1
AmMv0:    move.w    d0,AmVirgX(a6)
    move.w    d1,AmVirgY(a6)
    swap    d0
    swap    d1
    cmp.w    d2,d0
    beq.s    AmMv1
    move.w    d0,2(a0)
    bset    #1,(a0)
    bset    d4,d5
AmMv1:    cmp.w    d3,d1
    beq.s    AmMv2
    move.w    d1,4(a0)
    bset    #2,(a0)
    bset    d4,d5
AmMv2:    rts
* Mvt suivant
AmMvX:    move.l    AmFin(a6),a3
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
* Init! Calcule les pentes
AmMvI:    lea    -2(a3),a0
    move.l    a0,AmPos(a6)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.l    a3,AmFin(a6)
    tst.w    d3
    bgt.s    AmMi1
    moveq    #1,d3
AmMi1:    move.w    d3,AmCpt(a6)
    move.w    (sp)+,d1
    move.w    (sp)+,d0
    moveq    #0,d2
    ext.l    d0
    bpl.s    AmMi2
    neg.l    d0
    bset    #0,d2
AmMi2:    ext.l    d1
    bpl.s    AmMi3
    neg.l    d1
    bset    #1,d2
AmMi3:    lsl.l    #8,d0
    lsl.l    #8,d1
    divu    d3,d0
    bvc.s    AmMi4
    moveq    #0,d0
AmMi4:    divu    d3,d1
    bvc.s    AmMi5
    moveq    #0,d1
AmMi5:    btst    #0,d2
    beq.s    AmMi6
    neg.w    d0
AmMi6:    btst    #1,d2
    beq.s    AmMi7
    neg.w    d1
AmMi7:    ext.l    d0
    ext.l    d1
    lsl.l    #8,d0
    lsl.l    #8,d1
    move.l    d0,AmDeltX(a6)
    move.l    d1,AmDeltY(a6)
    move.l    AmAct(a6),a0
    move.w    2(a0),d2
    swap    d2
    move.w    #$8000,d2
    move.w    4(a0),d3
    swap    d3
    move.w    #$8000,d3
    add.l    d2,d0
    add.l    d3,d1
    bra    AmMv0

******* PLAY n
AmPlay:    subq.w    #1,AmCpt(a6)
    bmi    AmPli
    bne    AmX
AmPl0:    move.w    AmIRegs+NbInterne*2-4(a6),d2
    bmi    AmMvX
    move.l    AmAct(a6),a0
* Pas suivant en X
    move.l    AmDeltX(a6),a1
    move.b    (a1),d0
    beq    AmMvX
    bmi    AmPWx
    lsl.b    #1,d0
    asr.b    #1,d0
    ext.w    d0
    bset    #1,(a0)
    bset    d4,d5
    tst.w    d2
    beq.s    AmPx1
    add.w    d0,2(a0)
    addq.l    #1,AmDeltX(a6)
    bra.s    AmPy
AmPx1:    sub.w    d0,2(a0)
    subq.l    #1,AmDeltX(a6)
    bra.s    AmPy
* Attente en X!
AmPWx:    subq.w    #1,AmVirgX(a6)
    beq.s    Ampwx1
    bpl.s    Ampy
    and.w    #$7f,d0
    beq.s    Ampwx1
    move.w    d0,AmVirgX(a6)
    bra.s    AmPy
Ampwx1:    tst.w    d2
    bne.s    Ampwx2
    subq.l    #1,AmDeltX(a6)
    bra.s    AmPy
Ampwx2:    addq.l    #1,AmDeltX(a6)
* Pas suivant en Y
AmPy:    move.l    AmDeltY(a6),a1
    move.b    (a1),d0
    beq    AmMvX
    bmi    AmPWy
    lsl.b    #1,d0
    asr.b    #1,d0
    ext.w    d0
    bset    #2,(a0)
    bset    d4,d5
    tst.w    d2
    beq.s    AmPy1
    add.w    d0,4(a0)
    addq.l    #1,AmDeltY(a6)
    bra.s    Ampwy3
AmPy1:    sub.w    d0,4(a0)
    subq.l    #1,AmDeltY(a6)
    bra.s    Ampwy3
* Attente en Y!
AmPWy:    subq.w    #1,AmVirgY(a6)
    beq.s    Ampwy1
    bpl.s    Ampwy3
    and.w    #$7f,d0
    beq.s    Ampwy1
    move.w    d0,AmVirgY(a6)
    bra.s    Ampwy3
Ampwy1:    tst.w    d2
    bne.s    Ampwy2
    subq.l    #1,AmDeltY(a6)
    bra.s    Ampwy3
Ampwy2:    addq.l    #1,AmDeltY(a6)
Ampwy3:    move.w    AmIRegs+NbInterne*2-2(a6),AmCpt(a6)
    rts
******* Initialisation!
AmPli:    lea    -2(a3),a0
    move.l    a0,AmPos(a6)
    bsr    AmEvalue
    move.l    a3,AmFin(a6)
    move.l    T_AmBank(a5),d0
    beq    AmMvX
    move.l    d0,a0
    cmp.w    4(a0),d3
    bhi    AmMvX
    lsl.w    #1,d3
    beq    AmMvX
    move.w    4+2-2(a0,d3.w),d3
    beq    AmMvX
    lsl.w    #1,d3
    lea    4(a0,d3.w),a0
    move.w    (a0)+,AmIRegs+NbInterne*2-2(a6)
    move.w    #1,AmIRegs+NbInterne*2-4(a6)
    move.w    (a0)+,d0
    lea    -4+1(a0,d0.w),a1
    move.l    a1,AmDeltY(a6)
    addq.l    #1,a0
    move.l    a0,AmDeltX(a6)
    clr.w    AmVirgX(a6)
    clr.w    AmVirgY(a6)
    bra    AmPl0

******* ANIM 
AmAni:    bsr    AmEvalue        * Initialise l''animation!
    move.w    d3,AmACLoop(a6)
    move.w    #1,AmACpt(a6)
    lea    2(a3),a0
    move.l    a0,AmAAd(a6)
    move.l    a0,AmAALoop(a6)
    lea    AmDoAni(pc),a0
    move.l    a0,AmAJsr(a6)
    add.w    (a3),a3
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
AmDoAni    subq.w    #1,AmACpt(a6)        * Fait l''animation
    bne.s    AmDAX
    move.l    AmAAd(a6),a3
AmDA0    tst.w    (a3)
    beq.s    AmDA1
    bsr    AmEvalue
    move.l    AmAct(a6),a0
    move.w    d3,6(a0)
    bset    #0,(a0)
    bset    d4,d5
    bsr    AmEvalue
    move.w    d3,AmACpt(a6)
    move.l    a3,AmAAd(a6)
AmDAX    rts
AmDA1    tst.w    AmACLoop(a6)
    beq    AmDA2
    subq.w    #1,AmACLoop(a6)
    beq.s    AmDA3
AmDA2    move.l    AmAALoop(a6),a3
    bra.s    AmDA0
AmDA3    clr.l    AmAJsr(a6)
    rts

******* ST-ANIMATION
AmAnim:    move.w    #1,AmACpt(a6)
    move.l    a3,AmAAd(a6)
    move.l    a3,AmAALoop(a6)
    lea    StAni(pc),a0
    move.l    a0,AmAJsr(a6)
    clr.l    AmPos(a6)
    rts
StAni:    subq.w    #1,AmACpt(a6)
    bne.s    StA1
    move.l    AmAAd(a6),a3
StA0    move.w    (a3)+,d0
    bmi.s    StA2
    move.l    AmAct(a6),a0
    move.w    d0,6(a0)
    bset    #0,(a0)
    bset    d4,d5
    move.w    (a3)+,AmACpt(a6)
    beq.s    StA3
    move.l    a3,AmAAd(a6)
StA1    rts
StA2    cmp.w    #-1,d0
    beq.s    StA3
    move.l    AmAALoop(a6),a3
    bra.s    StA0
StA3    clr.l    AmAJsr(a6)
    rts

******* ST-MOUVEMENT EN X
AmMvtX:    move.w    #1,AmACpt(a6)
    move.l    a3,AmAALoop(a6)
    lea    StMvX(pc),a0
    move.l    a0,AmAJsr(a6)
    clr.l    AmPos(a6)
    moveq    #1,d1
    move.l    AmAct(a6),a0
    lea    2(a0),a1
    bra    StML
******* ST-MOUVEMENT EN Y
AmMvtY:    move.w    #1,AmACpt(a6)
    move.l    a3,AmAALoop(a6)
    lea    StMvY(pc),a0
    move.l    a0,AmAJsr(a6)
    clr.l    AmPos(a6)
    moveq    #2,d1
    move.l    AmAct(a6),a0
    lea    4(a0),a1
    bra    StML
* Entree MOVE X
StMvX    subq.w    #1,AmACpt(a6)
    bne.s    StMXx
    moveq    #1,d1
    move.l    AmAct(a6),a0
    lea    2(a0),a1
    bra.s    StM0
* Entree MOVE Y
StMvY    subq.w    #1,AmACpt(a6)
    bne.s    StMXx
    moveq    #2,d1
    move.l    AmAct(a6),a0
    lea    4(a0),a1
* Fait le mouvement
StM0    move.l    AmAAd(a6),a3
    move.w    (a3)+,AmACpt(a6)
    move.w    (a1),d0
    add.w    (a3)+,d0
    move.w    d0,(a1)
    bset    d1,(a0)
    bset    d4,d5
    cmp.w    AmDeltY(a6),d0        * Condition?
    beq.s    StM2
    subq.w    #1,AmDeltX(a6)        * Encore un mouvement?
    beq.s    StM1
StMXx:    rts
* Mouvement suivant
StM1    addq.l    #2,a3
    tst.w    (a3)
    bne.s    StM4
* Condition realisee: on boucle?
StM2:    move.l    AmAALoop(a6),a3
    tst.w    2(a3)
    beq.s    StMF
StML:    move.w    (a3)+,d0        * Reinitialisation
    cmp.w    #$8000,d0
    beq.s    StM3
    move.w    d0,(a1)
    bset    d1,(a0)
    bset    d4,d5
StM3:    addq.l    #2,a3
    move.w    (a3)+,AmDeltY(a6)
StM4:    move.l    a3,AmAAd(a6)
    move.w    4(a3),AmDeltX(a6)
    rts
StMF:    clr.l    AmAJsr(a6)
    rts

******* AUTOTEST ON
AmAOn:    move.w    (a3)+,d0
    move.l    a3,AmAuto(a6)
    lea    -2(a3,d0.w),a3
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
******* AUTOTEST OFF
AmAOff:    clr.l    AmAuto(a6)
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
******* AUTOTEST EXIT
AmAExit:rts
******* DIRECT label
AmDirect:
    move.w    (a3)+,d0
    lea    -2(a3,d0.w),a0
    move.l    a0,AmPos(a6)
    clr.w    AmCpt(a6)
    rts

******* STOP GENERAL!
AmStop:    clr.l    AmPos(a6)
    clr.l    AmAuto(a6)
    rts
******* WAIT VBL
AmPose:    move.l    a3,AmPos(a6)
    rts
******* WAIT
AmWait:    clr.l    AmPos(a6)
    rts
******* RIEN
AmRien:    move.w    (a3)+,d0
    jmp    0(a4,d0.w)

******* LET 
AmLet:    bsr    AmEvalue
    move.w    (a3)+,d0
    jsr    0(a4,d0.w)
    move.w    d3,(a0)
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)

******* IF
AmIf:    bsr    AmEvalue
    tst.w    d3
    bne.s    AmIfV
    addq.l    #4,a3
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
AmIfV:    move.w    (a3)+,d0
    jmp    0(a4,d0.w)

******* FOR
AmFor:    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    lea    T_AmRegs(a5),a0
    move.w    (a3)+,d0
    bpl.s    AmFr0
    lea    AmIRegs+NbInterne*2(a6),a0
AmFr0:    move.w    (sp)+,0(a0,d0.w)
    move.w    d3,(a3)+
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
******* NEXT
AmNxt:    move.w    (a3)+,d0
    lea    -2(a3,d0.w),a1
    lea    T_AmRegs(a5),a0
    move.w    (a1)+,d0
    bpl.s    AnNx0
    lea    AmIRegs+NbInterne*2(a6),a0
AnNx0:    add.w    d0,a0
    addq.w    #1,(a0)
    move.w    (a1)+,d0
    cmp.w    (a0),d0
    bge.s    AmNx1
* Sortie, on continue
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
* On reste dans la boucle
AmNx1:    move.l    a1,AmPos(a6)
    rts

******* JUMP
AmJump:    add.w    (a3),a3
    subq.w    #1,d6
    beq.s    AmJp1
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)
AmJp1    lea    AmRet(pc),a0
    cmp.l    (sp),a0
    bne.s    AmJp2
    move.l    a3,AmPos(a6)
AmJp2    rts

******* A=
AmAEg:    move.l    AmAct(a6),a0
    bset    #0,(a0)
    bset    d4,d5
    addq.l    #6,a0
    rts
******* X=
AmXEg:    move.l    AmAct(a6),a0
    bset    #1,(a0)
    bset    d4,d5
    addq.l    #2,a0
    rts
******* Y=
AmYEg:    move.l    AmAct(a6),a0
    bset    #2,(a0)
    bset    d4,d5
    addq.l    #4,a0
    rts
******* REG=
AmREg:    move.w    (a3)+,d0
    bmi.s    AmREg0
    lea    T_AmRegs(a5),a0
    add.w    d0,a0
    rts
AmREg0:    lea    AmIRegs+NbInterne*2(a6),a0
    add.w    d0,a0
    rts

******* EVALUATION D''EXPRESSION
AmEvalue:
    move.w    (a3)+,d0
    jsr    0(a4,d0.w)
    move.w    d2,d3
AmELoop    move.w    (a3)+,d0
    jsr    0(a4,d0.w)
    move.w    (a3)+,d0
    jmp    0(a4,d0.w)

* =XH(Ec,X)
AmXH:    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d1
    bsr    AmEcTo
    tst.w    EcCon0(a0)
    bpl.s    AmXH0
    asr.w    #1,d2
AmXH0:    add.w    EcWX(a0),d2
    move.w    (sp)+,d3
    rts
* =YH(Ec,Y)
AmYH:    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d1
    bsr    AmEcTo
    add.w    EcWY(a0),d2
    sub.w    #EcYBase,d2
    move.w    (sp)+,d3
    rts
* =XS(Ec,X)
AmXS:    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d1
    bsr    AmEcTo
    sub.w    EcWx(a0),d2
    btst    #7,EcCon0(a0)
    beq.s    AmXs1
    asl.w    #1,d2
AmXs1:    add.w    EcVx(a0),d2
    move.w    (sp)+,d3
    rts
* =YS(e,X)
AmYS:    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d1
    bsr    AmEcTo
    add.w    #EcYBase,d2
    sub.w    EcWy(a0),d2
    add.w    EcVy(a0),d2
    move.w    (sp)+,d3
    rts
* Routine: Ecto
AmEcTo    move.w    d3,d2
    and.w    #$0007,d1
    lsl.w    #2,d1
    lea    T_EcAdr(a5),a0
    move.l    0(a0,d1.w),d1
    beq.s    AmEc1
    move.l    d1,a0
    rts
AmEc1:    addq.l    #4,sp
    moveq    #-1,d2
    move.w    (sp)+,d3
    rts
* = Bob Coll
AmBCol:    move.w    T_SyncOff(a5),d0
    beq.s    AmbbX
    movem.l    d3-d7/a0-a2,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d2
    move.w    (sp)+,d1
    bsr    BbColl
    movem.l    (sp)+,d3-d7/a0-a2
    move.w    d0,d2
    rts
* = Spr Coll
AmSCol:    move.w    T_SyncOff(a5),d0
    beq.s    AmbbX
    movem.l    d3-d7/a0-a2,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d2
    move.w    (sp)+,d1
    bsr    SpColl
    movem.l    (sp)+,d3-d7/a0-a2
    move.w    d0,d2
    rts
AmBbx:    moveq    #0,d2
    rts
* = Col(n)
AmCol:    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    d3,d1
    bsr    GetCol
    move.w    d0,d2
    move.w    (sp)+,d3
    rts
* = Haz(n)
AmHaz:    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    T_AmSeed(a5),d2
    mulu    #$3171,d2
    add.w    Circuits+$06,d2
    addq.w    #1,d2
    move.w    d2,T_AmSeed(a5)
    lsr.l    #8,d2
    and.w    d3,d2
    move.w    (sp)+,d3
    rts
* =Vu(n)
AmVu    move.w    d3,-(sp)
    bsr    AmEvalue
    move.w    (sp)+,d3
    move.l    ExtAdr+0*16(a5),d0
    beq.s    AmVu0
    move.l    d0,a0
    cmp.w    #4,d2
    bcc.s    AmVu0
    add.w    d2,a0
    move.b    (a0),d2
    clr.b    (a0)
    rts
AmVu0    moveq    #0,d2
    rts
* =A
AmEgA:    move.l    AmAct(a6),a0
    move.w    6(a0),d2
    rts
* =X
AmEgX:    move.l    AmAct(a6),a0
    move.w    2(a0),d2
    rts
* =Y
AmEgY:    move.l    AmAct(a6),a0
    move.w    4(a0),d2
    rts
* =RA
AmEgR:    move.w    (a3)+,d0
    bmi.s    AEgR0
    lea    T_AmRegs(a5),a0
    move.w    0(a0,d0.w),d2
    rts
AEgR0:    lea    AmIRegs+NbInterne*2(a6),a0
    move.w    0(a0,d0.w),d2
    rts
* =On
AmOn:    tst.w    AmCpt(a6)
    bmi.s    AmO0
    beq.s    AmO0    
AmOnM:    moveq    #-1,d2
    rts
AmO0:    moveq    #0,d2
    rts
AmO1:    moveq    #1,d2
    rts

* =Chiffre
AmChif:    move.w    (a3)+,d2
    rts
* =XMouse
AmXMou:    move.w    T_XMouse(a5),d2
    rts
* =YMouse
AmYMou:    move.w    T_Ymouse(a5),d2
    rts
* =Joy0
AmJ0:    moveq    #0,d1
    bsr    ClJoy
    move.w    d1,d2
    rts
* =Joy1
AmJ1:    moveq    #1,d1
    bsr    ClJoy
    move.w    d1,d2
    rts
* = Mousekey1
AmM1:    moveq    #0,d2
    btst    #6,CiaAPrA
    bne.s    AmMx
    moveq    #-1,d2
AmMx:    rts
* = Mousekey 2
AmM2:    moveq    #0,d2
    btst    #10,$DFF016
    beq.s    AmMx
    moveq    #-1,d2
    rts
    
******* OPERATEURS

* Fin de l''evaluation
AmSExp:    addq.l    #4,sp
    rts
* =
AmEg:    cmp.w    d3,d2
    bne.s    AmEF
AmEV:    moveq    #-1,d3
    bra    AmELoop
AmEF:    moveq    #0,d3
    bra    AmELoop
* <
AmInf:    cmp.w    d2,d3
    blt.s    AmEV
    bra.s    AmEF
* >
AmSup:    cmp.w    d2,d3
    bgt.s    AmEv
    bra.s    AmEF
* <>
AmDif:    cmp.w    d2,d3
    bne.s    AmEV
    bra.s    AmEF
* +
AmPlus:    add.w    d2,d3
    bra    AmELoop
* -
AmMoins    sub.w    d2,d3
    bra    AmELoop
* /
AmDiv:    tst.w    d2
    beq    AmELoop
    ext.l    d3
    divs    d2,d3
    bra    AmELoop
* *
AmMult:    ext.l    d3
    muls    d2,d3
    bra    AmELoop
* |
AmOr:    or.w    d2,d3
    bra    AmELoop
* !
AmXor:    eor.w    d2,d3
    bra    AmELoop
* &
AmAnd:    and.w    d2,d3
    bra    AmELoop
    ENDC
