
;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; Additional commands for AGA support
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
    Include    "AgaSupport_lib_Size.s"
    Include    "AgaSupport_lib_Labels.s"

; +++ You must include this file, it will decalre everything for you.
    include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
    Include    "src/AmosProAGA_Version.s"

; *** 2020.09.17 This one for ILBM/IFF CMAP files created by F.C
    Include    "iffIlbm_Equ.s"
    Include    "AgaSupport_Equ.s" ; 2020.10.02 Added for Rainbow structure datas

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

; A usefull macro to find the address of data in the extension''s own 
; datazone (see later)...
Dlea    MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-MB,\2
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
; **************** AGA Color palette support
    dc.w    L_createAGAPalette,L_Nul
    dc.b    "create aga palett","e"+$80,"I0",-1
    dc.w    L_deleteAGAPalette,L_Nul
    dc.b    "delete aga palett","e"+$80,"I0",-1
    dc.w    L_Nul,L_getAgaPeletteExists
    dc.b    "aga palette exis","t"+$80,"00",-1
    dc.w    L_loadAgaPalette,L_Nul
    dc.b    "load aga palett","e"+$80,"I2,0",-1
    dc.w    L_saveAgaPalette,L_Nul
    dc.b    "save aga palett","e"+$80,"I2,0",-1
    dc.w    L_setAgaPalette,L_Nul
    dc.b    "set aga palett","e"+$80,"I0",-1
    dc.w    L_getAgaPalette,L_Nul
    dc.b    "get aga palett","e"+$80,"I0",-1
    dc.w    L_copyScreenToAgaPal1,L_Nul
    dc.b    "!get aga colors from scree","n"+$80,"I0,0,0t0,0",-1
    dc.w    L_copyScreenToAgaPal2,L_Nul
    dc.b    $80,"I0,0,0t0",-1
; **************** AGA Color Palette fading effects
    dc.w    L_fadeAGAstep,L_Nul
    dc.b    "step fade ag","a"+$80,"I0",-1
    dc.w    L_fadeAGA,L_Nul
    dc.b    "fade ag", "a"+$80,"I0",-1
    dc.w    L_fadeAGAtoPalette,L_Nul
    dc.b    "fade to aga palett", "e"+$80,"I0,0",-1
; **************** Basic methods
    dc.w    L_Nul,L_isAgaDetected
    dc.b    "is aga detecte","d"+$80,"0",-1
    dc.w    L_Nul,L_isScreenInHam8Mode
    dc.b    "is ham","8"+$80,"0",-1
    dc.w    L_Nul,L_getHam8Value
    dc.b    "ham","8"+$80,"0",-1
    dc.w    L_Nul,L_getHam6Value
    dc.b    "ham","6"+$80,"0",-1
; **************** Screens color manipulations
    dc.w    L_Nul,L_getRgb24bColorSCR
    dc.b    "get rgb24 colou","r"+$80,"00",-1
    dc.w    L_setRgb24bColorSCR,L_Nul
    dc.b    "set rgb24 colou","r"+$80,"I0,0",-1
; **************** RGB 24 bits Color values manipulation methods
    dc.w    L_Nul,L_retRgb24Color
    dc.b    "rgb2","4"+$80,"00,0,0",-1
    dc.w    L_Nul,L_retRgbR8FromRgb24Color
    dc.b    "rgbr","8"+$80,"00",-1
    dc.w    L_Nul,L_retRgbG8FromRgb24Color
    dc.b    "rgbg","8"+$80,"00",-1
    dc.w    L_Nul,L_retRgbB8FromRgb24Color
    dc.b    "rgbb","8"+$80,"00",-1
; **************** RGB 12 bits Color values manipulation methods
    dc.w    L_Nul,L_retRgb12Color
    dc.b    "rgb1","2"+$80,"00,0,0",-1
    dc.w    L_Nul,L_getRgb12rColor
    dc.b    "rgbr","4"+$80,"00",-1
    dc.w    L_Nul,L_getRgb12gColor
    dc.b    "rgbg","4"+$80,"00",-1
    dc.w    L_Nul,L_getRgb12bColor
    dc.b    "rgbb","4"+$80,"00",-1
; **************** New AGA Rainbow system methods
    dc.w    L_createAGARainbow,L_Nul                           ; Create Aga Rainbow RAINBOWID
    dc.b    "create aga rainbo","w"+$80,"I0,0",-1
    dc.w    L_deleteAGARainbow,L_Nul                           ; Delete Aga Rainbow RAINBOWID
    dc.b    "delete aga rainbo","w"+$80,"I0",-1
    dc.w    L_Nul,L_getAgaRainbowExists                        ; = Aga Rainbow Exist( RAINBOWID )
    dc.b    "aga rainbow exis","t"+$80,"00",-1
    dc.w    L_setAGARainbowColor,L_Nul                         ; Set Aga Rainbow Color RAINBOWID, YLINE, RGB24Color
    dc.b    "set aga rainbow colo","r"+$80,"I0,0,0",-1
    dc.w    L_Nul,L_getAGARainbowColor                         ; = Get Aga Rainbow Color( RAINBOWID, YLINE )
    dc.b    "get aga rainbow colo","r"+$80,"00,0",-1
    dc.w    L_SetRainbowHidden,L_Nul                           ; Hide Aga Rainbow RAINBOWID
    dc.b    "hide aga rainbo","w"+$80,"I0",-1
    dc.w    L_SetRainbowVisible,L_Nul                          ; Show Aga Rainbow RAINBOWID
    dc.b    "show aga rainbo","w"+$80,"I0",-1
    dc.w    L_SetRainbowParams,L_Nul                           ; Set Aga Rainbow RAINBOWID, YPOS, YSHIFT
    dc.b    "set aga rainbo","w"+$80,"I0,0,0",-1
;    dc.w    L_saveAGARainbow,L_Nul                            ; Save Aga Rainbow FILE$, RAINBOWID
;    dc.b    "save aga rainbo","w"+$80,"I2,0",-1
;    dc.w    L_loadAGARainbow,L_Nul                            ; Load Aga Rainbow FILE$, RAINBOWID
;    dc.b    "load aga rainbo","w"+$80,"I2,0",-1






;    dc.w    L_Nul,L_retRgb25Color
;    dc.b    "rgb2","5"+$80,"00,0,0,0",-1
;    dc.w    L_Nul,L_getRgb24rColor
;    dc.b    "rgbr2","5"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb24gColor
;    dc.b    "rgbg2","5"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb24bColor
;    dc.b    "rgbb2","5"+$80,"00",-1
;    dc.w    L_Nul,L_getColour
;    dc.b    "get aga colou","r"+$80,"00,0",-1
;    dc.w    L_Nul,L_getRgb4FromRgb8
;    dc.b    "get rgb4 from rgb","8"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb8FromRgb4
;    dc.b    "get rgb8 from rgb","4"+$80,"00",-1
;    dc.w    L_getScreenAGAPalette,L_Nul
;    dc.b    "get screen aga palett","e"+$80,"I0",-1


;    +++ You must also leave this keyword untouched, just before the zeros.
;    TOKEN_END

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
    Lib_Def    AgaSupport_Cold
    cmp.l    #"APex",d1    Version 1.10 or over?
    bne.s    BadVer

    movem.l    a3-a6,-(sp)
;
; Here I store the address of the extension data zone in the special area
    lea        agaDatas(pc),a3
    move.l     a3,ExtAdr+ExtNb*16(a5)
;
; Here, I store the address of the routine called by DEFAULT, or RUN
    lea        AgaSupportDef(pc),a0
    move.l     a0,ExtAdr+ExtNb*16+4(a5)
;
; Here, the address of the END routine,
    lea        AgaSupportEnd(pc),a0
    move.l     a0,ExtAdr+ExtNb*16+8(a5)
;
; And now the Bank check routine..
    lea        BkCheck(pc),a0
    move.l     a0,ExtAdr+ExtNb*16+12(a5)
; You are not obliged to store something in the above areas, you can leave
; them to zero if no routine is to be called...
    lea        agaVectors(pc),a0
    move.l     a0,T_AgaVect(a5)

; ************* 2020.10.11 Enable the Screen Replacement Methods for AGA
    lea        screensVectors(pc),a0
    move.l     a0,T_ScrnRepVct(a5)

; **************** 2020.10.11 Patch the Copper List sytem to use AGA Colors for registers 032-255 - Start
    Rbsr       L_DetectAGAChipset      ; 2020.10.11 Will makes AGA Chipset Detection being done here.
    EcCall     CopperRelease           ; 2020.10.11 Force the Release of the Copper List
    EcCall     CopperCreate            ; 2020.10.11 Force A New creation of the Copper List
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing

; As you can see, you MUST preserve A3-A6, and return in D0 the 
; Number of the extension if everything went allright. If an error has
; occured (no more memory, no file found etc...), return -1 in D0 and
; AMOS will refuse to start.
    movem.l    (sp)+,a3-a6
    moveq    #ExtNb,d0    * NO ERRORS
    move.w    #$0110,d1    * Version d'ecriture
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
AgaSupportDef:
    Dload a3
    ; Put your setup needs here
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
AgaSupportEnd:
    Dload    a3
    ; Put your close needs here

    ; ******************************** Delete all AGA Color palette from memory
    move.l     #0,d3
    lea        T_AgaColorPals(a5),a2
    move.l     #agaPalCnt-1,d7
.loop:
    move.l     d7,d3
    lsl.l      #2,d3
    move.l     (a2,d3.w),d0
    tst.l      d0
    beq.s      .next
    Move.l     d0,a1
    Move.l     #agaColorPaletteSize,d0 ; 776 bytes = "CMAP" (4 bytes) + "CmapLength" (2 bytes) + ( 256 colors * 3 bytes long for each ) + "-1" ( 2 Bytes )
    SyCall     MemFree
    Clr.l      (a2,d3.w)
.next:
    dbra       d7,.loop
    ; ******************************** Delete the Iff/Ilbm CMAP file is not deleted from memory.
    Move.l     T_AgaCMAPColorFile(a5),d0
    tst.l      d0
    beq.s      .whatsNext
    move.l     d0,a1
    move.l     #aga_ILBM_SIZE,d0
    SyCall     MemFree
    clr.l      T_AgaCMAPColorFile(a5)
.whatsNext:
    ; ******************************** Delete all AGA Rainbow buffers from memory
    move.l     #agaRainCnt-1,d4        ; Used for delete loop
    lea        T_AgaRainbows(a5),a2    ; A2 Pointer to the 1st AGA Rainbow    
dLoop:
    move.l     d4,d3                   ; D3 = D4
    lsl.l      #2,d3                   ; D3 = D4 * 2
    move.l     (a2,d3.w),d0
    cmp.l      #0,d0                   ; No Aga rainbow in this slot ? -> No rain Jump ctn.
    beq.s      ctn
    move.l     #0,(a2,d3.w)            ; Clear pointer
    move.l     d0,a1
    Move.l     4(a1),d0                ; Data buffer Size
    add.l      #8,d0                   ; Add "AMRB" + Size.l to the whole buffer size
    SyCall     MemFree
ctn:
    dbra       d4,dLoop

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

agaDatas:
; The size of an AGA Color palette containing : "CMAP"( .l ) = 4 , CMAPSize( .l ) = 4, up to 256 RGB24 Colors ( 256 * 3.b ) = 768, $FFFF = 2 ; Total = 778 -> Push 780
agaColorPaletteSize    equ     780
agaCopper:     dc.w    0

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

screensVectors:
    ; **************** Amos Professional Copper List System ****************
    Rbra       L_RestartWithAGACopperList      ;  0 Amos.library "CpInit" replacement.
    Rbra       L_InsertSpritesInCopperList     ;  1 Amos.library "HsCop" replacement.
    Rbra       L_InsertScreenInCopper          ;  2 Amos.library "EcCopHo" replacement.
    Rbra       L_ForceFullCopperRefresh        ;  3 Amos.library "EcForceCop" replacement.
    Rbra       L_CopperRefresh                 ;  4 Amos.Library "EcCopper" replacement.
    Rbra       L_EndOfScreenCopper             ;  5 Amos.library "EcCopBa" replacement.
    Rbra       L_CopperOnOff                   ;  6 Amos.library "TCopOn" replacement.
    Rbra       L_CopperSwap                    ;  7 Amos.library "TCopSw" replacement
    Rbra       L_CopperSwapInternal            ;  8 Amos.library "TCpSw" replacement
    Rbra       L_NullFct                       ;  9
    Rbra       L_NullFct                       ; 10
    Rbra       L_NullFct                       ; 11
    Rbra       L_NullFct                       ; 12
    Rbra       L_NullFct                       ; 13
    Rbra       L_NullFct                       ; 14
    Rbra       L_NullFct                       ; 15
    Rbra       L_NullFct                       ; 16
    Rbra       L_NullFct                       ; 17
    Rbra       L_NullFct                       ; 18
    Rbra       L_NullFct                       ; 19
    ; **************** Amos Professional Screens System ****************
    Rbra       L_ScreenOpen                    ; 20 Amos.library "EcCree" replacement.
    Rbra       L_NullFct                       ; 21 Amos.library "EcDel" replacement.
    Rbra       L_NullFct                       ; 22 Amos.library "EcDual" replacement.
    Rbra       L_SetColourRGB12                ; 23 Amos.library "EcSCol" replacement.
    Rbra       L_NullFct                       ; 24
    Rbra       L_NullFct                       ; 25
    Rbra       L_NullFct                       ; 26
    Rbra       L_NullFct                       ; 27
    Rbra       L_NullFct                       ; 28
    Rbra       L_NullFct                       ; 29
    Rbra       L_NullFct                       ; 31
    Rbra       L_NullFct                       ; 32

;
; *****************************************************************************************************************************
; *************************************************************
; * Area Name : agaVectors                                    *
; *-----------------------------------------------------------*
; * Description : This area contains the list of methods that *
; * can be called directly by any other Amos Professional lib *
; * or directly by the AmosProAGA.library itself.             *
; *                                                           *
; *************************************************************
agaVectors:
    Rbra       L_AGAfade1                  ; Fade to Black
    Rbra       L_AGAfade2                  ; Fade to specific color palette
    Rbra       L_SHam8BPLS                 ; Method to change bitplanes order in HAM8 mode to keep Amos professional graphics drawing working.
    Rbra       L_SPalAGA_ScreenA4          ; previously called EcSPalAGAa4
    Rbra       L_SPalAGA_CurrentScreen     ; previously called EcSPalAGA
    Rbra       L_SPalAGA_ScreenA0          ; previously called EcForceFullAGAPalette_ScreenA0
    Rbra       L_SColAga24Bits             ; previously called EcSColAga24Bits
    Rbra       L_UpdateAGAColorsInCopper   ; Push the Global AGA Color palette stored to the copper list.
    Rbra       L_getAGAPaletteColourRGB12  ; Used by AmosProAGA.library/SetColour to get RGB12 High bits for colors 032-255
    Rbra       L_UpdateAGAColorsInCopper   ; Insert AGA Color palette inside
    Rbra       L_InsertSpritesInCopperList ; Insert Sprites in Copper List

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

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_DetectAGAChipset                          *
; *-----------------------------------------------------------*
; * Description : This method will detect if AGA chipset is   *
; *               available or not. It set T_isAga(a5) data to*
; *               fit the detected result.                    *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    Lib_Def    DetectAGAChipset
DetectAGAChipset:
    movem.l    a0/d1-d3,-(sp)              ; 2020.08.10 Save registers before doing AGA Checking : Fix the AMOS Switcher AMOS/WB
    moveq     #30,d3             ; Loop amoun()
    lea     $dff07c,a0         ; lea the register to check content
    move.w     (a0),d1         ; D1 = read register
    and.w     #$FF,d1         ; D1 = filtered
dcLoop:
    move.w     (a0),d2         ; D2 = Read Register
    and.w     #$FF,d2         ; D2 = filtered
    cmp.b     d1,d2             ; Compare D1 read & D2 Read
    bne.s     cEcs             ; Not equal -> Bus Garbage -> ECS
    dbra     d3,dcLoop         ; Loop until d3 = -1
    or.b     #$F0,d1         ; D1 & $F0
    cmp.b     #$F8,d1         ; if D1 =$F8 -> AGA
    bne.s     cEcs             ; Else -> ECS
    move.w     #1,T_isAga(a5)
    movem.l    (sp)+,a0/d1-d3
    rts
cEcs:
    move.w     #0,T_isAga(a5)
    movem.l    (sp)+,a0/d1-d3              ; 2020.08.10 Restore registers after AGA Checking completed : Fix the AMOS Switcher AMOS/WB
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : AGAfade1                                    *
; *-----------------------------------------------------------*
; * Description : This method is called by the Amos Professio-*
; * =nal VBL Interrupt AmosProAGA.library/FadeI method to do a*
; * simple Fade to black on the whole 256 colors available    *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    Lib_Def    AGAfade1
AGAfade1:
    movem.l    d0-d7/a0-a2,-(sp)       ; Save Regsxm
    lea        T_FadeCol(a5),a0        ; A0 = List of colors to update
    move.l     T_FadePal(a5),a1        ; A1 = Screen Palette (used to update color palette) = EcPal(T_FadeScreen(a5))
    move.w     T_FadeNb(a5),d0         ; D0 = Amount of colors in the list.
    move.w     T_FadeStep(a5),d2       ; D2 = Step to fade color
    moveq      #0,d1                   ; D1 = Counter for colour amount that will be updated during this pass.
fadeMainLoop:
; ***** Check if the current color reach the fade or must be updated
    tst.b      (a0)+
    bne.s      updateColor             ; If (a0).b =/= 0 then updateColor
; ******** (a0) = 0 mean this color reached the limit of fading, no update, next color please.
    add.l      #3,a0                   ; Next Color
    add.w      #2,a1                   ; Jump this color register in EcPal RGB12H & EcPalL RGB12L screen color palette 
    bra.s      nextColor               ; Jump -> nextColor
updateColor:
    moveq      #2,d7                   ; Counter to handle R,G then B and go to next color
    clr.l      d5                      ; D5 will store RGB12 High bits
    clr.l      d6                      ; D6 will store RGB12 Low bits
; ******** Handle R8 Color component in D3, Save : D3 = ....Rh.. and D4 = ....Rl..
rgbFadeLoop:
    moveq      #0,d3
    move.b     (a0)+,d3                ; D3 = R8/G8 or B8 Color Component
    and.l      #$FF,d3
    tst.b      d3
    beq.s      continueFadeAGA         ; if Color component = 0, we do not increase counter
    addq       #1,d1                   ; Increase updated colours counter
    sub.w      d2,d3                   ; D3 = D3 + D2 = Fade de la couleur vers le noir ou le blanc ********************************
    bpl.s      continueFadeAGA         ; If D3 > -1 -> Jump continueFadeAGA
    moveq      #0,d3
continueFadeAGA:
    move.b     d3,-1(a0)               ; Save the new color value in the Fade color list
    move.l     d3,d4                   ; D3 = D4 = R8
    lsr.w      #4,d3                   ; D3 = ......Rh or ......Gh or ......Bh
    and.w      #$F,d4                  ; D4 = ......Rl or ......Gl or ......Bl
    and.w      #$F,d3
; ******** Shift D6 & D7 by 4 bytes to insert the R4,GB or B4 component
    lsl.w      #4,d5                   ; D5 = ???????? = ??????..
    lsl.w      #4,d6                   ; D6 = ???????? = ??????..
    or.w       d3,d5                   ; D5 = ??????Ch = Store the current High bits component inserted after the previous one
    or.w       d4,d6                   ; D6 = ??????Cl = sdtore the current low bit component inserted after the previous one
    dbra d7,rgbFadeLoop                ; Decrease D7 and continue color extraction.
; ******** Now, we update the screen color palette
    move.w     d6,EcPalL-EcPal(a1)     ; Save RGB12L to EcPalL color palette
    move.w     d5,(a1)+                ; Save RGB12H to EcPal color palette
; Now we continue the loop or finish it.
nextColor:
    tst.w      (a0)
    bmi        listOver
    dbra       d0,fadeMainLoop
; Now that the full color palette was updated, we finish the job
listOver:
    add.w      #2,d1
    divu       #3,d1
    move.w     d1,T_FadeFlag(a5)       ; Update Fade Flag with current amount of colours that were updated
; ******** Now we will push the colors register 032-255 from Screen to T_globAgaPal
    move.l     T_FadeScreen(a5),a0
    lea        EcScreenAGAPal(a0),a1   ; A1 = Color 32 High bits
    lea        T_globAgaPal(a5),a2     ; A2 = Color 32 High Bits Global Aga Palette
    move.l     #223,d0                 ; 224 Colors to copy in the T_globAgaPal(L)
llp1:
    move.w     EcScreenAGAPalL-EcScreenAGAPal(a1),T_globAgaPalL-T_globAgaPal(a2) ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    move.w     (a1)+,(a2)+         ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    dbra       d0,llp1         
;  2020.09.29 The screen color palette update is called directly inside the AmosProAGA.library.
; Leave clean
    movem.l    (sp)+,d0-d7/a0-a2       ; LoadRegs.
    rts
; ************************************* 2020.09.16 New method to handle AGA color palette fading system - End

;
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : AGAfade2                                    *
; *-----------------------------------------------------------*
; * Description : This method is called by the Amos Professio-*
; * =nal VBL Interrupt AmosProAGA.library/FadeI method to do a*
; * simple Fade to existing AGA Color Palette on the whole 256*
; * colors available                                          *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
; ************************************* 2020.09.29 New method to fade from current color used to a chosen AGA Color palette - Start
    Lib_Def    AGAfade2
AGAfade2: 
    movem.l    d0-d7/a0-a2,-(sp)       ; Save Regsxm
    lea        T_FadeCol(a5),a0        ; A0 = List of colors to update
    move.l     T_FadePal(a5),a1        ; A1 = Screen Palette (used to update color palette) = EcPal(T_FadeScreen(a5))
    move.w     T_FadeNb(a5),d0         ; D0 = Amount of colors in the list.
    move.w     T_FadeStep(a5),d2       ; D2 = Step to fade color
    and.l      #$FF,d2
    move.l     T_NewPalette(a5),a2     ; A2 = New CMAP Color Palette
    moveq      #0,d1
fadeMainLoop2:
    add.l      #1,a0
    moveq      #2,d7                   ; Counter to handle R,G then B and go to next color
    clr.l      d5                      ; D5 will store RGB12 High bits
    clr.l      d6                      ; D6 will store RGB12 Low bits
; ******** Handle R8 Color component in D3, Save : D3 = ....Rh.. and D4 = ....Rl..
rgbFadeLoop2:
    moveq      #0,d3
    moveq      #0,d4
    move.b     (a0)+,d3                ; D3 = R8/G8 or B8 Color Component
    move.b     (a2)+,d4                ; D1 = R8/G8 or B8 Color component for color to reach
    and.l      #$FF,d3
    and.l      #$FF,d4
    cmp.w      d4,d3                   ; is D3 = R8/G8 or B8 Color Component ? 
    beq.s      noUpdate                ; Yes -> noUpdate
    bgt.s      lower                   ; D3 > D4 -> Decrease d3 JUMP lower
upper:                                 ; D3 < D4 -> Increase d3 Next Line
    add.w      d2,d3                   ; Increase D3
    cmp.w      d4,d3                   ; is D3 > D4 ?
    bgt.s      forceEqual              ; Yes Force D3 = D4 -> JUMP forceEqual
    bra.s      updtColor
lower:
    sub.w      d2,d3                   ; Decrease D3
    cmp.w      d4,d3                   ; is D3 < D4 ?
    bge.s      updtColor               ; NO -> JUMP update Color
                                       ; Yes Force D3 = D4 -> Next Line
forceEqual:
    move.w     d4,d3
updtColor:
    move.b     d3,-1(a0)               ; Update the color in the Fade color list
    addq       #1,d1
noUpdate:
    move.l     d3,d4                   ; D3 = D4 = R8
    lsr.w      #4,d3                   ; D3 = ......Rh or ......Gh or ......Bh
    and.w      #$F,d4                  ; D4 = ......Rl or ......Gl or ......Bl
    and.w      #$F,d3
; ******** Shift D6 & D7 by 4 bytes to insert the R4,GB or B4 component
    lsl.w      #4,d5                   ; D5 = ???????? = ??????..
    lsl.w      #4,d6                   ; D6 = ???????? = ??????..
    or.w       d3,d5                   ; D5 = ??????Ch = Store the current High bits component inserted after the previous one
    or.w       d4,d6                   ; D6 = ??????Cl = sdtore the current low bit component inserted after the previous one
    dbra       d7,rgbFadeLoop2         ; Decrease D7 and continue color extraction.
; ******** Now, we update the screen color palette
    move.w     d6,EcPalL-EcPal(a1)     ; Save RGB12L to EcPalL color palette
    move.w     d5,(a1)+                ; Save RGB12H to EcPal color palette
; Now we continue the loop or finish it.
    tst.w      (a0)
    bmi        listOver2
    dbra       d0,fadeMainLoop2
; Now that the full color palette was updated, we finish the job
listOver2:
    add.w      #2,d1
    divu       #3,d1
    move.w     d1,T_FadeFlag(a5)       ; Update Fade Flag with current amount of colours that were updated
; ******** Now we will push the colors register 032-255 from Screen to T_globAgaPal
    move.l     T_FadeScreen(a5),a0
    lea        EcScreenAGAPal(a0),a1   ; A1 = Color 32 High bits
    lea        T_globAgaPal(a5),a2     ; A2 = Color 32 High Bits Global Aga Palette
    move.l     #223,d0                 ; 224 Colors to copy in the T_globAgaPal(L)
llp1b:
    move.w     EcScreenAGAPalL-EcScreenAGAPal(a1),T_globAgaPalL-T_globAgaPal(a2) ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    move.w     (a1)+,(a2)+         ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    dbra       d0,llp1b
;    2020.09.29 The screen color palette update is called directly inside the AmosProAGA.library.
; Leave clean
    movem.l    (sp)+,d0-d7/a0-a2       ; LoadRegs.
    rts
; ************************************* 2020.09.29 New method to fade from current color used to a chosen AGA Color palette - End

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcSHam8BPLS                                 *
; *-----------------------------------------------------------*
; * Description : It is a trick that only modify the way gra- *
; *        phics are drawn. As Ham8 uses lower bitplanes bits *
; *        (bpls0-1) to control color shifting instead of hig-*
; *        -her bitlanes bits in ham 6 (Bpls4-5). I had to    *
; *        find a way to makes AMOS being able to draw on bit-*
; *        -map 2 to 7 instead of 0 to 5 when HAM8 mode is    *
; *        enabled. To do this, I simply roll bm_Planes by 2  *
; *        bitplanes regarding to EcCurrent content. It will  *
; *        makes bitplanes order 0-1-2-3-4-5-6-7 be changed to*
; *        2-3-4-5-6-7-0-1. With this, graphics operations on *
; *        colors 00-63 will be done on bitplanes 2 to 7 ins- *
; *        -tead of 0 & 1. and bitplanes 0&1 remain the cont- *
; *        -rol ones
; *                                                           *
; * Parameters : T_cScreen(a5)                                *
; *              Ham8Mode(T_cScreen(a5)) must be set to 1     *
; *                                                           *
; * Return Value :            *
; *************************************************************
; ************************************* 2020.07.31 Update to Add HAM8 support - START
    Lib_Def    SHam8BPLS
SHam8BPLS:
    movem.l    d3-d4/a0-a4,-(sp)       ; Save registers
    move.l     T_cScreen(a5),a4        ; Load current screen from T_cScreen(a5)
    tst.w      Ham8Mode(a4)            ; Load HAM8 mode flag stored in the screen datas structure
    beq.s      noCopy                  ; YES -> Jump to noCopy
    lea        EcPhysic(a4),a0         ; A4 = 1st physical bitplane in the list
    lea        EcCurrent(a4),a1        ; A1 = Screen Currently used bitplanes.
    move.l     Ec_BitMap(a4),a3        ; A3 = Screen Bitmap Structure pointer
    lea        bm_Planes(a3),a3        ; A3 = 1st bitplane pointer in the BitMap Structure
    Moveq      #8,d3                   ; Source start at BPL2 ( The objective is to make Bitplanes 0 and 1 become 6 and 7 to makes AMOS Being able to draw graphics with correct colors)
    Moveq      #0,d4                   ; Target start at BPL0 ( Because HAM6 used bitplanes 4 a 5 for controls datas and HAM8 used bitplanes 0 and 1 for this)
