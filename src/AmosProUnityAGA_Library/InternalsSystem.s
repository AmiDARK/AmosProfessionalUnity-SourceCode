
;    Envoie un signal à l''AMOS_Switcher (D3= signal)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Send_Switcher
    lea    Switcher(pc),a1
    move.l    $4.w,a6
    jsr    _LVOFindTask(a6)
    tst.l    d0
    beq.s    .PaSwi
    move.l    d0,a1
    moveq    #0,d0
    bset    d3,d0
    jsr    _LVOSignal(a6)
.PaSwi    rts




;    Fabrique la fonte par defaut
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Wi_MakeFonte
    movem.l    a2/d2-d7,-(sp)
    moveq    #0,d1            Ecran 16x8, 2 couleur
    moveq    #16,d2
    moveq    #8,d3
    moveq    #1,d4
    moveq    #0,d5
    moveq    #2,d6
    lea    Wi_MakeFonte(pc),a1
    bsr    EcCree
    bne    .Error
; Boucle de creation
    move.l    #8*256,d0
    SyCall    MemFastClear
    beq    .Error
    move.l    a0,T_JeuDefo(a5)
    move.l    a0,a2
    lea    32*8(a2),a0
    moveq    #32,d2
    move.w    #128,d3
    bsr    .CreeFont
    lea    160*8(a2),a0
    move.w    #160,d2
    move.w    #256,d3
    bsr    .CreeFont
; Poke les caracteres specifiques
    lea    Def_Font(pc),a0
    move.l    a2,a1
    moveq    #(8*32)/4-1,d0
.Copy1    move.l    (a0)+,(a1)+
    dbra    d0,.Copy1
    lea    128*8(a2),a1
    moveq    #(8*32)/4-1,d0
.Copy2    move.l    (a0)+,(a1)+
    dbra    d0,.Copy2
; A y est!
    moveq    #0,d0
    bra.s    .Out
; Erreur
.Error    moveq    #1,d0
; Sortie!
.Out    move.l    d0,-(sp)
    moveq    #0,d0
    bsr    EcDel
    move.l    (sp)+,d0
    movem.l    (sp)+,a2/d2-d7
    rts
; Saisit les caracteres d2-d3
.CreeFont
    movem.l    d2/d3/a2/a3/a6,-(sp)
    move.l    a0,a2
    move.l    T_EcCourant(a5),a3
.Car    move.l    T_RastPort(a5),a1        Le rastport
    move.w    #0,36(a1)            Curseur en 0,0
    move.w    #6,38(a1)
    moveq    #1,d0                Un caractere
    lea    .COut(pc),a0            
    move.b    d2,(a0)
    move.l    T_GfxBase(a5),a6        La fonction
    jsr    _LVOText(a6)
    move.l    EcLogic(a3),a0            Boucle de recopie
    move.w    EcTligne(a3),d0
    ext.l    d0
    moveq    #7,d1
.Loop    move.b    (a0),(a2)+
    add.l    d0,a0
    dbra    d1,.Loop
    addq.w    #1,d2
    cmp.w    d3,d2
    bcs.s    .Car
    movem.l    (sp)+,d2/d3/a2/a3/a6
    rts
.COut    dc.w    0

;    Effacement du jeu de caracteres
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Wi_DelFonte
    move.l    T_JeuDefo(a5),d0    
    beq.s    .Sip
    move.l    d0,a1
    move.l    #8*256,d0
    SyCall    MemFree
    clr.l    T_JeuDefo(a5)
.Sip    rts

***********************************************************
* Librairies
FntName:    dc.b    "diskfont.library",0
DevName     dc.b    "input.device",0
ConName     dc.b    "console.device",0
LayName     dc.b    "layers.library",0
TopazName   dc.b    "topaz.font",0
Switcher    dc.b    "_Switcher AMOS_",0
TaskName    dc.b    " AMOS",0
        even
***********************************************************

;     Patch sur LOADVIEW si AMOS TO FRONT si AA
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMOS_LoadView
    tst.b    0.l            T_AMOSHere, modifie lors du patch...
    bne.s    .Wb
    move.l    Old_LoadView(pc),-(sp)
.Wb    rts    
Old_LoadView    dc.l    0        Ici et pas ailleurs...

; AMOS / WORKBENCH
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    D1=0    >     Workbench
;    D1>0    >    AMOS
;    D1<0    >    Rien (trouver valeur)
;    Retour D1= AMOS ici(-1), WB ici (0)
TAMOSWb
    tst.w    d1
    beq    .ToWB
    bmi    .Return

;     Back to AMOS
; ~~~~~~~~~~~~~~~~~~
.ToAMOS    tst.b    T_AMOSHere(a5)
    bne    .Return
    move.b    #-1,T_AMOSHere+1(a5)        Code interdisant les requester

; Load View(0) + WaitTOF si AA
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    btst    #WFlag_LoadView,T_WFlags(a5)
    beq.s    .PaAA0
    movem.l    d0-d3/a0-a2/a6,-(sp)

    move.l    T_IntBase(a5),a6        Ouvre un ecran LOWRES

    btst    #WFlag_WBClosed,T_WFlags(a5)    Si WB ferme, le referme!
    beq.s    .NoWB
    jsr    -78(a6)            
.NoWB
    move.l  T_GfxBase(a5),a6        WaitTOF
    move.l  34(a6),T_ViewPort(a5)
    move.l  #0,a1
    jsr -222(a6)                LoadView
    jsr -$10e(a6)
    jsr -$10e(a6)
    
    move.w     #%0000110000000000,$dff106     Sprite width / DualPF palette
