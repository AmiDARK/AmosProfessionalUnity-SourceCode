
colorSupport_Init:
    movem.l    a0,-(sp)
    lea        colorSupport_Functions(pc),a0
    move.l     a0,T_ColorSupport(a5)
    movem.l    (sp)+,a0
    moveq      #0,d0
    rts

; *************************************************************************************
; Here is the list of the callable methods from AmosPro.lib :
colorSupport_Functions:
    bra        SeparateRGBComponents
    bra        MergeRGBComponents
    bra        ForceToRGB24

; ************************************ Separate RGB12, RGB15 and RGB24 color data into 2 RGB12 outputs.
SeparateRGBComponents:
    movem.l    d0-d1/a0,-(sp)
    move.l     T_rgbInput(a5),d0
    move.l     d0,d1                   ; d0 = RGB input (which format do we have ?)
    swap       d1                      ; d1 = theorically GGBBCCRR where CC is color format
    lsr.w      #8,d1                   ; d1 = GGBB..CC
    and.l      #$0F,d1                 ; d1 = in Interval {0-15} (Ignore high bits as there are only 3 formats supported)
    lsl.l      #2,d0                   ; D0 * 4 (for pointer list)
    lea        inputFormats(pc),a0
    adda.l     d1,a0                   ; a0 = Pointer to the method to callable
    jsr        (a0)                    ; Call the input method
    movem.l    (sp)+,d0-d1/a0
    rts
; ************************************ RGB Input format supported
inputFormats:
    bra        InputIsRGB12            ; 12 Bits (R4,G4,B4)
    bra        InputIsRGB24            ; 24 bits (R8,G8,B8)
    bra        InputIsR5G5B5           ; 15 bits (R5,G5,B5)
; ************************************ Read R4G4B4 and push it into 2 R4G4B4 registers for High/Low bits
InputIsRGB12:
    move.l      T_rgbInput(a5),d0       ; Load the RGB input data
    move.w      d0,T_rgb12High(a5)      ; On RGB12 input, Low and High bits are the same
    move.w      d0,T_rgb12Low(a5)       ; On RGB12 input, Low and High bits are the same
    rts
; ************************************ Read R5G5B5 and push it into 2 R4G4B4 registers for High/Low bits
InputIsR5G5B5:
    bsr        convertRGB15toRGB24
    ; ******** Update the input with the new R8G8B8 version of the color to use RGB24 components separation methods
    move.l      T_rgbOutput(a5),T_rgbInput(a5) ; Update input with new version in R8G8B8.
    ; ******** Continue with RGB24 -> RGB12H + RGB12L conversion
InputIsRGB24:
; ******** Calculate high bits of the RGB24 color palette
    move.l     T_rgbInput(a5),d1
    and.l      #$F0F0F0,d1             ; d2 = ..R.G.B.
    moveq      #0,d0                   ; d0 = 0
    lsr.l      #4,d1                   ; d2 = ...R.G.B
    move.b     d2,d0                   ; d0 = .......B
    lsr.l      #4,d1                   ; d2 = ....R.G.
    or.b       d2,d0                   ; d0 = ......GB
    lsr.l      #4,d1                   ; d2 = .....R.G
    and.l      #$F00,d1                ; d2 = .....R..
    or.w       d0,d1                   ; d2 = .....RGB
    move.w     d1,T_rgb12High(a5)      ; Save RGB12 high bits
; ******** Calculate low bits of the RGB24 color palette
    moveq      #0,d0                   ; d0 = 0
    and.l      #$0F0F0F,d1             ; d1 = ...R.G.B
    move.b     d1,d0                   ; d0 = .......B
    lsr.l      #4,d1                   ; d1 = ....R.G.
    or.b       d1,d0                   ; d0 = ......GB
    lsr.l      #4,d1                   ; d1 = .....R.G
    and.l      #$F00,d1                ; d1 = .....R..
    or.w       d0,d1                   ; d1 = .....RGB
    move.w     d1,T_rgb12Low(a5)       ; Save RGB12 high bits
    rts

