
;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; Rewrite of the Personal.lib for Amos Professional Unity 
; By Frédéric Cordier
; AMOS, AMOSPro, AMOS Compiler (c) Europress Software 1990-1992
; To be used with AMOS Professional Unity V3.0 and over
;--------------------------------------------------------------------- 
;
;---------------------------------------------------------------------
ExtNb            Equ    13-1         ; Extension number #13

;---------------------------------------------------------------------
;    +++
;    Include the files automatically calculated by
;    Library_Digest.AMOS
;---------------------------------------------------------------------
    Include    "PersonalUnity_lib_Size.s"
    Include    "PersonalUnity_lib_Labels.s"

; +++ You must include this file, it will decalre everything for you.
    include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
    Include    "src/AmosProUnity_Version.s"


; **************** 2021.03.17 Dos.h required content
    Include    "Includes/dos/dos.i"
; DOS_FIB    equ 2

; *** 2020.10.05-11 Includes AmigaOS libraries
    IncDir  "includes/"
    Include "exec/types.i"
    Include "exec/interrupts.i"
    Include "graphics/gfx.i"
    Include "graphics/layers.i"
    Include "graphics/clip.i"
    Include "hardware/intbits.i"
    Include "devices/input.i"
    Include "devices/inputevent.i"

VersionPUL MACRO
           dc.b "0.1 Alpha",0
           ENDM

; **************** 2021.03.10 Fast Icons Memory Banks datas
; ******** Flags for Fast Icon Bank DataType
Bnk_BitMemblock  Equ    4            ; = Bnk.BitReserved0
Bnk_BitFIcons    Equ    6            ; = Bnk_BitReserved2
; ******** Internal Structure of the FastIcon Bank
FIconsBlockSize  Equ    0            ; Long (4)
FIconsAmount     Equ    4            ; Word (2)
FIconsWidth      Equ    6            ; Word (2)
FIconsHeight     Equ    8            ; Word (2)
FIconsDepth      Equ   10            ; Word (2)
FIconsData       Equ   12            ; All Icons Datas

; A usefull macro to find the address of data in the extension''s own 
; datazone (see later)...
Dlea    MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-PersonalUnityDatas,\2
    ENDM

; Another macro to load the base address of the datazone...
Dload   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\1
    ENDM



; --------------------------------------------------------------------------- 
; Here is the place for the equates
;


; +++ First, a pointer to the token list
Start    dc.l    C_Tk-C_Off
;
; +++ Then, a pointer to the first library function
    dc.l    C_Lib-C_Tk
;
; +++ Then to the title
    dc.l    C_Title-C_Lib
;
; +++ From title to the end of the program
    dc.l    C_End-C_Title

;
; A value of -1 forces the copy of the first library routine...
    dc.w    0    

; +++ This magic code tells AMOSPro that this extensions uses the new format
    dc.b    "AP20"

    MCInit
C_Off
    REPT    Lib_Size
    MC
    ENDR

;    TOKEN_START

;     +++ The next two lines needs to be unchanged...
C_Tk:
    dc.w     1,0
    dc.b     $80,-1

; Now the real tokens...
; **************** Color palette support
        Dc.w    L_SNTSC,L_Nul
        Dc.b    "set nts","c"+$80,"I",-1
        Dc.w    L_SPAL,L_Nul
        Dc.b    "set pa","l"+$80,"I",-1
        Dc.w    L_Nul,L_RCLICK
        Dc.b    "right clic","k"+$80,"0",-1
        Dc.w    L_Nul,L_FIRE2
        Dc.b    "fire(1,2",")"+$80,"0",-1
        Dc.w    L_Nul,L_FIRE3
        Dc.b    "fire(1,3",")"+$80,"0",-1
        Dc.w    L_Nul,L_EHB
        Dc.b    "eh","b"+$80,"0",-1
        dc.w    L_Nul,L_getHam6Value
        dc.b    "ham","6"+$80,"0",-1

        dc.w    L_CreateMemblock,L_Nul
        dc.b    "create membloc","k"+$80,"I0,0",-1
        dc.w    L_Nul,L_MemblockExists
        dc.b    "memblock exis","t"+$80,"00",-1
        dc.w    L_Nul,L_GetMemblockSize
        dc.b    "get memblock siz","e"+$80,"00",-1
        dc.w    L_WriteMemblockLong,L_Nul
        dc.b    "write memblock lon","g"+$80,"I0,0,0",-1
        dc.w    L_Nul,L_ReadMemblockLong
        dc.b    "memblock lon","g"+$80,"00,0",-1
        dc.w    L_WriteMemblockWord,L_Nul
        dc.b    "write memblock wor","d"+$80,"I0,0,0",-1
        dc.w    L_Nul,L_ReadMemblockWord
        dc.b    "memblock wor","d"+$80,"00,0",-1
        dc.w    L_WriteMemblockByte,L_Nul
        dc.b    "write memblock byt","e"+$80,"I0,0,0",-1
        dc.w    L_Nul,L_ReadMemblockByte
        dc.b    "memblock byt","e"+$80,"00,0",-1
        dc.w    L_CreateMemblockFromFile,L_Nul
        dc.b    "create memblock from fil","e"+$80,"I2,0",-1

        dc.w    L_ReserveFIcons,L_Nul
        dc.b    "reserve f ico","n"+$80,"I0,0",-1
        dc.w    L_UseFIconBank,L_Nul
        dc.b    "set current f icon ban","k"+$80,"I0",-1
        dc.w    L_Nul,L_GetCurrentFIconBank
        dc.b    "get current f icon ban","k"+$80,"0",-1
        dc.w    L_GetFIcon,L_Nul
        dc.b    "get f ico","n"+$80,"I0,0,0",-1              ; Get F Icon ICONID,XPOS,YPOS
        dc.w    L_PasteFIcon1,L_Nul
        dc.b    "!paste f ico","n"+$80,"I0,0,0",-2            ; Paste F Icon ICONID,XPOS,YPOS
        dc.w    L_PasteFIcon2,L_Nul
        dc.b    $80,"I0,0,0,0",-2

        dc.w    L_Nul,L_GetFileSize
        dc.b    "get file siz","e"+$80,"02",-1

;    +++ You must also leave this keyword untouched, just before the zeros.
;    TOKEN_END

; Tokens to insert :
;        Dc.w    L_MOSAICx2,-1
;        Dc.b    "mosaic x","2"+$80,"I0",-1
;        Dc.w    L_MOSAICx4,-1
;        Dc.b    "mosaic x","4"+$80,"I0",-1
;        Dc.w    L_Mosaicx8,-1
;        Dc.b    "mosaic x","8"+$80,"I0",-1
;        Dc.w    L_Mosaicx16,-1
;        Dc.b    "mosaic x1","6"+$80,"I0",-1
;        Dc.w    L_MOSAICx32,-1
;        Dc.b    "mosaic x3","2"+$80,"I0",-1

;        Dc.w    L_DoubleMASK,-1
;        Dc.b    "double mas","k"+$80,"I0t0,0",-1
;        Dc.w    L_DoubleMASK2,-1
;        Dc.b    "l double mas","k"+$80,"I0,0,0t0,0",-1
;        Dc.w    L_DOUBLEMASKB,-1            ; Src1,Msk,Src2,Cible.
;        Dc.b    "blit mas","k"+$80,"I0,0,0t0",-1
;        Dc.w    L_DOUBLEMASKB2,-1   ; Src1,Msk,Src2 To Cible,Ys,Ye.
;        Dc.b    "l blit mas","k"+$80,"I0,0,0t0,0,0",-1
;        Dc.w    L_VBLWAIT,-1
;        Dc.b    "vb line wai","t"+$80,"I0",-1

;        Dc.w    L_MFILL,-1
;        Dc.b    "octets fil","l"+$80,"I0,0t0",-1
;        Dc.w    L_BLITCOPY,-1
;        Dc.b    "blitter cop","y"+$80,"I0t0",-1
;        Dc.w    L_CONFORM32,-1
;        Dc.b    "s32 block to scree","n"+$80,"I0",-1
;        Dc.w    L_CONFORM32B,-1
;        Dc.b    "s32 vertice to scree","n"+$80,"I0",-1

