
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
;    opt o+ :,w-

VersionPUL MACRO
    dc.b    "1.50beta8 24-Jun-22"
    ENDM
version MACRO
    dc.b    "1.50beta8 24-Jun-22"
    ENDM

debugvs equ 0
demover equ 0
salever equ 0

ExtNb   equ 8-1 ;Extension number 8

English equ $FACE   ;Supported (BEEF DEAD F00D)
Deutsch equ $AFFE   ;Supported

Languag equ English


;---------------------------------------------------------------------
;    +++
;    Include the files automatically calculated by
;    Library_Digest.AMOS
;---------------------------------------------------------------------
    Include    "AMOSProUnity_AMCAF_Size.s"
    Include    "AMOSProUnity_AMCAF_Labels.s"

; +++ You must include this file, it will decalre everything for you.
    include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
;    Include    "src/AmosProUnity_Version.s"


    IncDir  "includes/"
    Include "libraries/lowlevel.i"
    Include "exec/execbase.i"
    Include "graphics/gfxbase.i"
    include "graphics/rastport.i"
    Include "dos/datetime.i"
    Include "libraries/Powerpacker_lib.i"

_LVOReadJoyPort         equ -30
_LVOSetJoyPortAttrs     equ -132

    IFEQ    1

demotst MACRO
    IFNE    demover
    tst.w   T_AMOState(a5)
    bpl.s   .nocomp
    moveq.l #0,d0
    Rbra    L_Custom32
.nocomp
    ENDC
    ENDM

    ELSE

demotst MACRO
    IFNE    demover
    tst.w   T_AMOState(a5)
    Rbmi    L_Custom32
    ENDC
    ENDM
    
    ENDC

debug   MACRO
    IFEQ    debugvs-1
    illegal
    ENDC
    ENDM
; A usefull macro to find the address of data in the extension''s own 
; datazone (see later)...
dlea    MACRO
    move.l    ExtAdr+ExtNb*16(a5),\2
    add.w    #\1-PersonalUnityDatas,\2
    ENDM

; Another macro to load the base address of the datazone...
dload   MACRO
    move.l    ExtAdr+ExtNb*16(a5),\1
    ENDM

; New version of AddLabl to use in fact Lib_Par principle
L_Func  set 0
AddLabl MACRO
    IFEQ    NARG-1
\1  equ Lib_Count
    ENDC
        IFNE    Debug
        dc.b    "**"
        dc.w    Lib_Count
        ENDC
        dc.b    "GetP"