; ************************************ Merge rgb12High and rgb12Low to create a new output format
MergeRGBComponents:
    movem.l    d0-d1/a0,-(sp)
    moveq      #0,d0
    move.b     T_rgbOutput(a5),d0
    lsl.l      #2,d0                   ; D0 * 4 (for pointer list)
    lea        outputFormats(pc),a0
    adda.l     d0,a0                   ; a0 = Pointer to the method to callable
    jsr        (a0)                    ; Call the input method
    movem.l    (sp)+,d0-d1/a0
    rts
; ************************************ RGB Input format supported
outputFormats:
    bra        OutputIsRGB12           ; 12 Bits (R4,G4,B4)
    bra        OutputIsRGB24           ; 24 bits (R8,G8,B8)
    bra        OutputIsR5G5B5          ; 15 bits (R5,G5,B5)
; ************************************ Read RGB12 High & Low bits and output them in RGB15 output format
OutputIsRGB12:
    move.l     T_rgb12Low(a5),T_rgbOutput(a5)
    rts
OutputIsR5G5B5:
    bsr        OutputIsRGB24           ; First we must push RGB12H + RGB12L to RGB24 output format
    move.l     T_rgbOutput(a5),T_rgbInput(a5) ; Save updated RGB15->RGB24 output in rgbInput for 2nd pass
    move.l     #modeRgb15,T_rgbOutput(a5) ; Clear rgbOutput and prepare it for RGB15 output
    ; ******** extract B8 and push it to B5
    move.l     T_rgbInput(a5),d0
    and.l      #$FF,d0
    cmp.l      #0,d0
    beq.s      .part2
    add.l      #1,d0
    lsr.l      #3,d0
    sub.l      #1,d0
    and.l      #%11111,d0
    move.l     d0,T_rgbOutput(a5)      ; Save B5 component
.part2:
    ; ******** extract G8 and push it to G5
    move.l     T_rgbInput(a5),d0
    and.l      #$FF00,d0
    cmp.l      #0,d0
    beq.s      .part3
    add.l      #1,d0
    lsr.l      #3,d0
    sub.l      #1,d0
    and.l      #%1111100000,d0
    or.l       d0,T_rgbOutput(a5)      ; Save G5 component
.part3:
    ; ******** extract R8 and push it to R5
    move.l     T_rgbInput(a5),d0
    and.l      #$FF0000,d0
    cmp.l      #0,d0
    beq.s      .part4
    add.l      #1024,d0
    lsr.l      #3,d0
    sub.l      #1024,d0
    and.l      #%111110000000000,d0
    or.l       d0,T_rgbOutput(a5)      ; Save R5 component
.part4:
    rts
; ************************************ Read RGB12 High & Low bits and output them in RGB24 output format
OutputIsRGB24:
; ******** Clear rgbOutput and prepare it to receive RGB24 color datas
    move.l     #modeRgb24,T_rgbOutput(a5)
; ******** Get Low Bits for the RGB24 color value returned
    move.w     T_rgb12Low(a5),d0       ; d0 = .....RGB Low Bits
    and.l      #$FFF,d0                ; d0 = .....RGB Useless as color is always in RGB12 format in .w saves
    move.l     d0,d1                   ; d1 = .....RGB
    lsl.l      #4,d1                   ; d1 = ....RGB.
    move.b     d0,d1                   ; d1 = ....RGGB
    lsl.l      #4,d1                   ; d1 = ...RGGB.
    and.b      #$0F,d0                 ; d0 = .......B
    or.b       d0,d1                   ; d1 = ...RGGBB
    and.l      #$F0F0F,d1              ; d1 = ...R.G.B = Low bits for RGB24 color
    or.l       d1,T_rgbOutput(a5)      ; Push R4lG4lB4l components in rgbOutput
