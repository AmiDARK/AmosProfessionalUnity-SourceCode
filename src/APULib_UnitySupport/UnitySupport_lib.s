
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
; **************** Color palette support



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
    and.l      #$0F,d0                 ; d1 = in Interval {0-15} (Ignore high bits as there are only 3 formats supported)
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
    and.l      #$0F,d0
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
    and.l      #$0F,d0                 ; d1 = in Interval {0-15} (Ignore high bits as there are only 3 formats supported)
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

    Lib_Def Err1             ; Aga color palette creation valid range is 0-7.
    moveq   #1,d0
    Rbra    L_Errors

    Lib_Def Err2             ; The requested Aga color palette index already exists.
    moveq   #2,d0
    Rbra    L_Errors

    Lib_Def Err3             ; Cannot alocate memory to create new color palette.
    moveq   #3,d0
    Rbra    L_Errors

    Lib_Def Err4             ; The requested Aga color palette does not exists.
    moveq   #4,d0
    Rbra    L_Errors

    Lib_Def Err5             ; Starting Aga color palette position is invalid (range 0-255)
    moveq   #5,d0
    Rbra    L_Errors

    Lib_Def Err6             ; Aga color palette range cannot exceed value 255.
    moveq   #6,d0
    Rbra    L_Errors

    Lib_Def Err7             ; Screen index is invalid. (Valid range 0-12).
    moveq   #7,d0
    Rbra    L_Errors

    Lib_Def Err8             ; Chosen screen color range exceed maximum screen amount of colors.
    moveq   #8,d0
    Rbra    L_Errors

    Lib_Def Err9             ; Invalid amount of colors to copy (Valid range is 1-255 for AGA or 1-31 for ECS).
    moveq   #9,d0
    Rbra    L_Errors

    Lib_Def FCall
    moveq   #13,d0
    Rbra    L_Errors

    Lib_Def Err14            ; The specified file is not an IFF/ILBM Color Map (CMAP) file.
    moveq   #14,d0
    Rbra    L_Errors

    Lib_Def Err15            ; Cannot allocate memory to store the IFF/ILBM CMAP file.
    moveq   #15,d0
    Rbra    L_Errors

    Lib_Def Err16            ; The loaded IFF/ILBM, CMAP header is not found.
    moveq   #16,d0
    Rbra    L_Errors

    Lib_Def Err19            ; The IFF Color palette colors amount is corrupted
    moveq   #19,d0
    Rbra    L_Errors

    Lib_Def Err20            ; The IFF/FORM file size is incorrect.
    moveq   #20,d0
    Rbra    L_Errors

    Lib_Def Errors
    lea     ErrMess(pc),a0
    moveq   #0,d1        * Can be trapped
    moveq   #ExtNb,d2    * Number of extension
    moveq   #0,d3        * IMPORTANT!!!
    Rjmp    L_ErrorExt    * Jump to routine...

ErrMess:
    dc.b    "err0",0
    dc.b    "Color palette creation valid range is 0-7.",0                                         * Error #1
    dc.b    "The requested color palette index already exists.", 0                                 * Error #2
    dc.b    "Cannot alocate memory to create new color palette.",0                                 * Error #3
    dc.b    "The requested color palette does not exists.",0                                       * Error #4
    dc.b    "Starting color palette position is invalid (Valid range 0-255).", 0                   * Error #5
    dc.b    "Color palette range cannot exceed value 255.", 0                                      * Error #6
    dc.b    "Screen index is invalid. (Valid range 0-12).", 0                                      * Error #7
    dc.b    "Chosen screen color range for copy is out of screen colors range.", 0                 * Error #8
    dc.b    "Invalid amount of colors to copy (Valid range is 1-255 for AGA and 1-31 for ECS).",0  * Error #9
    dc.b    "",0                                                                                   * Error #10
    dc.b    "",0                                                                                   * Error #11
    dc.b    "",0                                                                                   * Error #12
    dc.b    "",0                                                                                   * Error #13
    dc.b    "The specified file is not an IFF/ILBM Color Map (CMAP) file.",0                       * Error #14
    dc.b    "Cannot allocate memory to store the IFF/ILBM CMAP file.",0                            * Error #15
    dc.b    "The loaded IFF/ILBM, CMAP header is not found.",0                                     * Error #16
    dc.b    "",0                                                                                   * Error #17
    dc.b    "",0                                                                                   * Error #18
    dc.b    "The IFF CMAP Color palette colors amount is corrupted.",0                             * Error #19
    dc.b    "The IFF/FORM file size is incorrect.",0                                               * Error #20
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