cpyBPL2:
    Move.l     (a0,d3.w),(a1,d4.w)     ; Copy BPL shifting/Rolling 2 BPLs to the left of the list *UPDATE EcCurrent(a4) bitplanes*
    Move.l     (a0,d3.w),(a3,d4.w)     ; Copy BPL shifting/Rolling 2 BPLs to the left of the list *UPDATE Ec_BitMap(a4).bm_Planes bitplanes*
    add.w      #4,d3                   ; Next Source BPLx
    and.w      #31,d3                  ; Makes > 31 become value in range 00-31
    Add.w      #4,d4                   ; Next Target BPLx
    cmp.w      #32,d4                  ; Ensure D4 will be from 00-28 to go to BPL0 with BPL7 is done
    blt.s      cpyBPL2
noCopy:
    movem.l    (sp)+,d3-d4/a0-a4       ; Restore register before leaving this method
    rts
; ************************************* 2020.07.31 Update to Add HAM8 support - END

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGA_ScreenA4                            *
; *-----------------------------------------------------------*
; * Description : This method will call the SPalAGAFull method*
; *               to update the copper list color palette of  *
; *               screen structure provided in a4. It will al-*
; *               -so refresh the global aga color palette    *
; *               with AGA color palette provided in a1       *
; *                                                           *
; * Parameters : A4 = Screen Structure Pointer                *
; *              A1 = Aga Color Palette, AGAP Format supported*
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    SPalAGA_ScreenA4
SPalAGA_ScreenA4:
    movem.l    a0,-(sp)
    move.l     a4,a0
    Rbra       L_SPalAGAFull

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGA_CurrentScreen                       *
; *-----------------------------------------------------------*
; * Description : This method will refresh the whole copper   *
; *               list color palette (including global aga)   *
; *               with the color palette provided into a1     *
; *                                                           *
; * Parameters : A1 = Aga Color Palette, AGAP Format supported*
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    Lib_Def    SPalAGA_CurrentScreen
SPalAGA_CurrentScreen:
    movem.l    a0,-(sp)
    move.l     T_EcCourant(a5),a0      ; A0 = Current Screen Structure pointer
    Rbra       L_SPalAGAFull

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGA_ScreenA0                                            *
; *-----------------------------------------------------------*
; * Description : This method will call the SPalAGAFull method*
; *               to update the copper list color palette of  *
; *               screen structure provided in a0. It will al-*
; *               -so refresh the global aga color palette    *
; *               with the screen AGA color palette           *
; *                                                           *
; * Parameters : A0 = Screen Structure Pointer                *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    SPalAGA_ScreenA0
SPalAGA_ScreenA0:
    ; A0 Must contain the screen to refresh for full
    movem.l    a0,-(sp)
    lea.l      AGAPMode(a0),a1
    Rbra       L_SPalAGAFull

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGAFull                                 *
; *-----------------------------------------------------------*
; * Description : This method will update the whole color pa- *
; *               -lette of the screen structure provided in  *
; *               a0 and will also refresh the global aga co- *
; *               -lor palette with the color palette provi- *
; *               -ded in register A1 (input)                 *
; *                                                           *
; * Parameters : A0 = Screen Structure Pointer                *
; *              A1 = Aga Color Palette, AGAP Format supported*
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    SPalAGAFull
SPalAGAFull:
    move.l     a0,T_CurScreen(a5)      ; To use instead of T_EcCourant(a5)
    movem.l    a1-a4/d0-d6,-(sp)       ; 2020.08.25 Updated to handle D6 for 2nd RGB color values

; ************************************* 2020.05.15 Update for AGAP mode *
    move.l     (a1),d5
    cmp.l      #"AGAP",d5              ; Is the "AGAP" header found ?
    beq.s      AGAPaletteUpd           ; Colour Count <= 32
    moveq      #32,d5                  ; D5 = Default 32 colors
    bra.s      PalUpdCont
AGAPaletteUpd:
    move.w     4(a1),d5                ; D5 = Colour Count
    And.l      #$FFFF,d5
    add.l      #6,a1                   ; A1 = Pointer to 1st color value
PalUpdCont:
; ************************************* 2020.05.15 Update for AGAP mode *
    move.w     EcNumber(a0),d2
    lsl.l      #7,d2                   ; D2 = Screen Nombre * 128 ( 128 bytes used by each screen for Copper MArks)
    lea        T_CopMark(a5),a2        ; A2 = 1st copper mark
    add.w      d2,a2                   ; A2 = Screen copper mark for current screen
    move.l     a2,d2                   ; D2 = Save of Screen copper mark
    lea        EcPal(a0),a0            ; A0 = Screen color palette pointer
    moveq      #0,d0
    moveq      #0,d1
    moveq      #31,d4                  ; 32 colors to update (32-1)
* Boucle de pokage
EcSP1b:
    move.w     EcPalL-EcPal(a1),d6     ; 2020.08.25 added : D6 = 2nd RGB12 color datas
    move.w     (a1)+,d1                ; D1 = 1st RGB12 color datas
    bmi.s      EcSP3b
    and.w      #$FFF,d6                ; 2020.08.25 added : D6 filtered to RGB12 R4G4B4
    and.w      #$FFF,d1                ; D1 filtered to RGB12 R4G4B4
* Poke dans la table
    move.w     d6,EcPalL-EcPal(a0)     ; 2020.08.25 Insert 2nd RGB12 Color Datas into EcPalL datas storage
    move.w     d1,(a0)
* Poke dans le copper
    move.l     d2,a2                   ; A2 = Slot offset 0 from Screen Copper Mark 1nd data slot
    cmp.w      #PalMax*4,d0            ; Is D0 > PalMax (=16) ?
    bcs.s      EcSP2b                  ; No -> Jump EcSP2b
    lea        64(a2),a2               ; A2 = Slot offset 64 from Screen Copper Mark 2nd data slot
EcSP2b:
    move.l     (a2)+,d3                ; d3 = Screen Copper Mark for color palette
    beq.s      EcSP3b                  ; D3 = NULL (=0) ? Jump EcSP3b
    move.l     d3,a3                   ; A3 = D3 = Pointer for 1st color palette index.
    move.w     d1,2(a3,d0.w)           ; Update 1st RGB12 color register in copper list
    move.w     d6,2+68(a3,d0.w)        ; Update 2nd RGB12 color register in copper list ( ( 16 colors +  BplCon3 ) * ( 2 bytes reg + 2 bytes datas ) ) = 68 )
    bra.s      EcSP2b
EcSP3b:
    addq.l     #2,a0
    addq.w     #4,d0
    dbra       d4,EcSP1b
; ************************************************************* 2020.08.25 Update to handle RGB24 Copper list palette update - END
; ************************************* 2020.05.15 Update for AGAP mode *
    cmp.w      #32,d5                  ; Do we have more than 32 colors to update ?
    ble.s      uclAGAEnd               ; No AGA update at all
    sub.w      #32,d5                  ; D5 = Color count - ECS color updated. So colors 032-0255 -> 000-223 as datas contains only 224 colors for AGA ( colors 000-031 are setup in screen themselves)
    sub.w      #1,d5                   ; 2020.09.04 D5 = Max 223 instead of 224 / Fix the palette color flickering
; ************************************* 2020.05.15 Update for AGAP mode *
    And.l      #$FFF,d5
; ********************** 2020.08.14 Update to Handle Update of up to 256 RGB24 colors in the copper list - START
; ********************** 2019.11.17 Update to also update the AGA color palette registers from 32-255 - START
    Move.l     T_AgaColor1(a5),a0      ; A0 = Pointer to the beginning of the current physical copper list.
    add.l      #6,a0                   ; 2020.08.13 Add #2 to point to content of 1st color register ( 0.l CopWait, 4.l SetColorGroup, 8.w 1st color Register, 10.w 1st color data)
    Move.l     T_AgaColor2(a5),a2      ; A2 = Pointer to the beginning of the current logic copper list
    add.l      #6,a2                   ; 2020.08.13 Add #2 to point to content of 1st color register ( 0.l CopWait, 4.l SetColorGroup, 8.w 1st color Register, 10.w 1st color data)
    lea        T_globAgaPal(a5),a3     ; A3 = Storage for AGA colors from 32 to 255 ( 224 registers )
    move.l     T_CurScreen(a5),a4      ; A4 = Current Screen Structure pointer
    Lea        EcScreenAGAPal(a4),a4
    Move.l     d5,d0                   ; D0 = Start at index 223 (-1 = end of copy)
    Clr.l      d1                      ; D1 = Register to check all 32 colors blocks
    bsr        uclAGA1                 ; Call method to update Copper List
    add.l      #2,a1                   ; Separator between 2 set of RGB12 color components.
; ************************************************************* 2020.08.13 Store Low bits in copper list
    Move.l     T_AgaColor1L(a5),a0     ; A0 = Pointer to the beginning of the current physical copper list.
    add.l      #6,a0                   ; 2020.08.13 Add #2 to point to content of 1st color register
    Move.l     T_AgaColor2L(a5),a2     ; A2 = Pointer to the beginning of the current logic copper list
    add.l      #6,a2                   ; 2020.08.13 Add #2 to point to content of 1st color register
    lea        T_globAgaPalL(a5),a3    ; A3 = Storage for AGA colors from 32 to 255 ( 224 registers )
    move.l     T_CurScreen(a5),a4      ; A4 = Current Screen Structure pointer
    Lea        EcScreenAGAPalL(a4),a4
    move.l     d5,d0                   ; D0 = Start at index 223 (-1 = end of copy)
    Clr.l      d1                      ; D1 = Register to check all 32 colors blocks
    bsr        uclAGA1                 ; Call method to update copper list
; ********************** 2019.11.17 End of Update to also update the AGA color palette registers from 32-255 - END
 uclAGAEnd:
    movem.l    (sp)+,a1-a4/d0-d6       ; 2020.08.25 Updated to handle D6 for 2nd RGB color values
    movem.l    (sp)+,a0
    moveq    #0,d0
    rts

; * Small method that inject all colors (all colors High bits OR all colors Low Bits at one time-call)
uclAGA1:
    Move.w     (a1)+,d2                ; Continue copy of the A1 palette
    Move.w     d2,(a3)+                ; Save the A1 Palette in global Aga Palette             -> T_globAgaPal(L) 
    move.w     d2,(a4)+                ; Save the A1 Palette in the current screen AGA Palette -> EcScreenAGAPal(L)
    Move.w     d2,(a0)                 ; Update Physic Copper                                  -> T_AgaColor1(L)
    Move.w     d2,(a2)                 ; Update Logic Copper                                   -> T_AgaColor2(L)
    Add.l      #4,a0                   ; A1 jump to next color register                        -> T_AgaColor1(L) + 4 = Next Color Register
    Add.l      #4,a2                   ; A2 jump to next color register                        -> T_AgaColor2(L) + 4 = Next Color Register
    sub.w      #1,d0                   ; D0 decrease copy counter
    cmp.w      #0,d0
    blt.s      uclAGAEndCPY
    add.w      #1,d1
    cmp.w      #32,d1
    blt.s      uclAGA1
    clr.l      d1
    add.l      #4,a0                   ; A0 was on a color group switcher -> Jump to next color register
    add.l      #4,a2                   ; A2 was on a color group switcher -> Jump to next color register
    bra.s      uclAGA1
uclAGAEndCPY:
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SColAga24Bits                               *
; *-----------------------------------------------------------*
; * Description : This method update the color D1 of the cur- *
; *               -rent screen with 24 bits RGB values separa-*
; *               ted in 2 registers to fit High/Low bits de- *
; *               -finition inside Copper list color registers*
; *                                                           *
; * Parameters : D1 = Color Register 032-255 tp Update        *
; *              D2 = RGB12 High bits for the D1 color        *
; *              D4 = RGB12 Low bits for the D1 color         *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    Lib_Def    SColAga24Bits
SColAga24Bits:
    Move.l     T_EcCourant(a5),a0
    and.l      #255,d1                 ; Remove 32 colours limit (original = #31) for AGA support with 256 colours limit
    sub.l      #32,d1                  ; D1 Color palette shifted with -32 to be index 00-223 in globAgaPal ( 224 registers )
    move.l     d1,d3                   ; D3 = True Color 032-255 indexed at 000-223
    lsl.l      #1,d3                   ; D3 = Color Index * 2 ( .w pointer )
    ; ****** Save Aga Color in the global globAgaPal register
    lea        T_globAgaPal(a5),a1     ; 2019.11.28 Storage for AGA colors from 32 to 255 ( 224 registers )
    Lea        EcScreenAGAPal(a0),a2   ; Storage for current Screen AGA color palette from 32 to 255 ( 224 registers )
    move.w     d2,(a1,d3.w)            ; Save D2 color in his AgaPal(ette) color register
    move.w     d2,(a2,d3.w)            ; Save D2 Color in the current Screen AGA Palette color register

; ************************************************************* 2020.08.31 Update to handle full RGB24 color update - Start
    lea        T_globAgaPalL(a5),a1    ; 2019.11.28 Storage for AGA colors from 32 to 255 ( 224 registers )
    Lea        EcScreenAGAPalL(a0),a2  ; Storage for current Screen AGA color palette from 32 to 255 ( 224 registers )
    move.w     d4,(a1,d3.w)            ; Save D2 color in his AgaPal(ette) color register
    move.w     d4,(a2,d3.w)            ; Save D2 Color in the current Screen AGA Palette color register
; ************************************************************* 2020.08.31 Update to handle full RGB24 color update - End

    Move.l     d1,d3                   ; D3 = true 32-255 Color Indexed at 0-224
    cmp.w      #0,d3
    beq        noDiv
    divu       #32,d3                  ; D3 = Palette groupe ID ( from 0 - 6, in reality color range 32-255 cos copper contains only colors 32-255 )
noDiv:
    Mulu       #132,d3                 ; D3 = Shift to reach the correct color group in Copper List
    and.l      #$1F,d1                 ; D1 = Color register driven in a 00-31 range.
    Lsl.l      #2,d1                   ; D1 = Color ID * 4 as each color uses .w-> Register + .w-> Color Value
    add.l      d3,d1
    add.l      #6,d1
    move.l     T_AgaColor1(a5),a1
    move.l     T_AgaColor2(a5),a2
    Move.w     d2,(a1,d1.w)            ; Update color in the copper list.
    Move.w     d2,(a2,d1.w)            ; Update color in the copper list.
; ************************************************************* 2020.08.31 Update to handle lower bits in full RGB24 mode or RGB12 copy mode - Start
    move.l     T_AgaColor1L(a5),a1
    move.l     T_AgaColor2L(a5),a2
    Move.w     d4,(a1,d1.w)            ; Update color in the copper list.
    Move.w     d4,(a2,d1.w)            ; Update color in the copper list.
; ************************************************************* 2020.08.31 Update to handle lower bits in full RGB24 mode or RGB12 copy mode - End
    ; ****** End with no error.
    moveq      #0,d0
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : UpdateAGAColorsInCopper                     *
; *-----------------------------------------------------------*
; * Description : This method push the T_globAgaPal color da- *
; *               -tas to the copper list to update colors re-*
; *               -gisters from 032 to 255                    *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
; ******************************************** 2019.24.11 New method to update the whole AGA color palette in copper list
    Lib_Def    UpdateAGAColorsInCopper
    movem.l    d6-d7/a0-a4,-(sp)
    Move.l     T_AgaColor1(a5),a0      ; A0 = Aga Copper 0 Colors 032-255 High Bits 
    Move.l     T_AgaColor2(a5),a1      ; A1 = Aga Copper 1 Colors 032-255 High Bits 
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    Move.l     T_AgaColor1L(a5),a3     ; A3 = Aga Copper 0 Colors 032-255 Low Bits 
    Move.l     T_AgaColor2L(a5),a4     ; A4 = Aga Copper 1 Colors 032-255 Low Bits 
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - END
    ; ************ Setup inital values for the AGA palette adding to Copper list
    Move.l     #7,d7                   ; D7 = Aga Color palette contains 224 colors.
    lea        T_globAgaPal(a5),a2     ; A2 = First color of AGA palette ( =32 ) of the curent screen (a0)
insert32cLoop2:
    sub.w      #1,d7
    bmi        insertIsOver2           ; Stop when we have reached 256 colors.
    Addq.l     #4,a0                   ; Jump to 1st color register definition COPPER 0 HIGH BITS
    Addq.l     #4,a1                   ; Jump to 1st color register definition COPPER 1 HIGH BITS
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    addq.l     #4,a3                   ; Jump to 1st color register definition COPPER 0 LOW BITS
    addq.l     #4,a4                   ; Jump to 1st color register definition COPPER 1 LOW BITS
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - END
    ; * setup for the Copy of the 32 colors registers
    move.l     #31,d6                  ; D5 = Color00 register
loopCopy2:
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    add.w      #2,a0                   ; A0 = Color Register Data HIGH Bits Copper 0
    move.w     (a2),(a0)+              ; Copy the AgaPal High Bits inside the CopperList 0
    Add.w      #2,a1                   ; Color register
    move.w     (a2),(a1)+              ; Copy the AgaPal High Bits inside the CopperList 1
    add.w      #2,a3                   ; Color register
    move.w     T_globAgaPalL-T_globAgaPal(a2),(a3)+    ; Copy the AgaPal Low Bits inside the CopperList 0
    Add.w      #2,a4                   ; Color register
    move.w     T_globAgaPalL-T_globAgaPal(a2),(a4)+   ; Copy the AgaPal Low Bitsinside the CopperList 1
    addq.l     #2,a2                   ; A2 = Next color data
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    sub.w      #1,d6
    bmi        insert32cLoop2          ; Once 32 colors registers were copied, we go back at the beginning of the loop for the next group of colours.
    bra        loopCopy2               ; If color <32 then continue the copy
insertIsOver2:
    movem.l    (sp)+,d6-d7/a0-a4
; ******************************************** 2019.24.11 New method to update the whole AGA color palette in copper list
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : getAGAPaletteColourRGB12                    *
; *-----------------------------------------------------------*
; * Description : This method is used by AmosProAGA.library   *
; *               Get Colour( I ) method to return AGA colors.*
; *                                                           *
; * Parameters : D1 = Color ID from range 032-255             *
; *                                                           *
; * Return Value : D1=RGB12 Color                             *
; *************************************************************
    Lib_Def    getAGAPaletteColourRGB12
getAGAPaletteColourRGB12:
    Sub.l      #32,d1
    lea        EcScreenAGAPal(a0),a1   ; 2019.11.28 Update for screen aga color palette backup
    lsl.w      #1,d1
    move.w     (a1,d1.w),d1            ; Get colour
    moveq      #0,d0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getAGARainbowColor                        *
; *-----------------------------------------------------------*
; * Description : This method will return the RGB24 color va- *
; * -lue of the color at chosen line in the specified AGA     *
; * rainbow index                                             *
; *                                                           *
; * Parameters : D1 = Aga Rainbow Index (0-3)                 *
; *              D2 = YLine in the Rainbow                    *
; *                                                           *
; * Return Value : D0 = RGB24 Color Value (Integer)           *
; *************************************************************
    Lib_Def    getRainColor
getRainColor:
    movem.l    d1-d7/a0-a6,-(sp)
    ; **************** LoadAGARainbow d1,a0 done 
    lea        T_AgaRainbows(a5),a0
    lsl.l      #2,d1
    move.l     (a0,d1.w),a0
    ; ****************
    mulu       #3,d2                   ; Each Color takes 3 Bytes R8,G8 and B8.
    add.l      #R_rainData,d2
    add.l      d2,a0                   ; A0 point to the R8 of the R8G8B8 color
    clr.l      d0
    move.b     (a0)+,d0                ; D0 =     R8
    lsl.l      #8,d0                   ; D0 =   R8..
    move.b     (a0)+,d0                ; D0 =   R8G8
    lsl.l      #8,d0                   ; D0 = R8G8..
    move.b     (a0)+,d0                ; D0 = R8G8B8
    movem.l    (sp)+,d1-d7/a0-a6
    rts
















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

;
; *****************************************************************************************************************************
; *************************************************************
; * MACRO Name : CheckAGAPaletteRange                         *
; *-----------------------------------------------------------*
; * Description : This MACRO is used to check if the chosen   *
; * Index fits in the available Aga Color Palette slot        *
; *                                                           *
; * Parameters : Dreg                                         *
; *                                                           *
; * Additional informations : Can cast an error               *
; *************************************************************
CheckAGAPaletteRange MACRO
    cmp.l      #agaPalCnt,\1           ; Uses AMOSProAGA_library_Equ.s/agaPalCnt equate for limit (default = 8)
    Rbge       L_agaErr1               ; errPal1 : Palette creation slots are 0-7
    cmp.l      #0,\1
    Rbmi       L_agaErr1               ; errPal1 : Palette creation slots are 0-7
                     ENDM

;
; *****************************************************************************************************************************
; *************************************************************
; * MACRO Name : LoadAGAPalette                               *
; *-----------------------------------------------------------*
; * Description : This macro load the chosen Aga color palette*
; * pointer into the chosen AReg                              *
; *                                                           *
; * Parameters : DReg = The Aga color palette index           *
; *              AReg = The adress register where the pointer *
; *                     will be loaded                        *
; *                                                           *
; *************************************************************
LoadAGAPalette       MACRO
    lea        T_AgaColorPals(a5),\2
    lsl.l      #2,\1
    move.l     (\2,\1.w),\2
    lsr.l      #2,\1
    cmpa.l     #0,\2
                     ENDM

;
; *****************************************************************************************************************************
; *************************************************************
; * MACRO Name : ClearAGAPalette                              *
; *-----------------------------------------------------------*
; * Description : Thie macro simply clear the pointer data    *
; * storage for the chosen aga color palette                  *
; *                                                           *
; * Parameters : DReg = The Aga color palette index           *
; *              AReg = The adress register where the pointer *
; *                     will be loaded                        *
; *                                                           *
; * Additional informations : This method does not release the*
; * memory used by the Aga color palette for which the pointer*
; * is cleared. The memory must be freed before using this    *
; * macro.                                                    *
; *************************************************************
ClearAGAPalette      MACRO
    lea        T_AgaColorPals(a5),\2
    lsl.l      #2,\1
    move.l     #0,(\2,\1.w)
    lsr.l      #2,\1
                     ENDM

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : CreateAgaPaletteBlock                       *
; *-----------------------------------------------------------*
; * Description : This internal method is called by the method*
; * L_createAGAPalette to allocate memory for the aga color   *
; * palette, and insert the CMAP heder in it.                 *
; *                                                           *
; * Parameters : D3 = aga color palette index                 *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      CreateAgaPaletteBlock
    CheckAGAPaletteRange d3
    Lea        T_AgaColorPals(a5),a2
    Move.l     #agaColorPaletteSize,d0                 ; 776 bytes = "CMAP" (4 bytes) + "CmapLength" (2 bytes) + ( 256 colors * 3 bytes long for each ) + "-1" ( 2 Bytes )
    SyCall     MemFastClear
    cmpa.l     #0,a0
    Rbeq       L_agaErr3
    move.l     #"CMAP",(a0)
    move.w     #0,4(a0)   ; Save CMAP Real Size ( 256 colors * 3 bytes long for each = 768 bytes )
    Lsl.l      #2,d3                   ; D4 * 4 for long
    Move.l     a0,(a2,d3.w)
    lsr.l      #2,d3
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_LoadAgaPaletteD3A0                        *
; *-----------------------------------------------------------*
; * Description : Load the Aga Palette Index D3 pointer in the*
; * A0 register                                               *
; *                                                           *
; * Parameters : D3 = Aga Palette Index                       *
; *                                                           *
; * Return Value : A0 = Aga Palette Buffer Memory Pointer     *
; *************************************************************
  Lib_Def      LoadAgaPaletteD3A0
    CheckAGAPaletteRange d3
    move.l     d3,d4
    Lsl.l      #2,d4                   ; D3 * 4 for long
    Lea        T_AgaColorPals(a5),a0
    move.l     (a0,d4.w),a0
    cmpa.l     #0,a0
    bne.s      .laps
    Rbsr       L_CreateAgaPaletteBlock
.laps:
    Lea        T_AgaColorPals(a5),a0
    move.l     (a0,d4.w),a0
    cmpa.l     #0,a0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_PushAgaColorD3ToCmapBlock                 *
; *-----------------------------------------------------------*
; * Description : Copy The AGA Color Palette contained in the *
; * Aga Color Palette at index D3, into the CMAP Buffer       *
; * This method is generally used just before a Save Aga Pale-*
; * -tte.                                                     *
; *                                                           *
; * Parameters : D3 = Aga Palette Index                       *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      PushAgaColorD3ToCmapBlock
    Rbsr       L_LoadAgaPaletteD3A0    ; A0 = Color Map Palette
    Move.l     (a0)+,d0
    cmp.l      #"CMAP",d0
    Rbne       L_agaErr16              ; No -> Error : The loaded IFF/ILBM, CMAP header is not found.
    Move.l     (a0)+,d0
    move.l     d0,d1
    divu       #3,d1                   ; D0 = Cmap Size / 2 ( color amount is always pair so 3 component * pair = pair result so we can copy by words. )
    cmp.l      #257,d1
    Rbge       L_agaErr19              ; Color Count Corrupted
    cmp.l      #1,d1
    Rblt       L_agaErr19              ; Color Count Corrupted
    move.l     T_AgaCMAPColorFile(a5),a1 ; A1 = CMAP Color File
    lea        aga_CMAP_size(a1),a1
    move.l     d0,(a1)+
    sub.l      #1,d0
rcpy:
    move.b     (a0)+,(a1)+
    dbra       d0,rcpy
    move.l     #"DPI ",(a1)+
    move.l     #0,(a1)+
    move.l     a1,d3                     ; D3 = Position where copy finished
    move.l     T_AgaCMAPColorFile(a5),a0 ; A0 = CMAP Color File
    move.l     a0,d0                     ; D0 = Start of CMAP IFF File in memory
    sub.l      d0,d3                     ; Buffer length to save
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_CreateIFFCmapBlock                        *
; *-----------------------------------------------------------*
; * Description : This internal method is used to create a me-*
; * -mory block to store a full AGA color palette using an    *
; * IFF/ILBM CMAP file format similar to the one used by the  *
; * software called Personal Paint 7.x . This memory buffer is*
; * used to load from disk and save to disk any aga color pa- *
; * -lette                                                    *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *                                                           *
; * Additional informations : This method can cast an error   *
; *************************************************************
  Lib_Def      CreateIFFCmapBlock
    ; ******** First, we check if the block was already created in memory
    move.l     T_AgaCMAPColorFile(a5),a0
    move.l     a0,d0
    tst.l      d0
    bne.s      .end
    ; ******** Secondly we create the block in memory
    move.l     #aga_ILBM_SIZE,d0    
    SyCall     MemFastClear
    cmpa.l     #0,a0
    Rbeq       L_agaErr15              ; Error 15 : Not enough memory
    ; ******** And then, we check block was created otherwise we cast an error
    move.l     a0,T_AgaCMAPColorFile(a5) ; Save the new block in Memory
    cmpa.l     #0,a0
