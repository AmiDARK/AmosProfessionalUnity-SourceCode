
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     AMOS REQUESTER ROUTINES
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Req_WY        equ    100
T_Tit        equ    0
T_Text        equ    T_Tit+80
T_Gad        equ    T_Text+320
T_Size        equ    T_Gad+128

;    Set request ON / OFF
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
WRequest_OnOff
    move.w    d0,T_ReqFlag(a5)
    rts

; - - - - - - - - - - - - -
AutoReq
; - - - - - - - - - - - - -
    movem.l    a0-a6/d0-d7,-(sp)
    bsr    Req_In
    bpl.s    .Skip
    bsr    Req_Auto
    bra    Req_AMOS
.Skip    move.l    T_PrevAuto(a5),T_ScAdr(a5)
    bra.s    Req_WB


; - - - - - - - - - - - - -
EasyReq
; - - - - - - - - - - - - -
    movem.l    a0-a6/d0-d7,-(sp)
    bsr    Req_In
    bpl.s    .Skip
    bsr    Req_Easy
    bra    Req_AMOS
.Skip    move.l    T_PrevEasy(a5),T_ScAdr(a5)
    bra.s    Req_WB

;    Dispatch requester between AMOS/WB
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Req_In    move.l    W_Base(pc),a5
    tst.b    T_AMOSHere+1(a5)    If AMOS / WB flipping running?
    bne.s    Req_ANo            ...no requester at all!
    tst.w    T_ReqFlag(a5)        Ou aller?
    beq.s    Req_ANo
    bmi.s    .AMOS
; System requester?
; ~~~~~~~~~~~~~~~~~
    tst.b    WB_Closed(a5)        WB closed!
    bne.s    .AMOS
.WB    moveq    #1,d0
    rts
; AMOS requester
; ~~~~~~~~~~~~~~
.AMOS    tst.b    T_AMOSHere(a5)        AMOS here?
    beq.s    .WB
    tst.w    T_Req_On(a5)        Requester already running?
    bne.s    Req_ANo            Always no...
    moveq    #-1,d0
    rts

;    Always no!
; ~~~~~~~~~~~~~~~~
Req_ANo    addq.l    #4,sp
    movem.l    (sp)+,a0-a6/d0-d7
    moveq    #0,d0
    rts

;    WB requester
; ~~~~~~~~~~~~~~~~~~
Req_WB    move.b    T_AMOSHere(a5),d0    Is AMOS here?
    ext.w    d0
    move.w    d0,T_ReqOld(a5)
    beq.s    .skip1
    EcCalD    AMOS_WB,0        AMOS To BACK
.skip1    pea    .ret(pc)
    move.l    T_ScAdr(a5),-(sp)
    movem.l    8(sp),a0-a6/d0-d7
    rts
.ret    move.l    W_Base(pc),a5
    move.l    d0,T_Req_Pos(a5)
    move.l    d0,(sp)            en D0
    move.w    T_ReqOld(a5),d1
    beq.s    .skip2
    EcCalD    AMOS_WB,1        AMOS To FRONT
.skip2    movem.l    (sp)+,a0-a6/d0-d7    Recupere Req_Pos
    rts

;    AMOS Normal requester
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Req_AMOS
    move.w    #-1,T_Req_On(a5)    Requester ON !

    SyCall    AMALFrz
    bsr    UnMix1

    move.w    T_Req_Sx(a5),d2
    lsl.w    #3,d2
    ext.l    d2
    move.w    T_Req_Sy(a5),d3
    lsl.w    #3,d3
    ext.l    d3
    moveq    #3,d4
    move.l    #$8000,d5
    moveq    #8,d6
    moveq    #0,d7
    lea    Req_Pal(pc),a1
    EcCalD    Cree,EcReq
    bne    NoReq
    move.l    a0,T_ScAdr(a5)
    WiCalA    Print,Req_Init(pc)

; Top
; ~~~
    moveq    #0,d0
    moveq    #0,d1
    moveq    #0,d2
    moveq    #0,d3
    moveq    #4,d4
    moveq    #3*8,d5
    bsr    Copy
    moveq    #4,d0
    moveq    #1,d4
    move.w    T_Req_Sx(a5),d6
.lp1    bsr    Copy
    subq.w    #1,d6
    cmp.w    #9,d6
    bcc.s    .lp1
    moveq    #10,d0
    moveq    #4,d4
    bsr    Copy
; Middle
; ~~~~~~
    moveq    #3*8,d3
    move.w    T_Req_Sy(a5),d7
    sub.w    #6,d7