;        Dc.w    L_RESICON,-1
;        Dc.b    "aga reserve ico","n"+$80,"I0",-1
;        Dc.w    L_ERAICON,-1
;        Dc.b    "aga erase ico","n"+$80,"I",-1
;        Dc.w    L_GETICON,-1
;        Dc.b    "aga get ico","n"+$80,"I0,0,0",-1
;        Dc.w    L_PASICON,-1
;        Dc.b    "aga paste ico","n"+$80,"I0,0,0",-1

;        Dc.w    L_MPRESERVE,-1
;        Dc.b    "mplot reserv","e"+$80,"I0",-1
;        Dc.w    L_MPDEFINE,-1
;        Dc.b    "mplot defin","e"+$80,"I0,0,0,0",-1
;        Dc.w    L_MPDRAW,-1
;        Dc.b    "mplot dra","w"+$80,"I0t0",-1
;        Dc.w    -1,L_MPX
;        Dc.b    "x mplo","t"+$80,"00",-1
;        Dc.w    -1,L_MPY
;        Dc.b    "y mplo","t"+$80,"00",-1
;        Dc.w    -1,L_MPC
;        Dc.b    "c mplo","t"+$80,"00",-1
;        Dc.w    L_MPMODIFY,-1
;        Dc.b    "mplot modif","y"+$80,"I0t0,0,0",-1
;        Dc.w    L_MPMODIFY2,-1
;        Dc.b    "mplot x defin","e"+$80,"I0,0",-1
;        Dc.w    L_MPMODIFY3,-1
;        Dc.b    "mplot y defin","e"+$80,"I0,0",-1
;        Dc.w    L_MPMODIFY4,-1
;        Dc.b    "mplot c defin","e"+$80,"I0,0",-1
;        Dc.w    L_MPORIGIN,-1
;        Dc.b    "mplot origi","n"+$80,"I0,0",-1
;        Dc.w    L_MPPLANES,-1
;        Dc.b    "mplot plane","s"+$80,"I0",-1
;        Dc.w    L_MPDRAWDPF1,-1
;        Dc.b    "mplot dpf1 dra","w"+$80,"I0t0",-1
;        Dc.w    L_MPDRAWDPF2,-1
;        Dc.b    "mplot dpf2 dra","w"+$80,"I0t0",-1



;    +++ The token table must end by this
    dc.w     0
    dc.l    0


;    Rjsr    L_Error          Jump to normal error routine. See end of listing
;    Rjsr    L_ErrorExt       Jump to specific error routine. See end of listing.
;    Rjsr    L_Test_PaSaut    Perform one AMOSPro updating procedure, update screens, sprites,
;                             bobs etc. You should use it for wait loops. Does not jump to 
;                             automatic calls.
;    Rjsr    L_Test_Normal    Same as before, but with automatic function jump.
;    Rjsr    L_WaitRout       Wait for D3 VBL with tests. See play instruction.
;    Rjsr    L_GetEc          Get screen address: In: D1.l= number, Out: A0=address
;    Rjsr    L_Demande        Ask for string space.  D3.l is the length to ask for. Return A0/A1 point to free space.
;                             Poke your string there, add the length of it to A0, EVEN the  address to the highest multiple
;                             of two, and move it into HICHAINE(a5) location...
;    Rjsr    L_RamChip        Ask for PUBLIC|CLEAR|CHIP ram, size D0, return address in D0, nothing changed, Z set according to the success.
;    Rjsr    L_RamChip2       Same for PUBLIC|CHIP
;    Rjsr    L_RamFast        Same for PUBLIC|CLEAR
;    Rjsr    L_RamFast2       Same for PUBLIC
;    Rjsr    L_RamFree        Free memory A1/D0
;    Rjsr    L_Bnk.OrAdr      Find whether a number is a address or a memory bank number IN: D0.l= number / OUT: D0/A0= number or start(number)
;    Rjsr    L_Bnk.GetAdr     Find the start of a memory bank. IN: D0.l= Bank number / OUT: A0= Bank address  D0.w= Bank flags / Z set if bank not defined.
;    Rjsr    L_Bnk.GetBobs    Returns the address of the bob''s bank IN: - / OUT:  A0=    address of bank / Z Set if not defined
;    Rjsr    L_Bnk.GetIcons   Returns the address of the icons bank IN:- / OUT:  A0= address of bank / Z Set if not defined
;    Rjsr    L_Bnk.Reserve    Reserve a memory bank. IN: D0.l Number / D1 = Flags / D2 Length / A0 Name of the bank (8 bytes) / OUT: A0 Address of bank / Z Set inf not successfull
;                             FLAGS: Bnk_BitData (Data bank), Bnk_BitChip (Chip bank)
;                             Example: Bset #Bnk_BitData|Bnk_BitChip,d1 // NOTE: you should call L_Bnk.Change after reserving/erasing a bank.
;    Rjsr    L_Bnk.Eff        Erase one memory bank. IN: D0.l Number / OUT: -
;    Rjsr    L_Bnk.EffA0      Erase a bank from its address. IN: A0 Start(bank) / OUT: -
;    Rjsr    L_Bnk.EffTemp    Erase all temporary banks
;    Rjsr    L_Bnk.EffAll     Erase all banks
;    Rjsr    L_Bnk.Change     Inform the extension, the bob handler that something has changed in the banks. You should use this function after every bank
;                             reserve / erase.
;     Rjsr    L_Dsk.PathIt    Add the current AMOS path to a file name IN: (Name1(a5)) contains the name, finished by zero / 
;                             OUT: (Name1(a5)) contains the name with new path.
;                             Example: move.l Name1(a5),a0 ; move.l #"Kiki",(a0)+ ; clr.b (a0); Rjsr L_Dsk.PathIt ; now I load in the current directory
;    Rjsr     L_Dsk.FileSelector Call the file selector. IN: 12(a3) Path+filter / 8(a3) Default name / 4(a3) Title 2 / 0(a3) Title 1
;                             All strings must be in AMOS string format: dc.w Length ; dc.b "String"
;                             OUT: D0.w Length of the result. 0 if no selection / A0 Address of first character of the result.
;
;    - Your code must be (pc), TOTALLY relocatable, check carefully your code!
;    - Never perform a BSR or a JSR from one function to another: it will crash once compiled. Use the special macros instead.
;    - Each individual routine of the library can be up to 32K

; +++ This macro initialise the library counter, and is also detected by
    Lib_Ini    0

; +++ Start of the library (for the header)
C_Lib

******************************************************************
*    COLD START
*
;
  Lib_Def    PersonalUnity_Cold
    cmp.l    #"APex",d1    Version 1.10 or over?
    bne.s    BadVer
    movem.l    a3-a6,-(sp)

; Here I store the address of the extension data zone in the special area
    lea        PersonalUnityDatas(pc),a3
    move.l     a3,ExtAdr+ExtNb*16(a5)
;
; Here, I store the address of the routine called by DEFAULT, or RUN
    lea        UnitySupportDef(pc),a0
    move.l     a0,ExtAdr+ExtNb*16+4(a5)
;
; Here, the address of the END routine,
    lea        UnitySupportEnd(pc),a0
    move.l     a0,ExtAdr+ExtNb*16+8(a5)
;
; And now the Bank check routine..
    lea        BkCheck(pc),a0
    move.l     a0,ExtAdr+ExtNb*16+12(a5)
; You are not obliged to store something in the above areas, you can leave
; them to zero if no routine is to be called...

; As you can see, you MUST preserve A3-A6, and return in D0 the 
; Number of the extension if everything went allright. If an error has
; occured (no more memory, no file found etc...), return -1 in D0 and
; AMOS will refuse to start.
    movem.l    (sp)+,a3-a6
    moveq      #ExtNb,d0    * NO ERRORS
    move.w     #$0110,d1    * Version d'ecriture
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : BadVer                                      *
; *-----------------------------------------------------------*
; * Description : In case this extension is runned on AMOS    *
; * Professional V1.00                                        *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
; 
BadVer:
    moveq    #-1,d0        * Bad version number
    sub.l    a0,a0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : AgaSupportDef                               *