L\<Lib_Count>:
Lib_Count    set    Lib_Count+1
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

    Include "AMOSPro_AMCAF_DataZones.s"

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
; ********************************************************************
    dc.w    -1,L_AmcafBase
    dc.b    "amcaf bas","e"+$80,"0",-1
    dc.w    -1,L_AmcafVersion
    dc.b    "amcaf version","$"+$80,"2",-1
    dc.w    -1,L_AmcafLength
    dc.b    "amcaf lengt","h"+$80,"0",-1
    dc.w    L_AgaNotationOn,-1
    dc.b    "amcaf aga notation o","n"+$80,"I",-1
    dc.w    L_AgaNotationOf,-1
    dc.b    "amcaf aga notation of","f"+$80,"I",-1
    dc.w    L_BankPermanent,-1
    dc.b    "bank permanen","t"+$80,"I0",-1
    dc.w    L_BankTemporary,-1
    dc.b    "bank temporar","y"+$80,"I0",-1
    dc.w    L_BankChip,-1
    dc.b    "bank to chi","p"+$80,"I0",-1
    dc.w    L_BankFast,-1
    dc.b    "bank to fas","t"+$80,"I0",-1
    dc.w    L_BankCodeXor1,-1
    dc.b    "!bank code xor.","b"+$80,"I0,0",-2
    dc.w    L_BankCodeXor2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeAdd1,-1
    dc.b    "!bank code add.","b"+$80,"I0,0",-2
    dc.w    L_BankCodeAdd2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeMix1,-1
    dc.b    "!bank code mix.","b"+$80,"I0,0",-2
    dc.w    L_BankCodeMix2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeRol1,-1
    dc.b    "!bank code rol.","b"+$80,"I0,0",-2
    dc.w    L_BankCodeRol2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeRor1,-1
    dc.b    "!bank code ror.","b"+$80,"I0,0",-2
    dc.w    L_BankCodeRor2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeXorw1,-1
    dc.b    "!bank code xor.","w"+$80,"I0,0",-2
    dc.w    L_BankCodeXorw2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeAddw1,-1
    dc.b    "!bank code add.","w"+$80,"I0,0",-2
    dc.w    L_BankCodeAddw2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeMixw1,-1
    dc.b    "!bank code mix.","w"+$80,"I0,0",-2
    dc.w    L_BankCodeMixw2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeRolw1,-1
    dc.b    "!bank code rol.","w"+$80,"I0,0",-2
    dc.w    L_BankCodeRolw2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankCodeRorw1,-1
    dc.b    "!bank code ror.","w"+$80,"I0,0",-2
    dc.w    L_BankCodeRorw2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    L_BankStretch,-1
    dc.b    "bank stretc","h"+$80,"I0t0",-1
    dc.w    L_BankCopy1,-1
    dc.b    "!bank cop","y"+$80,"I0t0",-2
    dc.w    L_BankCopy2,-1
    dc.b    $80,"I0,0t0",-1
    dc.w    -1,L_BankNameF
    dc.b    "bank name","$"+$80,"20",-1
    dc.w    L_BankNameC,-1
    dc.b    "bank nam","e"+$80,"I0,2",-1
    dc.w    -1,L_BankCheckSum1
    dc.b    "!bank checksu","m"+$80,"00",-2
    dc.w    -1,L_BankCheckSum2
    dc.b    $80,"00t0",-1
    dc.w    -1,L_DiskStatus
    dc.b    "disk stat","e"+$80,"02",-1
    dc.w    -1,L_DiskType
    dc.b    "disk typ","e"+$80,"02",-1
    dc.w    -1,L_DOSHash            ;***
    dc.b    "dos has","h"+$80,"02",-1
    dc.w    -1,L_UnpathFile
    dc.b    "filename","$"+$80,"22",-1
    dc.w    -1,L_PatternMatch
    dc.b    "pattern matc","h"+$80,"02,2",-1
    dc.w    L_OpenWorkbench,-1
    dc.b    "open workbenc","h"+$80,"I",-1
    dc.w    -1,L_RasterX
    dc.b    "x raste","r"+$80,"0",-1
    dc.w    -1,L_RasterY
    dc.b    "y raste","r"+$80,"0",-1
    dc.w    L_RasterWait1,-1
    dc.b    "raster wai","t"+$80,"I0",-2
    dc.w    L_RasterWait2,-1
    dc.b    "raster wai","t"+$80,"I0,0",-1
    dc.w    L_SetNTSC,-1
    dc.b    "set nts","c"+$80,"I",-1
    dc.w    L_SetPAL,-1
    dc.b    "set pa","l"+$80,"I",-1
    dc.w    L_TurboPlot,-1
    dc.b    "turbo plo","t"+$80,"I0,0,0",-1
    dc.w    -1,L_TurboPoint
    dc.b    "turbo poin","t"+$80,"00,0",-1
    dc.w    -1,L_RedValue
    dc.b    "red va","l"+$80,"00",-1
    dc.w    -1,L_GreenValue
    dc.b    "green va","l"+$80,"00",-1
    dc.w    -1,L_BlueValue
    dc.b    "blue va","l"+$80,"00",-1
    dc.w    -1,L_GivePath
    dc.b    "path","$"+$80,"22",-1
    dc.w    -1,L_ExtendPath
    dc.b    "extpath","$"+$80,"22",-1
    dc.w    L_RNCUnpack,-1
    dc.b    "rnc unpac","k"+$80,"I0t0",-1
    dc.w    -1,L_RobNothern
    dc.b    "rn","p"+$80,"0",-1
    dc.w    L_ResetComputer,-1
    dc.b    "reset compute","r"+$80,"I",-1
    dc.w    -1,L_AgaToOldRGB
    dc.b    "rrggbb to rg","b"+$80,"00",-1
    dc.w    -1,L_OldToAgaRGB
    dc.b    "rgb to rrggb","b"+$80,"00",-1
    dc.w    L_WLoad,-1
    dc.b    "wloa","d"+$80,"I2,0",-1
    dc.w    L_DLoad,-1
    dc.b    "dloa","d"+$80,"I2,0",-1
    dc.w    L_WSave,-1
    dc.b    "wsav","e"+$80,"I2,0",-1
    dc.w    L_WSave,-1
    dc.b    "dsav","e"+$80,"I2,0",-1
    dc.w    L_FCopy,-1
    dc.b    "file cop","y"+$80,"I2t2",-1
    dc.w    L_NopC,-1
    dc.b    "no","p"+$80,"I",-1
    dc.w    -1,L_NopF
    dc.b    "nf","n"+$80,"0",-1
    dc.w    L_PPSave0,-1
    dc.b    "!pptodis","k"+$80,"I2,0",-2
    dc.w    L_PPSave1,-1
    dc.b    $80,"I2,0,0",-2
    dc.w    L_PPUnpack,-1
    dc.b    "ppunpac","k"+$80,"I0t0",-1
    dc.w    L_PPLoad,-1
    dc.b    "ppfromdis","k"+$80,"I2,0",-1
    dc.w    -1,L_PowerOfTwo
    dc.b    "binex","p"+$80,"00",-1
    dc.w    -1,L_RootOfTwo
    dc.b    "binlo","g"+$80,"00",-1
    dc.w    -1,L_ExtDataBase
    dc.b    "extbas","e"+$80,"00",-1
    dc.w    -1,L_IOErrorString
    dc.b    "io error","$"+$80,"20",-1
    dc.w    -1,L_IOError
    dc.b    "io erro","r"+$80,"0",-1
    dc.w    -1,L_ScreenRastport
    dc.b    "scrn rastpor","t"+$80,"0",-1
    dc.w    -1,L_ScreenBitmap
    dc.b    "scrn bitma","p"+$80,"0",-1
    dc.w    -1,L_ScreenLayerInfo
    dc.b    "scrn layerinf","o"+$80,"0",-1
    dc.w    -1,L_ScreenLayer
    dc.b    "scrn laye","r"+$80,"0",-1
    dc.w    -1,L_ScreenRegion
    dc.b    "scrn regio","n"+$80,"0",-1
    dc.w    L_ChangeFont1,-1
    dc.b    "!change fon","t"+$80,"I2",-2
    dc.w    L_ChangeFont2,-1
    dc.b    $80,"I2,0",-2
    dc.w    L_ChangeFont3,-1
    dc.b    $80,"I2,0,0",-1
    dc.w    -1,L_FontStyle
    dc.b    "font styl","e"+$80,"0",-1
    dc.w    L_FlushLibs,-1
    dc.b    "flush lib","s"+$80,"I",-1
    dc.w    L_FilledCircle,-1
    dc.b    "fcircl","e"+$80,"I0,0,0",-1
    dc.w    L_FilledEllipse,-1
    dc.b    "fellips","e"+$80,"I0,0,0,0",-1
    dc.w    -1,L_CPU
    dc.b    "cp","u"+$80,"0",-1
    dc.w    -1,L_FPU
    dc.b    "fp","u"+$80,"0",-1
    dc.w    L_CreateProc1,-1
    dc.b    "!launc","h"+$80,"I2",-2
    dc.w    L_CreateProc2,-1
    dc.b    $80,"I2,0",-1
    dc.w    L_ExamineDir,-1
    dc.b    "examine di","r"+$80,"I2",-1
    dc.w    -1,L_ExamineNext
    dc.b    "examine next","$"+$80,"2",-1
    dc.w    L_ExamineStop,-1
    dc.b    "examine sto","p"+$80,"I",-1
    dc.w    L_ExamineFile,-1
    dc.b    "examine objec","t"+$80,"I2",-1
    dc.w    -1,L_FileType0
    dc.b    "!object typ","e"+$80,"0",-2
    dc.w    -1,L_FileType1
    dc.b    $80,"02",-1
    dc.w    -1,L_FileLength0
    dc.b    "!object siz","e"+$80,"0",-2
    dc.w    -1,L_FileLength1
    dc.b    $80,"02",-1
    dc.w    -1,L_FileBlocks0
    dc.b    "!object block","s"+$80,"0",-2
    dc.w    -1,L_FileBlocks1
    dc.b    $80,"02",-1
    dc.w    -1,L_FileName0
    dc.b    "!object name","$"+$80,"2",-2
    dc.w    -1,L_FileName1
    dc.b    $80,"22",-1
    dc.w    -1,L_FileDate0
    dc.b    "!object dat","e"+$80,"0",-2
    dc.w    -1,L_FileDate1
    dc.b    $80,"02",-1
    dc.w    -1,L_FileTime0
    dc.b    "!object tim","e"+$80,"0",-2
    dc.w    -1,L_FileTime1
    dc.b    $80,"02",-1
    dc.w    -1,L_ProtectionStr
    dc.b    "object protection","$"+$80,"20",-1
    dc.w    -1,L_FileProtection0
    dc.b    "!object protectio","n"+$80,"0",-2
    dc.w    -1,L_FileProtection1
    dc.b    $80,"02",-1
    dc.w    -1,L_FileComment0
    dc.b    "!object comment","$"+$80,"2",-2
    dc.w    -1,L_FileComment1
    dc.b    $80,"22",-2
    dc.w    L_SetProtection,-1
    dc.b    "protect objec","t"+$80,"I2,0",-1
    dc.w    L_SetComment,-1
    dc.b    "set object commen","t"+$80,"I2,2",-1
    dc.w    L_SpritePriority,-1
    dc.b    "set sprite priorit","y"+$80,"I0",-1
    dc.w    -1,L_CurrentDate
    dc.b    "current dat","e"+$80,"0",-1
    dc.w    -1,L_CurrentTime
    dc.b    "current tim","e"+$80,"0",-1
    dc.w    -1,L_CdYear
    dc.b    "cd yea","r"+$80,"00",-1
    dc.w    -1,L_CdMonth
    dc.b    "cd mont","h"+$80,"00",-1
    dc.w    -1,L_CdDay
    dc.b    "cd da","y"+$80,"00",-1
    dc.w    -1,L_CdWeekDay
    dc.b    "cd weekda","y"+$80,"00",-1
    dc.w    -1,L_CtHour
    dc.b    "ct hou","r"+$80,"00",-1
    dc.w    -1,L_CtMinute
    dc.b    "ct minut","e"+$80,"00",-1
    dc.w    -1,L_CtSecond
    dc.b    "ct secon","d"+$80,"00",-1
    dc.w    -1,L_CtTick
    dc.b    "ct tic","k"+$80,"00",-1
    dc.w    L_MaskCopy3,-1
    dc.b    "!mask cop","y"+$80,"I0t0,0",-2
    dc.w    L_MaskCopy9,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0,0",-2
    dc.w    L_MaskCopy10,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0,0,0",-1
    dc.w    -1,L_ScanStr
    dc.b    "scanstr","$"+$80,"20",-1
    dc.w    -1,L_ChrWord
    dc.b    "chr.w","$"+$80,"20",-1
    dc.w    -1,L_ChrLong
    dc.b    "chr.l","$"+$80,"20",-1
    dc.w    -1,L_4PJoy
    dc.b    "pjo","y"+$80,"00",-1
    dc.w    -1,L_4PJLeft
    dc.b    "pjlef","t"+$80,"00",-1
    dc.w    -1,L_4PJRight
    dc.b    "pjrigh","t"+$80,"00",-1
    dc.w    -1,L_4PJUp
    dc.b    "pju","p"+$80,"00",-1
    dc.w    -1,L_4PJDown
    dc.b    "pjdow","n"+$80,"00",-1
    dc.w    -1,L_4PFire
    dc.b    "pfir","e"+$80,"00",-1
    dc.w    -1,L_Lsl
    dc.b    "ls","l"+$80,"00,0",-1
    dc.w    -1,L_Lsr
    dc.b    "ls","r"+$80,"00,0",-1
    dc.w    -1,L_MCSwap
    dc.b    "wordswa","p"+$80,"00",-1
    dc.w    L_AudioLock,-1
    dc.b    "audio loc","k"+$80,"I",-1
    dc.w    L_AudioFree,-1
    dc.b    "audio fre","e"+$80,"I",-1
    dc.w    L_ConvertGrey,-1
    dc.b    "convert gre","y"+$80,"I0t0",-1
    dc.w    -1,L_AscWord
    dc.b    "asc.","w"+$80,"02",-1
    dc.w    -1,L_AscLong
    dc.b    "asc.","l"+$80,"02",-1
    dc.w    -1,L_GetTask
    dc.b    "amos tas","k"+$80,"0",-1
    dc.w    -1,L_Cli
    dc.b    "amos cl","i"+$80,"0",-1
    dc.w    -1,L_CommandName
    dc.b    "command name","$"+$80,"2",-1
    dc.w    -1,L_ToolTypes
    dc.b    "tool types","$"+$80,"22",-1
    dc.w    -1,L_HamColor
    dc.b    "ham colou","r"+$80,"00,0",-1
    dc.w    -1,L_HamBest
    dc.b    "ham bes","t"+$80,"00,0",-1
    dc.w    -1,L_GlueColor
    dc.b    "glue colou","r"+$80,"00,0,0",-1
    dc.w    L_PTileBank,-1
    dc.b    "ptile ban","k"+$80,"I0",-1
    dc.w    L_PastePTile,-1
    dc.b    "paste ptil","e"+$80,"I0,0,0",-1
    dc.w    L_DefCall,-1
    dc.b    "extdefaul","t"+$80,"I0",-1
    dc.w    L_ExtRemove,-1
    dc.b    "extremov","e"+$80,"I0",-1
    dc.w    L_ExtReinit,-1
    dc.b    "extreini","t"+$80,"I0",-1
    dc.w    L_TdStarBank,-1
    dc.b    "td stars ban","k"+$80,"I0,0",-1
    dc.w    L_TdStarLimitAll,-1
    dc.b    "!td stars limi","t"+$80,"I",-2
    dc.w    L_TdStarLimit,-1
    dc.b    $80,"I0,0t0,0",-1
    dc.w    L_TdStarOrigin,-1
    dc.b    "td stars origi","n"+$80,"I0,0",-1
    dc.w    L_TdStarInit,-1
    dc.b    "td stars ini","t"+$80,"I",-1
    dc.w    L_TdStarDo1,-1
    dc.b    "td stars single d","o"+$80,"I",-1
    dc.w    L_TdStarDo2,-1
    dc.b    "td stars double d","o"+$80,"I",-1
    dc.w    L_TdStarDel1,-1
    dc.b    "td stars single de","l"+$80,"I",-1
    dc.w    L_TdStarDel2,-1
    dc.b    "td stars double de","l"+$80,"I",-1
    dc.w    L_TdStarMove,-1
    dc.b    "!td stars mov","e"+$80,"I",-2
    dc.w    L_TdStarMoveSingle,-1
    dc.b    $80,"I0",-1
    dc.w    L_TdStarDraw,-1
    dc.b    "td stars dra","w"+$80,"I",-1
    dc.w    L_TdStarGravity,-1
    dc.b    "td stars gravit","y"+$80,"I0,0",-1
    dc.w    L_TdStarAccelOn,-1
    dc.b    "td stars accelerate o","n"+$80,"I",-1
    dc.w    L_TdStarAccelOff,-1
    dc.b    "td stars accelerate of","f"+$80,"I",-1
    dc.w    L_TdStarPlanes,-1
    dc.b    "td stars plane","s"+$80,"I0,0",-1
    dc.w    -1,L_SgnDeek
    dc.b    "sdee","k"+$80,"00",-1
    dc.w    -1,L_SgnPeek
    dc.b    "spee","k"+$80,"00",-1
    dc.w    L_PixShiftUp,-1
    dc.b    "!pix shift u","p"+$80,"I0,0,0,0,0t0,0",-2
    dc.w    L_PixShiftUp2,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0",-1
    dc.w    L_PixShiftDown,-1
    dc.b    "!pix shift dow","n"+$80,"I0,0,0,0,0t0,0",-2
    dc.w    L_PixShiftDown2,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0",-1
    dc.w    L_PixBrighten,-1
    dc.b    "!pix brighte","n"+$80,"I0,0,0,0,0t0,0",-2
    dc.w    L_PixBrighten2,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0",-1
    dc.w    L_PixDarken,-1
    dc.b    "!pix darke","n"+$80,"I0,0,0,0,0t0,0",-2
    dc.w    L_PixDarken2,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0",-1
    dc.w    L_MakePixTemplate,-1
    dc.b    "make pix mas","k"+$80,"I0,0,0t0,0,0",-1
    dc.w    -1,L_CountPixels
    dc.b    "count pixel","s"+$80,"00,0,0,0t0,0",-1
    dc.w    L_CoordsBankSet,-1
    dc.b    "!coords ban","k"+$80,"I0",-2
    dc.w    L_CoordsBank,-1
    dc.b    $80,"I0,0",-1
    dc.w    L_CoordsRead,-1
    dc.b    "coords rea","d"+$80,"I0,0,0,0t0,0,0,0",-1
    dc.w    L_SplinterBank,-1
    dc.b    "splinters ban","k"+$80,"I0,0",-1
    dc.w    L_SplinterLimitAll,-1
    dc.b    "!splinters limi","t"+$80,"I",-2
    dc.w    L_SplinterLimit,-1
    dc.b    $80,"I0,0t0,0",-1
    dc.w    L_SplinterGravity,-1
    dc.b    "splinters gravit","y"+$80,"I0,0",-1
    dc.w    L_SplinterInit,-1
    dc.b    "splinters ini","t"+$80,"I",-1
    dc.w    L_SplinterColor,-1
    dc.b    "splinters colou","r"+$80,"I0,0",-1
    dc.w    L_SplinterDo1,-1
    dc.b    "splinters single d","o"+$80,"I",-1
    dc.w    L_SplinterDo2,-1
    dc.b    "splinters double d","o"+$80,"I",-1
    dc.w    L_SplinterDel1,-1
    dc.b    "splinters single de","l"+$80,"I",-1
    dc.w    L_SplinterDel2,-1
    dc.b    "splinters double de","l"+$80,"I",-1
    dc.w    L_SplinterMove,-1
    dc.b    "splinters mov","e"+$80,"I",-1
    dc.w    L_SplinterDraw,-1
    dc.b    "splinters dra","w"+$80,"I",-1
    dc.w    L_SplinterMax,-1
    dc.b    "splinters ma","x"+$80,"I0",-1
    dc.w    L_SplinterBack,-1
    dc.b    "splinters bac","k"+$80,"I",-1
    dc.w    L_FImpUnpack,-1
    dc.b    "imploder unpac","k"+$80,"I0t0",-1
    dc.w    L_ImploderLoad,-1
    dc.b    "imploder loa","d"+$80,"I2,0",-1
    dc.w    -1,L_LeadZeroStr
    dc.b    "lzstr","$"+$80,"20,0",-1
    dc.w    -1,L_LeadSpaceStr
    dc.b    "lsstr","$"+$80,"20,0",-1
    dc.w    L_WriteCLI,-1
    dc.b    "write cl","i"+$80,"I2",-1
    dc.w    -1,L_MixColor2
    dc.b    "!mix colou","r"+$80,"00,0",-2
    dc.w    -1,L_MixColor4
    dc.b    $80,"00,0,0t0",-1
    dc.w    -1,L_ConvDate
    dc.b    "cd date","$"+$80,"20",-1
    dc.w    -1,L_ConvTime
    dc.b    "ct time","$"+$80,"20",-1
    dc.w    L_SplinterFuel,-1
    dc.b    "splinters fue","l"+$80,"I0",-1
    dc.w    -1,L_SplinterActive
    dc.b    "splinters activ","e"+$80,"0",-1
    dc.w    L_ShadeBobMask,-1
    dc.b    "shade bob mas","k"+$80,"I0",-1
    dc.w    L_ShadeBobPlanes,-1
    dc.b    "shade bob plane","s"+$80,"I0",-1
    dc.w    L_ShadeBobUp,-1
    dc.b    "shade bob u","p"+$80,"I0,0,0,0",-1
    dc.w    L_ShadeBobDown,-1
    dc.b    "shade bob dow","n"+$80,"I0,0,0,0",-1
    dc.w    L_HamFadeOut,-1
    dc.b    "ham fade ou","t"+$80,"I0",-1
    dc.w    L_DeltaEncode1,-1
    dc.b    "!bank delta encod","e"+$80,"I0",-2
    dc.w    L_DeltaEncode2,-1
    dc.b    $80,"I0t0",-1
    dc.w    L_DeltaDecode1,-1
    dc.b    "!bank delta decod","e"+$80,"I0",-2
    dc.w    L_DeltaDecode2,-1
    dc.b    $80,"I0t0",-1
    dc.w    L_TurboDraw5,-1
    dc.b    "!turbo dra","w"+$80,"I0,0t0,0,0",-2
    dc.w    L_TurboDraw6,-1
    dc.b    $80,"I0,0t0,0,0,0",-1
    dc.w    L_BlitFill2,-1
    dc.b    "!blitter fil","l"+$80,"I0,0",-2
    dc.w    L_BlitFill4,-1
    dc.b    $80,"I0,0t0,0",-2
    dc.w    L_BlitFill6,-1
    dc.b    $80,"I0,0,0,0,0,0",-2
    dc.w    L_BlitFill,-1
    dc.b    $80,"I0,0,0,0,0,0t0,0",-1
    dc.w    L_PTPlay1,-1
    dc.b    "!pt pla","y"+$80,"I0",-2
    dc.w    L_PTPlay2,-1
    dc.b    $80,"I0,0",-1
    dc.w    L_PTStop,-1
    dc.b    "pt sto","p"+$80,"I",-1
    dc.w    -1,L_PTSignal
    dc.b    "pt signa","l"+$80,"0",-1
    dc.w    L_PTVolume,-1
    dc.b    "pt volum","e"+$80,"I0",-1
    dc.w    L_PTVoice,-1
    dc.b    "pt voic","e"+$80,"I0",-1
    dc.w    -1,L_PTVumeter
    dc.b    "pt v","u"+$80,"00",-1
    dc.w    L_PTCiaSpeed,-1
    dc.b    "pt cia spee","d"+$80,"I0",-1
    dc.w    -1,L_QSin
    dc.b    "qsi","n"+$80,"00,0",-1
    dc.w    -1,L_QCos
    dc.b    "qco","s"+$80,"00,0",-1
    dc.w    L_VecRotPos,-1
    dc.b    "vec rot po","s"+$80,"I0,0,0",-1
    dc.w    L_VecRotAngles,-1
    dc.b    "vec rot angle","s"+$80,"I0,0,0",-1
    dc.w    L_VecRotPrecalc,-1
    dc.b    "vec rot precal","c"+$80,"I",-1
    dc.w    -1,L_VecRotX
    dc.b    "!vec rot ","x"+$80,"0",-2
    dc.w    -1,L_VecRotX3
    dc.b    $80,"00,0,0",-1
    dc.w    -1,L_VecRotY
    dc.b    "!vec rot ","y"+$80,"0",-2
    dc.w    -1,L_VecRotY3
    dc.b    $80,"00,0,0",-1
    dc.w    L_ChangePrintFont,-1
    dc.b    "change print fon","t"+$80,"I0",-1
    dc.w    -1,L_QRnd
    dc.b    "qrn","d"+$80,"00",-1
    dc.w    -1,L_VecRotZ
    dc.b    "!vec rot ","z"+$80,"0",-2
    dc.w    -1,L_VecRotZ3
    dc.b    $80,"00,0,0",-1
    dc.w    -1,L_CopPos
    dc.b    "cop po","s"+$80,"0",-1
    dc.w    L_MakeBankFont,-1
    dc.b    "make bank fon","t"+$80,"I0",-1
    dc.w    L_ChangeBankFont,-1
    dc.b    "change bank fon","t"+$80,"I0",-1
    dc.w    L_BlitClear2,-1
    dc.b    "!blitter clea","r"+$80,"I0,0",-2
    dc.w    L_BlitClear,-1
    dc.b    $80,"I0,0,0,0t0,0",-1
    dc.w    -1,L_BlitBusy
    dc.b    "blitter bus","y"+$80,"0",-1
    dc.w    L_BlitWait,-1
    dc.b    "blitter wai","t"+$80,"I",-1
    dc.w    L_ShadePix2,-1
    dc.b    "!shade pi","x"+$80,"I0,0",-2
    dc.w    L_ShadePix,-1
    dc.b    $80,"I0,0,0",-1
    dc.w    L_BlitterCopyLimit1,-1
    dc.b    "!blitter copy limi","t"+$80,"I0",-2
    dc.w    L_BlitterCopyLimit4,-1
    dc.b    $80,"I0,0t0,0",-1
    dc.w    L_BlitterCopy4,-1
    dc.b    "!blitter cop","y"+$80,"I0,0t0,0",-2
    dc.w    L_BlitterCopy5,-1
    dc.b    $80,"I0,0t0,0,0",-2
    dc.w    L_BlitterCopy6,-1
    dc.b    $80,"I0,0,0,0t0,0",-2
    dc.w    L_BlitterCopy7,-1
    dc.b    $80,"I0,0,0,0t0,0,0",-2
    dc.w    L_BlitterCopy8,-1
    dc.b    $80,"I0,0,0,0,0,0t0,0",-2
    dc.w    L_BlitterCopy9,-1
    dc.b    $80,"I0,0,0,0,0,0t0,0,0",-1
    dc.w    L_SetRainCol,-1
    dc.b    "set rain colou","r"+$80,"I0,0",-1
    dc.w    L_RainFade2,-1
    dc.b    "!rain fad","e"+$80,"I0,0",-2
    dc.w    L_RainFadet2,-1
    dc.b    $80,"I0t0",-1
    dc.w    -1,L_QSqr
    dc.b    "qsq","r"+$80,"00",-1
    dc.w    L_BCircle,-1
    dc.b    "bcircl","e"+$80,"I0,0,0,0",-1
    dc.w    -1,L_PTDataBase
    dc.b    "pt data bas","e"+$80,"0",-1
    dc.w    -1,L_PTInstrAdr
    dc.b    "pt instr addres","s"+$80,"00",-1
    dc.w    -1,L_PTInstrLen
    dc.b    "pt instr lengt","h"+$80,"00",-1
    dc.w    L_PTBank,-1
    dc.b    "pt ban","k"+$80,"I0",-1
    dc.w    L_PTInstrPlay1,-1
    dc.b    "!pt instr pla","y"+$80,"I0",-2
    dc.w    L_PTInstrPlay2,-1
    dc.b    $80,"I0,0",-2
    dc.w    L_PTInstrPlay3,-1
    dc.b    $80,"I0,0,0",-1
    dc.w    L_PTSamStop,-1
    dc.b    "pt sam sto","p"+$80,"I0",-1
    dc.w    L_PTRawPlay,-1
    dc.b    "pt raw pla","y"+$80,"I0,0,0,0",-1
    dc.w    L_PTSamBank,-1
    dc.b    "pt sam ban","k"+$80,"I0",-1
    dc.w    L_PTSamPlay1,-1
    dc.b    "!pt sam pla","y"+$80,"I0",-2
    dc.w    L_PTSamPlay2,-1
    dc.b    $80,"I0,0",-2
    dc.w    L_PTSamPlay3,-1
    dc.b    $80,"I0,0,0",-1
    dc.w    L_PTSamVolume1,-1
    dc.b    "!pt sam volum","e"+$80,"I0",-2
    dc.w    L_PTSamVolume2,-1
    dc.b    $80,"I0,0",-1
    dc.w    L_PalGetScreen,-1
    dc.b    "pal get scree","n"+$80,"I0,0",-1
    dc.w    L_PalSetScreen,-1
    dc.b    "pal set scree","n"+$80,"I0,0",-1
    dc.w    -1,L_PalGet
    dc.b    "pal ge","t"+$80,"00,0",-1
    dc.w    L_PalSet,-1
    dc.b    "pal se","t"+$80,"I0,0,0",-1
    dc.w    L_ExchangeBob,-1
    dc.b    "exchange bo","b"+$80,"I0,0",-1
    dc.w    L_ExchangeIcon,-1
    dc.b    "exchange ico","n"+$80,"I0,0",-1

    dc.w    -1,L_BestPen1
    dc.b    "!best pe","n"+$80,"00",-2
    dc.w    -1,L_BestPen3
    dc.b    $80,"00,0t0",-1
    dc.w    L_BZoom,-1
    dc.b    "bzoo","m"+$80,"I0,0,0,0,0t0,0,0,0",-1
    dc.w    -1,L_XSmouse
    dc.b    "x smous","e"+$80,"0",-1
    dc.w    -1,L_YSmouse
    dc.b    "y smous","e"+$80,"0",-1
    dc.w    L_SetXSmouse,-1
    dc.b    "smouse ","x"+$80,"I0",-1
    dc.w    L_SetYSmouse,-1
    dc.b    "smouse ","y"+$80,"I0",-1
    dc.w    L_SmouseSpeed,-1
    dc.b    "smouse spee","d"+$80,"I0",-1
    dc.w    -1,L_SmouseKey
    dc.b    "smouse ke","y"+$80,"0",-1
    dc.w    L_LimitSmouse0,-1
    dc.b    "!limit smous","e"+$80,"I",-2
    dc.w    L_LimitSmouse4,-1
    dc.b    $80,"I0,0t0,0",-1
    dc.w    -1,L_Xfire
    dc.b    "xfir","e"+$80,"00,0",-1
    dc.w    L_PTContinue,-1
    dc.b    "pt continu","e"+$80,"I",-1
    dc.w    -1,L_PTCPattern
    dc.b    "pt cpatter","n"+$80,"0",-1
    dc.w    -1,L_PTCPos
    dc.b    "pt cpo","s"+$80,"0",-1
    dc.w    -1,L_PTCInstr
    dc.b    "pt cinst","r"+$80,"00",-1
    dc.w    -1,L_PTCNote
    dc.b    "pt cnot","e"+$80,"00",-1
    dc.w    L_PTSamFreq,-1
    dc.b    "pt sam fre","q"+$80,"I0,0",-1
    dc.w    -1,L_Vclip
    dc.b    "vcli","p"+$80,"00,0t0",-1
    dc.w    -1,L_Vin
    dc.b    "vi","n"+$80,"00,0t0",-1
    dc.w    -1,L_Vmod2
    dc.b    "!vmo","d"+$80,"00,0",-2
    dc.w    -1,L_Vmod3
    dc.b    $80,"00,0t0",-1
    dc.w    -1,L_Insstr
    dc.b    "insstr","$"+$80,"22,2,0",-1
    dc.w    -1,L_CutStr
    dc.b    "cutstr","$"+$80,"22,0t0",-1
    dc.w    -1,L_Replacestr
    dc.b    "replacestr","$"+$80,"22,2t2",-1
    dc.w    -1,L_Itemstr2
    dc.b    "!itemstr","$"+$80,"22,0",-2
    dc.w    -1,L_Itemstr3
    dc.b    $80,"22,0,2",-1
    dc.w    -1,L_QArc
    dc.b    "qar","c"+$80,"00,0",-1
    dc.w    -1,L_Even
    dc.b    "eve","n"+$80,"00",-1
    dc.w    -1,L_Odd
    dc.b    "od","d"+$80,"00",-1
    dc.w    -1,L_HamPoint
    dc.b    "ham poin","t"+$80,"00,0",-1
    dc.w    L_SetObjectDate,-1
    dc.b    "set object dat","e"+$80,"I2,0,0",-1
    dc.w    -1,L_AgaDetect
    dc.b    "aga detec","t"+$80,"0",-1
    dc.w    L_PalSpread,-1
    dc.b    "pal sprea","d"+$80,"I0,0t0,0",-1

    dc.w    -1,L_CtString
    dc.b    "ct strin","g"+$80,"02",-1
    dc.w    -1,L_CdString
    dc.b    "cd strin","g"+$80,"02",-1

    dc.w    L_C2PConvert,-1
    dc.b    "c2p conver","t"+$80,"I0,0,0t0,0,0",-1
    dc.w    L_C2PShift,-1
    dc.b    "c2p shif","t"+$80,"I0,0,0t0,0",-1
    dc.w    L_C2PFire,-1
    dc.b    "c2p fir","e"+$80,"I0,0,0t0,0",-1

    dc.w    L_SLoad,-1
    dc.b    "sloa","d"+$80,"I0t0,0",-1
    dc.w    L_SSave,-1
    dc.b    "ssav","e"+$80,"I0,0t0",-1

    dc.w    -1,L_PTFreeVoice0
    dc.b    "!pt free voic","e"+$80,"0",-2
    dc.w    -1,L_PTFreeVoice1
    dc.b    $80,"00",-1

    dc.w    L_AllocTransSource,-1
    dc.b    "alloc trans sourc","e"+$80,"I0",-1
    dc.w    L_SetTransSource,-1
    dc.b    "set trans sourc","e"+$80,"I0",-1
    dc.w    L_AllocTransMap,-1
    dc.b    "alloc trans ma","p"+$80,"I0,0,0",-1
    dc.w    L_SetTransMap,-1
    dc.b    "set trans ma","p"+$80,"I0,0,0",-1
    dc.w    L_AllocCodeBank,-1
    dc.b    "alloc code ban","k"+$80,"I0,0",-1

    dc.w    L_TransScreenRuntime,-1
    dc.b    "trans screen runtim","e"+$80,"I0,0,0,0",-1
    dc.w    L_TransScreenStatic,-1
    dc.b    "trans screen stati","c"+$80,"I0,0,0,0",-1
    dc.w    L_TransScreenDynamic,-1
    dc.b    "trans screen dynami","c"+$80,"I0,0,0,0",-1

    dc.w    L_SetC2PSource,-1
    dc.b    "set c2p sourc","e"+$80,"I0,0,0,0,0t0,0",-1

    dc.w    L_C2pZoom7,-1
    dc.b    "!c2p zoo","m"+$80,"I0,0,0,0,0t0,0",-2
    dc.w    L_C2pZoom8,-1
    dc.b    $80,"I0,0,0,0,0t0,0,0",-1