.lp2    moveq    #0,d0
    moveq    #3*8,d1
    moveq    #0,d2
    moveq    #2,d4
    moveq    #12,d5
    bsr    Copy
    moveq    #6,d0
    moveq    #1,d4
    move.w    T_Req_Sx(a5),d6
.lp3    bsr    Copy
    subq.w    #1,d6
    cmp.w    #5,d6
    bcc.s    .lp3
    moveq    #12,d0
    moveq    #2,d4
    bsr    Copy
    addq.w    #8,d3
    subq.w    #1,d7
    bne.s    .lp2
; Bottom
; ~~~~~~
    moveq    #0,d0
    moveq    #4*8+4,d1
    moveq    #0,d2
    add.w    #4,d3
    moveq    #1,d4
    moveq    #2*8+4,d5
    bsr    Copy
    moveq    #6,d0
    moveq    #1,d4
    move.w    T_Req_Sx(a5),d6
.lp4    bsr    Copy
    subq.w    #1,d6
    cmp.w    #3,d6
    bcc.s    .lp4
    moveq    #13,d0
    moveq    #1,d4
    bsr    Copy
; Bottom Left
; ~~~~~~~~~~~
    move.l    T_Req_Pos(a5),a0
.lp5    tst.b    (a0)+
    bne.s    .lp5
    sub.l    T_Req_Pos(a5),a0
    move.w    a0,d6
    moveq    #1,d0
    moveq    #4*8+4,d1
    moveq    #1,d2
    moveq    #2,d4
    moveq    #2*8,d5
    bsr    Copy
    moveq    #3,d0
    moveq    #1,d4
    subq.w    #3+1,d6
    bmi.s    .sk2
.lp6    bsr    Copy
    dbra    d6,.lp6
.sk2    moveq    #4,d0
    moveq    #2,d4
    bsr    Copy
; Bottom right
; ~~~~~~~~~~~~
    move.l    T_Req_Neg(a5),d0
    move.l    d0,a0
    beq.s    .sk1
.lp7    tst.b    (a0)+
    bne.s    .lp7
    sub.l    T_Req_Neg(a5),a0
    move.w    a0,d6
    move.w    T_Req_Sx(a5),d0
    sub.w    a0,d0
    add.b    #48-1,d0
    move.l    a1,-(sp)
    lea    XTNeg(pc),a1
    move.b    d0,(a1)
    move.l    (sp)+,a1
    moveq    #8,d0
    moveq    #4*8+4,d1
    move.w    T_Req_Sx(a5),d2
    sub.w    d6,d2
    subq.w    #2,d2
    moveq    #2,d4
    moveq    #2*8,d5
    bsr    Copy
    moveq    #10,d0
    moveq    #1,d4
    subq.w    #3+1,d6
    bmi.s    .sk3
.lp8    bsr    Copy
    dbra    d6,.lp8
.sk3    moveq    #11,d0
    moveq    #2,d4
    bsr    Copy
.sk1
; End of init
; ~~~~~~~~~~~
    SyCalD    ResZone,2
    move.w    T_Req_Sy(a5),d0
    lsl.w    #3,d0
    move.w    d0,T_Req_Sy(a5)

; Initialise background text
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
    WiCalA    Centre,T_Tit(a4)
; Print main text
; ~~~~~~~~~~~~~~~
    WiCalA    Print,Req_Main(pc)
    lea    T_Text(a4),a1
.lop    move.l    a1,-(sp)
    WiCall    Centre
    move.l    (sp)+,a1
.lop1    tst.b    (a1)+
    bne.s    .lop1
    tst.b    (a1)
    bne.s    .lop
; Positive text (left)
; ~~~~~~~~~~~~~~~~~~~~
    moveq    #1,d0
    moveq    #"0",d1
    bsr    PrtZone
; Negative text (right)
; ~~~~~~~~~~~~~~~~~~~~~
    move.l    T_Req_Neg(a5),d0
    beq.s    .NoNeg
    move.l    d0,a0
    moveq    #2,d0
    moveq    #"0",d1
    bsr    PrtZone
; Screen appearance
; ~~~~~~~~~~~~~~~~~
.NoNeg    move.l    T_ScAdr(a5),a2
    move.w    #288,d0
    move.w    T_Req_Sx(a5),d1
    lsl.w    #1,d1
    sub.w    d1,d0
    move.w    d0,EcAWX(a2)
    bset    #1,EcAW(a2)
    moveq    #8,d7
    moveq    #1,d6
    move.w    T_Req_Sy(a5),d5
    lsr.w    #1,d5
    add.w    #Req_WY,d5
    bsr    AppCentre
