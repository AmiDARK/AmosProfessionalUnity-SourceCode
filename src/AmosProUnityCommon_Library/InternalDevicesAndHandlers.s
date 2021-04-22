;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * TRAPPE FENETRES
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------


; OPEN CONSOLE.DEVICE
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpConsole
    lea    ConIo(pc),a1
    moveq    #(Lio+Lmsg)/2-1,d0
.Clean    clr.w    (a1)+
    dbra    d0,.Clean
    move.l    $4.w,a6
    lea    ConName(pc),a0
    lea    ConIo(pc),a1
    moveq    #-1,d0            Console #= -1
    moveq    #0,d1
    jsr    OpenDev(a6)
    rts

; OPEN INPUT.DEVICE
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A1->     pointeur sur zone libre!!!
OpInput
    move.l    a1,-(sp)
* Clean
    moveq    #(Lio+Lmsg)/2-1,d0
OpInp1    clr.w    (a1)+
    dbra    d0,OpInp1
* Creates port
    sub.l    a1,a1
    move.l    $4.w,a6
    jsr    FindTask(a6)
    move.l    (sp),a1
    lea    Lio(a1),a1
    move.l    d0,$10(a1)
    jsr    AddPort(a6)
* Open device
    lea    DevName(pc),a0
    move.l    (sp),a1
    moveq    #0,d0
    moveq    #0,d1
    jsr    OpenDev(a6)
    move.l    (sp)+,a1
    lea    Lio(a1),a0
    move.l    a0,14(a1)
    rts

; CLOSE input.device
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInput    move.l    a1,-(sp)
; Close device
    move.l    $4.w,a6
    jsr    CloseDev(a6)
; Close port
    move.l    (sp)+,a1
    lea    Lio(a1),a1
    jsr    RemPort(a6)
    rts    

; Input handler, branche sur la chaine des inputs.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IoHandler
    move.l    a5,-(sp)
    move.l    W_Base(pc),a5
; Si inhibe, laisse TOUT passer!
    tst.w    T_Inhibit(a5)
    bne.s    I_Inhibit
; Continue...
    move.b    T_AMOSHere(a5),d4        Si AMOS pas la,
    ext.w    d4
    bne.s    .Skip
    bset    #WFlag_Event,T_WFlags(a5)    Marque des faux events!
.Skip    move.l    a0,d0
    move.l    a0,d2
    moveq    #0,d3
IeLoop    move.b    Ie_Class(a0),d1
    cmp.b    #IeClass_RawMouse,d1
    beq.s    IeMous
    cmp.b    #IeClass_Rawkey,d1
    beq    IeKey
    cmp.b    #IeClass_DiskInserted,d1
    beq.s    IeDIn
    cmp.b    #IeClass_DiskRemoved,d1
    beq.s    IeDOut
IeLp1    move.l    d2,d3
    move.l    (a0),d2
IeLp2    move.l    d2,a0
    bne.s    IeLoop
IeLpX    move.l    (sp)+,a5
    rts
I_Inhibit    
    move.l    (sp)+,a5
    move.l    a0,d0
    rts    
; Disc inserted
IeDIn    bset    #WFlag_Event,T_WFlags(a5)
    move.w    #-1,T_DiscIn(a5)
    bra.s    IeLp1
; Disc removed
IeDOut    bset    #WFlag_Event,T_WFlags(a5)
    clr.w    T_DiscIn(a5)
    bra.s    IeLp1    
; Evenement Mouse, fait le mouvement!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IeMous    tst.w    d4
    beq.s    IeLp1
    bset    #WFlag_Event,T_WFlags(a5)        Flag: un event!
    cmp.l    #Fake_Code,ie_X(a0)    Un faux evenement?
    beq.s    IeFake
IeNof    move.w    T_MouYOld(a5),d1    * Devenir des MOUSERAW
    and.w    #$0003,d1        * 0-> Normal
    beq.s    .norm            * 1-> Trash
    subq.w    #2,d1            * 2-> Tout passe
    bmi.s    IeTrash            * 3-> Mouvements seuls
    beq.s    IeLp1
; Mode key only>>> prend les touches, laisse passer les mouvements
    move.w    ie_Qualifier(a0),T_MouXOld(a5)
    and.w    #%1000111111111111,ie_Qualifier(a0)
    move.w    ie_Code(a0),d1
    and.w    #$7f,d1
    cmp.w    #IECODE_LBUTTON,d1
    beq.s    .ski1
    cmp.w    #IECODE_RBUTTON,d1
    bne.s    IeLp1
.ski1    move.w    #IECODE_NOBUTTON,ie_Code(a0)
    bra.s    IeLp1
