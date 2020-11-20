
; Mini CHRGET: (a1)--->d0
miniget:move.b    (a1)+,d0     ;beq: fini
        beq.s     mini5           ;bmi: lettre
        cmp.b     #32,d0        ;bne: chiffre
        beq.s     miniget
        cmp.b     #"0",d0
        blt.s     mini2
        cmp.b     #"9",d0
        bhi.s     mini2
        moveq     #1,d7
        rts
mini2:  cmp.b     #"a",d0       ;transforme en majuscules
        bcs.s     mini3
        sub.b     #32,d0
mini3:  moveq     #-1,d7
mini5:  rts

; Prend un chiffre hexa--> D1
Gethexa:clr.w    d1
    bsr    MiniGet
    beq.s    GhX
    move.b    d0,d1
    sub.b    #"0",d1
    cmp.b    #9,d1
    bls.s    Gh1
    sub.b    #7,d1
Gh1:    cmp.b    #15,d1
    bhi.s    GhX
    moveq    #1,d0
    rts
GhX:    moveq    #0,d0
    rts

;Conversion dec/hexa a1 -> chiffre en d1
dechexa:clr     d1             ; derniere lettre en D0
        clr     d2
        bsr     miniget
        beq.s     Mdh5
        bpl.s     Mdh2
        cmp.b     #"-",d0
        bne.s     Mdh5
        moveq     #1,d2
Mdh0:   bsr     miniget
        beq.s     Mdh3
        bmi.s     Mdh3
Mdh2:   mulu     #10,d1
        sub.b     #48,d0
        and     #$00ff,d0
        add     d0,d1
        bra.s     Mdh0
Mdh3:   tst     d2
        beq.s     Mdh4
        neg     d1
Mdh4:   clr     d2              ;beq: un chiffre
        rts
Mdh5:   moveq     #1,d2             ;bne: pas de chiffre
        rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description : This method get a char from the string in A0*
; *               and check if it''s a number or letter. If it*
; *               is not the case, it continues reading the   *
; *               string until finding one, or reaching a 0.  *
; *                                                           *
; * Parameters : A0 = pointer to the String                   *
; *                                                           *
; * Return Value : D0 = Char                                  *
; *************************************************************
AniChr:
    moveq      #0,d0                   ; D0 = 0
AniCh0:
    move.b     (a0)+,d0                ; D0=(a0)+ (char read)
    beq.s      AnChX                   ; if D0 = 0 Then Jump AnChX (end).
    cmp.b      #33,d0                  ; if D0 < 33 ?
    bcs.s      AniCh1                  ; Yes -> Jump AniCh1
    cmp.b      #"Z",d0                 ; if D0 > "Z"
    bhi.s      AniCh1                  ; Yes -> Jump AniCh1
AnChX:
    rts                                ; End/Return
AniCh1:
    cmp.b      #"|",d0                 ; is D0="|" ?
    beq.s      AnChX                   ; Yes -> Jump AnChX (end).
    cmp.b      #"!",d0                 ; is D0="!" ?
    beq.s      AnChX                   ; Yes -> Jump AnChX (end).
    cmp.b      #27,d0                  ; is D0=Chr(27) ?
    bne.s      AniCh0                  ; No  -> Jump AniCh0 (= Continue reading next string char)
    addq.l     #2,a0                   ; Yes (D0=Chr(27) ) -> a0 = a0 + 2 (Return takes 2 chars)
    bra.s      AniCh0                  ; Jump AniCh0 (= Continue reading next string char)

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : AniLong                                     *
; *-----------------------------------------------------------*
; * Description : This method convert a string number into a  *
; *               true number. It can handle both decimal and *
; *               Hexadecimal as input.                       *
; *                                                           *
; * Parameters : A0 = pointer to the String                   *
; *                                                           *
; * Return Value : D0 = Number                                *
; *************************************************************
******* Conversion DECIMAL/HEXA-> Number in D0
AniLong
    moveq      #1,d3                   ; d3=1
    bsr        AniChr                  ; Read Num/Letter Char
    cmp.b      #"-",d0                 ; is D0="-"
    bne.s      Adh0                    ; No -> Jump Adh0
    subq.w     #1,d3                   ; d3=d3-1 (d3=0)
    bsr        AniChr                  ; Read Num/Letter Char