.end:
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_PopulateIFFCmapBlock                      *
; *-----------------------------------------------------------*
; * Description : This method fill the buffer created with the*
; * method L_CreateIFFCmapBlock with datas compatible with the*
; * IFF/ILBM CMAP file format used in Personal Paint 7.x . It *
; * is used by the method called to save an aga color palette *
; * to disk.                                                  *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  ; ******************************************* Modify A0 only
  Lib_Def      PopulateIFFCmapBlock
    tst.l      T_AgaCMAPColorFile(a5)
    beq.w      .end2
    move.l     T_AgaCMAPColorFile(a5),a0
    move.l     #"FORM",aga_FORM(a0)              ; Insert "FORM" header
    move.l     #$334,aga_FORM_size(a0)           ; Insert FORM whole content size
    move.l     #"ILBM",aga_ILBM(a0)              ; insert "ILBM" header
    move.l     #"BMHD",aga_BMHD(a0)              ; Insert "BMHD" header
    move.l     #$0014,aga_BMHD_size(a0)          ; Insert BMHD block size
    move.w     #$0000,aga_BMHD_W(a0)             ; Image Width = 0
    move.w     #$0000,aga_BMHD_W(a0)             ; Image Height = 0
    move.w     #$0000,aga_BMHD_X(a0)             ; Image Pixel Pos X
    move.w     #$0000,aga_BMHD_Y(a0)             ; Image Pixel Pos Y
    move.b     #$00,aga_BMHD_nPlanes(a0)         ; set bitplanes amount (and then colors count) at 0 per default
    move.b     #$00,aga_BMHD_masking(a0)         ; Masking = 0
    move.b     #$00,aga_BMHD_compression(a0)     ; Compression = 0 = No compression as there are no bitmaps there
    move.b     #$00,aga_BMHD_pad1(a0)            ; Pad1 = 0 as unused
    move.w     #$0000,aga_BMHD_transparentC(a0)  ; Transparency = Not available / Not Set
    move.b     #$00,aga_BMHD_xAspect(a0)         ; xAspect = 0
    move.b     #$00,aga_BMHD_yAspect(a0)         ; yAspect = 0
    move.w     #$00,aga_BMHD_pageWidth(a0)       ; xAspect = 0
    move.w     #$00,aga_BMHD_pageHeight(a0)      ; yAspect = 0
    move.l     #"CMAP",aga_CMAP(a0)              ; Insert "CMAP" header
    ; The forced update of the IFF/ILBM Color map block stop here.
    ; Because Color size may vary depending on the amount of colors of the screen (bitplanes depth), 
    ; the position of the DPI block may vary and, due to that, the block is inserted at end of palette integration.
.end2:
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_notCMAPFile                               *
; *-----------------------------------------------------------*
; * Description : This internal method is used by the method  *
; * L_loadAgaPalette to close the opened file and cast an er- *
; * -ror saying that the opened file is not a valide IFF/ILBM *
; * CMAP file                                                 *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    ; **************** Send an error if a content of the file is not compliant with IFF/ILBM CMAP File
  Lib_Def    notCMAPFile
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile
    Rbra       L_agaErr14              ; Error : The specified file is not an IFF/ILBM Color Map (CMAP) file.
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_notCMAPFileSizeKO                         *
; *-----------------------------------------------------------*
; * Description : This internal method is used by the method  *
; * L_loadAgaPalette to close the opened file and cast an er- *
; * -ror saying that the opened file is not a valide IFF/ILBM *
; * CMAP file                                                 *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def    notCMAPFileSizeKO
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile
    Rbra       L_agaErr20              ; Error : The IFF/FORM file size is incorrect.
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_copyToAgaPal                              *
; *-----------------------------------------------------------*
; * Description : This internal method is called by methods   *
; * that ask for partial copy of a screen color palette inside*
; * a chosen aga color palette slot.                          *
; *                                                           *
; * Parameters : D1 = Source Screen to get the palette from   *
; *              D2 = First color index to copy from screen   *
; *              D4 = Amount of colors to copy from screen    *
; *              D5 = Chosen aga color palette to update      *
; *              D3 = First color index to update in the aga  *
; *                   color palette to update                 *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    ; ****************************************** This method will copy part of screen color palette to created Aga Color Palette
    ; D1 = SOURCE : Which screen 
    ; D2 = SOURCE : First color to copy from screen
    ; D4 = SOURCE : Amount of colors to copy from Screen
    ; D5 = DESTINATION : Chosen color palette to use for save.
    ; D3 = DESTINATION : Aga Color Palette Start Copy Position
    Lib_Def    copyToAgaPal
    ; * 1. We check if chosen color palette is valid & exists.
    cmp.l      #8,d5                   ; is Index > 7 ?
    Rbge       L_agaErr1               ; if YES -> agaErr1 : Palette creation slots are 0-7
    cmp.l      #0,d5                   ; is Index < 0 ?
    Rbmi       L_agaErr1               ; if YES -> agaErr1 : Palette creation slots are 0-7
    LoadAGAPalette d5,a2               ; A2 =  Aga Color Palette D5 pointer
    Rbeq       L_agaErr4               ; if NOT exists (=0) -> agaErr4
    Move.l     d0,a2                   ; A2 = Color Index 0 of the chosen Aga Color palette
    ; * 2. We check if destination color index & range are valids.
    cmp.l      #0,d3                   ; if chosen color > -1 ?
    Rbmi       L_agaErr5               ; if NOT -> agaErr5
    Move.l     d4,d0                   ; D0 = Amount of colors to copy from screen
    Add.l      d3,d0                   ; D0 = Amount of colors to copy from screen + Start AGA color palette index for copy
    Cmp.l      #257,d0                 ; Does Start Copy Color Index + Amount of Colors to copy > 256 ?
    Rbge       L_agaErr6               ; if YES -> agaErr6
    Lsl.l      #2,d3                   ; D3 * 4 for pointers alignment
    Add.l      d3,a2                   : ***************************************** A2 = Color index D3 (Start) of the chosen Aga Color palette
    ; * 3. We check if chosen screen is valid and exists
    cmp.l      #12,d1                  ; is Index > EcMax ? ( +WEqu.s/EcMax L88)
    Rbge       L_agaErr7               ; if YES -> agaErr1 : Screen index is invalid.
    cmp.l      #0,d1                   ; if Screen ID < 0 ?
    Rbmi       L_agaErr7               ; if YES -> agaErr7 : Screen index is invalid.
    Lsl.l      #2,d1                   ; D1 * 4 for pointer
    Move.l     a5,a1
    Add.l      #T_EcAdr,a1
    Move.l     (a1,d1.w),a1            ; ***************************************** A1 = Chosen Screen Data Base
    ; * 4. We check if chosen screen contain enough colors for the copy
    move.w     EcNbCol(a1),d0          ; D0 = Amount of colors available in the current Screen
    And.l      #$FFFF,d0
    Sub.l      D2,d0
    Sub.l      d4,d0
    Rbmi       L_agaErr8
    cmp.l      #0,d4
    Rble       L_agaErr9               ; No color to copy.
    Sub.w      #1,d4                   ; D4=D4-1 to use minus state for copy ending
    ; D0-D1-D3-D5 can be used from now.
    ; * 5. We copy ECS/AGA compatible color palette inside AGA color palette.
    Lea.l      EcPal(a1),a0            ; *A0 = Source Color Palette High Bits
    Lea.l      EcPalL(a1),a1           ; *A1 = Source Color palette Low Bits
    Lsl.l      #1,d2                   ; D2 = Word aligned because ECS colors are R4G4B4 (.w)
cpyLoop:
    clr.l      d0
    clr.l      d3
    Move.w     (a0,d2.w),d0            ; D0 =..RhGhBh= ECS Color R4G4B4 High Bits
    Move.w     (a1,d2.w),d3            ; D3 =..RlGlBl = ECS Color R4G4B4 Low Bits
    and.l      #$00000FFF,d3           ; D3 = ..........RlGlBl
    Move.l     d3,d1                   ; D1 = ..........RlGlBl
    And.w      #$00000F00,d3           ; D3 = ..........Rl....
    Lsl.l      #4,d3                   ; D3 = ........Rl......
    or.w       d1,d3                   ; D3 = ........RlRlGlBl
    And.l      #$0000F0F0,d3           ; D3 = ........Rl..Gl..
    lsl.l      #4,d3                   ; D3 = ......Rl..Gl....
    and.w      #$0000000F,d1           ; D2 = ..............Bl
    or.l       d1,d3                   ; D3 = ......Rl..Gl..Bl
    ; ************************* Secondly, we read the high bits values in D2 to get D2 = ....Rh..Gh..Bh..
    and.l      #$00000FFF,d0           ; D0 = ..........RhGhBh
    Move.l     d0,d1                   ; D1 = ..........RhGhBh
    And.l      #$00000F00,d0           ; D0 = ..........Rh....
    Lsl.l      #4,d0                   ; D0 = ........Rh......
    or.l       d1,d0                   ; D0 = ........RhRhGhBh
    And.l      #$0000F0F0,d0           ; D0 = ........Rh..Gh..
    lsl.l      #4,d0                   ; D0 = ......Rh..Gh....
    and.l      #$0000000F,d1           ; D1 = ..............Bh
    or.l       d1,d0                   ; D0 = ......Rh..Gh..Bh
    lsl.l      #4,d0                   ; D0 = ....Rh..Gh..Bh..
    ; ************************* Finally we merge D3 and D2 to obtain the full RGB24 color D3 + D2 = ....RhRlGhGlBhBl
    or.l       d3,d0                   ; D0 = ....RhRlGhGlBhBl
    move.l     d0,d3                   ; D3 = ....RhRlGhGlBhBl
    ; ************************ Handle RGB12 + RGB12 to become RGB24 : Set Byte #0 = 1 = Color Active
    swap       d3                      ; D3 = GhGlBhBl....RhRl
    move.b     d3,(a2)+                ; Push D3.B = RhRl -> (a2)+
    lsr.l      #8,d0                   ; D0 = ........RhRlGhGl
    swap       d3                      ; D3 = ....RhRlGhGlBhBl
    move.b     d3,(a2)+                ; Push BhBl -> (a2)+
    move.b     d3,(a2)+                ; Push BhBl -> (a2)+
    ; ************************* Next color to copy ?
    Sub.w      #1,d4                   ; D4=D4-1 (remaining amount of colors to copy)
    bmi.s      endCpy                  ; No more colors to copy ? YES -> Jump to .endCpy
    add.w      #2,d2                   ; Some colors remains to copy -> D2 = Next Color register
    Cmp.w      #512,d2                 ; Check if we reach Color #256 -> then continue with Aga color
    blt.s      cpyLoop                 ; Next color < 32 -> Continue ECS Copy -> Jump .cpyLoop
endCpy:
    rts

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

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_createAGAPalette                          *
; *-----------------------------------------------------------*
; * Description : This method will allocate memory to store   *
; * a full 256 colors aga palette inspired from IFF/CMAP file *
; * format                                                    *
; *                                                           *
; * Parameters : D3 = AGA Color Palette Bank ID (0-7)         *
; *                                                           *
; *************************************************************
  Lib_Par      createAGAPalette
    CheckAGAPaletteRange d3            ; Check limits for color palette indexes
    LoadAGAPalette d3,a2
    Rbne       L_agaErr2               ; No = Aga Color Palette already Exists -> Error "Aga Palette already exists"
    Rbsr       L_CreateAgaPaletteBlock ; Create the memory block for the chosen Aga Color Palette
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_deleteAGAPalette                          *
; *-----------------------------------------------------------*
; * Description : This method will free the memory used by an *
; * aga color palette that was allocated using the method na- *
; * -med : L_createAGAPalette                                 *
; *                                                           *
; * Parameters : D3 = AGA Color Palette Bank ID (0-7)         *
; *                                                           *
; *************************************************************
  Lib_Par      deleteAGAPalette
    CheckAGAPaletteRange d3
    LoadAGAPalette d3,a1
    cmpa.l     #0,a1
    Rbeq       L_agaErr4
    ClearAGAPalette d3,a2
    Move.l     #agaColorPaletteSize,d0                 ; 776 bytes = "CMAP" (4 bytes) + "CmapLength" (2 bytes) + ( 256 colors * 3 bytes long for each ) + "-1" ( 2 Bytes )
    SyCall     MemFree
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getAgaPaletteExists                       *
; *-----------------------------------------------------------*
; * Description : This method will return 1 if the specified  *
; * aga color palette exists, otherwise 0.                    *
; *                                                           *
; * Parameters : D3 = AGA Color Palette Bank ID (0-7)         *
; *                                                           *
; * Return Value : 1 or 0 (Integer)                           *
; *************************************************************
  Lib_Par      getAgaPeletteExists
    CheckAGAPaletteRange d3
    LoadAGAPalette d3,a2
    beq.s      .gape1
    moveq      #1,d3
    Ret_Int
.gape1:
    moveq      #0,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_loadAgaPalette                            *
; *-----------------------------------------------------------*
; * Description : This method is used to load, from an IFF    *
; * CMAP disk file, an existing aga color palette             *
; *                                                           *
; * Parameters : D3    = AGA Color Palette Bank ID (0-7)      *
; *              (a3)+ = IFF/ILBM color map file              *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      loadAgaPalette
    move.l    (a3)+,a4                 ; A4 = FileName
    ; ******** We check if the Color Palette index is in the correct range 0-7
    CheckAGAPaletteRange d3
    move.l     d3,d4                   ; D4 = Current Color Palette (Save)
    ; ******** We check if the block to load the file was created or not.
    Rbsr       L_CreateIFFCmapBlock    ; Verify if the memory block for CMAP File is created
    ; ******** Secondly, we check if the filename contain a path. To do that we check for a ":"
    move.l     a4,a2                   ; a2 = a4 = FileName
    Rbsr       L_NomDisc2              ; This method will update the filename to be full Path+FileName
    move.l     #1005,d2                ; D2 = READ ONLY dos file mode
    Rbsr       L_OpenFile              ; Dos->Open
    Rbeq       L_DiskFileError         ; -> Error when trying to open the file.
    Rbsr       L_SaveRegsD6D7          ; Save AMOS System registers
    move.l     Handle(a5),d1           ; D1 = File Handle
    move.l     T_AgaCMAPColorFile(a5),a0 ; Load buffer in A0
    Move.l     a0,d2                   ; D2 = A0 (Save)
    move.l     #12,d3                  ; D3 = 12 bytes to read
    Rbsr       L_IffReadFile2          ; Dos->Read
    move.l     T_AgaCMAPColorFile(a5),a0 ; Load buffer in A0
    move.l     (a0),d3
    cmp.l      #"FORM",d3              ; Does the file start with "FORM" ?
    Rbne       L_notCMAPFile           ; No -> Jump L_notCMAPFile
    move.l     4(a0),d3                ; D3 = Get the file size
    ; ******** Check if FORM size is in a correct range ( 0 < size < 400 bytes )
    cmp.l      #0,d3
    Rbmi       L_notCMAPFileSizeKO
    cmp.l      #$400,d3
    Rbge       L_notCMAPFileSizeKO
    ; Continue
    adda.l     #12,a0                  ; A0 = A0 + 12 -> A0 Point just after the 12 already read bytes
    move.l     a0,d2                   ; D2 = Buffer
    move.l     Handle(a5),d1           ; D1 = File Handle
    Rbsr       L_IffReadFile2          ; Read the remaining bytes
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close
    ; **************** Now We create the AGA color palette block if it does not exists.
    Move.l     d4,d3                   ; Restore AGA Color palette index into D3
    Rbsr       L_LoadAgaPaletteD3A0    ; A0 = Current Color Palette
    move.l     #"CMAP",(a0)+
    move.l     T_AgaCMAPColorFile(a5),a1 ; A1 = Loaded color Map
    add.l      #aga_CMAP,a1            ; A1 to point to the CMAP Size
    move.l     (a1),d0
    cmp.l      #"CMAP",d0              ; does the loaded IFF color map file contains "CMAP" where it is waited ?
    Rbne       L_agaErr16              ; No -> Error : The loaded IFF/ILBM, CMAP header is not found.
    add.l      #4,a1                   ; A1 point to aga_CMAP_Size
    move.l     (a1)+,d0                ; D0 = CMAP Size
    move.l     d0,d1
    divu       #3,d0                   ; D0 = Cmap Size / 2 ( color amount is always pair so 3 component * pair = pair result so we can copy by words. )
    cmp.l      #257,d0
    Rbge       L_agaErr19              ; Color Count Corrupted
    cmp.l      #1,d0
    Rblt       L_agaErr19              ; Color Count Corrupted
    move.l     d1,(a0)+                ; Save CMAP size into target AGA color palette (define the amount of colors in.)
    sub.l      #1,d1                   ; sub 1 to use dbra to stop copy.
    ; **************** Start the copy of the color palette from the IFF/ILBM file into the Aga Color Palette
.lapl1:
    move.b     (a1)+,(a0)+
    dbra       d1,.lapl1
    move.w     #$FF,(a0)+
    moveq      #0,d0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_saveAgaPalette                            *
; *-----------------------------------------------------------*
; * Description : Save the chosen AGA Palette to disk         *
; *                                                           *
; * Parameters : D3    = AGA Color Palette Bank ID (0-7)      *
; *              (a3)+ = IFF/ILBM color map file              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      saveAgaPalette
    move.l    (a3)+,a4                 ; A4 = FileName
    ; ******** We check if the Color Palette index is in the correct range 0-7
    LoadAGAPalette d3,a0               ; A0 = CMAP buffer. Start with "CMAP" datas at index = 0
    Rbeq       L_agaErr4               ; If the color palette was not created -> Jump L_agaErr4 (AGA Color palette not previously created)
    ; ******** We check if the block to load the file was created or not.
    Rbsr       L_CreateIFFCmapBlock    ; Verify if the memory block for CMAP File is created
    Rbsr       L_PopulateIFFCmapBlock  ; Fill the IFF file with the correct informations for the file to be valid.
    Rbsr       L_PushAgaColorD3ToCmapBlock ; Push the chosen color palette to the CMAP file ----> D3 = Buffer Length
    move.l     d3,d4                   ; Save buffer size to D3
    ; ******** Secondly, we check if the filename contain a path. To do that we check for a ":"
    move.l     a4,a2                   ; a2 = a4 = FileName
    Rbsr       L_NomDisc2              ; This method will update the filename to be full Path+FileName
    move.l     #1006,d2                ; D2 = MODE_NEWFILE (create/overwrite)
    Rbsr       L_OpenFile              ; Dos->Open
    Rbeq       L_DiskFileError         ; -> Error when trying to open the file.
    Rbsr       L_SaveRegsD6D7          ; Save AMOS System registers
    move.l     Handle(a5),d1           ; D1 = File Handle
    move.l     T_AgaCMAPColorFile(a5),a0 ; Load buffer in A0
    Move.l     a0,d2                   ; D2 = A0 (Save) = Buffer to output
    move.l     d4,d3                   ; D3 = XXX bytes to write (calculated by the call L_PushColorD3ToCmapBlock)
    Rbsr       L_IffWriteFile2         ; Dos->Write
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_setAgaPalette                             *
; *-----------------------------------------------------------*
; * Description : This method will update the current screen  *
; * full aga color palette from range 000-255 and the global  *
; * aga color palette from range 032-255 with the one set in  *
; * the specified aga color palette buffer                    *
; *                                                           *
; * Parameters : D3    = AGA Color Palette Bank ID (0-7)      *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      setAgaPalette
    LoadAGAPalette d3,a2               ; A2 = CMAP buffer. Start with "CMAP" datas at index = 0
    Rbeq       L_agaErr4
    move.l     (a2)+,d0                ; D0 = CMAP header (is everything is ok)
    cmp.l      #"CMAP",d0              ; CMAP ? Ok ?
    Rbne       L_agaErr18              ; Aga color palette corrupted
    move.l     (a2)+,d0                ; D0 = CMAP hunk size
    divu       #3,d0                   ; D0 = CMAP Color amount ( = CMAP hunk size / 3 )
    cmp.l      #257,d0                 ; >256 colors = KO
    Rbge       L_agaErr17              ; Color Count Corrupted
    cmp.l      #2,d0                   ; <2 colors = KO
    Rblt       L_agaErr17              ; Color Count Corrupted
    movem.l    d4-d5,-(sp)             ; Save D4/D5 to SP
    move.l     d0,d3                   ; 2019.11.18 D3 = Color amount backup for palette update selection ECS/AGA
    move.l     Buffer(a5),a0           ; A0 = Temporar buffer for Color palette
    move.l     a0,a1                   ; A1 = Temporar buffer for Color palette
; ************************************* 2020.05.15 AGAP for AGA color Palette
    cmp.l      #32,d0                  ; Do we have more than 32 colors in this palette ?
    ble.s      iffEcsPal               ; No -> Jump to iffEcsPal
iffAgaPal:                             ; Yes -> Insert AGA informations
    Move.l     #"AGAP",(a0)+           ; 2020.08.14 Not Push 'AG24' instead of 'AGAP' inside the buffer to mean AGA 24 Bit color palette
    Move.w     d0,(a0)+                ; Push Color Amount inside buffer
iffEcsPal:
; ************************************* 2020.05.15 AGAP for AGA color Palette
    subq.w     #1,d0                   ; D0 = Color Amount -1 to makes dbra handle color count up to negative D0.
;    addq.l     #8,a2                   ; A2 = located to the first R8G8B8 color CMAP value.
    moveq      #0,d1                   ; 2020.08.25 Clear register
    moveq      #0,d4                   ; 2020.08.25 Clear register
    moveq      #0,d2                   ; 2020.08.25 Clear register
    moveq      #0,d5                   ; 2020.08.25 Clear register
IfSb:
    ; Read R8 value
    move.b     (a2)+,d1                ; D1 = ....RhRl
    move.b     d1,d4                   ; D4 = ....RhRl
    and.w      #$00F0,d1               ; D1 = 0000Rh00 2020.08.25 added
    lsl.w      #4,d4                   ; D4 = ....Rl..
    and.w      #$00F0,d4               ; D4 = 0000Rl00 2020.08.25 added
    ; Read G8 value
    move.b     (a2)+,d2                ; D2 = ....GhGl
    move.b     d2,d5                   ; D5 = ....GhGl
    lsr.b      #4,d2                   ; D2 = ......Gh
    and.b      #$F,d2                  ; D2 = 000000Gh In case lsr keep the upper bit  2020.08.25 added
    or.b       d2,d1                   ; D1 = ....RhGh
    lsl.w      #4,d1                   ; D1 = ..RhGh..
    and.w      #$FF0,d1                ; D1 = 00RhGh00 2020.08.25 added
    and.w      #$0F,d5                 ; D5 = 000000Gl 2020.08.25 added
    or.w       d5,d4                   ; D4 = ....RlGl
    lsl.w      #4,d4                   ; D4 = ..RlGl..
    and.w      #$FF0,d4                ; D4 = 00RlGl00 2020.08.25 added
    ; Read B8 value
    move.b     (a2)+,d2                ; D2 = ....BhBl
    move.b     d2,d5                   ; D5 = ....BhBl
    lsr.b      #4,d2                   ; D2 = ......Bh
    and.w      #$F,d2                  ; D2 = 000000Bh 2020.08.25 added
    or.w       d1,d2                   ; D2 = ..RhGhBh 2020.08.25 updated to .w instead of .b
    and.w      #$F,d5                  ; D5 = 000000Bl 2020.08.25 Updated to AND instead of OR
    or.w       d5,d4                   ; D4 = ..RlGlBl
    move.w     d4,514(a0)              ; (A0) + 512 + 2 = D4 = RlGlBl
    move.w     d2,(a0)+                ; (A0)       = D2 = RhGhBh, A0+
    dbra       d0,IfSb                 ; d0, next color > -1 Jump IfSb (Loop)
IfSc:
; ************************************************************* 2020.08.30 Passage to AGA have broken default limit checking with negative value. Reinsert it - Start
    move.w     #$FFFF,514(a0)          ; (A0) + 512 + 2 = NEGATIVE VALUE
    move.w     #$FFFF,(a0)             ; (A0)       = NEGATIVE VALUE
; ************************************************************* 2020.08.30 Passage to AGA have broken default limit checking with negative value. Reinsert it - End
    movem.l    (sp)+,d4-d5
    AgaLibCall EcSPalAGA_CurrentScreen
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getAgaPalette                             *
; *-----------------------------------------------------------*
; * Description : This method will get the whole aga color pa-*
; * -lette from the current screen, and store it in the speci-*
; * -fied aga color palette slot.                             *
; *                                                           *
; * Parameters : D3    = AGA Color Palette Bank ID (0-7)      *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      getAgaPalette
    LoadAGAPalette d3,a0               ; A0 = CMAP buffer. Start with "CMAP" datas at index = 0
    Rbeq       L_agaErr4               ; If the color palette was not created -> Jump L_agaErr4 (AGA Color palette not previously created)
    move.l     (a0)+,d0                ; D0 should be = to "CMAP"
    Cmp.l      #"CMAP",d0
    Rbne       L_agaErr18              ; Aga color palette corrupted
    move.l     ScOnAd(a5),d0           ; D0 = Current Screen structure pointer
    cmp.l      #0,d0                   ; D0 = 0 = NULL ?
    Rbeq       L_agaErr21              ; Yes -> No screen available for the requested operation
    move.l     d0,a2                   ; A2 = Current Screen
    Move.w     EcNbCol(a2),d0          ; D0 = Screen Amount of colors
    and.l      #$01FF,d0
    cmp.l      #257,d0                 ; >256 colors = KO
    Rbge       L_agaErr17              ; Color Count Corrupted
    cmp.l      #2,d0                   ; <2 colors = KO
    Rblt       L_agaErr17              ; Color Count Corrupted
    mulu       #3,d0                   ; Because CMAP store size of CMAP block ( Amount of colors * 3 (R,G,B) )
    move.l     d0,(a0)+                ; AGA Color palette count updated with current screen amount of colors.
    divu       #3,d0                   ; Restore true amount of colors.
    sub.l      #1,d0                   ; TO makes dbra stop copy when reach -1
; ******** Here start the loop that store the full color palette in RGB24 format for easier fading calculation.
    lea        EcPal(a2),a2
fap1B:
    ; ************************ First, we read the low bits values in D3 to get D3 = ......Rl..Gl..Bl
    clr.l      d3
    Move.w     EcPalL-EcPal(a2),d3  ; D3 =     ..RlGlBl
    and.l      #$00000FFF,d3    ; D3 = ..........RlGlBl
    Move.l     d3,d2            ; D2 = ..........RlGlBl
    And.w      #$00000F00,d3    ; D3 = ..........Rl....
    Lsl.l      #4,d3            ; D3 = ........Rl......
    or.w       d2,d3            ; D3 = ........RlRlGlBl
    And.l      #$0000F0F0,d3    ; D3 = ........Rl..Gl..
    lsl.l      #4,d3            ; D3 = ......Rl..Gl....
    and.w      #$0000000F,d2    ; D2 = ..............Bl
    or.l       d2,d3            ; D3 = ......Rl..Gl..Bl
    ; ************************* Secondly, we read the high bits values in D2 to get D2 = ....Rh..Gh..Bh..
    clr.l      d2
    Move.w     (a2)+,d2         ; D2 =         ..RhGhBh
    and.l      #$00000FFF,d2    ; D2 = ..........RhGhBh
    Move.l     d2,d1            ; D1 = ..........RhGhBh
    And.l      #$00000F00,d2    ; D2 = ..........Rh....
    Lsl.l      #4,d2            ; D2 = ........Rh......
    or.l       d1,d2            ; D2 = ........RhRhGhBh
    And.l      #$0000F0F0,d2    ; D2 = ........Rh..Gh..
    lsl.l      #4,d2            ; D2 = ......Rh..Gh....
    and.l      #$0000000F,d1    ; D1 = ..............Bh
    or.l       d1,d2            ; D2 = ......Rh..Gh..Bh
    lsl.l      #4,d2            ; D2 = ....Rh..Gh..Bh..
    ; ************************* Finally we merge D3 and D2 to obtain the full RGB24 color D3 + D2 = ....RhRlGhGlBhBl
    or.l       d2,d3            ; D3 = ....RhRlGhGlBhBl
    move.l     d3,d2            ; D2 = ....RhRlGhGlBhBl
    swap       d2               ; D2 = GhGlBhBl....RhRl
    
    ; ************************ Handle RGB12 + RGB12 to become RGB24 : Set Byte #0 = 1 = Color Active
    move.b     d2,(a0)+                ; Push RhRl -> (a0)+
    lsr.l      #8,d3                   ; D3 = ........RhRlGhGl
    swap       d2                      ; D2 = ....RhRlGhGlBhBl
    move.b     d3,(a0)+                ; Push GhGl -> (a0)+
    move.b     d2,(a0)+                ; Push BhBl -> (a0)+
    ; Color component inserted with 4 bytes in the list (Flag,R8,G8,B8), any other color to insert ?
    dbra       d0,fap1B