;   dc.w    L_TurboText3,-1
;   dc.b    "!turbo tex","t"+$80,"I0,0,2",-2
;   dc.w    L_TurboText4,-1
;   dc.b    $80,"I0,0,2,0",-2
;   dc.w    L_TurboText5,-1
;   dc.b    $80,"I0,0,2,0,0",-1

;   dc.w    L_FFTStart,-1
;   dc.b    "fft star","t"+$80,"I0,0",-1

;   dc.w    L_FFTStop,-1
;   dc.b    "fft sto","p"+$80,"I",-1

;   dc.w    L_ChunkyRead,-1
;   dc.b    "chunky rea","d"+$80,"I0,0,0t0,0,0",-1
;   dc.w    L_ChunkyDraw4,-1
;   dc.b    "!chunky dra","w"+$80,"I0,0,0,0",-2
;   dc.w    L_ChunkyDraw5,-1
;   dc.b    $80,"I0,0,0,0,0",-1

;   dc.w    L_QZoom,-1
;   dc.b    "qzoo","m"+$80,"I0,0,0,0,0t0,0,0,0,0",-1


; ********************************************************************

;    +++ You must also leave this keyword untouched, just before the zeros.
;    TOKEN_END

;    +++ The token table must end by this
    dc.w    0
    dc.l    0

