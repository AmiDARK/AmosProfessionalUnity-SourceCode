
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


; A usefull macro to find the address of data in the extension''s own 
; datazone (see later)...
Dlea     MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-UnityDatas,\2
    ENDM

DmoveaL  MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-UnityDatas,\2
    move.l   (\2),\2
    ENDM

DmoveL   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-UnityDatas,\2
    move.l   (\2),\3
    ENDM

DmoveW   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-UnityDatas,\2
    move.w   (\2),\3
    ENDM

DmoveB   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-UnityDatas,\2
    move.b   (\2),\3
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
    dc.w    L_fadeUnitytoPalette,L_Nul
    dc.b    "unity fade to palett", "e"+$80,"I0,0",-1


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
    lea        colorSupport_Functions(pc),a0
    move.l     a0,T_ColorSupport(a5)
    movem.l    (sp)+,a0
    moveq      #0,d0

    lea        UnityVectors(pc),a0
    move.l     a0,T_UnityVct(a5)

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
UnityVectors:
    ; **************** Amos Professional Unity System : New Color palette support, fading, etc. ****************
    dc.l       0

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
    And.l      #$FF,d3       ; D3 = ......B8
    Move.b     3(a3),d2      ; D2 = xxxxxxG8
    Move.b     7(a3),d1      ; D1 = xxxxxxR8
    Or.l       #modeRgb24,d3 ; D3 = .F....B8
    And.l      #$FF,d1       ; D1 = ......R8
    lsl.w      #8,d2         ; D2 = xxxxG8..
    swap       d1            ; D1 = ..R8....
    or.w       d2,d3         ; D3 = .F..G8B8
    adda.l     #8,a3         ; Push A3 like if it was read with (a3)+
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
    Move.b     3(a3),d2  ; xxxxxxxG
    Move.b     7(a3),d1  ; xxxxxxxR
    And.w      #$F,d2    ; xxxx...G
    And.w      #$F,d1    ; xxxx...R
    And.l      #$F,d3    ; .......B
    Lsl.l      #8,d1     ; xx...R..
    Or.w       d1,d3     ; .....R.B
    Lsl.w      #4,d2     ; xxx...G.
    adda.l     #8,a3     ; Push A3 like if it was read with (a3)+
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
    move.l   #256,d3                   ; D3 = Create Colors Palette with 256 colors
    Rbra     L_CreatePalette3
.ecs:
    move.l   #32,d3                    ; D3 = Create Colors Palette with 32 colors
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
    move.l      (a3)+,d0               ; D4 = Color Palette Index
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
    movem.l     d3,-(sp)               ; Save Colour Amount
    Rjsr        L_Bnk.Reserve
    Rbeq        L_Err3                 ; Not Enough Memory to allocation memblock.

    move.l      a0,a1                  ; A1 = Memory Bank pointer (required for L_Bnk_Change)
    move.l      d2,(a0)+               ; Save full color palette
    movem.l     (sp)+,d3               ; Restore Colors Amount
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
    move.l     d0,def_CMAP_size(a0)              ; Save the Amount of colors of the colour palette block
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
    movem.l    d0/a0/a1,-(sp)
    ; ******** First, we check if the block was already created in memory
    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),d0
    tst.l      d0
    bne.s      .end
    ; ******** Secondly we create the block in memory
    move.l     #aga_iffPalSize,d0      ; Reserve a block enough large to handle a full 256 color palette in IFF/ILBM format
    SyCall     MemFastClear
    cmpa.l     #0,a0
    Rbeq       L_Err7                 ; Error 15 : Not enough memory
    ; ******** And then, we check block was created otherwise we cast an error
    Dlea       AgaCMAPColorFile,a1
    move.l     a0,(a1)                 ; Save the new block in Memory
    cmpa.l     #0,a0
