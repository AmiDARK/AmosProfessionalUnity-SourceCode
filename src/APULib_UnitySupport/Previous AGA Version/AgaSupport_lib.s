
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
    Include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
    Include    "src/AmosProAGA_Version.s"

; *** 2020.09.17 This one for ILBM/IFF CMAP files created by F.C
    Include    "iffIlbm_Equ.s"

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
    dc.w    L_Nul,L_isAgaDetected
    dc.b    "is aga detecte","d"+$80,"0",-1
    dc.w    L_Nul,L_isScreenInHam8Mode
    dc.b    "is ham","8"+$80,"0",-1
    dc.w    L_Nul,L_getHam8Value
    dc.b    "ham","8"+$80,"0",-1
    dc.w    L_Nul,L_getHam6Value
    dc.b    "ham","6"+$80,"0",-1
    dc.w    L_Nul,L_getRgb24bColorSCR
    dc.b    "get rgb24 colou","r"+$80,"00",-1
    dc.w    L_setRgb24bColorSCR,L_Nul
    dc.b    "set rgb24 colou","r"+$80,"I0,0",-1
    dc.w    L_fadeAGAstep,L_Nul
    dc.b    "step fade ag","a"+$80,"I0",-1
    dc.w    L_fadeAGA,L_Nul
    dc.b    "fade ag", "a"+$80,"I0",-1
    dc.w    L_fadeAGAtoPalette,L_Nul
    dc.b    "fade to aga palett", "e"+$80,"I0,0",-1
    dc.w    L_Nul,L_retRgb24Color
    dc.b    "rgb2","4"+$80,"00,0,0",-1
    dc.w    L_Nul,L_retRgbR8FromRgb24Color
    dc.b    "rgbr","8"+$80,"00",-1
    dc.w    L_Nul,L_retRgbG8FromRgb24Color
    dc.b    "rgbg","8"+$80,"00",-1
    dc.w    L_Nul,L_retRgbB8FromRgb24Color
    dc.b    "rgbb","8"+$80,"00",-1
    dc.w    L_createAGAPalette,L_Nul
    dc.b    "create aga palett","e"+$80,"I0",-1
    dc.w    L_deleteAGAPalette,L_Nul
    dc.b    "delete aga palett","e"+$80,"I0",-1
    dc.w    L_Nul,L_getAgaPeletteExists
    dc.b    "aga palette exis","t"+$80,"00",-1
    dc.w    L_loadAgaPalette,L_Nul
    dc.b    "load aga palett","e"+$80,"I2,0",-1
    dc.w    L_setAgaPalette,L_Nul
    dc.b    "set aga palett","e"+$80,"I0",-1
    dc.w    L_getAgaPalette,L_Nul
    dc.b    "get aga palett","e"+$80,"I0",-1
    dc.w    L_saveAgaPalette,L_Nul
    dc.b    "save aga palett","e"+$80,"I2,0",-1



;    dc.w    L_Nul,L_retRgb25Color
;    dc.b    "rgb2","5"+$80,"00,0,0,0",-1
;    dc.w    L_Nul,L_getRgb24rColor
;    dc.b    "rgbr2","5"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb24gColor
;    dc.b    "rgbg2","5"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb24bColor
;    dc.b    "rgbb2","5"+$80,"00",-1
;    dc.w    L_cscToAaPl1,L_Nul
;    dc.b    "get aga colors from scree","n"+$80,"I0,0,0t0,0",-1
;    dc.w    L_Nul,L_getColour
;    dc.b    "get aga colou","r"+$80,"00,0",-1
;    dc.w    L_Nul,L_getRgb4FromRgb8
;    dc.b    "get rgb4 from rgb","8"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb8FromRgb4
;    dc.b    "get rgb8 from rgb","4"+$80,"00",-1
;    dc.w    L_Nul,L_retRgb12Color
;    dc.b    "rgb1","2"+$80,"00,0,0",-1
;    dc.w    L_Nul,L_getRgb12rColor
;    dc.b    "rgbr1","2"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb12gColor
;    dc.b    "rgbg1","2"+$80,"00",-1
;    dc.w    L_Nul,L_getRgb12bColor
;    dc.b    "rgbb1","2"+$80,"00",-1
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
; The first routine of the library will perform all initialisations in the
; booting of AMOS.
;
; I have put here all the music datazone, and all the interrupt routines.
; I suggest you put all you C-Code here too if you have some...