.NoBug

    movem.l    (sp)+,d0-d3/a0-a2/a6
.PaAA0    
    lea    Circuits,a0            Remet les circuits
    move.w    #$8080,JoyTest(a0)
    move.l     T_CopPhysic(a5),$80(a0)
    clr.w     $88(a0)
    move.b    #-1,T_AMOSHere(a5)        AMOS en front!
    clr.b    T_AMOSHere+1(a5)        Flip termine!
    bra.s    .Return

;     Goto workbench
; ~~~~~~~~~~~~~~~~~~~~
.ToWB    tst.b    T_AMOSHere(a5)
    beq.s    .Return
    clr.b    T_AMOSHere(a5)            AMOS en fond!
    move.b    #-1,T_AMOSHere+1(a5)        Code interdisant les requesters

    move.w    T_OldDma(a5),$Dff096        Remet les chips
    move.l  T_GfxBase(a5),a0
    move.l  38(a0),$dff080
    clr.w    $dff088

; Efface l''ecran si AA
; ~~~~~~~~~~~~~~~~~~~~
    btst    #WFlag_LoadView,T_WFlags(a5)
    beq.s    .PaAA1
    movem.l    d0-d3/a0-a2/a6,-(sp)
    move.l    T_IntBase(a5),a6        Close Screen
    btst    #WFlag_WBClosed,T_WFlags(a5)    Si WB ferme, le rouvre!
    beq.s    .NoBW
    jsr    -210(a6)            Reopen workbench
.NoBW    
    move.l  T_ViewPort(a5),a1      Close screen
    move.l  T_GfxBase(a5),a6
    jsr     -222(a6)        load view
    jsr -$10e(a6)            WaitTOF
    jsr -$10e(a6)            WaitTOF
    movem.l    (sp)+,d0-d3/a0-a2/a6
.PaAA1
    clr.b    T_AMOSHere+1(a5)        Flip termine!

; Retourne l''etat actuel
; ~~~~~~~~~~~~~~~~~~~~~~
.Return    move.b    T_AMOSHere(a5),d1
    ext.w    d1
    ext.l    d1
    moveq    #0,d0
    rts


;    Clear CPU Caches
; ~~~~~~~~~~~~~~~~~~~~~~
Sys_ClearCache
    movem.l    a0-a1/a6/d0-d1,-(sp)
    move.l    $4.w,a6
    cmp.w    #37,$14(a6)            A partir de V37
    bcs.s    .Exit
    jsr    -$27c(a6)            CacheClearU
.Exit    movem.l    (sp)+,a0-a1/a6/d0-d1
    rts



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     ZONE DE DONNE CENTRALE (BEARK)
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;     Table des sauts aux affichages texte
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TAdCol        dc.l CZero-TAdCol,CNorm-TAdCol
        dc.l CInv-TAdCol,CUn-TAdCol
        dc.l CNul-TAdCol

;        Zone de donnee externe
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ConIo        ds.b     32+8
LConBuffer    equ    64
ConBuffer    ds.b     LConBuffer
ConEssai    ds.b    32
W_Base        ds.l    1
GfxBase        ds.l    1
WRastPort    ds.l    1
FoPat        dc.w    -1
; Autoback fenetres
WiAuto        ds.b    8*6+WiSAuto+4
        even
; Table de retournement bobs
TRetour        ds.b    256

;        Caracteres speciaux des fontes AMOS
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Def_Font    IncBin    "src/bin/WFont.bin"
        even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * SYSTEME : SOURIS / CLAVIER / INTER VBL
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------

***********************************************************
*    DEMARRAGE A FROID DU SYSTEME
***********************************************************
SyInit:    
    bsr    AMALInit
    moveq    #0,d0
    rts
***********************************************************
*    ARRET FINAL DU SYSTEME
***********************************************************
SyEnd:    bsr    AMALEnd
    moveq    #0,d0
    rts


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     Initialisation / Fin du requester
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;    Demarrage du requester (a0)= default palette
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WRequest_Start
; Copy default palette    
    lea    8*2(a0),a0
    lea    Req_Pal+8*2(pc),a1
    moveq    #24-1,d0
CPal    move.w    (a0)+,(a1)+
    dbra    d0,CPal
; Branch the requester
    lea    AutoReq(pc),a2
    lea    EasyReq(pc),a3
    bsr.s    SetJump
    move.l    a2,T_PrevAuto(a5)
    move.l    a3,T_PrevEasy(a5)
    move.w    #-1,T_ReqFlag(a5)            * Default is AMOS request
    rts

;    Arret du requester
; ~~~~~~~~~~~~~~~~~~~~~~~~
WRequest_Stop
    tst.l    T_PrevAuto(a5)
    beq.s    .Skip
    move.l    T_PrevAuto(a5),a2
    move.l    T_PrevEasy(a5),a3
    bsr.s    SetJump
.Skip    rts

; Branche A2/a3 sur easy/auto request
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SetJump    movem.l    a0/a1/a6,-(sp)
    move.l    $4.w,a6
; AutoRequest
    move.l    a2,d0
    lea    -$15c,a0
    move.l    T_IntBase(a5),a1
    jsr    SetFunction(a6)
    move.l    d0,a2
; EasyRequest, seulement si wb>=2.0
    move.l    $4.w,a0
    cmp.w    #36,$14(a0)
    bcs.s    .skip
    move.l    a3,d0
    lea    -$1d4-(20*6),a0
    move.l    T_IntBase(a5),a1
    jsr    SetFunction(a6)
    move.l    d0,a3
.skip    movem.l    (sp)+,a0/a1/a6
    rts