; ******** Get High bits for the RGB24 color value returned
    move.w     T_rgb12High(a5),d1      ; D1 = .....RGB High Bits
    and.l      #$FFF,d1                ; d1 = .....RGB Useless as color is always in RGB12 format in .w saves
    move.l     d1,d0                   ; d0 = .....RGB
    lsl.l      #4,d1                   ; d1 = ....RGB.
    move.b     d0,d1                   ; d1 = ....RGGB
    lsl.l      #4,d1                   ; d1 = ...RGGB.
    and.b      #$0F,d0                 ; d0 = .......B
    or.b       d0,d1                   ; d1 = ...RGGBB
    lsl.l      #4,d1                   ; d1 = ..RGGBB.
    and.l      #$F0F0F0,d1             ; d1 = ..R.G.B. = High bits for RGB24 color
    or.l       d1,T_rgbOutput(a5)      ; Push R4hG4hB4h components in rgbOutput
; Job Finished
    rts




; ************************************ Separate RGB12, RGB15 and RGB24 color data into 2 RGB12 outputs.
ForceToRGB24:
    movem.l    d0-d1/a0,-(sp)
    move.l     T_rgbInput(a5),d0
    move.l     d0,d1                   ; d0 = RGB input (which format do we have ?)
    swap       d1                      ; d1 = theorically GGBBCCRR where CC is color format
    lsr.w      #8,d1                   ; d1 = GGBB..CC
    and.l      #$0F,d1                 ; d1 = in Interval {0-15} (Ignore high bits as there are only 3 formats supported)
    lsl.l      #2,d0                   ; D0 * 4 (for pointer list)
    lea        F24_inputFormats(pc),a0
    adda.l     d1,a0                   ; a0 = Pointer to the method to callable
    jsr        (a0)                    ; Call the input method
    movem.l    (sp)+,d0-d1/a0
    rts
; ************************************ RGB Input format supported
F24_inputFormats:
    bra        F24_InputIsRGB12            ; 12 Bits (R4,G4,B4)
    bra        F24_InputIsRGB24            ; 24 bits (R8,G8,B8)
    bra        F24_InputIsR5G5B5           ; 15 bits (R5,G5,B5)
; ***********************************
F24_InputIsRGB12:
    bsr         InputIsRGB12             ; Push RGB12 to be 2x RGB12 (Low & High Bits) 
    bsr         OutputIsRGB24            ; Merge RGB12 Low & RGB12 High to create full RGB24
    rts
; ***********************************
F24_InputIsR5G5B5:
    bsr         convertRGB15toRGB24      ; Simply convert RGB15 (R5G5B5) to RGB24
    rts
; ***********************************
F24_InputIsRGB24:
    move.l      T_rgbInput(a5),T_rgbOutput(a5) ; Input and Output are under the same format
    rts








; ************************************ Simply Convert RGB15 (R5G5B5) to RGB24
convertRGB15toRGB24:
    move.l      T_rgbInput(a5),d0       ; R5G5B5 must be converted in R8G8B8 then separated
    move.l      #modeRgb24,T_rgbOutput(a5) ; Clear the input and prepare it to receive RGB24 value
    ; ******** Extract the B5 component to create a B8 one
    move.l      d0,d1
    and.l       #%11111,d1              ; Look for the Blue component
    cmp.b       #0,d1
    beq.s       .part2                  ; If B=0 -> No conversion from B5-> B8
    add.l       #1,d1                   ; D1 = interval { 1-32 }
    lsl.l       #3,d1                   ; D1 = D1 * 8
    sub.l       #1,d1                   ; D1 = D1 -1 = interval { 15-255 }
    move.b      d1,T_rgbOutput+3(a5)    ; T_rgbOutput(a5) = ......B8
.part2:
    ; ******** Extract the G5 component to create a G8 one
    move.l      d0,d1
    and.l       #%1111100000,d1         ; Look for the green component
    cmp.l       #0,d1
    beq.s       .part3                  ; If G=0 -> No conversion from G5-> G8
    add.l       #32,d1
    lsl.l       #3,d1
    sub.l       #32,d1
    move.b      d1,T_rgbOutput+2(a5)
.part3:
    ; ******** Extract the R5 component to create a R8 one
    move.l      d0,d1
    and.l       #%111110000000000,d1    ; Look for the green component
    cmp.l       #0,d1
    beq.s       .part4                  ; If R=0 -> No conversion from R5-> R8
    add.l       #1024,d1
    lsl.l       #3,d1
    sub.l       #1024,d1
    move.b      d1,T_rgbOutput+1(a5)
.part4:
    rts