; ALL the following code, from L0 to L1 will be copied into the compiled 
; program (if any music is used in the program) at once. All RBSR, RBRA etc
; will be detected and relocated. AMOSPro extension loader does the same.
; The length of this routine (and of any routine) must not exceed 32K

; - - - - - - - - - - - - -
    Lib_Def    AgaSupport_Cold
; - - - - - - - - - - - - -
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


; *******************     Insert cold start there !!!!!!!!!!!!!!!!!!!!!

; As you can see, you MUST preserve A3-A6, and return in D0 the 
; Number of the extension if everything went allright. If an error has
; occured (no more memory, no file found etc...), return -1 in D0 and
; AMOS will refuse to start.
    movem.l    (sp)+,a3-a6
    moveq    #ExtNb,d0    * NO ERRORS
    move.w    #$0110,d1    * Version d'ecriture
    rts

; In case this extension is runned on AMOSPro V1.00
BadVer:
    moveq    #-1,d0        * Bad version number
    sub.l    a0,a0
    rts

; This routine is called each time a DEFAULT occurs...
;
; The next instruction loads the internal datazone address. I could have
; of course done a load MB(pc),a3 as the datazone is in the same
; library chunk. 
AgaSupportDef:
    Dload a3
    ; Put your setup needs here
    rts

; This routine is called when you quit AMOS or when the compiled program
; ends. If you have opend devices, reserved memory you MUST close and
; restore everything to normal.

AgaSupportEnd:
    Dload    a3
    ; Put your close needs here

    ; ******************************** Delete all AGA Color palette from memory
    move.l     #0,d3
    lea        T_AgaColorPals(a5),a2
    move.l     #7,d7
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
    rts

; This routine is called after any bank has been loaded, reserved or erased.
; Here, if a music is being played and if the music bank is erased, I MUST
; stop the music, otherwise it might crash the computer. That''s why I
; do a checksum on the first bytes of the bank to see if they have changed...
BkCheck:
    rts


agaDatas:

agaVectors:
    bra        AGAfade1        ; Fade to Black
    bra        AGAfade2        ; Fade to specific color palette




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

; ************************************* 2020.09.29 New method to fade from current color used to a chosen AGA Color palette - Start
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

; The size of an AGA Color palette containing : "CMAP"( .l ) = 4 , CMAPSize( .l ) = 4, up to 256 RGB24 Colors ( 256 * 3.b ) = 768, $FFFF = 2 ; Total = 778 -> Push 780
agaColorPaletteSize    equ     780

CheckAGAPaletteRange MACRO
    cmp.l      #agaPalCnt,\1           ; Uses AMOSProAGA_library_Equ.s/agaPalCnt equate for limit (default = 8)
    Rbge       L_agaErr1               ; errPal1 : Palette creation slots are 0-7
    cmp.l      #0,\1
    Rbmi       L_agaErr1               ; errPal1 : Palette creation slots are 0-7
                     ENDM

LoadAGAPalette       MACRO
    lea        T_AgaColorPals(a5),\2
    lsl.l      #2,\1
    move.l     (\2,\1.w),\2
    lsr.l      #2,\1
    cmpa.l     #0,\2
                     ENDM