; *-----------------------------------------------------------*
; * Description : This routine is called each time a DEFAULT  *
; * occurs.. The next instruction loads the internal datazone *
; * address. I could have of course done a load MB(pc),a3 as  *
; * the datazone is in the same library chunk.                *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
UnitySupportDef:
    Dload    a3
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : AgaSupportEnd                               *
; *-----------------------------------------------------------*
; * Description : This routine is called when you quit AMOS   *
; * or when the compiled program ends. If you have opened     *
; * devices, reserved memory you MUST close and restore       *
; * everything to normal.                                     *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
UnitySupportEnd:
    Dload    a3
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : BkCheck                                     *
; *-----------------------------------------------------------*
; * Description : This routine is called after any bank has   *
; * been loaded, reserved or erased. Here, if a music is being*
; * played and if the music bank is erased, I MUST stop the   *
; * music, otherwise it might crash the computer. That''s why *
; * I do a checksum on the first bytes of the bank to see if  *
; * they have changed...                                      *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
BkCheck:
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Area Name : agaDatas                                      *
; *-----------------------------------------------------------*
; * Description : This area contains the internal data used by*
; * the agaSupport.lib                                        *
; *                                                           *
; *************************************************************
;
PersonalUnityDatas:
CurrentFIconBank:    dc.l 0


; Now follow all the music routines. Some are just routines called by others,
; some are instructions. 
; See how a adress the internal music datazone, by using a base register
; (usually A3) and adding the offset of the data in the datazone...
;
; +++ How to get the parameters for the instruction?
;
; When an instruction or function is called, you get the parameters
; pushed in A3, and the last parameter in D3. So if you only have
; one parameter to your instruction, now need to acceed to (a3)
;
; Remember that you unpile them in REVERSE order than
; the instruction syntax.
;
; As you have a entry point for each set of parameters, you know
; how many are pushed...
;    - INTEGER:    move.l    d3,d0    
;    or    move.l    (a3)+,d0
;    - STRING:    move.l    d3,a0
;    or    move.l    (a3)+,a0
;    and    move.w    (a0)+,d0
;    A0---> start of the string.
;    D0---> length of the string
;    - FLOAT:    move.l    d3,d0
;    or    move.l    (a3)+,d0
;        fast floatting point format.
;    - DOUBLE:    move.l    d3,d0
;        move.l    d4,d1
;    or    movem.l    (a3)+,d3/d4
;        ieee double precision format
;
; IMPORTANT POINT: you MUST unpile the EXACT number of parameters to restore A3 to its original level. If you do not, you will not
; have a immediate error, and AMOS will certainely crash on next UNTIL / WEND / ENDIF / NEXT etc... 
; +++ So, your instruction must:
;    - Unpile the EXACT number of parameters from A3 (if needed), and exit with A3 at the original level it was before collecting your parameters)
;    - Preserve A4, A5, A6, D6 and D7. Warning D6/D7 was not preserved before V2.x of AMOSPro. Re-read your code, or use the "L_SaveRegs" and
;      "L_LoadRegs" routines.
;    - You can use D0-D5/A0-A2 freely...

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : Lib_Empty                                   *
; *-----------------------------------------------------------*
; * Description : This method is required and must be at the  *
; * 1st place in the methods list of the .lib                 *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    Lib_Empty

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :                                     *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

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
  Lib_Par      SNTSC
    move.w      #$0000,$DFF1DC
    rts

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
  Lib_Par      SPAL
    move.w      #$0020,$DFF1DC
    rts

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
  Lib_Par      RCLICK
    Move.l      #0,d2
    Moveq      #0,d3
    Btst        #2,$Dff016
    Bne.b       .F1
    Move.l      #$ffffffff,d3
.F1:
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
  Lib_Par      FIRE2
    Move.l      #0,d2
    Moveq       #0,d3
    Btst        #6,$Dff016
    Bne.b       .F2
    Move.l      #$ffffffff,d3
.F2:
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
  Lib_Par      FIRE3
    Move.l      #0,d2
    Moveq       #0,d3
    Btst        #4,$Dff016
    Bne.b       .F3
    Move.l      #$ffffffff,d3
.F3:
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
  Lib_Par      EHB
    Moveq       #64,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getHam6Value                              *
; *-----------------------------------------------------------*
; * Description : This method will return an integer value of *
; * 4096 and can be used in the Amos Professional method cal- *
; * -led "Screen Open" to open a HAM6 screen.                 *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : 4096 (Integer)                             *
; *************************************************************
    ; ****************************************** Return Ham6 value for screen open (=4096)
  Lib_Par      getHam6Value
    Move.l     #4096,d3
    Ret_Int

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME : Memblocks methods support           *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************
  
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : Create Memblock ID,Size                     *
; *-----------------------------------------------------------*
; * Description : This method will try to create a new memory *
; *               block                                       *
; *                                                           *
; * Parameters : (a3)+ = Memblock ID                          *
; *              d3 = Memblock size in bytes                  *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      CreateMemblock
; **************** 1. Check if MemblockID and Size mets the requirements
    move.l      (a3)+,d0               ; D0 = Memblock ID, D3 = Memblock Size
    cmp.l       #5,d0
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d0
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #16,d3                 ; 
    Rblt        L_Err12                ; Memblock size < 16 -> Error : Memblock size is invalid
    moveq       #(1<<Bnk_BitMemblock)+(1<<Bnk_BitData),d1    Flags ; Memblock,DATA, FAST
    move.l      d3,d2                  ; D2 = Memblock Size
    add.l       #4,d2                  ; +4 to save memblock size
    lea         BkMbc(pc),a0           ; A0 = Pointer to BkMbc (Bank Name)
    Rjsr        L_Bnk.Reserve
    Rbeq        L_Err11                ; Not Enough Memory to allocation memblock.
    move.l      a0,a1                  ; A1 = Memory Bank pointer (required for L_Bnk_Change)
    move.l      d3,(a0)
    Rjsr        L_Bnk.Change           ; Tell Amos Professional Unity Extensions that Memory Banks changed (to update)
    rts
BkMbc:
    dc.b       "MemBlock",0,0



;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : = Memblock Exist( MemblockID )              *
; *-----------------------------------------------------------*
; * Description : This method will return 1 if the bank exists*
; *               and is flagged as Memblock bank             *
; *                                                           *
; * Parameters : D3 = Memblock ID                             *
; *                                                           *
; * Return Value : 1 or 0                                     *
; *************************************************************
  Lib_Par      MemblockExists
    cmp.l       #5,d3
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d3
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    move.l      d3,d0
    clr.l       d3
    Rjsr        L_Bnk.GetAdr
    beq.s       .none
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    beq.s       .none
    move.l      #1,d3
.none:
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
  Lib_Par      GetMemblockSize
    cmp.l       #5,d3
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d3
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    move.l      d3,d0
    clr.l       d3
    Rjsr        L_Bnk.GetAdr
    Rbeq        L_Err13
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14
    Move.l      (a0),d3
    Ret_Int