; Mode normal>>> prend et met a la poubelle
.norm    move.w    ie_Qualifier(a0),d1
    move.w    d1,T_MouXOld(a5)
    btst    #IEQUALIFIERB_RELATIVEMOUSE,d1
    beq.s    IeTrash
    move.w    ie_X(a0),d1
    add.w    d1,T_MouseX(a5)
    move.w    ie_Y(a0),d1
    add.w    d1,T_MouseY(a5)
; Event to trash!
IeTrash    tst.l    d3
    beq.s    IeTr1
    move.l    d3,a1
    move.l    (a0),d2
    move.l    d2,(a1)
    bra    IeLp2
IeTr1    move.l    (a0),d0
    move.l    d0,a0
    bne    IeLoop
    move.l    (sp)+,a5
    rts
; Faux evenement clavier...
; ~~~~~~~~~~~~~~~~~~~~~~~~~
IeFake    cmp.w    #IEQUALIFIER_RELATIVEMOUSE,ie_Qualifier(a0)
    bne    IeNof
    clr.l    ie_X(a0)            Plus de decalage
    bra    IeLp1                On laisse passer
; Event clavier: prend le caractere au vol
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IeKey    bset    #WFlag_Event,T_WFlags(a5)
    bsr    Cla_Event
    bne.s    .IeKy1
.IeKy0    tst.w    d4        Event to trash ou non
    bne.s    IeTrash
    bra    IeLp1
; AMIGA-A pressed
; ~~~~~~~~~~~~~~~
.IeKy1    tst.w    T_NoFlip(a5)
    bne.s    .IeKy0
    btst    #WFlag_LoadView,T_WFlags(a5)
    bne.s    .AA    
; Appel de TAMOSWb, rapide...
    movem.l    a0-a1/d0-d1,-(sp)
    moveq    #0,d1
    tst.w    d4
    bne.s    .Ska
    moveq    #1,d1
.Ska    bsr    TAMOSWb
    movem.l    (sp)+,a0-a1/d0-d1
    bra    IeTrash
; Marque pour TESTS CYCLIQUES
.AA    bset    #WFlag_AmigaA,T_WFlags(a5)
    bra    IeTrash

;     Gestion des evenements clavier
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A0=    EVENT KEY
;    D4=    Flag AMOS / WB
Cla_Event
    movem.l    a0-a1/d0-d3,-(sp)
    move.w    Ie_Code(a0),d0
    bclr    #7,d0
    bne    .ClaI2
; Appui sur une touche
; ~~~~~~~~~~~~~~~~~~~~
    cmp.b    #$68,d0                Shifts>>> pas stockes
    bcc.s    .RawK
    cmp.b    #$40,d0
    bcs.s    .RawK
    cmp.b    #$60,d0
    bcc    .Cont
; Conversion a la main des codes speciaux
    lea    Cla_Special-$40(pc),a1
    move.b    0(a1,d0.w),d1
    bpl    .Rien
    cmp.b    #$FF,d1
    beq.s    .RawK
; Une touche de fonction AMOS?
    moveq    #0,d1                Ascii nul
    move.b    Ie_Qualifier+1(a0),d2        Les shifts
    btst    #6,d2
    beq.s    .FFk1
    lea    T_TFF1(a5),a1            Touches 1-10
    bra.s    .FFk2
.FFk1    btst    #7,d2                Pas AMIGA>>> Touche normale
    beq.s    .Rien
    lea    T_TFF2(a5),a1            Touches 11-20
.FFk2    move.w    d0,d2
    sub.w    #$50,d2
    mulu    #FFkLong,d2
    lea    0(a1,d2.w),a1
    tst.b    (a1)
    beq.s    .Rien
    bsr    ClPutK
    moveq    #0,d2
    bra    .ClaIX
; Appel de RAWKEYCONVERT et stockage si AMOS present
.RawK    move.b    Ie_Qualifier+1(a0),d2        Prend CONTROL
    and.b    #%11110111,Ie_Qualifier+1(a0)    Plus de CONTROL
    movem.l    a0/a2/a6,-(sp)    
    lea    ConIo(pc),a6            Structure IO
    move.l    20(a6),a6            io_device
    lea    ConBuffer(pc),a1            Buffer de sortie
    sub.l    a2,a2                Current Keymap
    moveq    #LConBuffer,d1            Longueur du buffer
    jsr    -$30(a6)            RawKeyConvert
    move.w    d0,d3
    movem.l    (sp)+,a0/a2/a6
    move.b    d2,Ie_Qualifier+1(a0)        Remet CONTROL
    move.w    Ie_Code(a0),d0
    moveq    #0,d1
    subq.w    #1,d3
    bmi.s    .Rien
    lea    ConBuffer(pc),a1            Une seule touche
    move.b    (a1),d1