;    move.w     #$FFFF,(a0)+            ; End of color list defined by a -1.w
    moveq      #0,d0                   ; D0 = 0 = Everything is OK
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_copyScreenToAgaPal1                       *
; *-----------------------------------------------------------*
; * Description : This method will copy a part of the screen  *
; * color palette inside a part of a chosen aga color palette *
; * slot.                                                     *
; *                                                           *
; * Parameters : D3    = Position in the destination aga color*
; *                      palette to copy the screen color pa- *
; *                      -lette part                          *
; *              (a3)+ = Destination aga color palette        *
; *              (a3)+ = Amount of colors to copy from screen *
; *              (a3)+ = First color index to copy from screen*
; *              (a3)+ = Source screen                        *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par  copyScreenToAgaPal1
    ; * 1. We get all parameters to makes A3 be at the correct position.
    ; Last parameter -> D3  ; D3 = DESTINATION : Aga Color Palette Start Copy Position
    Move.l  (a3)+,d5        ; D5 = DESTINATION : Chosen color palette to use for save.
    Move.l  (a3)+,d4        ; ****************************************** D4 = SOURCE : Amount of colors to copy from Screen
    Move.l  (a3)+,d2        ; ****************************************** D2 = SOURCE : First color to copy from screen
    Move.l  (a3)+,d1        ; D1 = SOURCE : Which screen 
    Rbra    L_copyToAgaPal

; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_copyScreenToAgaPal2                       *
; *-----------------------------------------------------------*
; * Description : This method will copy a part of the screen  *
; * color palette inside a part of a chosen aga color palette *
; * slot. The color copy start at index position 0 in the des-*
; * -tination aga color palette                               *
; *                                                           *
; * Parameters : D3    = Destination aga color palette        *
; *              (a3)+ = Amount of colors to copy from screen *
; *              (a3)+ = First color index to copy from screen*
; *              (a3)+ = Source screen                        *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par  copyScreenToAgaPal2
    ; * 1. We get all parameters to makes A3 be at the correct position.
    ; Last parameter -> D3  ; D3 = DESTINATION : Chosen color palette to use for save.
    Move.l  d3,d5           ; D5 = DESTINATION : Chosen color palette to use for save.
    move.l  #0,d3           ; D3 = DESTINATION : Aga Color Palette Start Copy Position
    Move.l  (a3)+,d4        ; ****************************************** D4 = SOURCE : Amount of colors to copy from Screen
    Move.l  (a3)+,d2        ; ****************************************** D2 = SOURCE : First color to copy from screen
    Move.l  (a3)+,d1        ; D1 = SOURCE : Which screen 
    Rbra    L_copyToAgaPal


;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME :       Palette Fade Internal methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_fadeAGAinside                             *
; *-----------------------------------------------------------*
; * Description : This internal method is used by all the fade*
; * methods to setup Amos Professional VBL/FadeI interrupt to *
; * makes it call the correct special fade interrupt method.  *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      fadeAGAinside
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
    move.w     d0,T_FadeFlag(a5)       ; T_FadeFlag(a5) = D0 = Colour amount to Update
    sub.w      #1,d0                   ; D0 = D0 -1 (to use -1 as end of color handling loop)
    Move.w     d0,T_FadeNb(a5)         ; T_FadeNb(a5) = Amount of colors of the Screen -1
; ******** Here start the loop that store the full color palette in RGB24 format for easier fading calculation.
fap1:
    ; ************************ First, we read the low bits values in D3 to get D3 = ......Rl..Gl..Bl
    clr.l      d3
    Move.w     EcPalL-EcPal(a2),d3  ; D3 =     ..RlGlBl
    and.l      #$00000FFF,d3    ; D3 = ..........RlGlBl
    Move.l     d3,d2            ; D2 = ..........RlGlBl
    And.w      #$00000F00,d3    ; D3 = ..........Rl....
    Lsl.l      #4,d3            ; D3 = ........Rl......
    or.w       d2,d3            ; D3 = ........RlRlGlBl
    And.l      #$0000F0F0,d3    ; D3 = ........Rl..Gl..
    lsl.l      #4,d3            ; D3 = ......Rl..Gl....
    and.w      #$0000000F,d2    ; D2 = ..............Bl
    or.l       d2,d3            ; D3 = ......Rl..Gl..Bl
    ; ************************* Secondly, we read the high bits values in D2 to get D2 = ....Rh..Gh..Bh..
    clr.l      d2
    Move.w     (a2)+,d2         ; D2 =         ..RhGhBh
    and.l      #$00000FFF,d2    ; D2 = ..........RhGhBh
    Move.l     d2,d1            ; D1 = ..........RhGhBh
    And.l      #$00000F00,d2    ; D2 = ..........Rh....
    Lsl.l      #4,d2            ; D2 = ........Rh......
    or.l       d1,d2            ; D2 = ........RhRhGhBh
    And.l      #$0000F0F0,d2    ; D2 = ........Rh..Gh..
    lsl.l      #4,d2            ; D2 = ......Rh..Gh....
    and.l      #$0000000F,d1    ; D1 = ..............Bh
    or.l       d1,d2            ; D2 = ......Rh..Gh..Bh
    lsl.l      #4,d2            ; D2 = ....Rh..Gh..Bh..
    ; ************************* Finally we merge D3 and D2 to obtain the full RGB24 color D3 + D2 = ....RhRlGhGlBhBl
    or.l       d2,d3            ; D3 = ....RhRlGhGlBhBl
    move.l     d3,d2            ; D2 = ....RhRlGhGlBhBl
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
;                                                                                           * AREA NAME : Palette Fade AgaSupport.lib methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_fadeAGAstep                               *
; *-----------------------------------------------------------*
; * Description : This method will initialize a fade effect to*
; * the whole current screen AGA color palette index range 000*
; * to 255 and to the global aga color palette range 032-255. *
; * The fade effect can be used to makes the color palette be-*
; * -come entirely black or entierly white.                   *
; *                                                           *
; * Parameters : D3 = Speed (Step) used for the fading (can be*
; *                   negative = fade to black, or positive = *
; *                   fade to white)                          *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      fadeAGAstep             ; d3 = speed used for the screen fading system.
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     #1,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.w     d3,T_FadeStep(a5)       ; Set a step different from 1
    move.b     #1,T_isFadeAGA(a5)
    Rbra       L_fadeAGAinside

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_fadeAGA                                   *
; *-----------------------------------------------------------*
; * Description : This method will initialize a fade effect to*
; * the whole current screen AGA color palette index range 000*
; * to 255 and to the global aga color palette range 032-255. *
; * The fade effect can be used to makes the color palette be-*
; * -come entirely black or entierly white.                   *
; *                                                           *
; * Parameters : D3 = Speed ( = 1/Speed ) used for the fading *
; *                   (can be negative = fade to black, or po-*
; *                   sitive = fade to white)                 *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      fadeAGA                 ; d3 = speed used for the screen fading system.
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     d3,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.w     #1,T_FadeStep(a5)       ; Set a step different from 1
    move.b     #1,T_isFadeAGA(a5)
    Rbra       L_fadeAGAinside

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_fadeAGAtoPalette                          *
; *-----------------------------------------------------------*
; * Description : This method will initialize a fade effect to*
; * the whole current screen AGA color palette index range 000*
; * to 255 and to the global aga color palette range 032-255. *
; * The fade effect will be used to makes the color palette be*
; * smoothly faded to finally become equal to the color palet-*
; * -te stored in the chosen aga color palette slot.          *
; *                                                           *
; * Parameters : D3    = Speed (Step), (a3)+ = AGA Color Pale-*
; *                      -tte to use.                         *
; *              (a3)+ = The aga color palette slot (index)   *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      fadeAGAtoPalette
    move.l     (a3)+,d0                ; D0 = Color Palette to use
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     d3,T_FadeStep(a5)       ; D3 = Fading speed
    LoadAGAPalette d0,a0               ; A0 = CMAP buffer. Start with "CMAP" datas at index = 0
    Rbeq       L_agaErr4
    add.l      #8,a0                   ; A0 = 1st color index in the color palette
    move.l     a0,T_NewPalette(a5)     ; Store the new color palette into T_NewPalette data.
    move.w     #1,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.b     #2,T_isFadeAGA(a5)      ; Use the AGA version 2 of the Fading interrupt.
    Rbra       L_fadeAGAinside

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
; * Method Name : L_isAgaDetected                             *
; *-----------------------------------------------------------*
; * Description : This method will return 1 if the AGA Chipset*
; * is detected, otherwise 0.                                 *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : 1 or 0 (Integer)                           *
; *************************************************************
  Lib_Par      isAgaDetected
    Move.w     T_isAga(a5),d3
    and.l      #$FFFF,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_isScreenInHam8Mode                        *
; *-----------------------------------------------------------*
; * Description : This method will return 1 is the current    *
; * screen uses HAM8 mode, otherwise 0.                       *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : 1 or 0 (Integer)                           *
; *************************************************************
  Lib_Par      isScreenInHam8Mode
    Moveq      #0,d3
    move.l     ScOnAd(a5),d0
    beq.s      ScNOp1
    move.l     d0,a0    
    move.w     Ham8Mode(a0),d3
ScNOp1:
    Ret_Int

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
;                                                                                           * AREA NAME :  Screens color manipulation methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getRgb24bColorSCR                         *
; *-----------------------------------------------------------*
; * Description : This method will return the RGB24 color va- *
; * -lue of the chosen color index in the current screen.     *
; *                                                           *
; * Parameters : D3 = Color Index (Range 000-255)             *
; *                                                           *
; * Return Value : RGB24 Color Value (Integer)                *
; *************************************************************
  Lib_Par      getRgb24bColorSCR
    move.l     ScOnAd(a5),d0
    beq.s      ScNOp2
    move.l     d0,a0
    ; *** Error support for invalid color index - START
    move.w     EcNbCol(a0),d0
    cmp.l      #0,d3
    Rblt       L_agaErr10
    cmp.l      d0,d3
    Rbge       L_agaErr10
    ; *** Error support for invalid color index - END
    lsl.l      #1,d3        ; D3 = Color index * 2 (as each color takes 2 bytes for HIGH and 2 bytes for LOW in a second list)
    ; **** Calculate High Bits into RGB24 register
    Lea        EcPal(a0),a1     ; A1 = Index of 1st color
    Move.w     (a1,d3.w),d0     ; D0 =         ..RhGhBh
    and.l      #$00000FFF,d0    ; D0 = ..........RhGhBh
    Move.l     d0,d1            ; D1 = ..........RhGhBh
    And.l      #$00000F00,d0    ; D0 = ..........Rh....
    Lsl.l      #4,d0            ; D0 = ........Rh......
    or.l       d1,d0            ; D0 = ........RhRhGhBh
    And.l      #$0000F0F0,d0    ; D0 = ........Rh..Gh..
    lsl.l      #4,d0            ; D0 = ......Rh..Gh....
    and.l      #$0000000F,d1    ; D1 = ..............Bh
    or.l       d1,d0            ; D0 = ......Rh..Gh..Bh
    lsl.l      #4,d0            ; D0 = ....Rh..Gh..Bh..
    ; **** Calculate Low Bits into RGB24 register
    Lea        EcPalL(a0),a1    ; A1 = Index of 1st color
    Move.w     (a1,d3.w),d3     ; D3 =     ..RlGlBl
    and.l      #$00000FFF,d3    ; D3 = ..........RlGlBl
    Move.l     d3,d1            ; D1 = ..........RlGlBl
    And.w      #$00000F00,d3    ; D3 = ..........Rl....
    Lsl.l      #4,d3            ; D3 = ........Rl......
    or.w       d1,d3            ; D3 = ........RlRlGlBl
    And.l      #$0000F0F0,d3    ; D3 = ........Rl..Gl..
    lsl.l      #4,d3            ; D3 = ......Rl..Gl....
    and.w      #$0000000F,d1    ; D1 = ..............Bl
    or.l       d1,d3        ; D3 = ......Rl..Gl..Bl
;    ; **** Merge High and Low
    or.l       d0,d3        ; D3 = ....RhRlGhGlBhBl
    Bra.s      ScNOp3
ScNOp2:
    Moveq      #0,d3
ScNOp3:
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_setRgb24bColorSCR                         *
; *-----------------------------------------------------------*
; * Description : This method will update the current screen  *
; * color at chosen index, using directly RGB24 color value.  *
; *                                                           *
; * Parameters : D3    = RGB24 Color value                    *
; *              (a3)+ = Color Index                          *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    ; ****************************************** Set The RGB24 value of a color register and if the color register is >31 update the global aga palette color register
 Lib_Par       setRgb24bColorSCR
    ; Clear used registers
    moveq      #0,d1           ; 2020.08.25 Clear register
    moveq      #0,d4           ; 2020.08.25 Clear register
    moveq      #0,d2           ; 2020.08.25 Clear register
    moveq      #0,d5           ; 2020.08.25 Clear register
    move.l     (a3),d0         ; D0 = Color Index, D3 = RGB24 Value
    move.l     d3,(a3)         ; (a3) = D3 = RGB24 Value = 00R8G8B8
    add.l      #1,a3           ; (a3) = RGB R8      (Original A3 + 1)
    ; Read R8 value
    move.b     (a3)+,d1        ; D1 = ....RhRl
    move.b     d1,d4           ; D4 = ....RhRl
    and.w      #$00F0,d1           ; D1 = 0000Rh00 2020.08.25 added
    lsl.w      #4,d4           ; D4 = ....Rl..
    and.w      #$00F0,d4           ; D4 = 0000Rl00 2020.08.25 added
    ; Read G8 value
    move.b     (a3)+,d2        ; D2 = ....GhGl
    move.b     d2,d5           ; D5 = ....GhGl
    lsr.b      #4,d2           ; D2 = ......Gh
    and.b      #$F,d2          ; D2 = 000000Gh In case lsr keep the upper bit  2020.08.25 added
    or.b       d2,d1           ; D1 = ....RhGh
    lsl.w      #4,d1           ; D1 = ..RhGh..
    and.w      #$FF0,d1        ; D1 = 00RhGh00 2020.08.25 added
    and.w      #$0F,d5         ; D5 = 000000Gl 2020.08.25 added
    or.w       d5,d4           ; D4 = ....RlGl
    lsl.w      #4,d4           ; D4 = ..RlGl..
    and.w      #$FF0,d4        ; D4 = 00RlGl00 2020.08.25 added
    ; Read B8 value
    move.b     (a3)+,d2        ; D2 = ....BhBl
    move.b     d2,d5           ; D5 = ....BhBl
    lsr.b      #4,d2           ; D2 = ......Bh
    and.w      #$F,d2          ; D2 = 000000Bh 2020.08.25 added
    or.w       d1,d2           ; D2 = ..RhGhBh 2020.08.25 updated to .w instead of .b
    and.w      #$F,d5          ; D5 = 000000Bl 2020.08.25 Updated to AND instead of OR
    or.w       d5,d4           ; D4 = ..RlGlBl
    move.w     d0,d1           ; D1 = Color Index
    cmp.w      #31,d1          ; Check if requested color is in range 00-31 (ECS) or 32-255 (AGA Only)
    bgt.s      agaVer0
    EcCall     SCol24Bits          ; Call full RGB24 variant of EcSCol.
    rts
agaVer0:
    AgaLibCall EcSColAga24Bits
    rts

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME : RGB12/24 Color manipulation methods *
;                                                                                           *                                                 *
;                                                                                           ***************************************************
;                                                                                                 ***
;                                                                                              ***
;                                                                                           ************************

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_retRgb24Color                             *
; *-----------------------------------------------------------*
; * Description : This method will return a RGB24 Color value *
; * calculated using 8 bits red, green and blue components    *
; *                                                           *
; * Parameters : D3    = 8 bits blue color component          *
; *              (a3)+ = 8 bits green color component         *
; *              (a3)+ = 8 bits red color component           *
; *                                                           *
; * Return Value : RGB24 Color value (Integer)                *
; *************************************************************
  Lib_Par      retRgb24Color
    And.l      #$FF,d3                 ; D3 = ......B8
    Move.l     (a3)+,d2                ; D2 = ......G8
    And.l      #$FF,d2                 ; D2 = ......G8
    Move.l     (a3)+,d1                ; D1 = ......B8
    And.l      #$FF,d1                 ; D1 = ......R8
    Lsl.l      #8,d1                   ; D1 = ....R8..
    Or.l       d1,d2                   ; D2 = ....R8G8
    Lsl.l      #8,d2                   ; D2 = ..R8G8..
    Or.l       d2,d3                   ; D3 = ..R8G8B8
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_retRgbR8FromRgb24Color                    *
; *-----------------------------------------------------------*
; * Description : This method will return the red component   *
; * from a RGB 24 Color value                                 *
; *                                                           *
; * Parameters : D3 = RGB 24 Color value                      *
; *                                                           *
; * Return Value : 8 bits red color component                 *
; *************************************************************
  Lib_Par      retRgbR8FromRgb24Color
    and.l      #$FF0000,d3             ; D3 = ..R8....
    swap       d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_retRgbG8FromRgb24Color                    *
; *-----------------------------------------------------------*
; * Description : This method will return the green component *
; * from a RGB 24 Color value                                 *
; *                                                           *
; * Parameters : D3 = RGB 24 Color value                      *
; *                                                           *
; * Return Value : 8 bits green color component               *
; *************************************************************
  Lib_Par      retRgbG8FromRgb24Color
    and.l      #$FF00,d3               ; D3 = ....G8..
    lsr.l      #8,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_retRgbB8FromRgb24Color                    *
; *-----------------------------------------------------------*
; * Description : This method will return the blue component  *
; * from a RGB 24 Color value                                 *
; *                                                           *
; * Parameters : D3 = RGB 24 Color value                      *
; *                                                           *
; * Return Value : 8 bits blue color component                *
; *************************************************************
  Lib_Par      retRgbB8FromRgb24Color
    and.l      #$FF,d3                 ; D3 = ......B8
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_retRgb12Color                             *
; *-----------------------------------------------------------*
; * Description : This method will return a RGB12 Color value *
; * calculated using 4 bits red, green and blue components    *
; *                                                           *
; * Parameters : D3    = 4 bits blue color component          *
; *              (a3)+ = 4 bits green color component         *
; *              (a3)+ = 4 bits red color component           *
; *                                                           *
; * Return Value : RGB12 Color value (Integer)                *
; *************************************************************
  Lib_Par      retRgb12Color
    And.l      #$F,d3                  ; B4 is already in ..D3
    Move.l     (a3)+,d2                ; Get ..G4
    And.l      #$F,d2
    Move.l     (a3)+,d1                ; Get ..R4
    And.l      #$F,d1
    Lsl.l      #4,d1                   ; Puch R4.. in d1
    Or.l       d1,d2                   ; Put R4G4 in D2
    Lsl.l      #4,d2                   ; Push R4G4.. in d2
    Or.l       d2,d3                   ; D3 = R4G4B4
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getRgb12rColor                            *
; *-----------------------------------------------------------*
; * Description : This method will return the red component   *
; * from a RGB 12 Color value                                 *
; *                                                           *
; * Parameters : D3 = RGB 12 Color value                      *
; *                                                           *
; * Return Value : 4 bits red color component                 *
; *************************************************************
  Lib_Par      getRgb12rColor
    And.l      #$F00,d3
    Lsr.l      #8,d3
    Ret_Int       

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getRgb12gColor                            *
; *-----------------------------------------------------------*
; * Description : This method will return the green component *
; * from a RGB 12 Color value                                 *
; *                                                           *
; * Parameters : D3 = RGB 12 Color value                      *
; *                                                           *
; * Return Value : 4 bits green color component               *
; *************************************************************
  Lib_Par      getRgb12gColor
    And.l      #$F0,d3
    Lsr.l      #4,d3
    Ret_Int       

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getRgb12bColor                            *
; *-----------------------------------------------------------*
; * Description : This method will return the blue component  *
; * from a RGB 12 Color value                                 *
; *                                                           *
; * Parameters : D3 = RGB 12 Color value                      *
; *                                                           *
; * Return Value : 4 bits blue color component                *
; *************************************************************
  Lib_Par      getRgb12bColor
    And.l      #$F,d3
    Ret_Int       


;
; *****************************************************************************************************************************
; *************************************************************
; * MACRO Name : CheckAGARainbowRange                         *
; *-----------------------------------------------------------*
; * Description : This MACRO is used to check if the chosen   *
; * Index fits in the available Aga Rainbow system slot       *
; *                                                           *
; * Parameters : Dreg                                         *
; *                                                           *
; * Additional informations : Can cast an error               *
; *************************************************************
CheckAGARainbowRange MACRO
    cmp.l      #agaRainCnt,\1          ; Uses AMOSProAGA_library_Equ.s/agaRainCnt equate for limit (default = 8)
    Rbge       L_agaErr25              ; errPal25 : The AGA Rainbow index is incorrect. Valid range is 0-3
    cmp.l      #0,\1
    Rbmi       L_agaErr25              ; errPal25 : The AGA Rainbow index is incorrect. Valid range is 0-3
                     ENDM
;
; *****************************************************************************************************************************
; *************************************************************
; * MACRO Name : LoadAGARainbow                               *
; *-----------------------------------------------------------*
; * Description : This macro load the chosen Aga Rainbow buf- *
; * -fer (pointer) into the chosen AReg                       *
; *                                                           *
; * Parameters : DReg = The Aga Rainbow buffer index          *
; *              AReg = The adress register where the pointer *
; *                     will be loaded                        *
; *                                                           *
; *************************************************************
LoadAGARainbow       MACRO
    lea        T_AgaRainbows(a5),\2
    lsl.l      #2,\1
    move.l     (\2,\1.w),\2
    lsr.l      #2,\1
    cmpa.l     #0,\2
                     ENDM

;
; *****************************************************************************************************************************
; *************************************************************
; * MACRO Name : ClearAGARainbow                              *
; *-----------------------------------------------------------*
; * Description : Thie macro simply clear the pointer data    *
; * storage for the chosen aga Rainbow Index                  *
; *                                                           *
; * Parameters : DReg = The Aga rainbow buffer index          *
; *              AReg = The adress register where the pointer *
; *                     will be loaded                        *
; *                                                           *
; * Additional informations : This method does not release the*
; * memory used by the Aga Rainbow buffer for which the poin- *
; * -ter is cleared. The memory must be freed before using    *
; * this macro.                                               *
; *************************************************************
ClearAGARainbow      MACRO
    lea        T_AgaRainbows(a5),\2
    lsl.l      #2,\1
    move.l     #0,(\2,\1.w)
    lsr.l      #2,\1
                     ENDM

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : CreateAgaRainbowBlock                       *
; *-----------------------------------------------------------*
; * Description : This internal method is called by the method*
; * L_createAGAPalette to allocate memory for the aga color   *
; * palette, and insert the CMAP heder in it.                 *
; *                                                           *
; * Parameters : D3 = aga color palette index                 *
; *              D4 = Rainbow lines height                    *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Def      CreateAgaRainbowBlock
    CheckAGARainbowRange d3
    cmp.l      #2,d4
    Rblt       L_agaErr24              ; The amount of lines for an AGA Rainbow must be greater than 2
    move.l     d4,d0                   ; Calculate the size required for the specified amount of lines
    mulu       #3,d0                   ; D0 = D4 * 3 = 3 bytes per color
    add.l      #rainMinStructSize,d0   ; Add the AGA Rainbow structure size
    move.l     d0,d5                   ; Save Buffer Size
    SyCall     MemFastClear
    cmpa.l     #0,a0
    Rbeq       L_agaErr26              ; Cannot alocate memory to create new AGA Rainbow buffer.
    Lea        T_AgaRainbows(a5),a2
    Lsl.l      #2,d3                   ; D3 * 4 for long
    Move.l     a0,(a2,d3.w)            ; Save new AGA Rainbow buffer inside his slot.
    lsr.l      #2,d3
    move.l     #"AMRB",(a0)
    sub.l      #8,d5                   ; Remove "AMRB" and Size from the data size header.
    move.l     d5,R_bufferSize(a0)     ; Save Buffer Real Size
    move.w     d4,R_rainHeight(a0)     ; Save the Aga Rainbow line amount
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_LoadAgaRainboxD3A0                        *
; *-----------------------------------------------------------*
; * Description : Load Aga Rainbow Index D3 pointer to A0     *
; *                                                           *
; * Parameters : D0 = Aga Rainbow Index                       *
; *                                                           *
; * Return Value : A0 = Aga Rainbow buffer memory pointer     *
; *************************************************************
  Lib_Def      LoadAgaRainbowD3A0
    CheckAGARainbowRange d3
    move.l     d3,d4
    Lsl.l      #2,d4                   ; D3 * 4 for long
    Lea        T_AgaRainbows(a5),a0
    move.l     (a0,d4.w),a0
    cmpa.l     #0,a0
    bne.s      .laps
    Rbsr       L_CreateAgaRainbowBlock
.laps:
    Lea        T_AgaRainbows(a5),a0
    move.l     (a0,d4.w),a0
    cmpa.l     #0,a0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_CreateAGARainbow                          *
; *-----------------------------------------------------------*
; * Description : This method will create a new buffer for an *
; * AGA Rainbow                                               *
; *                                                           *
; * Parameters : d3    = Rainbow lines height                 *
; *              (a3)+ = Rainbow ID                           *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par      createAGARainbow
    move.l     d3,d4                   ; D4 = Rainbow Y Size
    move.l     (a3)+,d3                ; D3 = Rainbow ID
    CheckAGARainbowRange d3            ; Check limits for color palette indexes
    LoadAGARainbow d3,a2
    Rbne       L_agaErr29              ; No = The requested Aga rainbow buffer index already exists.
    Rbsr       L_CreateAgaRainbowBlock ; Create the memory block for the chosen Aga Color Palette
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_deleteAGARainbow                          *
; *-----------------------------------------------------------*
; * Description : This method will free the memory used by an *
; * aga rainbow buffer that was allocated using the method na-*
; * -med : L_createAGARainbow                                 *
; *                                                           *
; * Parameters : D3 = AGA Rainbo buffer Bank ID (0-3)         *
; *                                                           *
; *************************************************************
  Lib_Par      deleteAGARainbow
    CheckAGARainbowRange d3
    LoadAGARainbow d3,a1
;    cmpa.l     #0,a1
    Rbeq       L_agaErr30              ; The requested Aga rainbow buffer does not exists.
    ClearAGARainbow d3,a2
    move.b     R_IsActive(a1),d4       ; D4 = Rainbow Visible/Hidden state
    Move.l     R_bufferSize(a1),d0     ; Data buffer Size
    add.l      #8,d0                   ; Add "AMRB" + Size.l to the whole buffer size
    SyCall     MemFree
    cmp.b      #0,d4                   ; Was Rainbow visible or hidden ?
    beq.s      .ende                   ; If hidden -> Jump .ende
    bset       #BitEcrans,T_Actualise(a5) ; Force Full Copper Refresh to remove the delete rainbow
.ende:
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getAgaRainbowExists                       *
; *-----------------------------------------------------------*
; * Description : This method will return 1 if the chosen aga *
; * Rainbow exists, otherwise 0.                              *
; *                                                           *
; * Parameters : D3 = Aga Rainbow Index                       *
; *                                                           *
; * Return Value : 1 or 0 (Integer)                           *
; *************************************************************
  Lib_Par      getAgaRainbowExists
    CheckAGARainbowRange d3
    LoadAGARainbow d3,a2
    beq.s      .gape1
    moveq      #1,d3
    Ret_Int