ClearAGAPalette      MACRO
    lea        T_AgaColorPals(a5),\2
    lsl.l      #2,\1
    move.l     #0,(\2,\1.w)
    lsr.l      #2,\1
                     ENDM


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     +++ One empty routine here!
;    Not really needed, but just to show the macro.
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Empty

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

    ; ****************************************** Return The RGB24 value of a color register
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
    EcCall     SColAga24Bits
    rts

    ; ****************************************** 2020.09.16 New Method : Prepare the AGA fading system - Start
    ; D3 = Speed (Step) used for the fading (can be negative = fade to black, or positive = fade to white)
  Lib_Par      fadeAGAstep             ; d3 = speed used for the screen fading system.
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     #1,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.w     d3,T_FadeStep(a5)       ; Set a step different from 1
    move.b     #1,T_isFadeAGA(a5)
    Rbra       L_fadeAGAinside

    ; ****************************************** 2020.09.16 New Method : Prepare the AGA fading system - Start
    ; D3 = Speed ( = 1/Speed ) used for the fading (can be negative = fade to black, or positive = fade to white)
  Lib_Par      fadeAGA                 ; d3 = speed used for the screen fading system.
    movem.l    d1-d4/a0-a2,-(sp)       ; Save Regsxm
    move.w     d3,T_FadeVit(a5)        ; Save the speed used for the fading System 
    move.w     #1,T_FadeCpt(a5)        ; Counter set at 1 to run 1st fade on 1st call.
    move.w     #1,T_FadeStep(a5)       ; Set a step different from 1
    move.b     #1,T_isFadeAGA(a5)
    Rbra       L_fadeAGAinside

    ; ****************************************** Fade color palette to AGA Color palette
    ; D3 = Speed (Step), (a3)+ = AGA Color Palette to use.
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
    Move.l     (a3)+,d2     ; D2 = ......G8
    And.l      #$FF,d2       ; D2 = ......G8
    Move.l     (a3)+,d1     ; D1 = ......B8
    And.l      #$FF,d1       ; D1 = ......R8
    Lsl.l      #8,d1         ; D1 = ....R8..
    Or.l       d1,d2         ; D2 = ....R8G8
    Lsl.l      #8,d2         ; D2 = ..R8G8..
    Or.l       d2,d3         ; D3 = ..R8G8B8
    Ret_Int

    ; ****************************************** Return 8 bits RED color data from RGB24 color
    ; Parameters :
    ; D3   = RGB24 color
    ; Return :
    ; (Integer)Red8
    ;
  Lib_Par      retRgbR8FromRgb24Color
    and.l      #$FF0000,d3   ; D3 = ..R8....
    swap       d3
    Ret_Int

    ; ****************************************** Return 8 bits GREEN color data from RGB24 color
    ; Parameters :
    ; D3   = RGB24 color
    ; Return :
    ; (Integer)Green8
    ;
  Lib_Par      retRgbG8FromRgb24Color
    and.l      #$FF00,d3   ; D3 = ....G8..
    lsr.l      #8,d3
    Ret_Int

    ; ****************************************** Return 8 bits BLUE color data from RGB24 color
    ; Parameters :
    ; D3   = RGB24 color
    ; Return :
    ; (Integer)Blue8
    ;
  Lib_Par      retRgbB8FromRgb24Color
    and.l      #$FF,d3   ; D3 = ......B8
    Ret_Int


    ; ****************************************** This method will create a memory space to store 256 RGB25 colors aga palette
  Lib_Par      createAGAPalette
    CheckAGAPaletteRange d3            ; Check limits for color palette indexes
    LoadAGAPalette d3,a2
    Rbne       L_agaErr2               ; No = Aga Color Palette already Exists -> Error "Aga Palette already exists"
    Rbsr       L_CreateAgaPaletteBlock ; Create the memory block for the chosen Aga Color Palette
    rts

    ; ****************************************** This method will delete a previously created memory space to store 256 RGB25 colors aga palette
  Lib_Par      deleteAGAPalette
    CheckAGAPaletteRange d3
    LoadAGAPalette d3,a1
    cmpa.l     #0,a1
    Rbeq       L_agaErr4
    ClearAGAPalette d3,a2
    Move.l     #agaColorPaletteSize,d0                 ; 776 bytes = "CMAP" (4 bytes) + "CmapLength" (2 bytes) + ( 256 colors * 3 bytes long for each ) + "-1" ( 2 Bytes )
    SyCall     MemFree
    rts

    ; ****************************************** This method will return =1 if the chosen Aga Colors palette exists, otherwise =0
  Lib_Par      getAgaPeletteExists
    CheckAGAPaletteRange d3
    LoadAGAPalette d3,a2
    beq.s      gape1
    moveq      #1,d3