; State of disc drive
; ~~~~~~~~~~~~~~~~~~~
    SyCall    GetDisc
    move.w    d0,T_DOld(a5)

;    Test loop (fun!)
; ~~~~~~~~~~~~~~~~~~~~~~
ReqLoop    
    bsr    UnMix2
    move.l    a6,-(sp)
    move.l    T_GfxBase(a5),a6
    jsr    -270(a6)        WaitTOF
    move.l    (sp)+,a6
    bsr    UnMix1

; Automatic disc change
; ~~~~~~~~~~~~~~~~~~~~~
    move.l    T_Req_IDCMP(a5),d0
    btst    #15,d0
    beq.s    NoAuto
    SyCall    GetDisc
    cmp.w    T_DOld(a5),d0
    beq.s    NoAuto
    move.w    d0,T_DOld(a5)
    bne    ReqYes
; Keyboard
; ~~~~~~~~
NoAuto    SyCall    Inkey
    cmp.w    #13,d1        * ASCII-> Return 
    beq.s    ReqYes    
    cmp.w    #27,d1        * ASCII-> ESC
    beq.s    ReqNo    
; Don''t you think it is better than this wierd Amiga V and B?
; Sometime I ask myself what they were thinking when they chose such
; key combinations!
    swap    d1
    move.w    d1,d0        * Isolate AMIGA keys
    and.w    #%1100000000000000,d0
    beq.s    RqL0
    cmp.b    #$34,d1        * V
    beq.s    ReqYes
    cmp.b    #$35,d1        * B
    beq.s    ReqNo
; Mouse pointer
; ~~~~~~~~~~~~~
RqL0    SyCall    GetZone
    cmp.w    #EcReq,d1
    beq.s    RqL1
    moveq    #0,d1
RqL1:    swap     d1
    cmp.w    d7,d1
    beq.s    RqL2
    move.w    d7,d0
    move.w    d1,d7
    moveq    #"0",d1
    bsr    PrtZone
RqL2:    move.w    d7,d0
    moveq    #"1",d1
    bsr    PrtZone
    tst.w    d7
    beq    ReqLoop
    SyCall    MouseKey
    tst.w    d1
    beq    ReqLoop
    cmp.w    #2,d7
    beq.s    ReqNo
ReqYes    moveq    #-1,d0
    bra.s    ReqGo
ReqNo    moveq    #0,d0

;    End of screen (well done!!!)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ReqGo    move.l    d0,-(sp)
    move.l    T_ScAdr(a5),a2
    moveq    #-8,d7
    move.w    EcTy(a2),d6
    lsr.w    #1,d6
    move.w    T_Req_Sy(a5),d5
    lsr.w    #1,d5
    add.w    #Req_WY,d5
    bsr    AppCentre
    EcCalD    Del,EcReq

;    Back to system!
; ~~~~~~~~~~~~~~~~~~~~~
ReqX    bsr    UnMix2
    bsr    ClrData
    SyCall    AMALUFrz    
    move.l    (sp)+,T_Req_Pos(a5)    * Returns answer
    clr.w    T_Req_On(a5)        * No more requester
; Normal exit
; ~~~~~~~~~~~
ReqXX    move.l    T_Req_Pos(a5),(sp)    ReqPos>>> D0
    movem.l    (sp)+,a0-a6/d0-d7
    rts
;    Can''t open screen!!!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
NoReq    clr.l    -(sp)
    bra.s    ReqX

;    Print a zone D0-> zone, D1-> inverse or not
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrtZone    subq.w    #1,d0
    bmi.s    PrtX
    bne.s    PrtNeg
; Print pos text
; ~~~~~~~~~~~~~~
PrtPos    tst.l    T_Req_Pos(a5)
    beq.s    .skip
    lea    TPos1(pc),a1
    move.b    d1,8(a1)
    WiCall    Print
    move.l    T_Req_Pos(a5),a1
    WiCall    Print
    WiCalA    Print,TPos2(pc)
.skip    bra.s    PrtX
; Print neg text
; ~~~~~~~~~~~~~~
PrtNeg    tst.l    T_Req_Neg(a5)
    beq.s    .skip
    lea    TNeg1(pc),a1
    move.b    d1,8(a1)
    WiCall    Print
    move.l    T_Req_Neg(a5),a1
    WiCall    Print
    WiCalA    Print,TNeg2(pc)
.skip
PrtX    rts

