
***********************************************************
*    GET BOB/BLOC
*    A1= Ecran
*    A2= descripteur
*    D2/D3= X1/Y1
*    D4/D5= TX/TY
*    D6=    X2
GetBob:
    movem.l    d1-d7/a0-a6,-(sp)       ; Save Regs
    move.l     a1,a5                   ; A5 = A1 = Screen Table

; Check mask for right limits :
    move.w     d4,d6                   ; D6 = D4 = Bob Width
    and.w      #$000F,d6               ; D6 = Bob Width && %$0F
    lsl.w      #1,d6                   ; D6 = ( Bob Width && %$0F ) * 2 = Range( 0-31 )
    move.w     d6,a4                   ; A4 = D6 = Range( 0-31 )

; Calculate the Bob memory size in bytes :
    move.w     EcNPlan(a5),d7          ; D7 = Screen Depth (Amount of bitplanes)
    add.w      #15,d4                  ; D4 = Width + 15 (Used for 16 bits final bob image size alignment)
    lsr.w      #4,d4                   ; D4 = D4 / 16 = Amount of word (16 bits) to use for sprite width
    move.w     d4,d6                   ; D6 = Sprite/Bob Width in word(s) (16 bits)
    lsl.w      #1,d6                   ; D6 = D6 * 2 = Sprite/Bob Width in bytes ( 8 bits )
    move.w     d6,d1                   ; D1 = Sprite/Bob Width in bytes
    mulu       d5,d1                   ; D1 = Sprite/Bob 1 bitplane size in bytes
    mulu       d7,d1                   ; D1 = Full Sprite/Bob D7 (Screen depth) size in bytes

; Delete the previous one ?
******* Efface l''ancien???
    move.l     (a2),d0                 ; Does a previous version of the Sprite/Bob exists ?
    beq.s      GtBb1                   ; NO -> Jump GtBb1
    move.l     d0,a1                   ; A1 = Previous bob table
    move.w     (a1),d0                 ; D0 = Previous Bob Width in bytes
    lsl.w      #1,d0                   ; D0 = D0 * 2 ( Word alignment)
    mulu       2(a1),d0                ; D0 = D0 * Previous Bob Height (in lines)
    mulu       4(a1),d0                ; D0 = D0 * Previous Bob Depth (in bitplanes amount)
    cmp.l      d0,d1                   ; Are both previous and new both the same size (in memory size not pixels)
    beq.s      GtBb1                   ; YES - > Jump GtBb1
    add.l      #10,d0                  ; D0 = D0 + 10 (for headers (width, height, depth, etc.))
    bsr        FreeMm                  ; Free Memory
    clr.l      (a2)                    ; Clear previous bob/sprite pointer to complete release
GtBb1:
    move.l     4(a2),d0                ; D0 = Does a previous version of the sprite/Bob table exists ?
    ble.s      GtBb2                   ; No -> Jump GtBb2
    move.l     d0,a1                   ; Load Previous bob/Sprite table -> A1
    move.l     (a1),d0                 ; D0 = Previous Bob/Sprite table size in bytes
    bsr        FreeMm                  ; Release previous Bob/Sprite table memory allocation.
GtBb2:
    clr.l      4(a2)                   ; Clear previous bob/sprite table pointer to complete release

; Allocate memory for the new one.
    tst.l      (a2)                    ; Does new sprite table allocated (because previous one fit the need and was not deleted)
    bne.s      GtBb3                   ; YES -> Jump GtBb3
    move.l     d1,d0                   ; D1 = Full Sprite/Bob D7 (Screen depth) size in bytes
    add.l      #10,d0                  ; D0 = D0 + 10 bytes (for headers (width, height, depth, etc.))
    bsr        ChipMm2                 ; Allocate memory for Bob/Sprite
    beq        GtBbE                   ; Cannot allocate memory -> Jump GtBbE (error)
    move.l     d0,(a2)                 ; (a2) = New Bob/Sprite memory block

; Save Bob/Sprite information in the Bob/Sprite memory block!
GtBb3:
    move.l     (a2),a2                 ; A2 = Pointer to new Sprite/Bob memory block
    move.w     d4,(a2)+                ; Save (a2,0.w) = Bob Width
    move.w     d5,(a2)+                ; Save (A2,2.w) = Bob Height
    move.w     d7,(a2)+                ; Save (A2,4.w) = Bob Depth
    clr.w      (a2)+                   ; Save (A2,6.w) = Flipped X
    clr.w      (a2)+                   ; Save (A2,8.w) = Flipped Y
                                       ; (A2,10...)    = Image Datas

;

; GET (not translated) :
    lea        Circuits,a6             ; A6 = Chipsets registers base
    bsr        OwnBlit                 ; Wait for blitter ending and get control overt it
    subq.w     #1,d7                   ; D7 = Bitplanes Amount -1 ( to use minus as end loop checking )
    move.w     d2,d0                   ; D0 = Sprite/Bob X Position in screen for capture
    and.w      #$000F,d0               ; Check if X Position is multiple of 16
    bne.s      GtBc                    ; NO -> Jump GtBc