gape1:
    Ret_Int


    ; ****************************************** Allocate memory block for the Aga IFF/ILBM CMAP File.
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

    ; ****************************************** Load an AGA Palette from disk
    ; D3    = AGA Color Palette Bank ID (0-7)
    ; (a3)+ = IFF/ILBM color map file
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
    Rbsr       L_SaveRegs2             ; Save AMOS System registers
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
    Rbsr       L_LoadRegs2             ; Load Amos System registers
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
    ; **************** Send an error if a content of the file is not compliant with IFF/ILBM CMAP File
  Lib_Def    notCMAPFile
    Rbsr       L_LoadRegs2             ; Load Amos System registers
    Rbsr       L_CloseFile
    Rbra       L_agaErr14              ; Error : The specified file is not an IFF/ILBM Color Map (CMAP) file.
    rts
  Lib_Def    notCMAPFileSizeKO
    Rbsr       L_LoadRegs2             ; Load Amos System registers
    Rbsr       L_CloseFile
    Rbra       L_agaErr20              ; Error : The IFF/FORM file size is incorrect.
    rts

    ; ****************************************** Update screen palette using a loaded color palette
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
;    cmp.w      #32,d3                  ; 2019.11.18 Adding to select which palette mode we update. ECS or AGA
;    bhi.s      IFFAgaVersion           ; 2019.11.18 If more than 32 Colors, then -> Jump to AGA palette update.
;    EcCall     SPal
;    rts
;IFFAgaVersion:                         ; 2019.11.18 call the updated method that handle full 256 colors AGA palette 
    EcCall     SPalAGA
    rts

    ; ****************************************** Push a screen color palette directly inside an AGA color palette slot.
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

    ; ****************************************** Load an AGA Palette from disk
    ; D3    = AGA Color Palette Bank ID (0-7)
    ; (a3)+ = IFF/ILBM color map file
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
    Rbsr       L_SaveRegs2             ; Save AMOS System registers
    move.l     Handle(a5),d1           ; D1 = File Handle
    move.l     T_AgaCMAPColorFile(a5),a0 ; Load buffer in A0
    Move.l     a0,d2                   ; D2 = A0 (Save) = Buffer to output
    move.l     d4,d3                   ; D3 = XXX bytes to write (calculated by the call L_PushColorD3ToCmapBlock)
    Rbsr       L_IffWriteFile2         ; Dos->Write
    Rbsr       L_LoadRegs2             ; Load Amos System registers
    Rbsr       L_CloseFile             ; Doc -> Close
    rts















; ********************************************** Methods copied from AmosProAga_lib.s - START
    Lib_Def    NomDisc2
; - - - - - - - - - - - - -
    move.w    (a2)+,d2
    Rbeq    L_FonCall2
    cmp.w    #108,d2
    Rbcc    L_FonCall2
    move.l    Name1(a5),a0
    Rbsr    L_ChVerBuf22
    Rjsr    L_Dsk.PathIt
    rts
; - - - - - - - - - - - - -
    Lib_Def    ChVerBuf22
; - - - - - - - - - - - - -
    move.l    a2,a1
    move.w    d2,d0
    beq.s    Chv2
    subq.w    #1,d0
    cmp.w    #510,d0
    bcs.s    Chv1
    move.w    #509,d0
Chv1:    move.b    (a1)+,(a0)+
    dbra    d0,Chv1
Chv2:    clr.b    (a0)+
    rts
; - - - - - - - - - - - - -
    Lib_Def    FonCall2
; - - - - - - - - - - - - -
    moveq     #23,d0
    Rbra    L_GoError2
; - - - - - - - - - - - - -
    Lib_Def    GoError2