.end:
    movem.l    (sp)+,d0/a0/a1
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
    move.l     (a3)+,a4                ; A4 = FileName
    movem.l    d3,-(sp)                ; Save D3 = Colors Palette ID
    ; ******** We check if the Color Palette index is in the correct range
    cmp.l      #5,d3
    Rble       L_Err1                  ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l      #255,d3
    Rbhi       L_Err1                  ; Colors Palette ID > 255 -> Error : Invalid range
    move.l     d3,d4                   ; D4 = Current Color Palette (Save)
    ; ******** We check if the block to load the file was created or not.
    Rbsr       L_CreateIFFCmapBlock    ; Verify if the memory block for CMAP File is created
    ; ******** Secondly, we check if the filename contain a path. To do that we check for a ":"
    move.l     a4,a2                   ; a2 = a4 = FileName
    Rbsr       L_NomDisc2              ; This method will update the filename to be full Path+FileName
    move.l     #1005,d2                ; D2 = READ ONLY dos file mode
    Rbsr       L_OpenFile              ; Dos->Open
    Rbeq       L_DiskFileError         ; -> Error when trying to open the file.
    Rbsr       L_SaveRegsD6D7           ; Save AMOS System registers
    move.l     Handle(a5),d1           ; D1 = File Handle
    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),a0                 ; Load buffer in A0
    Move.l     a0,d2                   ; D2 = A0 (Save)
    move.l     #12,d3                  ; D3 = 12 bytes to read
    Rbsr       L_IffReadFile2          ; Dos->Read
    Dlea       AgaCMAPColorFile,a0
    move.l     (a0),a0                 ; Load buffer in A0
    move.l     (a0),d3
    cmp.l      #"FORM",d3              ; Does the file start with "FORM" ?
    Rbne       L_notCMAPFile           ; No -> Jump L_notCMAPFile
    move.l     4(a0),d3                ; D3 = Get the file size
    ; ******** Check if FORM size is in a correct range ( 0 < size < 400 bytes )
    cmp.l      #0,d3
    Rbmi       L_notCMAPFileSizeKO
    cmp.l      #$400,d3
    Rbge       L_notCMAPFileSizeKO
    ; ******** Continue
    adda.l     #12,a0                  ; A0 = A0 + 12 -> A0 Point just after the 12 already read bytes
    move.l     a0,d2                   ; D2 = Buffer
    move.l     Handle(a5),d1           ; D1 = File Handle
    Rbsr       L_IffReadFile2          ; Read the remaining bytes
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close
    ; ******** Now that we have loaded the IFF/ILBM CMAP File in the temporary buffer, we can create the new Color Palette Bank
    movem.l    (sp),d4                 ; Restore D4 = Colors Palette ID (saved from D3)
    Dlea       AgaCMAPColorFile,a0
    Move.l     (a0),a0
    Move.l     def_CMAP_size(a0),d3    ; D3 = Colour Amount * 3
    divu       #3,d3                   ; D3 = Colour Amount
    Rbsr       L_CreatePalette3        ; D3 = Colour Amount, D4 = Colour Palette ID
    movem.l    (sp)+,d4                ; Restore D4 = Colors Palette ID (saved from D3)
    move.l      d4,d0                  ; D0 = Bank ID
    Rjsr        L_Bnk.GetAdr           ; Get Bank D0 Adress
    bne.s       .cty                   ; No bank = -> Jump .no deletion
    Rbra        L_Err4                 ; No Colors Palette Bank at this location
.cty:
    btst        #Bnk_BitPalette,d0     ; No Bnk_BitPalette flag = not a memblock
    Rbeq        L_Err5                 ; Not a Color Palette bank -> Error
    Move.l      (a0)+,d0               ; D0 = Palette bank Size, A0 = Pointer to Palette byte #0 
    Dlea        AgaCMAPColorFile,a1
    Move.l      (a1),a1                ; A1 = Loaded IFF/ILBM Color Palette file
    Add.l       #def_CMAP_size,a0      ; A0 point to CMAP Size
    Add.l       #def_CMAP,a1           ; A1 point to "CMAP" header in the loaded file.
    cmp.l       #"CMAP",(a1)
    beq.s       .loadedCMAPisOk
    Rbra        L_Err8                ; CMAP not found at its logical location
.loadedCMAPisOk:
    add.l       #4,a1                  ; A1 point to CMAP Size
    move.l      (a1)+,d0               ; D0 = CMAP size
    move.l      d0,(a0)+               ; Save CMAP Size in Colors Palette Bank
    sub.w       #2,d0
; ******** Copy Color Palette from loaded file to 
.ctCopy:
    move.w      (a1)+,(a0)+            ; Copy components 2 per 2
    sub.w       #2,d0
    bpl.s       .ctCopy