;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : Write Memblock Long MBCID, POSITION, VALUE  *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : MemblockID, MemblockPosition, IntegerToWrite *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      WriteMemblockLong       ; D3 = Value To Write
    move.l      (a3)+,d4               ; D4 = Memblock Position
    move.l      (a3)+,d5               ; D5 = Memblock ID
    cmp.l       #5,d5
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d5
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #0,d4                  ; Position < 0 ?
    Rbmi        L_Err15                ; Yes -> Error
    btst        #0,d4                  ; Is adress odd ?
    Rbne        L_Err16                ; Error : Mamory adress is not word aligned
    move.l      d5,d0                  ; D0 = Memblock ID 
    Rjsr        L_Bnk.GetAdr           ; A0 = Memblock ADR
    Rbeq        L_Err13                ; A0 = 0 = No Memblock -> Error
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14                ; Not a memblock -> Error
    Move.l      (a0)+,d0               ; D0 = Memblock Size, A0 = Pointer to Memblock byte #0 
    cmp.l       d4,d0
    Rblt        L_Err15                ; Outside MemBlock
    adda.l      d4,a0                  ; a0 = Position to write inside the Memblock
    move.l      d3,(a0)
    rts
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
  Lib_Par      ReadMemblockLong        ; D3 = Position To Read
    move.l      (a3)+,d5               ; D5 = Memblock ID
    cmp.l       #5,d5
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d5
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #0,d3                  ; Position < 0 ?
    Rbmi        L_Err15                ; Yes -> Error
    btst        #0,d3                  ; Is adress odd ?
    Rbne        L_Err16                ; Error : Mamory adress is not word aligned
    move.l      d5,d0                  ; D0 = Memblock ID 
    Rjsr        L_Bnk.GetAdr           ; A0 = Memblock ADR
    Rbeq        L_Err13                ; A0 = 0 = No Memblock -> Error
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14                ; Not a memblock -> Error
    Move.l      (a0)+,d0               ; D0 = Memblock Size, A0 = Pointer to Memblock byte #0 
    cmp.l       d3,d0
    Rblt        L_Err15                ; Outside MemBlock
    adda.l      d3,a0                  ; a0 = Position to write inside the Memblock
    move.l      (a0),d3
    Ret_Int
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : Write Memblock Word MBCID, POSITION, VALUE  *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : MemblockID, MemblockPosition, WordToWrite    *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      WriteMemblockWord       ; D3 = Value To Write
    move.l      (a3)+,d4               ; D4 = Memblock Position
    move.l      (a3)+,d5               ; D5 = Memblock ID
    cmp.l       #5,d5
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d5
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #0,d4                  ; Position < 0 ?
    Rbmi        L_Err15                ; Yes -> Error
    btst        #0,d4                  ; Is adress odd ?
    Rbne        L_Err16                ; Error : Mamory adress is not word aligned
    move.l      d5,d0                  ; D0 = Memblock ID 
    Rjsr        L_Bnk.GetAdr           ; A0 = Memblock ADR
    Rbeq        L_Err13                ; A0 = 0 = No Memblock -> Error
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14                ; Not a memblock -> Error
    Move.l      (a0)+,d0               ; D0 = Memblock Size, A0 = Pointer to Memblock byte #0 
    cmp.l       d4,d0
    Rblt        L_Err15                ; Outside MemBlock
    adda.l      d4,a0                  ; a0 = Position to write inside the Memblock
    move.w      d3,(a0)
    rts
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
  Lib_Par      ReadMemblockWord        ; D3 = Position To Read
    move.l      (a3)+,d5               ; D5 = Memblock ID
    cmp.l       #5,d5
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d5
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #0,d3                  ; Position < 0 ?
    Rbmi        L_Err15                ; Yes -> Error
    btst        #0,d3                  ; Is adress odd ?
    Rbne        L_Err16                ; Error : Mamory adress is not word aligned
    move.l      d5,d0                  ; D0 = Memblock ID 
    Rjsr        L_Bnk.GetAdr           ; A0 = Memblock ADR
    Rbeq        L_Err13                ; A0 = 0 = No Memblock -> Error
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14                ; Not a memblock -> Error
    Move.l      (a0)+,d0               ; D0 = Memblock Size, A0 = Pointer to Memblock byte #0 
    cmp.l       d3,d0
    Rblt        L_Err15                ; Outside MemBlock
    adda.l      d3,a0                  ; a0 = Position to write inside the Memblock
    move.w      (a0),d3
    and.l       #$FFFF,d3
    Ret_Int
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : Write Memblock Long MBCID, POSITION, VALUE  *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : MemblockID, MemblockPosition, IntegerToWrite *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      WriteMemblockByte       ; D3 = Value To Write
    move.l      (a3)+,d4               ; D4 = Memblock Position
    move.l      (a3)+,d5               ; D5 = Memblock ID
    cmp.l       #5,d5
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d5
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #0,d4                  ; Position < 0 ?
    Rbmi        L_Err15                ; Yes -> Error
    move.l      d5,d0                  ; D0 = Memblock ID 
    Rjsr        L_Bnk.GetAdr           ; A0 = Memblock ADR
    Rbeq        L_Err13                ; A0 = 0 = No Memblock -> Error
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14                ; Not a memblock -> Error
    Move.l      (a0)+,d0               ; D0 = Memblock Size, A0 = Pointer to Memblock byte #0 
    cmp.l       d4,d0
    Rblt        L_Err15                ; Outside MemBlock
    adda.l      d4,a0                  ; a0 = Position to write inside the Memblock
    move.b      d3,(a0)
    rts
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
  Lib_Par      ReadMemblockByte        ; D3 = Position To Read
    move.l      (a3)+,d5               ; D5 = Memblock ID
    cmp.l       #5,d5
    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
    cmp.l       #255,d5
    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
    cmp.l       #0,d3                  ; Position < 0 ?
    Rbmi        L_Err15                ; Yes -> Error
    move.l      d5,d0                  ; D0 = Memblock ID 
    Rjsr        L_Bnk.GetAdr           ; A0 = Memblock ADR
    Rbeq        L_Err13                ; A0 = 0 = No Memblock -> Error
    btst        #Bnk_BitMemblock,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err14                ; Not a memblock -> Error
    Move.l      (a0)+,d0               ; D0 = Memblock Size, A0 = Pointer to Memblock byte #0 
    cmp.l       d3,d0
    Rblt        L_Err15                ; Outside MemBlock
    adda.l      d3,a0                  ; a0 = Position to write inside the Memblock
    move.b      (a0),d3
    And.l       #$FF,d3
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
  Lib_Par      CreateMemblockFromFile  ; D3 = Memblock ID
    move.l      (a3)+,d4               ; D4 = File Name
;    movem.l     d3,-(sp)               ; Save Memblock ID
;    ; Check if memblock ID is correct or not.
;    cmp.l       #5,d3
;    Rble        L_Err10                ; Memblock ID < 6 -> Error : Invalid range
;    cmp.l       #255,d3
;    Rbhi        L_Err10                ; Memblock ID > 255 -> Error : Invalid range
;; ******** Open File
;    move.l     a4,a2                   ; a2 = a4 = FileName
;    Rbsr       L_NomDisc2              ; This method will update the filename to be full Path+FileName
;    move.l     #1005,d2                ; D2 = READ ONLY dos file mode
;    Rbsr       L_OpenFile              ; Dos->Open
;    Rbeq       L_DiskFileError         ; -> Error when trying to open the file.
;    Rbsr       L_SaveRegsD6D7           ; Save AMOS System registers
;    move.l     Handle(a5),d1           ; D1 = File Handle
;; ******** Get the file size
;   Rbsr        L_LoadRegsD6D7
   rts

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :                                     *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *   D3 = Amount of F Icons to reserve/allocate              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      ReserveFIcons
 ; **************** 1. Check if FIcon ID and Size mets the requirements
    move.l      (a3)+,d0               ; D0 = Memory Bank ID, D3 = Amount of F Icons (d4->d0)
    cmp.l       #5,d0
    Rble        L_Err1                 ; ID < 6 -> Error : Invalid range
    cmp.l       #255,d0
    Rbhi        L_Err1                 ; ID > 255 -> Error : Invalid range
    cmp.l       #4,d3                  ; 
    Rblt        L_Err2                 ; FIcons Amount < 4 -> Error : FIcons Amount is invalid
; ******** Calculate the length (in bytes) of the bank in D2
    move.l      d3,d2                  ; D2 = Icons Amount
    lsl.l       #5,d2                  ; D2 = Icon Amount * 16 Lines per Icon * 2 bytes per lines (global *32)
    mulu        #9,d2                  ; Maximum 8 Bitplanes + 1 Mask (Makes AGA banks being capable to be used on ECS screens as paste uses screen bpls limit)
    add.l       #FIconsData,d2         ; FullBlockSize.l, Amount.w, Width.w, Height.w, Depth.w
    Movem.l     d2-d4,-(a3)            ; Save D2,D3,D4 (D2=FullBlockSize,D3=IconsCount,D4=MemoryBank)
; ******** Define the bank datatype in D1
    moveq       #(1<<Bnk_BitFIcons)+(1<<Bnk_BitData),d1    Flags ; Fast Icon,DATA, FAST
    lea         BkFIco(pc),a0          ; A0 = Pointer to BkFIco (Bank Name)
    Rjsr        L_Bnk.Reserve          ; -> Need D0=BankID, D1=Flags, D2=Size(In bytes)
    Rbeq        L_Err3                 ; Not Enough Memory to allocation Fast Icon bank
    move.l      a0,a1                  ; A1 = Memory Bank pointer (required for L_Bnk_Change)
    ; **************** 3. Now that the memory block (bank) is created we save informations in it.
    Movem.l     (a3)+,d2-d4            ; Load D2,D3,D4 (FullBlockSize,D3=IconsCount,D4=MemoryBank)
    move.l      d2,FIconsBlockSize(a0) ; Save Full Block Size
    move.w      d3,FIconsAmount(a0)    ; Save Amount of Icons Available
    move.w      #16,FIconsWidth(a0)    ; Save Icons Width
    move.w      #16,FIconsHeight(a0)   ; Save Icons HEeght
    cmp.w       #0,T_isAga(a5)         ; Check if program is running under AGA or ECS
    beq.s       .useECS2