; +++ This macro initialise the library counter, and is also detected by
    Lib_Ini    0

; +++ Start of the library (for the header)
C_Lib

******************************************************************
*    COLD START
*
;
  Lib_Def    PersonalUnity_Cold
    cmp.l   #'APex',d1
    bne .error
    move.l  #O_SizeOf,d0
    move.l  #$10001,d1
    move.l  a6,d5
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  d5,a6
    move.l  d0,ExtAdr+ExtNb*16(a5)
    beq .error
    move.l  d0,a2
    clr.l   O_BufferLength(a2)
    clr.l   O_BufferAddress(a2)

    moveq.l #4,d0
    move.l  #$10003,d1
    move.l  a6,d5
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  d5,a6
    move.l  d0,O_4ByteChipBuf(a2)

    lea ResetToDefault(pc),a0
    move.l  a0,ExtAdr+ExtNb*16+4(a5)
    lea AmcafQuit(pc),a0
    move.l  a0,ExtAdr+ExtNb*16+8(a5)
    lea BkCheck(pc),a0
    move.l  a0,ExtAdr+ExtNb*16+12(a5)

    moveq.l #4,d0
    Rbsr    L_PT_Routines

    lea .abase(pc),a0
    move.l  a2,(a0)
    lea O_MouseInt(a2),a1
    lea .introu(pc),a0
    move.l  a0,18(a1)
    lea .intnam(pc),a0
    move.l  a0,10(a1)
    moveq.l #5,d0
    move.l  a6,d7
    move.l  4.w,a6
    jsr _LVOAddIntServer(a6)
    move.l  d7,a6

    lea ExtAdr(a5),a0
    move.l  (a0),d0
    bne.s   .muxins
    move.l  O_PTDataBase(a2),a1
    lea MT_Vumeter(a1),a1
    move.l  a1,(a0)