; ******** Once CMAP copy is completed, we push de DPI bloc
    move.l     #"DPI ",(a0)+
    move.l     #0,(a0)+
    rts

    ; **************** Send an error if a content of the file is not compliant with IFF/ILBM CMAP File
  Lib_Def    notCMAPFile
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile
    Rbra       L_Err6                 ; Error : The specified file is not an IFF/ILBM Color Map (CMAP) file.

  Lib_Def    notCMAPFileSizeKO
    Rbsr       L_LoadRegsD6D7          ; Load Amos System registers
    Rbsr       L_CloseFile
    Rbra       L_Err9                 ; Error : The IFF/FORM file size is incorrect.




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
    move.l      d3,d2                 ; D2 = RGB24Value
    move.l      (a3)+,d4              ; D4 = ColorID
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
    add.l       d4,a0
    ForceToRGB24 d2,d2                ; Force color value to be RGB24 bits
    move.l      d2,d0
    swap        d0
    move.b      d0,(a0)+              ; Push R8 in (a0)+
    move.l      d2,d0
    lsr.l       #8,d0
    move.b      d0,(a0)+              ; Push G8 in (a0)+
    move.b      d4,(a0)+              ; Push B8 in (a0)+
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
    ; ****************************************** Fade color palette to AGA Color palette
    ; D3 = Speed (Step), (a3)+ = AGA Color Palette to use.
  Lib_Par      fadeUnitytoPalette
    move.l     (a3)+,d0                ; D0 = Color Palette to use
    move.l     d3,d4                   ; D4 = Speed
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     d3,T_FadeStep(a5)       ; D3 = Fading speed
    ; ******** 2021.03.13 Get the Color Palette pointer, and push pointer to CMAP location inside the color palette
    cmp.l      #5,d0
    ble        FD_Err1                 ; Colors Palette ID < 6 -> Error : Invalid range
    cmp.l      #255,d0
    bhi        FD_Err1                 ; Colors Palette ID > 255 -> Error : Invalid range
    Rjsr       L_Bnk.GetAdr
    beq        FD_Err4
    btst       #Bnk_BitPalette,d0      ; No Bnk_BitPalette flag = not a Colors Palette
    beq        FD_Err3
    move.l     a0,d0                   ; d0 = color palette block size
    add.l      #4,d0                   ; Color Palette bank block size
    add.l      #def_CMAP_Colors,d0     ; D0 = Colour #0 CMAP position
    move.l     d0,T_NewPalette(a5)     ; Store the new color palette into T_NewPalette data.
    move.w     #1,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.b     #2,T_isFadeAGA(a5)      ; Use the AGA version 2 of the Fading interrupt.
    move.l     d4,d3
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
  Lib_Def      fadeUnityinside
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

  Lib_Def Err1             ; Error 01 : Aga color palette creation valid range is 0-7.
    moveq   #1,d0
    Rbra    L_Errors

  Lib_Def Err2             ; Error 02 : Colors amount is incorrect (Valids values are 2,4,8,16,32,64,128,256)
    moveq   #2,d0
    Rbra    L_Errors

  Lib_Def Err3             ; Error 03 : Not enough free memory to allocate the requested colors palette
    moveq   #3,d0
    Rbra    L_Errors

  Lib_Def Err4             ; Error 04 : There is no colors palette bank at this slot
    moveq   #4,d0
    Rbra    L_Errors

  Lib_Def Err5             ; 
    moveq   #5,d0
    Rbra    L_Errors

  Lib_Def Err6            ; The specified file is not an IFF/ILBM Color Map (CMAP) file.
    moveq   #6,d0
    Rbra    L_Errors

  Lib_Def Err7            ; Cannot allocate memory to store the IFF/ILBM CMAP file.
    moveq   #7,d0
    Rbra    L_Errors

  Lib_Def Err8            ; The loaded IFF/ILBM, CMAP header is not found at normal location.
    moveq   #8,d0
    Rbra    L_Errors

  Lib_Def Err9            ; The IFF/FORM file size is incorrect
    moveq   #9,d0
    Rbra    L_Errors

  Lib_Def Err10           ; The input RGB format is not recognized.
    moveq   #10,d0
    Rbra    L_Errors

  Lib_Def Err11           ; The requested color index is out of the color palette range.
    moveq   #11,d0
    Rbra    L_Errors


    Lib_Def Errors
    lea     ErrMess(pc),a0
    moveq   #0,d1        * Can be trapped
    moveq   #ExtNb,d2    * Number of extension
    moveq   #0,d3        * IMPORTANT!!!
    Rjmp    L_ErrorExt    * Jump to routine...

ErrMess:
    dc.b    "err0",0
; ******** Color Palette V2 error messages CURRENT VERSION
    dc.b    "Valid colors palette id range is 6-65535",0                                           * Error #1 USED
    dc.b    "Colors amount is incorrect (Valids values are 2,4,8,16,32,64,128,256)", 0             * Error #2 USED
    dc.b    "Not enough free memory to allocate the requested colors palette",0                    * Error #3 USED
    dc.b    "There is no colors palette bank at this slot",0                                       * Error #4 USED
    dc.b    "This bank is not a Color Palette bank.",0                                             * Error #5 USED
; *******
    dc.b    "The specified file is not an IFF/ILBM Color Map (CMAP) file.",0                       * Error #6 USED -> (#14)
    dc.b    "Cannot allocate memory to store the IFF/ILBM CMAP file.",0                            * Error #7 USED -> (#15)
    dc.b    "The loaded IFF/ILBM, CMAP header is not found at normal location.",0                  * Error #8 USED -> (#16)
    dc.b    "The IFF/FORM file size is incorrect.",0                                               * Error #9 USED -> (#20)
; *******
    dc.b    "The input RGB format is not recognized."                                              * Error #10
    dc.b    "The requested color index is out of the color palette range."                         * Error #11

    dc.b    "Starting color palette position is invalid (Valid range 0-255).", 0                   * Error #5 UNUSED
    dc.b    "Color palette range cannot exceed value 255.", 0                                      * Error #6 UNUSED
    dc.b    "Screen index is invalid. (Valid range 0-12).", 0                                      * Error #7 UNUSED
    dc.b    "Chosen screen color range for copy is out of screen colors range.", 0                 * Error #8 UNUSED
    dc.b    "Invalid amount of colors to copy (Valid range is 1-255 for AGA and 1-31 for ECS).",0  * Error #9 UNUSED
    dc.b    "The IFF CMAP Color palette is corrupted.",0                                          * Error #19 UNUSED
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