.useAGA2:                              ; We are on AGA chipset
    move.w      #8,FIconsDepth(a0)     ; Save Icons Depth : Maximum 8 Bitplanes + 1 Mask
    bra.s       .follow2               ; -> .Follow2
.useECS2:                              ; We are on ECS/OCS chipset
    move.w      #6,FIconsDepth(a0)     ; Save Icons Depth : Maximum 6 Bitplanes + 1 Mask
.follow2:
    ; *************** 4. Save The Current Icon Bank as "Current"
    Dlea        CurrentFIconBank,a0
    move.l      d4,(a0)                ; Save CurrentFIconBank as the one freshly created
    Rjsr        L_Bnk.Change           ; Tell Amos Professional Unity Extensions that Memory Banks changed (to update) (a1 use)
    rts
BkFIco:
    dc.b       "F Icons ",0,0

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
  Lib_Par      UseFIconBank
    cmp.l       #5,d3
    Rble        L_Err1                 ; ID < 6 -> Error : Invalid range
    cmp.l       #255,d3
    Rbhi        L_Err1                 ; ID > 255 -> Error : Invalid range
    movem.l     d3,-(sp)               ; Save BankID
    move.l      d3,d0
    clr.l       d3
    Rjsr        L_Bnk.GetAdr
    Rbeq        L_Err4
    btst        #Bnk_BitFIcons,d0    ; No Bnk_BitMemblock flag = not a memblock
    Rbeq        L_Err5
    move.l      (sp)+,d3
    Dlea        CurrentFIconBank,a0
    move.l      d3,(a0)
    rts
; F Icon Content :
; 1 ICON = 9 Bitplanes * 16 lignes each
; Storing 1 full line after the other one.
; Storing line X Mask.w Bpl1.w Bpl2.w Bpl3.w Bpl4.w .... Bpl8.w
; Next line.

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
  Lib_Par      GetCurrentFIconBank
    Dlea        CurrentFIconBank,a0
    move.l      (a0),d3
    Ret_Int
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : IconID, inScreenXPos, inScreenYPos           *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      GetFIcon               ; D3 = inScreenYPos
    ; **************** 1. We get information from a3 stack
    move.l      (a3)+,d4              ; D4 = inScreenXPos
    move.l      (a3)+,d5              ; D5 = IconID
    exg         d3,d5                 ; D3 = Icon ID, D4 = inScreenXPos, D5 = inScreenYPos
    ; **************** 2. We check if the "Current Fast Icon Bank" exists and is valid
    Dlea        CurrentFIconBank,a0
    move.l      (a0),d0               ; d0 = FIcon Bank in use
    Rjsr        L_Bnk.GetAdr          ; Get Bank memory adress (does not modify d3-d5)
    Rbeq        L_Err4                ; Bank does not exists
    btst        #Bnk_BitFIcons,d0     ; check No Bnk_BitFIcons flag = not a memblock
    bne.s       .BankIsOk             ; Bank is a FIcons one -> Jmp to .BankIsOk
.B_Err5:
    Rbra        L_Err5                ; Error, not a FIcons bank
 .BankIsOk:
    move.l      a0,a2                 ; a2 = F Icon Bank Adress
    ; **************** 3. Now, we check if Icon ID is correct and fit in the bank.
    cmp.l       #0,d3
    Rble        L_Err7                ; FIcon ID not in Bank Range
    cmp.w       FIconsAmount(a2),d3
    ble         .ok
    Rbra        L_Err7                ; FIcon ID not in Bank Range
.ok:

; *********************************** Important variables state :
; ** A2 = Icon Bank Pointer
; ** D3 = IconID
; ** D4 = inScreenXPos
; ** D5 = inScreenYPos
; ***********************************

    ; **************** 4. We get the current screen to capture the Icon    
	move.l	    ScOnAd(a5),d0         ; D0 = Get Current Screen
    Rbeq        L_Err6
    move.l      d0,a1                 ; *********************************************** a1 = Screen Structure Pointer

    movem.l     d6-d7,-(sp)

    sub.l       #1,d3                 ; D3 = IconID Shift = IconID -1 (true Icon index start at 0, where Icon 0 = no shift)
    ; **************** 5. We push a2 adress to point at the start of the Icon to grab
    move.w      FIconsDepth(a2),d2    ; D2.w = FIcon Depth (Bitplanes only)
    ext.l       d2                    ; D2.l = FIcon Depth (Bitplanes only)
    move.l      d2,d7                 ; D7.l = FIcon Depth (Bitplanes only) [Save]
    addq        #1,d2                 : D2.L = FIcon Depth (Bitplanes + Mask)
    lsl.l       #5,d2                 ; D2.l = FIcon Size in bytes
    mulu.w      d3,d2                 ; D2 = Shift in Icon Bank where to start Icon writing
    add.l       #FIconsData,d2        ; D2 = Add Bank header so now, D2 is real shift in a2 to start write the F Icon
    add.l       d2,a2                 ; A2 = Pointer to the F Icon to grab

; *********************************** Important variables state :
; ** A1 = Current Screen Structure Pointer
; ** D3 = IconID-1 (True Icon index start at 0 instead of 1)
; ** D4 = inScreenXPos
; ** D5 = inScreenYPos
; ** A2 = Icon #IconID Pointer (1st pixel of icon mask bitplane)
; ***********************************

    ; **************** 6. Store current screen information
    move.w      EcTx(a1),d0           ; d0 = Screen Width in pixels
    ext.l       d0                    ; extends d0.w -> d0.l
    move.w      EcTy(a1),d1           ; d1 = Screen Height in pixels
    ext.l       d1                    ; extends d1.w -> d1.l

    ; **************** 7. Verify that F Icon to grab coordinates are inside screen sizes
    tst.l       d4                    ; Is XPos < 0 ?
    Rblt        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)
    tst.l       d5                    ; Is YPos < 0 ?
    Rblt        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)
    cmp.l       d0,d4                 ; is XPos >= Screen Width ?
    Rbge        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)
    sub.l       #15,d1                ; Screen Height -15 (for F Icon grab position limits)
    cmp.l       d1,d5                 ; is YPos >= Screen Height ?
    Rbge        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)

    ; **************** 8. Calculate the offset in the bitplanes to start grab the Icon
    move.w      EcTLigne(a1),d0       ; D0 = Screen line size in bytes
    ext.l       d0
    mulu.w      d0,d5                 ; D5 = Y Line Offset
    lsr.l       #3,d4                 ; D2 = Icon X Pos X Shift (in bytes, can be odd)
    bclr        #0,d4                 ; Clear #0 (Makes D2 be 16 Pixels aligned, always even adress) / D4 = X Offset
    add.l       d4,d5                 ; *********************************************** D5 = Final Offset inside bitplanes
    move.l      a2,d4                 ; D4 = Icon Pointer


; *********************************** Important variables state :
; ** A1 = Current Screen Structure Pointer
; ** A2 = Icon #IconID Pointer (1st pixel of icon mask bitplane)
; ** D4 = Icon #IconID Pointer (1st pixel of icon mask bitplane) [Save]
; ** D5 = X,Y FIcon to grab position inside Screen 
; ** D0 = Bitplan Width in Bytes
; ** D7 = Icon Depth (Bitplanes Only)
; ***********************************

    ; **************** 9. We grab the icon
    move.l     d7,d6                  ; D6 = Icon Depth to grab
    add.l      #1,d6                  ; D6 = True Icon Bitplanes Amount (counting Mask one)
    lsl.l      #1,d6                  ; D6 = 1 line ( X Bpls + Mask ) size in bytes
    lea        EcCurrent(a1),a1        ; a1 = Pointer sur EcPhysic Bitplan 0
    move.l     d7,d3                  ; D5 = Icon Depth to grab
    subq       #1,d3                  ; for dbra works for the loop ( Icon Depth -1 )
    move.l     #2,d1                  ; D1 = Start Bitplan Shift in ICON ( For Bitplane 0 , After mask )
