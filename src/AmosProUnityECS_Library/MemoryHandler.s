
FastMm    movem.l    a0/d1,-(sp)
    move.l    #CLEAR|PUBLIC,d1
    bsr    WMemReserve
    move.l    a0,d0
    movem.l    (sp)+,a0/d1
    rts
FastMm2    movem.l    a0/d1,-(sp)
    move.l    #PUBLIC,d1
    bsr    WMemReserve
    move.l    a0,d0
    movem.l    (sp)+,a0/d1
    rts
ChipMm    movem.l    a0/d1,-(sp)
    move.l    #CLEAR|PUBLIC|CHIP,d1
    bsr    WMemReserve
    move.l    a0,d0
    movem.l    (sp)+,a0/d1
    rts
ChipMm2    movem.l    a0/d1,-(sp)
    move.l    #PUBLIC|CHIP,d1
    bsr    WMemReserve
    move.l    a0,d0
    movem.l    (sp)+,a0/d1
    rts
FreeMm    bra    WMemFree

; ___________________________________________________________________
;
;    RESERVATION / LIBERATION MEMOIRE CENTRALISEE / DEBUGGAGE
; ___________________________________________________________________
;
        RsReset
Mem_Length    rs.l    1
Mem_Pile    rs.l    8
Mem_Header    equ    __Rs
Mem_Border    equ    128
Mem_Code    equ    $AA
MemList_Size    equ    1024*8

; Reservations directes
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    IN:    D0    length
;    OUT:    A0    adress / nothing else changed.
WMemFastClear
    move.l    d1,-(sp)
    move.l    #Public|Clear,d1
    bsr    WMemReserve
    movem.l    (sp)+,d1
    rts
WMemFast
    move.l    d1,-(sp)
    move.l    #Public,d1
    bsr    WMemReserve
    movem.l    (sp)+,d1
    rts
WMemChipClear
    move.l    d1,-(sp)
    move.l    #Chip|Public|Clear,d1
    bsr    WMemReserve
    movem.l    (sp)+,d1
    rts
WMemChip
    move.l    d1,-(sp)
    move.l    #Chip|Public,d1
    bsr    WMemReserve
    movem.l    (sp)+,d1
    rts

    IFEQ    Debug

; Reservation memoire
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    D0=    Longueur
;    D1=    Flags
WMemReserve
    movem.l    d0-d3/a1/a5-a6,-(sp)
    move.l    W_Base(pc),a5
    move.l    d1,d2
    move.l    d0,d3
    move.l    $4.w,a6
    jsr    AllocMem(a6)
    tst.l    d0
    bne.s    .MemX
; Out of memory: flush procedure!
    bsr    WMemFlush
; Try once again
    move.l    d2,d1
    move.l    d3,d0
    jsr    AllocMem(a6)
; Get out, address in A0, Z set.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.MemX    move.l    d0,a0
    tst.l    d0
    movem.l    (sp)+,d0-d3/a1/a5-a6
    rts

; Liberation memoire centralisee
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A1=    Debut zone
;    D0=    Taille zone
WMemFree
    movem.l    d0-d1/a0-a1/a6,-(sp)
    move.l    $4.w,a6
    jsr    FreeMem(a6)
    movem.l    (sp)+,d0-d1/a0-a1/a6
    rts

; Fausses fonctions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WMemInit
WMemEnd    
WMemCheck
    rts
    ENDC
    IFNE    Debug
; Initialisation memoire centralisee
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WMemInit
    movem.l    a0-a1/a5-a6/d0-d1,-(sp)
    move.l    W_Base(pc),a5
    move.l    #MemList_Size*4,d0
    move.l    #Clear|Public,d1
    move.l    $4.w,a6
    jsr    AllocMem(a6)
    move.l    d0,T_MemList(a5)
    movem.l    (sp)+,a0-a1/a5-a6/d0-d1
    rts

; Fin memoire centralisee
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WMemEnd    
    movem.l    a0-a1/a5-a6/d0-d1,-(sp)
    bsr    WMemCheck
    tst.l    d0
    beq.s    .Skip
    bsr    BugBug
.Skip    move.l    W_Base(pc),a5
    move.l    #MemList_Size*4,d0
    move.l    T_MemList(a5),a1
    move.l    $4.w,a6
    jsr    FreeMem(a6)
    clr.l    T_MemList(a5)
    movem.l    (sp)+,a0-a1/a5-a6/d0-d1
    rts

; Reservation memoire
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    D0=    Longueur
;    D1=    Flags
WMemReserve
    movem.l    d0-d3/a1-a2/a5-a6,-(sp)
    move.l    W_Base(pc),a5

;    cmp.l    #$4FC-Mem_Header-2*Mem_Border,d0
;    bne.s    .Skip
;    jsr    BugBug
;.Skip
    move.l    d1,d2
    move.l    d0,d3
    add.l    #Mem_Header+2*Mem_Border,d0
    move.l    $4.w,a6
    jsr    AllocMem(a6)
    tst.l    d0
    beq.s    .OutM
; Store the adress in the table
.Again    move.l    T_MemList(a5),a0
.Free    tst.l    (a0)+
    bne.s    .Free
    move.l    d0,-4(a0)
    move.l    d0,a0
    move.l    d3,(a0)+            Save length
    lea    4*4+4*4(sp),a1
    moveq    #7,d1