; To word :
    moveq      #-1,d1                  ; D1 = $FFFFFFFF
    move.w     d1,BltMaskG(a6)         ; BltMaskG = $FFFF
    move.w     a4,d0                   ; ( Bob Width && #$0F ) *2 = Range( 0-31 )
    beq.s      GtBbM                   ; =0 -> GtBbM
    lea        MCls(pc),a0
    move.w     0(a0,d0.w),d1
    not.w      d1                      ; D1 = $0000
GtBbM:
    move.w     d1,BltMaskD(a6)         ; BltMaskD = $0000
    move.w     EcTLigne(a5),d1         ; D1 = Screen Line size (bytes)
    mulu       d1,d3                   ; D3 = Current Line position in Screen to grab the Sprite/Bob
    lsr.w      #4,d2                   ; D2 = XPos to grab / 16
    lsl.w      #1,d2                   ; D2 = XPos to grab / 8 (byte position) word aligned.
    ext.l      d2                      ; Extends D2 sign (bit #15) to .l ( Bits #16-#31)
    add.l      d2,d3                   ; D3 = Exact bitplane position to start grab the sprite/bob in screen.
    lea        EcCurrent(a5),a1        ; A1 = Load Bitplane #0
    sub.w      d6,d1                   ; Calculate modulo in D1
    move.w     d1,BltModA(a6)          ; Set Blitter Source A Modul0 ( Screen Width (in bytes) - Bob/Sprite width (in bytes) )
    move.l     a2,BltAdD(a6)           ; Blitter Source D Pointer
    clr.w      BltModD(a6)             ; Blitter Source D modulo = 0
    lsl.w      #6,d5                   ; D5 = Bob Height * 64 ( Bits 15-06 = H9-H0 in BltSize )
    or.w       d5,d4                   ; D4 = Bob Width in bytes ( Bits 05-00 = W5-W0 in BltSize
    move.w     #%0000100111110000,BltCon0(a6) ; BltCon0 Set : USEA USED LF7 LF6 LF5 LF4
    clr.w      BltCon1(a6)             ; BltCon1 Set : Non (Are Mode)
GtBb5:
    move.l     (a1)+,a0                ; A0 = Current BitPlane (to read) Pointer
    add.l      d3,a0                   ; A0 = Exact position inside bitplane to start the copy of the Bob/Sprite
    move.l     a0,BltAdA(a6)           ; Blitter Source A Pointer
    move.w     d4,BltSize(a6)          ; BltSize = D4 = H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 W5 W4 W3 W2 W1 W0 = H9-H0 ->Bob Height, W5-W0 -> Bob Width
GtBb6:
    bsr        BlitWait                ; Wait for blitter to finish the copy
    dbra       d7,GtBB5                ; Next Bitplane, repeat until all planed bitplaes are copied.
    bra        GtBbX                   ; jump to GtBbX

******* Au pixel!
GtBc:    move.w    #%0000010111001100,BltCon0(a6)
    moveq    #16,d1
    sub.w    d0,d1
    moveq    #12,d0
    lsl.w    d0,d1
    move.w    d1,BltCon1(a6)
    move.w    EcTligne(a5),d1
    ext.l    d1
    mulu    d1,d3
    lsr.w    #4,d2
    lsl.w    #1,d2
    ext.l    d2
    add.l    d2,d3
    lea    EcCurrent(a5),a1
    subq.l    #2,a2
    addq.w    #1,d4
    or.w    #%0000000001000000,d4
    subq.w    #1,d5
    ext.l    d6
    move.w    a4,d2
    lea    MCls(pc),a0
    move.w    0(a0,d2.w),d2
    bmi.s    GtBc1
    not.w    d2
GtBc1:    move.l    (a1)+,a0
    add.l    d3,a0
    move.w    d5,d0
GtBc2:    move.l    a0,BltAdB(a6)
    move.w    (a2),a4
    move.l    a2,BltAdD(a6)
    move.w    d4,BltSize(a6)
    move.l    a2,a5
    add.l    d1,a0
    add.l    d6,a2
GtBc3:    bsr    BlitWait
    move.w    a4,(a5)
    and.w    d2,(a2)
    dbra    d0,GtBc2
    dbra    d7,GtBc1

******* FINI! Pas d''erreur
GtBbX: 
   bsr    DOwnBlit                     ; Release Blitter
    movem.l    (sp)+,d1-d7/a0-a6     ; Load Regs
    moveq    #0,d0                     ; No error
    rts

******* Out of mem
GtBbE:    movem.l    (sp)+,d1-d7/a0-a6
    moveq    #-1,d0
    rts

***********************************************************
*    INITIALISATION BOBS / D0= Nombre de bobs!
BbInit:
********
    clr.l    T_BbDeb(a5)
* Efface ce qui etait reserve
    move.w    d0,-(sp)
    bsr    BbEnd
    move.w    (sp)+,d1
* Reserve la memoire pour les tables priorites
    move.w    d1,T_BbMax(a5)
    ext.l    d1
    lsl.w    #2,d1
    move.l    d1,d0
    bsr    FastMm
    beq    GFatal
    move.l    d0,T_BbPrio(a5)
    move.l    d1,d0
    bsr    FastMm
    beq    GFatal
    move.l    d0,T_BbPrio2(a5)
    moveq    #0,d0
    rts

***********************************************************
*    FIN DES BOBS
BbEnd:
*******
    move.w    T_BbMax(a5),d1
    ext.l    d1
    lsl.l    #2,d1
    move.l    T_BbPrio(a5),d0
    beq.s    BOBE1
    move.l    d0,a1
    move.l    d1,d0
    bsr    FreeMm
BOBE1:    move.l    T_BbPrio2(a5),d0
    beq.s    BOBE2
    move.l    d0,a1
    move.l    d1,d0
    bsr    FreeMm
BOBE2:    moveq    #0,d0
    rts

***********************************************************
*    BOB X/Y
BobXY:    bsr    BobAd
    bne.s    BobxyE
    move.w    BbX(a1),d1
    move.w    BbY(a1),d2
    move.w    BbI(a1),d3
    moveq    #0,d0
BobxyE:    rts

***********************************************************
*    PATCH BOB / ICON
*    Dessine simplement un bob/icon
*    A1-    Buffer de calcul      = BufBob(a5) for Paste Bob & Paste Icon
*    A2-    Descripteur bob/icon  = Bob Address
*    D1-    Image retournee???    = Bob/Icon ID
*    D2/D3-    Coordonnees        =  X, Y
*    D4-    Minterms (0 si rien)  = 0 for Paste Bob & Paste Icon
*    D5-    APlan                 = -1 for Paste Bob & Paste Icon
TPatch
    movem.l    d1-d7/a0-a6,-(sp)
    move.l    a1,a4               ; = BufBob(a5)
* Va retourner le bob
    move.l    a2,a0
    move.w    d1,d0
    and.w    #$C000,d0
    bsr    Retourne
* Parametres de l''ecran courant
    move.l    T_EcCourant(a5),a0    * Calculssss
    move.w    EcClipX0(a0),d0
    and.w    #$FFF0,d0
    move.w    d0,BbLimG(a4)
    move.w    EcClipY0(a0),BbLimH(a4)
    move.w    EcClipX1(a0),d0
    add.w    #15,d0
    and.w    #$FFF0,d0
    move.w    d0,BbLimD(a4)
    move.w    EcClipY1(a0),BbLimB(a4)
    tst.w    d4
    beq.s    Patch1
    and.w    #$00FF,d4
    bset    #15,d4
Patch1    move.w    d4,BbACon(a4)
    move.w    d5,BbAPlan(a4)
    move.l    a0,BbEc(a4)
    exg.l    d3,d1
    bset    #31,d3            * Flag PAS POINT CHAUD!
    bsr    BobCalc
    bne.s    PatchO
* Gestion de l''autoback
    move.l    T_EcCourant(a5),a0
    tst.w    EcAuto(a0)
    beq.s    Patch2
    bsr    TAbk1
    bsr    PBobA
    bsr    TAbk2
    bsr    PBobA
    bsr    TAbk3
    bra.s    PatchO
Patch2:
    bsr    PBobA
* Fini!
PatchO    moveq    #0,d0
    movem.l    (sp)+,d1-d7/a0-a6
    rts
* Appelle la routine d''affichage
PBobA    lea    Circuits,a6
    bsr    OwnBlit
    move.w    BbASize(a4),d2
    move.l    BbTPlan(a4),d4               ; 2019.12.06
    ; ext.l    D4                         ; 2019.12.06 put as comment, useless
    move.l    BbAData(a4),a0
    move.l    BbEc(a4),a3
    lea    EcCurrent(a3),a3
    move.w    BbAModD(a4),d0
    move.w    d0,BltModC(a6)
    move.w    d0,BltModD(a6)
    move.l    BbADraw(a4),a2
    move.l    BbAMask(a4),d5
    jsr    (a2)
    bsr    BlitWait
    bra    DOwnBlit



***********************************************************
*    CREATION / CHANGEMENT D''UN BOB
*    D1= Numero du CANAL
*    D2= X
*    D3= Y
*    D4= Image
*    D5= MODE DECOR
*    D6= Plans affiches
*    D7= Minterms
BobSet:
********
    cmp.w      T_BbMax(a5),d1          ; if T_BbMax(A5) = D1 ?
    bcc        CreBbS                  ; YES -> Jump CreBbS (Mean D1 is the latest created bob)

; Write on previous (if available)
    move.l     a1,a0                   ; What is in a1 ???
    move.l     T_BbDeb(a5),d0          ; D0 = T_BbDeb(a5) Blitter Bob Debut (Beginning of chained list)
    beq.s      CreBb1                  ; if D0 = 0 -> Jump CreBb1 (Mean chained list contains 0 elements)
CreBb0:
    move.l     d0,a1                   ; A1 = D0 (when list contains elements)
    cmp.w      BbNb(a1),d1             ; Compare Blitter Bob Number(a1), d1
    beq.s      CreBb5                  ; D1 = BbNb(a1) -> Jump CreBb5
    bcs.s      CreBb2                 
    move.l     BbNext(a1),d0           ; D0 = Blitter Bob Next(a1) (Get Next bob chained item from the current bob)
    bne.s      CreBb0                  ; if D0 != 0 -> Jump CreBb0 ( Loop until the end of the chained list is reached)

; Add the new bob at end of chained list
    bsr        ResBOB                  ; A0 = New Bob : Create Bob Table & Set Screen Data in Bob Limits Droite (Right) & Bas (Bottom)
    bne        CreBbE                  ; Bob not created -> Jump CreBbE (Error Bob Not Created)
    move.l     a1,BbPrev(a0)           ; Save previous bob as being "previous bob" from the New bob in A0
    move.l     a0,BbNext(a1)           ; Save New bob in A0 being the "next bob" to the previous one
    move.l     a0,a1                   ; A1 = A0
    bra.s      CreBb5                  ; -> Jump to CreBbS

; Add the new bob at beginning of chained list
CreBb1:
    bsr        ResBOB                  ; A0 = New Bob : Create Bob Table & Set Screen Data in Bob Limits Droite (Right) & Bas (Bottom)
    bne        CreBbE                  ; Bob not created -> Jump CreBbE (Error Bob Not Created)
    move.l     a0,T_BbDeb(a5)          ; T_BbDeb(a5) = A0 (New Bob) as the list was previously empty.
    move.l     a0,a1                   ; A1 = A0
    bra.s      CreBb5                  ; -> Jump to CreBbS

; Insert new bob in chained list between 2 elements
CreBb2:
    bsr        ResBOB                  ; A0 = New Bob : Create Bob Table & Set Screen Data in Bob Limits Droite (Right) & Bas (Bottom)
    bne        CreBbE                  ; Bob not created -> Jump CreBbE (Error Bob Not Created)
    move.l     BbPrev(a1),d0           ; D0 = Previous Bob of (a1) bob           \
    move.l     a0,BbPrev(a1)           ; Previous Bob of (a1) Bob = New Bob A0    > Insert new bob between 2 elements of the chained list
    move.l     d0,BbPrev(a0)           ; Previous Bob of (a0) new Bob = D0       /
    bne.s      CreBb3                  ; if D0 != 0 -> Jump BreBb3
    move.l     T_BbDeb(a5),d1          ; D1 = T_BbDeb(a5) = 1st bob element of the chained list
    move.l     a0,T_BbDeb(a5)          ; T_DbDeb(a5) = New Bob A0 = 1st Bob Element of the list
    bra.s      CreBb4                  ; Jump -> CreBb4
CreBb3:
    move.l     d0,a2                   ; A2 = Previous bob of (a1) bob 
    move.l     BbNext(a2),d1           ; D1 = Next Bob of (a2) Bob
    move.l     a0,BbNext(a2)           ; Next Bob of (a2) Bob = New Bob a0
CreBb4:
    move.l     d1,BbNext(a0)           ; Next Bob of New bob (a0) = d1 = 1st Element of the List
    move.l     a0,a1                   ; A1 = New Bob A0

; Update new Bob coordinates from AMOS command
CreBb5:
    move.l     #EntNul,d7              ; Minterm = 0
    move.b     BbAct(a1),d6            ; D6 =Bob Action New bob (a1)
    bmi.s      CreBb9                  ; If D6 < 0 -> Jump CreBb9
    cmp.l      d7,d2                   ; Compare D7 & D2
    beq.s      CreBb6                  ; If D2 = D7 (=$80000000) -> Jump CreBb6
    move.w     d2,BbX(a1)              ; New Bob (a1) X Position = D2
    bset       #1,d6                   ; D6 = X Coordinate changed
CreBb6:
    cmp.l      d7,d3                   ; Compare D7 & D3
    beq.s      CreBb7                  ; If D3 = D7 (=$80000000) -> Jump CreBb7
    move.w     d3,BbY(a1)              ; New Bob (a1) Y Position = D3
    bset       #2,d6                   ; D6 = D6 || Y Coordinate changed
CreBb7:
    cmp.l      d7,d4                   ; Compare D7 & D4
    beq.s      CreBb8                  ; If D4 = D7 (=$80000000) -> Jump CreBb8
    move.w     d4,BbI(a1)              ; New Bob (a1) Image = D4
    bset       #0,d6                   ; D6 = D6 || Image changed
CreBb8:
    move.b     d6,BbAct(a1)            ; Save BbAct to check from D6 updates

; Bobx must be updated flag set 
CreBb9:
    bset       #BitBobs,T_Actualise(a5) ; Set BitBobs to T_Actualise(a5) to tell "we must actualize bobs"
    moveq      #0,d0                   ; D0 = 0 = No error.
    rts

; Error 1
CreBbS:
    moveq      #1,d0
CreBbE:
    tst.w      d0
    rts

******* CREATION DE LA TABLE!
ResBOB:
    move.l     #BbLong,d0
    bsr        FastMm
    beq.s      ResBErr
    move.l     d0,a0
    move.w     d1,BbNb(a0)
    move.l     T_EcCourant(a5),a2
    move.l     a2,BbEc(a0)
    move.w     EcTx(a2),BbLimD(a0)
    move.w     EcTy(a2),BbLimB(a0)
    move.w     d6,BbAPlan(a0)
    and.w      #$00FF,d7
    beq.s      ResBb0
    bset       #15,d7
ResBb0:
    move.w     d7,BbACon(a0)
    move.w     #$01,BbDecor(a0)
    btst       #BitDble,EcFlags(a2)
    beq.s      ResBb1
    addq.w     #1,BbDecor(a0)
    move.w     #Decor,BbDCur2(a0)
ResBb1:
    tst.w      d5
    bpl.s      ResBb2
    clr.w      BbDecor(a0)
ResBb2:
    move.w     d5,BbEff(a0)
    moveq      #0,d0
    rts
* Erreur memoire!
ResBErr:
    moveq      #-1,d0
    rts

***********************************************************
*    BOB OFF d1=#
BobOff:
*******
    move.l    T_BbDeb(a5),d0
    beq.s    DBb2
DBb1:    move.l    d0,a1
    cmp.w    BbNb(a1),d1
    beq.s    DBb3
    bcs.s    DBb2
    move.l    BbNext(a1),d0
    bne.s    DBb1
DBb2:    moveq    #1,d0
    rts
DBb3:
    move.b    #-1,BbAct(a1)
    bset    #BitBobs,T_Actualise(a5)
    moveq    #0,d0
    rts
***********************************************************
*    ARRET TOUS LES BOBS
BobSOff:
*******
    movem.l    d0/a1/a2,-(sp)
    move.l    T_BbDeb(a5),d0
    beq.s    DBbs2
DBbs1:    move.l    d0,a1
    move.b    #-1,BbAct(a1)
    move.l    BbNext(a1),d0
    bne.s    DBbs1
DBbs2:    bset    #BitBobs,T_Actualise(a5)
    movem.l    (sp)+,d0/a1/a2
    moveq    #0,d0
    rts

***********************************************************
*    LIMIT BOB tous, Ecran courant!
*    D1= # ou -1, D2/D3->D4/D5
BobLim:
*******
    movem.l    d2-d7,-(sp)
    move.l    T_BbDeb(a5),d0
    beq    LBbX
* Verifie les coordonnees
    move.l    T_EcCourant(a5),d6
    move.l    d6,a0
    move.l    #EntNul,d7
    cmp.w    d7,d2
    bne.s    LBba
    clr.w    d2
LBba:
    cmp.w    d7,d3
    bne.s    LBbb
    clr.w    d3
LBbb:
    cmp.w    d7,d4
    bne.s    LBbc
    move.w    EcTx(a0),d4
LBbc:
    cmp.w    d7,d5
    bne.s    LBbd
    move.w    EcTy(a0),d5
LBbd:
    and.w    #$FFF0,d2
    and.w    #$FFF0,d4
    cmp.w    d2,d4
    bls.s    LbbE
    cmp.w    d2,d5
    bls.s    LbbE
    cmp.w    EcTx(a0),d4
    bhi.s    LbbE
    cmp.w    EcTy(a0),d5
    bhi.s    LbbE
* Change les bobs!
LBb1:
   move.l    d0,a1
    tst.w    BbAct(a1)
    bmi.s    LBb3
    cmp.l    BbEc(a1),d6
    bne.s    LBb3
    tst.w    d1
    bmi.s    LBb2
    cmp.w    BbNb(a1),d1
    bhi.s    LBb3
    bcs.s    LBbX
LBb2:
    move.w    d2,BbLimG(a1)             ; = Left limit ( = 0 )
    move.w    d3,BbLimH(a1)             ; = Top limit ( = 0 )
    move.w    d4,BbLimD(a1)             ; = Right limit ( = Screen Witdh )
    move.w    d5,BbLimB(a1)             ; = Bottom limit ( = Screen Height )
    bset    #0,BbAct(a1)                ; = 1 = Active bob  ***Bug?
    bset    #BitBobs,T_Actualise(a5)
LBb3:    move.l    BbNext(a1),d0
    bne.s    LBb1
LBbX:    moveq    #0,d0
LBbXx    movem.l    (sp)+,d2-d7
    rts
LBbE:    moveq    #-1,d0
    bra.s    LBbXx

***********************************************************
*    PRIORITY ON/OFF
*    D1= on/off - Ecran courant (-1 indet)
*    D2= normal - reversed      (-1 indet)
TPrio    tst.l    d1
    bmi.s    TPri2
    beq.s    TPri1
    move.l    T_EcCourant(a5),d1
TPri1    move.l    d1,T_Priorite(a5)
TPri2    tst.l    d2
    bmi.s    TPri3
    move.w    d2,T_PriRev(a5)
TPri3    moveq    #0,d0
    rts

***********************************************************
*    ENLEVE LES BOBS D''UN ECRAN!
*    A0= Ecran
BbEcOff:
********
    movem.l    d1-d7/a0/a1,-(sp)
    move.l    a0,d7                     ; D7 = Chosen screen
    move.l    T_BbDeb(a5),d0             ; D0 = First Bob
    beq.s    BbEO2                         ; No bob exists ? YEST -> BbE02
BbEO1:
    move.l    d0,a1                     ; A1 = Current Bob
    cmp.l    BbEc(a1),d7                 ; If Current Bob Screen = Chosen Screen
    beq.s    BbEO3                         ; YES -> Jump BbE03
    move.l    BbNext(a1),d0             ; D0 = Next Bob
    bne.s    BbEO1                         ; Bob D0 Exists -> Jump BbE01
BbEO2:                                     ; NO -> End of loop
    movem.l    (sp)+,d1-d7/a0/a1
    moveq    #0,d0                         ; Non Errors
    rts
******* Enleve le bob!
BbEO3:
    move.l    BbNext(a1),d0             ; D0 = Next Bob
    bsr    DelBob                         ; Jump -> Delete Current Bob A1
* Encore?
    tst.l    d0                         ; Bob DO Exists ?
    bne.s    BbEO1                         ; YES -> Jump BbE01
    bra.s    BbEO2                         ; NO -> BbE02 Jump End of Loop

******* Efface la definition du bob (A1)
DelBob:
    movem.l    d0-d7/a0-a2,-(sp)
    move.l    a1,a2

; Delete background buffers ( double buffers )
    moveq    #0,d0
    move.w    BbDLBuf(a2),d0
    beq.s    DBo1
    lsl.l    #1,d0
    move.l    BbDABuf(a2),a1
    bsr    FreeMm
DBo1:
    moveq    #0,d0
    move.w    BbDLBuf+Decor(a2),d0
    beq.s    DBo2
    lsl.l    #1,d0
    move.l    BbDABuf+Decor(a2),a1
    bsr    FreeMm

; Remove Amal link
DBo2:
    lea    BbAct(a2),a0    
    bsr    DAdAMAL

; Delete bob itself
    move.l    BbNext(a2),d3
    move.l    BbPrev(a2),d2
    beq.s    DBo3
    move.l    d2,a0
    move.l    d3,BbNext(a0)
    bra.s    DBo4
DBo3:
    move.l    d3,T_BbDeb(a5)
DBo4:
    tst.l    d3
    beq.s    DBo5
    move.l    d3,a0
    move.l    d2,BbPrev(a0)
DBo5:
    move.l    a2,a1
    move.l    #BbLong,d0
    bsr    FreeMm

    movem.l    (sp)+,d0-d7/a0-a2
    rts

***********************************************************
*    ADRESSE D''UN BOB: D1= Numero!
BobAd:
*******
    move.l    T_BbDeb(a5),d0
    beq.s    AdBb1
AdBb0:    move.l    d0,a1
    cmp.w    BbNb(a1),d1
    beq.s    AdBb2
    bcs.s    AdBb1
    move.l    BbNext(a1),d0
    bne.s    AdBb0
AdBb1    moveq    #1,d0
AdBb2    rts

***********************************************************
*    PUT BOB n
BobPut:
    bsr    BobAd
    bne.s    BbPx
    move.w    BbDecor(a1),BbECpt(a1)
    moveq    #0,d0
BbPx:
    rts

***********************************************************
*    ACTUALISATION DES BOBS
*******
BobAct:    movem.l    d2-d7/a2-a6,-(sp)
    move.l    T_BbPrio(a5),a3
* Banque de sprites chargee?
    move.l    T_SprBank(a5),d0
    beq    BbSx
    move.l    d0,a6
******* Explore les bobs!
    move.l    T_BbDeb(a5),d0
    beq    BbSx
    clr.w    -(sp)
    move.l    T_Priorite(a5),-(sp)
    move.l    T_BbPrio2(a5),a5
BbS0:    move.l    d0,a4
* Flippe les decors!
    move.w    BbDCur2(a4),d4
    move.w    BbDCur1(a4),BbDCur2(a4)
    move.w    d4,BbDCur1(a4)
* Bob modifie?
    tst.w    BbECpt(a4)        * Si PUT BOB---> Pas d''act!
    bne.s    BbSDec
    tst.b    BbAct(a4)
    beq    BbSDec
    bmi    BbDel
    clr.b    BbAct(a4)
    move.w    BbI(a4),d2        * Pointe l''image
    moveq    #0,d3
    move.w    d2,d3
    and.w    #$C000,d3
    move.w    d3,BbRetour(a4)
    and.w    #$3FFF,d2
    beq    BbSort
    cmp.w    (a6),d2
    bhi    BbSort
    lsl.w    #3,d2
    lea    -8+2(a6,d2.w),a2
    tst.l    (a2)
    beq    BbSort
    move.l    a2,BbARetour(a4)
    move.w    BbX(a4),d2        * Coordonnees
    move.w    BbY(a4),d1
    move.l    BbEc(a4),a0        * Ecran
    bsr    BobCalc
    bne    BbSort

******* Sauvegarde du decor!
BbSDec:    move.w    BbDecor(a4),d0
    beq    BbSN
    move.w    BbESize(a4),d1
    beq    BbSort
* Stocke les parametres
    move.w    d0,BbDCpt(a4)
    move.w    BbDCur1(a4),d0
    lea    0(a4,d0.w),a2
    move.w    d1,BbDASize(a2)
    move.w    BbEMod(a4),BbDMod(a2)
    move.w    BbAPlan(a4),BbDAPlan(a2)
    move.w    BbEAEc(a4),BbDAEc(a2)
    move.w    BbNPlan(a4),d1
    move.w    d1,BbDNPlan(a2)
    tst.w    BbEff(a4)        * Effacement en couleurs?
    bne.s    BbSN
    addq.w    #1,d1
    mulu    BbETPlan+2(a4),d1        * Taille du buffer
    moveq    #0,d0
    move.w    BbDLBuf(a2),d0
    beq.s    BbD4
    lsl.l    #1,d0
    cmp.l    d0,d1            * Taille suffisante?
    bls.s    BbD5
* Efface l''ancien buffer?
    move.l    BbDABuf(a2),a1
    bsr    FreeMm
    clr.l    BbDABuf(a2)
    clr.w    BbDLbuf(a2)
* Reserve le nouveau!
BbD4:    move.l    d1,d0
    bsr    ChipMm
    beq.s    BbD5
    move.l    d0,BbDABuf(a2)
    lsr.l    #1,d1
    move.w    d1,BbDLBuf(a2)
* Ok!
BbD5:    bra    BbSN

******* BOB ARRETE
BbDel:    subq.w    #1,BbDecor(a4)        * Compte le nombre de REDRAW
    bhi.s    BbSort
* Efface!
    move.l    BbNext(a4),d0
    move.l    a4,a1
    move.l    a5,-(sp)
    move.l    W_Base(pc),a5
    bsr    DelBob
    move.l    (sp)+,a5
    tst.l    d0
    bne    BbS0
    bra.s    BbBug

******* Calcul des priorites
BbSN:    move.l    BbEc(a4),d0
    cmp.l    (sp),d0
    bne.s    BbPrX
* Priorite!
    move.l    a4,(a5)+
    addq.w    #1,4(sp)
    bra.s    BbSort
* Pas de priorite
BbPrX    move.l    a4,(a3)+
******* En dehors!
BbSort:    move.l    BbNext(a4),d0
    bne    BbS0
BbBug
******* Classe les bobs...
    move.l    W_Base(pc),a5
    addq.l    #4,sp
    move.w    (sp)+,d6
    beq.s    BbSx
    subq.w    #1,d6
* Recopie dans la liste
    move.l    a3,a4
    move.l    T_BbPrio2(a5),a0
    move.w    d6,d0
BbPr1    move.l    (a0)+,(a3)+
    dbra    d0,BbPr1
    subq.w    #1,d6
    bmi.s    BbSx
* Classe (a bulle!)
BbPr2    moveq    #0,d1
    move.w    d6,d2
    move.l    a4,a2
    move.l    (a2)+,a0
BbPr3    move.l    (a2)+,a1
    move.w    BbY(a0),d0        * Compare
    cmp.w    BbY(a1),d0
    blt.s    BbPr5
    bne.s    BbPr4
    move.w    BbX(a0),d0
    cmp.w    BbX(a1),d0
    ble.s    BbPr5
BbPr4    exg    a0,a1
    move.l    a0,-8(a2)
    move.l    a1,-4(a2)
    addq.w    #1,d1
BbPr5    move.l    a1,a0
    dbra    d2,BbPr3
    tst.w    d1
    bne.s    BbPr2
* Renverser la table???
BbSx:    clr.l    (a3)
    tst.w    T_PriRev(a5)
    beq.s    BbSxX
* Renverse la table!!!
    move.l    T_BbPrio(a5),a0
    cmp.l    a3,a0
    bcc.s    BbSxX
BbSRv    move.l    (a0),d0
    move.l    -(a3),(a0)+
    move.l    d0,(a3)
    cmp.l    a3,a0
    bcs.s    BbSRv
* Fini!
BbSxX    movem.l    (sp)+,d2-d7/a2-a6
    rts

******* ROUTINE DE CALCUL DES PARAMS AFFICHAGE BOB/BLOC
*    A0-> Screen
*    A2-> Image descriptor
*    A4-> Calculation buffer
*    D2-> X
*    D1-> Y
*    D3-> Flipping/Mirroring flags
BobCalc:
    move.l     (a2),a1                 ; A1 = Adresse Image.
    tst.l      4(a2)                   ; (A2,4) = Image Mask pointer
    bne.s      BbS1                    ; Image Mask already exists ? YES -> Jump BbS1
    bsr        Masque                  ; Calculate Image Mask
    bne        BbSOut                  ; No mask calculated ? -> Jump to error : BbSOut
* Hot spot flipped ?
BbS1: 
    tst.l      d3                      ; Should image be flipped ?
    bmi.s      BbHt3                   ; < 0 (=no) -> Jump BbHt3
* Start hot spot flipping
    move.w     6(a1),d0                ; D0 = Hot Spot X Coordinate
    move.w     d0,d4                   ; D4 = Hot Spot X Coordinate
    lsl.w      #2,d4                   ; D4 = D4 * 4 ( Bit #0-1 = %00 )
    asr.w      #2,d4                   ; D4 = D4 / 4 with the 2 lower bits shifted to the 2 higher ones ( 16 bits )
    move.w     8(a1),d5                ; D5 = Hot Spot Y Coordinate
    eor.w      d0,d3                   ; D3 = Flips flags ( Bits #14 & #15 ) && Bobx Hot Spot X Coordinate ( Bits #00 to #13 )
* Start Flipping on Y ?
    btst       #14,d3                  ; Should Image be flipped on Y ?
    beq.s      BbHt1                   ; No -> Jump BbHt1
    neg.w      d5                      ; D5 = 0 - Hot Spot Y Coordinate
    add.w      2(a1),d5                ; D5 = ( 0 - Hot Spot Y Coordinate ) + Image Height   ( Reversed Hot Spot Y position inside the image)
* Start Flipping on X ?
BbHt1:
    btst       #15,d3                  ; Should Image be flipped on X ?
    beq.s      BbHt2                   ; No -> Jump BbHt2
    move.w     (a1),d0                 ; D0 = Image Width (in bytes)
    lsl.w      #4,d0                   ; D0 = Image Width * 16 = Image Pixel Width
    sub.w      d4,d0                   ; DO = Image Pixel Width - Hot Spot X Coordinate ( Reversed Hot Spot X position inside the image)
    move.w     d0,d4                   ; D5 = Hot Spot X coordinate reversed
BbHt2:
    sub.w      d5,d1                   ; D1 = Y Position - Reversed Hot Spot Y Position = Final Y Position for render
    sub.w      d4,d2                   ; D2 = X Position - Reversed Hot Spot X Position = Final X Position for render
* Amount of planes   
BbHt3:
    move.w     4(a1),d0                ; D0 = Bob Bitplanes Depth
    cmp.w      EcNPlan(a0),d0          ; Compare Screen Bitplanes Depth & Bob Bitplanes Depth (D0)
    bls.s      BbS1a                   ; If D0 < Screen Depth -> BdS1A
    move.w     EcNPlan(a0),d0          ; If D0 > Screen Depth -> D0 = Screen Depth (trace only the screen amount of planes)
BbS1a:
    subq.w     #1,d0                   ; D0 -1;
    move.w     d0,BbNPlan(a4)          ; Buffer/BbNPlan = D0
    clr.w      BbESize(a4)             ; Buffer/BbESize = 0
* Controls words?
    tst.w      BbACon(a4)              ; Buffer/BbACon ! 0 ?
    beq.s      BbS1b                   ; YES -> DbS1b
    bpl.s      BbS1d                   ; > 0 -> BbS1d
    move.w     BbACon(a4),d0           ; D0 = BbACon (*mask the minterm)
    bclr       #15,d0                  ; BClr #15, BbACon
    or.w       #%0000111100000000,d0
    tst.l      4(a2)
    bpl.s      BbS1c
    and.w      #%0000011111111111,d0
    bra.s      BbS1c
BbS1b:
    move.w     #%0000111111001010,d0   ; Make the minterm
    tst.l      4(a2)
    bpl.s      BbS1c
    move.w     #%0000011111001010,d0
BbS1c:
    move.w     d0,BbACon(a4)           ; DbACon = D0
BbS1d:
    move.w     d2,d0                   ; D0 = Final X Render position
    and.w      #$F,d2                  ; D2 = D2 And $F ( 16 Pixels scrolling shifting )
    beq        BbND                    ; if Result = 0 Then draw at position multiple of 16 pixels -> Jump to BbND

******* DECALES!
    lsl.w      #8,d2                   ; D2 = D2 * 256
    lsl.w      #4,d2                   ; D2 = D2 * 16 . Result D2 uses bits #12 to #15 for BbaCon1 register
    move.w     d2,BbACon1(a4)          ; BbaCon1 = 16 pixels shift values in bits #12 to #15
    or.w       BbACon(a4),d2           ; Update D2 with BbACon content
    move.w     d2,BbACon0(a4)          ; BbaCon2 = BbACon + D2, 16 Pixels shift values in bits #12 to #15

    move.w     (a1),d4                 ; D4 = Image word width (in word = pixel width / 16 )
    lsl.w      #1,d4                   ; D4 = D4 * 2 = Image bytes width ( = pixel width / 8 )
    move.w     d4,d3                   ; D3 = Image bytes width
    move.w     2(a1),d5                ; D5 = Image Height in lines amount 
    move.w     d4,d2                   ; D2 = Image word width * 2
    mulu       d5,d2                   ; D2 = Full Image planar copy size
    move.l     d2,BbTPLan(a4)          ; BbTPlan(a4) = 1 image full planar copy size ; 2019.12.06 to .l
    add.w      d5,d2                   ; D2 = D2 + Image height (in pixels amount)
    add.w      d5,d2                   ; D2 = D2 + Image height (in pixels amount)
    move.l     d2,BbETPlan(a4)         ; * Clearing takes borders ; 2019.12.06 to .l

    move.w     d5,d2                   ; D2 = Image height (in pixels amount)
    add.w      d1,d2                   ; D2 = Image height + Final Y Position for render
    cmp.w      BbLimB(a4),d2           ; * Bottom limit compare with D2
    ble        BbDe2                   ; Limit does not go out of the screen -> Jump BbDe2
    sub.w      BbLimB(a4),d2           ; D2 = ( Image height + Final Y Position for render ) - Screen Height (calculate amount of lines that are outside the screen)
    sub.w      d2,d5                   ; D6 = Image height (in pixels amount) - D2 (amount of lines that are out of the screen = ( bottom clipping)
    bls        BbSOut                  ; Error -> Jump to BbSOut
BbDe2:    
    moveq      #0,d7
    cmp.w      BbLimH(a4),d1           ; Compare top limit with D1 ( = Final Y Position for render )
    bge.s      BbDe1                   ; D1 > BbLimH(a4) -> Jump BbDe1 (Pas de modifications à faire )
    sub.w      BbLimH(a4),d1           ; D1 = D1 - BbLimH( a4 ) 
    neg.w      d1                      ; D1 = -D1
    sub.w      d1,d5                   ; D5 = D5 - D1 ( Y amount of lines to copy - Y screen exceeding size ) = Final Amount of lines to copy from image to screen
    bls        BbSOut                  ; Error -> Jump to BbSOut
    move.w     d1,d7                   ; D7 = Y screen exceeding size
    mulu       d4,d7                   ; D7 = Y Screen exceeding size * 1 line byte size = Total amount of bytes to not copy from the beginning (top) of the image.
    move.w     BbLimH(a4),d1           ; D1 = BbLimH(a4) = Top limit = (new) Final Y Position for render
BbDe1:    
    move.w     EcTLigne(a0),d2         ; D2 = 1 screen line size (in bytes)
    move.w     d2,d6                   ; D6 = D2 = 1 screen line size (in bytes)
    mulu       d1,d6                   ; D6 = Y Final line in screen memory position, to trace the image (screen y shift)
    lsl.w      #3,d4                   ; D4 (Image bytes width) * 8 = X image width in pixels
    move.w     d4,d1                   ; D1 = D4 = image width in pixels
    add.w      d0,d1                   ; D1 = D1 Image width in pixeld + D0 Final X Render position 
    clr.w      BbAMaskD(a4)
    cmp.w      BbLimD(a4),d1           ; Compare D1 (the last pixel on the right of the image to draw) to screen width limit (BbLimD(a4) )
    ble.s      BbDe4                   ; D1  BbLimD(a4) -> No changes to do -> Jump BbDe4
    sub.w      BbLimD(a4),d1           ; D1 = D1 - BbLimD(a4) ( = the pixel width that is exceeding the screen limits )
    and.w      #$FFF0,d1               ; D1 = D1 - (0-15) offset (this and.w align D1 to 16 bits)
    add.w      #16,d1                  ; D1 = D1 + 16 (to be sure to cover the maximum width that exceed the screen limits)
    sub.w      d1,d4                   ; D4 = D4 Image width in pixels - Exceeding screen limits width = Image Width to copy (without calculating left border potential reduction)
    bmi        BbSOut                  ; D4 < 0 mean Error -> Jump to BbSOut 
    move.w     d0,d1                   ; D1 = Final X Render position
    and.w      #$000F,d1               ; D1 = 16 bits X pixels shifting for blitting copy
    lsl.w      #1,d1                   ; D1 = D1 * 2 (cos masks in Mask list MCls2 are 16 bits words )
    lea        MCls2(pc),a0            ; A0 load to Mask list ( L 4113 ).
    move.w     0(a0,d1.w),d1           ; Load correct Right Mask into D1 (D1 Bit shift value 0-15 define the mask to use)
    not.w      d1                      ; Invert mask bits
    move.w     d1,BbAMaskD(a4)         ; DbAMaskD(a4) = Current Right Mask = D1
BbDe4:    
    moveq      #-1,d1                  ; D1 = -1
    cmp.w      BbLimG(a4),d0           ; Compare BbLimG(a4) = Left minimal limit to D0 = Final X Render position
    bge.s      BbDe3                   ; if D0 > or Equal to BbLimG(a4) -> Jump BbDe3
; If D0 < BbLimG(a4) :
    move.w     d0,d1                   ; D1 = D0 = Final X Render Position
    sub.w      BbLimG(a4),d0           ; D0 = Final X Render Position - X Min draw limit
    neg.w      d0                      ; D0 = X Min Draw Limit - Final X Rander Position = Positive Value ( 1st left pixel to draw in the image
    sub.w      d0,d4                   ; D4 = Image Width in pixels - DO = Final Image width in pixels to draw with potentials left and right screen limits reductions (clipping).
    bls        BbSOut                  ; D4 < 1 -> Jump BbSOut
    add.w      #16,d4                  ; D4 = Final Image Width To Draw + 16
    lsr.w      #4,d0                   ; D0 = Left shift to remove to the image / 16
    lsl.w      #1,d0                   ; D0 = Left Shift to remove to the image / 8 with Word alignment = Left Pixel shift for image drawing.
    add.w      d0,d7                   ; D7 = D7 + D0 = Final X,Y start position (in bytes with 16 bits word alignment) inside image, for image drawing on screen
    bset       #31,d7                  ; D7 = Final X,Y Start position + Bit#31 set to %1
    subq.l     #2,d6                   ; D6 = Y Final line in screen memory position, to trace the image (screen y shift) - 2 bytes ( 1 word, 16 bits)
    lea        MCls2(pc),a0            ; A0 load to Mask list ( L 4113 ).
    and.w      #$000F,d1               ; D1 = 16 bits X pixels shifting for blitting copy
    lsl.w      #1,d1                   ; D1 = D1 * 2 (cos masks in Mask list MCls2 are 16 bits words )
    move.w     0(a0,d1.w),d1           ; Load correct Left Mask into D1 (D1 Bit shift value 0-15 define the mask to use)
    move.w     BbLimG(a4),d0           ; D0 = X Position to draw image.
BbDe3:
    move.w     d1,BbAMaskG(a4)         ; DbAMaskG(a4) = Current Left Mask = D1
    add.w      #16,d4                  ; D4 = Final Image Width To Draw + 16
    ext.l      d0                      ; 2019.12.21 Put here to keep the sign of D0 before doing bits shifting in .l instead of .w
    asr.l      #4,d0                   ; 2019.12.21 Updated to use asr.l instead of lsr.w : D0 = X Position to draw image / 16 to preserve D0 sign
    asl.l      #1,d0                   ; 2019.12.21 Updated to use asr.l instead of lsl.w : D0 = X Position to draw image / 8 with word alignment to preserve D0 sign
    ; ext.l    d0                      ; * BUG ! -> 2019.12.21 Removed, put sooner before the bits shifting with D0 sign conservation / Bug theorically fixed.
    add.l      d0,d6                   ; D6 = Bitplane Shift to draw image (= the 1st byte of the bitplane where the image will start to be drawn)
    lsr.l      #1,d6                   ; D6 = Bitplane Shift to draw image in Word amount
    move.l     d6,BbAAEc(a4)           ; 2019.12.21 Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )

    lsr.w      #4,d4                   ; D4 = ( Final Image Width to draw + 16 ) / 16 = Final Image word width to draw + 1
    move.w     d4,d0                   ; D0 = D4 = Final Image Word width to draw + 1
    lsl.w      #1,d4                   ; D0 = Final Image bytes to draw + 2 (word aligned) = Image modulo
    sub.w      d4,d3                   ; D3 = Image modulo (modulo inside image object itself)
    move.w     d3,BbAModO(a4)          ; BbAModO(a4) = D3 = Image Modulo
    sub.w      d4,d2                   ; D2 = Screen Width (in bytes) - Final image bytes to draw + 2 (image modulo) = Screen modulo
    move.w     d2,BbAModD(a4)          ; DbAModD(a4) = D2 = Screen Modulo

    move.w     d0,d1                   ; D1 = D0 = Image Modulo (bytes)
    lea        BbAP(pc),a0             ; Lea BbAP(pc) -> a0
    tst.l      d7                      ; D7 = 0 ?
    bpl.s      BbDe5                   ; D7 > 0 -> BbDe5
    add.l      #1,d6                   ; * Suite BUG ! -> 2019.12.26 Replaced addq.w with add.l
    subq.w     #1,d1                   ; D1 = Image Modulo - 1
    addq.w     #2,d2                   ; D2 = Screen Modulo + 2
    bne.s      BbDe5                   ; Resuls != 0 -> Jump BbDe5
    lea        BbAL(pc),a0             ; Lea BbAL(pc) -> a0
BbDe5:
    lsl.w      #6,d5                   ; D5 = Final Amount of lines to copy from image to screen * 64
    or.w       d5,d1                   ; D1 = Amount of blitter lines to copy * 64 || Image Bytes modulo - 1 (BltESize ?)
    move.w     d1,BbESize(a4)          ; BbESize(a4) = D1
    or.w       d5,d0                   ; D0 = Amount of blitter lines to copy * 64 || Image Bytes modulo (BltESize ?)
    move.w     d0,BbASize(a4)          ; BbASize(a5) = D0
    move.w     d2,BbEMod(a4)           ; BbEMod(a4) = Screen Modulo + 2
    move.w     d6,BbEAEc(a4)           ; BbEAEc(a4) = Bitplane Shift to draw image in Word amount + 1
    move.l     a0,BbADraw(a4)          ; BbADraw(a4) = BbAP(PC) or BbAL(PC) = Method to draw image with X multiple of 16 & X not multiple of 16

    move.l    4(a2),a2        * Adresses bob
    lea    4(a2,d7.w),a2
    move.l    a2,BbAMask(a4)
    lea    10(a1,d7.w),a2
    move.l    a2,BbAData(a4)

    moveq    #0,d0
    rts

* Sortie
BbSOut    moveq    #-1,d0
    rts

* NON DECALES: Teste limites en H G
BbND:    move.w    d0,d2
    move.w    d1,d3
    moveq    #0,d4
    moveq    #0,d5
    cmp.w    BbLimG(a4),d0
    bge.s    BbS2
    move.w    BbLimG(a4),d4
    sub.w    d0,d4
    lsr.w    #4,d4
    move.w    BbLimG(a4),d0
BbS2:    cmp.w    BbLimH(a4),d1
    bge.s    BbS3
    move.w    BbLimH(a4),d5
    sub.w    d1,d5
    move.w    BbLimH(a4),d1
BbS3:    lsr.w    #4,d0
    lsl.w    #1,d0
    ext.l    d0            BUG !
    mulu    EcTLigne(a0),d1
    add.l    d0,d1
    lsr.l    #1,d1
    move.l     d1,BbAAEc(a4)           ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )
    move.w     d1,BbEAEc(a4)
    move.w    (a1),d6
    move.w    2(a1),d7
    move.w    d6,d0
    lsl.w    #1,d0
    move.w    d0,d1
    mulu    d7,d1
    move.l     d1,BbTPlan(a4)          ; 2019.12.06
    move.l     d1,BbETPlan(a4)         ; 2019.12.06
    mulu    d5,d0
    add.w    d4,d0
    add.w    d4,d0
    move.l    4(a2),a2
    lea    4(a2,d0.w),a2
    move.l    a2,BbAMask(a4)
    lea    10(a1,d0.w),a2
    move.l    a2,BbAData(a4)

    move.w    BbACon(a4),BbACon0(a4)
    clr.w    BbACon1(a4)
    move.w    d6,d0
    lsl.w    #4,d0
    add.w    d0,d2
    add.w    d7,d3
    move.w    d6,d0
    move.w    d7,d1
    cmp.w    BbLimD(a4),d2
    ble.s    BbS4
    sub.w    BbLimD(a4),d2
    lsr.w    #4,d2
    sub.w    d2,d0
BbS4:    cmp.w    BbLimB(a4),d3
    ble.s    BbS5
    sub.w    BbLimB(a4),d3
    sub.w    d3,d1
BbS5:    sub.w    d4,d0
    ble    BbSOut
    sub.w    d5,d1
    ble    BbSout
    sub.w    d0,d6
    lsl.w    #1,d6
    move.w    d6,BbAModO(a4)
    move.w    EcTLigne(a0),d6
    sub.w    d0,d6
    sub.w    d0,d6
    move.w    d6,BbAModD(a4)
    move.w    d6,BbEMod(a4)
    lsl.w    #6,d1
    or.w    d1,d0
     move.w    d0,BbASize(a4)
    move.w    d0,BbESize(a4)
    lea    BbA16(pc),a0
    move.l    a0,BbADraw(a4)
    moveq    #0,d0
    rts


***********************************************************
*    CALCUL DU MASQUE, 1 MOT BLANC A DROITE!
*    A2= descripteur
Masque:    
*******
    movem.l    d1-d7/a0-a2,-(sp)
    move.l    (a2),a1
    move.w    (a1),d2
    lsl.w    #1,d2
    mulu    2(a1),d2        * D2= Taille plan
    move.l    d2,d3            
    addq.l    #4,d3            * D3= Taille memoire
    move.w    4(a1),d4        
    subq.w    #2,d4            * D4= Nb de plans
    move.w    d2,d5
    lsr.w    #1,d5
    subq.w    #1,d5
* Reserve la memoire pour le masque        
    move.l    4(a2),d0
    bne.s    Mas0
MasM    move.l    d3,d0
    bsr    ChipMm2
    beq.s    MasErr
    move.l    d0,4(a2)
* Calcule le masque
Mas0:    bmi.s    MasM
    move.l    d0,a2            * Adresse du masque
    move.l    d3,(a2)+        * Taille du masque
    lea    10(a1),a1        * Pointe le premier plan
Mas2:    move.l    a1,a0
    move.w    (a0),d0
    move.w    d4,d3
    bmi.s    Mas4
Mas3:    add.l    d2,a0
    or.w    (a0),d0
    dbra    d3,Mas3
Mas4:    move.w    d0,(a2)+
    addq.l    #2,a1
    dbra    d5,Mas2
* Pas d''erreur
    movem.l    (sp)+,d1-d7/a0-a2
    moveq    #0,d0
    rts
* Erreur!
MasErr:    movem.l    (sp)+,d1-d7/a0-a2
    moveq    #-1,d0
    rts
    
******************************************************** 
*    EFFACEMENT DE TOUS LES BOBS DES ECRANS
********
BobEff:    movem.l    d2-d7/a2-a6,-(sp)
    lea    Circuits,a6
    move.l    T_BbDeb(a5),d0
    beq    BbExX

******* Initialise le blitter
    bsr    OwnBlit
    move.w    #0,BltModA(a6)
    move.w    #0,BltCon1(a6)
    moveq    #-1,d1
    move.w    d1,BltMaskG(a6)
    move.w    d1,BltMaskD(a6)

******* Explore la liste des bobs
BbE0:    move.l    d0,a5
    tst.w    BbECpt(a5)            * Compteur PUT BOB
    bne.s    BbE5
    move.l    BbEc(a5),a3
    lea    EcLogic(a3),a3
    move.w    BbDCur2(a5),d4
    lea    0(a5,d4.w),a4

    move.w    BbDASize(a4),d2            * D2= BltSize
    beq.s    BbE4
    move.w    BbDAEc(a4),d3            * D3= Decalage ecran    
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbEff(a5),d4
    bne.s    BbEFc

* Effacement NORMAL
    tst.l    BbDABuf(a4)
    beq.s    BbE4
    move.w    BbDAPlan(a4),d1
    move.w    BbDNPlan(a4),d0
    bsr    BlitWait
    move.w    BbDMod(a4),BltModD(a6)
    move.l    BbDABuf(a4),BltAdA(a6)        * Adresse buffer
    move.w    #%0000100111110000,BltCon0(a6)
BbE1:    lsr.w    #1,d1
    bcc.s    BbE3
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbE3:    addq.l    #4,a3
    dbra    d0,BbE1
* Un autre?
BbE4:    move.l    BbNext(a5),d0
    bne.s    BbE0
    bra.s    BbEx
BbE5:    subq.w    #1,BbECpt(a5)
    bne.s    BbE4
    bra.s    BbE4

* Effacement COLORE!
BbEfC:    subq.w    #1,d4
    move.w    BbDAPlan(a4),d1
    move.w    BbDNPlan(a4),d0
    bsr    BlitWait
    move.w    BbDMod(a4),BltModD(a6)
    move.w    #%0000000111110000,BltCon0(a6)
    moveq    #0,d5
BbEfc1:
    lsr.w    #1,d4
    subx.w    d5,d5
    lsr.w    #1,d1
    bcc.s    BbEfc4
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.w    d5,BltDatA(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbEfc4:    addq.l    #4,a3
    moveq    #0,d5
    dbra    d0,BbEfc1
* Un autre?
    move.l    BbNext(a5),d0
    bne    BbE0

* FINI: remet le blitter
BbEx:    bsr    BlitWait
    bsr    DOwnBlit
BbExX:    movem.l    (sp)+,d2-d7/a2-a6
    rts    

******************************************************** 
*    SAISIE  ET DESSIN DE TOUS LES BOBS
********
BobAff:
    movem.l    d2-d7/a2-a6,-(sp)
    lea    Circuits,a6
    bsr    OwnBlit
    
******* SAISIE
    move.l    T_BbDeb(a5),d0
    beq    BbGx
* Initialise le blitter
    move.w    #0,BltModD(a6)
    move.w    #%0000100111110000,BltCon0(a6)
    move.w    #0,BltCon1(a6)
    moveq    #-1,d1
    move.w    d1,BltMaskG(a6)
    move.w    d1,BltMaskD(a6)

* Explore les bobs
BbG0:    move.l    d0,a5
    tst.w    BbDCpt(a5)            * Nombre de saisies
    beq.s    BbG4
    tst.w    BbEff(a5)            * Decor colore?
    bne.s    BbG4

    move.l    BbEc(a5),a3            * Adresse ecran
    lea    EcLogic(a3),a3
    move.w    BbDCur1(a5),d4
    lea    0(a5,d4.w),a4
    tst.l    BbDABuf(a4)            * Adress buffer 0?
    beq.s    BbG4
    move.w    BbDASize(a4),d2            * D2= BltSize
    beq.s    BbG4
    subq.w    #1,BbDCpt(a5)            * Une saisie de moins

    move.w    BbDAEc(a4),d3            * D3= Decalage ecran    
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbDAPlan(a4),d1
    move.w    BbDNPlan(a4),d0

    bsr    BlitWait
    move.l    BbDABuf(a4),d7
    move.l    d7,BltAdD(a6)            * Adresse buffer
    move.w    BbDMod(a4),BltModA(a6)
BbG1:
    lsr.w    #1,d1
    bcc.s    BbG3
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a2,BltAdA(a6)
    move.w    d2,BltSize(a6)
BbG3:    addq.l    #4,a3
    dbra    d0,BbG1

* Un autre?
BbG4:    move.l    BbNext(a5),d0
    bne.s    BbG0
BbGx:

*******    AFFICHAGE
    move.l    W_Base(pc),a5
    move.l    T_BbPrio(a5),a5
* Explore tous les bobs
    move.l    (a5)+,d0
    beq    BbAx
* Valeurs communes au 16 et autre
BbA0:    move.l    d0,a4
    move.w    BbASize(a4),d2
    beq.s    BbAn
* Va retourner le bob???
    move.w    BbRetour(a4),d0
    move.l    BbARetour(a4),a0
    bsr    Retourne
* Va dessiner
    moveq    #0,d4
    move.l    BbTPlan(a4),d4             ; 2019.12.06
    move.l    BbAData(a4),a0
    move.l    BbEc(a4),a3
    lea    EcLogic(a3),a3
    move.w    BbAModD(a4),d0
    move.l    BbADraw(a4),a1
    bsr    BlitWait
    move.w    d0,BltModC(a6)
    move.w    d0,BltModD(a6)
    move.l    BbAMask(a4),d5
    jsr    (a1)
* Un autre?
BbAn:    move.l    (a5)+,d0
    bne    BbA0
******* FINI: remet le blitter
BbAx:
    bsr    BlitWait
    bsr    DOwnBlit
    movem.l    (sp)+,d2-d7/a2-a6
    rts

******* ROUTINE DESSIN au pixel
BbAp:    bmi    BMAp
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)
    move.l    BbAAEc(a4),d3                         ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )
;    ext.l    d3                                    ; 2019.12.21 Removed the ext.l as data is now fully stored as 32 bits
    lsl.l    #1,d3
    move.w    BbAModO(a4),d0
    move.w    d0,BltModA(a6)
    move.w    d0,BltModB(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BbAp1:    lsr.w    #1,d1
    bcc.s    BbAp4
BbAp2:
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    d5,BltAdA(a6)
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbAp4:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BbAp1
    rts

******* ROUTINE DESSIN au pixel trop grand
BbAL:
    bmi    BmAp
    move.w    d2,d6
    lsr.w    #6,d6
    and.w    #%0111111,d2
    or.w    #%1000000,d2
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)
    move.l    BbAAEc(a4),d3                    ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )
    ext.l    d3
    lsl.l    #1,d3
    move.w    BbAModO(a4),d0
    move.w    d0,BltModA(a6)
    move.w    d0,BltModB(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BbAl1:
    lsr.w    #1,d1
    bcc.s    BbAl5
BbAl2:
    move.l    (a3),a2
    add.l    d3,a2
    move.w    d6,d7
    bsr    BlitWait
    move.l    d5,BltAdA(a6)
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
BbAl3
    bsr    BlitWait
    move.w    #0,BltDatA(a6)
    move.w    d2,BltSize(a6)
    subq.w    #1,d7
    bne.s    BbAl3
BbAl5:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BbAl1
    rts

******* ROUTINE DESSIN: Multiple de 16!
BbA16:
    bmi    BMA16
    move.l    BbAAEc(a4),d3         * D3 = screen shift ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )   
;    ext.l    d3                                        ; 2019.12.21 Useless now that BbAAEc is 32bits
    lsl.l    #1,d3
    move.w    BbAModO(a4),d0        * Valeur MODULO
    move.w    d0,BltModA(a6)
    move.w    d0,BltModB(a6)
    move.w    BbACon0(a4),BltCon0(a6)    * Registres de controle
    move.w    #0,BltCon1(a6)
    moveq    #-1,d0
    move.w    d0,BltMaskG(a6)
    move.w    d0,BltMaskD(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BbA1:    lsr.w    #1,d1
    bcc.s    BbA4
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    d5,BltAdA(a6)
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BbA4:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BbA1
    rts

******* ROUTINE DESSIN SANS MASQUE, Multiple de 16!
BMA16: 
    move.l    BbAAEc(a4),d3                         ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )
;    ext.l    d3                                    ; 2019.12.21 Useless now that BbAAEc is 32bits
    lsl.l    #1,d3
    move.w    BbAModO(a4),BltModB(a6)

    move.w    BbACon0(a4),d0          *If minterm replace use
    cmp.b    #$CA,d0              *fast blit , ideal for
    bne.s    Normal_BMA16          *fast icon pasting in games!
    move.w    BbAModO(a4),BltModA(a6)
    move.w    #%100111110000,BltCon0(a6)
    move.w    #0,BltCon1(a6)
    moveq    #-1,d0
    move.w    d0,BltMaskG(a6)
    move.w    d0,BltMaskD(a6)
    move.w    d0,BltDatB(a6)
    move.w    d0,BltDatC(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BMA1f:    lsr.w    #1,d1
    bcc.s    BMA3f
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a0,BltAdA(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BMA3f:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BMA1f
    rts

Normal_BMA16:
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    #0,BltCon1(a6)
    moveq    #-1,d0
    move.w    d0,BltMaskG(a6)
    move.w    d0,BltMaskD(a6)
    move.w    d0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BMA1:    lsr.w    #1,d1
    bcc.s    BMA3
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BMA3:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BMA1
    rts

******* ROUTINE DESSIN SANS MASQUE, Pixel!
BMAp:    
    move.l    BbAAEc(a4),d3                     ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )
;    ext.l    d3                                ; 2019.12.21 Useless now that BbAAEc is 32bits
    lsl.l    #1,d3

    move.w    BbAModO(a4),BltModB(a6)
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #-1,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BMAp1:    lsr.w    #1,d1
    bcc.s    BMAp4
    move.l    (a3),a2
    add.l    d3,a2
    bsr    BlitWait
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
    move.w    d2,BltSize(a6)
BMAp4:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BMAp1
    rts

******* ROUTINE DESSIN SANS MASQUE au pixel trop grand
BmAL:    move.w    d2,d6
    lsr.w    #6,d6
    and.w    #%0111111,d2
    or.w    #%1000000,d2
    move.w    BbACon0(a4),BltCon0(a6)    
    move.w    BbACon1(a4),BltCon1(a6)

    move.l    BbAAEc(a4),d3                ; 2019.12.21 Update Updated to .l to be sure that images can be drawn on big screen (ex. > 1024x1024 )
;    ext.l    d3                           ; 2019.12.21 Useless now that BbAAEc is 32bits
    lsl.l    #1,d3

    move.w    BbAModO(a4),BltModB(a6)
    move.w    BbAMaskG(a4),BltMaskG(a6)
    move.w    BbAMaskD(a4),BltMaskD(a6)
    move.w    #0,BltDatA(a6)
    move.w    BbAPlan(a4),d1
    move.w    BbNPlan(a4),d0
BmAl1:    lsr.w    #1,d1
    bcc.s    Bmal7
    move.l    (a3),a2
    add.l    d3,a2
    move.w    d6,d7
    bsr    BlitWait
    move.l    a0,BltAdB(a6)
    move.l    a2,BltAdC(a6)
    move.l    a2,BltAdD(a6)
Bmal3:    bsr    BlitWait
    move.w    #-1,BltDatA(a6)
    move.w    d2,BltSize(a6)
    subq.w    #1,d7
    bne.s    Bmal3
Bmal7:    add.l    d4,a0
    addq.l    #4,a3
    dbra    d0,BmAl1
    rts