.BplsLoop:
    move.l     (a1)+,a0               ; A0 = Bitplan X Pointer, A1 = Pointer to next bitplane
    add.l      d5,a0
    cmp.l      #0,a0                  ; Current Bitplane = NULL (=0) ?
    beq.s      .endOfCopy             ; Can occur if screen have less bitplanes than the Icon limitation
    move.l     d4,a2                  ; A2 = Start Icon (Bitplan Mask, Position 0,0)
    moveq      #15,d2                 ; 16 lines to copy (-1 will stop copy)
    Add.l      d1,a2                  ; A2 = Start Icon (Bitplan D1  , Position 0,0)
.linesLoop
    move.w     (a0),(a2)              ; Grab 2 Bytes = 16 Pixels for the icon
    add.l      d0,a0                  ; a0 = Next Bitplane Line position
    add.l      d6,a2                  ; a3 = Next Icon Line
    dbra       d2,.linesLoop          ; Continue Copy until 16 lines are done
    add.l      #2,d1                  ; D2 = Next Icon Bitplane to copy
    dbra       d3,.BplsLoop           ; Jump to Next Bitplane Copy if not finished
.endOfCopy:

    bra.s      .ende
; *********************************** Important variables state :
; ** D4 = Icon #IconID Pointer (1st pixel of icon mask bitplane) [Save]
; ** D6 = 1 line ( X Bpls + Mask ) size in bytes
; ** D7 = Icon Depth (Bitplanes Only)
; ***********************************
;    moveq      #18,d6                 ; 9 bpls * 2 = 18 bytes per icon line.
    ; **************** 10. Last phase, we calculate the mask.
    moveq      #15,d2                 ; D2 = 16 lines to check
    move.l     d4,a0                  ; A0 = Pointer to Icon Line 0 Mask Plane
.linesLoop2:
    clr.l      d0                     ; D0 = Clear MASK
    move.l     a0,a1                  ; A1 = Pointer to Icon Current Line Mask (-1)
    add.l      #2,a1                  ; A1 = Current Line Bitplane 0            
    move.l     d7,d1                  ; D1 = Icon Depth
    subq       #1,d1                  ; D1 = Icon Depth - 1 / for Dbra loop
.bplsLoop2:
    move.w     (a1)+,d5               ; D5 = Bpl(x) datas content
    or.w       d5,d0                  ; D0 = D0 + D5 (Mask all pixels)
    dbra       d1,.bplsLoop2          ; Next bitplane for this line ? Yes -> .bplsLoop2
    not        d0                     ; D0 = Mask of acceptation
    move.w     d0,(a0)
    add.l      d6,a0                  ; A0 = Pointer to next Icon line X Mask Plane
    dbra       d2,.linesLoop2         ; Next Line for this icon ? Yes -> .linesLoop2

.ende:
    movem.l     (sp)+,d6-d7
    moveq      #0,d0                  ; D0 = 0 -> Everything completed with no problem
    rts

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
  Lib_Par      PasteFIcon1            ; D3 = inScreenYPos
    move.l      d3,-(a3)              ; push inScreenYPos in a3 stack
    move.l      #0,d3                 ; D3 = No Mask
    Rbra       L_PasteFIcon2

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
  Lib_Par      PasteFIcon2            ; D3 = inScreenYPos
    ; **************** 1. We get information from a3 stack
    move.b      d3,d2                 ; D2.b = Mask or not Mask.
    move.l      (a3)+,d3              ; D3 = inScreenYPos
    and.l       #$FF0,d3              ; D3 = inScreenYPos (multiples of 16)
    move.l      (a3)+,d4              ; D4 = inScreenXPos
    move.l      (a3)+,d5              ; D5 = IconID
    exg         d3,d5                 ; D3 = Icon ID, D4 = inScreenXPos, D5 = inScreenYPos
    movem.l     d6-d7/a3,-(sp)
    move.b      d2,d6                 ; D6.b = Mask or not Mask [Save]
    ; **************** 2. We check if the "Current Fast Icon Bank" exists and is valid
    Dlea        CurrentFIconBank,a0
    move.l      (a0),d0               ; d0 = FIcon Bank in use
    Rjsr        L_Bnk.GetAdr          ; Get Bank memory adress (does not modify d3-d5)
    Rbeq        L_Err4                ; Bank does not exists
    btst        #Bnk_BitFIcons,d0     ; check No Bnk_BitFIcons flag = not a memblock
    bne.s       .BankIsOk             ; Bank is a FIcons one -> Jmp to .BankIsOk
.B_Err5:
    Rbra        L_Err5                ; Error, not a FIcons bank
 .BankIsOk:
    move.l      a0,a2                 ; a2 = F Icon Bank Adress
    ; **************** 3. Now, we check if Icon ID is correct and fit in the bank.
    cmp.l       #0,d3
    Rble        L_Err7                ; FIcon ID not in Bank Range
    cmp.w       FIconsAmount(a2),d3
    ble         .ok
    Rbra        L_Err7                ; FIcon ID not in Bank Range
.ok:

; *********************************** Important variables state :
; ** A2 = Icon Bank Pointer
; ** D3 = IconID
; ** D4 = inScreenXPos
; ** D5 = inScreenYPos
; ***********************************

    ; **************** 4. We get the current screen to capture the Icon    
	move.l	    ScOnAd(a5),d0         ; D0 = Get Current Screen
    Rbeq        L_Err6
    move.l      d0,a1                 ; *********************************************** a1 = Screen Structure Pointer
    subq        #1,d3                 ; D3 = IconID Shift = IconID -1 (true Icon index start at 0, where Icon 0 = no shift)
    ; **************** 5. We push a2 adress to point at the start of the Icon to grab
    move.w      FIconsDepth(a2),d2    ; D2.w = FIcon Depth (Bitplanes only)
;    ext.l       d2                    ; D2.l = FIcon Depth (Bitplanes only)
    move.w      d2,d7                 ; D7.l = FIcon Depth (Bitplanes only) [Save]
    addq        #1,d2                 : D2.L = FIcon Depth (Bitplanes + Mask)
    lsl.w       #5,d2                 ; D2.l = FIcon Size in bytes
    mulu.w      d3,d2                 ; D2 = Shift in Icon Bank where to start Icon writing
    add.w       #FIconsData,d2        ; D2 = Add Bank header so now, D2 is real shift in a2 to start write the F Icon
    add.w       d2,a2                 ; A2 = Pointer to the F Icon to grab

; *********************************** Important variables state :
; ** A1 = Current Screen Structure Pointer
; ** D3 = IconID-1 (True Icon index start at 0 instead of 1)
; ** D4 = inScreenXPos
; ** D5 = inScreenYPos
; ** A2 = Icon #IconID Pointer (1st pixel of icon mask bitplane)
; ***********************************

    ; **************** 6. Store current screen information
    move.w      EcTx(a1),d0          ; d0.w = Screen Width in pixels
    ext.l       d0                    ; extends d0.w -> d0.l
    move.w      EcTy(a1),d1          ; d1.w = Screen Height in pixels
    ext.l       d1                    ; extends d1.w -> d1.l
    move.w      EcNPlan(a1),d7        ; d7.w = Screen Depth in bitplanes amount
    ext.l       d7

    ; **************** 7. Verify that F Icon to grab coordinates are inside screen sizes
    tst.w       d4                    ; Is XPos < 0 ?
    Rblt        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)
    tst.w       d5                    ; Is YPos < 0 ?
    Rblt        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)
    cmp.w       d0,d4                 ; is XPos >= Screen Width ?
    Rbge        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)
    sub.w       #15,d1                ; Screen Height -15 (for F Icon grab position limits)
    cmp.w       d1,d5                 ; is YPos >= Screen Height ?
    Rbge        L_Err8                ; Yes -> Error Err8 (Out of screen coordinates)

    ; **************** 8. Calculate the offset in the bitplanes to start grab the Icon
    move.w      EcTLigne(a1),d0       ; D0 = Screen line size in bytes
;    ext.l       d0
    mulu.w      d0,d5                 ; D5 = Y Line Offset
    lsr.l       #3,d4                 ; D2 = Icon X Pos X Shift (in bytes, can be odd)
    bclr        #0,d4                 ; Clear #0 (Makes D2 be 16 Pixels aligned, always even adress) / D4 = X Offset
    add.l       d4,d5                 ; *********************************************** D5 = Final Offset inside bitplanes
    move.l      a2,d4                 ; D4 = Icon Pointer

