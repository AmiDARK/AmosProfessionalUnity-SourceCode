;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     useSAGAgfx
    moveq.l   #$0040,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     useAGAgfx
    moveq.l   #$0020,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     useECSgfx
    moveq.l   #$0010,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     checkSAGAgfx
    moveq.l   #$0400,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     checkAGAgfx
    moveq.l   #$0200,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     checkECSgfx
    moveq.l   #$0100,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     getScreenBestMode
    move.l    d3,-(a3)             ; Push Depth -> Stack
    move.l    #0000,d3             ; D3 = 0 = Best Mode Check ( Check SAGA, then AGA, then ECS)
    Rbra      L_getScreenMode

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************

; Modes :
; Hires          = $00008000
; Laced          = $00000004
; Lowres         = $00000000
; CheckECSModes  = $00000100
; CheckAGAModes  = $00000200
; CheckSAGAModes = $00000400
; ECSOnly        = $00000010
; AGAOnly        = $00000020
; SAGAOnly       = $00000040

; Depths :                                                | SAGA | AGA | ECS
; 2 Couleurs      = $00000001 (=1 bitplane)               |   Y     Y     Y
; 4 Couleurs      = $00000002 (=2 bitplanes)              |   Y     Y     Y
; 8 Couleurs      = $00000003 (=3 bitplanes)              |   Y     Y     Y
; 16 Couleurs     = $00000004 (=4 bitplanes)              |   Y     Y     Y
; 32 Couleurs     = $00000005 (=5 bitplanes)              |   Y     Y     Y
; 32 Couleurs EHB = $00000006 (=6 bitplanes)              |   Y     Y     Y
; 128 Couleurs    = $00000007 (=7 bitplanes)              |   Y     Y     N
; 256 Couleurs    = $00000008 (=8 bitplanes)              |   Y     Y     N
; 15 bits         = $0000000F (=15 bits CHUNKY 1R5G5B5)   |   Y     N     N
; 16 bits         = $00000010 (=16 bits CHUNKY R5G6B5)    |   Y     N     N
; 24 bits         = $00000018 (=24 bits CHUNKY R8G8B8)    |   Y     N     N
; 32 bits         = $00000020 (=32 bits CHUNKY A8R8G8B8)  |   Y     N     N
; YUV             = $00000040 (=YUV CHUNKY)               |   Y     N     N
; PLANAR 1BIT     = $00000081 (=PLANAR 1BIT)              |   Y     N     N
; PLANAR 2BIT     = $00000082 (=PLANAR 2BIT)              |   Y     N     N
; PLANAR 4BIT     = $00000084 (=PLANAR 4BIT)              |   Y     N     N
; Ham6            = $00001000 (=4096)                     |   Y     Y     Y
; Ham8            = $00040000 (=262144)                   |   Y     Y     Y
; True64          = $FFFFFFC0 (=-64)                      |   Y     Y     N          

; 
  Lib_Par     getScreenMode         ; D3.l = Chipset Modes Allowed (ECS/AGA/SAGA)
    move.l    (a3)+,d2              ; D2.l = Screen Depth/Mode
    move.l    (a3)+,d1              ; D1.l = Screen Height
    move.l    (a3)+,d0              ; D0.l = Screen Width

;   Check if D3 = 0 Then it enabled ECS,AGA & SAGA mode check (no force mode)
    tst.l     d3
    bne.s     .gSM1
    move.l    #$700,d3              ; = ECS($100)+AGA($200)+SAGA($400)
.gSM1:

; Compiles d0 (Width) and d1 (height) to be a 32 bits W.w/H.w content ( WWHH )
    swap      d0                    ; D0.l = Screen Width $WWWW0000
    clr.w     d0                    ; Clear d0 bits 00-15
    Or.w      d1,d0                 ; d0 = Width.w/Height.w


; ******** Check for SAGA graphics modes compatibility with the command parameters.
_CheckPart1_SAGA:
    btst      #10,d3                ; Force SAGA if available ?
    bne.s     _CheckSAGA            ; YES -> _Force _CheckSAGA
    btst      #6,d3                 ; check SAGA Gfx ?
    beq.s     _CheckPart2_AGA       ; NO -> Jump to Check next chipset (AGA)
_CheckSAGA:
    lea       SAGA_DEPTHS(pc),a0
    move.w    (a0)+,d4              ; d4 = Next existing Depth to compare/check
.continueSagDepth:
    cmp.w     d4,d2                 ; If D2 = D3
    beq.s     ThisOneD              ; Then Jump "This One Depth"
    add.w     #2,a0                 ; a0 = Pointer to the next Depth to compare/check/test
    move.w    (a0)+,d4              ; d4 = Next existing Depth to compare/check
    tst.w     d4                    ; d4 = 0 ? (No More depth to test)
    bne.s     .continueSagDepth     ; No -> .continueSagDepth to check next Depth.
NotFoundD:
    btst      #10,d3                ; Force SAGA if available ?
    beq.s     _CheckPart2           ; No = Check if compatible AGA screen mode exists
    Rbra      L_Err17               ; YES -> Requested display mode is not available
ThisOneD:
    move.w    (a0),d7               ; d7.w = Final PixelFormat
    and.l     #$FFFF,d7
;
    lea       SAGA_GFXMODES(pc),a0
    move.l    (a0)+,d0              ; D0 = next SAGA_GFXMODE(S).
.continueSagMode:
    cmp.l     d0,d1                 ; if D0 = D1 
    beq.s     ThisOne               ; Then Jump "This One"
    add.w     #2,a0                 ; Otherwise, read next screen mode
    move.l    (a0)+,d0
    tst.l     d0                    ; D0 = 0 = List fully explored, error -> Screen resolution not recognized.
    bne.s     .continueSagMode
NotFound:
    btst      #10,d3                ; Force SAGA if available ?
    beq.s     _CheckPart2           ; No = Check if compatible AGA screen mode exists
    Rbra      L_Err16               ; YES -> Requested display mode is not available
ThisOne:
    move.w    (a0),d2
    swap      d2
    And.l     #$FFFF0000,d2
    or.l      d2,d3
    Ret_Int
_CheckPart2_AGA:


; Saga DEPTH modes for the Screen Display Mode
SAGA_DEPTHS:
    dc.w      8,1
    dc.w      16,2
    dc.w      15,3
    dc.w      24,4
    dc.w      32,5
    dc.w      0,0

; Saga GFXMODE register screen resolutions
SAGA_GFXMODES:
    dc.w      320,200,1
    dc.w      320,240,2
    dc.w      320,256,3
    dc.w      640,400,4
    dc.w      640,480,5
    dc.w      640,512,6
    dc.w      960,240,7
    dc.w      480,270,8
    dc.w      304,224,9
    dc.w      1280,720,$A
    dc.w      640,360,$B
    dc.w      0,0,0

AGA_DEPTHS:
    dc.w      1,2
    dc.w      2,4
    dc.w      3,8
    dc.w      4,16
    dc.w      5,32
    dc.w      6,64
    dc.w      7,128
    dc.w      8,256
    dc.w      4096,6
    dc.w      
   