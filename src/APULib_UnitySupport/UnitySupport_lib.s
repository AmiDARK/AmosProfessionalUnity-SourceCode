
;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; Additional commands for ECS/OCS/AGA & SAGA support²
; By Frédéric Cordier
; AMOS, AMOSPro, AMOS Compiler (c) Europress Software 1990-1992
; To be used with AMOSPro V2.0 and over
;--------------------------------------------------------------------- 
;
;---------------------------------------------------------------------
ExtNb    equ    7-1         ; Extension number #7

;---------------------------------------------------------------------
;    +++
;    Include the files automatically calculated by
;    Library_Digest.AMOS
;---------------------------------------------------------------------
    Include    "UnitySupport_lib_Size.s"
    Include    "UnitySupport_lib_Labels.s"

; +++ You must include this file, it will decalre everything for you.
    include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
    Include    "src/AmosProUnity_Version.s"

; *** 2020.09.17 This one for ILBM/IFF CMAP files created by F.C
    Include    "iffIlbm_Equ.s"
    Include    "UnitySupport_Equ.s" ; 2020.10.02 Added for Rainbow structure datas

; *** 2021.12.21 Includes SAGA chipset 
;    Include    "includesSAGA/sagaRegisters.h"

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

VersionUS  MACRO
           dc.b "0.3 Alpha",0
           ENDM

Bnk_BitPalette    Equ    5            ; = Bnk.BitReserved1
Bnk_BitCopperFX   Equ    7            ; = Bnk_BitReserved3
sprFX_BankID      Equ    0
SimpleRainbowFX   Equ    0            ; The Bit ID of the Simple Rainbow FX effect to be used.

; A usefull macro to find the address of data in the extension''s own 
; datazone (see later)...
Dlea     MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-UnityDatas,\2
    ENDM

; DmoveaL    #VALUE,DataName,TempRegister
DmoveaL  MACRO
    move.l    ExtAdr+ExtNb*16(a5),\3
    add.w    #\2-UnityDatas,\3
    move.l   \1,\3
    ENDM

DmoveL   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\3
    add.w    #\2-UnityDatas,\3
    move.l   \1,\3
    ENDM

DmoveW   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\3
    add.w    #\2-UnityDatas,\2
    move.w   \1,\3
    ENDM

DmoveB   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\2-UnityDatas,\2
    move.b   \1,\3
    ENDM

; Another macro to load the base address of the datazone...
Dload    MACRO
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

;---------------------------------------------------------------------
;    +++ TABLE OF POINTERS TO THE LIBRARY
;
;    The following macros automatically create the necessary pointers
; to the library. It uses the informations created by "Library_Digest"
; You are free to add/remove a function in the middle of the extension
; without having to care about the numbers of the function.
;---------------------------------------------------------------------
    MCInit
C_Off
    REPT    Lib_Size
    MC
    ENDR

;---------------------------------------------------------------------
;     +++ TOKEN TABLE
;
;    
; This table is the crucial point of the extension! It tells
; everything the tokenisation process needs to know. You have to 
; be carefull when writing it!
;
; The format is simple:
;    dc.w    Number of instruction,Number of function
;    dc.b    "instruction nam","e"+$80,"Param list",-1[or -2]
;
;    (1) Number of instruction / function
;    You must state the one that is needed for this token.
;           I suggest you keep the same method of referencing the
;    routines than mine: L_name, this label being defined
;    in the main program.
;    A -1 means take no routine is called (example a 
;    instruction only will have a -1 in the function space...)
;
;    (2) Instruction name
;    It must be finished by the letter plus $80.
;    - You can SET A MARK in the token table with a "!" before
;    the name. See later
;    -Using a $80 ALONE as a name definition, will force AMOS
;    to point to the previous "!" mark...
;    
;    (3) Param list
;    This list tells AMOS everything about the instruction.
;
;    - First character:
;    The first character defines the TYPE on instruction:
;        I--> instruction
;        0--> function that returns a integer
;        1--> function that returns a float
;        2--> function that returns a string
;        V--> reserved variable. In that case, you must
;        state the type int-float-string
;    - If your instruction does not need parameters, then you stop
;    - Your instruction needs parameters, now comes the param list
;        Type,TypetType,Type...
;    Type of the parameter:
;        0--> integer
;        1--> float or double
;        2--> string
;        3--> integer OR string. The only way to check the type
;         is to check the adress (UGLY, but safe for integer
;         up to 512 which cannot ever be a string''s address)
;        4--> Integer OR float/double. You must then write TWO
;         routines. The first one being called when the param
;         is an integer, and being the one pointed to by the
;                token table. The second one being called when the
;                parameter is a float/double.
;         This system is used for functions like SGN.
;        5--> Angle. This parameter will always be a float/double,
;         in radians, even if DEGREE has been set.
;    Comma or "t" for TO
;
;    (4) End of instruction
;        "-1" states the end of the instruction
;        "-2" tells AMOS that another parameter list
;         can be accepted. if so, MUST follow the
;         complete instruction definition as explained
;         but with another param list.
;    If so, you can use the "!" and $80 facility not to rewrite the
;    full name of the instruction...See SAM LOOP ON instruction for an
;    example...
;
;
;    +++ You _MUST_ leave this keyword in the source, in upper case:
;    Library_Digest uses it to detect the start of the library.
;
;    TOKEN_START

;     +++ The next two lines needs to be unchanged...
C_Tk:
    dc.w     1,0
    dc.b     $80,-1

; Now the real tokens...
; **************** Color palette support
    dc.w    L_Nul,L_isAgaDetected
    dc.b    "is aga availabl","e"+$80,"0",-1
    dc.w    L_Nul,L_isScreenInHam8Mode
    dc.b    "is ham","8"+$80,"0",-1
    dc.w    L_Nul,L_getHam8Value
    dc.b    "ham","8"+$80,"0",-1

    dc.w    L_Nul,L_retRgb24Color
    dc.b    "rgb2","4"+$80,"00,0,0",-1
    dc.w    L_Nul,L_retRgbR8FromRgbColor
    dc.b    "rgbr","8"+$80,"00",-1
    dc.w    L_Nul,L_retRgbG8FromRgbColor
    dc.b    "rgbg","8"+$80,"00",-1
    dc.w    L_Nul,L_retRgbB8FromRgbColor
    dc.b    "rgbb","8"+$80,"00",-1
    
    dc.w    L_Nul,L_retRgb12Color
    dc.b    "rgb1","2"+$80,"00,0,0",-1
    dc.w    L_Nul,L_retRgbR4FromRgbColor
    dc.b    "rgbr","4"+$80,"00",-1
    dc.w    L_Nul,L_retRgbG4FromRgbColor
    dc.b    "rgbg","4"+$80,"00",-1
    dc.w    L_Nul,L_retRgbB4FromRgbColor
    dc.b    "rgbb","4"+$80,"00",-1

    dc.w    L_CreatePalette1,L_Nul
    dc.b    "!create palett","e"+$80,"I0",-2
    dc.w    L_CreatePalette2,L_Nul
    dc.b    $80,"I0,0",-2
    dc.w    L_Nul,L_GetPaletteColorsAmount
    dc.b    "get palette colors amoun","t"+$80,"00",-1
    dc.w    L_LoadIFFPalette,L_Nul
    dc.b    "load cmap to palett","e"+$80,"I2,0",-1
    dc.w    L_Nul,L_GetPaletteColourID
    dc.b    "get palette colo","r"+$80,"00,0",-1
    dc.w    L_SetPaletteColourID,L_Nul
    dc.b    "set palette colo","r"+$80,"I0,0,0",-1

    dc.w    L_fadeUnitystep,L_Nul
    dc.b    "unity step fad","e"+$80,"I0",-1
    dc.w    L_fadeUnity,L_Nul
    dc.b    "unity fad","e"+$80,"I0",-1
    dc.w    L_fadeUnitytoPalette2,L_Nul
    dc.b    "!unity fade to palett", "e"+$80,"I0,0",-2
    dc.w    L_fadeUnitytoPalette,L_Nul
    dc.b    $80,"I0,0,0",-2

    dc.w    L_Nul,L_true64Colors
    dc.b    "true6","4"+$80,"0",-1

    dc.w    L_GrabPaletteFromScreen,L_Nul
    dc.b    "grab screen palett","e"+$80,"I0",-1

    dc.w    L_SetAGASpritesWidth,L_Nul
    dc.b    "set sprite widt","h"+$80,"I0",-1
    dc.w    L_Nul,L_GetAgaSpritesMaxHeight
    dc.b    "get sprite buffe","r"+$80,"0",-1
    dc.w    L_SetSpritePalette,L_Nul
    dc.b    "set sprite palett","e"+$80,"I0",-1
    dc.w    L_Nul,L_GetSpritePalette
    dc.b    "get sprite palett","e"+$80,"0",-1

    dc.w    L_SetSpritesToLowres,L_Nul
    dc.b    "set sprites to lowre","s"+$80,"I",-1
    dc.w    L_SetSpritesToHires,L_Nul
    dc.b    "set sprites to hire","s"+$80,"I",-1
    dc.w    L_SetSpritesToSHres,L_Nul
    dc.b    "set sprites to shre","s"+$80,"I",-1
    dc.w    L_SetSpriteToECS,L_Nul
    dc.b    "set sprites to ecs compatibilit","y"+$80,"I",-1
    dc.w    L_Nul,L_GetSpritesResolution
    dc.b    "get sprites resolutio","n"+$80,"0",-1

    dc.w    L_CreateRainboxFX,L_Nul
    dc.b    "create rainbow fx ban","k"+$80,"I0",-1             ; BankID
    dc.w    L_SetRainbowFXColorID,L_Nul
    dc.b    "set rainbow fx colo","r"+$80,"I0,0",-1             ; BankID,ColorIndex(000-255)
    dc.w    L_SetRainbowFXColorValue,L_Nul
    dc.b    "set rainbow fx color lin","e"+$80,"I0,0,0",-1      ; BankID,YLine,RGBValue(12/15/24)
    dc.w    L_ApplyRainbowFXToScreen,L_Nul
    dc.b    "apply rainbow fx to scree","n"+$80,"I0",-1         ; BankID (-> Current Screen)
    dc.w    L_RemoveRainbowFXFromScreen,L_Nul
    dc.b    "remove rainbow fx from scree","n"+$80,"I",-1
    dc.w    L_Nul,L_getRainbowFXColorValue
    dc.b    "get rainbow fx color lin","e"+$80,"00,0",-1        ; Rgb24ColorValue/-1= ( BankID,YLine)

    dc.w    L_Nul,L_GetSagaC2PScreenMode
    dc.b    "!get saga c2p screen mod","e"+$80,"00,0,0",-1         ; GFXMODE = get saga c2p screen mode( Width, Height, Depth )
    dc.w    L_Nul,L_GetSagaC2PScreenModeEx
    dc.b    $80,"00,0,0,0",-1                                      ; GFXMODE = get saga c2p screen mode( Width, Height, Depth, ScanMode )
    dc.w    L_CustomScreenOpen,L_Nul
    dc.b    "cs open scree","n"+$80,"I0,0,0,0",-1              ; Open Saga c2p Screen ScreenID, Width, Height, GFXMODE
    dc.w    L_CustomScreenClose,L_Nul
    dc.b    "cs close scree","n"+$80,"I0",-1                   ; Close Saga c2p Screen ScreenID
    dc.w    L_Nul,L_GetCustomScreenBase
    dc.b    "cs screen bas","e"+$80,"00",-1

;    +++ You must also leave this keyword untouched, just before the zeros.
;    TOKEN_END

; To Add : 
;    Create Memblock From File

;    +++ The token table must end by this
    dc.w     0
    dc.l    0

;
; Now come the big part, the library. 
;
; The beginning of each routine is defined with macros. NB: in the following text
; a space in inserted in the macro name, so that it is not detected by 
; "Library_Digest".
;
;    Lib_ Def    Function_Name_No_Parameter
; or
;    Lib_ Par Function_Name_With_Parameter
;
; Those two macro have the same function:
;    - Create an entry in the library offset table, so that AMOSPro locates
;    the function,
;    - Are detected by Library_Digest: it then creates a label in the "_Label.s"
;    file (see above) of the following form, by appending a "L_" to the name:
;    "L_Function_Name_..." This label must be used in the extension to reference
;    the routine.
;
; Differences between Lib_ Def and Lib_ Par
;    - Lib_ Def must be used for internal routines (ie, not instructions or
;    functions)
;    - Lib_ Par must be used for instructions or functions: it reserved a space
;    before the routine if used by the interpreter, to call the parameter
;    calculation routines. Well this is internal, you don''t have to care 
;    about it, just use "Lib_ Par" for routines referenced in the token 
;    table...
;
; BSR and JSR
;    - You cannot directly call other library routines from one routine
;    by doing a BSR, but I have defined special macros (in +CEQU.S file) 
;    to allow you to easily do so. Here is the list of available macros:
;
;    Rbsr    L_Routine    does a simple BSR to the routine
;    Rbra    L_Routine    as a normal BRA
;    Rbeq    L_Routine    as a normal Beq
;    Rbne    L_Routine    ...
;    Rbcc    L_Routine
;    Rbcs    L_Routine
;    Rblt    L_Routine
;    Rbge    L_Routine
;    Rbls    L_Routine
;    Rbhi    L_Routine
;    Rble    L_Routine
;    Rbpl    L_Routine
;    Rbmi    L_Routine
;
; I remind you that you can only use this to call an library routine
; from ANOTHER routine. You cannot do a call WITHIN a routine, or call
; the number of the routine your calling from...
; The compiler (and AMOSPro extension loading part) will manage to find
; the good addresses in your program from the offset table.
;
; You can also call some main AMOSPro.Lib routines, to do so, use the 
; following macros:
;    Rjsr    L_Routine    
;    Rjmp    L_Routine    
; 
; Here is the list of the most usefull routines from the AMOSPro.Lib
;
;    Rjsr    L_Error
; ~~~~~~~~~~~~~~~~~~~~~
;    Jump to normal error routine. See end of listing
;
;    Rjsr    L_ErrorExt
; ~~~~~~~~~~~~~~~~~~~~~~~~
;    Jump to specific error routine. See end of listing.
;
;     Rjsr    L_Test_PaSaut
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Perform one AMOSPro updating procedure, update screens, sprites,
;    bobs etc. You should use it for wait loops. Does not jump to 
;    automatic calls.
;
;    Rjsr    L_Test_Normal
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Same as before, but with automatic function jump.
;
;    Rjsr    L_WaitRout
; ~~~~~~~~~~~~~~~~~~~~~~~~
;    Wait for D3 VBL with tests.
;    See play instruction.
;
;    Rjsr    L_GetEc
; ~~~~~~~~~~~~~~~~~~~~~
;    Get screen address: In: D1.l= number, Out: A0=address
;
;    Rjsr    L_Demande
; ~~~~~~~~~~~~~~~~~~~~~~~
;    Ask for string space.
;    D3.l is the length to ask for. Return A0/A1 point to free space.
;    Poke your string there, add the length of it to A0, EVEN the 
;    address to the highest multiple of two, and move it into
;    HICHAINE(a5) location...
;
;    Rjsr    L_RamChip
; ~~~~~~~~~~~~~~~~~~~~~
;    Ask for PUBLIC|CLEAR|CHIP ram, size D0, return address in D0, nothing
;    changed, Z set according to the success.
;
;    Rjsr    L_RamChip2
; ~~~~~~~~~~~~~~~~~~~~~~
;    Same for PUBLIC|CHIP
;
;    Rjsr    L_RamFast
; ~~~~~~~~~~~~~~~~~~~~~
;    Same for PUBLIC|CLEAR
;
;    Rjsr    L_RamFast2
; ~~~~~~~~~~~~~~~~~~~~~~~~
;    Same for PUBLIC
;
;    Rjsr    L_RamFree
; ~~~~~~~~~~~~~~~~~~~~~~~
;    Free memory A1/D0
;
;    Rjsr    L_Bnk.OrAdr
; ~~~~~~~~~~~~~~~~~~~~~~~~~
;    Find whether a number is a address or a    memory bank number
;    IN:     D0.l= number 
;    OUT:     D0/A0= number or start(number)
;
;    Rjsr    L_Bnk.GetAdr
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Find the start of a memory bank.
;    IN:    D0.l=    Bank number
;    OUT:    A0=    Bank address
;    D0.w=    Bank flags
;    Z set if bank not defined.
;
;    Rjsr    L_Bnk.GetBobs
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Returns the address of the bob''s bank
;    IN:
;    OUT:    Z     Set if not defined
;    A0=    address of bank
;
;    Rjsr    L_Bnk.GetIcons
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Returns the address of the icons bank
;    IN:
;    OUT:    Z     Set if not defined
;    A0=    address of bank
;
;    Rjsr    L_Bnk.Reserve
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Reserve a memory bank.
;    IN:    D0.l    Number
;    D1    Flags
;    D2    Length
;    A0    Name of the bank (8 bytes)
;    OUT:    Z     Set inf not successfull
;    A0    Address of bank
;    FLAGS:    
;    Bnk_BitData    Data bank
;    Bnk_BitChip    Chip bank
;    Example:    Bset    #Bnk_BitData|Bnk_BitChip,d1
;    NOTE:     you should call L_Bnk.Change after reserving/erasing a bank.
;
;    Rjsr    L_Bnk.Eff
; ~~~~~~~~~~~~~~~~~~~~~~~
;    Erase one memory bank.
;    IN:    D0.l    Number
;    OUT:    
;
;    Rjsr    L_Bnk.EffA0
; ~~~~~~~~~~~~~~~~~~~~~~~~~
;    Erase a bank from its address.
;    IN:    A0    Start(bank)
;    OUT:    
;
;    Rjsr    L_Bnk.EffTemp
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Erase all temporary banks
;    IN:
;    OUT:
;
;    Rjsr    L_Bnk.EffAll
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Erase all banks
;    IN:
;    OUT:
;
;    Rjsr    L_Bnk.Change
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Inform the extension, the bob handler that something has changed
;    in the banks. You should use this function after every bank
;    reserve / erase.
;    IN:
;    OUT:
;
;     Rjsr    L_Dsk.PathIt
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Add the current AMOS path to a file name.
;    IN:    (Name1(a5)) contains the name, finished by zero
;    OUT:    (Name1(a5)) contains the name with new path
;    Example:
;    move.l    Name1(a5),a0
;    move.l    #"Kiki",(a0)+
;    clr.b    (a0)
;    Rjsr    L_Dsk.PathIt
;    ... now I load in the current directory
;
;    Rjsr     L_Dsk.FileSelector
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    Call the file selector.
;    IN:    12(a3)    Path+filter
;    8(a3)    Default name
;    4(a3)    Title 2
;    0(a3)    Title 1
;    All strings must be in AMOS string format:
;        dc.w    Length
;        dc.b     "String"
;    OUT:    D0.w    Length of the result. 0 if no selection
;    A0    Address of first character of the result.
;
;
; How does it work?
; Having a look at the +CEQU file, you see that I use special codes
; to show the compiler that it has to copy the asked routine and relocate
; the branch. Some remarks:
;    - The size of a Rbsr is 4 bytes, like the normal branch, it does
; not change the program (you can make some jumps over it)
;    - Although I have coded the signal, and put a lot a security, 
; a mischance may lead to the compiler thinking there is a Rbsr where
; there is nothing than normal data. The result may be disastrous! So if
; you have BIG parts of datas in which you do not make any special calls,
; you can put before it the macro: RDATA. It tells the compiler that 
; the following code, up to the end of the library routine (up to the next
; L(N) label) is normal data: the compiler will not check for Rbranches...
; Up to now, I have not been forced to do so, but if something goes wrong,
; try that!
;