; - - - - - - - - - - - - -
    Rjmp    L_Error
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     ROUTINES DISQUE
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    OpenFile
; - - - - - - - - - - - - -
    move.l     Name1(a5),d1
    Rbra    L_OpenFileD1
; - - - - - - - - - - - - -
    Lib_Def    OpenFileD1
; - - - - - - - - - - - - -
    move.l    a6,-(sp)
    move.l    DosBase(a5),a6
    jsr       _LVOOpen(a6)
    move.l    (sp)+,a6
    move.l    d0,Handle(a5)
; Branche la routine de nettoyage en cas d''erreur
    move.l    a2,-(sp)
    lea    .Struc(pc),a1
    lea    Sys_ErrorRoutines(a5),a2
    SyCall    AddRoutine
    lea    .Struc2(pc),a1
    lea    Sys_ClearRoutines(a5),a2
    SyCall    AddRoutine
    move.l    (sp)+,a2
    move.l    Handle(a5),d0
    rts
.Struc    dc.l    0
    Rbra    L_CloseFile
.Struc2    dc.l    0
    Rbra    L_CloseFile
; - - - - - - - - - - - - -
    Lib_Def    CloseFile
; - - - - - - - - - - - - -
    movem.l    d0/d1/a0/a1/a6,-(sp)
    move.l    Handle(a5),d1
    beq.s    .Skip
    clr.l    Handle(a5)
    move.l    DosBase(a5),a6
    jsr    _LVOClose(a6)
.Skip    movem.l    (sp)+,d0/d1/a0/a1/a6
    rts
; - - - - - - - - - - - - -
    Lib_Def    ReadFile
; - - - - - - - - - - - - -
    movem.l    d1/a0/a1/a6,-(sp)
    move.l    Handle(a5),d1
    move.l    DosBase(a5),a6
    jsr    _LVORead(a6)
    movem.l    (sp)+,d1/a0/a1/a6
    cmp.l    d0,d3
    rts
; - - - - - - - - - - - - -
    Lib_Def    DiskFileError
; - - - - - - - - - - - - -
    move.l    a6,-(sp)
    move.l    DosBase(a5),a6
    jsr    _LVOIoErr(a6)
    move.l    (sp)+,a6
    Rbra    L_DiskFileErr
; - - - - - - - - - - - - -
    Lib_Def    DiskFileErr
; - - - - - - - - - - - - -
    lea    ErDisk(pc),a0
    moveq    #-1,d1
DiE1:    addq.l    #1,d1
    move.w    (a0)+,d2
    bmi.s    DiE2
    cmp.w    d0,d2
    bne.s    DiE1
    add.w    #DEBase,d1
    move.w    d1,d0
    move.l    Fs_ErrPatch(a5),d3
    Rbeq    L_GoError2
    move.l    d3,a0
    jmp    (a0)
DiE2:
    moveq    #DEBase+15,d0
    Rbra    L_GoError2
; Table des erreurs reconnues
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
ErDisk:    dc.w 203,204,205,210,213,214,216,218
    dc.w 220,221,222,223,224,225,226,-1
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Lecture pour IFF
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    IffReadFile2
; - - - - - - - - - - - - -
; D1 = File
; D2 = Buffer
; D3 = Length
    movem.l    a0/a1/a6/d1,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVORead(a6)
    movem.l    (sp)+,a0/a1/a6/d1
    tst.l      d0
    Rbmi       L_DiskFileError
    rts

    Lib_Def    IffWriteFile2
; - - - - - - - - - - - - -
; D1 = File
; D2 = Buffer
; D3 = Length
    movem.l    a0/a1/a6/d1,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOWrite(a6)
    movem.l    (sp)+,a0/a1/a6/d1
    tst.l      d0
    Rbmi       L_DiskFileError
    rts
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauvegarde les registres D5-D7
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    SaveRegs2
; - - - - - - - - - - - - -
    movem.l    d6-d7,ErrorSave(a5)
    move.b    #1,ErrorRegs(a5)
    rts
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Recupere les registres D5-D7
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    LoadRegs2
; - - - - - - - - - - - - -
    movem.l    ErrorSave(a5),d6-d7
    clr.b    ErrorRegs(a5)
    rts