;    Screen appearance
; ~~~~~~~~~~~~~~~~~~~~~~~
AppCentre:
    move.w    d6,d4
    move.w    d6,EcAWTY(a2)
    add.w    d6,EcAWTY(a2)
    bset    #2,EcAWT(a2)
    move.w    EcTy(a2),d0
    lsr.w    #1,d0
    sub.w    d6,d0
    move.w    d0,EcAVY(a2)
    bset    #2,EcAV(a2)
    move.w    d5,EcAWY(a2)
    sub.w    d6,EcAWY(a2)
    bset    #2,EcAW(a2)
    movem.l    a2/d4-d7,-(sp)
    SyCall    WaitVbl
    EcCall    CopForce
    movem.l    (sp)+,a2/d4-d7
    add.w    d7,d6
    bpl.s    FsApp2
    clr.w    d6
FsApp2:    move.w    EcTy(a2),d0
    lsr.w    #1,d0
    cmp.w    d0,d6
    bcs.s    FsApp3
    move.w    d0,d6
FsApp3:    cmp.w    d4,d6
    bne.s    AppCentre
    rts

;    Prevent mixes between AMOS and the requester!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
UnMix1    movem.l    d0-d7/a0-a6,-(sp)
    move.l    $4.w,a6
    jsr    Forbid(a6)
    EcCall    Current
    move.w    EcNumber(a0),d1
    move.w    d1,T_ReqOldScreen(a5)
    EcCalD    Active,EcReq
    EcCalD    First,EcReq
    EcCall    CopMake
    SyCall    WaitVbl
    movem.l    (sp)+,d0-d7/a0-a6
    rts
UnMix2    movem.l    d0-d7/a0-a6,-(sp)
    move.w    T_ReqOldScreen(a5),d1
    EcCall    Active
    move.l    $4.w,a6
    jsr    Permit(a6)
    movem.l    (sp)+,d0-d7/a0-a6
    rts

;    Open TEXT data zone
; ~~~~~~~~~~~~~~~~~~~~~~~~~
ResData    move.l    #T_Size,d0
    SyCall    SyFast
    move.l    d0,a4
    rts
;    Clear TEXT data zone
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
ClrData    move.l    #T_Size,d0
    move.l    a4,a1
    SyCall    SyFree
    rts

;    WB1.3 requester entry
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Req_Auto

    bsr    ResData

    move.l    #$00008000,T_Req_IDCMP(a5)

    lsr.w    #3,d2
    addq.w    #3,d2
    and.w    #$FFFC,d2
    move.w    d2,T_Req_Sx(a5)
    lsr.w    #3,d3
    addq.w    #2,d3
    move.w    d3,T_Req_Sy(a5)

    move.l    a1,a0
    lea    T_Text(a4),a1
    moveq    #10,d0
    bsr    IT_Print

    clr.l    T_Req_Pos(a5)
    lea    T_Gad(a4),a1
    move.l    a2,d0
    move.l    d0,a0
    beq.s    .skip1
    move.l    a1,T_Req_Pos(a5)
    moveq    #0,d0
    bsr    IT_Print
.skip1
    clr.l    T_Req_Neg(a5)
    lea    T_Gad+64(a4),a1
    move.l    a3,d0
    move.l    d0,a0
    beq.s    .skip2
    move.l    a1,T_Req_Neg(a5)
    moveq    #0,d0
    bsr    IT_Print
.skip2
    lea    Req_Tit(pc),a0
    lea    T_Tit(a4),a1
.loop    move.b    (a0)+,(a1)+
    bne.s    .loop
    rts    

;    WB2.0 Requester entry
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Req_Easy
    bsr    ResData
    move.l    (a2),T_Req_IDCMP(a5)

    lea    8(a1),a2
    clr.w    T_TxtMaxCx(a5)

    lea    T_Tit(a4),a1
    move.l    (a2)+,d0
    move.l    d0,a0
    bne.s    .nof
    lea    Req_Tit(pc),a0
.nof    bsr    Format

    move.l    (a2)+,a0
    lea    T_Text(a4),a1
    bsr    Format
    move.w    T_TxtCy(a5),T_Req_Sy(a5)

    move.l    (a2)+,a0
    lea    T_Gad(a4),a1
    bsr    Format

    lea    T_Gad(a4),a0
    move.l    a0,T_Req_Pos(a5)
    clr.l    T_Req_Neg(a5)
.loop    move.b    (a0)+,d0
    beq.s    .skp
    cmp.b    #"|",d0
    bne.s    .loop
    clr.b    -1(a0)
    move.l    a0,T_Req_Neg(a5)