.gape1:
    moveq      #0,d3
    Ret_Int

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_setAGARainbowColor                        *
; *-----------------------------------------------------------*
; * Description : This method allow the update of an AGA rain-*
; * -bow color at the specified line                          *
; *                                                           *
; * Parameters : D3    = RGB24 Color Value                    *
; *              (a3)+ = The Y Line to update                 *
; *              (a3)+ = The Aga Rainbow Index                *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      setAGARainbowColor
    move.l     d3,d1                   ; D1 = RGB24 Color
    move.l     (a3)+,d2                ; D2 = Y Line to update
    move.l     (a3)+,d3                ; D3 = The Aga Rainbow Index
    CheckAGARainbowRange d3
    LoadAGARainbow d3,a0
    Rbeq       L_agaErr30              ; The requested Aga rainbow buffer does not exists.
    move.w     R_rainHeight(a0),d0     ; D0 = Rainbow Height
    and.l      #$FFFF,d0
    cmp.l      d0,d2                   ; is D2 > D0 (True Height) ?
    Rbge       L_agaErr31              ; The requested line is out of current Aga Rainbow range
    cmp.l      #0,d2                   ; is D2 < 0 (minimal Y line) ?
    Rbmi       L_agaErr31              ; The requested line is out of current Aga Rainbow range
    mulu       #3,d2                   ; Each Color takes 3 Bytes R8,G8 and B8.
    add.l      #R_rainData,d2
    add.l      d2,a0                   ; A2 point to the R8 of the R8G8B8 color
    move.l     d1,d2
    swap       d2
    move.b     d2,(a0)                 ; Save R8 at A2
    move.b     d1,2(a0)                ; Save B8 at A2+2
    lsr.l      #8,d1
    move.b     d1,1(a0)                ; Save G8 at A1+1
    ; **************** Finally, if the Rainbow is in mode "Visible", we force its update in real-time
    move.b     R_IsActive(a0),d2       ; D2 = Copper Visible/Hidden state
    cmp.b      #0,d2                   ; Is Rainbow displayed or hidden ?
    beq.s      .ende                   ; Is Rainbow is not displayed, we do not force full copper refresh
    bset       #BitEcrans,T_Actualise(a5) ; Force Full Copper Refresh
.ende:
    moveq    #0,d0
    rts
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_getAGARainbowColor                        *
; *-----------------------------------------------------------*
; * Description : This method will return the RGB24 color va- *
; * -lue of the color at chosen line in the specified AGA     *
; * rainbow index                                             *
; *                                                           *
; * Parameters : D3    = Y Line                               *
; *              (a3)+ = The Aga Rainbow Index                *
; *                                                           *
; * Return Value : RGB24 Color Value (Integer)                *
; *************************************************************
  Lib_Par      getAGARainbowColor
    move.l     (a3)+,d1                ; D1 = The Aga Rainbow Index
    CheckAGARainbowRange d1
    LoadAGARainbow d1,a0
    Rbeq       L_agaErr30              ; The requested Aga rainbow buffer does not exists.
    move.w     R_rainHeight(a0),d0     ; D0 = Rainbow Height
    and.l      #$FFFF,d0
    cmp.l      d0,d3                   ; is D3 > D0 (True Height) ?
    Rbge       L_agaErr31              ; The requested line is out of current Aga Rainbow range
    cmp.l      #0,d3                   ; is D3 < 0 (minimal Y line) ?
    Rbmi       L_agaErr31              ; The requested line is out of current Aga Rainbow range
    mulu       #3,d3                   ; Each Color takes 3 Bytes R8,G8 and B8.
    add.l      #R_rainData,d3
    add.l      d3,a0                   ; A2 point to the R8 of the R8G8B8 color
    clr.l      d3
    move.b     (a0)+,d3                ; D3 =     R8
    lsl.l      #8,d3                   ; D3 =   R8..
    move.b     (a0)+,d3                ; D3 =   R8G8
    lsl.l      #8,d3                   ; D3 = R8G8..
    move.b     (a0)+,d3                ; D3 = R8G8B8
    Ret_Int
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_SetRainbowHidden                          *
; *-----------------------------------------------------------*
; * Description : This method will remove the rainbow from the*
; * display copper list. It will then be hidden               *
; *                                                           *
; * Parameters : D3 = Aga Rainbow Index (0-3)                 *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      SetRainbowHidden
    CheckAGARainbowRange d3
    LoadAGARainbow d3,a0
    Rbeq       L_agaErr30              ; The requested Aga rainbow buffer does not exists.
    move.b     #0,R_rainHeight(a0)     ; R_rainHeight(a0) = 0 -> Rainbow is hidden
    moveq      #0,d0
    rts
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SetRainbowVisible                           *
; *-----------------------------------------------------------*
; * Description : This method will makes the rainbow visible  *
; *                                                           *
; * Parameters : D3 = Aga Rainbow Index (0-3)                 *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
  Lib_Par      SetRainbowVisible
    CheckAGARainbowRange d3
    LoadAGARainbow d3,a0
    Rbeq       L_agaErr30              ; The requested Aga rainbow buffer does not exists.
    move.b     #1,R_rainHeight(a0)     ; R_rainHeight(a0) = 1 -> Rainbow is visible
    bset       #BitEcrans,T_Actualise(a5) ; Force Full Copper Refresh
.ende:
    moveq    #0,d0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_SetRainbowParams                          *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : D3    = YSHIFT for colors calculation        *
; *              (a3)+ = YPOS copper line where the rainbow   *
; *                      will start to be displayed           *
; *              (a3)+ = Aga Rainbow Index (0-3)              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
  Lib_Par SetRainbowParams
    move.l     (a3)+,d2                ; d2 = YPOS
    move.l     (a3)+,d1                ; d1 = RAINBOWID
    CheckAGARainbowRange d1
    LoadAGARainbow d1,a0
    Rbeq       L_agaErr30              ; The requested Aga rainbow buffer does not exists.
    move.w     d2,R_rainYPos(a0)       ; Save Rainbow Y Position
    move.w     d3,R_rainYShift(a0)     ; Save Rainbow Y Shift
    move.b     R_IsActive(a0),d2       ; D2 = Copper Visible/Hidden state
    cmp.b      #0,d2                   ; Is Rainbow displayed or hidden ?
    beq.s      .ende                   ; Is Rainbow is not displayed, we do not force full copper refresh
    bset       #BitEcrans,T_Actualise(a5) ; Force Full Copper Refresh
.ende:
    moveq    #0,d0
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


























    ; *************************************** Convert D0 -> R4G4B4 to R8G8B8 -> D0
    Lib_Def  rgb4toRgb8
    Movem.l  d1-d2,-(sp)      ; Save D1 & D2
    ; Get RED component from ECS Color and change it to RGB4 ready for RBG8
    Move.w  d0,d1
    And.l   #$F00,d1
    Lsl.l   #8,d1 ; D1 = ..R4..?4..?4
    Move.l  d1,d2         ; Save ..R4..?4..?4 -> D2
    ; Get GREEN component from ECS Color and change it to RGB4 ready for RGB8
    Move.w  d0,d1
    And.l   #$F0,d1
    Lsl.l   #4,d1         ; D1 = ..?4..G4..?4
    Or.l    d1,d2         ; Save RG -> D2 Makes D2 = ..R4..G4..?4
    ; Get BLUE component from ECS Color and change it to RGB4 ready for RGB8
    And.l   #$F,d0        ; D0 = ..?4..?4..B4
    ; Mix the Three components to get in R8G8B8 a content = ..R4..G4..B4
    Or.l    d0,d2         ; D2 = ..R4..G4..B4
    Move.l  d2,d0         ; D0 = ..R4..G4..B4 (=D2)
    Lsl.l   #4,d2         ; D2 = R4..G4..B4..
    Or.l    d2,d0         ; D0 = R4..G4..B4.. + ..R4..G4..B4 = Smooth R8G8B8 from $000000 to $FFFFFF
    Movem.l (sp)+,d1-d2       ; Restores D1 & D2
    rts

    ; *************************************** Convert D0 -> R8G8B8 to R4G4B4 -> D0
    Lib_Def  rgb8toRgb4
    Movem.l d1-d2,-(sp)       ; Save D1 & D2
    And.l #$F0F0F0,d0         ; Filter High values for Red, Green and Blue
    Move.b  d0,d1         ; D1.b = B4..
    Lsr.b   #4,d1         : D1.b = ..B4
    move.w  d0,d2         ; D2.w = G4..B4..
    Lsr.w   #8,d2         ; D2.w = G4..
    Or.b    d2,d1         ; D1 = ..G4B4
    Swap    d0            ; D0 = G4..B4......R4..
    Lsl.w   #4,d0         ; D0 = G4..B4....R4....
    or.b  d1,d0           ; D0 = G4..B4....R4G4B4
    Or.l    #$FFF,d0          ; D0 = ..........R4G4B4
    Movem.l  (sp)+,d1-d2      ; Restores D1 & D2
    rts

;                                                                                                                      ************************
;                                                                                                                                        ***
;                                                                                                                                     ***
; *********************************************************************************************************************************************
;                                                                                           *                                                 *
;                                                                                           * AREA NAME : Methods imported from AmosProAGA.lib*
;                                                                                           *                                                 *
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
; * Method Name : CpInit / RestartWithAGACopperList           *
; *-----------------------------------------------------------*
; * Description : Restart the creation of Copper List setups  *
; *               using AGA capabilities for global color pa- *
; *               -lette registers 032 to 255                 *
; *                                                           *
; * Parameters : D0 = Copper List Length (redefined in)       *
; *                                                           *
; * Return Value : -                                           *
; *************************************************************
    Lib_Def    RestartWithAGACopperList
    move.l     #16384,d0 ; 2019.11.11 Force reserve 16Ko memory for Copper lists instead of default 1Ko
* Reserve la memoire pour les listes
    move.l     d0,T_CopLong(a5)
    SyCall     SyChip                  ; 2020.10.12 Previously : bsr ChipMm
    Beq        inFatalQuit             ; 2020.10.12 Previously : beq GFatal
    move.l     d0,T_CopLogic(a5)
    move.l     T_CopLong(a5),d0
    SyCall     SyChip                 ; 2020.10.12 Previously : bsr ChipMm
    Beq        inFatalQuit             ; 2020.10.12 Previously : beq GFatal
    move.l     d0,T_CopPhysic(a5)
    move.l     d0,a1                   ; A1 = Copper Physic
    move.l     T_CopLogic(a5),a0       ; A0 = Copper Logic
* Copper en ROUTE!
    move.w     #-1,T_CopON(a5)
    Rbra       L_InsertSpritesInCopperList
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsCop / L_InsertSpritesInCopperList         *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
; ********************************************* Insert SPRITES inside the Copper List
    Lib_Def    InsertSpritesInCopperList
HsCop:
    move.l     #$1003FFFE,(a0)         ; Copper 1 : Wait to line raster line 16 (out of screen as screen start near line 50)
    move.l     (a0)+,(a1)+             ; Copper 2 : Copy Wait line from copper 1
    move.w     #$120,d0                ; D0 = 1st sprite register
CpI1:
    move.w     d0,(a0)+                ; Write Sprite register in Copper2, Add +2, A0
    move.w     d0,(a1)+                ; Write Sprite register in Copper2, Add +2, A1
    addq.w     #2,d0                   ; D0 = Next Sprite Register ( 8 sprites * 2 register per sprite (high & low adresses values) ) 
    addq.l     #2,a0                   ; Add + 2, A0 (Sprite register value set to #$0000)
    addq.l     #2,a1                   ; Add + 2, A1 (Sprite register value set to #$0000)
    cmp.w      #$13e,d0                ; Does sprite register reached last one ?
    bls.s      CpI1                    ; Not yet ? -> Jump to CpI1 to continue sprites insertion in Copper lists.
; ************************************************************* 2019.11.13 Insert the AGA color palette at the end of the screen definition - START
; ************************* 2020.08.14 Update to handle RGB24 bits colors 032-255 in the Copper List - Start
; ************************* 2019.11.16 Update : This method insert colors 32 to 255 in the CopperList [D4-D7]
insertAGAColorsInCopper:
    ; ******************************** Insert HIGH Bits of the color table 032-0255
    Move.l     #$1203FFFE,(a0)         ; Wait in copper list 0
    Move.l     (a0)+,(a1)+             ; Wait in copper list 1
    Move.l     a0,T_AgaColor1(a5)
    Move.l     a1,T_AgaColor2(a5)
    lea        T_globAgaPal(a5),a2     ; A2 = First color of AGA palette ( =32 ) of the curent screen (a0)
    Move.l     #$0000,d4               ; (09) LOCT=0 ( High bits )
    bsr        insertAGACIC
    ; ******************************** Insert LOW Bits of the color table 032-0255
    Move.l     a0,T_AgaColor1L(a5)
    Move.l     a1,T_AgaColor2L(a5)
    lea        T_globAgaPalL(a5),a2    ; A2 = First color of AGA palette ( =32 ) of the curent screen (a0)
    Move.l     #$200,d4                ; (09) LOCT=1 ( Low bits )
    bsr        insertAGACIC
    move.w     #BplCon3,(a0)+          ; uses BplCon3 bits 13-15 to set other color palettes in copper list 0
    move.w     #%1000000000000,(a0)+
    move.w     #BplCon3,(a1)+          ; uses BplCon3 bits 13-15 to set other color palettes in copper list 1
    move.w     #%1000000000000,(a1)+
; **************** 2020.10.13 Now, we calculate the size used by Sprites and AGA Color palette so if we add new things, it will be automatically handled - Start
    move.l     T_CopLogic(a5),d1       ; D1 = Start of Logic Copper
    move.l     a0,d0                   ; D0 = Current Logic Copper position
    sub.l      d1,d0                   ; D0 = Shift from Start to current position. Define where to start to populate copper lists.
    move.l     d0,T_EcStartEdit(a5)    ; Save shift to add to define the start position for populate of the copper list
; **************** 2020.10.13 Now, we calculate the size used by Sprites and AGA Color palette so if we add new things, it will be automatically handled - End
    moveq      #0,d0
    rts
inFatalQuit:
    SyJmp      FatalQuit               ; Force AMOS Professioanl to entirely quit if Copper Lists memory blocks cannot be allocated.
insertAGACIC:
    ; ************ Setup inital values for the AGA palette adding to Copper list
    Move.l     #0,d7                   ; D7 = Current Color Palette ( = Initial one )
insert32cLoop:
    addq.w     #1,d7                   ; D7 = Next Palette (ensure we start from colors 32-63)
    cmp.w      #8,d7                   ; if we've pasted the last palette ( total = 256 colors )
    bge.s      insertIsOver            ; Stop when we have reached 256 colors.
    move.l     d7,d6                   ; D6 = D7 = Current Palette
    lsl.l      #5,d6                   ; D6 = Current Palette * 32 colors = 1st color to thread
    lsl.l      #8,d6                   ; Raise D6 to makes bits 0-2 reach 13-15 (lsl.w #5 + #8) for color palette switching
    or.l       d4,d6                   ; 2020.08.13 Update to Add bit clr/set for High/Low color register values
    move.w     #BplCon3,(a0)+          ; uses BplCon3 bits 13-15 to set other color palettes in copper list 0
    move.w     d6,(a0)+                ; Active current palette in bplCon3 register in copper list 0
    move.w     #BplCon3,(a1)+          ; uses BplCon3 bits 13-15 to set other color palettes in copper list 1
    move.w     d6,(a1)+                ; Active current palette in bplCon3 register in copper list 1
    ; * setup for the Copy of the 32 colors registers
    move.w     #Color00,d5             ; D5 = Color00 register
loopCopy:
    move.w     d5,(a0)                 ; insert current color register
    move.w     (a2)+,2(a0)             ; Copy the AgaPal inside the CopperList 0
    move.l     (a0)+,(a1)+             ; Copy Register + Color value from (A0)+ -> (A1)+
    add.w      #2,d5                   ; Jump to next color register
    cmp.w      #Color31,d5
    ble        loopCopy                ; If color <32 then continue the copy
    bra        insert32cLoop           ; Once 32 colors registers were copied, we go back at the beginning of the loop for the next group of colours.
insertIsOver:
    rts




;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TCopOn / L_CopperOnOff                      *
; *-----------------------------------------------------------*
; * Description : This method enable or disable the Amos Pro- *
; *               -fessional copper list system.              *
; *                                                           *
; * Parameters : d1 = Switch value on/off                     *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    CopperOnOff
    tst.w      d1
    bne.s      ICpo1
* Copper OFF -> Hide!
    tst.w      T_CopON(a5)
    beq.s      ICpoX
    clr.w      T_CopON(a5)
    Rbsr       L_ForceFullCopperRefresh ; 2020.10.14 Replace : bsr EcForceCop * CLEAR pointers
    clr.l      T_HsChange(a5)            * Plus de HS!
    move.w     #-1,T_MouShow(a5)        * Plus de souris
    move.l     T_CopLogic(a5),T_CopPos(a5)    * Init!
    SyCallA1   WaitVbl                 ; 2020.10.14 Replace : bsr WVbl
    Rbra       L_CopperSwap            ; 2020.10.14 Replace : bra TCopSw
* Copper ON -> Recalcule!
ICpo1:
    tst.w      T_CopON(a5)
    bne.s      ICpoX
    SyCallA1   WaitVbl                 ; 2020.10.14 Replace : bsr WVbl
    move.l     T_CopLogic(a5),a0       ; Set sprites list
    move.l     a0,a1
    Rbsr       L_InsertSpritesInCopperList ; 2020.10.14 Replace : bsr HsCop
    Rbsr       L_CopperSwapInternal    ; 2020.10.14 Replace : bsr TCpSw
    SyCallA1   WaitVbl                 ; 2020.10.14 Replace : bsr WVbl
    move.l     T_CopLogic(a5),a0
    move.l     a0,a1
    Rbsr       L_InsertSpritesInCopperList ; 2020.10.14 Replace : bsr HsCop
    Rbsr       L_CopperSwapInternal    ; 2020.10.14 Replace : bsr TCpSw
    SyCallA1   WaitVbl                 ; 2020.10.14 Replace : bsr WVbl
    move.w     #-1,T_CopON(a5)        * Remet!
    SyCall     AffHs                   ; 2020.10.14 Replace bsr HsAff
    clr.w      T_MouShow(a5)
    Rbsr       L_ForceFullCopperRefresh ; 2020.10.14 Replace : bsr EcForceCop * CLEAR pointers
    SyCallA1   WaitVbl                 ; 2020.10.14 Replace : bsr WVbl
ICpoX:
    moveq      #0,d0
    rts











;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcForceCop / L_ForceFullCopperRefresh       *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    ForceFullCopperRefresh
    addq.w     #1,T_EcYAct(a5)         ; Enforce re-calculation for screens.
    Rbra       L_CopperRefresh

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcCopper / L_CopperRefresh                  *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    CopperRefresh
    movem.l    d1-d7/a1-a6,-(sp)       ; Standard entrance

; Continue actualisation
    move.w     T_EcYAct(a5),d7         ; D7 = counter for Y cutting action on screens
    lea        T_EcPri(a5),a0          ; A0 = Pointer to the 1st screen in the screen priorities list
    move.l     (a0)+,d0                ; D0 = Current Screen structure address.
    beq        EcA6                    ; if D0 = 0 -> jump to EcA6.
    bmi        EcActX                  ; If ScreenID < 0 -> Jump to ExActX (refresh its closure/end ?)
EcAct0:                                ; If ScreenID > 0 refresh its opening
    move.l     d0,a1                   ; A1 = D0 = current Screen Structure

******************** Check for changes on Y Position
    move.b     EcAW(a1),d0             ; D0 = Current view update settings (flags)
    beq.s      EcA2                    ; if no changes -> Jump to EcAa
    btst       #2,d0                   ; Check if Y changes are required or not
    beq.s      EcAct1                  ; if no Y Changes -> Jump to ExAct1 ( Check for X position changes )
    move.w     EcAWY(a1),d1            ; D1 = requested Y position
    add.w      #EcYBase,d1             ; D1 + EcYBase
    bpl.s      EcAa                    ; if positif -> Jump to EcAa
    moveq      #0,d1                   ; if negative, clear D1.
EcAa:
    move.w     d1,EcWy(a1)             ; Save final Y position on EcWy register of current screen structure
    addq.w     #1,d7                   ; increase D7+1 counter

******************** Check for changes on X Position
EcAct1:
    btst       #1,d0                   ; Check if X changes are requires or not
    beq.s      EcAct2                  ; If no changes on X -> Jump to ExAct2
    move.w     EcAWX(a1),d1            ; D1 = Requested X Position
    and.w      #$FFF0,d1               ; Fix D1 to 4 bits alignment.
    move.w     d1,EcWx(a1)             ; Save final X position on EcWx register of current screen structure
EcAct2:
    clr.w     EcAW(a1)                 ; Once changes are done, we reset the current screen EcAW flags

******************** Check on changes concerning screen Height display
EcA2:
    move.b     EcAWT(a1),d0            ; D0 = Current View sizes update settings (flags)
    beq.s      EcA4                    ; if no changes -> Jump to EcA4
    btst       #2,d0                   ; Check if Height Changes are required or not
    beq.s      EcAct3                  ; if no Height changes -> Jump to EcAct3 ( Check for Width changes )
    move.w     EcAWTY(a1),d1           ; D1 = Requested Height
    beq.s      EcAct3                  ; If = 0 -> Jump to EcAct3 ( Check for Width changes )
    cmp.w      EcTy(a1),d1             ; Compare current Height with new one
    bcs.s      EcAc                    ; 
EcAg:
    move.w     EcTy(a1),d1             ; D1 = Current screen display Height
EcAc:
    btst       #2,EcCon0+1(a1)         ; Check for Interlace mode                  // 2019.11.05 Check in .b mode to be sure default is not .w
    beq.s      EcA2a                   ; If Not Interlaced -> Jump to EcA2a
    lsr.w      #1,d1                   ; if Interlaced : Height = Height / 2 
EcA2a:
    move.w     d1,EcWTy(a1)            ; Save final Height D1 to EcWTy
    addq.w     #1,d7                   ; increase D7+1 counter

******************** Check on changes concerning screen Width display
EcAct3:
    btst       #1,d0                   ; Check if Width changes are required or not
    beq.s      EcAct4                  ; if no changes -> Jump to EcAct4
    move.w     EcAWTX(a1),d1           ; D1 = Requested Width
    and.w      #$FFF0,d1               ; Fix D1 on 4 bits alignment.
    beq.s      EcAct4                  ; if D1 = 0 -> Jump to EcAct4
    move.w     EcTx(a1),d2             ; D2 = Current Screen display width
    tst.w      EcCon0(a1)              ; Check current screen BplCon0 save value
    bpl.s      EcAe                    ; if current Screen EcCon0 > 0 (not hires but lowres)  -> Jump to EcAe
    lsr.w      #1,d2                   ; if Hires D2 = D2 / 2
EcAe:
    cmp.w      d2,d1                   ; Compare calculated Width with requested one
    bcs.s      EcAf                    ; if d2 > d1 jump EcAf
    move.w     d2,d1                   ; D1 = D2
EcAf:
    move.w     d1,EcWTx(a1)            ; Save final Width D1 to EcWTx

EcAct4:
    clr.w      EcAWT(a1)               ; Once changes are done, we reset the current screen EcAWT flags

******************** Check on changes concerning screen OY. ????
EcA4:
    move.b     EcAV(a1),d0
    beq.s      EcA6
    btst       #2,d0
    beq.s      EcAct5
    move.w     EcAVY(a1),EcVY(a1)

******************** Check on changes concerning screen OX. ????
EcAct5:
    btst       #1,d0
    beq.s      EcAct6
    move.w     EcAVX(a1),EcVX(a1)
EcAct6:
    clr.w      EcAV(a1)                ; Once changes are done, we reset the current screen EcAV flags

EcA6:
    move.l     (a0)+,d0                ; Get next Screen pointer
    beq.s      EcA6                    ; If no more screen are requested -> Jump to EcA6
    bpl        EcAct0                  ; if some screens still un handled, loop to EcAct0 to handle next screen of the list


******************** Are there some news Y/TY/Priorities to calculate ?
EcActX:
    move.l     T_EcCop(a5),a1          ; A1 = Copper list address.

    tst.w      d7                      ; Check for changes in Y / TY / Priorities
    beq        PaDecoup                ; if no changes are required -> Jump to PaDecoup (no screens cutting, no calculation)
    clr.w      T_EcYAct(a5)            ; Clear the T_EcYAct register

******************** This part will cut screens in parts
    lea        T_EcBuf(a5),a3          ; A3 = Screen buffers list
    moveq      #0,d2                   ; D2 = Current display raster Y Position
MkD0:
    lea        T_EcPri(a5),a2          ; A2 = Screen priority list pointer
    move.w     #10000,d3               ; D3 = Bottom Y Limit
    moveq      #-1,d5
    moveq      #0,d1