.muxins

    Rbsr    L_Precalc32
    bsr ResetToDefault

    IFEQ    1
    movem.l a3-a6/d0-d7,-(sp)
    dload   a2
    lea O_DateStamp(a2),a2
    move.l  a2,d1
    move.l  DosBase(a5),a6
    jsr _LVODateStamp(a6)
    movem.l (sp)+,a3-a6/d0-d7
    cmp.l   #6666,(a2)
    bgt.s   .error
    ENDC

    IFEQ    salever
    IFNE    demover
    bsr.s   .demove
    ENDC
    move.w  #$0110,d1
    moveq   #ExtNb,d0       * NO ERRORS
    rts
.error  sub.l   a0,a0
    moveq.l #-1,d0
    rts
.abase  dc.l    0
.introu:
    movem.l d1-d7/a0-a6,-(sp)
    lea $DFF000,a6
    move.l  .abase(pc),a2
    move.w  O_MouseDX(a2),d2
    move.w  O_MouseDY(a2),d3
    move.b  $00D(a6),d0
    move.b  $00C(a6),d1
    ext.w   d0
    ext.w   d1
    move.w  d0,O_MouseDX(a2)
    move.w  d1,O_MouseDY(a2)
    sub.w   d2,d0
    sub.w   d3,d1
    cmp.w   #-127,d0
    bgt.s   .nox1
    add.w   #256,d0