; +++ Remember!
;    - Your code must be (pc), TOTALLY relocatable, check carefully your
;      code!
;    - Never perform a BSR or a JSR from one function to another: it 
;    _will_ crash once compiled. Use the special macros instead.
;    - Each individual routine of the library can be up to 32K

;---------------------------------------------------------------------
; +++ This macro initialise the library counter, and is also detected by
;     Library_Digest
;
    Lib_Ini    0

; +++ Start of the library (for the header)
C_Lib

******************************************************************
*    COLD START
*

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : AgaSupport_Cold                             *
; *-----------------------------------------------------------*
; * Description : The first routine of the library will per-  *
; * -form all initialisations in the booting of AMOS. I have  *
; * put here all the music datazone, and all the interrupt    *
; * routines. I suggest you put all you C-Code here too if    *
; * you have some...                                          *
; * ALL the following code, from L0 to L1 will be copied into *
; * the compiled program (if any music is used in the program)*
; * at once. All RBSR, RBRA etc will be detected and reloca-  *
; * -ted. AMOSPro extension loader does the same. The length  *
; * of this routine (and of any routine) must not exceed 32K  *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def    UnitySupport_Cold
    cmp.l    #"APex",d1    Version 1.10 or over?
    bne.s    BadVer
    movem.l    a3-a6,-(sp)

;
; Here I store the address of the extension data zone in the special area
; Here I store the address of the extension data zone in the special area
    lea        UnityDatas(pc),a3
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

    movem.l    a0,-(sp)

; ******** push RGB12/15/24 colors format support methods - START
    lea        colorSupport_Functions(pc),a0
    move.l     a0,T_ColorSupport(a5)
; ******** push RGB12/15/24 colors format support methods - END

; ******** push Specific Unity Support FX Methods - START
    lea        UnityVectors(pc),a0
    move.l     a0,T_UnityVct(a5)
; ******** push Specific Unity Support FX Methods - END

    movem.l    (sp)+,a0
; ******** 2021.03.30 Default AGA Sprites datas setup for native 16 pixels width sprites - START
    moveq.l    #0,d3
    move.l     #0,T_AgaSprWidth(a5)     ; 16 pixels wide sprites
    move.w     #$40,T_AgaSprResol(a5)   ; Low Res AGA Resolutions
    move.w     #1,T_AgaSprWordsWidth(a5) ;
    move.w     #2,T_AgaSprBytesWidth(a5)
    move.l     #$00080000,T_SprAttach(a5)
; ******** 2021.03.30 Default AGA Sprites datas setup for native 16 pixels width sprites - END

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
    ; ******************************** Delete the Iff/Ilbm CMAP file is not deleted from memory.
    Dlea       AgaCMAPColorFile,a1
    move.l     (a1),d0
    tst.l      d0
    beq.s      .whatsNext
    move.l     d0,a1
    move.l     #aga_iffPalSize,d0
    SyCall     MemFree
    Dlea       AgaCMAPColorFile,a1
    clr.l      (a1)
.whatsNext:

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
UnityDatas:
AgaCMAPColorFile:
    dc.l    0               ; Used to store the pointer to the temporary IFF/CMAP loaded file.
AgaCurrentColorPalette:
    dc.l    0               ; Saved by Create Palette to be used directly by methods that may call it

;
; *****************************************************************************************************************************
; *************************************************************
; * Area Name : Screen Replacement Plugin                     *
; *-----------------------------------------------------------*
; * Description : This area contains the list of methods that *
; * can are called directly by AMOS.library to use AGA chipset*
; * instead of default ECS/OCS graphics                       *
; *                                                           *
; *************************************************************
;
colorSupport_Functions:
    ; **************** Amos Professional Unity System : New Color format convertion system****************
    Rbra       L_SeparateRGBComponents
    Rbra       L_MergeRGBComponents
    Rbra       L_ForceToRGB24
    dc.l       0
    ; **************** Amos Professional Unity System : New Color palette support, fading, etc. ****************
UnityVectors:
    dc.l       0

    ; **************** Amos Professional Unity System : Other FX ****************
RainbowFXCall:
    Rbra       L_insertSimpleRainbowFX


; ***** 2021.12.20 Here is the list of the available depths mode in Vampire V4SA - START
SAGA_C2P_DEPTHS:
;             User value -> GFXMODE/PixelFormat value
    dc.w      8,SAGA_VIDEO_FORMAT_CLUT8
    dc.w      16,SAGA_VIDEO_FORMAT_RGB16
    dc.w      15,SAGA_VIDEO_FORMAT_RGB15
    dc.w      24,SAGA_VIDEO_FORMAT_RGB24
    dc.w      32,SAGA_VIDEO_FORMAT_RGB32
    dc.w      422,SAGA_VIDEO_FORMAT_YUV422
    dc.w      1,SAGA_VIDEO_FORMAT_PLANAR1BIT
    dc.w      2,SAGA_VIDEO_FORMAT_PLANAR2BIT
    dc.w      4,SAGA_VIDEO_FORMAT_PLANAR4BIT
    dc.w      0,0
; ***** 2021.12.20 Here is the list of the available depths mode in Vampire V4SA - END

; **** 2021.12.21 Updated Saga GFXMODE register screen resolutions
SAGA_C2P_GFXMODES:
    dc.w       320,200,$01
    dc.w       320,240,$02
    dc.w       320,256,$03
    dc.w       640,400,$04
    dc.w       640,480,$05
    dc.w       640,512,$06
    dc.w       960,240,$07
    dc.w       480,270,$08
    dc.w       304,224,$09
    dc.w      1280,720,$0A
    dc.w       640,360,$0B
    dc.w       800,600,$0C
    dc.w      1024,768,$0D
    dc.w       720,576,$0E
    dc.w       848,480,$0F
    dc.w       640,200,$10
    dc.w         0,000,$00      ; Last slot is empty to ensure loop quit possible.

; **** 2022.01.03 Added pixel size for custom screen buffer creation
SAGA_PIXEL_SIZE:
    dc.w       0,1,2,2,3,4,2,0  ; CLUT_OFF(0),CLUT8(1),RGB16(2),RGB15(3),RGB24(4),RGB32(5),YUV422(6),NOT_DEFINED(7)
    dc.w       1,1,1            ; PLANAR1BIT(8),PLANAR2BIT(9),PLANAR4BIT(10=$A) (unknown mode format)

; **** 2021.12.22 
CUSTOM_SCREEN:
    dc.l       0,0,0,0,0,0,0,0   ; Space to contains up to 8 screen structures pointers.

TEMP_BUFFER:
    dc.l       0,0,0,0,0,0,0,0   ; Save temporar datas

        RsReset