; ********************************************** Methods copied from AmosProAga_lib.s - END




























; *********************************************************** End of integration from AmosProAGA_lib.s





































 Lib_Par       getScreenAGAPalette
    move.l     d3,d1           ; D1 = Current Screen ID
    Rbsr       L_GetEc         ; A0 = Current Screen
; Copy 224 Colors High Bits from screen to global AGA Palette
    lea    EcScreenAGAPal(a0),a1   ; A1 = Color 32 High bits
    lea    T_globAgaPal(a5),a2
    move.l     #223,d0         ; 224 Colors to copy in the T_globAgaPal(L)
    bsr.s      llp
; Copy 224 Colors Low Bits from screen to global AGA Palette
    lea    EcScreenAGAPalL(a0),a1  ; A1 = Color 32 High bits
    lea    T_globAgaPalL(a5),a2
    move.l     #223,d0         ; 224 Colors to copy in the T_globAgaPal(L)
    bsr.s      llp
    Moveq      #0,d0
    rts
llp:
    move.w     (a1)+,(a2)+         ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    dbra       d0,llp

    EcCall     UpdateAGAColorsInCopper ; Call method to update the copper list with the modified colors.

    rts


    ; ****************************************** Return RGB25 color from Genlock1,RED8,GREEN8,BLUE8 components
    Lib_Par  retRgb25Color
    And.l #$FF,d3       ; B8 is already in D3
    Move.l (a3)+,d2     ; Get G8
    And.l #$FF,d2
    Move.l (a3)+,d1     ; Get R8
    And.l #$FF,d1
    Move.l (a3)+,d4     ; get Genlock value
    And.l   #%1,d4      ; D4 = D4 && $%1
    Lsl.l   #8,d4       ; D4 = push to $100
    Swap    d4          ; D4 = push to $1000000
    Lsl.l #8,d1         ; Puch R8.. in d1
    Or.w  d1,d2         ; Put R8G8 in D2
    Lsl.l #8,d2         ; Push R8G8.. in d2
    Or.l  d2,d3         ; D3 = R8G8B8
    Or.l  d4,d3         ; Add genlock value
    Ret_Int

    ; ****************************************** Return RED component from RGB24/25 color
    Lib_Par  getRgb24rColor
    And.l   #$FF0000,d3
    Swap    d3 
    Ret_Int       

    ; ****************************************** Return GREEN component from RGB24/25 color
    Lib_Par getRgb24gColor
    And.l   #$FF00,d3
    Lsr.l   #8,d3
    Ret_Int       

    ; ****************************************** Return BLUE component from RGB24/25 color
    Lib_Par getRgb24bColor
    And.l   #$FF,d3
    Ret_Int       

    ; ****************************************** This method will copy part of screen color palette to created Aga Color Palette
    Lib_Par  cscToAaPl1

    ; * 1. We get all parameters to makes A3 be at the correct position.
    ; Last parameter -> D3      ; D3 = DESTINATION : Aga Color Palette Start Copy Position
    Move.l  (a3)+,d5        ; D5 = DESTINATION : Chosen color palette to use for save.
    Move.l  (a3)+,d4        ; ****************************************** D4 = SOURCE : Amount of colors to copy from Screen
    Move.l  (a3)+,d2        ; ****************************************** D2 = SOURCE : First color to copy from screen
    Move.l  (a3)+,d1        ; D1 = SOURCE : Which screen 
    Rbra    L_copyToAgaPal

    ; ****************************************** This method will copy part of screen color palette to created Aga Color Palette
    ; D1 = SOURCE : Which screen 
    ; D2 = SOURCE : First color to copy from screen
    ; D4 = SOURCE : Amount of colors to copy from Screen
    ; D5 = DESTINATION : Chosen color palette to use for save.
    ; D3 = DESTINATION : Aga Color Palette Start Copy Position
    Lib_Def   copyToAgaPal
    ; * 1. We check if chosen color palette is valid & exists.
    cmp.l   #8,d5           ; is Index > 7 ?
    Rbge    L_agaErr1           ; if YES -> agaErr1 : Palette creation slots are 0-7
    cmp.l   #0,d5           ; is Index < 0 ?
    Rbmi    L_agaErr1           ; if YES -> agaErr1 : Palette creation slots are 0-7
    move.l  a5,a2           ; A2 = A5 = AMOS DataBase
    Add.l   #T_AgaColorPals,a2      ; A2 = Aga Color Palettes blocks 0-7 pointers list.
    Lsl.l   #2,d5           ; D5 * 4 for long 
    move.l  (a2,d5.w),d0        ; D0 = Pointer to the chosen Aga Color Palette (DESTINATION)
    tst.l   d0              ; is chosen aga palette exists ?
    Rbeq    L_agaErr4           ; if NOT -> agaErr4
    Move.l  d0,a2           ; A2 = Color Index 0 of the chosen Aga Color palette

    ; * 2. We check if destination color index & range are valids.
    cmp.l  #0,d3            ; if chosen color > -1 ?
    Rbmi   L_agaErr5        ; if NOT -> agaErr5
    Move.l d4,d0            ; D0 = Amount of colors to copy from screen
    Add.l  d3,d0            ; D0 = Amount of colors to copy from screen + Start AGA color palette index for copy
    Cmp.l  #257,d0          ; Does Start Copy Color Index + Amount of Colors to copy > 256 ?
    Rbge   L_agaErr6        ; if YES -> agaErr6
    Lsl.l  #2,d3            ; D3 * 4 for pointers alignment
    Add.l  d3,a2            : ***************************************** A2 = Color index D3 (Start) of the chosen Aga Color palette

    ; * 3. We check if chosen screen is valid and exists
    cmp.l   #12,d1          ; is Index > EcMax ? ( +WEqu.s/EcMax L88)
    Rbge    L_agaErr7           ; if YES -> agaErr1 : Screen index is invalid.
    cmp.l   #0,d1           ; if Screen ID < 0 ?
    Rbmi    L_agaErr7           ; if YES -> agaErr7 : Screen index is invalid.
    Lsl.l   #2,d1           ; D1 * 4 for pointer
    Move.l  a5,a1
    Add.l   #T_EcAdr,a1
    Move.l  (a1,d1.w),a1        ; ***************************************** A1 = Chosen Screen Data Base

    ; * 4. We check if chosen screen contain enough colors for the copy
    move.w  EcNbCol(a1),d0      ; D0 = Amount of colors available in the current Screen
    And.l   #$FFFF,d0
    Sub.l   D2,d0
    Sub.l   d4,d0
    Rbmi    L_agaErr8
    cmp.l   #0,d4
    Rble    L_agaErr9           ; No color to copy.
    Sub.w   #1,d4           ; D4=D4-1 to use minus state for copy ending

    ; * 5. We check if there are some ECS/AGA colors to copy (registers 0-31) or not.
    cmp.l   #32,d2
    bge     copyAgaColor        ; if 1st colors start at >31 -> Copy directly AGA color palette

    ; D0-D1-D3-D5 can be used from now.

    ; * 6. We copy ECS/AGA compatible color palette inside AGA color palette.
    Lea.l  EcPal(a1),a0        ; *A0 = Source Color Palette
    Lsl.l   #1,d2           ; D2 = Word aligned because ECS colors are R4G4B4 (.w)
