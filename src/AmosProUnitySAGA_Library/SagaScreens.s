; ******** 2021.06.16 Start of the Saga Screens Support with wrapping for the various screens functions - START



; *************************************************************************************
;                     SCREEN OPEN
; Came From AMP_InScreenOpen:
;    and.l      #%1110000000000100,d5   ; 2021.06.16 : D5 = Display Mode (Hires(bit#15),c2p(bit#14),pip(bit#13),Laced(bit#2))
;    move.l     d5,d6
;    and.l      #%0110000000000000,d6
;    bne.w      SAGA_InScreenOpen       ; If c2p(bit#14) or pip(bit#13) is set, then we call the SAGA Screen Open Method
SAGA_InScreenOpen:
    btst        #14,d5
    bne         SAGA_OpenC2PScreen
    btst        #13,d5
    bne         SAGA_OpenPIPScreen
SAGA_OpenP2PScreen:


    bsr        LoadRegs
    rts
SAGA_OpenPIPScreen:


    bsr        LoadRegs
    rts


;     ************************ Check for HAM mode and its limitations
    move.l     (a3)+,d6

    cmp.l      #4096,d6                ; If HAM Mode is requested ?
    bne.s      ScOo0                   ; If not -> Jump to ScOo0
; **************** 2020.07.31 Remove Lowres limitation and allow Ham in HIRES - START
;    tst.w      d5                     ; Check if HAM Mode is requested in HiRes
;    bmi        FonCall                ; If yes, -> Jump to error L_FonCall
; **************** 2020.07.31 Remove Lowres limitation and allow Ham in HIRES - END
    moveq      #6,d4                   ; HAM used 6 bitplanes.
    or.w       #$0800,d5
    moveq      #64,d6
    bra.s      ScOo2
* Amount of colours -> Planes
ScOo0:
; **************** 2020.07.31 Test for HAM8 mode - START
    cmp.l      #262144,d6              ; Ham8 Requested ?
    bne.s      ScOo0b
    moveq      #8,d4                   ; HAM used 8 bitplanes.
    or.w       #$0800,d5
    move.l     #256,d6
    bset       #19,d5                  ; Enable HAM8 Mode in Display Mode (Ham8)
    bra.s      ScOo2
ScOo0b:
; **************** 2020.07.31 Test for HAM8 mode - END
; **************** 2021.03.16 Test for True 64 Color non EHB - START
    cmp.l      #-64,d6
    bne.s      ScOo1b
    Neg.l      d6                      ; D6 go back to 64 colors
    bset       #20,d5                  ; Enable True 64 colors.
    moveq      #6,d4
    bra.s      ScOo2
ScOo1b:
; **************** 2021.03.16 Test for True 64 Color non EHB - END
    ; ***** Loop to define the amount of colours depending on the amount of bitplanes requested
    moveq      #1,d4                   ; = Bitplane amount
    moveq      #2,d1                   ; = Colour amount
ScOo1:
    cmp.l      d1,d6
    beq.s      ScOo2
    lsl.w      #1,d1
    addq.w     #1,d4
    cmp.w      #EcMaxPlans+1,d4        ; 2019.11.05 Updated to handle directly max amount of planes allowed (original was = #7)
    bcs.s      ScOo1
IlNCo:
    moveq      #5,d0                   ; Illegal number of colours
    bra        EcWiErr
ScOo2:
    move.l     (a3)+,d3        * TY
    move.l     (a3)+,d2        * TX
    move.l     (a3)+,d1        * Numero
    bsr        CheckScreenNumber
; ********************* 2019.11.18 Removed 16 Color Hires resolution limitation
;    tst.w    d5            * Si HIRES, pas plus de 16 couleurs
;    bpl.s    ScOo3
;    cmp.w    #4,d4
;    bhi      FonCall    
; ********************* 2019.11.18 Removed 16 Color Hires resolution limitation
ScOo3:
    lea        DefPal(a5),a1           ; Load Default Palette adress -> a1
    EcCall     Cree                    ; Call +W.s/EcCree method
    bne        EcWiErr                 ; If screen was not created -> Error
    move.l     a0,ScOnAd(a5)           ; Save Screen Adresse -> ScOnAd(a5)
    move.w     EcNumber(a0),ScOn(a5)   ; Save Screen number  -> ScOn(a5)
    addq.w     #1,ScOn(a5)             ; ScOn(a5) = Screen number + 1
* Flash on color 3 if more than 2 colors are displayed
    cmp.w      #1,d4                   ; D4 = Bitplane Amount
    beq.s      ScOo4                   ; BitPlane Amount = 1 means Color Amount = 2 -> Jump No Flash color ScOo4.
    moveq      #3,d1                   ; Select color 3 for flashing
    moveq      #46,d0                  ; Move #46, D0 ????
    Bsr        Sys_GetMessage          ;
    move.l     a0,a1
    EcCall     Flash
ScOo4:
    bsr        LoadRegs
    rts


























; ******** 2021.06.16 Start of the Saga Screens Support with wrapping for the various screens functions - START