.nox1   cmp.w   #127,d0
    blt.s   .nox2
    sub.w   #256,d0
.nox2   cmp.w   #-127,d1
    bgt.s   .noy1
    add.w   #256,d1
.noy1   cmp.w   #127,d1
    blt.s   .noy2
    sub.w   #256,d1
.noy2   add.w   O_MouseX(a2),d0
    add.w   O_MouseY(a2),d1
    move.w  O_MouseSpeed(a2),d6
    move.w  O_MouseLim(a2),d2
    move.w  O_MouseLim+2(a2),d3
    move.w  O_MouseLim+4(a2),d4
    move.w  O_MouseLim+6(a2),d5
    asl.w   d6,d2
    asl.w   d6,d3
    asl.w   d6,d4
    asl.w   d6,d5
    cmp.w   d2,d0
    bgt.s   .nolix1
    move.w  d2,d0
.nolix1 cmp.w   d4,d0
    blt.s   .nolix2
    move.w  d4,d0
.nolix2 cmp.w   d3,d1
    bgt.s   .noliy1
    move.w  d3,d1
.noliy1 cmp.w   d5,d1
    blt.s   .noliy2
    move.w  d5,d1
.noliy2 move.w  d0,O_MouseX(a2)
    move.w  d1,O_MouseY(a2)

    move.l  O_PTDataBase(a2),a5
    tst.b   MT_SfxEnable(a5)
    bne.s   .sfxen1
    tst.w   MT_VblDisable(a5)
    blt.s   .sfxen1
    subq.w  #1,MT_VblDisable(a5)
    bne.s   .sfxen1
    st  MT_SfxEnable(a5)
    move.w  #1,$96(a6)
