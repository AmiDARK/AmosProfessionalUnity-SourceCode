;                            Arret general
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EndAll:
    lea    Circuits,a6

;    Remet l''ecran du workbench
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    moveq    #0,d1    
    bsr    TAMOSWb
    moveq    #2,d0
    bsr    WVbl_d0

; Empeche le switcher de fonctionner (si 2.0)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cmp.w    #$0200,T_WVersion(a5)
    bcs.s    .No20_a
    moveq    #Switcher_Signal+1,d3
    bsr    Send_Switcher
;     Plus de requester
; ~~~~~~~~~~~~~~~~~~~~~~~
    bsr    WRequest_Stop
;    Efface la fonte
; ~~~~~~~~~~~~~~~~~~~~~
    bsr    Wi_DelFonte
.No20_a
    
;    Si AA, remet le vecteur LOADVIEW
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    btst    #WFlag_LoadView,T_WFlags(a5)    Si LoadView en route
    beq.s    .NoLoadView
    move.l    Old_LoadView(pc),d0        Ancienne fonction
    beq.s    .NoLoadView
    move.w    #-222,a0            LOADVIEW
    move.l    T_GfxBase(a5),a1        Librairie
    move.l    $4.w,a6
    jsr    -420(a6)            Set function
.NoLoadView    

;    Debranche l''input.device
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    tst.w    T_DevHere(a5)
    beq.s    .skip0
    lea    T_Interrupt(a5),a0
    lea    T_IoDevice(a5),a1
    move.l    a0,io_Data(a1)
    move.w    #IND_REMHANDLER,Io_Command(a1)    
    move.l    $4.w,a6
    jsr    _LVODoIo(a6)
    lea    T_IoDevice(a5),a1
    bsr    ClInput
.Skip0

;     Arret des toutes les fonctions AMOS
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    bsr    TFFonts
;    bsr    WiEnd            Rts!
    bsr    SyEnd
    bsr    EcEnd
    bsr    RbEnd
    bsr    BbEnd
    bsr    HsEnd
    bsr    VBLEnd
    bsr    CpEnd

;    Ferme les librairies
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l    $4.w,a6        
    move.l    T_FntBase(a5),d0        diskfont.library
    beq.s    .Lib0
    move.l    d0,a1
    jsr     CloseLib(a6)
.Lib0    move.l    T_LayBase(a5),d0        layer.library
    beq.s    .Lib1
    move.l    d0,a1
    jsr     CloseLib(a6)
.Lib1    move.l    T_GfxBase(a5),d0        graphics.library
    beq.s    .Lib2
    move.l    d0,a6                Ferme la fonte par defaut
    move.l    T_DefaultFont(a5),d0
    beq.s    .Lib2
    move.l    d0,a1
    jsr    _LVOCloseFont(a6)
.Lib2    
    moveq    #0,d0
    rts

; Fin d''access au fonctions systeme
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IceEnd
; Relance l''ancien AMOS (si 2.0)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cmp.w    #$0200,T_WVersion(a5)
    bcs.s    .No20_a
    move.l    T_Stopped(a5),d0
    beq.s    .Skup
    move.l    d0,a0
    move.b    #" ",(a0)
; Remet son ancien nom
.Skup    move.l    T_MyTask(a5),d0
    beq.s    .Skiip
    move.l    d0,a0    
    move.l    T_OldName(a5),10(a0)
.Skiip
.No20_a
; Enleve la gestion memoire si definie
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    bsr    WMemEnd            Plus de memory checking!
    rts