; *********************************** Important variables state :
; ** A1 = Current Screen Structure Pointer
; ** D4 = Icon #IconID Pointer (1st pixel of icon mask bitplane) [Save]
; ** D5 = X,Y FIcon to grab position inside Screen 
; ** D0 = Bitplan Width in Bytes
; ** D7 = Screen Depth (Bitplanes Only)
; ***********************************
; D6 = Amount of icon lines to paste (=15 for 16 lines, dbra makes end at -1)
; a3 = EcCurrent bitplanes pointer of current screen
; ** A2 = Icon #IconID Pointer (1st pixel of icon mask bitplane)
; A1 = Bitplanes List pointer
; A0 = Bitplane X pointer + InPos X,Y for Icon
; D1 = Icon Depth (based on screen depth as icons are always 8 bitplanes)
; D2 = Screen Datas
; D3 = Mask
;
    ; **************** 9. We push the icon in the Screen
    lea        EcCurrent(a1),a3       ; a3 = Pointer sur EcCurrent (=EcPhysic) Bitplan 0
    tst.b      d6                     ; d6.b = Mask on [=1] or Mask Off [=0]
    beq.s      .drawNoMask

.DrawWithMask:
    moveq      #15,d6                 ; d6 = 16 lines to push into the screen
.linesLoop2:
    move.w     d7,d1                  ; D1.b = Icon Depth to grab
    subq       #1,d1                  ; for dbra works for the loop ( Icon Depth -1 )
    move.l     d4,a2                  ; A2 = Pointer to the current FIcon line to paste
    move.w     (a2)+,d3               ; d3 = Mask to apply to screen data before including icon ones.
    move.l     a3,a1                  ; a1 = Pointer sur EcCurrent
.BplsLoop2:
    move.l     (a1)+,a0               ; a0 = BitPlane X pointer
;    cmp.l      #0,a0
;    beq.s      .nextLine
    add.l      d5,a0                  ; a0 = Bitplane X pointer to X,Y position to paste.
    move.w     (a0),d2                ; D2 = Screen Datas
    and.w      d3,d2                  ; D2 = Screen Datas modified by Mask
    or.w       (a2)+,d2               ; D2 = Screen Datas + Icon Datas using MASK
    move.w     d2,(a0)                ; Push new modified data inside Screen
    dbra       d1,.BplsLoop2
.nextLine:
    add.l      #18,d4                 ; D4 = Move Icon pointer to next line
    add.l      d0,d5
    dbra       d6,.linesLoop2
    bra.s      .endOfCopy4

.drawNoMask:
    moveq      #15,d6                 ; d6 = 16 lines to push into the screen
.linesLoop3:
    move.w     d7,d1                  ; D5 = Icon Depth to grab
    subq       #1,d1                  ; for dbra works for the loop ( Icon Depth -1 )
    move.l     d4,a2                  ; A2 = Pointer to the current FIcon line to paste
    add.w      #2,a2
    move.l     a3,a1                  ; a1 = Pointer sur EcCurrent
.BplsLoop3:
    move.l     (a1)+,a0               ; a0 = BitPlane X pointer
;    cmp.l      #0,a0
;    beq.s      .nextLine2
    add.l      d5,a0                  ; a0 = Bitplane X pointer to X,Y position to paste.
    move.w     (a2)+,(a0)
    dbra       d1,.BplsLoop3
.nextLine2:
    add.l      #18,d4                 ; D4 = Move Icon pointer to next line
    add.l      d0,d5
    dbra       d6,.linesLoop3

.endOfCopy4:
    movem.l    (sp)+,d6-d7/a3
    moveq      #0,d0                  ; D0 = 0 -> Everything completed with no problem
    rts


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                          *                                                  *
;                                                                                          * AREA NAME :                                      *
;                                                                                          *                                                  *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                          *                                                  *
;                                                                                          * AREA NAME : Miscellaneous methods                *
;                                                                                          *                                                  *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

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
  Lib_Par      GetFileSize
    move.l      d3,a2                   ; A2.l = FileName to load.
    ; ******** Firstly, we check if the filename contain a path. To do that we check for a ":" (a2=filename)
    Rbsr       L_NomDisc2               ; This method will update the filename to be full Path+FileName
    ; ******** Then we open the file
    move.l     #1005,d2                 ; D2 = READ ONLY dos file mode
    Rbsr       L_OpenFile               ; Dos->Open
    Rbeq       L_DiskFileError          ; -> Error when trying to open the file.
    Rbsr       L_SaveRegsD6D7           ; Save AMOS System registers
    ; ******** Thirdly we create the File Info Block
    move.l     #DOS_FIB,d1              ; D1 = FileInfoBlock type
    lea        Tags(pc),a0
    move.l     a0,d2
    DosCall    _LVOAllocDosObject       ; D0 = File Info Block
    Rbeq       L_DiskFileError          ; -> Error if Dos Object was not allocated
    move.l     d0,T_SaveReg(a5)         ; Save FIB / File Info Block for future use
    ; ******** Fourthly we use ExamineFH to get the File Size
    move.l     Handle(a5),d1            ; D1 = File Handle
    move.l     d0,d2                    ; D2 = FIB / File Info Block
    DosCall    _LVOExamineFH
    Rbeq       L_DiskFileError          ; D0 = Success in file examineFH method
    ; ******** Now we get the file size and save it
    move.l     T_SaveReg(a5),a0         ; A0 = FIB / File Info Block
    move.l     fib_Size(a0),T_SaveReg2(a5) ; Output File Size
    ; ******** And finally we close the Dos Object FIB
    move.l     #DOS_FIB,d1              ; D1 = FileInfoBlock type
    move.l     T_SaveReg(a5),d2
    DosCall    _LVOFreeDosObject
    ; ******** We close the file handle

    move.l     Handle(a5),d1           ; D1 = File Handle
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close
    ; ********
    clr.l      T_SaveReg(a5)
    move.l     T_SaveReg2(a5),d3
    clr.l      T_SaveReg2(a5)
    Ret_Int
Tags:
    dc.l      TAG_DONE
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


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                          *                                                  *
;                                                                                          * AREA NAME : Methods imported from AmosProAGA.lib *
;                                                                                          *                                                  *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_NomDisc2                                  *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It is used to complete the file*
; * name with full absolute path if not available.            *
; *                                                           *
; * Parameters : A2 = Pointer to the file name string. The fi-*
; *                   -le size is located in the first long   *
; *                                                           *
; * Return Value : Name1(a5) = The file name with full path   *
; *                            added if required.             *
; *************************************************************
  Lib_Def      NomDisc2
    move.w     (a2)+,d2
    Rbeq       L_FonCall2
    cmp.w      #108,d2
    Rbcc       L_FonCall2
    move.l     Name1(a5),a0
    Rbsr       L_ChVerBuf22
    Rjsr       L_Dsk.PathIt
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_ChVerBuf22                                *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It is used to check if the file*
; * name is not too big to be handle by Amos Professional.    *
; *                                                           *
; * Parameters : A2 = Pointer to the file name string         *
; *              D2 = length of the string in bytes           *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      ChVerBuf22
    move.l     a2,a1
    move.w     d2,d0
    beq.s      Chv2
    subq.w     #1,d0
    cmp.w      #510,d0
    bcs.s      Chv1
    move.w     #509,d0
Chv1:
    move.b     (a1)+,(a0)+
    dbra       d0,Chv1
Chv2:
    clr.b      (a0)+
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_FonCall2                                  *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. it is an error call error #23  *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      FonCall2
    moveq      #23,d0
    Rbra       L_GoError2


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_GoError2                                  *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It call the Amos Professional  *
; * internal error handler to cast a previously specified er- *
; * -ror using its ID number.                                 *
; *                                                           *
; * Parameters : D0 = Error ID Number                         *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      GoError2
    Rjmp       L_Error

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_OpenFile                                  *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It open a file on a disk       *
; *                                                           *
; * Parameters : Name1(a5) = The full file name with absolute *
;*                           path to access it.               *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      OpenFile
    move.l     Name1(a5),d1
    Rbra       L_OpenFileD1

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_OpenFileD1                                *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It open a file on a disk       *
; *                                                           *
; * Parameters : D1 = The full file name with absolute path to*
;*                    access it.                              *
; *                                                           *
; * Return Value : Handle(a5) = Handler to the opened file    *
; *************************************************************
  Lib_Def      OpenFileD1
    move.l     a6,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOOpen(a6)
    move.l     (sp)+,a6
    move.l     d0,Handle(a5)