Adh0:
    cmp.b      #"$",d0                 ; is d0=chr("$")
    beq.s      Adhh0                   ; Yes -> Jump adhh0 (Read Hexadecimal)
    sub.b      #"0",d0                 ; D0 = D0 - Val( Chr( "0" ) )
    bcs        AniE1                   ; if D0 < 0 Then Jump AMAL Error AniE1 (AmalSystem.s)
    cmp.b      #10,d0                  ; Is D0 > 10 ?
    bcc        AniE1                   ; if D0 >10 Then Jump AMAL Error AniE1 (AmalSystem.s)
    move.l     d0,d1                   ; D1 = D0
    subq.w     #1,d3                   ; d3=d3-1
Adh1:
    bsr        AniChr                  ; Read Num/Letter Char
    sub.b      #"0",d0                 ; D0 = D0 - Val( Chr( "0" ) )
    bcs.s      Adh2                    ; if D0 < 0 Then Jump Adh2
    cmp.b      #10,d0                  ; Is D0 > 10 ?
    bcc.s      Adh2                    ; if D0 > 10 Then Jump Adh2
    ; **************** Here, AMOS Do a Mulu #10,d1 using 4 lines - Sthttps://www.facebook.com/hunts.zombiez#art
    add.l      d1,d1                   ; D1 = D1 * 2                   | D1 = PrevNum * 2
    move.l     d1,d2                   ; D2 = D1                       | D2 = PrevNum * 2
    lsl.l      #2,d1                   ; D1 = D1 * 4                   | D1 = PrevNum * 2 * 4 = PrevNum * 8
    add.l      d2,d1                   ; D1 = D1 + D2                  | D2 = PrevNum * 8 + PrevNum * 2 = PrevNum * 10
    ; **************** Here, AMOS Do a Mulu #10,d1 using 4 lines - End
    add.l      d0,d1                   ; D1 = D1 + D0                  | D1 = PrevNum * 10 + NewNum (D0)
    bra.s      Adh1                    ; Jump Adh1 to read another number to complete the full number
Adh2: ; Number reading is finished.
    subq.l     #1,a0                   ; A0 = A0 -1
    tst        d3                      ; Test D3
    beq.s      AdhX                    ; if D3 = 0 Then Jump AdhX
    bpl        AniE1                   ; if D3 > 0 Then Jump AMAL Error AniE1
    neg.l      d1                      ; if D3 < 0 Then D1 = 0 - D1 (Neg D1)
AdhX:
    move.l     d1,d0                   ; D0 = D1;
    rts
******* Conversion HEXA-> Number in D0
Adhh0:
    bsr        AniChr                  ; Read Num/Letter Char
    bsr        Tohh                    ; Jump -> Check char content 0-9, A-F or else.
    bmi        AniE1                   ; if D0 < 0 Then Jump AMAL Error AniE1
    move.l     d0,d1                   ; D1 = D0
    subq.w     #1,d3                   ; D3 = D3 -1
Adhh1:
    bsr        AniChr                  ; Read Num/Letter Char
    bsr        Tohh                    ; Jump -> Check char content 0-9, A-F or else.
    bmi.s      Adh2                    ; if D0 < 0 -> Jump Adh2 (Number reading is finished)
    lsl.l      #4,d1                   ; D1 = D1 * 16 (Hexa is base 16 ) (PrevNum)
    add.l      d0,d1                   ; D1 = D1 + D0  ( D1 = PrevNum * 16 ) + NewNum
    bra.s      Adhh1                   ; Loop to read next char
Tohh:
    sub.b      #"0",d0                 ; if 0<=d0<10 then D0 in range 0-9
    bcs.s      TohhError               ; if d0 < 0 Then Jump TohhError 
    cmp.b      #10,d0                  ; Is D0 => 10 ?
    bcs.s      TohhX                   ; No -> Jump ToohX
    sub.b      #"A"-"0",d0             ; Check if D0 was in range A-F for Hexa
    bcs.s      TohhError               ; Negative
    cmp.b      #6,d0
    bcc.s      TohhError
    add.b      #10,d0
TohhX:
    tst.b      d0                      ; Cmp.b #0,d0
    rts
TohhError:
    moveq      #-1,d0                  ; D0 = -1
    rts