MkD1:
    addq.w    #4,d1                     ; D1+4
    move.l    (a2)+,d0                 ; Get next Screen Structure pointer from the screen priority list (A2)
    bmi.s    MkD3                     ; if Screen Pointer < 0 ( Negative ) -> Jump to MkD3 (list fully explored)
    beq.s    MkD1                     ; if Screen Pointer = 0 -> Jump to MkD1 ( no more screen to cut)
    move.l    d0,a0                     ; A0 = current Screen Structure Pointer
    tst.b    EcFlags(a0)             ; Test current screen EcFlags
    bmi.s    MkD1                     ; if EcFlags(a0) <0 (Bit15=%1) then -> Loop to MkD1 to check next screen
    move.w    EcWy(a0),d0             ; D0 = current screen Window Y position
    subq.w    #1,d0                     ; D0-1
    cmp.w    d2,d0                     ; Compare current screen Y Window position to current raster Y Position
    bls.s    MkD2                     ; if D2 <= D0 -> Jump to MkD2
    cmp.w    d3,d0                     ; Compare Maximum Raster Y Position (#10000 defined upper)
    bcc.s    MkD2                    ; if d3 > d0 ( no C register c for carrying overtaking, restraint )
    move.w    d0,d3                     ; Update D3 Limits = D0 
    move.w    d3,d4                     ; Copy D3 -> D4
    add.w    EcWTy(a0),d4             ; D4 + Current Screen Window TY
    addq.w    #1,d4                     ; D4+1
    move.w    d1,d5                     ; D5 = D1
    bra.s    MkD1                     ; Jump to MkD1
MkD2:
    add.w    EcWTy(a0),d0
    addq.w    #1,d0
    cmp.w    d2,d0
    bls.s    MkD1
    cmp.w    d3,d0
    bcc.s    MkD1
    move.w    d0,d3
    move.w    d1,d5
    bset     #15,d5
    bra.s    MkD1

MkD3:
    cmp.w    #-1,d5            ;Fini?
    beq.s    MkD5
    cmp.w    #EcYStrt-1,d2        ;Passe le haut de l''ecran?
    bcc.s    MkD3a
    cmp.w    #EcYStrt-1,d3
    bcs.s    MkD3a    
    move.w    #EcYStrt-1,(a3)+    ;Marque le haut de l''ecran
    clr.w    (a3)+
    move.w    #$8000,(a3)+
    
MkD3a:    
MkD3b:
    move.w    d3,(a3)+
    move.w    d4,(a3)+
    move.w    d5,(a3)+
; Re-Explore la liste en cas d''egalite SI DEBUT DE FENETRE
    and.w    #$7fff,d5
    lea    T_EcPri(a5),a2
    moveq    #0,d1

MkD4:    addq.w    #4,d1
    move.l    (a2)+,d0
    bmi.s    MkD4a
    beq.s    MkD4
    move.l    d0,a0
    tst.b    EcFlags(a0)
    bmi.s    MkD4
    move.w    EcWy(a0),d0
    subq.w    #1,d0
    cmp.w    d0,d3
    bne.s    MkD4
    cmp.w    d5,d1
    beq.s    MkD4
    move.w    d3,(a3)+
    move.w    d3,d4
    addq.w    #1,d4
    add.w    EcWTy(a0),d4
    move.w    d4,(a3)+
    move.w    d1,(a3)+
    bra.s    MkD4
; Remonte la limite
MkD4a:    move.w    d3,d2
    bra    MkD0
; Fin de la liste
MkD5:    move.w    #-1,(a3)+

PaDecoup:

;-----> Analyse de la table / creation de la liste
    clr.w    T_InterInter(a5)
    lea    T_EcPri(a5),a2
    lea    T_EcBuf(a5),a3
MkA1:
    move.w    (a3),d0
    bmi    MkAFin
    move.w    2(a3),d1
    move.w    4(a3),d2
    bmi    MkA4
; Debut d''une fenetre: doit-on l''afficher?
    lea    T_EcBuf(a5),a0
MkA2:
    cmp.l    a3,a0
    bcc    MkA8
    tst.w    4(a0)
    bmi.s    MkA3
    cmp.w    (a0),d0
    bcs.s    MkA3
    cmp.w    2(a0),d0
    bcc.s    MkA3
    cmp.w    4(a0),d2
    bcc    MkA10
MkA3:
    lea    6(a0),a0
    bra.s    MkA2

; Fin d''une fenetre: doit-on en reafficher une autre?    
MkA4:
    and.w    #$7FFF,d2
    cmp.w    #$100,d2        ;Si fin de l''ecran --> marque!
    beq    MkA9a

    clr.w    d3    
MkA4a:
    addq.w    #6,d3            ;Cherche UN DEBUT devant
    cmp.w    0(a3,d3.w),d0
    bne.s    MkA4b
    tst.w    4(a3,d3.w)
    bmi.s    MkA4a
    lea    0(a3,d3.w),a3        ;Va faire le debut!
    bra    MkA1

MkA4b:
    lea    T_EcBuf(a5),a0        ;Cherche la fenetre a reafficher
    move.w    #1000,d3
MkA5:
    cmp.l    a3,a0
    bcc.s    MkA7
    tst.w    4(a0)
    bmi.s    MkA6
    cmp.w    (a0),d0
    bcs.s    MkA6
    cmp.w    2(a0),d0
    bcc.s    MkA6
    cmp.w    4(a0),d3
    bcs.s    MkA6
    move.w    4(a0),d3
MkA6:
    lea    6(a0),a0
    bra.s    MkA5
MkA7:
    cmp.w    #1000,d3
    beq.s    MkA9
    cmp.w    d2,d3
    bls.s    MkA10
    move.w    d3,d2        
; Peut creer la fenetre
MkA8:
    move.l    -4(a2,d2.w),a0
    move.w    (a3),d0
    cmp.w    #EcYStrt-1,d0        * Sort en haut?
    bcs.s    MkA10
    move.w    T_EcYMax(a5),d1        * Sort en bas?
    subq.w    #2,d1
    cmp.w    d1,d0
    bcc.s    MkA10
    move.w    d0,(a1)+
    move.l    a0,(a1)+
    btst    #2,EcCon0+1(a0)
    beq.s    MkA10
    move.w    #%100,T_InterInter(a5)
    bra.s    MkA10
; Fin normale de la fenetre
MkA9:
    tst.w    d2
    beq.s    MkA10
    move.w    (a3),d0
MkA9a:
    cmp.w    #EcYStrt-1,d0
    bcs.s    MkA10
    move.w    T_EcYMax(a5),d1
    subq.w    #1,d1
    cmp.w    d1,d0
    bcc.s    MkA11
    neg.w    d0
    move.w    d0,(a1)+
; Passe a une autre
MkA10:
    lea    6(a3),a3
    bra    MkA1
; C''est la fin
MkA11:
    neg.w    d1
    move.w    d1,(a1)+
* Marque la fin des ecrans
MkAFin:
    clr.w    (a1)

*******    Populate the Copper list With/Without Rainbows
CLPopulate:                                ; // 2019.11.05 Useless Reference added for faster search on copper update
; No screen swap
    clr.w    T_Cop255(a5)
    clr.w    T_InterBit(a5)
    clr.l    T_SwapList(a5)
; Clean markers
    clr.l    T_CopMark+CopL1*0(a5)             ; Clear Screen  0 Mark Offset 0    Copper 1      0
    clr.l    T_CopMark+CopL1*0+64(a5)          ; Clear Screen  0 Mark Offset 64   Copper 1     64
    clr.l    T_CopMark+CopL1*1(a5)             ; Clear Screen  1 Mark Offset 0    Copper 1    128
    clr.l    T_CopMark+CopL1*1+64(a5)          ; Clear Screen  1 Mark Offset 64   Copper 1    192
    clr.l    T_CopMark+CopL1*2(a5)             ; Clear Screen  2 Mark Offset 0    Copper 1    256
    clr.l    T_CopMark+CopL1*2+64(a5)          ; Clear Screen  2 Mark Offset 64   Copper 1    320
    clr.l    T_CopMark+CopL1*3(a5)             ; Clear Screen  3 Mark Offset 0    Copper 1    384
    clr.l    T_CopMark+CopL1*3+64(a5)          ; Clear Screen  3 Mark Offset 64   Copper 1    448
    clr.l    T_CopMark+CopL1*4(a5)             ; Clear Screen  4 Mark Offset 0    Copper 1    512
    clr.l    T_CopMark+CopL1*4+64(a5)          ; Clear Screen  4 Mark Offset 64   Copper 1    576
    clr.l    T_CopMark+CopL1*5(a5)             ; Clear Screen  5 Mark Offset 0    Copper 1    640
    clr.l    T_CopMark+CopL1*5+64(a5)          ; Clear Screen  5 Mark Offset 64   Copper 1    704
    clr.l    T_CopMark+CopL1*6(a5)             ; Clear Screen  6 Mark Offset 0    Copper 1    768
    clr.l    T_CopMark+CopL1*6+64(a5)          ; Clear Screen  6 Mark Offset 64   Copper 1    832
    clr.l    T_CopMark+CopL1*7(a5)             ; Clear Screen  7 Mark Offset 0    Copper 1    896
    clr.l    T_CopMark+CopL1*7+64(a5)          ; Clear Screen  7 Mark Offset 64   Copper 1    960
    clr.l    T_CopMark+CopL1*8(a5)             ; Clear Screen  8 Mark Offset 0    Copper 1   1024
    clr.l    T_CopMark+CopL1*8+64(a5)          ; Clear Screen  8 Mark Offset 64   Copper 1   1088
    clr.l    T_CopMark+CopL1*9(a5)             ; Clear Screen  9 Mark Offset 0    Copper 1   1152
    clr.l    T_CopMark+CopL1*9+64(a5)          ; Clear Screen  9 Mark Offset 64   Copper 1   1216
    clr.l    T_CopMark+CopL1*10(a5)            ; Clear Screen 10 Mark Offset 0    Copper 1   1280
    clr.l    T_CopMark+CopL1*10+64(a5)         ; Clear Screen 10 Mark Offset 64   Copper 1   1344
    clr.l    T_CopMark+CopL1*11(a5)            ; Clear Screen 11 Mark Offset 0    Copper 1   1408
    clr.l    T_CopMark+CopL1*11+64(a5)         ; Clear Screen 11 Mark Offset 64   Copper 1   1472
    clr.l    T_CopMark+CopL1*12+CopL2*0(a5)    ; Clear Copper 2 Mark                         1536
    clr.l    T_CopMark+CopL1*12+CopL2*1(a5)    ; Clear Copper 2 Mark                         1600
    clr.l    T_CopMark+CopL1*12+CopL2*2(a5)    ; Clear Copper 2 Mark                         1664
    clr.l    T_CopMark+CopL1*12+CopL2*3(a5)    ; Clear Copper 2 Mark                         1728
    clr.l    T_CopMark+CopL1*12+CopL2*4(a5)    ; Clear Copper 2 Mark                         1792
    clr.l    T_CopMark+CopL1*12+CopL2*5(a5)    ; Clear Copper 2 Mark                         1856
    clr.l    T_CopMark+CopL1*12+CopL2*6(a5)    ; Clear Copper 2 Mark                         1920
    clr.l    T_CopMark+CopL1*12+CopL2*7(a5)    ; Clear Copper 2 Mark                         1984
    clr.l    T_CopMark+CopL1*12+CopL2*8(a5)    ; Clear Copper 2 Mark                         2048
    clr.l    T_CopMark+CopL1*12+CopL2*9(a5)    ; Clear Copper 2 Mark                         2112
;                                                                                            2176 End Of CopMark Memory Block

    ; *********************** Is AMOS Copper enabled/disabled ?
    tst.w      T_CopON(a5)             ; Check if AMOS Auto copperlist is enabled or disable
    beq        PasCop                  ; if AMOS copper is disabled, no new copper calculation.

    ; **************** The Logic copper already contains sprites datas & 2020.01.01 AGA Palette addon is on AGA chipset
    move.l     T_CopLogic(a5),a1       ; send LOGIC copper addres into -> A1 (Work is always donc on logic version, not physic one.)
    ; ******************************* 2020.01.01 Add detection for AGA support
    move.l     T_EcStartEdit(a5),d0    ; 2020.10.13 Read shift to add to define the start position for populate of the copper list
    add.l      d0,a1                   ; 2020.10.13 Push A1 to the position where you can start to edit.
CpNxt:
    ; ******************************* 2020.01.01 End of : Add detection for AGA support.
* Rainbow?
    tst.w      T_RainBow(a5)
    Rbra       L_updateCopperRainbows  ; 2020.10.14 Replaced : bne.s CopBow ; If a RAINBOW is created/active, then jump to Rainbow update
    ; **************** Normal COPPER creation
MCop0:
    move.l     T_EcCop(a5),a2          ; Send screen list adress into ->A2
MCop1:
    move.w     (a2)+,d0                ; Send screen count ? into ->D0
    beq.s      MCopX                   ; if =0 -> No screen -> Jump to MCopX
    bmi.s      MCop2                   ; If ScreenID < 0 -> We must add the line that closes the screen (Y End)
    ; **************** A Screen is defined, we must insert it in the CopperList
    move.l     (a2)+,a0                ; A0 = Current Screen structure adress
    Rbsr       L_InsertScreenInCopper  ; 2020.10.14 Replaced : bsr EcCopHo ; (Jump with come back) -> Insert the current screen definition line in the AMOS Copper List.
    bra.s      MCop1                   ; Once the current screen was added in the copper list -> Loop to NCop1
    ; **************** Now we must insert the closure of a screen
MCop2:
    neg.w      d0                      ; D0 = 0-ScreenID so we neg it to get the true screen ID.
    Rbsr       L_EndOfScreenCopper     ; 2020.10.14 Replaced : bsr EcCopBa ; (Jump with come back) -> Method that wait the last line of the current screen and closes it
    bra.s      MCop1                   ; Once screen was closed, we loop to NCop1 to check if another screen is defined
    ; **************** We have now reached the end of the Copper list.
MCopX:
    subq.l     #2,a2
    cmp.l      T_EcCop(a5),a2
    bne.s      .Skip
    move.w     T_EcYMax(a5),d0
    subq.w     #1,d0
    Rbsr       L_EndOfScreenCopper     ; 2020.10.14 Replaced : bsr EcCopBa ; (Jump with come back) -> Method that wait the last line of the current screen and closes it
.Skip
    move.l     #$FFFFFFFE,(a1)+        ; Insert the last line of the Copper List.
*******    Swappe les listes
MCopSw:
    move.l     T_CopLogic(a5),a0
    move.l     T_CopPhysic(a5),a1
    move.l     a1,T_CopLogic(a5)
    move.l     a0,T_CopPhysic(a5)
* Poke dans le copper, si AMOS est la!
    tst.b      T_AMOSHere(a5)
    beq.s      PasCop
    move.l     a0,Circuits+Cop1lc
    move.w     T_InterInter(a5),T_InterBit(a5)
* Fini!
PasCop:
    movem.l    (sp)+,d1-d7/a1-a6
    moveq      #0,d0
    rts









;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : CopBow / L_updateCopperRainbows             *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
******* Actualise les RAINBOWS
    Lib_Def    updateCopperRainbows
    lea        T_RainTable(a5),a0
    moveq      #0,d4
    moveq      #NbRain-1,d6
    moveq      #0,d5
RainA1:
    tst.w      RnLong(a0)
    beq.s      RainA5
    addq.w     #1,d5
    tst.w      RnI(a0)
    bmi.s      RainA5
    addq.w     #1,d4
    move.b     RnAct(a0),d7
    beq.s      RainA5
    clr.b      RnAct(a0)
* Taille en Y
    bclr       #0,d7
    beq.s      RainA2
    move.w     RnI(a0),d0
    move.w     d0,RnTY(a0)
    bset       #2,d7
* Position en Y
RainA2:
    bclr       #2,d7
    beq.s      RainA4
    clr.l      RnDY(a0)
    move.w     RnY(a0),d1
    cmp.w      #28,d1
    bcc.s      RainA3
    moveq      #28,d1
RainA3:
    move.w     RnTY(a0),d0
    add.w      #EcYBase,d1
    move.w     d1,RnDY(a0)
    add.w      d0,d1
    move.w     d1,RnFY(a0)
* Position de la base
RainA4:
    bclr       #1,d7
    beq.s      RainA5
    move.w     RnX(a0),d0
    lsl.w      #1,d0
    cmp.w      RnLong(a0),d0
    bcc.s      RainA5
    lsr.w      #1,d0
    move.w     d0,RnBase(a0)
* Rainbow suivant
RainA5:
    lea        RainLong(a0),a0
    dbra       d6,RainA1
* Securite!
    move.w     d5,T_RainBow(a5)
    tst.w      d4
    beq        MCop0

******* Fabrique la liste
    move.l     T_EcCop(a5),a2
    move.w     #EcYBase,d0
    moveq      #-1,d3
    moveq      #-1,d4
    moveq      #0,d7
Rain1:
    move.w     (a2)+,d1
    beq        Rain3
    bmi.s      Rain2
* Debut d''un ecran
    bsr        Rain
    move.l     (a2)+,a0
    movem.l    d0/d3-d7,-(sp)
    Rbsr       L_InsertScreenInCopper  ; 2020.10.14 Replaced : bsr EcCopHo ; (Jump with come back) -> Insert the current screen definition line in the AMOS Copper List.
    movem.l    (sp)+,d0/d3-d7
    clr.w      d3
    tst.w      d4
    bmi.s      Rain1e
    cmp.w      #PalMax*4,d4
    bcs.s      Rain1d
    lea        64(a4),a4
Rain1d:
    move.l     (a4),a0    
    move.w     2(a0,d4.w),d3
    bclr       #31,d3
Rain1e:
    cmp.w      d7,d0
    bcc.s      Rain1a
    move.w     (a3)+,2(a0,d4.w)
    cmp.l      a6,a3
    bcs.s      Rain1a
    move.l     d6,a3
Rain1a:
    addq.w     #1,d0
    move.w     (a2),d1
    bpl.s      Rain1b
    neg.w      d1
Rain1b:
    cmp.w      d0,d1
    beq.s      Rain1
    cmp.w      d7,d0
    bcc.s      Rain2a
    move.w     d5,(a1)+
    move.w     (a3)+,(a1)+
    bra.s      Rain1c
* Fin d''un ecran
Rain2:
    neg.w      d1
    bsr        Rain
    Rbsr       L_EndOfScreenCopper     ; 2020.10.14 Replaced : bsr EcCopBa ; (Jump with come back) -> Method that wait the last line of the current screen and closes it
    tst.w      d4
    bne.s      Rain1b
    move.w     T_EcFond(a5),d3
    cmp.w      d7,d0
    bcc.s      Rain2a
    move.l     a1,a0            * Recherche la couleur
Rain1z:
    cmp.w      #$0180,-(a0)
    bne.s      Rain1z
    move.w     (a3)+,2(a0)
Rain1c:
    cmp.l      a6,a3
    bcs.s      Rain2a
    move.l     d6,a3
Rain2a:
    addq.w     #1,d0
    bra        Rain1
* Fin des ecrans
Rain3:
    subq.l     #2,a2
    cmp.l      T_EcCop(a5),a2
    bne.s      .Skip
    move.w     T_EcYMax(a5),d0
    subq.w     #1,d0
    bsr        Rain
    Rbsr       L_EndOfScreenCopper     ; 2020.10.14 Replaced : bsr EcCopBa ; (Jump with come back) -> Method that wait the last line of the current screen and closes it
.Skip:
    move.l     #$FFFFFFFE,(a1)+
    bra        MCopSw
******* Fabrique le rainbow ---> Y=D1
RainD1:
    move.w     d0,d2
    sub.w      #EcYBase,d2
    cmp.w      #256,d2            * Attente -> ligne -> D0
    bcs.s      RainD2
    tst.w      T_Cop255(a5)
    bne.s      RainD2
    move.w     #$FFE1,(a1)+
    move.w     #$FFFE,(a1)+
    addq.w     #1,T_Cop255(a5)
RainD2:
    lsl.w      #8,d2    
    or.w       #$03,d2
    move.w     d2,(a1)+
    move.w     #$FFFE,(a1)+
    move.w     d5,(a1)+        * Change la couleur
    move.w     (a3)+,(a1)+
    cmp.l      a6,a3
    bcs.s      RainD3
    move.l     d6,a3
RainD3:
    addq.w     #1,d0
* Entree!
Rain:
    cmp.w      d7,d0
    bcc.s      RainNX
RainD0:
    cmp.w      d1,d0
    bcs.s      RainD1
RainDX:
    move.w     d1,d0    
    rts
******* Trouve le rainbow comprenant D0
RainNX:
    tst.l      d3
    bmi.s      RainN0
    tst.w      d3            * Si RIEN au dessus
    bpl.s      Rain0a
    move.w     #Color00,(a1)+        * Couleur 0 d''office!
    move.w     T_EcFond(a5),(a1)+
    bset       #31,d3
    bra.s      RainN0
Rain0a:
    move.w     d5,(a1)+
    move.w     d3,(a1)+
    bset       #31,d3
RainN0:
    lea        T_RainTable(a5),a0    * Cherche le 1er
    moveq      #NbRain-1,d2
RainN1:
    cmp.w      (a0),d0
    bcs.s      RainN2
    cmp.w      RnFY(a0),d0
    bcs.s      RainN5
RainN2:
    lea        RainLong(a0),a0
    dbra       d2,RainN1    
    lea        T_RainTable(a5),a0    * Trouve le 1er plus bas
    moveq      #0,d7
    moveq      #NbRain-1,d2
    move.w     d1,d6
RainN3:
    cmp.w      RnFY(a0),d0
    bcc.s      RainN4
    cmp.w      (a0),d1
    bcs.s      RainN4
    cmp.w      (a0),d6
    bcs.s      RainN4
    move.w     (a0),d6
    move.l     a0,d7
RainN4:
    lea        RainLong(a0),a0
    dbra       d2,RainN3
    tst.l      d7
    beq        RainDX
    move.l     d7,a0
    move.w     (a0),d0
* Debut d''un RainBow
RainN5:
    move.w     d0,d5
    sub.w      (a0),d5
    add.w      RnBase(a0),d5
    lsl.w      #1,d5
    move.l     RnBuf(a0),d6
    move.l     d6,a3
    move.l     a3,a6
    add.w      RnLong(a0),a6
    add.w      d5,a3
    cmp.l      a6,a3
    bcs.s      RainD7
RainN6:
    sub.w      RnLong(a0),a3
    cmp.l      a6,a3
    bcc.s      RainN6
RainD7: 
   move.w      RnFY(a0),d7
* Nouvelle couleur
    move.w     d4,d2    
    move.w     RnColor(a0),d4
    move.w     d4,d5
    lsl.w      #2,d4
    lsl.w      #1,d5
    add.w      #Color00,d5
* Reprend la couleur!
    tst.w      d3
    bmi.s      RainD9
    cmp.w      d4,d2
    beq.s      RainD9
    move.l     (a4),a0
    move.w     2(a0,d4.w),d3
RainD9:
    bclr       #31,d3
    bra        RainD0







;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcCopHo / L_InsertScreenInCopper            *
; *-----------------------------------------------------------*
; * Description : This method replaces the EcCopHo method from*
; *               the AmosProAGA.library to support AGA       *
; *                                                           *
; * Parameters : D0 = Y Screen Position                       *
; *              A0 = Screen Structure Adress                 *
; *              A1 = Copper List to update                   *
; *              A2 = Screen List (For Dual Playfield mode)   *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    InsertScreenInCopper
    rts
* Decalage PHYSIQUE dans la fenetre
    move.w     d0,d1             ; Move Screen Y Pos from D0 -> D1
    sub.w      EcWy(a0),d1       ; Substract requires screen Y Pos to D1
    addq.w     #1,d1
    btst       #2,EcCon0+1(a0)        * par 2 si entrelace!
    beq.s      MkC4a
    lsl.w      #1,d1
MkC4a    
* Attend jusqu''a la ligne D0
    move.w     d0,d2
    sub.w      #EcYBase,d2
    Rbsr       L_newWaitD2              ; 20.10.14 Replaced : bsr WaitD2
* Prepare view
    move.w     #DmaCon,(a1)+           ; Send data to DMACON register
    move.w     #$0100,(a1)+            ; Stop All DMA except Bit Plane DMA
* Beginning of the color palette
    move.l     a1,-(sp)
    moveq      #PalMax-1,d3            ; D3 = Amount of colors to copy to the copper list ( the colors 00-15 only as PalMax=16 )
    move.w     #Color00,d2             ; D2 = 1st Color Register ( Color #00 )
    lea        EcPal(a0),a4            ; A4 = Screen color table pointer
MkC5:                                  ; Loop to put then entire screen palette in the copper list
    move.w     d2,(a1)+                ; Insert color register DFF180-DFF1BE into copper
    addq.w     #2,d2                   ; Go to next color register
    move.w     (a4)+,(a1)+             ; Copy color data from screen palette inside copper list
    dbra       d3,MkC5                 ; End of color copy into copper list loop.

; ( 16 colors +  BplCon3 ) * ( 2 reg + 2 datas ) ) = 68
; ********************************************* 2020.08.14 Add support for RGB24 bits colors 000-015 - START
    move.w     #BplCon3,(a1)+          ; 2019.11.04 Added BplCon3 to support dual playfield 2x16 colors
    move.w     #%1001000000000,(a1)+   ; 2020.08.14 Makes LOCT = 1, PF2OF2 = 1
    moveq      #PalMax-1,d3            ; D3 = Amount of colors to copy to the copper list ( the colors 00-15 only as PalMax=16 )
    move.w     #Color00,d2             ; D2 = 1st Color Register ( Color #00 )
    lea        EcPalL(a0),a4           ; A4 = Screen color table pointer
MkC5b:                                 ; Loop to put then entire screen palette in the copper list
    move.w     d2,(a1)+                ; Insert color register DFF180-DFF1BE into copper
    addq.w     #2,d2                   ; Go to next color register
    move.w     (a4)+,(a1)+             ; Copy color data from screen palette inside copper list
    dbra       d3,MkC5b                ; End of color copy into copper list loop.
    move.w     #BplCon3,(a1)+
    move.w     #%1000000000000,(a1)+   ; 2020.08.14 Makes LOCT = 0, PF2OF2 = 1
; ********************************************* 2020.08.14 Add support for RGB24 bits colors 000-015 - END

* Dual playfield???
    move.w     EcDual(a0),d2           ; If screen is attached to another in DualPlayfield mode
    Rbra       L_CreateDuaplPlayfield  ; 2020.10.14 Replaced : bne CreeDual ; -> Then jump to 2nd screen copper list definition.
PluDual:
* Ecran normal!
    add.w      EcVY(a0),d1             ; D1 = How many lines to scroll
    mulu       EcTLigne(a0),d1 ;       ; D1 = Bytes shift for Y scrolling ( how many lines * 1 line byte size)
    move.w     EcVX(a0),d2             ; D2 = X Scrolling (from left-right)
    ; ************************ 2019.11.19 Update for Fetch mode 1 scrolling?
    tst.w      EcFMode(a0)             ; 2019.11.19 Add -8 if FMode is active
    beq        .noFetchChanges4BPL
    lsr.w      #5,d2                   ; To make scrolling be 64 bits instead of 16 bits initial.
    lsl.w      #2,d2
    bra        .bplct
.noFetchChanges4BPL:
    lsr.w      #4,d2
    lsl.w      #1,d2
.bplct:
    add.w      d2,d1
    move.l     a1,d3
* Poke les adresses des bitplanes

    moveq      #EcPhysic,d2
    move.w     EcNPlan(a0),d6
    subq.w     #1,d6
    move.w     #Bpl1PtH,d7
MkC0:
    move.l     0(a0,d2.w),d5
    add.l      d1,d5
    move.w     d7,(a1)+
    addq.w     #2,d7
    swap       d5
    move.w     d5,(a1)+
    move.w     d7,(a1)+
    addq.w     #2,d7
    swap       d5
    move.w     d5,(a1)+
    addq.l     #4,d2
    dbra       d6,MkC0
* Marque les adresses SCREEN SWAP
    move.w     EcNumber(a0),d2        * Marque les adresse 
    cmp.w      #10,d2            * Si ecran utilisateur!
    bcc.s      MrkC2
    lsl.w      #6,d2
    lea        CopL1*EcMax+T_CopMark(a5),a4
    add.w      d2,a4
MrkC1:
    tst.l      (a4)
    addq.l     #8,a4
    bne.s      MrkC1
    clr.l      (a4)
    move.l     d3,-8(a4)        * Adresse dans liste
    move.l     d1,-4(a4)        * Decalage
MrkC2:    
* Calcule les valeurs non plantantes!
    move.w     #465+16,d3
    tst.w      EcCon0(a0)
    bpl.s      MkC1c
    move.w     #465,d3
MkC1c:
    move.w     EcWx(a0),d1
    addq.w     #1,d1
    move.w     EcWTx(a0),d2
    move.w     d1,d6
    add.w      d2,d6
    cmp.w      d3,d6
    bcs.s      MkC1a
    sub.w      d3,d6
    add.w      #16,d6
    sub.w      d6,d2
    bra.s      MkC1b
MkC1a:
    cmp.w      #176,d6
    bhi.s      MkC1b
    sub.w      #176,d6
    sub.w      d6,d1
MkC1b:
    move.w     d1,EcWXr(a0)
    move.w     d2,EcWTxr(a0)
    move.w     #DiwStrt,(a1)+        ;DiwStrt Y = 0
    move.w     d1,(a1)
    or.w       #$0100,(a1)+
    move.w     #DiwStop,(a1)+        ;DiwStop Y = 311
    add.w      d2,d1
    and.w      #$00ff,d1
    or.w       #$3700,d1
    move.w     d1,(a1)+
* Calcul des valeurs modulo ---> d4
    move.w     EcTLigne(a0),d4
    move.w     EcWTxr(a0),d5
    lsr.w      #3,d5
    btst       #7,EcCon0(a0)
    bne.s      MkC2a
    lsr.w      #1,d5
MkC2a:
    lsl.w      #1,d5
    sub.w      d5,d4
    bpl.s      MkC2
    clr.w      d4
MkC2:    
* Calcul DDF Start/Stop---> D1/D2
    move.w     EcWXr(a0),d1
    move.w     EcWTxr(a0),d2
    move.w     EcVX(a0),d6
    btst       #7,EcCon0(a0)
    bne.s      MkCH
* Lowres
    sub.w      #17,d1
    lsr.w      #1,d1
    and.w      #$FFF8,d1
    lsr.w      #1,d2
    subq.w     #8,d2
    add.w      d1,d2
    and.w      #15,d6            ;Scrolling?
    beq.s      MkC3
    subq.w     #8,d1
    subq.w     #2,d4
    neg.w      d6
    add.w      #16,d6
    bra.s      MkC3
* Hires
MkCH:
    sub.w      #9,d1
    lsr.w      #1,d1
    and.w      #$FFFC,d1
    lsr.w      #1,d2
    subq.w     #8,d2
    add.w      d1,d2