.sfxen1 tst.b   MT_SfxEnable+1(a5)
    bne.s   .sfxen2
    tst.w   MT_VblDisable+2(a5)
    blt.s   .sfxen2
    subq.w  #1,MT_VblDisable+2(a5)
    bne.s   .sfxen2
    st  MT_SfxEnable+1(a5)
    move.w  #2,$96(a6)
.sfxen2 tst.b   MT_SfxEnable+2(a5)
    bne.s   .sfxen3
    tst.w   MT_VblDisable+4(a5)
    blt.s   .sfxen3
    subq.w  #1,MT_VblDisable+4(a5)
    bne.s   .sfxen3
    st  MT_SfxEnable+2(a5)
    move.w  #4,$96(a6)
.sfxen3 tst.b   MT_SfxEnable+3(a5)
    bne.s   .sfxen4
    tst.w   MT_VblDisable+6(a5)
    blt.s   .sfxen4
    subq.w  #1,MT_VblDisable+6(a5)
    bne.s   .sfxen4
    st  MT_SfxEnable+3(a5)
    move.w  #8,$96(a6)
.sfxen4

    movem.l (sp)+,d1-d7/a0-a6
    moveq.l #0,d0
    rts
.intnam dc.b    '2nd mouse',0
    even
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

.demove
    IFNE    demover
    IFEQ    1
;   EcCall  AMOS_WB
;   move.l  a6,d5
;   moveq.l #0,d0
;   lea .demost(pc),a0
;   move.l  #147,d1
;   move.l  T_IntBase(a5),a6
;   jsr _LVODisplayAlert(a6)
;   move.l  d5,a6
.skip   rts

;.demost    dc.b    0,10,10,"This is only a demoversion of the AMCAF-Extension.",0,-1
;   dc.b    0,10,20,"If you like it, you can register your version by sending $25 or 30 DM to:",0,-1
;   dc.b    0,140,35,"Chris Hodges",0,-1
;   dc.b    0,140,45,"Kennedystr. 8",0,-1
;   dc.b    0,140,55,"D-82178 Puchheim",0,-1
;   dc.b    0,140,65,"Germany",0,-1
;   dc.b    0,140,80,"chris@sixpack.pfalz.de",0,-1
;   dc.b    0,140,90,"chris@surprise.rhein-ruhr.de",0,-1
;   dc.b    0,140,105,"Account 359 68 63",0,-1
;   dc.b    0,140,115,"Sparkasse Fuerstenfeldbruck",0,-1
;   dc.b    0,140,125,"BLZ 700 530 70",0,-1
;   dc.b    0,10,140,"Enjoy...",0,0
    ELSE
;   EcCall  AMOS_WB
;   move.l  a6,d5
;   moveq.l #0,d0
;   lea .demost(pc),a0
;   move.l  #20,d1
;   move.l  T_IntBase(a5),a6
;   jsr _LVODisplayAlert(a6)
;   move.l  d5,a6
.skip   rts

;.demost    dc.b    0,10,10,"AMCAF Demoversion! Please register!",0,0
    ENDC
    even
    ENDC
    ELSE
    movem.l d1-d7/a0-a6,-(sp)
    lea regdata(pc),a0
    Rbsr    L_DecodeRegData
    movem.l (sp)+,d1-d7/a0-a6
    move.w  #$0110,d1
    rts
.error  sub.l   a0,a0
    moveq.l #-1,d0
    rts
    ENDC

.abase  dc.l    0
.introu movem.l d1-d7/a0-a6,-(sp)
    lea $DFF000,a6
    move.l  .abase(pc),a2
    move.w  O_MouseDX(a2),d2
    move.w  O_MouseDY(a2),d3
    move.b  $00D(a6),d0
    move.b  $00C(a6),d1
    ext.w   d0
    ext.w   d1
    move.w  d0,O_MouseDX(a2)
    move.w  d1,O_MouseDY(a2)
    sub.w   d2,d0
    sub.w   d3,d1
    cmp.w   #-127,d0
    bgt.s   .nox1
    add.w   #256,d0
.nox1   cmp.w   #127,d0
    blt.s   .nox2
    sub.w   #256,d0
.nox2   cmp.w   #-127,d1
    bgt.s   .noy1
    add.w   #256,d1
.noy1   cmp.w   #127,d1
    blt.s   .noy2
    sub.w   #256,d1
.noy2   add.w   O_MouseX(a2),d0
    add.w   O_MouseY(a2),d1
    move.w  O_MouseSpeed(a2),d6
    move.w  O_MouseLim(a2),d2
    move.w  O_MouseLim+2(a2),d3
    move.w  O_MouseLim+4(a2),d4
    move.w  O_MouseLim+6(a2),d5
    asl.w   d6,d2
    asl.w   d6,d3
    asl.w   d6,d4
    asl.w   d6,d5
    cmp.w   d2,d0
    bgt.s   .nolix1
    move.w  d2,d0
.nolix1 cmp.w   d4,d0
    blt.s   .nolix2
    move.w  d4,d0
.nolix2 cmp.w   d3,d1
    bgt.s   .noliy1
    move.w  d3,d1
.noliy1 cmp.w   d5,d1
    blt.s   .noliy2
    move.w  d5,d1
.noliy2 move.w  d0,O_MouseX(a2)
    move.w  d1,O_MouseY(a2)

    move.l  O_PTDataBase(a2),a5
    tst.b   MT_SfxEnable(a5)
    bne.s   .sfxen1
    tst.w   MT_VblDisable(a5)
    blt.s   .sfxen1
    subq.w  #1,MT_VblDisable(a5)
    bne.s   .sfxen1
    st  MT_SfxEnable(a5)
    move.w  #1,$96(a6)
.sfxen1 tst.b   MT_SfxEnable+1(a5)
    bne.s   .sfxen2
    tst.w   MT_VblDisable+2(a5)
    blt.s   .sfxen2
    subq.w  #1,MT_VblDisable+2(a5)
    bne.s   .sfxen2
    st  MT_SfxEnable+1(a5)
    move.w  #2,$96(a6)
