; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     ROUTINES AU MILIEU!
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Icestart: branch system functions only.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IceStart
    move.l    a6,-(sp)

    clr.w    T_WVersion(a5)        Par defaut
    cmp.l    #"V2.0",d0        Le magic
    bne.s    .Nomagic
    move.w    d1,T_WVersion(a5)    La version d''AMOS
.Nomagic

    lea    W_Base(pc),a0
    move.l    a5,(a0)
    lea    SyIn(pc),a0
    move.l    a0,T_SyVect(a5)
    bsr    WMemInit
   
; Recherche et stoppe les programmes AMOS lancés... (si AMOSPro V2.0)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cmp.w    #$0200,T_WVersion(a5)
    bcs.s    .No20
    move.l    $4.w,a6
    jsr    Forbid(a6)
    lea    TaskName(pc),a1
    jsr    FindTask(a6)
    tst.l    d0
    beq.s    .skip
    move.l    d0,a0
    move.l    10(a0),a1
    move.b    #"S",(a1)        * STOP!!!
    move.l    a1,T_Stopped(a5)
.skip    jsr    Permit(a6)
; Change son propre nom...
    sub.l    a1,a1
    jsr    FindTask(a6)
    move.l    d0,a0
    move.l    d0,T_MyTask(a5)
    move.l    10(a0),T_OldName(a5)
    lea    TaskName(pc),a1
    move.l    a1,10(a0)
    move.l    a5,$58(a0)        Adresse des datas...
; Fini!
.No20    move.l    (sp)+,a6
    move.l    #"W2.0",d0        Retourne des magic
    move.w    #$0200,d1
    rts

; Normal cold start: start default system
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
StartAll
    movem.l    a0-a6/d1-d7,-(sp)
    move.l    sp,T_GPile(a5)

    move.l    a2,-(sp)            Palette par defaut
    move.l    a0,-(sp)
    
; Attend que l''autre AMOS soit arrete! (si v2.0)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cmp.w    #$0200,T_WVersion(a5)
    bcs.s    .No20_a
    movem.l    a0-a3/d0-d3,-(sp)
    move.l    T_Stopped(a5),d0
    beq.s    .Wait2
    move.l    d0,a2
    move.w    #50*5,d3
.Wait1    move.l    T_GfxBase(a5),a6
    jsr    -270(a6)
    cmp.b    #"S",(a2)
    bne.s    .Wait2
    dbra    d3,.Wait1
.GoEnd    bra    GFatal
.Wait2    movem.l    (sp)+,a0-a3/d0-d3
.No20_a

; Sauve les flags du DMA
; ~~~~~~~~~~~~~~~~~~~~~~
    move.b    d0,T_AMOSHere(a5)
    move.w    Circuits+DmaConR,T_OldDma(a5)
    bset    #7,T_OldDma(a5)

; Amiga-A
; ~~~~~~~
    tst.l    d1
    bne.s    .Skip
    move.l    #$00406141,d1
.Skip    move.b    d1,T_AmigA_Ascii1(a5)
    lsr.l    #8,d1
    move.b    d1,T_AmigA_Ascii2(a5)
    lsr.w    #8,d1
    move.b    d1,T_AmigA_Shifts(a5)
; Mouse.Abk (si v2.0)
; ~~~~~~~~~~~~~~~~~~~
    cmp.w    #2,T_WVersion(a5)
    bcs.s    .No20_b
    move.l    a1,d0
    bne.s    .MSkip    
    move.l    WDebut-4(pc),d0            Prend le HUNK suivant
    lsl.l    #2,d0
    move.l    d0,a1
    addq.l    #4,a1
.MSkip    cmp.l    #"AmSp",(a1)+
    bne    GFatal
    move.w    (a1)+,d1
    cmp.w    #4,d1
    bcs    GFatal
    move.l    a1,T_MouBank(a5)
; Pointe la palette pour l''ouverture des ecrans
    subq.w    #1,d1
.MLoop    move.w    (a1)+,d0
    mulu    (a1)+,d0
    mulu    (a1)+,d0
    lsl.l    #1,d0
    lea    4(a1,d0.l),a1
    dbra    d1,.MLoop
    move.w    #-1,(a1)        Stoppe la mouse.abk
    lea    16*2(a1),a1        Pointe couleurs 16-32
    lea    16*2(a2),a2        Couleurs 16-32 de default palette
    moveq    #15,d0
.PCopy    move.w    (a1)+,(a2)+
    dbra    d0,.PCopy
.No20_b

; Ouverture de la fonte systeme 8x8
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    lea    TopazName(pc),a1    Topaz force si <2.0
    cmp.w    #$0200,T_WVersion(a5)
    bcs.s    .Sfont
    move.l    a3,d0            Sinon, fonte dans a3
    beq.s    .Sfont
    tst.b    (a3)
    beq.s    .Sfont
    move.l    a3,a1
.Sfont    lea    -8(sp),sp
    move.l    sp,a0
    move.l    a1,(a0)
    move.w    #8,4(a0)
    move.w    #$0041,6(a0)
    move.l    T_GfxBase(a5),a6
    jsr    _LVOOpenFont(a6)
    move.l    d0,T_DefaultFont(a5)
    bne.s    .fOk
    lea    TopazName(pc),a1
    move.l    sp,a0            On ressaie avec topaz
    move.l    a1,(a0)
    move.w    #8,4(a0)
    move.w    #$0041,6(a0)
    jsr    _LVOOpenFont(a6)
    move.l    d0,T_DefaultFont(a5)
    beq    GFatal            ???