; **************************** 2019.11.19 Updated for Fetch Mode Scrolling values.
    tst.w      EcFMode(a0)             ; 2019.11.19 Add -8 if FMode is active
    beq        .noFetchChanges4S
    ; * Fetch 1 mode
    and.w      #31,d6                  ; Scrolling 64 bits
    beq        MkC3
    subq.w     #4,d1
    subq.w     #4,d4
    neg.w      d6
    add.w      #32,d6
    move.w     d6,d5
    and.w      #%1100000,d5            ; Get PF1H6 & PF1H7 for D5
    lsl.w      #6,d5                   ; d5 reach bytes 11-12
    Or.w       d5,d6 
    And.w      #%1100000011111,d6      ; D6 = Scroll value bits 2-5 + 6-7
    Move.w     d6,d5
    Lsr.w      #1,d6                   ; D6 = PF1H2-PF1H5 = Scroll bits 2-5 & 6-7
    And.w      #%1,d5                  ; D5 = Scroll values bits 0-1
    Lsl.w      #8,d5          
    lsl.w      #1,d5                   ; D5 = PF1H1 = Scroll bits 1
    Or.w       d5,d6                   ; D6 = PF1H0-PF1H5 = Scroll bits 0-5 ( 6 bits = 32 bits mode )
    bra        MkC3                    ; -> To duplicate PF1H0-PF1H5 bits to PF2H0-PF2H5
.noFetchChanges4S:                     ; * No fetch changes to do ( Fetch = 0 )
    ; * No Fetch (=0) mode
    and.w      #15,d6            ;Scrolling?
    lsr.w      #1,d6
    beq.s      MkC3
    subq.w     #4,d1
    subq.w     #4,d4
    neg.w      d6
    addq.w     #8,d6
MkC3:
    ; * Common part to copy Playfield 1 bits to Playfield 2 ones.
    move.w     d6,d5                   ; D5 = D6 = SCroll values 0-15
    lsl.w      #4,d5                   ; D5 shift for Playfield 2 scrolling value
    or.w       d6,d5                   ; D5 = D5 | D6 = Scrolling values for both playfields 1 & 2

* Calcul et poke DDF Start/Stop
    tst.w      EcFMode(a0)              ; 2019.11.19 Add -8 if FMode is active
    beq        noFetchChanges
    sub.l      #8,d1
noFetchChanges:
* Poke les valeurs
    move.w     #DdfStrt,(a1)+
    move.w     d1,(a1)+
    move.w     #DdfStop,(a1)+
    move.w     d2,(a1)+
* Interlace?
    move.w     EcCon0(a0),d1
    btst       #2,d1
    beq.s      MkCi1
    move.w     EcTx(a0),d2
    lsr.w      #3,d2
    add.w      d2,d4
MkCi1:
* Calcul et poke MODULO Start/Stop
    tst.w      EcFMode(a0)             ; 2019.11.19 Add -8 if FMode is active
    beq        noFetchChanges2
    sub.l      #4,d4
noFetchChanges2:
    move.w     #Bpl1Mod,(a1)+
    move.w     d4,(a1)+
    move.w     #Bpl2Mod,(a1)+          ; Bpl2Mod
    move.w     d4,(a1)+
* Registres de controle
    move.w     #BplCon0,(a1)+
    or.w       T_InterInter(a5),d1
    move.w     d1,(a1)+
    move.w     #BplCon1,(a1)+
    move.w     d5,(a1)+
    move.w     #BplCon2,(a1)+
    move.w     EcCon2(a0),(a1)+
    move.w     #BplCon3,(a1)+          ; 2019.11.04 Added BplCon3 to support dual playfield 2x16 colors
    move.w     #%1000000000000,(a1)+   ; 2019.11.04
    move.w     #FMode,(a1)+            ; 2019.11.04 And FMode Support too
    Move.w     EcFMode(a0),(a1)+       ; 2019.11.04
    Rbra      L_FinishCopper           ; 2020.10.14 Replaced : bra FiniCop


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : FiniCop / L_FinishCopper                    *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
* Reactive le DMA au debut de la fenetre
    Lib_Def    FinishCopper
    move.l     (sp)+,d4
    addq.w     #1,d0
    move.w     (a2),d1
    bpl.s      FiCp1
    neg.w      d1
FiCp1:
    cmp.w      d0,d1
    beq.s      MkC9
    move.w     d0,d2
    sub.w      #EcYBase,d2
    Rbsr       L_newWaitD2              ; 20.10.14 Replaced : bsr WaitD2
    move.w     #DmaCon,(a1)+
    move.w     #$8300,(a1)+

* Now AMOS insert colors 16-31
    move.l     a1,d3

    moveq      #32-PalMax-1,d1         ; D1 = 32-16-1 = 15 ( 16 colors to insert)
    move.w     #Color00+PalMax*2,d2    ; D2 = Copper Color Register 000 + ( 16 * 2 )
    lea        EcPal+PalMax*2(a0),a4   ; A4 = Color 016 (High Bits) data from Screen A0
MkC7:
    move.w     d2,(a1)+                ; Next Copper Action = D2 = Copper Color Register
    addq.w     #2,d2                   ; D2 = Next Copper Color Register
    move.w     (a4)+,(a1)+             ; Next Copper Data (A1) = Color Data (A4) 
    dbra       d1,MkC7                 ; D1 > -1 Continue inserting color registers -> Jump MkC7

; ********************************************* 2020.08.14 Add support for RGB24 bits colors 016-031 - START
    move.w     #BplCon3,(a1)+          ; 2019.11.04 Added BplCon3 to support dual playfield 2x16 colors
    move.w     #%1001000000000,(a1)+   ; 2020.08.14 Makes LOCT = 1, PF2OF2 = 1
    moveq      #32-PalMax-1,d1         ; D1 = 32-16-1 = 15 ( 16 colors to insert)
    move.w     #Color00+PalMax*2,d2    ; D2 = Copper Color Register 000 + ( 16 * 2 )
    lea        EcPalL+PalMax*2(a0),a4  ; A4 = Color 016 (Low Bits) data from Screen A0
MkC7b:
    move.w     d2,(a1)+                ; Next Copper Action = D2 = Copper Color Register
    addq.w     #2,d2                   ; D2 = Next Copper Color Register
    move.w     (a4)+,(a1)+             ; Next Copper Data (A1) = Color Data (A4) 
    dbra       d1,MkC7b                ; D1 > -1 Continue inserting color registers -> Jump MkC7
    move.w     #BplCon3,(a1)+
    move.w     #%1000000000000,(a1)+   ; 2020.08.14 Makes LOCT = 0, PF2OF2 = 1
; ********************************************* 2020.08.14 Add support for RGB24 bits colors 016-031 - END

* Adresse de la 2ieme palette
    move.w     EcNumber(a0),d2
    lsl.w      #7,d2
    lea        T_CopMark+64(a5),a4
    add.w      d2,a4
MkC8:
    tst.l      (a4)+
    bne.s      MkC8
    clr.l      (a4)
    sub.l      #4*PalMax,d3
    move.l     d3,-(a4)    
* Adresse de la 1ere palette dans la liste copper
MkC9:
    move.w     EcNumber(a0),d2         ; Mark the adresse
    lsl.w      #7,d2
    lea        T_CopMark(a5),a4
    add.w      d2,a4
MkC10:
    tst.l      (a4)+
    bne.s      MkC10
    clr.l      (a4)
    move.l     d4,-(a4)
* Fini!
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : CreeDual / L_CreateDualPlayfield            *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters : D0 = Y Screen Position                       *
; *              A0 = 1st Struct structure pointer. Screen al-*
; *                   -ready inserted in the CopperList from  *
; *                   the method that call CreeDual           *
; *              D2 = 2nd screen structure pointer. Screen    *
; *                   that must be handled there.             *
; *                                                           *
; * Return Value : -                                           *
; *************************************************************
*   D2 = 2nd screen structure pointer. Screen that must be handled there.
    Lib_Def    CreateDuaplPlayfield
* Adresse du deuxieme ecran
    move.l     a2,-(sp)
    lsl.w      #2,d2
    lea        T_EcAdr(a5),a2
    move.l     -4(a2,d2.w),d2          ; We clear the 2nd one
    bne.s      CrDu1
    move.l     (sp)+,a2
    clr.w      EcDual(a0)              ; Transform as simple screen
    move.w     EcCon0(a0),d2
    and.w      #%1000101111101111,d2   ; // 2019.11.04 Update to handle Bit 4 BPU3
    move.w     EcNPlan(a0),d7
    ; 2019.11.04 Update this part to handle 2x16 colors in Dual Playfield mode.
;    lsl.w      #8,d7                   ; These 2 lines were the original ones to calcule BPU0-2 with a  maximum of 2x8colors per field
;    lsl.w      #4,d7                   ; Now, we put them as comment and update the method to handle 2x16 colors per field and BPU3 byte.
    cmp.w      #8,d7                   ; If 8 bitplanes are requested, we directly set byte #4 (=BPU3) of d2
    blt        sevenOrLowerDPFcop      ; Less than 8 bitplanes, jump to classical way of shifting bytes to set BPU0-2
heightBitPlanesDPFcop:
    move.w     #16,d7                  ; Set byte 04 ( BPU3 ) to 1 and others (BPU0-2) to 0 to define 8 bitplanes
    bra.s      continueDPFcop
sevenOrLowerDPFcop:                    ; if less thab 8 bitplanes are requested, we use the default Amos calculation as it fit
    lsl.w      #8,d7                   ; in BPU0-1-2 bytes 12-13-14 in BPLCON0 16 bits register
    lsl.w      #4,d7                   ; As lsl.w handle max of 8, to shift by 12 AMOS must to 2 Lsl.w calls.
continueDPFcop:                        ; 2019.11.04 End of upgrade to handle BPU3 for 8 Bitplanes mode.
    or.w       d7,d2
    move.w     d2,EcCon0(a0)
    bra        PluDual                 ; -> Now, we come back to the screen creation

CrDu1:
    move.l    d2,a2
* Adresses bitplanes PAIRS!
    move.w    d1,-(sp)
    add.w     EcVY(a0),d1              ; Screen shift
    mulu      EcTLigne(a0),d1
    move.w    EcVX(a0),d2
    move.w    d2,d5                    ; 2019.11.08 From AMOS Factory Dual Playfield Fix
    lsr.w     #4,d2
    lsl.w     #1,d2
    add.w     d2,d1
; ************************************** 2019.11.08 From AMOS Factory Dual Playfield fix
    move.w     #$F,d4
    btst       #7,EcCon0(a0)
    beq.s      MkDC0
    sub.w      #1,d4
MkDC0: 
    and.w      d4,d5
    bne.s      MkDC0a
; bitplane fetch starts 2 bytes early if no finescroll remainder
    sub.l      #2,d1
; ************************************** 2019.11.08 End of AMOS Factory Dual Playfield fix