.sfxen2 tst.b   MT_SfxEnable+2(a5)
    bne.s   .sfxen3
    tst.w   MT_VblDisable+4(a5)
    blt.s   .sfxen3
    subq.w  #1,MT_VblDisable+4(a5)
    bne.s   .sfxen3
    st  MT_SfxEnable+2(a5)
    move.w  #4,$96(a6)
.sfxen3 tst.b   MT_SfxEnable+3(a5)
    bne.s   .sfxen4
    tst.w   MT_VblDisable+6(a5)
    blt.s   .sfxen4
    subq.w  #1,MT_VblDisable+6(a5)
    bne.s   .sfxen4
    st  MT_SfxEnable+3(a5)
    move.w  #8,$96(a6)
.sfxen4

    movem.l (sp)+,d1-d7/a0-a6
    moveq.l #0,d0
    rts
.intnam dc.b    '2nd mouse',0
    even



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
ResetToDefault:
    movem.l a3-a6/d6-d7,-(sp)
    dload   a2

;   Rbsr    L_FFTStop
    Rbsr    L_PTStop
    move.l  #$00800030,O_MouseLim(a2)
    move.l  #$01BF012F,O_MouseLim+4(a2)
    clr.l   O_MouseX(a2)
    move.b  $DFF00D,d0
    move.b  $DFF00C,d1
    ext.w   d0
    ext.w   d1
    move.w  d0,O_MouseDX(a2)
    move.w  d1,O_MouseDY(a2)
    move.w  #1,O_MouseSpeed(a2)
    clr.l   O_HamRed(a2)
    clr.l   O_StarBank(a2)
    clr.l   O_StarGravity(a2)
    st  O_StarAccel(a2)
    clr.l   O_CoordsBank(a2)
    clr.l   O_SpliBank(a2)
    clr.w   O_SpliBkCol(a2)
    clr.w   O_PTCiaVbl(a2)
    move.w  #64,O_PTSamVolume(a2)
    move.l  O_PTDataBase(a2),a0
    moveq.l #-1,d0
    move.l  d0,MT_ChanEnable(a0)
    move.l  d0,MT_SfxEnable(a0)
    move.w  #125,MT_CiaSpeed(a0)
    move.w  #64,MT_Volume(a0)
    clr.w   MT_Signal(a0)
    clr.l   MT_Vumeter(a0)
    move.w  #-1,O_SpliFuel(a2)
    moveq.l #3,d0
    move.l  d0,O_SpliGravity(a2)
    move.w  #2,O_MaxSpli(a2)
    clr.w   O_SBobMask(a2)
    move.w  #6,O_SBobPlanes(a2)
    moveq.l #4,d0
    move.l  d0,O_StarPlanes(a2)
    tst.w   O_AudioOpen(a2)
    beq.s   .skip
    Rbsr    L_AudioFree
.skip   move.w  #4,O_AgaColor(a2)
    Rbsr    L_ExamineStop
    Rbsr    L_FreeExtMem
    movem.l (sp)+,a3-a6/d6-d7
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
AmcafQuit:
    movem.l a3-a6/d6-d7,-(sp)
    bsr ResetToDefault
    dload   a2
    move.l  a6,d3
    move.l  4.w,a6
    move.l  O_PowerPacker(a2),d0
    beq.s   .nopp
    move.l  d0,a1
    jsr _LVOCloseLibrary(a6)
.nopp   move.l  O_DiskFontLib(a2),d0
    beq.s   .nodsfn
    move.l  d0,a1
    jsr _LVOCloseLibrary(a6)
.nodsfn move.l  O_LowLevelLib(a2),d0
    beq.s   .noll
    move.l  d0,a1
    jsr _LVOCloseLibrary(a6)
.noll   lea O_MouseInt(a2),a1
    moveq.l #5,d0
    jsr _LVORemIntServer(a6)
    move.l  O_4ByteChipBuf(a2),a1
    moveq.l #4,d0
    jsr _LVOFreeMem(a6)
    move.l  a2,a1
    move.l  #O_SizeOf,d0
    jsr _LVOFreeMem(a6)
    move.l  d3,a6
    movem.l (sp)+,a3-a6/d6-d7
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
BkCheck
    dload   a2
    move.l  O_PTVblOn(a2),d0
    beq.s   .skip
    move.l  O_PTBank(a2),d0
    Rjsr    L_Bnk.GetAdr
    beq.s   .ptstop
    move.l  O_PTAddress(a2),d0
    cmp.l   a0,d0
    beq.s   .skip
.ptstop movem.l a3-a6/d6-d7,-(sp)
    Rbsr    L_PTStop
    movem.l (sp)+,a3-a6/d6-d7
.skip   rts

    IFNE    salever
regdata dc.l    $26121976
sernumb dc.l    0
usernam ds.b    80
chksumm dc.l    0
    ENDC


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
    include "Amcaf/3D.asm"
    include "Amcaf/4Player.asm"
    include "Amcaf/Amcaf.asm"
    include "Amcaf/AudioLock.asm"
    include "Amcaf/Bank.asm"
    include "Amcaf/Blitter.asm"
    include "Amcaf/C2P.asm"
    include "Amcaf/CnvGrey.asm"
    include "Amcaf/Chunky.asm"
    include "Amcaf/Color.asm"
    include "Amcaf/Coords.asm"
    include "Amcaf/DiskFun.asm"
    include "Amcaf/Dload.asm"
    include "Amcaf/DOSObject.asm"
    include "Amcaf/Ext.asm"
    include "Amcaf/FImp.asm"
    include "Amcaf/Font.asm"

    AddLabl L_KalmsC2P32
    Rbra    L_KalmsC2P

    AddLabl L_Custom32
    IFNE    demover
    moveq.l #0,d0
    ENDC
    Rbra    L_Custom

    AddLabl L_IFonc32
    Rbra    L_IFonc

    AddLabl L_IOoMem32
    Rbra    L_IOoMem

    AddLabl L_Precalc32
    Rbra    L_PrecalcTables

    include "Amcaf/Ham.asm"
    include "Amcaf/Smouse.asm"
    include "Amcaf/IOError.asm"
    include "Amcaf/MaskCopy.asm"
    include "Amcaf/MiscFun.asm"
    include "Amcaf/MiscGfx.asm"
    include "Amcaf/MiscSys.asm"
    include "Amcaf/Pix.asm"
    include "Amcaf/PP.asm"
    include "Amcaf/Protracker.asm"
    include "Amcaf/PTile.asm"
    include "Amcaf/Qfunctions.asm"
    include "Amcaf/RNC.asm"
    include "Amcaf/ScanStr.asm"
    include "Amcaf/Scrn.asm"
    include "Amcaf/ShadeBobs.asm"
    include "Amcaf/Splinters.asm"
    include "Amcaf/TdStars.asm"
    include "Amcaf/Time.asm"
    include "Amcaf/Palette.asm"
    include "Amcaf/ToolTypes.asm"
    include "Amcaf/Turbo.asm"

    include "Amcaf/Private.asm"

    dc.b    '32K-LIMIT!'
    even

    include "Amcaf/NonTokenFuncs.asm"
    include "Amcaf/CustomErrors.asm"
    include "Amcaf/PrecalcTables.asm"


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

    include "Amcaf/Error.asm"

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
C_Title    dc.b    "APU AMCAF Extension version V "
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
;                                                                                           * AREA NAME :        ***** Area Final Name *
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