.fOk    addq.l    #8,sp

; Graphic library
; ~~~~~~~~~~~~~~~
    lea    GfxBase(pc),a1
    move.l    T_GfxBase(a5),a0
    move.l    a0,(a1)
    clr.b    T_WFlags(a5)            Flag AA
    btst    #2,236(a0)
    beq.s    .PaAA
    bset    #WFlag_AA,T_WFlags(a5)
    bset    #WFlag_LoadView,T_WFlags(a5)
.PaAA    move.l    $4.w,a0                Kickstart >= V39?
    cmp.w    #39,$14(a0)            Si oui, on fait un LoadView(0)
    bcs.s    .Pa39
    bset    #WFlag_LoadView,T_WFlags(a5)
.Pa39
    IFNE    Debug=2                Si debug
    bclr    #WFlag_LoadView,T_WFlags(a5)    AMIGA-A normal...
    ENDC


; Ma propre tache
; ~~~~~~~~~~~~~~~
    sub.l    a1,a1
    move.l    $4.w,a6
    jsr    FindTask(a6)
    move.l    d0,T_MyTask(a5)
    move.l    d0,a0

; Ouverture du layer.library
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
    moveq    #0,d0
    lea    LayName(pc),a1
    move.l    $4.w,a6
    jsr    OpenLib(a6)
    move.l    d0,T_LayBase(a5)
    beq    GFatal

; Branche l''input.device
; ~~~~~~~~~~~~~~~~~~~~~~
    bsr    ClInit
; Open Console Device        
; ~~~~~~~~~~~~~~~~~~~
    lea    ConIo(pc),a1
    bsr    OpConsole
; Branche le input_handler
; ~~~~~~~~~~~~~~~~~~~~~~~~
    lea    T_IoDevice(a5),a1
    bsr    OpInput
    lea    T_Interrupt(a5),a0
    lea    IoHandler(pc),a1
    move.l    a1,IS_CODE(a0)
    clr.l    IS_DATA(a0)
    move.b    #100,ln_pri(a0)
    lea    T_IoDevice(a5),a1
    move.l    a0,io_Data(a1)
    move.w    #IND_ADDHANDLER,io_command(a1)
    jsr    _LVODoIo(a6)
    move.w    #-1,T_DevHere(a5)

; ***************************************
; Default screens parameters 
; ***************************************
    move.l     (sp),a0    
    move.w     #129,T_DefWX(a5)
    move.w     #129-16,T_DefWX2(a5)
    move.w     10(a0),T_DefWY(a5)
    move.w     10(a0),T_DefWY2(a5)
    subq.w     #8,T_DefWY2(a5)

    lea        Circuits,a6
    move.l     (sp),a0
    move.l     16(a0),d0
    bsr        HsInit                  ; Init Hard Sprites
    move.l     (sp),a0
    move.w     8(a0),d0
    bsr        BbInit                  ; Blitter Objects (Bobs) Init
    bsr        RbInit                  ; Blitter Objects (Bobs) Reverser (French : Retourneur)
    move.l     (sp),a0
    move.l     12(a0),d0
    bsr        CpInit                  ; Setup Copper
    bsr        EcInit                  ; Setup Screens
    bsr        ampLib_Init             ; 2020.11.22 Setup AmosProLib_ExtractedMethods branchment list
;    bsr        colorSupport_Init       ; 2021.02.12 Removed // 2020.12.05 Setup for Advanced Color Support for Colors Datas Format Conversions
    bsr        SyInit                  ; System Setup
    bsr        VBLInit                 ; VBL Interrupts Setup 
    bsr        WiInit                  ; Windows Setup

; ***************************************
; If AA, modify the LOADVIEW Vector
; ***************************************
    btst       #WFlag_LoadView,T_WFlags(a5)    Si LoadView en route
    beq.s      .NoLoadView
    lea        AMOS_LoadView(pc),a0
    lea        T_AMOSHere(a5),a1        Adresse du test
    move.l     a1,2(a0)            >>> dans le source...
    move.l     a0,d0                Nouvelle fonction
    move.w     #-222,a0            LOADVIEW
    move.l     T_GfxBase(a5),a1        Librairie
    move.l     $4.w,a6
    jsr        -420(a6)            Set function
    lea        Old_LoadView(pc),a0        Ancien vecteur
    move.l     d0,(a0)
    bsr        Sys_ClearCache            Nettoie les caches!
.NoLoadView    

; ***************************************
; Requester Branchment
; ***************************************
    cmp.w      #$0200,T_WVersion(a5)
    bcs.s      .No20_c
    move.l     4(sp),a0            Palette par defaut
    bsr        WRequest_Start
; ***************************************
; Build the default font
; ***************************************
    bsr        Wi_MakeFonte
    bne        GFatal
.No20_c:

; ***************************************
; Everything setup correctly ? Send AMOS to front ?
; ***************************************
    tst.b      T_AMOSHere(a5)
    beq.s      .Pafr
    clr.b      T_AMOSHere(a5)
    moveq      #1,d1
    bsr        TAMOSWb
.Pafr:

; ***************************************
; No error.
; ***************************************
    moveq      #0,d0
    bra.s      GFini

; ***************************************
; Errors happened during setup. Clear everything and go back to Cli/WB
; ***************************************
GFatal:
    bsr.s      EndAll
    moveq      #-1,d0

; ***************************************
; Setup End
; ***************************************
GFini:
    move.l     T_GPile(a5),a7
    movem.l    (sp)+,a0-a6/d1-d7
    rts