; Branche la routine de nettoyage en cas d''erreur
    move.l     a2,-(sp)
    lea        .Struc(pc),a1
    lea        Sys_ErrorRoutines(a5),a2
    SyCall     AddRoutine
    lea        .Struc2(pc),a1
    lea        Sys_ClearRoutines(a5),a2
    SyCall     AddRoutine
    move.l     (sp)+,a2
    move.l     Handle(a5),d0
    rts
.Struc:
    dc.l       0
    Rbra       L_CloseFile
.Struc2:
    dc.l       0
    Rbra       L_CloseFile

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_CloseFile                                 *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It closes a file on a disk that*
; * was previously opened using methods OpenFile or OpenFileD1*
; *                                                           *
; * Parameters : Handle(a5) = Handler to the opened file      *
; *                                                           *
; * Return Value : Handle(a5) = 0                             *
; *************************************************************
  Lib_Def      CloseFile
    movem.l    d0/d1/a0/a1/a6,-(sp)
    move.l     Handle(a5),d1
    beq.s      .Skip
    clr.l      Handle(a5)
    move.l     DosBase(a5),a6
    jsr        _LVOClose(a6)
.Skip:
    movem.l    (sp)+,d0/d1/a0/a1/a6
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_ReadFile                                 *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It read datas from an opened   *
; * file.                                                     *
; *                                                           *
; * Parameters : Handle(a5) = Handler to the opened file      *
; *              D2         = Buffer                          *
; *              D3         = Bytes amount to read from file  *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      ReadFile
    movem.l    d1/a0/a1/a6,-(sp)
    move.l     Handle(a5),d1
    move.l     DosBase(a5),a6
    jsr        _LVORead(a6)
    movem.l    (sp)+,d1/a0/a1/a6
    cmp.l      d0,d3
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_DiskFileError                             *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It get from the dos.library,   *
; * the ID of the last error occured                          *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : D1 = Last error occured                    *
; *************************************************************
  Lib_Def      DiskFileError
    move.l     a6,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOIoErr(a6)
    move.l     (sp)+,a6
    Rbra       L_DiskFileErr

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_DiskFileErr                               *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It cast Amos Professional error*
; * using the ID provided in D1                               *
; *                                                           *
; * Parameters : D1 = Error ID                                *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      DiskFileErr
    lea        ErDisk(pc),a0
    moveq      #-1,d1
DiE1:
    addq.l     #1,d1
    move.w     (a0)+,d2
    bmi.s      DiE2
    cmp.w      d0,d2
    bne.s      DiE1
    add.w      #DEBase,d1
    move.w     d1,d0
    move.l     Fs_ErrPatch(a5),d3
    Rbeq       L_GoError2
    move.l     d3,a0
    jmp        (a0)
DiE2:
    moveq      #DEBase+15,d0
    Rbra       L_GoError2
; Table for the known errors that can be cast to Amos Professional internal error handler.
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
ErDisk:
    dc.w 203,204,205,210,213,214,216,218
    dc.w 220,221,222,223,224,225,226,-1

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_SaveRegsD6D7                              *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. it simply save D6/D7 data regi-*
; * -sters to the stack pile (sp)                             *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      SaveRegsD6D7
    movem.l    d6-d7,ErrorSave(a5)
    move.b     #1,ErrorRegs(a5)
    rts
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_LoadRegsD6D7                              *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. it simply load D6/D7 data regi-*
; * -sters from the stack pile (sp)                           *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      LoadRegsD6D7
    movem.l    ErrorSave(a5),d6-d7
    clr.b      ErrorRegs(a5)
    rts

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
    Lib_Def    NullFct
    moveq      #0,d0
    rts


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    +++ ERROR MESSAGES...
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Lib_Def    FonCall
; - - - - - - - - - - - - -
    moveq     #23,d0
    Rbra    L_GoError

  Lib_Def Err1             ; The requested F Icons ID number is invalid (valid range=0-65535).
    moveq   #1,d0
    Rbra    L_Errors

  Lib_Def Err2             ; You cannot reserve less than 4 F Icons in a bank.
    moveq   #2,d0
    Rbra    L_Errors

  Lib_Def Err3             ; Not enough memory to allocate F Icon bank.
    moveq   #3,d0
    Rbra    L_Errors

  Lib_Def Err4             ; The requested memory bank does not exists.
    moveq   #4,d0
    Rbra    L_Errors

  Lib_Def Err5             ; The requested memory bank is not a F Icons one.
    moveq   #5,d0
    Rbra    L_Errors

  Lib_Def Err6             ; No Current Screen to grab the F Icon.
    moveq   #6,d0
    Rbra    L_Errors

  Lib_Def Err7             ; The F Icon ID Number does not fit the current F Icon Bank amount.
    moveq   #7,d0
    Rbra    L_Errors

  Lib_Def Err8             ; The F Icon coordinates are out of screen sizes.
    moveq   #8,d0
    Rbra    L_Errors

  Lib_Def Err9             ; 
    moveq   #9,d0
    Rbra    L_Errors

  Lib_Def Err10            ; The Memblock ID Range is 1-255
    moveq   #10,d0
    Rbra    L_Errors

  Lib_Def Err11            ; Not enough free memory to allocate the requested memblock
    moveq   #11,d0
    Rbra    L_Errors

  Lib_Def Err12            ; Memblock Size is incorrect
    moveq   #12,d0
    Rbra    L_Errors

  Lib_Def Err13            ; There is no memblock bank at this slot
    moveq   #13,d0
    Rbra    L_Errors

  Lib_Def Err14             ; This bank is not a memblock bank
    moveq   #17,d0
    Rbra    L_Errors

  Lib_Def Err15            ; The requested position is out of memblock size/range
    moveq   #18,d0
    Rbra    L_Errors

  Lib_Def Err16            ; The memblock position entered is not word aligned
    moveq   #21,d0
    Rbra    L_Errors

    Lib_Def Errors
    lea     ErrMess(pc),a0
    moveq   #0,d1        * Can be trapped
    moveq   #ExtNb,d2    * Number of extension
    moveq   #0,d3        * IMPORTANT!!!
    Rjmp    L_ErrorExt    * Jump to routine...

ErrMess:
    dc.b    "err0",0
    dc.b    "The requested F Icons ID number is invalid (valid range=0-65535).",0                  * Error #1
    dc.b    "You cannot reserve less than 4 F Icons in a bank.",0                                  * Error #2
    dc.b    "Not enough memory to allocate F Icon bank.",0                                         * Error #3
    dc.b    "The requested memory bank does not exists.",0                                         * Error #4
    dc.b    "The requested memory bank is not a F Icons one.",0                                    * Error #5
    dc.b    "No Current Screen to grab the F Icon.",0                                              * Error #6
    dc.b    "The F Icon ID Number does not fit the current F Icon Bank amount",0                   * Error #7
    dc.b    "The F Icon coordinates are out of screen sizes.",0                                    * Error #8
    dc.b    " ",0                                                                                  * Error #9 UNUSED
; ******** Memblocks error messages CURRENT VERSION
    dc.b    "Valid memblock id range is 6-65535.",0                                                * Error #10 USED
    dc.b    "Not enough free memory to allocate the requested memblock.",0                         * Error #11 USED
    dc.b    "Memblock Size is incorrect.",0                                                        * Error #12 USED
    dc.b    "There is no memblock bank at this slot.",0                                            * Error #13 USED
    dc.b    "This bank is not a memblock bank.",0                                                  * Error #17 USED
    dc.b    "The requested position is out of memblock size/range.",0                              * Error #18 USED
    dc.b    "The memblock position entered is not word aligned.",0                                 * Error #21 USED


* IMPORTANT! Always EVEN!
    even



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     +++ If no error routines, you must anyway have 2 empty routines!        
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Empty
; - - - - - - - - - - - - -
; - - - - - - - - - - - - -
    Lib_Empty
; - - - - - - - - - - - - -

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     +++ Finish the library
;    Another macro for Library_Digest
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_End
; - - - - - - - - - - - - -


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     +++ TITLE OF THE EXTENSION!
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C_Title    dc.b    "AMOSPro Personal Unity SupportLib version V "
    VersionPUL
    dc.b    0,"$VER: "
    VersionPUL
    dc.b    0
    Even


; +++ END OF THE EXTENSION
C_End    dc.w    0
    even



;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :        ***** AgaSupport.lib methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************



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