.Save    move.l    (a1)+,(a0)+            Save Content of pile
    dbra    d1,.Save
; Put code before and after memory
    move.b    #Mem_Code,d2
    move.w    #Mem_Border-1,d1
    move.l    a0,a1
    add.l    #Mem_Border,a1
    add.l    d3,a1
.Code1    move.b    d2,(a0)+
    move.b    d2,(a1)+
    dbra    d1,.Code1
; All right, memory reserved
    add.l    #Mem_Header+Mem_Border,d0
    bra.s    .MemX
; Out of memory: flush procedure!
.OutM    bsr    WMemFlush
; Try once again
    move.l    d2,d1
    move.l    d3,d0
    add.l    #Mem_Header+2*Mem_Border,d0
    jsr    AllocMem(a6)
    tst.l    d0
    bne.s    .Again
; Get out, address in A0, Z set.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.MemX    move.l    d0,a0
    tst.l    d0
    movem.l    (sp)+,d0-d3/a1-a2/a5-a6
    rts

; Liberation memoire centralisee
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A1=    Debut zone
;    D0=    Taille zone
WMemFree
    movem.l    d0-d2/a0-a2/a5-a6,-(sp)
    move.l    W_Base(pc),a5
; Find in the list
    sub.l    #Mem_Header+Mem_Border,a1
    move.l    T_MemList(a5),a2
    move.w    #MemList_Size-1,d2
.Find    cmp.l    (a2)+,a1
    beq.s    .Found
    dbra    d2,.Find
    bra.s    Mem_NFound
; Found, erase from the list
.Found    clr.l    -4(a2)
; Check the length
    cmp.l    Mem_Length(a1),d0
    bne.s    Mem_BLen
; Check the borders
    lea    Mem_Header(a1),a0
    move.l    a0,a2
    add.l    #Mem_Border,a2
    add.l    d0,a2
    move.w    #Mem_Border-1,d1
.Check    cmp.b    #Mem_Code,(a0)+
    bne.s    Mem_BCode
    cmp.b    #Mem_Code,(a2)+
    bne.s    Mem_BCode
    dbra    d1,.Check
; Perfect!
    add.l    #Mem_Header+2*Mem_Border,d0
    move.l    $4.w,a6
    jsr    FreeMem(a6)
Mem_Go    movem.l    (sp)+,d0-d2/a0-a2/a5-a6
    rts
; Error messages
; ~~~~~~~~~~~~~~
Mem_NFound
    bsr    BugBug
    bra.s    Mem_Go
    dc.b    "No found"
Mem_BLen
    bsr    BugBug
    bra.s    Mem_Go
    dc.b    "Bad leng"
Mem_BCode
    bsr    BugBug
    bra.s    Mem_Go
    dc.b    "Bad code"

; Check the whole memory list
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WMemCheck
    movem.l    d1-d2/a0-a2/a5-a6,-(sp)
    move.l    W_Base(pc),a5
    moveq    #0,d2
    move.l    T_MemList(a5),a0
    move.w    #MemList_Size-1,d0
.List    tst.l    (a0)+
    beq.s    .Next
    move.l    -4(a0),a1
    add.l    (a1),d2
; Check the borders
    move.l    (a1),d1
    lea    Mem_Header(a1),a1
    lea    0(a1,d1.l),a2
    add.l    #Mem_Border,a2
    move.w    #Mem_Border-1,d1
.Check    cmp.b    #Mem_Code,(a1)+
    bne.s    .BCode2
    cmp.b    #Mem_Code,(a2)+
    bne.s    .BCode2
    dbra    d1,.Check
; Next chunk
.Next    dbra    d0,.list
    move.l    d2,d0
.Xx    movem.l    (sp)+,d1-d2/a0-a2/a5-a6
    rts
.BCode2
    bsr    BugBug
    moveq    #0,d0
    bra.s    .Xx
    dc.b    "Bad code"
    even

    ENDC

;    Ajoute une routine flush
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WAddFlushRoutine
    move.l    a2,-(sp)
    lea    T_MemFlush(a5),a2
    bsr.s    WAddRoutine
    move.l    (sp)+,a2
    rts
;    Insere une routine dans une liste de routines
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A1=    Pointeur sur structure
;    A2=    Liste des routines
;        dc.l    0
;        ...routine...
WAddRoutine
    tst.l    (a1)            Deja la?
    bmi.s    .Deja
    move.l    (a2),d0
    lsr.l    #1,d0
    bset    #31,d0
    move.l    d0,(a1)            Branche dans la liste
    move.l    a1,(a2)
.Deja    rts

;    Apelle le memory flush
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WMemFlush
    lea    T_MemFlush(a5),a1
;    Appelle une liste de routine
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A1=    Liste des routines
WCallRoutines
    move.l    (a1),d0
    beq.s    .Out
    clr.l    (a1)
.Loop    move.l    d0,a0
    move.l    (a0),d0
    clr.l    (a0)
    lsl.l    #1,d0
    movem.l    a0-a6/d0-d7,-(sp)
    jsr    4(a0)
    movem.l    (sp)+,a0-a6/d0-d7
    tst.l    d0
    bne.s    .Loop
.Out:
    rts