.Rien    move.b    Ie_Qualifier+1(a0),d2        Les shifts!
; Amiga-A?
.A    move.b    d2,d3
    and.b    T_AmigA_Shifts(a5),d3        
    cmp.b    T_AmigA_Shifts(a5),d3
    bne.s    .AAA
    cmp.b    T_AmigA_Ascii1(a5),d1
    beq.s    .AA
    cmp.b    T_AmigA_Ascii2(a5),d1
    bne.s    .AAA
.AA    moveq    #-1,d2
    bra.s    .ClaI1    
; AMOS Not here: stop!
.AAA    tst.w    d4
    beq.s    .Cont
; Est-ce un CONTROL-C?
    btst    #3,d2
    beq.s    .Sto
    cmp.b    #"C",d1
    beq.s    .C
    cmp.b    #"c",d1
    bne.s    .Sto
.C    bset    #BitControl,T_Actualise(a5)
    bra.s    .Cont
; Stocke dans le buffer
.Sto    bsr    Cla_Stocke            On stocke!
; Change la table
.Cont    moveq    #0,d2
.ClaI1    move.w    d0,d1
    and.w    #$0007,d0
    lsr.w    #3,d1
    lea    T_ClTable(a5),a0
    bset    d0,0(a0,d1.w)
.ClaIX    tst.w    d2
    movem.l    (sp)+,a0-a1/d0-d3
    rts
; Relachement d''une touche
; ~~~~~~~~~~~~~~~~~~~~~~~~
.ClaI2    move.w    d0,d1
    and.w    #$0007,d0
    lsr.w    #3,d1
    lea    T_ClTable(a5),a1
    bclr    d0,0(a1,d1.w)
.ClaIF    moveq    #0,d0
    movem.l    (sp)+,a0-a1/d0-d3
    rts

; Table des touches $40->$5f
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
Cla_Special
    dc.b    $ff,$08,$09,$0d,$0d,$1b,$00,$00        $40>$47
    dc.b    $00,$00,$ff,$00,$1e,$1f,$1c,$1d        $48>$4f
    dc.b    $fe,$fe,$fe,$fe,$fe,$fe,$fe,$fe        $50>$57
    dc.b    $fe,$fe,$ff,$ff,$ff,$ff,$ff,$00        $58>$5f
    
; Stocke D0/D1/D2 dans le buffer clavier
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    D0    Rawkey
;    D1    Ascii
;    D2    Shifts
Cla_Stocke
    movem.l    a0/d3,-(sp)
    lea    T_ClBuffer(a5),a0
    move.w    T_ClTete(a5),d3
    addq.w    #3,d3
    cmp.w    #ClLong,d3
    bcs.s    .ClS11
    clr.w    d3
.ClS11    cmp.w    T_ClQueue(a5),d3
    beq.s    .ClS12
    move.w    d3,T_ClTete(a5)
    move.b    d2,0(a0,d3.w)
    move.b    d0,1(a0,d3.w)
    move.b    d1,2(a0,d3.w)
.ClS12    move.b    d2,-4(a0)
    move.b    d0,-3(a0)
    move.b    d1,-1(a0)
.ClSFin    movem.l    (sp)+,a0/d3
    rts

; Envoi d''un faux event souris au systeme
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WSend_FakeEvent
    movem.l    d0-d1/a1/a6,-(sp)
    lea    Fake_Event(pc),a0
    move.b    #IECLASS_RAWMOUSE,ie_Class(a0)
    clr.b    ie_SubClass(a0)    
    move.w    #IECODE_NOBUTTON,ie_Code(a0)
    move.w    #IEQUALIFIER_RELATIVEMOUSE,ie_Qualifier(a0)
    move.l    #Fake_Code,ie_X(a0)
    lea    T_IoDevice(a5),a1
    move.l    a0,io_Data(a1)
    move.w    #IND_WRITEEVENT,io_Command(a1)
    move.l    #22,io_Length(a1)
    move.l    $4.w,a6
    jsr    _LVODoIO(a6)
    movem.l    (sp)+,d0-d1/a1/a6
    rts
Fake_Code    equ    $789A789A        
; Faux evenement souris
Fake_Event    dc.l    0                0
        dc.b    IeClass_RawMouse        4
        dc.b    0                5
        dc.w    IECODE_NOBUTTON            6
        dc.w    0                8
        dc.w    0                10
        dc.w    0                12
        dc.l    0                14 Time Stamp
        dc.l    0                18   "    "