cpyLoop:
    Move.w  (a0,d2.w),d0        ; D0 = ECS Color R4G4B4
    Rbsr    L_rgb4toRgb8      ; Convert ECS R4G4B4 to AGA R8G8B8 color
    Move.l  d0,(a2)+          ; Save current color in destination AGA Color Palette
    Sub.w   #1,d4         ; D4=D4-1 (remaining amount of colors to copy)
    bmi.s   endCpy           ; No more colors to copy ? YES -> Jump to .endCpy
    add.w   #2,d2         ; Some colors remains to copy -> D2 = Next Color register
    Cmp.w   #64,d2        ; Check if we reach Color #32 -> then continue with Aga color
    blt.s   cpyLoop          ; Next color < 32 -> Continue ECS Copy -> Jump .cpyLoop
copyAgaColor:
    Lea.l  EcScreenAGAPal(a1),a0 ; A0 = Current Screen Aga Palette in R4G4B4 mode...
cpyLoop2:
       Move.w   (a0)+,d0
       Rbsr     L_rgb4toRgb8
       Move.l   d0,(a2)+
       Sub.w    #1,d4         ; D4=D4-1 (remaining amount of colors to copy)
       bpl.s    cpyLoop2
endCpy:
       rts

    ; ************************************
    Lib_Par getColour
    ;                 D3 = Color Index to read
    Move.l (a3)+,d2           D2 = Aga Color Palette 
    ; * 1. We check if chosen color palette is valid & exists.
    cmp.l   #8,d2           ; is Index > 7 ?
    Rbge    L_agaErr1           ; if YES -> agaErr1 : Palette creation slots are 0-7
    cmp.l   #0,d2           ; is Index < 0 ?
    Rbmi    L_agaErr1           ; if YES -> agaErr1 : Palette creation slots are 0-7
    move.l  a5,a2           ; A2 = A5 = AMOS DataBase
    Add.l   #T_AgaColorPals,a2      ; A2 = Aga Color Palettes blocks 0-7 pointers list.
    Lsl.l   #2,d2           ; D5 * 4 for long 
    move.l  (a2,d2.w),d0        ; D0 = Pointer to the chosen Aga Color Palette (DESTINATION)
    tst.l   d0              ; is chosen aga palette exists ?
    Rbeq    L_agaErr4           ; if NOT -> agaErr4
    Move.l  d0,a1           ; A1 = Color Index 0 of the chosen Aga Color palette
    ; * 2. We check if Source color index is valide
    cmp.l  #0,d3            ; if chosen color > -1 ?
    Rbmi   L_agaErr5        ; if NOT -> agaErr5
    Cmp.l  #256,d3          ; Does Start Copy Color Index > 255 ?
    Rbge   L_agaErr6        ; if YES -> agaErr6
    Lsl.l  #2,d3            ; D3 * 4 for pointers alignment
    Add.l  d3,a1            : ***************************************** 12 = Color index D3 (Start) of the chosen Aga Color palette
    Move.l (a1),d3
    Ret_Int

    ; ************************************
    Lib_Par  getRgb4FromRgb8
        Move.l  d3,d0
        Rbsr     L_rgb8toRgb4
        Move.l     d0,d3
        Ret_Int

    ; ************************************
    Lib_Par  getRgb8FromRgb4
        Move.l  d3,d0
        Rbsr     L_rgb4toRgb8
        Move.l     d0,d3
        Ret_Int

    ; ************************************
    Lib_Par  retRgb12Color
    And.l #$F,d3        ; B4 is already in ..D3
    Move.l (a3)+,d2     ; Get ..G4
    And.l #$F,d2
    Move.l (a3)+,d1     ; Get ..R4
    And.l #$F,d1
    Lsl.l #4,d1         ; Puch R4.. in d1
    Or.l  d1,d2         ; Put R4G4 in D2
    Lsl.l #4,d2         ; Push R4G4.. in d2
    Or.l  d2,d3         ; D3 = R4G4B4
    Ret_Int

    ; ****************************************** Return RED component from RGB12 color
    Lib_Par  getRgb12rColor
    And.l      #$F00,d3
    Lsr.l      #8,d3
    Ret_Int       

    ; ****************************************** Return GREEN component from RGB12 color
    Lib_Par getRgb12gColor
    And.l      #$F0,d3
    Lsr.l      #4,d3
    Ret_Int       

    ; ****************************************** Return BLUE component from RGB12 color
    Lib_Par getRgb12bColor
    And.l      #$F,d3
    Ret_Int       













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