CusEcLogic:    rs.l 1            ;  0 1x .L = to contain pointer to the screen Logic plane
CusEcPhysic    rs.l 1            ;  4 1x .L = to contain pointer to the screen Physic plane
CusEcBuffer3   rs.l 1            ;  8 1x .L = to contain pointer to the screen (non physic nor logic) when using triple buffering.
CusEcCurrent   rs.l 1            ; 12 1x .L = to contain pointer to the screen displayed plane (should be =CurEcPhysic)
CusEcPixWidth  rs.l 1            ; 16 1x .L = Screen width in pixels
CusEcPixHeight rs.l 1            ; 20 1x .L = Screen height in pixels
CusEcPixDepth  rs.l 1            ; 24 1x .L = Pixel depth in bytes
CusEcDepth     rs.w 1            ; 28 1x .W = contain the screen depth ( 8/15/16/24/32 bits color depth, or YUV).
CusEcOffsetX   rs.w 1            ; 30 1x .W = Screen offset on width (X)
CusEcOffsetY   rs.w 1            ; 32 1x .W = Screen offset on height (Y)
CusEcViewWidth rs.w 1            ; 34 1x .L = Screen width in pixels
CusEcViewHeight rs.w 1           ; 36 1x .L = Screen height in pixels
CusEcMod       rs.w 1            ; 38 1x .W = Screen module ( CusEcViewWidth-CusEcPixWidth)
CusEcGFXMODE   rs.l 1            ; 40 1x .L = The GFXMODE used to open the screen 
CusEcInkA      rs.l 1            ; 44 1x .L = Current screen ink color (max 32 bits)
CusEcInkB      rs.l 1            ; 48 1x .L = Current screen 2nd ink color (max 32 bits)
CusEcPaper     rs.l 1            ; 52 1x .L
CusEcText      rs.w 1            ; 56 1x .W = Current text size
CurExFont      rs.w 1            ; 58 1x .W = Current text font.  
CusBufferLen   rs.l 1            ; 60 Taille du buffer mémoire réservé pour l'écran
CurPalette     rs.l 256          ; 64 256x .L = 32 bits 256 Color palette when under 8 bits mode
CusEcLong      equ __RS          ; Length of a screen


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
; IMPORTANT POINT: you MUST unpile the EXACT number of parameters,
; to restore A3 to its original level. If you do not, you will not
; have a immediate error, and AMOS will certainely crash on next
; UNTIL / WEND / ENDIF / NEXT etc... 
;
; +++ So, your instruction must:
;    - Unpile the EXACT number of parameters from A3 (if needed), and exit
;    with A3 at the original level it was before collecting your parameters)
;    - Preserve A4, A5, A6, D6 and D7. Warning D6/D7 was not preserved
;    before V2.x of AMOSPro. Re-read your code, or use the "L_SaveRegs" and
;    "L_LoadRegs" routines.
;
;     You can use D0-D5/A0-A2 freely...
;
; You can jump to the error routine without thinking about A3 if an error
; occurs in your routine (via a Rbra of course). BUT A4, A5, A6, D6 and D7
; registers MUST be preserved before calling the error routines.
;
; You end must end by a RTS.
;
; +++ Functions, how to return the parameter?
; To send a function`s parameter back to AMOS, you load it in D3 (and D4 for
; double), and put its type in D2:
;    moveq    #0,d2    for an integer
;    moveq    #1,d2    for a float
;    moveq    #2,d2    for a string
;
; +++ Special parameter-return macros
; You can optimise a little your code for the compilation of functions. The
; TYPE of the parameter returned by a function is not needed within the
; compiled program, as the compiler have already created the good code
; to handle the parameter. It is though necessary to have it for the
; interpreter.
; So I have created three macros: Ret_Int, Ret_String and Ret_Float.
; These macros should be used at the end of your function.
; Example, the Ret_Int macro:
;
;    moveq    #1,d3
;    Ret_Int
;
; becomes under the interpreter:
;    moveq    #1,d3
;    moveq    #0,d2
;    rts
; and under the compiler, _ONLY_ is Ret_Int is the LAST instruction of the
; routine:
;    moveq    #1,d3
;    rts
; ... the linker removes the type from D2, as it is not needed...
;

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
;                                                                                           * AREA NAME : *** Color format conversion methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_SeparateRGBComponents                     *
; *-----------------------------------------------------------*
; * Description : This method can receive RGB12, RGB15 or     *
; *               RGB24 value and separate components to      *
; *               Deviver 2x RGB12 color components           *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB12,   *
; *               RGB15 or RGB24 color format                 *
; *                                                           *
; * Return Value : T_rgb12Low(a5) = RGB12 low bits color      *
; *                T_rgb12High(a5) = RGB12 high bits color    *
; *                                                           *
; *************************************************************
  Lib_Def      SeparateRGBComponents
; ************************************ Separate RGB12, RGB15 and RGB24 color data into 2 RGB12 outputs.
    movem.l    d0-d1/a0,-(sp)
    move.b     T_rgbInput(a5),d0
    and.l      #%11,d0                 ; d1 = in Interval {0-3} (Ignore high bits as there are only 3 formats supported)
    lsl.l      #2,d0                   ; D0 * 4 (for pointer list)
    lea        inputFormats(pc),a0
    adda.l     d0,a0                   ; a0 = Pointer to the method to callable
    jsr        (a0)                    ; Call the input method
    movem.l    (sp)+,d0-d1/a0
    rts
; ************************************ RGB Input format supported
inputFormats:
    Rbra       L_InputIsRGB12          ; 12 Bits (R4,G4,B4)
    Rbra       L_InputIsRGB24          ; 24 bits (R8,G8,B8)
    Rbra       L_InputIsR5G5B5         ; 15 bits (R5,G5,B5)
    Rbra       L_Err10                 ; Unknown input format

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_InputIsRGB12                              *
; *-----------------------------------------------------------*
; * Description : Internal method to handle RGB12 color format*
; *               as input for RGB12H/RGB12L components sepa- *
; *               -ration. In this case input is simply copied*
; *               directly in the two output buffers          *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB12    *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgb12High(a5) = High bits for RGB12 color*
; *                value output                               *
; *                T_rgb12Low(a5) = Low bits for RGB12 color  *
; *                value output                               *
; *                                                           *
; *************************************************************
; ************************************ Read R4G4B4 and push it into 2 R4G4B4 registers for High/Low bits
  Lib_Def       InputIsRGB12
    move.l      T_rgbInput(a5),d0       ; Load the RGB input data
    move.w      d0,T_rgb12High(a5)      ; On RGB12 input, Low and High bits are the same
    move.w      d0,T_rgb12Low(a5)       ; On RGB12 input, Low and High bits are the same
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_InputIsR5G5B5                             *
; *-----------------------------------------------------------*
; * Description : Internal method to handle R5G5B5 color for- *
; *               -mat as input for RGB12H/RGB12L components  *
; *               separation                                  *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using R5G5B5   *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = Color Value using RGB24  *
; *                color format                               *
; *                T_rgbInput(a5) = Color Value using RGB24   *
; *                color format                               *
; *                                                           *
; *************************************************************
  Lib_Def      InputIsR5G5B5
; ************************************ Read R5G5B5 and push it into 2 R4G4B4 registers for High/Low bits
    Rbsr       L_convertRGB15toRGB24
    ; ******** Update the input with the new R8G8B8 version of the color to use RGB24 components separation methods
    move.l      T_rgbOutput(a5),T_rgbInput(a5) ; Update input with new version in R8G8B8.
    ; ******** Continue with RGB24 -> RGB12H + RGB12L conversion
    Rbra       L_InputIsRGB24

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_InputIsRGB24                              *
; *-----------------------------------------------------------*
; * Description : Internal method to handle RGB24 color format*
; *               as input for RGB12H/RGB12L components sepa- *
; *               -ration                                     *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB24    *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgb12High(a5) = High bits for RGB12 color*
; *                value output                               *
; *                T_rgb12Low(a5) = Low bits for RGB12 color  *
; *                value output                               *
; *                                                           *
; *************************************************************
  Lib_Def      InputIsRGB24
; ******** Calculate high bits of the RGB24 color palette
    move.l     T_rgbInput(a5),d1
    and.l      #$00F0F0F0,d1           ; d2 = ..R.G.B.
    moveq      #0,d0                   ; d0 = ........
    lsr.l      #4,d1                   ; d2 = ...R.G.B
    move.b     d1,d0                   ; d0 = .......B
    lsr.l      #4,d1                   ; d2 = ....R.G.
    or.b       d1,d0                   ; d0 = ......GB
    lsr.l      #4,d1                   ; d2 = .....R.G
    and.l      #$F00,d1                ; d2 = .....R..
    or.w       d0,d1                   ; d2 = .....RGB
    move.w     d1,T_rgb12High(a5)      ; Save RGB12 high bits
; ******** Calculate low bits of the RGB24 color palette
    move.l     T_rgbInput(a5),d1
    moveq      #0,d0                   ; d0 = ........
    and.l      #$000F0F0F,d1           ; d1 = ...R.G.B
    move.b     d1,d0                   ; d0 = .......B
    lsr.l      #4,d1                   ; d1 = ....R.G.
    or.b       d1,d0                   ; d0 = ......GB
    lsr.l      #4,d1                   ; d1 = .....R.G
    and.l      #$F00,d1                ; d1 = .....R..
    or.w       d0,d1                   ; d1 = .....RGB
    move.w     d1,T_rgb12Low(a5)       ; Save RGB12 high bits
    rts
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_MergeRGBComponents                        *
; *-----------------------------------------------------------*
; * Description : This method merge RGB12H/RGB12L color value *
; *               data to create a color value output using   *
; *               one of the following supported color format:*
; *               RGB12, RGB15 or RGB24                       *
; *                                                           *
; * Parameters :  T_rgb12High(a5) = High bits for source RGB24*
; *               color value to output                       *
; *               T_rgb12Low(a5) = Low bits for source RGB24  *
; *               color value to output                       *
; *               T_rgbOutput(a5).b (bits 24-31) to specify   *
; *               which output format will be used            *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = Color value using the    *
; *                requested color output format              *
; *                                                           *
; *************************************************************
  Lib_Def      MergeRGBComponents
; ************************************ Merge rgb12High and rgb12Low to create a new output format
    movem.l    d0-d1/a0,-(sp)
    move.b     T_rgbOutput(a5),d0
    and.l      #%11,d0
    lsl.l      #2,d0                   ; D0 * 4 (for pointer list)
    lea        outputFormats(pc),a0
    adda.l     d0,a0                   ; a0 = Pointer to the method to callable
    jsr        (a0)                    ; Call the input method
    movem.l    (sp)+,d0-d1/a0
    rts
; ************************************ RGB Input format supported
outputFormats:
    Rbra       L_OutputIsRGB12         ; 12 Bits (R4,G4,B4)
    Rbra       L_OutputIsRGB24         ; 24 bits (R8,G8,B8)
    Rbra       L_OutputIsR5G5B5        ; 15 bits (R5,G5,B5)
    Rbra       L_Err10                 ; Unknown input format

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_OutputIsRGB12                             *
; *-----------------------------------------------------------*
; * Description : Internal method to output RGB12 High bits as*
; *               output RGB12 color value                    *
; *                                                           *
; * Parameters : T_rgb12High(a5) = RGB12 Color value          *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = Color value using the    *
; *                RGB12 color output format                  *
; *                                                           *
; *************************************************************
  Lib_Def      OutputIsRGB12
; ************************************ Read RGB12 High & Low bits and output them in RGB15 output format
    move.l     T_rgb12High(a5),T_rgbOutput(a5)
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_OutputIsR5G5B5                            *
; *-----------------------------------------------------------*
; * Description : Internal method to output RGB15 color value *
; *               from RGB12H/RGB12L color input              *
; *                                                           *
; * Parameters : T_rgb12High(a5) = RGB12 Color value High bits*
; *              T_rgb12Low(a5) = RGB12 Color value Low bits  *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = Color value using the    *
; *                RGB15 (R5G5B5) color output format         *
; *                                                           *
; *************************************************************
  Lib_Def      OutputIsR5G5B5
; ************************************ Read RGB12 High & Low bits and output them in RGB15 (R5G5B5) output format
    Rbsr       L_OutputIsRGB24         ; First we must push RGB12H + RGB12L to RGB24 output format
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

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_OutputIsRGB24                             *
; *-----------------------------------------------------------*
; * Description : Internal method to output RGB24 color value *
; *               from RGB12H/RGB12L color input              *
; *                                                           *
; * Parameters : T_rgb12High(a5) = RGB12 Color value High bits*
; *              T_rgb12Low(a5) = RGB12 Color value Low bits  *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = Color value using the    *
; *                RGB24 (R8G8B8) color output format         *
; *                                                           *
; *************************************************************
  Lib_Def      OutputIsRGB24
; ************************************ Read RGB12 High & Low bits and output them in RGB24 output format
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

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_ForceToRGB24                              *
; *-----------------------------------------------------------*
; * Description : Force any input format (RGB12,RGB15 and     *
; *               RGB24) to be outputted as RGB24             *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using any of   *
; *               the support color format                    *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = RGB24 color value        *
; *                                                           *
; *************************************************************
  Lib_Def      ForceToRGB24
; ************************************ Force any input format (RGB12,RGB15 and RGB24) to be outputted as RGB24
    movem.l    d0-d1/a0,-(sp)
    move.b     T_rgbInput(a5),d0
    and.l      #%11,d0                 ; d1 = in Interval {0-15} (Ignore high bits as there are only 3 formats supported)
    lsl.l      #2,d0                   ; D0 * 4 (for pointer list)
    lea        F24_inputFormats(pc),a0
    adda.l     d0,a0                   ; a0 = Pointer to the method to callable
    jsr        (a0)                    ; Call the input method
    movem.l    (sp)+,d0-d1/a0
    rts
; ************************************ RGB Input format supported
F24_inputFormats:
    Rbra       L_F24_InputIsRGB12          ; 12 Bits (R4,G4,B4)
    Rbra       L_F24_InputIsRGB24          ; 24 bits (R8,G8,B8)
    Rbra       L_F24_InputIsR5G5B5         ; 15 bits (R5,G5,B5)
    Rbra       L_Err10                     ; Unknown input format

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_F24_InputIsRGB12                          *
; *-----------------------------------------------------------*
; * Description : Internal method to output as RGB24 a RGB12  *
; *               color input                                 *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB12    *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = RGB24 color value        *
; *                                                           *
; *************************************************************
  Lib_Def       F24_InputIsRGB12
; ***********************************
    Rbsr        L_InputIsRGB12           ; Push RGB12 to be 2x RGB12 (Low & High Bits) 
    Rbsr        L_OutputIsRGB24          ; Merge RGB12 Low & RGB12 High to create full RGB24
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_F24_InputIsR5G5B5                         *
; *-----------------------------------------------------------*
; * Description : Internal method to output as RGB24 a RGB15  *
; *               color input                                 *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB15    *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = RGB24 color value        *
; *                                                           *
; *************************************************************
  Lib_Def       F24_InputIsR5G5B5
; ***********************************
    Rbsr        L_convertRGB15toRGB24    ; Simply convert RGB15 (R5G5B5) to RGB24
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_F24_InputIsRGB24                          *
; *-----------------------------------------------------------*
; * Description : Internal method to output as RGB24 a RGB24  *
; *               color input (no conversion)                 *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB24    *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = RGB24 color value        *
; *                                                           *
; *************************************************************
  Lib_Def       F24_InputIsRGB24
; ***********************************
    move.l      T_rgbInput(a5),T_rgbOutput(a5) ; Input and Output are under the same format
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_convertRGB15toRGB24                       *
; *-----------------------------------------------------------*
; * Description : Internal method to convert to RGB24 a RGB15 *
; *               color input                                 *
; *                                                           *
; * Parameters :  T_rgbInput(a5) = Color Value using RGB15    *
; *               color format                                *
; *                                                           *
; * Return Value : T_rgbOutput(a5) = RGB24 color value        *
; *                                                           *
; *************************************************************
    Lib_Def     convertRGB15toRGB24
; ************************************ Simply Convert RGB15 (R5G5B5) to RGB24
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

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :       Area for Miscellanous methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************
    ; ****************************************** Return = 1 if AGA Chipset is detected, otherwise = 0
  Lib_Par      isAgaDetected
    Move.w     T_isAga(a5),d3
    and.l      #$FFFF,d3
    Ret_Int

    ; ****************************************** Return =1 if current screen is opened in Ham8 mode, otherwise =0
  Lib_Par      isScreenInHam8Mode
    Moveq      #0,d3
    move.l     ScOnAd(a5),d0
    beq.s      ScNOp1
    move.l     d0,a0    
    move.w     Ham8Mode(a0),d3
ScNOp1:
    Ret_Int

    ; ****************************************** Return Ham8 value for screen open (=262144)
  Lib_Par      getHam8Value
    Move.l     #262144,d3
    Ret_Int

    ; ****************************************** Return Ham6 value for screen open (=4096)
  Lib_Par      getHam6Value
    Move.l     #4096,d3
    Ret_Int

    ; ****************************************** Return True64 value for screen open (true 64 colors non EHB)
  Lib_Par      true64Colors
    Move.l     #-64,d3
    Ret_Int



;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :   Macro Aera for AGA Color palettes *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                         *                                                   *
;                                                                                         * AREA NAME : Color Palettes AgaSupport.lib methods *
;                                                                                         *                                                   *
;                                                                                         *****************************************************
;                                                                                               ***
;                                                                                            ***
;                                                                                         ************************

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :        Basic AgaSupport.lib methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getHam8Value                              *
; *-----------------------------------------------------------*
; * Description : This method will return an integer value of *
; * 262144 and can be used in the Amos Professional method ca-*
; * -lled "Screen Open" to open a HAM8 screen.                *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : 262144 (Integer)                           *
; *************************************************************
    ; ****************************************** Return Ham8 value for screen open (=262144)
  Lib_Par      getHam8Value
    Move.l     #262144,d3
    Ret_Int

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :  Screens color manipulation methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

    ; ****************************************** Return RGB24 color from RED8,GREEN8,BLUE8 components
    ; Parameters :
    ; D3    = Blue 8 bits
    ; (a3)+ = Green 8 Bits
    ; (a3)+ = Red 8 Bits
    ; Return :
    ; (Integer)RGB24
    ;
  Lib_Par      retRgb24Color
; Check Blue8 limits
    cmp.l      #255,d3
    ble.s      .noOverD3a
    move.l     #255,d3
.noOverD3a:
    tst.l      d3
    bpl.s      .noOverD3b
    move.l     #0,d3
.noOverD3b:

    move.l     (a3)+,d2
; Check Green limits
    cmp.l      #255,d2
    ble.s      .noOverD2a
    move.l     #255,d2
.noOverD2a:
    tst.l      d2
    bpl.s      .noOverD2b
    move.l     #0,d2
.noOverD2b:

    move.l     (a3)+,d1
; Check Red limits
    cmp.l      #255,d1
    ble.s      .noOverD1a
    move.l     #255,d1
.noOverD1a:
    tst.l      d1
    bpl.s      .noOverD1b
    move.l     #0,d1
.noOverD1b:
; Add RGB24 Bits flag
    Or.l       #modeRgb24,d3 ; D3 = .F....B8
; Create RGB24 color using .FD1D2D3
    lsl.w      #8,d2         ; D2 = xxxxG8..
    swap       d1            ; D1 = ..R8....
    or.w       d2,d3         ; D3 = .F..G8B8
    Or.l       d1,d3         ; D3 = .FR8G8B8
    Ret_Int

    ; ****************************************** Return 8 bits RED color data from RGB24 color
    ; Parameters :
    ; D3   = RGB24 color
    ; Return :
    ; (Integer)Red8
    ;
  Lib_Par      retRgbR8FromRgbColor
    ForceToRGB24 d3,d3
    and.l      #$FF0000,d3   ; D3 = ..R8....
    swap       d3
    Ret_Int

    ; ****************************************** Return 8 bits GREEN color data from RGB24 color
    ; Parameters :
    ; D3   = RGB24 color
    ; Return :
    ; (Integer)Green8
    ;
  Lib_Par      retRgbG8FromRgbColor
    ForceToRGB24 d3,d3
    and.l      #$FF00,d3   ; D3 = ....G8..
    lsr.l      #8,d3
    Ret_Int

    ; ****************************************** Return 8 bits BLUE color data from RGB24 color
    ; Parameters :
    ; D3   = RGB24 color
    ; Return :
    ; (Integer)Blue8
    ;
  Lib_Par      retRgbB8FromRgbColor
    ForceToRGB24 d3,d3
    and.l      #$FF,d3   ; D3 = ......B8
    Ret_Int

    ; ************************************
  Lib_Par    retRgb12Color
; Check Blue8 limits
    cmp.l      #15,d3
    ble.s      .noOverD3a
    move.l     #15,d3
.noOverD3a:
    tst.l      d3
    bpl.s      .noOverD3b
    move.l     #0,d3
.noOverD3b:

    move.l     (a3)+,d2
; Check Green limits
    cmp.l      #15,d2
    ble.s      .noOverD2a
    move.l     #15,d2
.noOverD2a:
    tst.l      d2
    bpl.s      .noOverD2b
    move.l     #0,d2
.noOverD2b:

    move.l     (a3)+,d1
; Check Red limits
    cmp.l      #15,d1
    ble.s      .noOverD1a
    move.l     #15,d1
.noOverD1a:
    tst.l      d1
    bpl.s      .noOverD1b
    move.l     #0,d1
.noOverD1b:
; Create RGB12 color using ..........D1D2D3

    Lsl.l      #8,d1     ; xx...R..
    Or.w       d1,d3     ; .....R.B
    Lsl.w      #4,d2     ; xxx...G.
    Or.w       d2,d3     ; .....RGB
    Ret_Int

    ; ****************************************** Return RED component from RGB12 color
  Lib_Par  retRgbR4FromRgbColor
    ForceToRGB24 d3,d3
    And.l      #$FF0000,d3   ; D3 = ..R8....
    swap       d3            ; D3 = ......R8
    Lsr.l      #4,d3         ; D3 = .......R
    Ret_Int       

    ; ****************************************** Return GREEN component from RGB12 color
  Lib_Par retRgbG4FromRgbColor
    ForceToRGB24 d3,d3
    And.l      #$FF00,d3     ; D3 = ....G8..
    Lsr.l      #8,d3         ; D3 = ......G8
    Lsr.l      #4,d3         ; D3 = .......G
    Ret_Int       

    ; ****************************************** Return BLUE component from RGB12 color
  Lib_Par retRgbB4FromRgbColor
    ForceToRGB24 d3,d3
    And.l      #$FF,d3       ; D3 = ......B8
    Lsr.l      #4,d3         ; D3 = .......B
    Ret_Int       


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME : Color Palette methods               *
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
  Lib_Par    CreatePalette1
    move.L   d3,d0                     ; D0 = Colors Palette Index
    tst.w    T_isAga(a5)
    beq.s    .ecs
.aga:
    move.l   #256,d0                   ; D3 = Create Colors Palette with 256 colors
    Rbra     L_CreatePalette3
.ecs:
    move.l   #32,d0                    ; D3 = Create Colors Palette with 32 colors
    Rbra     L_CreatePalette3
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
  Lib_Par    CreatePalette2            ; D3 = Colour Amount
    move.l      (a3)+,d0               ; D0 = Color Palette Index
    Rbra        L_CreatePalette3

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
  Lib_Def    CreatePalette3
    cmp.l       #5,d0
    Rble        L_Err1                 ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l       #65535,d0
    Rbhi        L_Err1                 ; Colors Palette ID > 255 -> Error : Invalid range
    and.l       #$1FE,d3               ;
   ; We will count the amount of bits sets in d3. if not equal to 1, -> Error
    moveq       #9,d2                  ; Start at bit #9
    moveq       #0,d1                  ; counter = 0
.loop:
    btst        d2,d3                  ; test bit d0 of d3
    beq.s       .loopct                ; = 0 -> .loopct
    addq        #1,d1                  ; counter = counter + 1 
.loopct:
    dbra        d2,.loop
    cmp.b       #1,d1                  ; if more than 1 bit is set
    Rbne        L_Err2                 ; -> Jump to L_Err2
    btst        #0,d3                  ; if bit #0 is set (mean 1 color or odd color amount)
    Rbne        L_Err2                 ; -> Jump to L_Err2
.isOK:
    moveq       #(1<<Bnk_BitPalette)+(1<<Bnk_BitData),d1   D1 = Flags ; Memblock,DATA, FAST
    move.l      d3,d2                  ; D2 = Colour Amount
    mulu        #3,d2                  ; D2 = Memory size used to define each color ( 3 bytes per color R8+G8+B8 )
    add.l       #def_WithoutPalSize,d2 ; D2 = Memory size used for IFF/ILBM color palette (containing palette), without DPI Block.
    Add.l       #12,d2                 ; D2 = D2 + DPI Block = Full IFF/ILBM Color Palette
    add.l       #4,d2                  ; +4 to save memblock size
    lea         BkPal(pc),a0           ; A0 = Pointer to BkPal (Bank Name)
    movem.l     d3,T_SaveReg(a5)       ; Save Colour Amount
    Rjsr        L_Bnk.Reserve
    Rbeq        L_Err3                 ; Not Enough Memory to allocation memblock.

    Dlea        AgaCurrentColorPalette,a1
    move.l      a0,(a1)                ; Save color palette as current for Load Cmap To Palette method.
    move.l      a0,a1                  ; A1 = Memory Bank pointer (required for L_Bnk_Change)
    move.l      #def_WithoutPalSize,(a0)+  ; Save full color palette
    movem.l     T_SaveReg(a5),d3       ; Restore Colors Amount
    Rbsr        L_PopulateIFFCmapBlock
    Rjsr        L_Bnk.Change           ; Tell Amos Professional Unity Extensions that Memory Banks changed (to update)
    rts
BkPal:
    dc.b       "Palette ",0,0
    Even
  
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
  ; ******************************************* Modify A0 only
  Lib_Def      PopulateIFFCmapBlock
    move.l     #"FORM",def_FORM(a0)              ; Insert "FORM" header
    move.l     d2,d0
    sub.l      #8,d0
    move.l     d0,def_FORM_size(a0)              ; Insert FORM whole content size
    move.l     #"ILBM",def_ILBM(a0)              ; insert "ILBM" header
    move.l     #"BMHD",def_BMHD(a0)              ; Insert "BMHD" header
    move.l     #$0014,def_BMHD_size(a0)          ; Insert BMHD block size
    move.w     #$0000,def_BMHD_W(a0)             ; Image Width = 0
    move.w     #$0000,def_BMHD_W(a0)             ; Image Height = 0
    move.w     #$0000,def_BMHD_X(a0)             ; Image Pixel Pos X
    move.w     #$0000,def_BMHD_Y(a0)             ; Image Pixel Pos Y
    move.b     #$00,def_BMHD_nPlanes(a0)         ; set bitplanes amount (and then colors count) at 0 per default
    move.b     #$00,def_BMHD_masking(a0)         ; Masking = 0
    move.b     #$00,def_BMHD_compression(a0)     ; Compression = 0 = No compression as there are no bitmaps there
    move.b     #$00,def_BMHD_pad1(a0)            ; Pad1 = 0 as unused
    move.w     #$0000,def_BMHD_transparentC(a0)  ; Transparency = Not available / Not Set
    move.b     #$00,def_BMHD_xAspect(a0)         ; xAspect = 0
    move.b     #$00,def_BMHD_yAspect(a0)         ; yAspect = 0
    move.w     #$00,def_BMHD_pageWidth(a0)       ; xAspect = 0
    move.w     #$00,def_BMHD_pageHeight(a0)      ; yAspect = 0
    move.l     #"CMAP",def_CMAP(a0)              ; Insert "CMAP" header
    move.l     d3,d0
    mulu       #3,d0
    move.l     d0,def_CMAP_size(a0)              ; Save the Amount of colors of the colour palette block * 3 (R8G8B8 for each)
    ; The forced update of the IFF/ILBM Color map block stop here.
    ; Because Color size may vary depending on the amount of colors of the screen (bitplanes depth), 
    ; the position of the DPI block may vary and, due to that, the block is inserted at end of palette integration.
.end2:
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
  Lib_Par      GetPaletteColorsAmount
    cmp.l       #5,d3
    Rble        L_Err1                ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l       #255,d3
    Rbhi        L_Err1                ; Colors Palette ID > 255 -> Error : Invalid range
    move.l      d3,d0
    clr.l       d3
    Rjsr        L_Bnk.GetAdr
    Rbeq        L_Err4
    btst        #Bnk_BitPalette,d0    ; No Bnk_BitPalette flag = not a Colors Palette
    Rbeq        L_Err3
    move.l      (a0)+,d3              ; d3 = color palette block size
    move.l      def_CMAP_size(a0),d3  ; D3 = Colour CMAP size.
    divu        #3,d3
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
;
  Lib_Def      CreateIFFCmapBlock
    movem.l    d0-d2/a0-a2,-(sp)
    ; ******** First, we check if the block was already created in memory
    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),d0
    tst.l      d0
    bne.s      .end
    ; ******** Secondly we create the block in memory
    move.l     #$400,d0      ; Reserve a block enough large to handle a full 256 color palette in IFF/ILBM format
    SyCall     MemFastClear
    cmpa.l     #0,a0
    Rbeq       L_Err7                 ; Error 15 : Not enough memory
    ; ******** And then, we check block was created otherwise we cast an error
    Dlea       AgaCMAPColorFile,a1
    move.l     a0,(a1)                 ; Save the new block in Memory
    cmp.l      #0,a0
.end:
    movem.l    (sp)+,d0-d2/a0-a2
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
;
  Lib_Par     LoadIFFPalette           ; D3 = Colors Palette ID
    move.l     (a3)+,a2                ; A2 = FileName
    move.l     d3,T_SaveReg(a5)        ; Save D3 = Colors Palette ID
    ; ******** We check if the Color Palette index is in the correct range
    cmp.l      #5,d3
    Rble       L_Err1                  ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l      #65535,d3
    Rbhi       L_Err1                  ; Colors Palette ID > 255 -> Error : Invalid range
    move.l     d3,d4                   ; D4 = Current Color Palette (Save)
    ; ******** We check if the block to load the file was created or not.
    Rbsr       L_CreateIFFCmapBlock    ; Verify if the memory block for CMAP File is created
    ; ******** Secondly, we check if the filename contain a path. To do that we check for a ":" (a2=filename)
    Rbsr       L_NomDisc2              ; This method will update the filename to be full Path+FileName
    move.l     #1005,d2                ; D2 = READ ONLY dos file mode
    Rbsr       L_OpenFile              ; Dos->Open
    Rbeq       L_DiskFileError         ; -> Error when trying to open the file.
    Rbsr       L_SaveRegsD6D7           ; Save AMOS System registers

    move.l     Handle(a5),d1           ; D1 = File Handle
    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),a0                 ; Load buffer in A0
    Move.l     a0,d2                   ; D2 = A0 (Save)
    move.l     #8,d3                   ; D3 = FORM + Size.l = 8 Bytes to read
    Rbsr       L_IffReadFile2          ; Dos->Read

    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),a0                 ; Load buffer in A0
    move.l     (a0),d3
    cmp.l      #"FORM",d3              ; Does the file start with "BMHD" ?
    bne        B_Err6                  ; Error : The specified file is not an IFF/ILBM Color Map (CMAP) file.
    move.l     4(a0),d3                ; D3 = Remaining bytes to read
    cmp.l      #$400,d3
    bge        B_Err6

    move.l     Handle(a5),d1           ; D1 = File Handle
    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),a0                 ; Load buffer in A0
    Move.l     a0,d2                   ; D2 = A0 (Save)
    Rbsr       L_IffReadFile2          ; Dos->Read

    ; ******** Continue
    move.l     Handle(a5),d1           ; D1 = File Handle
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close


    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),a0                 ; Load buffer in A0
    move.l     (a0)+,d3                ; D3 = get the ILBM Header
    cmp.l      #"ILBM",d3              ; Right ?
    Rbne       L_Err6                  ; No -> Not an Iff/Ilbm file
    move.l     (a0)+,d3                ; D3 = get the BMHD Header
    cmp.l      #"BMHD",d3              ; Right ?
    Rbne       L_Err6                  ; No -> Not an Iff/Ilbm file
    move.l     (a0)+,d3                ; Get BMHD block size
    adda.l     d3,a0                   ; Reach next block

    move.l     (a0)+,d3                ; D3 = Get the CMAP Header
    cmp.l      #"CMAP",d3              ; Right ?
    Rbne       L_Err6                  ; No -> Not an Iff/Ilbm file

    move.l     a0,T_SaveReg2(a5)       ; Save A0 = CMAP Size in Loaded IFF/ILBM color palette
    move.l     T_SaveReg(a5),d0        ; D0 = Color Palette ID
    move.l     (a0),d3                 ; D3 = Color Amount * 3
    Divu       #3,d3                   ; D3 = Color Amount

    Rbsr       L_CreatePalette3        ; Create The Color Palette

    Move.l     T_SaveReg2(a5),a0       ; Load A0 = CMAP Size in loaded IFF/ILBM color palette
    move.l     (a0)+,d0                ; D0 = Cmap Size = Color Amount * 3 (RGB24 datas for each color)
    subq       #1,d0                   ; dbra close copy loop
    Dlea       AgaCurrentColorPalette,a1
    move.l     (a1),a1                 ; A1 = CMAP Color Palette
    add.l      #4,a1                   ; Pass CMAP Color Palette full size.
    add.l      #def_CMAP_Colors,a1     ; A1 = Pointer to the 1st color inside the color palette
.sCopy:
    move.b     (a0)+,(a1)+
    dbra       d0,.sCopy
    rts

B_Err6:
    move.l     Handle(a5),d1           ; D1 = File Handle
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close
    Rbra       L_Err6


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : PaletteID, ColorID                           *
; *                                                           *
; * Return Value : RGB24Value                                 *
; *************************************************************
  Lib_Par   GetPaletteColourID
    move.l      d3,d4                 ; D4 = ColorID
    move.l      (a3)+,d0              ; D0 = Color Palette BankID
    cmp.l       #5,d0
    Rble        L_Err1                ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l       #255,d0
    Rbhi        L_Err1                ; Colors Palette ID > 255 -> Error : Invalid range
    clr.l       d3
    Rjsr        L_Bnk.GetAdr
    Rbeq        L_Err4
    btst        #Bnk_BitPalette,d0    ; No Bnk_BitPalette flag = not a Colors Palette
    Rbeq        L_Err3
    move.l      (a0)+,d3              ; d3 = color palette block size
    move.l      def_CMAP_size(a0),d3  ; D3 = Colour CMAP size.
    divu        #3,d3
    cmp.l       #0,d4
    Rblt        L_Err11               ; Err11 : The requested color index is out of the color palette range.
    cmp.l       d3,d4
    Rbge        L_Err11               ; Err11 : The requested color index is out of the color palette range.
    mulu        #3,d4                 ; Each Color component uses 3 bytes
    Add.l       #def_CMAP_Colors,d4   ; d4 can point to chosen color in color palette bank A0
    clr.l       d3
    add.l       d4,a0
    move.b      (a0)+,d3
    lsl.l       #8,d3
    move.b      (a0)+,d3
    lsl.l       #8,d3
    move.b      (a0)+,d3
    or.l        #modeRgb24,d3         ; Set RGB24 return value mode
    Ret_Int
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : PaletteID, ColorID, RGB24Value               *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par   SetPaletteColourID
    move.l      d3,T_SaveReg(a5)      ; D2 = RGB24Value
    move.l      (a3)+,d4              ; D4 = ColorID
    move.l      (a3)+,d0              ; D0 = Color Palette BankID
    cmp.l       #5,d0
    Rble        L_Err1                ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l       #65535,d0
    Rbhi        L_Err1                ; Colors Palette ID > 255 -> Error : Invalid range
    clr.l       d3
    Rjsr        L_Bnk.GetAdr
    Rbeq        L_Err4
    btst        #Bnk_BitPalette,d0    ; No Bnk_BitPalette flag = not a Colors Palette
    Rbeq        L_Err3
    move.l      (a0)+,d3              ; d3 = color palette block size
    move.l      def_CMAP_size(a0),d3  ; D3 = Colour CMAP size.
    divu        #3,d3
    cmp.l       #0,d4
    Rblt        L_Err11               ; Err11 : The requested color index is out of the color palette range.
    cmp.l       d3,d4
    Rbge        L_Err11               ; Err11 : The requested color index is out of the color palette range.
    mulu        #3,d4                 ; Each Color component uses 3 bytes
    Add.l       #def_CMAP_Colors,d4   ; d4 can point to chosen color in color palette bank A0
    add.l       d4,a0
    move.l      T_SaveReg(a5),d2
    ForceToRGB24 d2,d2                ; Force color value to be RGB24 bits
    move.l      d2,d0
    swap        d0
    move.b      d0,(a0)+              ; Push R8 in (a0)+
    move.l      d2,d0
    lsr.l       #8,d0
    move.b      d0,(a0)+              ; Push G8 in (a0)+
    move.b      d2,(a0)+              ; Push B8 in (a0)+
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : BankID                                       *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par   GrabPaletteFromScreen
    move.l      d3,d0                 ; D0 = Bank ID
    ; ******** Get Current Screen colors and create palette
    move.l      ScOnAd(a5),d1         ; D1 = Get Current Screen Pointer
    Rbeq        L_Err6
    move.l      d1,a0                 ; a0 = Screen Structure Pointer
    move.w      EcNbCol(a0),d3        ; D3 = Screen Amount of colorSupport_Functions
    ext.l       d3
    Rbsr        L_CreatePalette3      ; D3 = Color Amount, Create The Color Palette
    ; ******** Load current color palette, and jump to Color #00 inside to populate
    Dlea        AgaCurrentColorPalette,a1
    move.l      (a1),a1               ; A1 = CMAP Color Palette
    add.l      #4,a1                  ; Pass CMAP Color Palette full size.
    add.l      #def_CMAP_Colors,a1    ; A1 = Pointer to the 1st color inside the color palette
    ; ******** Load current screen color pointer
    move.l     ScOnAd(a5),a0          ; A0 = Get Current Screen Pointer
    move.w     EcNbCol(a0),d0         ; D0 = Amount of color to copy
    ext.l      d0
    lea        EcPal(a0),a0           ; A0 = Pointer to Color #0 on screen
    subq       #1,d0                  ; To makes dbra do the job
.sCopy:
    move.w     EcPalL-EcPal(a0),d2    ; D2 = Color Low Bits
    move.w     (a0)+,d1                ; D1 = Color High Bits
    PushToRGB24 d1,d2,d1              ; D1 = $01R8G8B8 = RGB24 Color, we do not save RGB24 flag $01
    move.l     d1,d2                  ; D2 = $01R8G8B8
    swap       d2                     ; D2 = $G8B801R8
    move.b     d2,(a1)+               ; Save R8
    rol.l      #8,d2                  ; D2 = $B801R8G8
;    swap       d2
;    lsr.l      #8,d2
    move.b     d2,(a1)+               ; Save G8
    move.b     d1,(a1)+               ; Save B8
    dbra       d0,.sCopy
    moveq      #0,d0                  ; Everything is Ok.
    rts


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME : New UNITY Fading methods            *
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
    ; ****************************************** 2020.09.16 New Method : Prepare the AGA fading system - Start
    ; D3 = Speed (Step) used for the fading (can be negative = fade to black, or positive = fade to white)
  Lib_Par      fadeUnitystep           ; d3 = speed used for the screen fading system.
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    clr.w      T_FadeFlag(a5)
    move.w     #1,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.w     d3,T_FadeStep(a5)       ; Set a step different from 1
    move.b     #1,T_isFadeAGA(a5)
    Rbra       L_fadeUnityinside

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
    ; ****************************************** 2020.09.16 New Method : Prepare the AGA fading system - Start
    ; D3 = Speed ( = 1/Speed ) used for the fading (can be negative = fade to black, or positive = fade to white)
  Lib_Par      fadeUnity               ; d3 = speed used for the screen fading system.
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    clr.w      T_FadeFlag(a5)
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.b     #1,T_isFadeAGA(a5)
    move.b     #16,T_FadeStep(a5)
    tst.l      d3
    bpl.s      .PositiveFading
.NegativeFading:
    neg.l      d3
    move.w     d3,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #-1,T_FadeStep(a5)      ; Set a step different from 1
    Rbra       L_fadeUnityinside
.PositiveFading:
    move.w     d3,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeStep(a5)       ; Set a step different from 1
    Rbra       L_fadeUnityinside


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
  Lib_Par      fadeUnitytoPalette2
    move.l     d3,-(a3)                ; Push Speed -> -(a3)
    clr.l      d3                      ; D3 = Color ID Max = 0 (for default screen color palette size)
    Rbra       L_fadeUnitytoPalette

    ; ****************************************** Fade color palette to AGA Color palette
    ; D3 = Max Color ID, (a3)+ = Speed, (A3)+ = AGA Color Palette to use
  Lib_Par      fadeUnitytoPalette      ; d3 = Amount of colors to fade
    move.l     (a3)+,d4                ; d4 = Speed
    move.l     (a3)+,d0                ; d0 = Color Palette to use
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     d3,T_MaxColorID(a5)     ; Enforce the maximum color ID if set <>0
    move.w     d4,T_FadeStep(a5)       ; d4 = Fading speed
    ; ******** 2021.03.13 Get the Color Palette pointer, and push pointer to CMAP location inside the color palette
    cmp.l      #5,d0
    ble        FD_Err1                 ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l      #255,d0
    bhi        FD_Err1                 ; Colors Palette ID > 255 -> Error : Invalid range
    Rjsr       L_Bnk.GetAdr
    beq        FD_Err4
    btst       #Bnk_BitPalette,d0      ; No Bnk_BitPalette flag = not a Colors Palette
    beq        FD_Err3
    tst.w      T_MaxColorID(a5)
;    beq.s      .noPaletteReading
    bpl.s      .noPaletteReading
    move.l     def_CMAP_size+4(a0),d3  ; D3 = Colour CMAP size.
    divu       #3,d3
    move.w     d3,T_MaxColorID(a5)     ; Enforce the maximum color ID if set <>0
.noPaletteReading:
    move.l     a0,d0                   ; d0 = color palette block size
    add.l      #def_CMAP_Colors+4,d0   ; D0 = Colour #0 CMAP position (add 4 for memblock size header)
    move.l     d0,T_NewPalette(a5)     ; Store the new color palette into T_NewPalette data.
    move.w     #1,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.b     #2,T_isFadeAGA(a5)      ; Use the AGA version 2 of the Fading interrupt.
    Rbra       L_fadeUnityinside

FD_Err1:
    moveq      #1,d0
    bra.s      FD_Errors
FD_Err3:
    moveq      #3,d0
    bra.s      FD_Errors
FD_Err4:
    moveq      #4,d0
FD_Errors:
    movem.l    (sp)+,d1-d4/a0-a2       ; LoadRegs.
    Rbra       L_Errors
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
  Lib_Def    fadeUnityinside
    move.l     T_EcCourant(a5),a1      ; A1 = Current Screen pointer
    move.l     a1,T_FadeScreen(a5)     ; T_FadeScreen(a5) = Screen required for fading calculation.
    move.w     EcNumber(a1),d0         ; d0 = Current screen number
    lsl.w      #7,d0                   ; d0 = d0 * 128
    lea        T_CopMark(a5),a0        ; a0 = T_CopMark(a5)
    add.w      d0,a0                   ; a0 = T_CopMark(a5) + ( 128 * Current Screen )
    move.l     a0,T_FadeCop(a5)        ; T_FadeCop(a5) = T_CopMark(a5) + ( 128 * CurrentScreen )
    lea        EcPal(a1),a2            ; A2 = Get Screen Color Palette
    move.l     a2,T_FadePal(a5)        ; T_FadePal(a5) = A2 = Current Screen color palette
    lea        T_FadeCol(a5),a0        ; A0 = T_FadeCol(a5) = Target color palette memory block
    move.w     EcNbCol(a1),d0          ; D0 = Amount of colours available in the Screen
; ******** 2021.04.13 Updated to handle more colors than the ones in the screen - START
    tst.w      T_MaxColorID(a5)
    beq.s      .noEnforcing
    move.w     T_MaxColorID(a5),d0     ; Force to use a specific amount of colors in the fading system.
    bra.s      .Enforced
.noEnforcing:
; ******** 2021.04.13 Updated to handle more colors than the ones in the screen - END
    cmp.w      #0,EcDual(a1)           ; Is screen dual playfield ?
    ble.s      .nodpf                  ; No -> Jump .nodpf
    move.w     #16,d0                  ; 16 colors ECS Mode for 2 screens.
    cmp.w      #0,T_isAga(a5)          ; Are we on AGA or ECS ?
    beq.s      .noAga
    lsl.w      #1,d0                   ; 32 colors AGA Mode for 2 screens.
.noAga:
.nodpf:
.Enforced:
    move.w     d0,T_FadeFlag(a5)       ; T_FadeFlag(a5) = D0 = Colour amount to Update
;    sub.w      #1,d0                   ; D0 = D0 -1 (to use -1 as end of color handling loop)
    Move.w     d0,T_FadeNb(a5)         ; T_FadeNb(a5) = Amount of colors of the Screen -1

; ******** Here start the loop that store the full color palette in RGB24 format for easier fading calculation.
fap1:
    ; ************************ First, we read the low bits values in D3 to get D3 = ......Rl..Gl..Bl
    clr.l      d3
    Move.w     EcPalL-EcPal(a2),d3  ; D3 =     ..RlGlBl
    ; ************************* Secondly, we read the high bits values in D2 to get D2 = ....Rh..Gh..Bh..
    clr.l      d2
    Move.w     (a2)+,d2         ; D2 =         ..RhGhBh
    PushToRGB24 d2,d3,d3
    move.l     d3,d2
    swap       d2               ; D2 = GhGlBhBl....RhRl
    
    ; ************************ Handle RGB12 + RGB12 to become RGB24 : Set Byte #0 = 1 = Color Active
    move.b     #1,(a0)+                ; (a0)+ = 1 = The current color is activated in the update
    move.b     d2,(a0)+                ; Push ....RhRl -> (a0)+
    move.w     d3,(a0)+                ; Push GhGlBhBl -> (a0)+
    ; Color component inserted with 4 bytes in the list (Flag,R8,G8,B8), any other color to insert ?
    dbra       d0,fap1
    move.w     #$FFFF,(a0)+            ; End of color list defined by a -1.w
    movem.l    (sp)+,d1-d4/a0-a2       ; LoadRegs.
    moveq      #0,d0                   ; D0 = 0 = Everything is OK
    rts
    ; ****************************************** 2020.09.16 New Method : Prepare the AGA fading system - End





;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME : New UNITY AGA Sprites Methods       *
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
  Lib_Def    UpdateFModes2
    movem.l    d0-d3/a0-a2,-(sp)       ; Save registers
    moveq      #10,d2                  ; D3 = Scren Number
.loopScreen:
    move.l     d2,d1
    EcCall     AdrEc                   ; Return the adress of the screen
    beq.s      .Next                   ; Screen does not exists -> .Next screen
    move.l     d0,a0
    move.w     EcNumber(a0),d0         ; Get Back Screen number in D0 for CopMark
    lsl.w      #7,d0                   ; Multiply by 128 for Cop Mark Screen D0
    lea        T_CopMark(a5),a1
    add.w      d0,a1

    move.w     T_AgaSprWidth(a5),d1
    lsl.w      #2,d1
    or.w       EcFMode(a0),d1          ; 2021.03.30 Read FMode datas

.ml:
    move.l     (a1)+,d0                ; D0 = Copper pointer to Color #00
    beq.s      .Next                   ; No pointer -> .Next Screen
    moveq      #16,d3
    Add.l      #48*4,d0
    move.l     d0,a2                   ; A0 = Copper pointer to Color #00
.s1a:
    cmp.w      #FMODE,(a2)
    beq.s      .s1
    add.l      #4,a2
    dbra       d3,.s1a
    bra.s      .ml
.s1:
    Move.w     d1,2(a2)                ; 2021.03.30 Push the whole datas
    bra.s      .ml
.Next:
    dbra       d2,.loopScreen          ; Next Screen or ends.
    movem.l    (sp)+,d0-d3/a0-a2       ; Load registers
    Rts

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
  Lib_Par    SetAGASpritesWidth
    ; ******** 1. We check if width is compatible with ECS
    cmp.l      #16,d3
    beq.s      .set16pix
    ; ******** 2. Check if AGA is Enabled or not
    tst.w      T_isAga(a5)
    Rbeq       L_Err8                   ; ECS Allow only 16 pixels width for sprites
    ; ******** 3. If AGA Is Enabled, then we check for aga compatibles width 32 and 64 pixels.
    cmp.l      #32,d3
    beq.s      .set32pix
    cmp.l      #64,d3
    Rbne       L_Err5                   ; Aga Allow only 16,32 or 64 pixels width for sprites
    ; ******** 4. Push the values in d3 for 64, 32 and 16 pixels width sprites
.set64pix:
    move.l     #aga64pixSprites,d3      ; 64 pixels wide sprites
    move.w     #4,T_AgaSprWordsWidth(a5) ;
    move.w     #8,T_AgaSprBytesWidth(a5)
    move.l     #$00200000,T_SprAttach(a5)
    bra.s      .set
.set32pix:
    move.l     #aga32pixSprites,d3      ; 32 pixels wide sprites
    move.w     #2,T_AgaSprWordsWidth(a5) ;
    move.w     #4,T_AgaSprBytesWidth(a5)
    move.l     #$00100000,T_SprAttach(a5)
    bra.s      .set
.set16pix:
    move.l     #aga16pixSprites,d3      ; 16 pixels wide sprites
    move.w     #1,T_AgaSprWordsWidth(a5) ;
    move.w     #2,T_AgaSprBytesWidth(a5)
    move.l     #$00080000,T_SprAttach(a5)
.set:
    ; ******** 5. Save the value in the register
    cmp.w      T_AgaSprWidth(a5),d3
    beq.s      noSet
    move.w     d3,T_AgaSprWidth(a5)
    ; ******** 6. We force Amos Professional to reset buffers.
    move.w     T_HsNLine(a5),d1         ; Load the current lines max size
    ext.l      d1
    subq.l     #2,d1                    ; To get the original height, as because it automatically add +2 to the sent height.
    move.w     #1,T_RefreshForce(a5)
    SyCall     SBufHs                   ; Call the method to force sprites buffers refreshing (re-create them)
    move.w     T_AgaSprWidth(a5),d0
    move.l     T_CopLogic(a5),a0        ; A0 = Copper Logic
    lsl.w      #2,d0                    ; D0 uses bits for Sprite Mode
    move.l     T_CopPhysic(a5),a1       ; A1 = Copper Physic
; ******** 2021.03.31 Update copper list FMODE set before Sprites SprXPTH/L list
    move.w     d0,CopSprFMODE+2(a0)
    move.w     d0,CopSprFMODE+2(a1)
; ******** 2021.03.31 Update copper list FMODE set before Sprites SprXPTH/L list
    Rbsr       L_UpdateFModes2
    addq.w     #1,T_EcYAct(a5)         ; Forces Screen recalculation (in copper list)
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
noSet:
    moveq      #0,d0                   ; Everything is OK;
    rts

; 2021.04.08 Should Try with these instead of using direct FMode pushes.

;
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
  Lib_Par    GetAgaSpritesMaxHeight
    move.w     T_HsNLine(a5),d3
    ext.l      d3
    subq.l     #2,d3
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
  Lib_Par    SetSpritePalette
    and.l      #$F,d3
    move.w     d3,T_AgaSprColorPal(a5)
    move.w     d3,d2
    lsl.w      #4,d2
    or.w       d2,d3
    move.l     T_CopLogic(a5),a0        ; A0 = Copper Logic
    move.l     T_CopPhysic(a5),a1       ; A1 = Copper Physic
; ******** 2021.04.07 Update copper list SPRITES Color Palette - START
    move.w     d3,CopSprPAL+2(a0)
    move.w     d3,CopSprPAL+2(a1)
; ******** 2021.04.07 Update copper list SPRITES Color Palette - END
    moveq      #0,d0
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
  Lib_Par    GetSpritePalette
    clr.l      d3
    move.w     T_AgaSprColorPal(a5),d3
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
  Lib_Par    SetSpritesToLowres
    tst.w      T_isAga(a5)
    Rbeq       L_Err9
    move.w     #$40,T_AgaSprResol(a5)     ; Low Res AGA Resolutions
    Rbra       L_ForceDisplayUpdate

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
  Lib_Par    SetSpritesToHires
    tst.w      T_isAga(a5)
    Rbeq       L_Err9
    move.w     #$80,T_AgaSprResol(a5)     ; Low Res AGA Resolutions
    Rbra       L_ForceDisplayUpdate

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
  Lib_Par    SetSpritesToSHres
    tst.w      T_isAga(a5)
    Rbeq       L_Err9
    move.w     #$C0,T_AgaSprResol(a5)     ; Low Res AGA Resolutions
    Rbra       L_ForceDisplayUpdate

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
  Lib_Par    SetSpriteToECS
    tst.w      T_isAga(a5)
    Rbeq       L_Err9
    move.w     #$00,T_AgaSprResol(a5)     ; Low Res AGA Resolutions
    Rbra       L_ForceDisplayUpdate

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
  Lib_Def    ForceDisplayUpdate
    addq.w     #1,T_EcYAct(a5)            ; Forces Screen recalculation (in copper list)
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
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
  Lib_Par    GetSpritesResolution
    clr.l      d3
    move.w     T_AgaSprResol(a5),d3
    lsr.l      #6,d3
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
  Lib_Par    CreateRainboxFX
    move.l      d3,d0
    cmp.l       #5,d0
    Rble        L_Err13                ; Rainbow FX Bank ID < 6 -> Error : Invalid range
    cmp.l       #65535,d0
    Rbhi        L_Err13                ; Rainbow FX Bank ID > 255 -> Error : Invalid range
; ******** Now we will reserve the bank.
    move.l      d0,T_SaveReg(a5)
    move.l      #(1<<Bnk_BitCopperFX)+(1<<Bnk_BitData),d1   D1 = Flags ; Memblock,DATA, FAST
    move.l      #258*4,d2              ; 256 Lines FX (Register.w+Datas.w) + 4 for the Color ID ( 0 - 255 ) +4 to save memblock size
    lea         BkCopperFX1(pc),a0     ; A0 = Pointer to BkPal (Bank Name)
    Rjsr        L_Bnk.Reserve
    Rbeq        L_Err3                 ; Not Enough Memory to allocation memblock.
    move.l      #258*4,(a0)+           ; Save Bank ID
    move.w      #1,(a0)+               ; Effect Type 1, Simple Rainbow 1 color
    move.w      #0,(a0)+               ; Color ID = 0 (per default)
    move.w      #255,d0
; ******** Push all 256 colors from 0-255 inside the effect to value RGB24(0,0,0)
.setupColors:
    move.l      #-1,(a0)+              ; Push All Copper Line to value -1 ( = Original Screen Color Value )
    dbra        d0,.setupColors
    moveq       #0,d0                  ; Everything is OK
    rts
BkCopperFX1:
    dc.b       "CopperFX",0,0
    Even

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
  Lib_Par     SetRainbowFXColorID
    move.w      d3,T_SaveReg(a5)      ; Color Index ( 000 - 255 )
    move.l      (a3)+,d0              ; D0 = Rainbow FX Palette BankID
; ******** Get Rainbow Bank Memory Pointer -> A0 if correct (check possibles errors)
    Rbsr        L_GetRainbowBank
    move.w      (a0)+,d0              ; d0 = FXType
    cmp.w       #1,d0                 ; Is the CopperFX Bank type FXType=1 (simple RainbowFX) ?
    Rbne        L_Err4                ; No -> Error
; ******** Now we will push the color inside the bank position
    move.w      T_SaveReg(a5),(a0)    ; Rainbow FX will now apply to chosen color
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
  Lib_Par     SetRainbowFXColorValue
    move.l      d3,T_SaveReg(a5)      ; Save RGB12/15/24/Value
    move.l      (a3)+,d1
    move.l      d1,T_SaveReg2(a5)     ; Save Y Line
    move.l      (a3)+,d0              ; D0 = Rainbow FX Palette BankID
; ******** Get Rainbow Bank Memory Pointer -> A0 if correct (check possibles errors)
    cmp.l       #40,d1
    Rble        L_Err14               ; Rainbow FX Y Line > 40 & < 300
    cmp.l       #255,d1
    Rbhi        L_Err14               ; Rainbow FX Y Line > 40 & < 300
    Rbsr        L_GetRainbowBank
    move.w      (a0)+,d0              ; d0 = FXType
    cmp.w       #1,d0                 ; Is the CopperFX Bank type FXType=1 (simple RainbowFX) ?
    Rbne        L_Err4                ; No -> Error
    add.w       #2,a0                 ; (do not care about colorID), jump A0 to Raster Line 0 in the definition.
; ******** Now we will push the color inside the bank position
    move.l      T_SaveReg2(a5),d0
    move.l      T_SaveReg(a5),d1
    lsl.l       #2,d0                 ; D0 = D0 * 4 ( 4 bytes = 1 long for 1 rainbow fx line definition)
    cmp.l       #-1,d1
    beq.s       .noRgb24
    ForceToRGB24 d1,d1
.noRgb24:
    move.l      d1,(a0,d0.w)
    rts
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : D0 = Bank ID                                 *
; *                                                           *
; * Return Value : A0 = Rainbow Bank (D0) memory pointer      *
; *                                                           *
; *************************************************************
  Lib_Def    GetRainbowBank
    cmp.l       #5,d0
    Rble        L_Err13               ; Rainbow FX Bank ID < 6 -> Error : Invalid range
    cmp.l       #65535,d0
    Rbhi        L_Err13               ; Rainbow FX Bank ID > 255 -> Error : Invalid range
; ******** Get Bank D0 Adress
    clr.l       d3
    Rjsr        L_Bnk.GetAdr          ; a0 = Bank Adress
    Rbeq        L_Err4                ; No Bank -> Error
    btst        #Bnk_BitCopperFX,d0   ; Is bank a CopperFX bank ?
    Rbeq        L_Err4                ; Bank Is not a CopperFX Bank -> Error
    move.l      (a0)+,d0              ; d0 = color palette block size
    cmp.l       #258*4,d0             ; Is bank size the one for FXType=1 ?
    Rbne        L_Err4                ; No -> Error
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
  Lib_Par    ApplyRainbowFXToScreen
    move.l      d3,T_SaveReg(a5)      ; Save BankID
    move.l      d3,d0
; ******** 1. Get Rainbow Bank Memory Pointer -> A0 if correct (check possibles errors)
    Rbsr        L_GetRainbowBank
    move.w      (a0)+,d0              ; d0 = FXType
    cmp.w       #1,d0                 ; Is the CopperFX Bank type FXType=1 (simple RainbowFX) ?
    Rbne        L_Err4                ; No -> Error
    add.w       #2,a0                 ; (do not care about colorID), jump A0 to Raster Line 0 in the definition.
; ******** 2. Check if current screen is valid
    move.l     ScOnAd(a5),d0          ; D0 = Get Current Screen
    Rbeq       L_Err15                ; No current screen -> Error #15 "NoScreenAvailable"
    move.l     d0,a2                  ; a2 = Current Screen pointer
; ******** Now we will push the FX to the screen
    move.l      T_SaveReg(a5),d0      ; D0 = BankID
; ******** 3. Enable RainbowFX in current Screen
    move.w     ScreenFX(a2),d2
    btst       #SimpleRainbowFX,d2    ; Is the CopperFX Bank type FXType=1 (simple RainbowFX) ?
    move.b     #1,ScreenFX(a2)        ; Enable Simple Rainbow FX As Layer in the chosen Screen
    Dlea       RainbowFXCall,d1
    move.l     d1,ScreenFXCall(a2) ; Push Callable adress for FX
; ******** 4. Save  Sprites Playfield FX datas in current Screen
    move.w     d0,sprFX_BankID+ScreenFXDatas(a2) ; Bank to use for the Rainbow FX
; ******** 5. Ask AMOS to refresh screens (to insert the Sprite as layered background)
    addq.w     #1,T_EcYAct(a5)            ; Forces Screen recalculation (in copper list)
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
;    move.w     #2,T_doubleRefresh(a5)
    moveq      #0,d0
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
  Lib_Par    RemoveRainbowFXFromScreen
; ******** 1. Check if current screen is valid
    move.l     ScOnAd(a5),d0          ; D0 = Get Current Screen
    Rbeq       L_Err15                ; No current screen -> Error #15 "NoScreenAvailable"
    move.l     d0,a2                  ; a2 = Current Screen pointer
    move.b     #0,ScreenFX(a2)        ; Disable Simple Rainbow FX As Layer in the chosen Screen
    clr.l      ScreenFXCall(a2)       ; Remove Callable adress for FX
; ******** 2. Save  Sprites Playfield FX datas in current Screen
    clr.w      sprFX_BankID+ScreenFXDatas(a2) ; Clear bank to use for FX.
; ******** 3. Ask AMOS to refresh screens (to insert the Sprite as layered background)
    addq.w     #1,T_EcYAct(a5)            ; Forces Screen recalculation (in copper list)
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
    move.w     #2,T_doubleRefresh(a5)
    moveq      #0,d0
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_insertSimpleRainbowFX                     *
; *-----------------------------------------------------------*
; * Description : This method will insert a Sprite FX called  *
; *                       <<Create Playfield From Sprite>>    *
; *                                                           *
; * Parameters :
; *   A0 = Screen Structure inside which, FX will be inserted *
; *   A1 = Logic Copper List (Where FX will be inserted)      *
; *   D0 = Max Line to reach (never go up to this line)       *
; *      sprFX_BankID+ScreenFXDatas(ScrnPointer) = Bank To Use*
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Def    insertSimpleRainbowFX
    movem.l    a4,-(sp)              ; Save A4 (Screen Color Palette)
; ******** 1. We calculate the last line that can be updated with Simple Rainbow FX
    cmp.w      #0,d0
    bge.s      .noNeg
.neg:
    neg.w      d0
.noNeg:
    sub.w      #EcYBase,d0
; ******** 2. We calculate the 1st line that can be updated with Simple Rainbow FX
    move.w     T_lastYLinePosition(a5),d1 ; D1 = Last line that was processed by Amos Professional Copper List System (screen insertion)
    sub.w      #EcYBase,d1           ; D1 = 1st line for the started screen
    add.w      #1,d1                 ; D1 = 1st Start Line
; ******** 3. We calculate the amount of lines that can be edited.
    cmp.w      #254,d0
    ble.s      .ctNC
    move.l     #254,d0
.ctNC:
    sub.w      d1,d0                 ; D0 = Amount of lines to edit.
    move.l     d0,T_SaveReg(a5)      ; Save D0 = Lines Count
    move.l     d1,T_SaveReg2(a5)     ; Save D1 = Y Start
    movem.l    a0/a1,-(sp)           ; Save A0 = Screen Pointer / a1 = Copper list pointer
; ******** 4. Now we get the bank defined in the screen to insert it in the copper list.
    cmp.w      #2,d0
    ble.w      cleanScreen
    clr.l      d0
    move.w     sprFX_BankID+ScreenFXDatas(a0),d0 ; D0 = Amos Professional Bank used to get Simple Rainbow FX Datas.
    clr.l      d3
    Rjsr       L_Bnk.GetAdr          ; a0 = Bank Adress
    beq        cleanScreen           ; No Bank -> Error
    move.l     a0,a2
    btst       #Bnk_BitCopperFX,d0   ; Is bank a CopperFX bank ?
    beq        cleanScreen           ; Bank Is not a CopperFX Bank -> Error
    move.l     (a2)+,d0              ; d0 = color palette block size
    cmp.l      #258*4,d0             ; Is bank size the one for FXType=1 ?
    bne        cleanScreen           ; No -> Error
    move.w     (a2)+,d0              ; d0 = FXType
    btst       #SimpleRainbowFX,d0   ; Is the CopperFX Bank type FXType=1 (simple RainbowFX) ?
    beq        cleanScreen    
; ******** 5
    movem.l    (sp)+,a0/a1           ; A0 = Screen Pointer / a1 = Copper list pointer / a2 = Rainbow FX Bank Pointer
; ******** 5. Push A4 to the pointer of the screen color palette Color ID.
    lea.l      EcPal(a0),a4          ; a4 = Screen Color #00
    clr.l      d2
    move.w     (a2)+,d2              ; d2 = Color chosen for the FX
;    move.w     (a2),d2
    lsl.w      #1,d2
    add.l      d2,a4                 ; a4 = Pointer to the color in the screen color palette
    lsr.w      #1,d2
; ******** 6. We Get the Color ID and prepare value for BplCon3 updates (Bit#9 for LOCT $200 for low, $000 for High, filter with SPRES value too.)
    tst.w      T_isAga(a5)
    beq.s      .noBankCalculation
    move.w     d2,d3
    and.l      #%11100000,d3         ; d3 = Color banks in bits 05-07
    lsl.w      #8,d3                 ; d3 = Color Banks in bits 13-15 (BplCon3 bits)
    or.w       T_AgaSprResol(a5),d3  ; -----> d3 = Color Banks in bits 13-15 + current AGA Sprites Resolutions (BplCon3 bits)
.noBankCalculation:
    and.l      #%11111,d2            ; d2 filtered in range 000-031 = Color Index Range 000-031
    lsl.w      #1,d2
    or.w       #$180,d2              ; -----> d2 = Color Register to setup

; ******** 7. We jump to the 1st line in the Rainbow FX bank to use for editing
    move.l     T_SaveReg(a5),d0      ; -----> Load D0 = Lines Count
    move.l     T_SaveReg2(a5),d1     ; -----> Load D1 = Y Start
    move.l     d1,d7
    lsl.w      #2,d7                 ; D7 = Y Line * 4
    add.l      d7,a2                 ; -----> A2 = Current line to edit

; ****************************************************************
; ******** 8 Push last calculation to original color
    move.l     #-1,d6                  ; Color Value = -1 = Original color.

; ******** 9 Start Y Loop for Rainbow Effect
CopperYLoop:
; ******** 10 Calculate the Copper Wait for this line and insert Copper Line (Y) Wait.
;    move.w #(DISPLAY_Y<<8)!$38!$0001,d7 ;$38 empiriquement déterminé, mais en fait c'est la valeur de DDFSTRT en lowres (4.5 cycles d'horloge vidéo avant DIWSTRT => $81/2-8.5 car résolution de DIWSTRT est le pixel mais de DDFSTRT est 4 pixels)
    move.w     d1,d7                   ; d7 = Y Start / Y Current Line
    and.l      #$FF,d7                 ; Y Line && 255 (to be sure it's inside view)
    lsl.w      #8,d7                   ; Push d7.w = YYYYYYYY........
    or.w       #$18!$0001,d7           ; Add X Screen Position Start

; ******** 11 Read new Rainbow FX line data and check what to do
    move.l     (a2)+,d5                ; d5 = New color to implement
    cmp.l      d5,d6                   ; Are old & new color the same ?
    beq.w      continue               ; Yes -> Do not push any color change (optimisation)
    move.l     d5,d6                   ; Save new color for next line update checking

; ******** 12 Push Y Line Wait if we are lower than the current Screen Y Line  position
    move.w     d7,(a1)+                ; Wait Line d7
    move.w     #$FFFE,(a1)+            ; 

; ******** 13 Do we restore original color or push a new one ?
    cmp.l      #-1,d5
    beq.s      .restore
.modify:
; ******** 14.1 Cut Rgb24(D5) into two Rgb12H(d4) & Rgb12L(d5)
    getRGB12Datas d5,d4,d5             ; D5=Rgb24->D4=Rgb12H,D5=Rgb12L
; ******** 14.2 Do we push AGA or ECS/OCS Color in the copper list ?
    tst.w      T_isAga(a5)             ; Are we on AGA or ECS/OCS ?
    beq.s      .ecsColor
.agaColor:
; ******** 15.1 Push New AGA Color Rgb12 High bits
    bclr       #9,d3                   ; LOCT = 1 (Low Bits)
    move.w     #BplCon3,(a1)+          ; BplCon3 = Modify Color High Bits
    move.w     d3,(a1)+                ; Push BplCon3 value
    move.w     d2,(a1)+                ; Color#XX register
    move.w     d4,(a1)+                ; Color Value RGB12H
; ******** 15.2 Push New AGA Color Rgb12 Low bits
    bset       #9,d3                   ; LOCT = 1 (Low Bits)
    move.w     #BplCon3,(a1)+    
    move.w     d3,(a1)+                ; Push BplCon3 value
    move.w     d2,(a1)+                ; Color#XX register
    move.w     d5,(a1)+                ; Color Value RGB12L
    bra.s      continue
; ******** 15.2 Push New ECS Color Rgb12  bits
.ecsColor:
    move.w     d2,(a1)+                ; Color#XX register
    move.w     d4,(a1)+                ; Color Value RGB12H
    bra.s      continue
.restore:
; ******** 16 Do we push AGA or ECS/OCS Original Color in the copper list ?
    tst.w      T_isAga(a5)             ; Are we on AGA or ECS/OCS ?
    beq.s      .ecsOriginalColor
; ******** 17.1 Push Original AGA Color Rgb12 High bits
.agaOriginalColor:
    bclr       #9,d3                   ; LOCT = 1 (Low Bits)
    move.w     #BplCon3,(a1)+          ; BplCon3 = Modify Color High Bits
    move.w     d3,(a1)+                ; Push BplCon3 value
    move.w     d2,(a1)+                ; Color#XX register
    move.w     (a4),(a1)+              ; Color Value RGB12H
; ******** 17.2 Push Original AGA Color Rgb12 Low bits
    bset       #9,d3                   ; LOCT = 1 (Low Bits)
    move.w     #BplCon3,(a1)+    
    move.w     d3,(a1)+                ; Push BplCon3 value
    move.w     d2,(a1)+                ; Color#XX register
    move.w     EcPalL-EcPal(a4),(a1)+  ; Color Value RGB12L
    bra.s      continue
; ******** 18 Push Original ECS Color Rgb12 bits
.ecsOriginalColor:
    move.w     d2,(a1)+                ; Color#XX register
    move.w     (a4),(a1)+              ; Color Value RGB12H
; ******** 19 Continue to the next line
continue:
    addi.w     #$01,d1                 ; D1 = Next Copper Line Wait
    dbra       d0,CopperYLoop          ; D0 = D0 - 1 ; if d0 > -1 -> Jump CopperYLoop (Another Y Line to draw ?)

; ******** 20 If we are on ECS/OCS, ne BplCon3/Pal0 restore required
    tst.w      T_isAga(a5)             ; Are we on AGA or ECS/OCS ?
    beq.s      .endRainbowFX
.restoreDefColorPalette:
    and.w      #%11111111,d3           ; Leave only Sprites resolution datas, push Palette 00 HighBits(LOCT=0)
    move.w     #BplCon3,(a1)+    
    move.w     d3,(a1)+                ; Push BplCon3 value
.endRainbowFX:
    movem.l    (sp)+,a4                ; Restore Original a4
    Rts

; ******** 10. If an error happen (bank does no more exists, bad bank type, etc.) we remove FX from the screen.
cleanScreen:
    movem.l    (sp)+,a0/a1           ; A0 = Screen Pointer / a1 = Copper list pointer
    movem.l    (sp)+,a4              ; Restore Original a4
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
  Lib_Par     getRainbowFXColorValue
    move.l      d3,T_SaveReg(a5)      ; Save Y Line
    move.l      (a3)+,d0              ; D0 = Rainbow FX Palette BankID
; ******** Get Rainbow Bank Memory Pointer -> A0 if correct (check possibles errors)
    cmp.l       #40,d3
    Rble        L_Err14               ; Rainbow FX Y Line > 40 & < 300
    cmp.l       #255,d3
    Rbhi        L_Err14               ; Rainbow FX Y Line > 40 & < 300
    Rbsr        L_GetRainbowBank
    move.w      (a0)+,d0              ; d0 = FXType
    btst        #SimpleRainbowFX,d0   ; Is the CopperFX Bank type FXType=1 (simple RainbowFX) ?
    Rbeq        L_Err4                ; No -> Error
    add.w       #2,a0                 ; (do not care about colorID), jump A0 to Raster Line 0 in the definition.
; ******** Now we will push the color inside the bank position
    move.l      T_SaveReg(a5),d0
    lsl.l       #2,d0                 ; D0 = D0 * 4 ( 4 bytes = 1 long for 1 rainbow fx line definition)
    move.l      (a0,d0.w),d3
    Ret_Int
    rts

;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                          *                                                  *
;                                                                                          * AREA NAME : Custom Screens Support methods       *
;                                                                                          *                                                  *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************


;
; *****************************************************************************************************************************
; ************************************************************* 2021.12.20-21
; * Method Name :                                             *
; *   Get saga C2P Screen Mode(width,height,depth(,scanmode)) *
; *-----------------------------------------------------------*
; * Description : This method will return a SAG GFXMODE regis-*
; *               -ter compatible value for RESOLUTION and DE-*
; *               -PTH for Saga C2P screen mode               *
; *                                                           *
; * Parameters : Visible Width in pixels, Visible Depth in pi-*
; *              -els, Depth                                  *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     GetSagaC2PScreenMode    ;
    move.l      d3,-(a3)              ; Push Depth to -(a3)
    clr.l       d3                    ; d3 = Scan Mode = 0
    Rbra        L_GetSagaC2PScreenModeEx
; *************************************************************
  Lib_Par     GetSagaC2PScreenModeEx  ; d3 = ScanMode
    move.l      (a3)+,d5              ; d5 = depth
    move.l      (a3)+,d2              ; d2 = Height in pixels
    move.l      (a3)+,d1              ; d1 = Width in pixels

;; **** 1. We check the chosen ScanMode
;    Dlea        SAGA_C2P_DBLSCAN,a0
;.miniLoopDBL:
;    move.w      (a0)+,d0
;    cmp.w       d0,d5
;    beq.s       .miniLoopQuitDBL
;    add.l       #2,a0                 ; Jump to next value
;    cmp.w       #0,(a0)               ; new value ?
;    bne.s       .miniLoopDBL             ; Yes -> Continue Looping
;    Rbra        L_Err18               ; "Unknown SAGA Double Scan mode requested."     * Error #18 USED (Saga Screen Mode)
;.miniLoopQuitDBL:
;    move.w      (a0),d3               ; d5 (07-00) = GFXMode Pixel Format

; **** 2. We check if the entered depth is available.
    Dlea        SAGA_C2P_DEPTHS,a0
.miniLoop:
    move.w      (a0)+,d0
    cmp.w       d0,d5
    beq.s       .miniLoopQuit
    add.l       #2,a0                 ; Jump to next value
    cmp.w       #0,(a0)               ; new value ?
    bne.s       .miniLoop             ; Yes -> Continue Looping
    Rbra        L_Err17               ; "Requested SAGA C2P Screen depth is not available."     * Error #17 USED (Saga Screen Mode)
.miniLoopQuit:
    move.w      (a0),d5               ; d5 (07-00) = GFXMode Pixel Format

; **** 3. We check if the chosen graphic resolution is available.
    Dlea        SAGA_C2P_GFXMODES,a0
.miniLoopGFX:
    move.w      (a0)+,d0              ; d0 = Existing Resolution Width in pixels
    move.w      (a0)+,d4              ; d4 = Existing Resolution Height in pixels
    cmp.w       d4,d2                 ; d2(Height) = Existing resolution Height ?
    bne.s       .miniLoopCheck2       ; No, continue with next test
    cmp.w       d0,d1                 ; d1(Width) = Existing resolution Width(d1) ?
    beq.s       .miniLoopGFXQuit
.miniLoopCheck2:
    add.l       #2,a0
    cmp.w       #0,(a0)
    bne.s       .miniLoopGFX
    Rbra        L_Err16               ; "Requested SAGA C2P Screen resolution is not available.",0  * Error #16 USED (Saga Screen Mode)
.miniLoopGFXQuit:
    or.w        (a0),d3               ; d3 = (07-00) GFXMode Resolution + ScanMode (15-14)
    lsl.w       #8,d3                 ; d4 = (15-08) GFXMode Resolution
    or.w        d5,d3                 ; d3 = GFXMODE Resolution(15-08) | Pixelformat(07-00)
    and.l       #$FFFF,d3             ; ensure higher 16 bits are suppressed to fix GFXMode content.
    Bset        #SagaC2PModeBit,d3    ; Use the SAGA Graphic C2P Screen Mode
    Ret_Int




;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *   Open Custom Screen SCREENID,WIDTH,HEIGHT,GFXMODE        *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : ScreenID,X,Y,GFXMODE                         *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     CustomScreenOpen       ; D3 = Screen GFX MODE
; ******* 1. Get all screen creation informations
    move.l      (a3)+,d2             ; D2 = Screen Height in pixels (Visible + Not visible)
    move.l      (a3)+,d1             ; D1 = Screen Width in pixels (Visible + Not visible)
    move.l      (a3)+,d0             ; D0 = Screen ID
; ******* 2. Check screenID limits
    cmp.l       #8,d0
    Rbge        L_Err18              ; "Custom Screen ID number is invalid. Valid range is 0-7 (included)" * Error #18 USED (Custom Screens)
    cmp.l       #0,d0
    Rbmi        L_Err18              ; "Custom Screen ID number is invalid. Valid range is 0-7 (included)" * Error #18 USED (Custom Screens)
; ******* 3. Screen sizes will be checked by dedicaced Custom Screen Creation methods as they will depend on the GFXMODE resolution visible sizes.
; ******* 3. Check screen mode and redirect to the dedicaced screen creation method.
    Btst        #SagaC2PModeBit,d3
    Rbne        L_OpenSagaC2PScreen
; .... Add other screens type here
    Rbra        L_Err21              ; "Unknown Custom Screen type."  * Error #21 USED (Custom Screens)



; *****************************************************************************************************************************
; * OpenSagaC2PScreen D0(=ScreenID), D1(=Screen Pixels Width), D2(=Screen Pixels Height), D3(=GFXMODE)
; *****************************************************************************************************************************
  Lib_Def     OpenSagaC2PScreen      ; Internal method to open a SAGA C2P Screen
    bclr        #SagaC2PModeBit,d3   ; Remove the C2P Screen mode bit.
    move.l      d3,d5                ; D5 = GFXMODE content (high bits 15-8)
    and.l       #$FF00,d5            ; Keep only the GFXMODE graphical resolution value
    lsr.l       #8,d5                ; D5 = GFXMODE in low bits (7-0)

; *************************************************************** Check GFXMODE (Resolution informations)
    Dlea        SAGA_C2P_GFXMODES,a0
    add.l       #4,a0                ; Push A0 directly to the Graphic resolution ID code.
    move.w      (a0),d7              ; d7 = Screen mode Resolution ID Code to check/compare
.miniLoop:
    cmp.w       d7,d5                ; if chosen resolution ID Code (d5) = current readen one (d7) ?
    beq.s       .found               ; Yes -> Jump .found
    add.l       #6,a0                ; No -> Check next graphic resolution ID Code
    move.w      (a0),d7              ; d7 = Next Screen mode resolution ID Code to check/compare
    cmp.w       #0,d7                ; d7 = NULL (=0) = Screen resolution ID Code list finished ?
    bne.s       .miniLoop            ; NO -> Check next resolution ID Code with chosen one.
    Rbra        L_Err16              ; "Requested SAGA C2P Screen resolution is not available.",0  * Error #16 USED (Saga Screen Mode)
.found    
    move.w      -4(a0),d6            ; d6 = Graphic Resolution visible pixel Widht
    move.w      -2(a0),d7            ; d7 = Graphic Resolution visible pixel Height

                                     ; D0=ScreenID, D1=Width, D2=Height, D3=GFXMode, D6=VisibleWidth, D7=VisibleHeight
    Dlea        TEMP_BUFFER,a1 
    move.w      d0,2(a1)             ; Save ScreenID
    move.w      d1,6(a1)             ; Save Width
    move.w      d2,10(a1)            ; Save Height
    move.w      d3,14(a1)            ; Save GFXMode
    move.w      d6,18(a1)            ; Save Width display resolution
    move.w      d7,22(a1)            ; Save height display resolution.

; *************************************************************** Check screen sizes limits
; 1. Check Screen Width must be >= Display Width
    cmp.w       d6,d1                ; if D1 (Requested Pixels Width) < D6 (Visible Pixels Width)
    Rblt        L_Err22              ; Screen Pixels Width is smaller than requested resolution pixels width.      * Error #22 USED (Custom Screens)
; 2. Check Screen Height must be >= Display Height
    cmp.w       d7,d2                ; if D2 (Requested Pixels Height) < D7 (Visible Pixels Height)
    Rblt        L_Err23              ; Screen Pixels Height is smaller than requested resolution pixels height.    * Error #23 USED (Custom Screens)
; 3. Check Screen Width maximal size (3x Display Width)
    mulu        #3,d6
    cmp.w       d1,d6
    Rblt        L_Err24              ; Screen Pixels Width is higher than 3x requested resolution pixels width.    * Error #24 USED (Custom Screens)
; 4. Check Screen Height maximal size (3x Display Height)
    mulu        #3,d7
    cmp.w       d2,d7
    Rblt        L_Err25              ; Screen Pixels Height is higher than 3x requested resolution pixels height.  * Error #25 USED (Custom Screens)

; *************************************************************** 2021.01.03 If screenID already exists, close the current one before opening the new one.
    move.l      d3,d7                ; D7 = GFXMODE
    and.l       #$0F,d7              ; D7 = Pixel Format
    cmp.b       #0,d7
    Rbeq        L_Err26              ; Invalid Custom Screen Pixel format                                          * Error #26 USED (Custom Screens)
    Dlea        SAGA_PIXEL_SIZE,a0
    lsl.w       #1,d7                ; To Read a .w from the list mulu d7 by 2 (d7 range is 1-10 so it gives 2-20)
    move.w      (a0,d7),d4           ; d4 = Pixel Size ( 1, 2, 3 or 4 bytes depending on PixelFormat used)
    move.w      d4,26(a1)            ; Save Pixel Depth

; ***************************************************************
; * Current OpenSagaC2PScreen datas D0(=ScreenID), D1(=Screen Pixels Width),
;           D2(=Screen Pixels Height), D3(=GFXMODE), D4=Pixel Size (in bytes), D6=Display Width(in pixels), D7=Display Height(in pixels)
; Now we allocate memory for the screen
    Dlea        CUSTOM_SCREEN,a2     ; a2 = Custom screens structures pointers
    move.l      d0,d5                ; D5 = Screen ID
    lsl.l       #2,d0                ; D0 = D0 * 4
    add.l       d0,a2                ; a2 = Current Custom Screen Structure Pointer
    cmp.l       #0,(a2)              ; Screen already exists ?
    Rbne        L_Err27              ; Screen already exists error                                                  * Error #27 USED (Custom Screens)
; Allocate memory for screen structure
    move.l      #CusEcLong,d0
    Rjsr        L_RamFast            ; Allocate screen structure
    move.l      d0,(a2)              ; a2 = Screen Structure save
    move.l      d0,a2
    Dlea        TEMP_BUFFER,a1
    move.l      (a1)+,d0             ; D0 = Screen ID
    move.l      (a1)+,d1             ; D1 = Screen Width in pixels
    move.l      (a1)+,d2             ; D2 = Screen Height in pixels
    move.l      (a1)+,d3             ; D3 = GFXMode
    move.l      (a1)+,d4             ; D4 = Display Width
    move.l      (a1)+,d5             ; D5 = Displey Height
    move.l      (a1),d6             ; D6 = Pixel depth in bytes
    move.l      d1,CusEcPixWidth(a2)
    move.l      d2,CusEcPixHeight(a2)
    move.l      d3,CusEcGFXMODE(a2)
    move.l      d4,CusEcViewWidth(a2)
    move.l      d5,CusEcViewHeight(a2)
    move.l      d6,CusEcPixDepth(a2)
    sub.l       d1,d4                ; D4 = CusEcViewWidth - CusEcPixWidth = CusEcMod
    move.l      d4,CusEcMod(a2)
    mulu        d6,d1                ; d1 = Width * Depth ( Bytes in size of a whole screen )
    mulu        d2,d1                ; d1 = Width * Depth * Height
    move.l      d1,CusBufferLen(a2)  ; Save screen buffer length
    move.l      d1,d0                ; d0 = Bytes size
    Rjsr        L_RamFast            ; Allocate screen plane datas
    move.l      d0,CusEcLogic(a2)    ; \
    move.l      d0,CusEcPhysic(a2)   ;  > Save Screen pointer
    move.l      d0,CusEcCurrent(a2)  ; /
    move.l      #1,CusEcInkA
    move.l      #2,CusEcInkB
    move.l      #0,CusEcPaper
    move.l      #1,CusEcText
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *   Close Custom Screen SCREENID                            *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : ScreenID                                     *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     CustomScreenClose      ; D3 = Screen GFX MODE
; ******* 1. Check screenID limits
    cmp.l       #8,d3
    Rbge        L_Err18              ; "Custom Screen ID number is invalid. Valid range is 0-7 (included)" * Error #18 USED (Custom Screens)
    cmp.l       #0,d3
    Rbmi        L_Err18              ; "Custom Screen ID number is invalid. Valid range is 0-7 (included)" * Error #18 USED (Custom Screens)
    Dlea        CUSTOM_SCREEN,a2     ; a2 = Custom screens structures pointers
    lsl.l       #2,d3
    Add.l       d3,a2                ; a2 = Pointer to chosen screen
    move.l      (a2),d7              ; d7 = Screen Pointer
    tst.l       d7
    Rbeq        L_Err28              ; "Custom screen does not exists"                                        * Error #28 USED (Custom Screens)
    clr.l       (a2)                 ; Libère l'écran
    move.l      d7,a2
    move.l      CusBufferLen(a2),d0
    move.l      CusEcPhysic(a2),a1
    Rjsr        L_RamFree            ; Libération du bloc mémoire de l'écran lui même
    move.l      a2,a1
    move.l      #CusEcLong,d0
    Rjsr        L_RamFree            ; Libération du bloc mémoire de la structure de l'écran
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *   Get Custom Screen Base SCREENID                         *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : ScreenID                                     *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par     GetCustomScreenBase    ; D3 = Screen ID
; ******* 1. Check screenID limits
    cmp.l       #8,d3
    Rbge        L_Err18              ; "Custom Screen ID number is invalid. Valid range is 0-7 (included)" * Error #18 USED (Custom Screens)
    cmp.l       #0,d3
    Rbmi        L_Err18              ; "Custom Screen ID number is invalid. Valid range is 0-7 (included)" * Error #18 USED (Custom Screens)
    Dlea        CUSTOM_SCREEN,a2     ; a2 = Custom screens structures pointers
    lsl.l       #2,d3
    Add.l       d3,a2                ; a2 = Pointer to chosen screen
    move.l      (a2),d3              ; d3 = Screen Pointer
    Ret_Int

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
; * Method Name : L_IffReadFile2                              *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It read datas from an opened   *
; * file.                                                     *
; *                                                           *
; * Parameters : D1 = Handler to the opened file              *
; *              D2 = Buffer                                  *
; *              D3 = Bytes amount to read from file          *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      IffReadFile2
    movem.l    a0/a1/a6/d1,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVORead(a6)
    movem.l    (sp)+,a0/a1/a6/d1
    tst.l      d0
    Rbmi       L_DiskFileError
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_IffWriteFile2                             *
; *-----------------------------------------------------------*
; * Description : This method is imported from AmosProAGA.lib *
; * To makes files I/O easier. It write datas to an opened    *
; * file.                                                     *
; *                                                           *
; * Parameters : D1 = Handler to the opened file              *
; *              D2 = Buffer                                  *
; *              D3 = Bytes amount to write to file           *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      IffWriteFile2
    movem.l    a0/a1/a6/d1,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOWrite(a6)
    movem.l    (sp)+,a0/a1/a6/d1
    tst.l      d0
    Rbmi       L_DiskFileError
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
; 
;     NOTE: this extension uses the main internal AMOS error messages,
;     But, follow the explanation on how to create NEW error messages,
;     specific to the extension. Everything is remark, of course...        
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; ____________________________________________________________________
;
; How to create you own messages...
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; You know that the compiler have a ERROR option (with errors) and a 
; a NOERROR (without errors). To achieve that, the compiler copies one of
; the two next routines, depending on the flag. If errors are to be
; copied along with the program, then the next next routine is used. If not,
; then the next one is copied.
; The compiler assumes that the two last routines in the library handles
; the errors: the previous last is WITH errors, the last is WITHOUT. So,
; remember:
;
; THESE ROUTINES MUST BE THE LAST ONES IN THE LIBRARY
;
; The AMOS interpretor always needs errors. So make all your custom errors
; calls point to the L_Custom routine, and everything will work fine...
;
; "With messages" routine.
; The following routine is the one your program must call to output
; a extension error message. It will be used under interpretor and under
; compiled program with -E1
;
;    Lib_Def    Mus_Custom
;    lea    ErrMess(pc),a0
;    moveq    #0,d1        * Can be trapped
;    moveq    #ExtNb,d2    * Number of extension
;    moveq    #0,d3        * IMPORTANT!!!
;    Rjmp    L_ErrorExt    * Jump to routine...
;* Messages...
;ErrMess
;    dc.b    "Wave not defined",0        *0
;    dc.b     "Sample not defined",0        *1
;    dc.b     "Sample bank not found",0    *2
;    dc.b    "256 characters for a wave",0    *3
;    dc.b    "Wave 0 and 1 are reserved",0    *4
;    dc.b    "Music bank not found",0    *5
;    dc.b     "Music not defined",0        *6
;    dc.b    "Can't open narrator",0        *7
;    dc.b    "Not a tracker module",0    *8
;* IMPORTANT! Always EVEN!
;    even
;
;******* "No errors" routine
; If you compile with -E0, the compiler will replace the previous
; routine by this one. This one just sets D3 to -1, and does not
; load messages in A0. Anyway, values in D1 and D2 must be valid.
;    
; THIS ROUTINE MUST BE THE LAST ONE IN THE LIBRARY!
;
;L113    moveq    #0,d1
;    moveq    #ExtNb,d2
;    moveq    #-1,d3
;    Rjmp    L_ErrorExt
; ___________________________________________________________________

  Lib_Def   FonCall
    moveq   #23,d0
    Rbra    L_GoError

; 2021.12.21 Idead for optimisations :
; Check For/Next loop to optimize error https://stackoverflow.com/questions/4217900/basic-for-loop-in-68k-assembly
; Or use a MACRO Style : CastError ID that will be replaced with "moveq #\1,d0, Rbra L_Errors"
; use pass1 macro style with variable defined using SET and a REPT in which the variable is incremented each time and used to create label + moveq

  Lib_Def Err1             ; Error 01 : Aga color palette creation valid range is 0-7.
    moveq   #1,d0
    Rbra    L_Errors

  Lib_Def Err2             ; Error 02 : Colors amount is incorrect (Valids values are 2,4,8,16,32,64,128,256)
    moveq   #2,d0
    Rbra    L_Errors

  Lib_Def Err3             ; Error 03 : Not enough free memory to allocate the requested memory bank.
    moveq   #3,d0
    Rbra    L_Errors

  Lib_Def Err4             ; Error 04 : The requested bank does not exists or is not of the correct type.
    moveq   #4,d0
    Rbra    L_Errors

  Lib_Def Err5             ; Width value is invalid. AGA Sprites Width can be 16,32 or 64
    moveq   #5,d0
    Rbra    L_Errors

  Lib_Def Err6             ; The specified file is not an IFF/ILBM Color Map (CMAP) file.
    moveq   #6,d0
    Rbra    L_Errors

  Lib_Def Err7             ; Cannot allocate memory to store the IFF/ILBM CMAP file.
    moveq   #7,d0
    Rbra    L_Errors

  Lib_Def Err8             ; Sprites Width value is invalid. ECS Sprites Width can only be 16
    moveq   #8,d0
    Rbra    L_Errors

  Lib_Def Err9            ; This command is available only on AGA Compatibles graphics chipsets.
    moveq   #9,d0
    Rbra    L_Errors

  Lib_Def Err10           ; The input RGB format is not recognized.
    moveq   #10,d0
    Rbra    L_Errors

  Lib_Def Err11           ; The requested color index is out of the color palette range.
    moveq   #11,d0
    Rbra    L_Errors

  Lib_Def NoScreenAvailable ; No current screen detected.
    moveq   #12,d0
    Rbra    L_Errors

  Lib_Def Err13           ; Valid Rainbow FX bank id range is 6-65535.
    moveq   #13,d0
    Rbra    L_Errors

  Lib_Def Err14           ; Rainbow FX can only update from hardware line 40 to 255.
    moveq   #14,d0
    Rbra    L_Errors

  Lib_Def Err15           ; No 'Current Screen' available.
    moveq   #15,d0
    Rbra    L_Errors

  Lib_Def Err16           ; Requested resolution is not available
    moveq   #16,d0
    Rbra    L_Errors

  Lib_Def Err17           ; Requested Depth is not available
    moveq   #17,d0
    Rbra    L_Errors

  Lib_Def Err18           ; Unknown SAGA Double Scan mode requested.
    moveq   #18,d0
    Rbra    L_Errors


  Lib_Def Err19           ; Custom Screen ID number is invalid. Valid range is 0-7 (included).
    moveq   #19,d0
    Rbra    L_Errors

  Lib_Def Err20           ; Unknown Custom Screen GFXMODE.
    moveq   #20,d0
    Rbra    L_Errors

  Lib_Def Err21           ; Unknown Custom Screen type
    moveq   #21,d0
    Rbra    L_Errors

  Lib_Def Err22           ; Screen Pixels Width is smaller than requested resolution pixels width.
    moveq   #22,d0
    Rbra    L_Errors

  Lib_Def Err23           ; Screen Pixels Height is smaller than requested resolution pixels height.
    moveq   #23,d0
    Rbra    L_Errors

  Lib_Def Err24           ; Screen Pixels Width is higher than 3x requested resolution pixels width.
    moveq   #24,d0
    Rbra    L_Errors

  Lib_Def Err25           ; Screen Pixels Jeogjt is higher than 3x requested resolution pixels height.
    moveq   #25,d0
    Rbra    L_Errors

  Lib_Def Err26           ; Invalid Custom Screen Pixel format.
    moveq   #26,d0
    Rbra    L_Errors

  Lib_Def Err27           ; Invalid Custom Screen Pixel format.
    moveq   #27,d0
    Rbra    L_Errors

  Lib_Def Err28           ; Invalid Custom Screen Pixel format.
    moveq   #28,d0
    Rbra    L_Errors

    Lib_Def Errors
    lea     ErrMess(pc),a0
    moveq   #0,d1        * Can be trapped
    moveq   #ExtNb,d2    * ID Number of the current extension
    moveq   #0,d3        * IMPORTANT!!!
    Rjmp    L_ErrorExt    * Jump to routine...

ErrMess:
    dc.b    "err0",0
; ******** Color Palette V2 error messages CURRENT VERSION
    dc.b    "Valid colors palette id range is 6-65535",0                                           * Error #1 USED
    dc.b    "Colors amount is incorrect (Valids values are 2,4,8,16,32,64,128,256)", 0             * Error #2 USED
    dc.b    "Not enough free memory to allocate the requested memory bank",0                       * Error #3 USED
    dc.b    "The requested bank does not exists or is not of the correct type.",0                  * Error #4 USED
    dc.b    "Sprites Width value is invalid. AGA Sprites Width can be 16,32 or 64.",0              * Error #5 USED
; *******
    dc.b    "The specified file is not an IFF/ILBM Color Map (CMAP) file.",0                       * Error #6 USED -> (#14)
    dc.b    "Cannot allocate memory to store the IFF/ILBM CMAP file.",0                            * Error #7 USED -> (#15)

    dc.b    "Sprites Width value is invalid. ECS Sprites Width can only be 16.",0                  * Error #8 USED
    dc.b    "This command is available only on AGA Compatibles graphics chipsets.",0               * Error #9 USED
; *******
    dc.b    "The input RGB format is not recognized.",0                                            * Error #10 USED
    dc.b    "The requested color index is out of the color palette range.",0                       * Error #11 USED
    dc.b    "No current screen detected.",0                                                        * Error #12 USED
    dc.b    "Valid Rainbow FX bank id range is 6-65535.",0                                         * Error #13 USED
    dc.b    "Rainbow FX can only update from hardware line 40 to 255",0                            * Error #14 USED
    dc.b    "No 'Current Screen' available.",0                                                     * Error #15 USED

; ******* SAGA Screen GFX Mode methods error messages

    dc.b    "Requested SAGA C2P Screen resolution is not available.",0                             * Error #16 USED (Saga Screen Mode)
    dc.b    "Requested SAGA C2P Screen depth is not available.",0                                  * Error #17 USED (Saga Screen Mode)
    dc.b    "Unknown SAGA Double Scan mode requested.",0                                           * Error #18 USED (Saga Screen Mode)

; ******* SAGA Screen Creation methods error messages

    dc.b    "Custom Screen ID number is invalid. Valid range is 0-7 (included).",0                 * Error #19 USED (Custom Screens)
    dc.b    "Unknown Custom Screen GFXMODE.",0                                                     * Error #20 USED (Custom Screens)
    dc.b    "Unknown Custom Screen type.",0                                                        * Error #21 USED (Custom Screens)
    dc.b    "Custom screen Pixels Width is smaller than requested resolution pixels width.",0      * Error #22 USED (Custom Screens)
    dc.b    "Custom screen Pixels Height is smaller than requested resolution pixels height.",0    * Error #23 USED (Custom Screens)
    dc.b    "Custom screen Pixels Width is higher than 3x requested resolution pixels width.",0    * Error #24 USED (Custom Screens)
    dc.b    "Custom screen Pixels Height is higher than 3x requested resolution pixels height.",0  * Error #25 USED (Custom Screens)
    dc.b    "Invalid Custom Screen Pixel format.",0                                                * Error #26 USED (Custom Screens)
    dc.b    "Custom screen already exists",0                                                       * Error #27 USED (Custom Screens)
    dc.b    "Custom screen does not exists",0                                                      * Error #28 USED (Custom Screens)

; *******

    dc.b    "Starting color palette position is invalid (Valid range 0-255).", 0                   * Error #5 UNUSED
    dc.b    "Color palette range cannot exceed value 255.", 0                                      * Error #6 UNUSED
    dc.b    "Screen index is invalid. (Valid range 0-12).", 0                                      * Error #7 UNUSED
    dc.b    "Chosen screen color range for copy is out of screen colors range.", 0                 * Error #8 UNUSED
    dc.b    "Invalid amount of colors to copy (Valid range is 1-255 for AGA and 1-31 for ECS).",0  * Error #9 UNUSED
    dc.b    "The IFF CMAP Color palette is corrupted.",0                                          * Error #19 UNUSED
    dc.b    "This bank is not a Color Palette bank.",0                                             * Error #5 UNUSED
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
C_Title    dc.b    "AMOSPro Unity Support extension V "
    VersionUS
    dc.b    0,"$VER: "
    VersionUS
    dc.b    0
    Even


; +++ END OF THE EXTENSION
C_End    dc.w    0
    even


; -----------------------------------------------------------------------
; +++     CONVERTING YOUR EXTENSION TO AMOSPRO V2.0 FORMAT
;
;    An old style extension will perfectly work under AMOSPro V2.0.
;    
;    You may anyway, want to convert you extension to the new format to
; to benefit from the new facilities. To do so:
;
;    - Add the code after the header of the extension
;    - Change the includes to the V2.00 includes
;    - Remove the library pointer list and replace it with the macros
;    - Replace "-1" in the DC.W of the token list by "L_Nul"
;    - For each routine :
;    * Make sure D6/D7 are preserved. If really it is too difficult
;      to preserve D6/D7, just call via a RJsr, L_SaveRegs at the
;      beginning of the routine, and L_LoadRegs at the end. See
;      my code.
;    * Grab the last parameter from D3 and not any more from the
;      pile (simplest way is to push D3 in A3 just before your code)
;    * Replace the label definition of the routine with the new
;      Lib_ Def or Lib_ Par macros. 
;    * Enventually, for function, use "Ret_" macros to return the 
;      parameters.
;



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