.skp
    move.w    T_TxtMaxCx(a5),d0
    cmp.w    #32,d0
    bcc.s    .skp2
    moveq    #32,d0
.skp2    add.w    #9,d0
    and.w    #$FFFC,d0
    move.w    d0,T_Req_Sx(a5)

    addq.w    #8,T_Req_Sy(a5)
    rts

;    Call RawDoFmt
; ~~~~~~~~~~~~~~~~~~~
Format    clr.w    T_TxtCx(a5)
    move.w    #1,T_TxtCy(a5)
    movem.l    a2/a3/a6,-(sp)
    exg    a3,a1
    lea    .OutC(pc),a2
    move.l    $4.w,a6
    jsr    -522(a6)
    exg    a3,a1
    movem.l    (sp)+,a2/a3/a6
.XMax    move.w    T_TxtCx(a5),d0
    cmp.w    T_TxtMaxCx(a5),d0
    bls.s    .sk
    move.w    d0,T_TxtMaxCx(a5)
.sk    rts
.OutC    movem.l    d0/a5,-(sp)
    move.l    W_Base(pc),a5
    addq.w    #1,T_TxtCx(a5)
    move.b    d0,(a3)+
    cmp.b    #10,d0
    bne.s    .Skip
    clr.b    (a3)+
    addq.w    #1,T_TxtCy(a5)
    bsr.s    .XMax
    clr.w    T_TxtCx(a5)
.Skip    movem.l    (sp)+,d0/a5
    clr.b    (a3)
    rts


;    Copy an intuitext into the buffer
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A0-> ITEXT
;    A1-> Buffer
;    D0-> Mettre un 10 a la fin...
IT_Print
    movem.l    a0-a2/d0-d1,-(sp)
.loop    move.l    12(a0),d1
    move.l    d1,a2
    beq.s    .skip
.loop1    move.b    (a2)+,(a1)+
    bne.s    .loop1
    tst.w    d0
    beq.s    .skip
    move.b    d0,-1(a1)
    clr.b    (a1)+
.skip    move.l    16(a0),d1
    move.l    d1,a0
    bne.s    .loop
    movem.l    (sp)+,a0-a2/d0-d1
    rts

;    Routine: copy the binary data
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Copy    movem.l    d0-d7/a0-a5,-(sp)
    mulu    #RPic_Sx/8,d1            d1= offset source
    add.l    d1,d0
    lea    RPic(pc),a0            a0= adress source
    move.w    T_Req_Sx(a5),d1
    ext.l    d1                d1= size of dest line
    mulu    d1,d3
    add.l    d2,d3                d3= offset dest
    move.l    T_ScAdr(a5),a3            a3= dest screen
    subq.w    #1,d4
    subq.w    #1,d5
    move.w    #RPic_Np-1,d2
.loop1    move.l    (a3)+,a4
    add.l    d3,a4
    move.l    a0,a1
    add.l    d0,a1
    move.w    d5,d7
.loop2    move.w    d4,d6
    move.l    a1,a2
    move.l    a4,a5
.loop3    move.b    (a2)+,(a5)+
    dbra    d6,.loop3
    add.w    #RPic_Sx/8,a1        
    add.l    d1,a4
    dbra    d7,.loop2
    add.w    #(RPic_Sx/8)*RPic_Sy,a0
    dbra    d2,.loop1
    movem.l    (sp)+,d0-d7/a0-a5
    add.w    d4,d2
    rts

;--------------------------------------------------------------------
*        DATA ZONE

*         Title
Req_Tit:
    dc.b "System request",0
Req_Init:
    dc.b 27,"C0",27,"V0",27,"Y1",27,"B2",27,"P7",0
*        Main text
Req_Main:
    dc.b 27,"B2",27,"P3",27,"Y4",0
*         Positive text
TPos1:
    dc.b 27,"B4",27,"P3",27,"I0",24,30,30,27,"X2",27,"Z0",0
TPos2:
    dc.b 27,"Z1",0
*         Negative text
TNeg1:
    dc.b 27,"B4",27,"P3",27,"I0",24,30,30,27,"X"
XTNeg:
    dc.b "0",27,"Z0",0
TNeg2:
    dc.b 27,"Z2",0
        even
;         Insertion de l''image de fond
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RPic_Sx        equ    112
RPic_Sy        equ    56
RPic_Np        equ    3
Req_Pal        Incbin    "bin/ReqPic.bin"
RPic        equ    Req_Pal+32*2
        even