MkDC0a:
    move.l     a1,d3
    moveq      #EcPhysic,d2
    move.w     EcNPlan(a0),d6          ; Here we get the amount of bitplanes stored in first screen of the DualPlayfield
    ; (in Duale, updated of EcNPlan forces cumulate 2 screens. This loop put all BplxPth/BplxPtl registers in the copper list
    subq.w     #1,d6
    move.w     #Bpl1PtH,d7
MkDC1:
    move.l     0(a0,d2.w),d5
    add.l      d1,d5
    move.w     d7,(a1)+
    addq.w     #2,d7
    swap       d5
    move.w     d5,(a1)+
    move.w     d7,(a1)+
    addq.w     #2,d7
    swap       d5
    move.w     d5,(a1)+
    addq.l     #4,d2
    addq.w     #4,d7
    dbra       d6,MkDC1
    move.w     EcNumber(a0),d2         ; Mark the address
    cmp.w      #8,d2
    bcc.s      MrkDC2
    lsl.w      #6,d2
    lea        CopL1*EcMax+T_CopMark(a5),a4
    add.w      d2,a4
MrkDC1:
    tst.l      (a4)
    addq.l     #8,a4
    bne.s      MrkDC1
    clr.l      (a4)
    move.l     d3,-8(a4)
    move.l     d1,-4(a4)
* Adresses bitplanes IMPAIRS!
MrkDC2:
    move.w     (sp)+,d1
    add.w      EcVY(a2),d1             ; Screen shift
    mulu       EcTLigne(a2),d1
    move.w     EcVX(a2),d2
    move.w     d2,d5                   ; 2019.11.08 From AMOS Factory Dual Playfield Fix
    lsr.w      #4,d2
    lsl.w      #1,d2
    add.w      d2,d1
; ************************************** 2019.11.08 From AMOS Factory Dual Playfield fix
MkDC0b:
    and.w     d4,d5
    bne.s    MkDC0c
    ; Bitplane fetch starts 2 bytes early if no finescroll reminder
    sub.l     #2,d1
; ************************************** 2019.11.08 End of AMOS Factory Dual Playfield fix
MkDC0c:
    move.l    a1,d3
    moveq    #EcPhysic,d2
    move.w    EcNPlan(a2),d6
    subq.w    #1,d6
    move.w    #Bpl1PtH+4,d7      ; Now we put odd bitplanes pointers
MkdC12:    move.l    0(a2,d2.w),d5
    add.l    d1,d5
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    addq.l    #4,d2
    addq.w    #4,d7
    dbra    d6,MkdC12
    move.w    EcNumber(a2),d2        * Marque les adresses
    cmp.w    #8,d2
    bcc.s    MrkDC4
    lsl.w    #6,d2
    lea    CopL1*EcMax+T_CopMark(a5),a4
    add.w    d2,a4
MrkDC3    tst.l    (a4)
    addq.l    #8,a4
    bne.s    MrkDC3
    clr.l    (a4)
    move.l    d3,-8(a4)
    move.l    d1,-4(a4)
MrkDC4
* Calcule les valeurs non plantantes!
    move.w    #465+16,d3
    tst.w    EcCon0(a0)
    bpl.s    MkdC1c
    sub.w    #16,d3
MkdC1c    move.w    EcWx(a0),d1
    addq.w    #1,d1
    move.w    EcWTx(a0),d2
    move.w    d1,d6
    add.w    d2,d6
    cmp.w    d3,d6
    bcs.s    MkdC1a
    sub.w    d3,d6
    add.w    #16,d6
    sub.w    d6,d2
    bra.s    MkdC1b
MkdC1a:    cmp.w    #176,d6
    bhi.s    MkdC1b
    sub.w    #176,d6
    sub.w    d6,d1
MkdC1b:
    move.w    d1,EcWXr(a0)
    move.w    d2,EcWTxr(a0)
    move.w    #DiwStrt,(a1)+        ;DiwStrt Y = 0
    move.w    d1,(a1)    
    or.w    #$0100,(a1)+
    move.w    #DiwStop,(a1)+        ;DiwStop Y = 311
    add.w    d2,d1
    and.w    #$00ff,d1
    or.w    #$3700,d1
    move.w    d1,(a1)+
* Calcul des valeurs modulo ---> D4/D5
    move.w    EcTLigne(a0),d4
    move.w    EcTLigne(a2),d5
    move.w    EcWTxr(a0),d6
    move.w    EcWTxr(a2),d7
    lsr.w    #3,d6
    lsr.w    #3,d7
    btst    #7,EcCon0(a0)
    bne.s    MkdC2
    lsr.w    #1,d6
    lsr.w    #1,d7
MkdC2:    lsl.w    #1,d6
    lsl.w    #1,d7
    sub.w    d6,d4
    bpl.s    MkdC2a
    clr.w    d4
MkdC2a:    sub.w    d7,d5
    bpl.s    MkdC2b
    clr.w    d5
MkdC2b:    
* Calcul DDF Start/Stop---> D1/D2
    move.w    EcVX(a0),d6
    move.w    EcVX(a2),d7
; ************************************** 2019.11.08 From AMOS Factory Dual Playfield fix
;    move.w    d6,d1
;    and.w    #15,d1
;    bne.s    Mkd2d
;    and.w    #$FFF0,d7
;Mkd2d:    move.w    d7,d1
;    and.w    #15,d1
;    bne.s    Mkd2e
;    and.w    #$FFF0,d6
; 
; ************************************** 2019.11.08 End of AMOS Factory Dual Playfield fix
Mkd2e:
    move.w    EcWXr(a0),d1
    move.w    EcWTxr(a0),d2
    btst    #7,EcCon0(a0)
    bne.s    MkdCH
* Lowres
    sub.w    #17,d1
    lsr.w    #1,d1
    and.w    #$FFF8,d1
    lsr.w    #1,d2
    subq.w    #8,d2
    add.w    d1,d2
; ************************************** 2019.11.08 From AMOS Factory Dual Playfield fix
;    and.w    #15,d6
;    and.w    #15,d7
;    beq.s    MkdC3
; ************************************** 2019.11.08 End of AMOS Factory Dual Playfield fix
    subq.w    #8,d1
    subq.w    #2,d4
    subq.w    #2,d5
; ************************************** 2019.11.08 From AMOS Factory Dual Playfield fix
    and.w     #$F,d6
    beq     .next
; ************************************** 2019.11.08 End of AMOS Factory Dual Playfield fix
    neg.w    d6
    add.w    #16,d6
; ************************************** 2019.11.08 From AMOS Factory Dual Playfield fix
.next:
    and.w     #$F,d7
    beq     MkdC3
; ************************************** 2019.11.08 End Of AMOS Factory Dual Playfield fix
    neg.w    d7
    add.w    #16,d7
    bra.s    MkdC3
* Hires
MkdCH:    sub.w    #9,d1
    lsr.w    #1,d1
    and.w    #$FFFC,d1
    lsr.w    #1,d2
    subq.w    #8,d2
    add.w    d1,d2
    and.w    #15,d6
    and.w    #15,d7
    lsr.w    #1,d6
    lsr.w    #1,d7
    beq.s    MkdC3
    subq.w    #4,d1
    subq.w    #4,d4
    subq.w    #4,d5
    neg.w    d6
    addq.w    #8,d6
    neg.w    d7
    addq.w    #8,d7
MkdC3:    lsl.w    #4,d7
    or.w    d7,d6
* Poke les valeurs
    move.w    #DdfStrt,(a1)+
    move.w    d1,(a1)+
    move.w    #DdfStop,(a1)+
    move.w    d2,(a1)+
    move.w    #Bpl1Mod,(a1)+
    move.w    d4,(a1)+
    move.w    #Bpl2Mod,(a1)+                      ; BPl2Mod à fixer/améliorer pour le 2nd écran.
    move.w    d5,(a1)+
* Registres de controle
    move.w    #BplCon0,(a1)+
    move.w    EcCon0(a0),d1
    or.w    T_InterInter(a5),d1
    move.w    d1,(a1)+
    move.w    #BplCon1,(a1)+
    move.w    d6,(a1)+
    move.w    #BplCon2,(a1)+
    move.w    EcCon2(a0),(a1)+

* Fini! Retourne au programme normal
    move.l    (sp)+,a2
    Rbra      L_FinishCopper           ; 2020.10.14 Replaced : bra FiniCop


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcCopBa / L_EndOfScreenCopper               *
; *-----------------------------------------------------------*
; * Description : Insert the bottom of a screen at current    *
; *               copper line                                 *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
; ************************************************************************** Insert a screen closure (Y End of screen)
******* Cree la ligne COPPER de fin de fenetre
    Lib_Def    EndOfScreenCopper
;    move.w     #BplCon3,(a1)+          ; 2019.11.05 Update BplCon3 when closing screen
;    move.w     #0,(a1)+                ; Reset everything concerning BplCon3.
    move.w     d0,d2
    sub.w      #EcYBase,d2
    Rbsr       L_newWaitD2              ; 20.10.14 Replaced : bsr WaitD2
    move.w     #DmaCon,(a1)+
    move.w     #$0100,(a1)+
    move.w     #Color00,(a1)+
    move.w     T_EcFond(a5),(a1)+
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : WaitD2 / L_newWaitD2                        *
; *-----------------------------------------------------------*
; * Description : Replacement for the Wait Copper Line. This  *
; *               method insert a Wait Line in the copper list*
; *                                                           *
; * Parameters : A1 = pointer to the current position in the  *
; *                   copper list editing                     *
; *              D2 = The line to wait
; *                                                           *
; * Return Value :                                            *
; *************************************************************
******* Attente copper jusqu''a la ligne D2
    Lib_Def    newWaitD2
    cmp.w      #256,d2
    bcs.s      WCop
    tst.w      T_Cop255(a5)
    bne.s      WCop
    move.w     #$FFDF,(a1)+
    move.w     #$FFFE,(a1)+
    addq.w     #1,T_Cop255(a5)
WCop:
    lsl.w      #8,d2    
    or.w       #$03,d2
    move.w     d2,(a1)+
    move.w     #$FFFE,(a1)+
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TCopSw / L_CopperSwap                       *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    CopperSwap
    tst.w      T_CopON(a5)
    bne        .CopperError1          ; 2020.10.14 Replace : bne CopEr1
    move.l     T_CopPos(a5),a0
    move.l     #$FFFFFFFE,(a0)
    Rbra       L_CopperSwapInternal
.CopperError1:
    moveq    #1,d0            * Copper not desactivated
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TCpSw / L_CopperSwapInternal                *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    CopperSwapInternal
    move.l     T_CopLogic(a5),a0
    move.l     T_CopPhysic(a5),a1
    move.l     a1,T_CopLogic(a5)
    move.l     a0,T_CopPhysic(a5)
    move.l     a0,Circuits+Cop1lc
    Rbra       L_CopperReset
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TCopRes / L_CopperReset                     *
; *-----------------------------------------------------------*
; * Description :                                             *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
******* COPRESET
    Lib_Def    CopperReset
    tst.w      T_CopON(a5)
    bne        .CopperError1           ; 2020.10.14 Replace : bne CopEr1
    move.l     T_CopLogic(a5),T_CopPos(a5)
    clr.w      T_Cop255(a5)
    moveq      #0,d0
    rts
.CopperError1:
    moveq    #1,d0            * Copper not desactivated
    rts

































;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : L_ScreenOpen / EcCree                       *
; *-----------------------------------------------------------*
; * Description : This method will create a screen using AGA  *
; *               capabilities                                *
; *                                                           *
; * Parameters : D1 = Screen Number                           *
; *              D2 = Width In Pixels (TX)                    *
; *              D3 = Height In Pixels (TY)                   *
; *              D4 = Number of Bitplanes                     *
; *              D5 = Graphic Mode (Hires,Laced,Lowres)       *
; *              D6 = Amount of colors                        *
; *              A1 = Color Palette ECS Or AGAP One           *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
    Lib_Def    ScreenOpen
;EcCree: 
    movem.l    d1-d7/a1-a6,-(sp)
    move.l     a1,a2

;    Verifie les parametres
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Move.l     d2,d7
    and.l      #$FFFFFFF0,d2           ; Ensure screen width is multiple of 16
    beq        EcE4                    ; if screen width = 0 ( < 16 ) -> Error EcE4
    cmp.l      d2,d7
    bne        EcE169                  ; 2019.11.30 Added restriction screen width must be multiple of 16 pixels.
    cmp.l      #2048,d2                ; 2019.11.18 : If Screen Width > 2048 -> Error
    bcc        EcE4
    tst.l      d3
    beq        EcE4
    cmp.l      #2048,d3                ; 2019.11.18 : If Screen Height > 2048 -> Error
    bcc        EcE4
    tst.l      d4                      ; If Screen Depth = 0 -> Error
    beq        EcE4
    cmp.l      #EcMaxPlans,d4          ; If Screen Depth > ExMAxPlans -> Error
    bhi        EcE4

;     Check for AGA specific screens :
; ~~~~~~~~~~~~~~~~~~~~~~~~~

; *********************** 2019.11.30 Full AGA/ECS support here
    cmp.w      #1,T_isAga(a5)          ; 2019.11.30 Check for AGA computer.
    beq.s      ecAga1                  ; If aga no 4 bitplanes limitation -> Jump to ecAga1
    Btst       #15,d5                  ; Do we request HiRes ?
    beq        .noHiresFetch           ; = NO -> No checking for hires || Aga Hires Fetch.
    Cmp.l      #4,d4                   ; is Hires using more than 4 bitplanes ?
    bhi        EcE167                  ; = Yes -> Error "no more than 4 bitplanes for hires screen" (ECS, No AGA)
    bra        ecCr2
.noHiresFetch:
    ; As this part is ECS only, we also check for 6 bitplanes limitation.
    cmp.l      #6,d4                   ; If Screen Depth > 6 bitplanes -> Error
    bhi        EcE168                  ; = Yes -> Error "no more than 6 bitplanes for Lowres screen" (ECS, No AGA)
    bra        ecCr2
ecAga1:
    Btst       #15,d5                  ; Do we request HiRes ?
    beq        ecCr2                   ; = NO -> No checking for hires || Aga Hires Fetch.
    ; Must be sure that screen width is multiple of 64 pixels.
    cmp.l      #4,d4                   ; is Hires using more than 4 bitplanes ?
    ble        ecCr2                   ; If less than 4 bitplanes, no checking for Fetch mode widht multiple of 64
    Move.l     d2,d7
    and.l      #$0FC0,d7
    cmp.l      d2,d7
    bne        EcE166                  ; AGA requires screen to be multiple of 64 pixels wide
ecCr2:
; *********************** 2019.11.30 End of Full AGA/ECS support here
; ~~~~~~~~~~~~~~~~~~~~~~~~~
ReEc:
    move.l     d1,-(sp)
    EcCall     GetScreen               ; 2020.10.11 Previously : bsr EcGet
    beq.s      EcCr0                   ; if Screen Adress (in D0) = 0 -> Screen not created. -> Jump to EcCr0
; If screen already exists, we close it before creating it again
    move.l     (sp)+,d1
    EcCallA1   Del                     ; 2020.10.11 Previously : bsr EcDel ; Close Screen
    bra.s      ReEc

;    Allocate memory (FastMem) for the Screen Table/Structure
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EcCr0:
    move.l     #EcLong,d0
    SyCallA1   SyFast                  ; 2020.10.11 Previously : bsr FastMm
    beq        EcEE1
    move.l     d0,a4                   ; A4 = Current Screen data structure
; ************************************* 2020.07.31 Add support for HAM8 in Screens - START
    move.w     #0,Ham8Mode(a4)         ; Clear HAM8 Mode for this screen
    btst       #19,d5                  ; Do we request HAM8 Mode ?
    beq.s      .noHam8
    move.w     #1,Ham8Mode(a4)         ; Save HAM8 Mode for this screen
    bclr       #19,d5                  ; Clear the bit as it is now useless.
.noHam8:
; ************************************* 2020.07.31 Add support for HAM8 in Screens - END

; 
; *********************** 2019.11.18 Preset the Fetch Mode depending on graphical resolution
;   This checking cannot be done sooner as it requires the Screen Table/Structure to be allocated (a4)
    Btst       #15,d5                  ; Do we request HiRes ?
    beq        .noHires
    Cmp.w      #4,d4                   ; is Hires using more than 4 bitplanes ?
    blt        .noHires
    Move.w     #%1,EcFMode(a4)         ;
    bra        .fModeSet
.noHires:
    Move.w     #0,EcFMode(a4)
.fModeSet:
; *********************** 2019.11.18 End pf Preset the Fetch Mode depending on graphical resolution

;; *********************** 2020.09.10 Updated to handle AGAP mode from Unpack command - Start
;    ****** This small loop copy the default AMOS color palette inside current screen one to set it.
    move.l     a2,a1
    move.w     #-1,EcPalSeparator(a4)  ; 2020.09.16 Reuired for Fade
    move.w     #-1,EcPalSepL(a4)       ; 2020.09.16 Reuired for Fade
    move.l     #"AGAP",AGAPMode(a4)
    move.w     d6,EcNbCol(a4)
    moveq      #31,d6                  ; Force to copy only the default 32 colors from the palette in A1 (old SPack or Default color palette)
    cmp.l      #"AGAP",(a1)            ; 2020.09.10 Check if the PAlette sent to screen creation own AGAP header or not.
    bne.s      noAgap
    move.w     4(a1),d6                ; Read Color Count from AGAP mode, new SPack with AGA 24Bits support
    add.l      #6,a1                   ; Push A1 to the 1st color in the palette when AGAP(.l) + NBColor(.w) are available
noAgap:
    moveq      #31,d0
    lea        EcPal(a4),a2
EcCr4:
    move.w     EcPalL-EcPal(a1),EcPalL-EcPal(a2)   ; 2020.08.13 Update lower bits for color palette 000-031
    move.w     (a1)+,(a2)+             ; Update default higher bits for color palette 000-031
    dbra       d0,EcCr4
    ; *********************************** 2019.11.23 Copy the AGA Color palette from the default palette
    move.w     d6,d0
;    and.l      #$FFFF,d0
; *********************** 2020.09.10 Updated to handle AGAP mode from Unpack command - End
    sub.w      #33,d0 
    bmi.s      noCopy2
; ************************************************************* 2020.08.13 Update to copy color to both high and low bits of color palette
    Lea        T_globAgaPal(a5),a2
    lea        EcScreenAGAPal(a4),a3   ; ************** 2020.05.01 Added to update the screen palette and not only the global aga palette
EcCr4b:
    ; RGB Color values read from default color palette, are RGB12 bits color values.
    move.w     514(a1),T_globAgaPalL-T_globAgaPal(a2)     ; 2020.08.13 Copy to T_globAgaPalL for lower RGB 24 bits
    move.w     (a1),(a2)+
    move.w     EcPalL-EcPal(a1),EcScreenAGAPalL-EcScreenAGAPal(a3) ; 2020.08.13 Copy to EcScreenAGAPalL for lower RGB 24 bits
    move.w     (a1)+,(a3)+             ; ************** 2020.05.01 Added to update the screen palette and not only the global aga palette
    dbra       d0,EcCr4b
; ************************************************************* 2020.08.13 Update to copy color to both high and low bits of color palette
    cmp.w      #31,d6                  ; Was A1 Palette uses AGAP and contains more than 32 colors ?
    beq.s      noCopy2                 ; No. -> Jump to noCopy2
    Rbsr       L_UpdateAGAColorsInCopper ; Yes -> Branch Sub to update aga color palette in copper list.
noCopy2:
    ; *********************************** End of AGA color palette copy.

    ; ****** This part will save informations concerning screen sizes
    move.w     d2,EcTx(a4)             ; Save Screen Width in pixels
    move.w     d2,EcTxM(a4)            ; Save Screen Width in pixels
    subq.w     #1,EcTxM(a4)            ; Width (in pixels) -1
    move.w     d2,d7
    lsr.w      #3,d7                   ; Screen Width / 8 = Screen Widht in bytes
    move.w     d7,EcTLigne(a4)         ; d7 = 1 line bytes size
    move.w     d3,EcTy(a4)             ; Save Screen Height
    move.w     d3,EcTyM(a4)            ; Save Screen Height
    subq.w     #1,EcTyM(a4)            ; Height (in pixels) -1
    mulu       d3,d7                   ; Height * Width(bytes) = Bitplane length in bytes
    move.l     d7,EcTPlan(a4)          ; Save Bitplane size in bytes
    move.w     d4,EcNPlan(a4)          ; Save bitplanes amount

    ; 2019.11.05 Setup for default color shifting in case this screen can be 1st screen in eventual DPF mode.
    cmp.w      #3,d4                   ; if this screen uses more than 4 bitplanes, it can't be used for DPF
    bhi        shift16c                ; Then we jump directly to set value 0 for eventual color shifting
    move.w     #%11,dpf2cshift(a4)
    bra        endCSsetup
shift16c:
    move.w     #%100,dpf2cshift(a4)
endCSsetup:
    ; 2019.11.05 End of setup for default color shifting in case this screen can be 1st screen in eventual DPF mode.

;     Display Parameters -1-
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     T_GfxBase(a5),a0        ; EcCon0
    move.w     164(a0),d0              ; Get GfxBase -> BplCon0 copy
    and.w      #%0000001111111011,d0   ; Filter for bitplanes amount
    move.w     d4,d1                   ; D1 = Bitplanes amount
    ; 2019.11.05 Update to handle 8 bitplanes in BplCon0 in normal screen (not dual playfield)
;    lsl.w     #8,d1                   ; Original method to handle 0-6 Bitplanes ( BPU0-2)
;    lsl.w     #4,d1                   ;
    cmp.w      #8,d1                   ; If 8 bitplanes are requested, we directly set byte #4 of d2
    blt        sevenOrLower            ; Less than 8 bitplanes, jump to classical way of shifting bytes to set BPU0-2
heightBitPlanes:
    move.w     #16,d1                  ; Set byte 04 ( BPU3 ) to 1 and others (BPU0-2) to 0 to define 8 bitplanes
    bra.s      continue
sevenOrLower:                          ; if less thab 8 bitplanes are requested, we use the default Amos calculation as it fit
    lsl.w      #8,d1                   ; in BPU0-1-2 bytes 12-13-14 in BPLCON0 16 bits register
    lsl.w      #4,d1                   ; As lsl.w handle max of 8, to shift by 12 AMOS must to 2 Lsl.w calls.
continue:                              ; 2019.11.05 End of upgrade to handle BPU3 for 8 Bitplanes mode.
    or.w       d0,d1                   ; D1 = BplCon0 filtered || BPU0-3
    or.w       d1,d5                   ; D5 = D1 || D5 (Mode (Hires, Lace))
    move.w     d5,EcCon0(a4)           ; Save BplCon0 value for this screen
    move.w     #%00100100,EcCon2(a4)   ; Save BplCon2 value for this screen

;    Create/Initialize the BitMap Structure
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    moveq      #bm_SIZEOF,d0            bm_SIZEOF
    SyCallA1   SyFast                  ; 2020.10.11 Previously : bsr FastMm
    beq        EcMdd
    move.l     d0,Ec_BitMap(a4)
    move.l     d0,a0                   ; A0 = bitmap structure pointer
    move.w     EcNPlan(a4),d0          ; Creation de BitMap
    ext.l      d0                      ; D0 = Screen Depth
    move.w     EcTx(a4),d1
    ext.l      d1                      ; D1 = Screen Width
    move.w     EcTy(a4),d2
    ext.l      d2                      ; D2 = Screen height
    move.l     T_GfxBase(a5),a6
    jsr        _LVOInitBitMap(a6)      ; Initialise bitmap using

; Allocate memory for all required BitMaps
; ~~~~~~~~~~~~~~
    ; **************************** 2019.11.13 Try to allocate the whole screen at once.
    move.w     EcNPlan(a4),d6          ; 2019.11.12 Directly moves EcNPlan instead of D6 datas
    subq.w     #1,d6
    move.l     Ec_BitMap(a4),a1        ; a1 = Initialized BitMap Structure
    moveq      #0,d2                   ; D2 start at offset 0
    Lea        EcOriginalBPL(a4),a2    ; A2 = Original Bitmaps to save
EcCra:
    move.l     EcTPlan(a4),d0          ; 2019.11.12 Directly moves ECTPlan in d0 instead of D7 register
    Add.l      #8,d0                   ; Add 8 bytes in total bitmap memory size allow manual 64 bits alignment.
    SyCall     SyChip                  ; 2020.10.11 Previously : bsr ChipMm
    beq        EcMdd
    move.l     d0,(a2)+                ; Save Original Bitmap Position
    And.l      #$FFFFFFC0,d0           ; Align D0 to 64bits address in range 0 <= Start of memory allocation <= 8
    Add.l      #8,d0                   ; ADD + 8 to d0 to be at the higher limit of its memory allocation without bytes over
    move.l     d0,bm_Planes(a1,d2.w)   ; Save bitmap in previously initialized bitmap structure
    move.l     d0,EcCurrent(a4,d2.w)   ; Save bitmaps to EcCurrent
    move.l     d0,EcLogic(a4,d2.w)     ; Save Bitmaps to EcLogic
    move.l     d0,EcPhysic(a4,d2.w)    ; Save Bitmap To EcPhysic
    addq.l     #4,d2
    dbra       d6,EcCra

; ********************************************* 2020.08.11 Update to support HAM8 Mode - Start
    Move.l     a4,T_cScreen(a5)          ; Save current screen to use it in the Bitplane Shift method
    Rbsr       L_SHam8BPLS               ; Call the Bitplane shifting method for HAM8 mode
ne1:
; ********************************************* 2020.08.11 Update to support HAM8 Mode - End

ctscr:
    EcCallA1   BlitterWait
    SyCallA1   WaitVbl
    EcCallA1   BlitterWait

;    Create the true Intuition Rastport
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     T_LayBase(a5),a6        
    jsr        _LVONewLayerInfo(a6)    ; Create LayerInfo
    move.l     d0,Ec_LayerInfo(a4)
    beq        EcMdd
    move.l     d0,a0                   ; A0 = Layer Info structure
    move.l     Ec_BitMap(a4),a1        ; A1 = Bitmap Structure
    moveq      #0,d0                   ; D0 = X0 of Upper left hand corner of layer
    moveq      #0,d1                   ; D1 = Y0 of Upper left hand corner of layer
    move.w     EcTx(a4),d2
    subq.w     #1,d2                   ; D2 = X1 of lower right hand corner of layer
    ext.l      d2
    move.w     EcTy(a4),d3
    subq.w     #1,d3                   ; D3 = Y1 of lower right hand corner of layer
    ext.l      d3
    moveq      #LAYERSIMPLE,d4         ; D4 = Flags
    sub.l      a2,a2                   ; A2 = null ( optional pointer to Super Bitmap )
    jsr        _LVOCreateUpfrontLayer(a6) ; Call CreateUpFrontLayer
    move.l     d0,Ec_Layer(a4)         ; Save created layer.
    beq        EcMdd
    move.l     d0,a0                    
    move.l     lr_rp(a0),Ec_RastPort(a4) ; Created layer rastport become current one.

    EcCallA1   BlitterWait
    SyCallA1   WaitVbl
    EcCallA1   BlitterWait

;    Zones
; ~~~~~~~~~~~
    clr.l      EcAZones(a4)
    clr.w      EcNZones(a4)

;    Additionne l''ecran dans les tables
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     (sp),d1
    lea        Circuits,a6
    EcCall     GetScreen          ; 2020.10.11 Previously : bsr EcGet
    move.l     a4,(a0)            ; Branche
    move.w     d1,EcNumber(a4)    ; Un numero!
    move.l     a4,a0              ; Become current screen
    EcCallA1   ScreenActive       ; 2020.10.11 Previously : bsr Ec_Active
    move.l     (sp),d1
    EcCallA1   First              ; 2020.10.11 Previously : bsr EcFirst ; Push over other screens
    EcCallA1   IsScreenInterL     ; 2020.10.11 Previously : bsr InterPlus ; Is interlaced ?

;     Parametres d''affichage -2-
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.w     T_DefWX(a5),d2        Affichage par defaut
    move.w     T_DefWY(a5),d3
    move.w     EcTx(a4),d4
    tst.w      EcCon0(a4)
    bpl.s      EcCr6
    lsr.w      #1,d4
EcCr6:
    move.w     EcTy(a4),d5
    cmp.w      #320+16,d4
    bcs.s      EcCr7
    move.w     T_DefWX2(a5),d2
EcCr7:
    cmp.w      #256,d5
    bcs.s      EcCr8
    btst       #2,EcCon0+1(a4)
    beq.s      EcCr7a
    cmp.w      #256*2,d5
    bcs.s      EcCr8
EcCr7a:
    move.w     T_DefWY2(a5),d3
EcCr8:
    ext.l      d2
    ext.l      d3
    ext.l      d4
    ext.l      d5
    move.l     (sp),d1
    EcCallA1   AView                   ; 2020.10.11 Previously : bsr EcView

;     Cree la fenetre de texte plein ecran
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    clr.l      EcWindow(a4)
    moveq      #0,d1                   ; D1 = Window number
    moveq      #0,d2                   ; D2 = X Start
    moveq      #0,d3                   ; D3 = Y Start
    move.w     EcTx(a4),d4
    lsr.w      #4,d4
    lsl.w      #1,d4                   ; D4 = TX
    move.w     EcTy(a4),d5
    lsr.w      #3,d5                   ; D5 = TY
    moveq      #1,d6                   ; D6 = Flags / 0=Faire un CLW
    moveq      #0,d7                   ; D7 = 0 = no border
    sub.l      a1,a1                   ; A1 = Null ( = optional charset )
    WiCall     WindOp                  ; 2020.10.11 Previously : bsr WOpen ; Call Window Open
    bne        EcM1

;    Initialisation des parametres graphiques
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     EcWindow(a4),a0
    move.b     WiPen+1(a0),d1
    move.b     d1,EcInkA(a4)
    move.b     WiPaper+1(a0),d0
    move.b     d0,EcInkB(a4)
    move.b     d1,EcFInkC(a4)
    move.b     d1,EcIInkC(a4)
    move.b     d0,EcFInkA(a4)
    move.b     d0,EcFInkB(a4)
    move.b     d0,EcIInkA(a4)
    move.b     d0,EcIInkB(a4)
    move.w     #1,EcIPat(a4)
    move.w     #2,EcFPat(a4)
    move.b     #1,EcMode(a4)
    move.w     #-1,EcLine(a4)

    move.l     Ec_RastPort(a4),a1
    moveq      #0,d0
    move.b     EcInkA(a4),d0            Ink A
    GfxA5      _LVOSetAPen
    move.b     EcInkB(a4),d0            Ink B
    GfxA5      _LVOSetBPen
    move.b     EcMode(a4),d0            Draw Mode
    GfxA5      _LVOSetDrMd
;   move.w     EcCont(a4),32(a1)        Cont
    move.w     EcLine(a4),34(a1)        Line
    clr.w      36(a1)                X
    clr.w      38(a1)                Y

    move.l     T_DefaultFont(a5),a0        Fonte systeme
    GfxA5      _LVOSetFont

    clr.w      EcClipX0(a4)            Par default
    clr.w      EcClipY0(a4)
    move.w     EcTx(a4),EcClipX1(a4)
    move.w     EcTy(a4),EcClipY1(a4)

; Pas d''erreur
; ~~~~~~~~~~~~~
    addq.l     #4,sp
    move.l     T_EcCourant(a5),a0    * Ramene l''adresse definition

; Doit recalculer les ecrans
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
EcTout:
    addq.w     #1,T_EcYAct(a5)         ; Forces Screen recalculation (in copper list)

; Doit actualiser ECRANS
; ~~~~~~~~~~~~~~~~~~~~~~
EcOtoV:
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
EcOk:
    movem.l    (sp)+,d1-d7/a1-a6
    moveq      #0,d0
    rts

;    Erreur creation d''un ecran
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EcM1:
    move.l    (sp),d1
    EcCall     Del                     ; 2020.10.11 Previously : bsr EcDel ; Close Screen
    bra.s      EcEE1
EcMdd:
    EcCall     ScreenDatDel            ; 2020.10.11 Previously : bsr EcDDel ; Clear the Structure
EcEE1:
    addq.l     #4,sp
EcE1:
    moveq    #1,d0
    bra.s    EcOut
EcE4:
    moveq    #4,d0            * Sans effacement
    bra.s    EcOut
EcE3:
    moveq    #3,d0            * 3 : SCREEN NOT OPENED
    bra.s    EcOut
EcE25:
    moveq    #25,d0            * 25: Screen already double buffered
    bra.s    EcOut
EcE26:
    moveq    #26,d0            * Can't set dual-playfield
    bra.s    EcOut
EcE27:
    moveq    #27,d0            * Screen not dual playfield
    bra.s    EcOut
    ; 2019.11.03 Aded 6 new Error messages for Dual PLayfield command
EcE160:
    move.l    #160,d0                  <first and second screen are the same> 
    bra.s    EcOut
EcE161:
    move.l    #161,d0                  <First entered screen is already in dual playfield mode>
    bra.s    EcOut
EcE162:
    move.l    #162,d0                  <Second entered screen is already in dual playfield mode>
    bra.s    EcOut
EcE163:
    move.l    #163,d0                  <First screen contains more than 4 bitplanes>
    bra.s    EcOut
EcE164:
    move.l    #164,d0                  <Second screen contains more than 4 bitplanes>
    bra.s    EcOut
EcE165:
    move.l    #165,d0                  <Unknown error when trying to set dual playfield mode> 
    bra.s    EcOut
    ; 2019.11.03 End of 6 new error messages for Dual Playfield command
    ; 2019.11.19 New Error messages for AGA graphics issues
EcE166:
    move.l     #166,d0                 <AGA Specific screens requires width to be multiple of 64 pixels> 
    bra.s      EcOut
EcE167:
    Move.l     #167,d0                 <ECS Hi-Resolution screen cannot contains more than 4 bitplanes> 
    bra.s      EcOut
EcE168: 
    Move.l     #168,d0                 <ECS Low-Resolution screens cannot contains more than 6 bitplanes>
    bra.s      EcOut
EcE169:
    Move.l     #169,d0                 <ECS/AGA non Fetch mode screen required width to be multiple of 16 pixels>
    bra.s      EcOut
    ; 2019.11.19 End of New Error messages for AGA graphics issues

EcE2:
    moveq    #2,d0            * 2 : SCREEN ALREADY OPENED
* Sortie erreur ecrans
EcOut:
    movem.l    (sp)+,d1-d7/a1-a6
    tst.l    d0
    rts




;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcSCol / L_SetColourRGB12                   *
; *-----------------------------------------------------------*
; * Description : This method update the default Amos Profes- *
; *               -sional "Set Colour" method to update both  *
; *               HIGH and LOW RGB24 colors, to keep correct  *
; *               color values                                *
; *                                                           *
; * Parameters : D1 = Color register ( 0-255 )                *
; *              D2 = 12 bits Color value ( R4G4B4 )          *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    SetColourRGB12
EcSCol:
    move.l     d2,d4                   ; D4 = RGB12 Low Bits
    Rbra       L_SetColourRGB24

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcSCol / L_SetColourRGB12                   *
; *-----------------------------------------------------------*
; * Description : This method update the default Amos Profes- *
; *               -sional "Set Colour" method to update both  *
; *               HIGH and LOW RGB24 colors, to keep correct  *
; *               color values                                *
; *                                                           *
; * Parameters : D1 = Color register ( 0-255 )                *
; *              D2 = 12 bits Color value ( R4G4B4 ) HIGH     *
; *              D4 = 12 bits Color value ( R4G4B4 ) LOW      *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
    Lib_Def    SetColourRGB24
    and.l      #$FFF,d2                ; Be sure that only R8G8B8 values are stored
    and.l      #$FFF,d4                ; Be sure that only R8G8B8 values are stored
     ; ********************************* 2019.11.13 Update Colour ID, R4G4B4 to handle 256 colors in the Screen structure palette
    and.l      #255,d1                 ; Remove 32 colours limit (original = #31) for AGA support with 256 colours limit
    cmp.w      #32,d1                  ; Check if requested color is in range 00-31 (ECS) or 32-255 (AGA Only)
    blt        ECSColor                ; if color = 32-255 -> AGAPaletteColour Else -> ECSColor
    Rbra       L_SColAga24Bits         ; Call SetColourRGB12->RGB24
;    *************************** Setup color 00-31 (Original AmosPRO setup)
ECSColor: 
    move.l     T_EcCourant(a5),a0
    lsl.w      #1,d1                   ; Colour definition is 16 bits, so d1*2 = Color Word index
    lea        EcPal(a0),a1
    add.l      d1,a1
    move.w     d2,(a1)                 ; Update screen color in table/structure palette
    move.w     d4,EcPalL-EcPal(a1)     ; 2020.08.14 Update low bits registers with the same value than the high bits as Set Colour is RGB12 only
; Update the copper by poking directly in it.
    lsl.w      #1,d1
    move.w     EcNumber(a0),d0
    lsl.w      #7,d0
    lea        T_CopMark(a5),a0
    add.w      d0,a0
    cmp.w      #PalMax*4,d1
    bcs.s      ECol0
    lea        64(a0),a0               ; ****************************************** CHECKER si le positionnement correspond bien à Color00 ($0180) dans la Copper List.
ECol0:
    move.l     (a0)+,d0
    beq.s      ECol1
    move.l     d0,a1
    move.w     d2,2(a1,d1.w)             ; **** 2020.08.29 SET COLOUR AGA
    move.w     d4,2+68(a1,d1.w)          ; Update 2nd RGB12 color register in copper list ( ( 16 colors +  BplCon3 ) * ( 2 bytes reg + 2 bytes datas ) ) = 68 )
    bra.s      ECol0
ECol1:
    moveq    #0,d0
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

  Lib_Def    FonCall
; - - - - - - - - - - - - -
    moveq     #23,d0
    Rbra    L_GoError

    Lib_Def agaErr1         ; Aga color palette creation valid range is 0-7.
    moveq   #1,d0
    Rbra    L_agaErrors

    Lib_Def agaErr2         ; The requested Aga color palette index already exists.
    moveq   #2,d0
    Rbra    L_agaErrors

    Lib_Def agaErr3         ; Cannot alocate memory to create new color palette.
    moveq   #3,d0
    Rbra    L_agaErrors

    Lib_Def agaErr4         ; The requested Aga color palette does not exists.
    moveq   #4,d0
    Rbra    L_agaErrors
.
    Lib_Def agaErr5         ; Starting Aga color palette position is invalid (range 0-255)
    moveq   #5,d0
    Rbra    L_agaErrors

    Lib_Def agaErr6         ; Aga color palette range cannot exceed value 255.
    moveq   #6,d0
    Rbra    L_agaErrors

    Lib_Def agaErr7         ; Screen index is invalid. (Valid range 0-12).
    moveq   #7,d0
    Rbra    L_agaErrors

    Lib_Def agaErr8         ; Chosen screen color range exceed maximum screen amount of colors.
    moveq   #8,d0
    Rbra    L_agaErrors

    Lib_Def agaErr9         ; Invalid amount of colors to copy (Valid range is 1-255 for AGA or 1-31 for ECS).
    moveq   #9,d0
    Rbra    L_agaErrors

    Lib_Def agaErr10        ; Invalid color index (Valid range is 0-255 for AGA and 0-31 for ECS).
    moveq   #10,d0
    Rbra    L_agaErrors

    Lib_Def agaErr12         ; Cannot allocate memory to create new IFF/ILBM color palette.
    moveq   #12,d0
    Rbra    L_agaErrors

    Lib_Def FCall
; - - - - - - - - - - - - -
    moveq   #13,d0
    Rbra    L_agaErrors

    Lib_Def agaErr14         ; The specified file is not an IFF/ILBM Color Map (CMAP) file.
    moveq   #14,d0
    Rbra    L_agaErrors

    Lib_Def agaErr15         ; Cannot allocate memory to store the IFF/ILBM CMAP file.
    moveq   #15,d0
    Rbra    L_agaErrors

    Lib_Def agaErr16         ; The loaded IFF/ILBM, CMAP header is not found.
    moveq   #16,d0
    Rbra    L_agaErrors

    Lib_Def agaErr17         ; The Color palette colors amount is corrupted
    moveq   #17,d0
    Rbra    L_agaErrors

    Lib_Def agaErr18         ; The Color palette colors amount is corrupted
    moveq   #18,d0
    Rbra    L_agaErrors

    Lib_Def agaErr19         ; The IFF Color palette colors amount is corrupted
    moveq   #19,d0
    Rbra    L_agaErrors

    Lib_Def agaErr20         ; The IFF/FORM file size is incorrect.
    moveq   #20,d0
    Rbra    L_agaErrors

    Lib_Def agaErr21         ; No screen available for the requested operation
    moveq   #21,d0
    Rbra    L_agaErrors

    ; 2020.10.02 AGA Rainbows system error messages
    Lib_Def agaErr22         ; Rainbow parameters are incorrect
    moveq   #22,d0
    Rbra    L_agaErrors

    Lib_Def agaErr23         ; Not enough memory to create the rainbow
    moveq   #23,d0
    Rbra    L_agaErrors

    Lib_Def agaErr24         ; The amount of lines for an AGA Rainbow, must be greater than 2
    moveq   #24,d0
    Rbra    L_agaErrors

    Lib_Def agaErr25         ; The AGA Rainbow index is incorrect. Valid range is 0-3
    moveq   #25,d0
    Rbra    L_agaErrors

    Lib_Def agaErr26         ; Cannot alocate memory to create new AGA Rainbow buffer.
    moveq   #26,d0
    Rbra    L_agaErrors

    Lib_Def agaErr27         ; The current buffer does not contain a valid AGA Rainbow AMRB content
    moveq   #27,d0
    Rbra    L_agaErrors

    Lib_Def agaErr28         ; The current AMRB buffer is corrupted
    moveq   #28,d0
    Rbra    L_agaErrors

    Lib_Def agaErr29         ; The requested Aga rainbow buffer index already exists.
    moveq   #29,d0
    Rbra    L_agaErrors

    Lib_Def agaErr30         ; The requested Aga rainbow buffer does not exists.
    moveq   #30,d0
    Rbra    L_agaErrors

    Lib_Def agaErr31         ; The requested line is out of current Aga Rainbow range
    moveq   #31,d0
    Rbra    L_agaErrors

    Lib_Def agaErrors
    lea     ErrMess(pc),a0
    moveq   #0,d1        * Can be trapped
    moveq   #ExtNb,d2    * Number of extension
    moveq   #0,d3        * IMPORTANT!!!
    Rjmp    L_ErrorExt    * Jump to routine...

ErrMess:
    dc.b    "err0",0
    dc.b    "Aga color palette creation valid range is 0-7.",0                                     * Error #1
    dc.b    "The requested Aga color palette index already exists.", 0                             * Error #2
    dc.b    "Cannot alocate memory to create new color palette.",0                                 * Error #3
    dc.b    "The requested Aga color palette does not exists.",0                                   * Error #4
    dc.b    "Starting Aga color palette position is invalid (Valid range 0-255).", 0               * Error #5
    dc.b    "Aga color palette range cannot exceed value 255.", 0                                  * Error #6
    dc.b    "Screen index is invalid. (Valid range 0-12).", 0                                      * Error #7
    dc.b    "Chosen screen color range for copy is out of screen colors range.", 0                 * Error #8
    dc.b    "Invalid amount of colors to copy (Valid range is 1-255 for AGA and 1-31 for ECS).",0  * Error #9
    dc.b    "Invalid color index (Valid range is 0-255 for AGA and 0-31 for ECS).",0               * Error #10
    dc.b    "Cannot open file to write memory block.",0                                            * Error #11
    dc.b    "Cannot allocate memory to create new IFF/ILBM color palette.",0                       * Error #12
    dc.b    "The entered filename is invalid.",0                                                   * Error #13
    dc.b    "The specified file is not an IFF/ILBM Color Map (CMAP) file.",0                       * Error #14
    dc.b    "Cannot allocate memory to store the IFF/ILBM CMAP file.",0                            * Error #15
    dc.b    "The loaded IFF/ILBM, CMAP header is not found.",0                                     * Error #16
    dc.b    "The Color palette colors amount is corrupted.",0                                      * Error #17
    dc.b    "The AGA Color palette block is corrupted.",0                                          * Error #18
    dc.b    "The IFF CMAP Color palette colors amount is corrupted.",0                             * Error #19
    dc.b    "The IFF/FORM file size is incorrect.",0                                               * Error #20
    dc.b    "No screen available for the requested operation",0                                    * Error #21
    dc.b    "Rainbow parameters are incorrect",0                                                   * Error #22
    dc.b    "Not enough memory to create the rainbow",0                                            * Error #23
    dc.b    "The amount of lines for an AGA Rainbow must be greater than 2",0                      * Error #24
    dc.b    "The AGA Rainbow index is incorrect. Valid range is 0-3",0                             * Error #25
    dc.b    "Cannot alocate memory to create new AGA Rainbow buffer.",0                            * Error #26
    dc.b    "The current buffer does not contain a valid AGA Rainbow AMRB content",0               * Error #27
    dc.b    "The current AMRB buffer is corrupted",0                                               * Error #28
    dc.b    "The requested Aga rainbow buffer index already exists.", 0                            * Error #29
    dc.b    "The requested Aga rainbow buffer does not exists.",0                                  * Error #30
    dc.b    "The requested line is out of current Aga Rainbow range",0                             * Error #31
    dc.b    "Frederic Cordier Copyrights (c)2019-2020", 0
;* IMPORTANT! Always EVEN!
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
C_Title    dc.b    "AMOSPro Aga Support extension V "
    Version
    dc.b    0,"$VER: "
    Version
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
