
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
;    include the files automatically calculated by
;    Library_Digest.AMOS
;---------------------------------------------------------------------
    include    "AMOSProUnity_AMCAF_Size.s"
    include    "AMOSProUnity_AMCAF_Labels.s"

; +++ You must include this file, it will decalre everything for you.
    include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
    include    "src/AmosProUnity_Version.s"


    IncDir  "includes/"
    include "libraries/lowlevel.i"
    include "exec/execbase.i"
    include "graphics/gfxbase.i"
    include "graphics/rastport.i"
    include "dos/datetime.i"
    include "libraries/Powerpacker_lib.i"

    include "AMOSPro_AMCAF_DataZones.s"


_LVOReadJoyPort         equ -30
_LVOSetJoyPortAttrs     equ -132

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

;    IFEQ    salever
;    IFNE    demover
;    bsr.s   .demove
;    ENDC
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

;.demove
;    ELSE
;    movem.l d1-d7/a0-a6,-(sp)
;    lea regdata(pc),a0
;    Rbsr    L_DecodeRegData
;    movem.l (sp)+,d1-d7/a0-a6
;    move.w  #$0110,d1
;    rts
;.error  sub.l   a0,a0
;    moveq.l #-1,d0
;    rts
;    ENDC

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
;;    include "Amcaf/3D.asm"
    Lib_Par      VecRotPos     *** Vec Rot Pos midx,midy,midz
    
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_VecRotPosZ(a2)
    move.l  (a3)+,d0
    move.w  d0,O_VecRotPosY(a2)
    move.l  (a3)+,d0
    move.w  d0,O_VecRotPosX(a2)
    rts

    Lib_Par      VecRotAngles      *** Vec Rot Angles angx,angy,angz
    
    dload   a2
    move.l  (a3)+,d0
    and.w   #$3ff,d0
    add.w   d0,d0
    move.w  d0,O_VecRotAngX(a2)
    move.l  (a3)+,d0
    and.w   #$3ff,d0
    add.w   d0,d0
    move.w  d0,O_VecRotAngY(a2)
    move.l  (a3)+,d0
    and.w   #$3ff,d0
    add.w   d0,d0
    move.w  d0,O_VecRotAngZ(a2)
    rts

    Lib_Par      VecRotPrecalc     *** Vec Rot Precalc
    
    dload   a2
    move.l  O_SineTable(a2),a1
    lea O_VecCosSines(a2),a0
    move.w  O_VecRotAngX(a2),d0
    move.w  (a1,d0.w),(a0)
        add.w   #$200,d0
    and.w   #$7fe,d0
    move.w  (a1,d0.w),2(a0)
    move.w  O_VecRotAngY(a2),d0
    move.w  (a1,d0.w),4(a0)
    add.w   #$200,d0
    and.w   #$7fe,d0
    move.w  (a1,d0.w),6(a0)
    move.w  O_VecRotAngZ(a2),d0
    move.w  (a1,d0.w),8(a0)
    add.w   #$200,d0
    and.w   #$7fe,d0
    move.w  (a1,d0.w),10(a0)
    lea O_VecConstants(a2),a1
    move.w  6(a0),d0
    move.w  (a0),d1
    move.w  d1,d2
    muls    d0,d1
    asr.l   #8,d1
    move.w  2(a0),d3
    muls    d3,d0
    asr.l   #8,d0
    move.w  d0,(a1)
;   neg.w   d1
    move.w  d1,2(a1)
    move.w  4(a0),4(a1)
    move.w  8(a0),d4
    move.w  d4,d6
    muls    4(a0),d4
    asr.l   #8,d4
    move.w  d4,d5
    muls    d2,d5
    muls    10(a0),d2
    muls    d3,d4
    muls    10(a0),d3
    add.l   d4,d2
    sub.l   d5,d3
    asr.l   #8,d2
    asr.l   #8,d3
    move.w  d2,6(a1)
    neg.w   d3
    move.w  d3,8(a1)
    muls    6(a0),d6
    asr.l   #8,d6
    neg.w   d6
    move.w  d6,10(a1)
    move.w  10(a0),d0
    move.w  d0,d4
    muls    4(a0),d0
    asr.l   #8,d0
    move.w  d0,d1
    move.w  8(a0),d2
    move.w  d2,d3
    muls    (a0),d0
    muls    2(a0),d1
    muls    (a0),d2
    muls    2(a0),d3
    sub.l   d1,d2
    asr.l   #8,d2
    move.w  d2,12(a1)
    add.l   d0,d3
    asr.l   #8,d3
    neg.w   d3
    move.w  d3,14(a1)
    muls    6(a0),d4
    asr.l   #8,d4
    move.w  d4,16(a1)
    rts

    Lib_Par      VecRotX3      *** =Vec Rot X(x,y,z)
    
    dload   a2
    Rbsr    L_VecRotDo
    ext.l   d3
    rts

    Lib_Par      VecRotX       *** =Vec Rot X
    
    dload   a2
    moveq.l #0,d2
    move.w  O_VecRotResX(a2),d3
    ext.l   d3
    rts

    Lib_Par      VecRotY3      *** =Vec Rot Y(x,y,z)
    
    dload   a2
    Rbsr    L_VecRotDo
    move.w  d4,d3
    ext.l   d3
    rts

    Lib_Par      VecRotY       *** =Vec Rot Y
    
    dload   a2
    moveq.l #0,d2
    move.w  O_VecRotResY(a2),d3
    ext.l   d3
    rts

    Lib_Par      VecRotZ3      *** =Vec Rot Z(x,y,z)
    
    dload   a2
    Rbsr    L_VecRotDo
    move.w  d5,d3
    ext.l   d3
    rts

    Lib_Par      VecRotZ       *** =Vec Rot Z
    
    dload   a2
    moveq.l #0,d2
    move.w  O_VecRotResZ(a2),d3
    ext.l   d3
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
;;    include "Amcaf/4Player.asm"
    Lib_Par      4PJoy         *** =Pjoy(j)
    
    lea $BFD000,a0
    lea $BFE101,a1
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .joy3
    cmp.b   #1,d0
    Rbne    L_IFonc32
    move.b  (a1),d3
    neg.b   d3
    lsr.b   #4,d3
    btst    d2,(a0)
    bne.s   .nofire
    add.b   #16,d3
.nofire rts
.joy3   move.b  (a1),d3
    neg.b   d3
    and.b   #%1111,d3
    btst    #2,(a0)
    bne.s   .nofire
    add.b   #16,d3
    rts

    Lib_Par      4PJLeft       *** =Pjleft(j)
    
    lea $BFE101,a1
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .joy3
    cmp.b   #1,d0
    Rbne    L_IFonc32
    btst    #6,(a1)
    bne.s   .notset
    moveq.l #-1,d3
.notset rts
.joy3   btst    #2,(a1)
    bne.s   .notset
    moveq.l #-1,d3
    rts

    Lib_Par      4PJRight      *** =Pjright(j)
    
    lea $BFE101,a1
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .joy3
    cmp.b   #1,d0
    Rbne    L_IFonc32
    btst    #7,(a1)
    bne.s   .notset
    moveq.l #-1,d3
.notset rts
.joy3   btst    #3,(a1)
    bne.s   .notset
    moveq.l #-1,d3
    rts

    Lib_Par      4PJUp         *** =Pjup(j)
    
    lea $BFE101,a1
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .joy3
    cmp.b   #1,d0
    Rbne    L_IFonc32
    btst    #4,(a1)
    bne.s   .notset
    moveq.l #-1,d3
.notset rts
.joy3   btst    d3,(a1)
    bne.s   .notset
    moveq.l #-1,d3
    rts

    Lib_Par      4PJDown       *** =Pjdown(j)
    
    lea $BFE101,a1
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .joy3
    cmp.b   #1,d0
    Rbne    L_IFonc32
    btst    #5,(a1)
    bne.s   .notset
    moveq.l #-1,d3
.notset rts
.joy3   btst    #1,(a1)
    bne.s   .notset
    moveq.l #-1,d3
    rts

    Lib_Par      4PFire        *** =Pfire(j)
    
    lea $BFD000,a0
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .joy3
    cmp.b   #1,d0
    Rbne    L_IFonc32
    btst    d3,(a0)
    bne.s   .notset
    moveq.l #-1,d3
.notset rts
.joy3   btst    #2,(a0)
    bne.s   .notset
    moveq.l #-1,d3
    rts

    Lib_Par      Xfire         *** =Xfire(port,fbut)
    
    dload   a2
    moveq.l #0,d2
    moveq.l #0,d3
    move.l  (a3)+,d6
    Rbmi    L_IFonc32
    cmp.w   #7,d6
    Rbge    L_IFonc32
    move.l  (a3)+,d7
    Rbmi    L_IFonc32
    cmp.w   #2,d7
    Rbge    L_IFonc32
    tst.w   d6
    beq.s   .redfir
    cmp.w   #1,d6
    beq.s   .blufir
    Rbsr    L_LLOpenLib
    move.l  a6,-(sp)
    move.l  O_LowLevelLib(a2),a6
    move.l  d7,d0
    lea .mtype(pc),a1
    jsr _LVOSetJoyPortAttrs(a6)
    move.l  d7,d0
    jsr _LVOReadJoyPort(a6)
    move.l  (sp)+,a6
    cmp.w   #2,d6
    beq.s   .yelfir
    cmp.w   #3,d6
    beq.s   .grefir
    cmp.w   #4,d6
    beq.s   .bckfir
    cmp.w   #5,d6
    beq.s   .forfir
    btst    #JPB_BUTTON_PLAY,d0
    bne.s   .setbut
    rts
.bckfir btst    #JPB_BUTTON_REVERSE,d0
    bne.s   .setbut
    rts
.forfir btst    #JPB_BUTTON_FORWARD,d0
    bne.s   .setbut
    rts
.grefir btst    #JPB_BUTTON_GREEN,d0
    bne.s   .setbut
    rts
.yelfir btst    #JPB_BUTTON_YELLOW,d0
    bne.s   .setbut
    rts
.redfir tst.w   d7
    beq.s   .rfir0
    btst    #7,$BFE001
    beq.s   .setbut
    rts
.rfir0  btst    #6,$BFE001
    bne.s   .nobut
.setbut moveq.l #-1,d3
.nobut  rts
.blufir tst.w   d7
    beq.s   .bfir0
    lea $DFF000,a0
    move.w  #$f000,$34(a0)
    btst    #6,$16(a0)
    beq.s   .setbut
    rts
.bfir0  lea $DFF000,a0
    move.w  #$f000,$34(a0)
    btst    #2,$16(a0)
    beq.s   .setbut
    rts
.mtype  dc.l    SJA_Type,SJA_TYPE_GAMECTLR,0
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
;;    include "Amcaf/Amcaf.asm"
    Lib_Par      AmcafBase     *** =Amcaf Base
    
    dload   d3
    moveq.l #0,d2
    rts

    Lib_Par      AmcafVersion      *** =Amcaf Version$
    
    lea .versst(pc),a0
    move.l  a0,d3
    moveq.l #2,d2
    rts
.versst dc.w    .endst-.versbg
    IFEQ    Languag-English
.versbg dc.b    "AMCAF extension V"
    version
    dc.b    " by Chris Hodges."
    ENDC
    IFEQ    Languag-Deutsch
.versbg dc.b    "AMCAF Erweiterung V"
    version
    dc.b    " von Chris Hodges."
    ENDC
.endst
    even

    Lib_Par      AmcafLength       *** =Amcaf Length
    
    moveq.l #0,d2
    move.l  #O_SizeOf,d3
    rts

    Lib_Par      NopC          *** Nop
    rts

    Lib_Par      NopF          *** =Nfn
    moveq.l #0,d2
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
;;    include "Amcaf/AudioLock.asm"
    Lib_Par      AudioLock     *** Audio Lock
    
    dload   a2
    tst.w   O_AudioOpen(a2)
    beq.s   .cont
    rts
.cont   move.l  a6,d6
    move.l  4.w,a6
    lea O_AudioPort(a2),a1
    tst.w   O_AudioPortOpen(a2)
    bne.s   .skip
    lea .portna(pc),a0
    move.l  a0,10(a1)
    move.w  #$0400,8(a1)
    clr.w   14(a1)
    sub.l   a1,a1
    jsr _LVOFindTask(a6)
    lea O_AudioPort(a2),a1
    move.l  d0,16(a1)
    jsr _LVOAddPort(a6)
.skip   lea O_AudioIO(a2),a0
    move.b  #127,9(a0)      ;Priority
    move.l  a1,14(a0)
    lea O_ChanMap(a2),a1
    move.b  #$0F,(a1)
    move.l  a1,$22(a0)
    move.b  #64,$1e(a0)
    moveq.l #1,d7
    move.l  d7,$26(a0)
    move.l  a0,a1
    lea .audion(pc),a0
    moveq.l #0,d0
    moveq.l #0,d1
    jsr _LVOOpenDevice(a6)
    move.l  d6,a6
    tst.l   d0
    beq.s   .cont2
    moveq.l #3,d0
    Rbra    L_Custom32
.cont2  st  O_AudioOpen(a2)
    rts
.portna dc.b    'AMOSPro Soundport',0
    even
.audion dc.b    'audio.device',0
    even

    Lib_Par      AudioFree     *** Audio Free
    dload   a2
    move.l  a6,d7
    tst.w   O_AudioOpen(a2)
    bne.s   .cont
    tst.w   O_AudioPortOpen(a2)
    bne.s   .cont2
    rts
.cont   lea O_AudioIO(a2),a1
    move.w  #9,$1c(a1)
    move.l  4.w,a6
    jsr _LVODoIO(a6)
    jsr _LVOCloseDevice(a6)
.cont2  lea O_AudioPort(a2),a1
    jsr _LVORemPort(a6)
    clr.w   O_AudioOpen(a2)
    move.l  d7,a6
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
;;    include "Amcaf/Bank.asm"
    Lib_Par      BankPermanent     *** Bank Permanent bank
    
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.w  -12(a0),d0
    bset    #0,d0
    move.w  d0,-12(a0)
    rts

    Lib_Par      BankTemporary     *** Bank Temporary bank
    
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.w  -12(a0),d0
    bclr    #0,d0
    move.w  d0,-12(a0)
    rts

    Lib_Par      BankChip      *** Bank To Chip bank
    
    move.l  (a3)+,d0
    move.l  d0,d7
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.w  -12(a0),d0
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom32
.noicon move.w  -12(a0),d1      ;Flags
    btst    #1,d1
    beq.s   .nochip
    rts
.nochip bset    #1,d1
    move.l  -20(a0),d2      ;Length
    subq.l  #8,d2
    subq.l  #8,d2
    moveq.l #-1,d0          ;Number
    move.w  #0,d0
    swap    d0
    move.l  a0,d6
    subq.l  #8,a0           ;Name
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  a0,d5
    move.l  d6,a1
    move.l  -20(a1),d0
    move.l  d0,d6
    lsr.l   d0
    subq.l  #8,d0
    subq.l  #1,d0
    move.l  d0,d1
    swap    d1
.loop   move.w  (a1)+,(a0)+
    dbra    d0,.loop
    dbra    d1,.loop
    btst    #0,d6
    beq.s   .even
    move.b  (a1)+,(a0)+
.even   move.l  d7,d0
    Rjsr    L_Bnk.Eff
    move.l  d5,a0
    move.l  d7,-16(a0)
    rts

    Lib_Par      BankFast      *** Bank To Fast bank
    
    move.l  (a3)+,d0
    move.l  d0,d7
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.w  -12(a0),d0
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom32
.noicon move.w  -12(a0),d1      ;Flags
    btst    #1,d1
    bne.s   .nofast
    rts
.nofast bclr    #1,d1
    move.l  -20(a0),d2      ;Length
    subq.l  #8,d2
    subq.l  #8,d2
    moveq.l #-1,d0          ;Number
    move.w  #0,d0
    swap    d0
    move.l  a0,d6
    subq.l  #8,a0           ;Name
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  a0,d5
    move.l  d6,a1
    move.l  -20(a1),d0
    move.l  d0,d6
    lsr.l   d0
    subq.l  #8,d0
    subq.l  #1,d0
    move.l  d0,d1
    swap    d1
.loop   move.w  (a1)+,(a0)+
    dbra    d0,.loop
    dbra    d1,.loop
    btst    #0,d6
    beq.s   .even
    move.b  (a1)+,(a0)+
.even   move.l  d7,d0
    Rjsr    L_Bnk.Eff
    move.l  d5,a0
    move.l  d7,-16(a0)
    rts

    Lib_Par      DeltaEncode2      *** Bank Delta Encode start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #2,d7
    move.l  d7,d6
    swap    d6
    move.b  (a0)+,d0
    move.b  (a0),d1
    sub.b   d0,(a0)+
    move.b  d1,d0
.loop   move.b  (a0),d1
    sub.b   d0,(a0)+
    move.b  d1,d0
    move.b  (a0),d1
    sub.b   d0,(a0)+
    move.b  d1,d0
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      DeltaEncode1      *** Bank Delta Encode bank
    
    Rbsr    L_GetBankLength
    Rbra    L_DeltaEncode2

    Lib_Par      DeltaDecode2      *** Bank Delta Decode start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #2,d7
    move.l  d7,d6
    swap    d6
    move.b  (a0)+,d0
    add.b   (a0),d0
    move.b  d0,(a0)+
.loop   add.b   (a0),d0
    move.b  d0,(a0)+
    add.b   (a0),d0
    move.b  d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      DeltaDecode1      *** Bank Delta Decode bank
    
    Rbsr    L_GetBankLength
    Rbra    L_DeltaDecode2

    Lib_Par      BankCodeXor2      *** Bank Code Xor.b code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   eor.b   d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeXor1      *** Bank Code Xor.b code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeXor2

    Lib_Par      BankCodeAdd2      *** Bank Code Add.b code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   add.b   d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeAdd1      *** Bank Code Add.b code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeAdd2

    Lib_Par      BankCodeMix2      *** Bank Code Mix.b code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
    move.l  d0,d1
    eor.b   #$AA,d1
.loop   add.b   d1,d0
    eor.b   d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeMix1      *** Bank Code Mix.b code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeMix2

    Lib_Par      BankCodeRol2      *** Bank Code Rol.b code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   move.b  (a0),d1
    rol.b   d0,d1
    move.b  d1,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeRol1      *** Bank Code Rol.b code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeRol2

    Lib_Par      BankCodeRor2      *** Bank Code Ror.b code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   move.b  (a0),d1
    ror.b   d0,d1
    move.b  d1,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeRor1      *** Bank Code Ror.b code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeRor2

    Lib_Par      BankCodeXorw2     *** Bank Code Xor.w code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   eor.w   d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeXorw1     *** Bank Code Xor.w code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeXorw2

    Lib_Par      BankCodeAddw2     *** Bank Code Add.w code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   add.w   d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeAddw1     *** Bank Code Add.w code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeAddw2

    Lib_Par      BankCodeMixw2     *** Bank Code Mix.w code,start To end
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
    move.l  d0,d1
    eor.w   #$FACE,d1
.loop   add.w   d1,d0
    eor.w   d0,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeMixw1     *** Bank Code Mix.w code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeMixw2

    Lib_Par      BankCodeRolw2     *** Bank Code Rol.w code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   move.w  (a0),d1
    rol.w   d0,d1
    move.w  d1,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeRolw1     *** Bank Code Rol.w code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeRolw2

    Lib_Par      BankCodeRorw2     *** Bank Code Ror.w code,start To end
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    move.l  (a3)+,d0
.loop   move.w  (a0),d1
    ror.w   d0,d1
    move.w  d1,(a0)+
    dbra    d7,.loop
    dbra    d6,.loop
    rts

    Lib_Par      BankCodeRorw1     *** Bank Code Ror.w code,bank
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCodeRorw2

    Lib_Par      BankStretch       *** Bank Stretch bank To length
    
    move.l  (a3)+,d6
    move.l  (a3)+,d0
    move.l  d0,-(sp)
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.w  -12(a0),d0
    move.w  d0,d1
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom32
.noicon move.l  -20(a0),d4      ;Length
    subq.l  #8,d4
    subq.l  #8,d4
    move.l  d6,d2
    moveq.l #-1,d0          ;Number
    move.w  #0,d0
    swap    d0
    move.l  a0,d7
    subq.l  #8,a0           ;Name
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  d4,d0
    cmp.l   d6,d4
    bls.s   .stretc
    move.l  d6,d0
.stretc move.l  a0,d5
    move.l  d7,a1
    lsr.l   d0
    subq.l  #1,d0
    move.l  d0,d1
    swap    d1
.loop   move.w  (a1)+,(a0)+
    dbra    d0,.loop
    dbra    d1,.loop
    btst    #0,d4
    beq.s   .even
    move.b  (a1)+,(a0)+
.even   move.l  (sp),d0
    Rjsr    L_Bnk.Eff
    move.l  d5,a0
    move.l  (sp)+,-16(a0)
    rts

    Lib_Par      BankCheckSum2     *** =Bank Checksum(bank To end)
    
    move.l  (a3)+,d7        ;End
    move.l  (a3)+,a0
    sub.l   a0,d7
    lsr.l   #2,d7
    subq.l  #1,d7
    move.l  d7,d6
    swap    d6
    moveq.l #0,d3
.loop   add.l   (a0)+,d3
    dbra    d7,.loop
    dbra    d6,.loop
    eor.l   #$FACEFACE,d3
    moveq.l #0,d2
    rts

    Lib_Par      BankCheckSum1     *** =Bank Checksum(bank)
    
    Rbsr    L_GetBankLength
    Rbra    L_BankCheckSum2
    
    Lib_Par      BankCopy2     *** Bank Copy bank,end To bank
    
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d0
    move.l  d0,a0
    move.w  -12(a0),d1
    and.w   #%1111111111110000,d1
    tst.w   d1
    bne.s   .nobank
    move.l  -16(a0),d1
    cmp.l   d1,d7
    Rbeq    L_IFonc32
    move.w  -12(a0),d1
    move.l  d6,d2
    move.l  a0,d6
    subq.l  #8,a0           ;Name
    bra.s   .bank
.nobank moveq.w #0,d1
    move.l  d6,d2
    move.l  a0,d6
    lea .bkwork(pc),a0      ;Name
.bank   sub.l   d6,d2
    move.l  d2,d5
    move.l  d7,d0           ;Number
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  d6,a1
    move.l  d5,d0
    lsr.l   d0
    subq.l  #1,d0
    move.l  d0,d1
    swap    d1
.loop   move.w  (a1)+,(a0)+
    dbra    d0,.loop
    dbra    d1,.loop
    btst    #0,d5
    beq.s   .even
    move.b  (a1)+,(a0)+
.even   rts
.bkwork dc.b    'Work    '
    even

    Lib_Par      BankCopy1     *** Bank Copy bank To bank
    
    move.l  (a3)+,d7
    Rbsr    L_GetBankLength
    move.l  d7,-(a3)
    Rbra    L_BankCopy2

    Lib_Par      BankNameC     *** Bank Name bank,name$
    
    move.l  (a3)+,a2
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  #'    ',d0
    move.l  d0,-8(a0)
    move.l  d0,-4(a0)
    move.w  (a2)+,d0
    beq.s   .zero
    cmp.w   #8,d0
    bls.s   .normal
    moveq.w #8,d0
.normal subq.w  #1,d0
    subq.l  #8,a0
.loop   move.b  (a2)+,(a0)+
    dbra    d0,.loop
.zero   rts

    Lib_Par      BankNameF     *** =Bank Name$(bank)
    
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  a0,a2
    subq.l  #8,a2
    moveq.l #10,d3
    Rjsr    L_Demande
    move.l  a0,d3
    move.w  #8,(a0)+
    move.l  (a2)+,(a0)+
    move.l  (a2),(a0)+
    move.l  a0,HiChaine(a5)
    moveq.l #2,d2
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
;;    include "Amcaf/Blitter.asm"
    Lib_Par      BlitterCopyLimit1 *** Blitter Copy Limit screen
    
    dload   a2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    clr.l   O_BlitAX(a2)
    move.w  EcTx(a0),d0
    lsr.w   #4,d0
    move.w  d0,O_BlitAWidth(a2)
    move.w  EcTy(a0),O_BlitAHeight(a2)
    rts

    Lib_Par      BlitterCopyLimit4 *** Blitter Copy Limit x1,y1 To x2,y2
    
    dload   a2
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.w  d5,O_BlitAY(a2)
    move.l  (a3)+,d4
    lsr.w   #4,d4
    add.w   #15,d6
    lsr.w   #4,d6
    sub.w   d4,d6
    bne.s   .cont
.noblit Rbra    L_IFonc32
.cont   bmi.s   .noblit
    move.w  d6,O_BlitAWidth(a2)
    sub.w   d5,d7
    beq.s   .noblit
    bmi.s   .noblit
    move.w  d7,O_BlitAHeight(a2)
    move.w  d4,O_BlitAX(a2)
    rts

    Lib_Par      BlitterCopy4      *** Blitter Copy sa,pa To sd,pd
    
    move.l  #%11110000,-(a3)
    Rbra    L_BlitterCopy5

    Lib_Par      BlitterCopy5      *** Blitter Copy sa,pa To sd,pd,mt
    
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_BlitMinTerm(a2)
    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitTargetPln(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitTargetMod(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourceA(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceAMd(a2)

    moveq.l #0,d0
    move.w  O_BlitAX(a2),d0
    add.w   d0,d0
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitSourceAMd(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitSourceA(a2)
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitTargetMod(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitTargetPln(a2)

    move.w  O_BlitAWidth(a2),d6
    move.w  O_BlitAHeight(a2),d2
    lsl.w   #6,d2
    add.w   d6,d2

    move.w  O_BlitSourceAMd(a2),d6
    move.w  O_BlitAWidth(a2),d0
    add.w   d0,d0
    sub.w   d0,d6
    move.w  O_BlitTargetMod(a2),d7
    sub.w   d0,d7

    lea $dff000,a1
.blifin move.w  #%1000010000000000,$96(a1)
    btst    #6,2(a1)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a1)
    move.l  a6,d3
    move.l  T_GfxBase(a5),a6
    jsr _LVOOwnBlitter(a6)
    move.l  d3,a6

    moveq.l #0,d0
    move.w  O_BlitMinTerm(a2),d0
    and.w   #$FF,d0
    add.w   #$900,d0
    swap    d0
    move.l  d0,$40(a1)
    moveq.l #-1,d0
    move.l  d0,$44(a1)
    move.l  O_BlitSourceA(a2),$50(a1)
    move.l  O_BlitTargetPln(a2),$54(a1)
    move.w  d6,$64(a1)
    move.w  d7,$66(a1)
    move.w  d2,$58(a1)
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVODisownBlitter(a6)
    move.l  d7,a6
    rts

    Lib_Par      BlitterCopy6      *** Blitter Copy sa,pa,sb,pd To sd,pd
    
    move.l  #%11111100,-(a3)
    Rbra    L_BlitterCopy7

    Lib_Par      BlitterCopy7      *** Blitter Copy sa,pa,sb,pb To sd,pd,mt
    
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_BlitMinTerm(a2)
    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitTargetPln(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitTargetMod(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourceB(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceBMd(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourceA(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceAMd(a2)

    moveq.l #0,d0
    move.w  O_BlitAX(a2),d0
    add.w   d0,d0
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitSourceAMd(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitSourceA(a2)
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitSourceBMd(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitSourceB(a2)
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitTargetMod(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitTargetPln(a2)

    move.w  O_BlitAWidth(a2),d6
    move.w  O_BlitAHeight(a2),d2
    lsl.w   #6,d2
    add.w   d6,d2

    move.w  O_BlitSourceAMd(a2),d6
    move.w  O_BlitAWidth(a2),d0
    add.w   d0,d0
    sub.w   d0,d6
    move.w  O_BlitSourceBMd(a2),d5
    sub.w   d0,d5
    move.w  O_BlitTargetMod(a2),d7
    sub.w   d0,d7

    lea $dff000,a1
.blifin move.w  #%1000010000000000,$96(a1)
    btst    #6,2(a1)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a1)
    move.l  a6,d3
    move.l  T_GfxBase(a5),a6
    jsr _LVOOwnBlitter(a6)
    move.l  d3,a6

    moveq.l #0,d0
    move.w  O_BlitMinTerm(a2),d0
    and.w   #$FF,d0
    add.w   #$0D00,d0
    swap    d0
    move.l  d0,$40(a1)
    moveq.l #-1,d0
    move.l  d0,$44(a1)
    move.l  O_BlitSourceB(a2),$4c(a1)
    move.l  O_BlitSourceA(a2),$50(a1)
    move.l  O_BlitTargetPln(a2),$54(a1)
    move.w  d5,$62(a1)
    move.w  d6,$64(a1)
    move.w  d7,$66(a1)
    move.w  d2,$58(a1)
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVODisownBlitter(a6)
    move.l  d7,a6
    rts

    Lib_Par      BlitterCopy8      *** Blitter Copy sa,pa,sb,pb,sc,pc To sd,pd
    
    dload   a2
    move.l  #$FF,-(a3)
    Rbra    L_BlitterCopy9

    Lib_Par      BlitterCopy9      *** Blitter Copy sa,pa,sb,pb,sc,pc To sd,pd,mt
    
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_BlitMinTerm(a2)
    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitTargetPln(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitTargetMod(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourceC(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceCMd(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourceB(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceBMd(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourceA(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceAMd(a2)

    moveq.l #0,d0
    move.w  O_BlitAX(a2),d0
    add.w   d0,d0
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitSourceAMd(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitSourceA(a2)
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitSourceBMd(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitSourceB(a2)
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitSourceCMd(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitSourceC(a2)
    moveq.l #0,d4
    move.w  O_BlitAY(a2),d4
    mulu    O_BlitTargetMod(a2),d4
    add.l   d0,d4
    add.l   d4,O_BlitTargetPln(a2)

    move.w  O_BlitAWidth(a2),d6
    move.w  O_BlitAHeight(a2),d2
    lsl.w   #6,d2
    add.w   d6,d2

    move.w  O_BlitSourceAMd(a2),d6
    move.w  O_BlitAWidth(a2),d0
    add.w   d0,d0
    sub.w   d0,d6
    move.w  O_BlitSourceBMd(a2),d5
    sub.w   d0,d5
    move.w  O_BlitSourceCMd(a2),d4
    sub.w   d0,d4
    move.w  O_BlitTargetMod(a2),d7
    sub.w   d0,d7

    lea $dff000,a1
.blifin move.w  #%1000010000000000,$96(a1)
    btst    #6,2(a1)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a1)
    move.l  a6,d3
    move.l  T_GfxBase(a5),a6
    jsr _LVOOwnBlitter(a6)
    move.l  d3,a6

    moveq.l #0,d0
    move.w  O_BlitMinTerm(a2),d0
    and.w   #$FF,d0
    add.w   #$0F00,d0
    swap    d0
    move.l  d0,$40(a1)
    moveq.l #-1,d0
    move.l  d0,$44(a1)
    move.l  O_BlitSourceC(a2),$48(a1)
    move.l  O_BlitSourceB(a2),$4c(a1)
    move.l  O_BlitSourceA(a2),$50(a1)
    move.l  O_BlitTargetPln(a2),$54(a1)
    move.w  d4,$60(a1)
    move.w  d5,$62(a1)
    move.w  d6,$64(a1)
    move.w  d7,$66(a1)
    move.w  d2,$58(a1)
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVODisownBlitter(a6)
    move.l  d7,a6
    rts

    Lib_Par      BlitBusy      *** =Blitter Busy
    
    moveq.l #0,d2
    btst    #6,$DFF002
    bne.s   .busy
    moveq.l #0,d3
    rts
.busy   moveq.l #-1,d3
    rts

    Lib_Par      BlitWait      *** Blitter Wait
    
    lea $DFF000,a1
.blifin move.w  #%1000010000000000,$96(a1)
    btst    #6,2(a1)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a1)
    rts

    Lib_Par      BlitClear2        *** Blitter Clear screen,plane
    
    move.l  4(a3),d1
    Rjsr    L_GetEc
    moveq.l #0,d0
    clr.l   -(a3)
    clr.l   -(a3)
    move.w  EcTx(a0),d0
    move.l  d0,-(a3)
    move.w  EcTy(a0),d0
    move.l  d0,-(a3)
    Rbra    L_BlitClear

    Lib_Par      BlitClear     *** Blitter Clear s,p,x1,y1 To x2,y2
    
    dload   a2
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.w  d5,O_BlitY(a2)
    move.l  (a3)+,d4
    lsr.w   #4,d4
    add.w   #15,d6
    lsr.w   #4,d6
    sub.w   d4,d6
    bne.s   .cont
.noblit addq.l  #8,a3
    rts
.cont   bmi.s   .noblit
    move.w  d6,O_BlitWidth(a2)
    sub.w   d5,d7
    beq.s   .noblit
    bmi.s   .noblit
    move.w  d7,O_BlitHeight(a2)
    move.w  d4,O_BlitX(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourcePln(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceMod(a2)

    moveq.l #0,d4
    moveq.l #0,d0
    move.w  O_BlitY(a2),d4
    mulu    O_BlitSourceMod(a2),d4
    move.w  O_BlitX(a2),d0
    add.l   d0,d4
    add.l   d0,d4
    add.l   d4,O_BlitSourcePln(a2)

    move.w  O_BlitWidth(a2),d6
    move.w  O_BlitHeight(a2),d5
    lsl.w   #6,d5
    add.w   d6,d5

    move.w  O_BlitSourceMod(a2),d6
    move.w  O_BlitWidth(a2),d0
    sub.w   d0,d6
    sub.w   d0,d6

    lea $dff000,a1
.blifin move.w  #%1000010000000000,$96(a1)
    btst    #6,2(a1)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a1)
    move.l  a6,d4
    move.l  T_GfxBase(a5),a6
    jsr _LVOOwnBlitter(a6)
    move.l  d4,a6
;                 3210ABCD765432103210xxxxxxxEICDL
    move.l  #%00000001111100000000000000000000,$40(a1)
    clr.w   $74(a1)
    moveq.l #-1,d0
    move.l  d0,$44(a1)
    move.l  O_BlitSourcePln(a2),$54(a1)
    move.w  d6,$66(a1)
    move.w  d5,$58(a1)
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVODisownBlitter(a6)
    move.l  d7,a6
    rts

    Lib_Par      BlitFill6     *** Blitter Fill s1,p1,x1,y1,x2,y2
    
    move.l  16(a3),d6
    move.l  20(a3),d7
    move.l  d7,-(a3)
    move.l  d6,-(a3)
    Rbra    L_BlitFill

    Lib_Par      BlitFill4     *** Blitter Fill s1,p1 To s2,p2
    
    move.l  (a3)+,d6
    move.l  (a3)+,d7
    move.l  4(a3),d1
    Rjsr    L_GetEc
    moveq.l #0,d0
    clr.l   -(a3)
    clr.l   -(a3)
    move.w  EcTx(a0),d0
    move.l  d0,-(a3)
    move.w  EcTy(a0),d0
    move.l  d0,-(a3)
    move.l  d7,-(a3)
    move.l  d6,-(a3)
    Rbra    L_BlitFill

    Lib_Par      BlitFill2     *** Blitter Fill screen,plane
    
    move.l  4(a3),d1
    move.l  d1,d7
    move.l  (a3),d6
    Rjsr    L_GetEc
    moveq.l #0,d0
    clr.l   -(a3)
    clr.l   -(a3)
    move.w  EcTx(a0),d0
    move.l  d0,-(a3)
    move.w  EcTy(a0),d0
    move.l  d0,-(a3)
    move.l  d7,-(a3)
    move.l  d6,-(a3)
    Rbra    L_BlitFill

    Lib_Par      BlitFill      *** Blitter Fill s1,p1,x1,y1,x2,y2 To s2,p2
    
    dload   a2
    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitTargetPln(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitTargetMod(a2)
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.w  d5,O_BlitY(a2)
    move.l  (a3)+,d4
    lsr.w   #4,d4
    add.w   #15,d6
    lsr.w   #4,d6
    sub.w   d4,d6
    bne.s   .cont
.noblit addq.l  #8,a3
    rts
.cont   bmi.s   .noblit
    move.w  d6,O_BlitWidth(a2)
    sub.w   d5,d7
    beq.s   .noblit
    bmi.s   .noblit
    move.w  d7,O_BlitHeight(a2)
    move.w  d4,O_BlitX(a2)

    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   d4,d7
    Rbge    L_IFonc32
    lsl.l   #2,d7
    move.l  (a0,d7),O_BlitSourcePln(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,O_BlitSourceMod(a2)

    moveq.l #0,d4
    moveq.l #0,d0
    move.w  O_BlitY(a2),d4
    add.w   O_BlitHeight(a2),d4
    subq.w  #1,d4
    mulu    O_BlitSourceMod(a2),d4
    move.w  O_BlitX(a2),d0
    add.w   O_BlitWidth(a2),d0
    add.l   d0,d4
    add.l   d0,d4
    subq.l  #2,d4
    add.l   d4,O_BlitSourcePln(a2)
    moveq.l #0,d4
    moveq.l #0,d0
    move.w  O_BlitY(a2),d4
    add.w   O_BlitHeight(a2),d4
    subq.w  #1,d4
    mulu    O_BlitTargetMod(a2),d4
    move.w  O_BlitX(a2),d0
    add.w   O_BlitWidth(a2),d0
    add.l   d0,d4
    add.l   d0,d4
    subq.l  #2,d4
    add.l   d4,O_BlitTargetPln(a2)

    move.w  O_BlitWidth(a2),d6
    move.w  O_BlitHeight(a2),d5
    lsl.w   #6,d5
    add.w   d6,d5

    move.w  O_BlitSourceMod(a2),d6
    move.w  O_BlitWidth(a2),d0
    sub.w   d0,d6
    sub.w   d0,d6
    move.w  O_BlitTargetMod(a2),d7
    move.w  O_BlitWidth(a2),d0
    sub.w   d0,d7
    sub.w   d0,d7

    lea $dff000,a1
.blifin move.w  #%1000010000000000,$96(a1)
    btst    #6,2(a1)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a1)
    move.l  a6,d4
    move.l  T_GfxBase(a5),a6
    jsr _LVOOwnBlitter(a6)
    move.l  d4,a6

    move.l  #$09f00012,$40(a1)
;   move.l  #$09f0000a,$40(a1)
    moveq.l #-1,d0
    move.l  d0,$44(a1)
    move.l  O_BlitSourcePln(a2),$50(a1)
    move.l  O_BlitTargetPln(a2),$54(a1)
    move.w  d6,$64(a1)
    move.w  d7,$66(a1)
    move.w  d5,$58(a1)
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVODisownBlitter(a6)
    move.l  d7,a6
    rts
    IFEQ    1
.nodfil bsr.s   .maknod
    move.l  #$09f00012,Bn_B40l(a1)
    moveq.l #-1,d0
    move.l  d0,Bn_B44l(a1)
    move.l  O_BlitSourcePln(a2),Bn_B50l(a1)
    move.l  O_BlitTargetPln(a2),Bn_B54l(a1)
    move.w  d6,Bn_B64w(a1)
    move.w  d7,Bn_B66w(a1)
    move.w  d5,Bn_B58w(a1)
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVOQBlit(a6)
    move.l  d7,a6
    rts
.maknod movem.l d0/d1/a0,-(sp)
    moveq.l #Bn_SizeOf,d0
    moveq.l #0,d1
    move.l  a6,d7
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IOoMem
    move.l  d0,a1
    clr.l   (a1)
    lea .blirou(pc),a0
    move.l  a0,Bn_Function(a1)
    move.w  #$4000,Bn_Stat(a1)
    clr.l   Bn_Dummy(a1)
    lea .clenup(pc),a0
    move.l  a0,Bn_CleanUp(a1)
    movem.l (sp)+,d0/d1/a0
    rts
.blirou move.l  Bn_B40l(a1),$40(a0)
    move.l  Bn_B44l(a1),$44(a0)
    move.l  Bn_B50l(a1),$50(a0)
    move.l  Bn_B54l(a1),$54(a0)
    move.l  Bn_B64w(a1),$62(a0)
    move.w  Bn_B66w(a1),$66(a0)
    move.w  Bn_B58w(a1),$58(a0)
    moveq.l #0,d0
    rts
.clenup movem.l a0/a1/a6/d1,-(sp)
    moveq.l #Bn_SizeOf,d0
    move.l  4.w,a6
    jsr _LVOFreeMem(a6)
    movem.l (sp)+,a0/a1/a6/d1
    moveq.l #0,d0
    rts
    ENDC
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
;;    include "Amcaf/C2P.asm"
    Lib_Par      C2PFire       *** C2p Fire st,wx,wy To st2,sub
    
    move.l  (a3)+,d7
    move.l  (a3)+,a1
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    mulu    d5,d6
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.l  d5,d4
    moveq.l #0,d1
    neg.l   d4
    moveq.l #0,d2
    moveq.l #0,d3
    dload   a2
    lea O_Div5Buf(a2),a2
.loop   moveq.l #0,d0
    move.b  (a0,d5.w),d0
    move.b  (a0,d4.w),d1
    move.b  -1(a0),d2
    add.w   d1,d0
    move.b  (a0)+,d3
    add.w   d2,d0
    move.b  (a0),d1
    add.w   d3,d0
    add.w   d1,d0
    move.b  (a2,d0.w),d0
    sub.w   d7,d0
    bpl.s   .cont
    clr.b   (a1)+
    subq.l  #1,d6
    bne.s   .loop
    rts
.cont   move.b  d0,(a1)+
    subq.l  #1,d6
    bne.s   .loop
    rts

    Lib_Par      C2PShift      *** C2p Shift st,wx,wy To st2,sh
    
    move.l  (a3)+,d7
    beq.s   .nlycpy
    move.l  (a3)+,a2
    move.l  (a3)+,d5
    move.l  (a3)+,d6
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr     ;bank???
    mulu    d5,d6
    lsr.l   #2,d6
    moveq.l #-1,d0
    lsr.b   d7,d0
    move.b  d0,d1
    lsl.w   #8,d0
    move.b  d1,d0
    lsl.l   #8,d0
    move.b  d1,d0
    lsl.l   #8,d0
    move.b  d1,d0
.loop1  move.l  (a0)+,d1
    lsr.l   d7,d1
    and.l   d0,d1
    move.l  d1,(a2)+
    subq.l  #1,d6
    bne.s   .loop1
    rts
.nlycpy move.l  (a3)+,a2
    move.l  (a3)+,d5
    move.l  (a3)+,d6
    move.l  (a3)+,a0
    mulu    d5,d6
    lsr.l   #2,d6
.loop2  move.l  (a0)+,(a2)+
    subq.l  #1,d6
    bne.s   .loop2
    rts

    Lib_Par      C2PConvert        *** C2p Convert st,wx,wy To screen,x,y
    
    move.l  4.w,a0
    move.w  AttnFlags(a0),d0
    btst    #AFB_68020,d0
    bne.s   .go020
    moveq.l #19,d0
    Rbra    L_Custom32
.go020  dload   a2
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcNPlan(a0),d4
    cmp.w   #4,d4
    bge.s   .goodpl
    moveq.l #18,d0
    Rbra    L_Custom32
.goodpl move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.l  a0,a1
    move.l  (a3)+,a0
    Rbra    L_KalmsC2P

    Lib_Par      SetC2PSource      *** Set C2p Source buf,width,height,ox,oy,wx,wy
    
    dload   a2
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.w  d5,O_C2PSourceOY(a2)
    move.l  (a3)+,d4
    move.w  d4,O_C2PSourceOX(a2)
    sub.l   d4,d6
    sub.l   d5,d7
    move.w  d6,O_C2PSourceWX(a2)
    move.w  d7,O_C2PSourceWY(a2)
    move.l  (a3)+,d3
    move.w  d3,O_C2PSourceBuWY(a2)
    move.l  (a3)+,d2
    move.w  d2,O_C2PSourceBuWX(a2)
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d2,d0
    mulu    d7,d0
    add.l   d6,d0
    add.l   d0,a0
    move.l  a0,O_C2PSourceBuf(a2)
    sub.w   d6,d2
    move.w  d2,O_C2PSourceXMod(a2)
    rts

    Lib_Par      C2pZoom7      *** C2p Zoom buf2,width,height,x1,y1 To x2,y2
    IFEQ    1
    
    Rbsr    L_C2pZoomInit
    movem.l a3-a5,-(sp)     ;actual zoomer
    move.l  O_C2PSourceBuf(a2),a5
    move.l  O_C2PTargetBuf(a2),a1
    lea O_C2PZoomPreY(a2),a4
.yloop  move.w  (a4)+,d0
    lea O_C2PZoomPreX(a2),a3
    lea (a5,d0.w),a5
    move.l  a5,a0
    move.w  d6,d5
.xloop  add.w   (a3)+,a0
    move.b  (a0),(a1)+
    dbra    d5,.xloop
    add.w   O_C2PTargetXMod(a2),a1
    dbra    d7,.yloop
    movem.l (sp)+,a3-a5
    ENDC
    rts

    Lib_Par      C2pZoom8      *** C2p Zoom buf2,width,height,x1,y1 To x2,y2,mask
    IFEQ    1
    
    move.l  (a3)+,d0
    Rbsr    L_C2PZoomInit
    movem.l a3-a5,-(sp)     ;actual zoomer
    move.l  O_C2PSourceBuf(a2),a5
    move.l  O_C2PTargetBuf(a2),a1
    lea O_C2PZoomPreY(a2),a4
.yloop  move.w  (a4)+,d0
    lea O_C2PZoomPreX(a2),a3
    lea (a5,d0.w),a5
    move.l  a5,a0
    move.w  d6,d5
.xloop  add.w   (a3)+,a0
    move.b  (a0),d0
    beq.s   .skip
    move.b  d0,(a1)+
    dbra    d5,.xloop
.ret    add.w   O_C2PTargetXMod(a2),a1
    dbra    d7,.yloop
    movem.l (sp)+,a3-a5
    rts
.skip   addq.l  #1,a1
    dbra    d5,.xloop
    bra.s   .ret
    ENDC

    Lib_Par      C2pZoomInit
    IFEQ    1
    dload   a2
    tst.l   O_C2PSourceBuf(a2)
    Rbeq    L_IFonc
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    sub.w   d5,d7           ;newheight
    Rble    L_IFonc
    move.w  d7,O_C2PTargetWY(a2)
    sub.w   d4,d6           ;newwidth
    Rble    L_IFonc
    move.w  d6,O_C2PTargetWX(a2)
    addq.l  #4,a3
    move.l  (a3)+,d3
    mulu    d3,d5
    add.l   d5,d4           ;offs
    sub.w   d6,d3           ;xmod
    move.w  d3,O_C2PTargetXMod(a2)
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    add.l   d4,a0
    move.l  a0,O_C2PTargetBuf(a2)   ;bufstart
    subq.w  #1,d6
    subq.w  #1,d7

    lea O_C2PZoomPreX(a2),a0
    move.w  O_C2PSourceWX(a2),d0
    move.w  O_C2PTargetWX(a2),d1
    moveq.w #1,d4
    bsr .interp
    lea O_C2PZoomPreY(a2),a0
    move.w  O_C2PSourceWY(a2),d0
    move.w  O_C2PTargetWY(a2),d1
    move.w  O_C2PSourceBuWX(a2),d4

.interp move.w  d1,d5
    subq.w  #1,d5           ;bytescounter
    cmp.w   d0,d1
    beq.s   .same

.zoom   move.w  d0,d2
    add.w   d0,d0
    add.w   d1,d1
    move.w  d4,d3
    neg.w   d3
.zomlop add.w   d4,d3
    sub.w   d1,d2
.zomres bgt.s   .zomlop
    move.w  d3,(a0)+
    moveq.l #0,d3
    add.w   d0,d2
    dbra    d5,.zomres
    rts
.same   move.w  d4,(a0)+
    dbra    d5,.same
    ENDC
    rts

    Lib_Par      AllocTransSource  *** Alloc Trans Source bank
    
    dload   a2
    moveq.l #1,d2
    swap    d2
    move.l  (a3)+,d0
    lea .bnknam(pc),a0
    moveq.l #0,d1
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  d0,O_TransSource(a2)
    rts
.bnknam dc.b    'TransSrc'

    Lib_Par      SetTransSource    *** Set Trans Source bank
    
    dload   a2
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  a0,O_TransSource(a2)
    rts

    Lib_Par      AllocTransMap     *** Alloc Trans Map bank,width,height
    
    dload   a2
    move.l  (a3)+,d3
    move.w  d3,O_TransHeight(a2)
    move.l  (a3)+,d2
    add.w   #31,d2
    and.w   #$FFE0,d2
    move.w  d2,O_TransWidth(a2)
    mulu    d3,d2
    add.l   d2,d2
    lea .bnknam(pc),a0
    moveq.l #0,d1
    move.l  (a3)+,d0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  d0,O_TransMap(a2)
    rts
.bnknam dc.b    'TransMap'

    Lib_Par      SetTransMap       *** Set Trans Map bank,width,height
    
    dload   a2
    move.l  (a3)+,d3
    move.w  d3,O_TransHeight(a2)
    move.l  (a3)+,d2
    add.w   #31,d2
    and.w   #$FFE0,d2
    move.w  d2,O_TransWidth(a2)
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  a0,O_TransMap(a2)
    rts

    Lib_Par      AllocCodeBank     *** Alloc Code Bank bank,size
    
    dload   a2
    move.l  (a3)+,d2
    move.l  d2,O_CodeBankSize(a2)
    move.l  (a3)+,d0
    moveq.l #0,d1
    lea .bnknam(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem32
    move.l  d0,O_CodeBank(a2)
    rts
.bnknam dc.b    'CodeBank'

    Lib_Par      TransScreenPrep
    
    dload   a2
    move.l  (a3)+,d7
    move.l  (a3)+,d5
    and.w   #$FFF0,d5
    lsr.w   #3,d5
    move.l  (a3)+,d4
    Rbmi    L_IFonc32
    cmp.w   #6,d4
    Rbhi    L_IFonc32
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcTx(a0),d6
    lsr.w   #3,d6
    mulu    d6,d7
    add.l   d5,d7
    move.w  O_TransWidth(a2),d5
    lsr.w   #3,d5
    sub.w   d5,d6
    lsl.w   #2,d4
    move.l  (a0,d4.w),a1
    add.l   d7,a1
    rts

    Lib_Par      TransScreenRuntime    *** Trans Screen Runtime scr,bitplane,ox,oy
    Rbsr    L_TransScreenPrep   
    movem.l a3,-(sp)
    move.l  O_TransMap(a2),a3
    move.l  O_TransSource(a2),a0
    lea $7FFE(a0),a0
    addq.l  #2,a0
    move.w  O_TransHeight(a2),d7
    subq.w  #1,d7
    moveq.l #0,d4
.yloop  move.w  O_TransWidth(a2),d5
    lsr.w   #5,d5
    subq.w  #1,d5
.xloop  moveq.l #15,d2
.zaplop move.l  (a3)+,d4
    move.b  (a0,d4.w),d3
    swap    d4
    move.b  (a0,d4.w),d1
    lsr.w   d1
    addx.l  d0,d0
    lsr.w   d3
    addx.l  d0,d0
    dbra    d2,.zaplop
    move.l  d0,(a1)+
    dbra    d5,.xloop
    add.w   d6,a1
    dbra    d7,.yloop
    movem.l (sp)+,a3
    rts

    Lib_Par      TransScreenDynamic    *** Trans Screen Dynamic scr,bitplane,ox,oy
    Rbsr    L_TransScreenPrep
    move.l  O_CodeBank(a2),d0
    Rbeq    L_IFonc32
    movem.l a3-a6,-(sp)
    move.l  d0,a5
    move.w  #$207C,(a5)+
    move.l  a1,(a5)+
    sub.l   a1,a1

    move.l  O_TransMap(a2),a3
    move.l  O_TransSource(a2),a0
    lea $7FFE(a0),a0
    addq.l  #2,a0

    move.w  O_TransHeight(a2),d7
    subq.w  #1,d7
    moveq.l #0,d4
.yloop  move.w  O_TransWidth(a2),d5
    lsr.w   #5,d5
    subq.w  #1,d5
.xloop  moveq.l #15,d2
.zaplop move.l  (a3)+,d4
    move.b  (a0,d4.w),d3
    swap    d4
    move.b  (a0,d4.w),d1
    asr.w   d1
    addx.l  d0,d0
    asr.w   d3
    addx.l  d0,d0
    dbra    d2,.zaplop
    tst.l   d0
    beq.s   .nodot
    move.w  #$217C,(a5)+
    move.l  d0,(a5)+
    move.w  a1,(a5)+
.nodot
    addq.w  #4,a1
    dbra    d5,.xloop
    add.w   d6,a1
    dbra    d7,.yloop
    move.w  #'Nu',(a5)+

    move.l  4.w,a6
    jsr _LVOCacheClearU(a6)
    movem.l (sp)+,a3-a6
    rts

    Lib_Par      TransScreenStatic
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
;;    include "Amcaf/CnvGrey.asm"
    Lib_Par      ConvertGrey       *** Convert Grey s1 To s2
    
    IFEQ    demover
    Rbra    L_ConvertGreyNoToken
    ELSE
    addq.l  #8,a3
    rts
    ENDC
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
;;    include "Amcaf/Chunky.asm"
    Lib_Par      ChunkyRead        *** Chunky Read s,x1,y1 To x2,y2,bank
    
    lea -16(sp),sp
    move.l  (a3)+,d3
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.w  d4,4(sp)        ;x1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    move.w  d6,d2
    mulu    d7,d2
    addq.l  #4,d2
    move.l  d3,d0
    moveq.l #0,d1
    lea .bkchun(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,a1
    move.w  d6,(a1)+
    move.w  d7,(a1)+
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
    move.w  d0,6(sp)
    move.l  a2,12(sp)
    moveq.l #0,d2
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
    move.w  d6,8(sp)
.xloop  move.w  d5,d3
    move.w  d1,d4
    lsr.w   #3,d4
    add.l   d4,d3
    move.b  d1,d4
    not.b   d4
    move.l  12(sp),a0
    move.w  EcNPlan(a0),d0
    subq.w  #1,d0
    moveq.l #1,d2
    clr.b   (a1)
.gloop  move.l  (a0)+,a2
    btst    d4,(a2,d3.l)
    beq.s   .skip
    add.b   d2,(a1)
    add.b   d2,d2
    dbra    d0,.gloop
    bra.s   .cont
.skip   add.b   d2,d2
    dbra    d0,.gloop
.cont   addq.l  #1,a1
    addq.w  #1,d1
    dbra    d6,.xloop
    add.l   6(sp),d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts
.bkchun dc.b    'Chunky  '
    even

    Lib_Par      ChunkyDraw4       *** Chunky Draw s,x,y,bank
    
    move.l  12(a3),d1
    Rjsr    L_GetEc
    moveq.l #0,d0
    move.w  EcNPlan(a0),d0
    move.l  d0,-(a3)
    Rbra    L_ChunkyDraw5

    Lib_Par      ChunkyDraw5
    dload   a2
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
;;    include "Amcaf/Color.asm"
    Lib_Par      AgaNotationOn     *** Amcaf Aga Notation On
    
    dload   a2
    move.w  #4,O_AgaColor(a2)
    rts

    Lib_Par      AgaNotationOf     *** Amcaf Aga Notation Off
    
    dload   a2
    move.w  #8,O_AgaColor(a2)
    rts

    Lib_Par      BestPen1      *** =Best Pen(rgb)
    
    move.l  ScOnAd(a5),a0
    move.w  EcNPlan(a0),d0
    moveq.l #1,d1
    lsl.w   d0,d1
    subq.l  #1,d1
    clr.l   -(a3)
    move.l  d1,-(a3)
    Rbra    L_BestPen3

    Lib_Par      BestPen3      *** =Best Pen(rgb,c1 To c2)
    
    move.l  (a3)+,d7
    Rbmi    L_IFonc32
    cmp.w   #63,d7
    Rbhi    L_IFonc32
    move.l  (a3)+,d6
    Rbmi    L_IFonc32
    cmp.w   #63,d6
    Rbhi    L_IFonc32
    sub.l   d6,d7
    Rbmi.s  L_IFonc32
    move.l  ScOnAd(a5),a0
    lea EcPal-4(a0),a0
    add.l   d6,a0
    add.l   d6,a0
    move.l  (a3)+,d5
    moveq.l #0,d3
    move.l  #1000,d4
    lea .coltab(pc),a2
.loop   movem.l d5-d7,-(sp)
    move.w  (a0)+,d0
    cmp.w   #31,d6
    bls.s   .noehb
    move.w  -66(a0),d0
    and.w   #$EEE,d0
    lsr.w   #1,d0
.noehb  cmp.w   d0,d5
    bne.s   .noequ
    movem.l (sp)+,d5-d7
    move.l  d6,d3
    moveq.l #0,d2
    rts 
.noequ  move.w  d0,d1
    move.w  d0,d2
    and.w   #$F00,d0
    move.w  d5,d6
    and.w   #$0F0,d1
    move.w  d5,d7
    and.w   #$00F,d2
    lsr.w   #8,d0
    and.w   #$F00,d5
    lsr.w   #4,d1
    and.w   #$0F0,d6
    lsr.w   #8,d5
    and.w   #$00F,d7
    lsr.w   #4,d6
    sub.w   d0,d5
    bpl.s   .nosgn1
    neg.w   d5
.nosgn1 sub.w   d1,d6
    bpl.s   .nosgn2
    neg.w   d6
.nosgn2 sub.w   d2,d7
    bpl.s   .nosgn3
    neg.w   d7
.nosgn3 moveq.l #0,d0
    move.b  (a2,d5.w),d0
    move.b  (a2,d6.w),d1
    ext.w   d1
    add.w   d1,d0
    move.b  (a2,d7.w),d1
    ext.w   d1
    add.w   d1,d0
    movem.l (sp)+,d5-d7
    cmp.w   d0,d4
    blt.s   .nogood
    move.w  d0,d4
    move.w  d6,d3
.nogood addq.l  #1,d6
    dbra    d7,.loop
    moveq.l #0,d2
    rts
.coltab dc.b    0,1,3,5,8,12,16,20,30,40,50,60,70,80,90,100
    

    Lib_Par      MixColor2     *** =Mix Colour(rgb1,rgb2)
    
    moveq.l #4,d3
    moveq.l #$F,d7
    move.l  (a3)+,d2
    move.w  d2,d1
    and.w   d7,d2
    lsr.w   d3,d1
    move.w  d1,d0
    and.w   d7,d1
    lsr.w   d3,d0
    move.l  (a3)+,d6
    move.w  d6,d5
    and.w   d7,d6
    lsr.w   d3,d5
    move.w  d5,d4
    and.w   d7,d5
    lsr.w   d3,d4
    add.b   d0,d4
    add.b   d1,d5
    add.b   d2,d6
    lsr.w   d4
    lsr.w   d5
    lsr.w   d6
    move.w  d6,d3
    lsl.w   #4,d5
    or.w    d5,d3
    lsl.w   #8,d4
    or.w    d4,d3
    moveq.l #0,d2
    rts

    Lib_Par      MixColor4     *** =Mix Colour(rgb1,rgb2,lrgb To urgb)
    
    moveq.l #4,d3
    moveq.l #$F,d7
    move.l  12(a3),d6
    move.w  d6,d5
    and.w   d7,d6
    lsr.w   d3,d5
    move.w  d5,d4
    and.w   d7,d5
    lsr.w   d3,d4
    move.l  8(a3),d2
    bmi.s   .minus
    move.w  d2,d1
    and.w   d7,d2
    lsr.w   d3,d1
    move.w  d1,d0
    and.w   d7,d1
    lsr.w   d3,d0
    add.w   d0,d4
    add.w   d1,d5
    add.w   d2,d6
    move.l  (a3),d2
    move.w  d2,d1
    and.w   d7,d2
    lsr.w   d3,d1
    move.w  d1,d0
    and.w   d7,d1
    lsr.w   d3,d0
    cmp.w   d0,d4
    blt.s   .lower1
    move.w  d0,d4
.lower1 cmp.w   d1,d5
    blt.s   .lower2
    move.w  d1,d5
.lower2 cmp.w   d2,d6
    blt.s   .lower3
    move.w  d2,d6
.lower3 move.w  d6,d3
    lsl.w   #4,d5
    or.w    d5,d3
    lsl.w   #8,d4
    or.w    d4,d3
    lea 16(a3),a3
    moveq.l #0,d2
    rts
.minus  neg.l   d2
    move.w  d2,d1
    and.w   d7,d2
    lsr.w   d3,d1
    move.w  d1,d0
    and.w   d7,d1
    lsr.w   d3,d0
    sub.w   d0,d4
    sub.w   d1,d5
    sub.w   d2,d6
    move.l  4(a3),d2
    move.w  d2,d1
    and.w   d7,d2
    lsr.w   d3,d1
    move.w  d1,d0
    and.w   d7,d1
    lsr.w   d3,d0
    cmp.w   d0,d4
    bge.s   .highe1
    move.w  d0,d4
.highe1 cmp.w   d1,d5
    bge.s   .highe2
    move.w  d1,d5
.highe2 cmp.w   d2,d6
    bge.s   .highe3
    move.w  d2,d6
.highe3 move.w  d6,d3
    lsl.w   #4,d5
    or.w    d5,d3
    lsl.w   #8,d4
    or.w    d4,d3
    lea 16(a3),a3
    moveq.l #0,d2
    rts

    Lib_Par      GlueColor     *** =Glue Colour(r,g,b)
    
    move.l  (a3)+,d3
    move.l  (a3)+,d4
    move.l  (a3)+,d5
    moveq.l #15,d0
    and.w   d0,d3
    and.b   d0,d4
    and.w   d0,d5
    lsl.b   #4,d4
    lsl.w   #8,d5
    or.b    d4,d3
    or.w    d5,d3
    moveq.l #0,d2
    rts

    Lib_Par      RedValue      *** =Red Val(rgb/rrggbb)
    
    move.l  (a3)+,d3
    moveq.l #0,d2
    dload   a2
    move.w  O_AgaColor(a2),d0
    cmp.w   #4,d0
    bne.s   .aga
    lsl.l   #8,d3
    move.w  d2,d3
    swap    d3
    rts
.aga    move.w  d2,d3
    swap    d3
    rts

    Lib_Par      GreenValue        *** =Green Val(rgb/rrggbb)
    
    move.l  (a3)+,d3
    moveq.l #0,d2
    dload   a2
    move.w  O_AgaColor(a2),d0
    cmp.w   #4,d0
    bne.s   .aga
    lsr.l   #4,d3
    and.l   #%1111,d3
    rts
.aga    lsr.l   #8,d3
    and.l   #$FF,d3
    rts

    Lib_Par      BlueValue     *** =Blue Val(rgb/rrggbb)
    
    move.l  (a3)+,d3
    moveq.l #0,d2
    dload   a2
    move.w  O_AgaColor(a2),d0
    cmp.w   #4,d0
    bne.s   .aga
    and.l   #%1111,d3
    rts
.aga    and.l   #$FF,d3
    rts

    Lib_Par      AgaToOldRGB       *** =Rrggbb To Rgb(rrggbb)
    
    move.l  (a3)+,d3        ;RRGGBB
    lsr.l   #4,d3           ;0RRGGB
    move.l  d3,d1
    and.l   #$F,d3          ;00000B
    lsr.l   #4,d1           ;00RRGG
    move.w  d1,d2
    and.w   #$F0,d1         ;0000G0
    lsr.w   #4,d2           ;000RRG
    and.w   #$F00,d2        ;000R00
    or.w    d1,d3           ;0000GB
    or.w    d2,d3           ;000RGB
    moveq.l #0,d2
    rts

    Lib_Par      OldToAgaRGB       *** =Rgb To Rrggbb(rgb)
    
    move.l  (a3)+,d0
    moveq.l #0,d1
    and.l   #$FFF,d0
    move.l  d0,d2
    and.w   #$F00,d2
    lsl.l   #4,d2
    lsl.l   #8,d2
    or.l    d2,d1
    move.l  d0,d2
    and.w   #$F0,d2
    lsl.l   #8,d2
    or.l    d2,d1
    move.l  d0,d2
    and.w   #$F,d2
    lsl.l   #4,d2
    or.l    d2,d1
    move.l  d1,d0
    move.l  d0,d3
    moveq.l #0,d2
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
;;    include "Amcaf/Coords.asm"
    Lib_Par      CountPixels       *** =Count Pixels s,c,x1,y1 To x2,y2
    
    lea -16(sp),sp
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a1
    sub.w   d4,d6
    Rbeq    L_IFonc
    Rbmi    L_IFonc
    sub.w   d5,d7
    Rbeq    L_IFonc
    Rbmi    L_IFonc
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a1),d4
    subq.b  #1,d4
    move.w  EcTx(a1),d0
    lsr.w   #3,d0
    mulu    d0,d5
    moveq.l #0,d3
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  movem.w d0-d1/d4-d5,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.l   d2,d5
    not.b   d1
    moveq.l #0,d2
    moveq.l #0,d0
    move.l  a1,a2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.l)
    beq.s   .skip
    bset    d2,d0
.skip   addq.b  #1,d2
    dbra    d4,.gloop
    cmp.b   10(sp),d0
    beq.s   .quit
    addq.l  #1,d3
.quit   movem.w (sp)+,d0-d1/d4-d5
    addq.w  #1,d1
    dbra    d6,.xloop
    add.l   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    moveq.l #0,d2
    rts

    Lib_Par      CoordsBankSet     *** Coords Bank bank
    
    dload   a2
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,O_CoordsBank(a2)
    rts

    Lib_Par      CoordsBank        *** Coords Bank bank,coords
    
    dload   a2
    move.l  (a3)+,d2
    Rbeq    L_IFonc
    moveq.l #0,d1
    move.l  (a3)+,d0
    moveq.l #0,d4
    move.w  d2,d4
    move.l  d4,d7
    lsl.l   #2,d2
    addq.l  #8,d2
    lea .bkcoor(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,O_CoordsBank(a2)
    move.w  d7,(a0)+
    clr.w   (a0)+
    moveq.l #8,d0
    move.l  d0,(a0)
    rts
.bkcoor dc.b    'Coords  '
    even

    Lib_Par      CoordsRead        *** Coords Read s,c,x1,y1 To x2,y2,bank,mode
    
    lea -20(sp),sp
    move.l  (a3)+,d7
    move.w  d7,(sp)
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,12(sp)
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a1
    sub.w   d4,d6
    Rbeq    L_IFonc32
    Rbmi    L_IFonc32
    sub.w   d5,d7
    Rbeq    L_IFonc32
    Rbmi    L_IFonc32
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a1),d4
    subq.b  #1,d4
    move.w  EcTx(a1),d0
    lsr.w   #3,d0
    mulu    d0,d5
    moveq.l #0,d3
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  movem.w d0-d1/d4-d5,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.l   d2,d5
    not.b   d1
    moveq.l #0,d2
    moveq.l #0,d0
    move.l  a1,a2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.l)
    beq.s   .skip
    bset    d2,d0
.skip   addq.b  #1,d2
    dbra    d4,.gloop
    cmp.b   10(sp),d0
    beq.s   .quit
    movem.w (sp)+,d0-d1/d4-d5
    move.l  12(sp),a0
    cmp.w   (a0),d3
    beq.s   .overfl
    move.w  d3,d2
    addq.l  #2,d2
    lsl.l   #2,d2
    add.l   d2,a0
    move.w  d1,d2
    lsl.w   #4,d2
    move.w  d2,(a0)
    move.w  10(sp),d2
    sub.w   d7,d2
    add.w   6(sp),d2
    lsl.w   #4,d2
    move.w  d2,2(a0)
    addq.w  #1,d3
    bra.s   .quit2
.quit   movem.w (sp)+,d0-d1/d4-d5
.quit2  addq.w  #1,d1
    dbra    d6,.xloop
    add.l   d0,d5
    dbra    d7,.yloop
    move.l  12(sp),a0
    move.w  d3,(a0)
.overfl move.w  (sp),d0
    bne.s   .random
    lea 20(sp),sp
    rts
.random move.l  d3,d7
    subq.l  #1,d3
    move.l  12(sp),a0
    lea 8(a0),a2
    lea $DFF006,a1
.raloop add.w   (a1),d6
    move.w  d6,d5
    mulu    d7,d5
    swap    d5
    ext.l   d5
    lsl.l   #2,d5
    move.l  8(a0,d5.l),d0
    move.l  (a2),8(a0,d5.l)
    move.l  d0,(a2)+
    dbra    d3,.raloop
    lea 20(sp),sp
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
;;    include "Amcaf/DiskFun.asm"
    Lib_Par      UnpathFile        *** =Filename$(path$)
    
    move.l  (a3)+,a0
    move.w  (a0)+,d1
    move.l  a0,-(sp)
    moveq.w #0,d2
    moveq.w #1,d3
    move.w  d1,d4
    beq.s   .skip
    subq.w  #1,d1
.loop   move.b  (a0)+,d0
    cmp.b   #':',d0
    bne.s   .nodev
    move.w  d3,d2
.nodev  cmp.b   #'/',d0
    bne.s   .nopath
    move.w  d3,d2
.nopath addq.w  #1,d3
    dbra    d1,.loop
    sub.w   d2,d4
.skip   move.w  d2,d7
    move.w  d4,d3
    
    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.l  (sp)+,a1
    add.w   d7,a1
    move.w  d4,(a0)+
    beq.s   .skip2
    subq.w  #1,d4
.loop2  move.b  (a1)+,(a0)+
    dbra    d4,.loop2
.skip2  moveq.l #2,d2
    rts

    Lib_Par      GivePath      *** =Path$(path$)
    
    move.l  (a3)+,a0
    move.w  (a0)+,d1
    move.l  a0,a2
    moveq.w #0,d2
    moveq.w #1,d3
    move.w  d1,d4
    beq.s   .skip
    subq.w  #1,d1
.loop   move.b  (a0)+,d0
    cmp.b   #':',d0
    bne.s   .nodev
    move.w  d3,d2
.nodev  cmp.b   #'/',d0
    bne.s   .nopath
    move.w  d3,d2
    subq.w  #1,d2
.nopath addq.w  #1,d3
    dbra    d1,.loop
.skip   move.w  d2,d7
    move.w  d2,d3

    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.w  d7,(a0)+
    beq.s   .skip2
    subq.w  #1,d7
.loop2  move.b  (a2)+,(a0)+
    dbra    d7,.loop2
.skip2  moveq.l #2,d2
    rts

    Lib_Par      ExtendPath        *** =Extpath$(path$)
    
    move.l  (a3)+,a2
    moveq.l #0,d3
    move.w  (a2)+,d3
    beq.s   .noext
    cmp.b   #'/',-1(a2,d3.w)
    beq.s   .noext
    cmp.b   #':',-1(a2,d3.w)
    beq.s   .noext

    move.w  d3,d4

    addq.w  #3,d3
    and.w   #$FFFE,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    addq.w  #1,d4
    move.w  d4,(a0)+
    subq.w  #2,d4
.loop   move.b  (a2)+,(a0)+
    dbra    d4,.loop
    move.b  #'/',(a0)+
    moveq.l #2,d2
    rts
.noext  move.w  d3,d4

    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.w  d4,(a0)+
    beq.s   .skip
    subq.w  #1,d4
.loop2  move.b  (a2)+,(a0)+
    dbra    d4,.loop2
.skip   move.l  a0,d0
    addq.l  #1,d0
    and.b   #$FE,d0
    move.l  d0,HiChaine(a5)
    moveq.l #2,d2
    rts

    Lib_Par      DOSHash       *** =Dos Hash(string$)
    
    move.l  (a3)+,a0
    moveq.l #0,d3
    move.w  (a0)+,d3
    move.w  d3,d7
.hloop  moveq.l #0,d2
    move.b  (a0)+,d2
    dbra    d7,.conhas
    divu    #72,d3
    moveq.l #0,d2
    move.w  d2,d3
    swap    d3
    rts
.conhas mulu    #13,d3
    cmp.b   #'a',d2
    blo.s   .hskip
    cmp.b   #'z',d2
    bhi.s   .hskip
    sub.b   #32,d2
.hskip  add.l   d2,d3
    and.l   #$7ff,d3
    bra.s   .hloop

    Lib_Par      DiskType      *** =Disk Type(device$)
    
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a0,a1
.tloop  move.b  (a1)+,d0
    Rbeq    L_IFonc
    cmp.b   #':',d0
    bne.s   .tloop
    clr.b   (a1)
    move.l  DosBase(a5),a1
    move.l  34(a1),a1
    move.l  24(a1),a1
    add.l   a1,a1
    add.l   a1,a1
    move.l  4(a1),a1
    add.l   a1,a1
    add.l   a1,a1
    move.l  a0,d7
.nexdev move.l  40(a1),a2
    add.l   a2,a2
    add.l   a2,a2
    move.b  (a2)+,d2
    ext.w   d2
    subq.w  #1,d2
.loop   move.l  d7,a0
.strcmp move.b  (a0)+,d0
    beq.s   .notfou
    move.b  (a2)+,d1
    bclr    #5,d1
    bclr    #5,d0
    cmp.b   d1,d0
    bne.s   .notfou
    dbra    d2,.strcmp
    cmp.b   #':',(a0)+
    bne.s   .notfou
    move.l  4(a1),d3
    moveq.l #0,d2
    rts
.notfou move.l  (a1),d0
    Rbeq    L_IFNoFou
    add.l   d0,d0
    add.l   d0,d0
    move.l  d0,a1
    bra.s   .nexdev

    Lib_Par      DiskStatus        *** =Disk State(device$)
    
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a0,a1
.tloop  move.b  (a1)+,d0
    Rbeq    L_IFonc
    cmp.b   #':',d0
    bne.s   .tloop
    move.l  a0,d1
    moveq.l #-2,d2
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVOLock(a6)
    move.l  d7,a6
    move.l  d0,d6
    Rbeq    L_IFNoFou
    move.l  d0,d1
    dload   a2
    lea O_TempBuffer(a2),a2
    move.l  a2,d2
    move.l  DosBase(a5),a6
    jsr _LVOInfo(a6)
    move.l  d0,d5
    move.l  d6,d1
    jsr _LVOUnLock(a6)
    move.l  d7,a6
    tst.l   d5
    Rbeq    L_IIOError
    moveq.l #0,d2
    move.l  24(a2),d0
    moveq.l #-1,d1
    cmp.l   d1,d0
    bne.s   .diskid
    moveq.l #-1,d3
    rts
.diskid move.l  8(a2),d0
    moveq.l #0,d3
    cmp.b   #82,d0
    beq.s   .diskok
    moveq.l #1,d3
.diskok tst.l   32(a2)
    beq.s   .notinu
    addq.l  #2,d3
.notinu rts

    Lib_Par      PatternMatch      *** =Pattern(sourcestring$,pattern$)
    
    Rbsr    L_CheckOS2
    dload   a2
    move.l  (a3)+,a0
    lea O_TempBuffer(a2),a1
    move.l  a1,d1
    move.w  (a0)+,d0
    bne.s   .nempty
    move.w  #'#?',(a1)+
    bra.s   .cont
.nempty subq.w  #1,d0
.cloop  move.b  (a0)+,d6
    cmp.b   #'*',d6
    bne.s   .noast
    move.b  #'#',(a1)+
    moveq.b #'?',d6
.noast  move.b  d6,(a1)+
    dbra    d0,.cloop
.cont   clr.b   (a1)
    lea O_ParseBuffer(a2),a0
    move.l  a0,d2
    moveq.l #64,d3
    lsl.w   #3,d3
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVOParsePatternNoCase(a6)
    move.l  d7,a6
    moveq.l #-1,d1
    cmp.l   d1,d0
    Rbeq    L_IFonc
    move.l  (a3)+,a0
    lea O_TempBuffer(a2),a1
    move.l  a1,d2
    move.w  (a0)+,d0
    beq.s   .empty2
.cloop2 move.b  (a0)+,(a1)+
    dbra    d0,.cloop2
.empty2 clr.b   (a1)
    lea O_ParseBuffer(a2),a0
    move.l  a0,d1
    move.l  DosBase(a5),a6
    jsr _LVOMatchPatternNoCase(a6)
    move.l  d7,a6
    move.l  d0,d3
    moveq.l #0,d2
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
;;    include "Amcaf/Dload.asm"
    Lib_Par      DLoad         *** Dload name$,bank
    
    move.l  (a3)+,d5        ;bank
    move.l  (a3)+,a0
    Rbsr    L_OpenFile
    bne.s   .good
    Rbra    L_IFNoFou
.good   move.l  d1,d7
    Rbsr    L_LengthOfFile
    move.l  d0,d6
    moveq   #(1<<Bnk_BitData),d1    ;Flags
    move.l  d5,d0           ;Number
    bpl.s   .nochip
    not.l   d0
    addq.w  #1,d0
    addq.w  #(1<<Bnk_BitChip),d1
.nochip
    lea .Bkdata(pc),a0
    move.l  d6,d2           ;Length
    Rjsr    L_Bnk.Reserve
    beq.s   .mem
    move.l  d7,d1
    move.l  d6,d0
    Rbsr    L_ReadFile
    beq.s   .noerr
    Rbsr    L_CloseFile
    Rbra    L_IIOError
.noerr  Rbsr    L_CloseFile
    rts
.mem    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbra    L_IOoMem
.Bkdata dc.b    'Datas   '
    even

    Lib_Par      WLoad         *** Wload name$,bank
    
    move.l  (a3)+,d5        ;bank
    move.l  (a3)+,a0
    Rbsr    L_OpenFile
    bne.s   .good
    Rbra    L_IFNoFou
.good   move.l  d1,d7
    Rbsr    L_LengthOfFile
    move.l  d0,d6
    moveq   #0,d1           ;Flags
    move.l  d5,d0           ;Number
    bpl.s   .nochip
    neg.w   d0
    addq.w  #(1<<Bnk_BitChip),d1
.nochip
    lea .Bkwork(pc),a0
    move.l  d6,d2           ;Length
    Rjsr    L_Bnk.Reserve
    beq.s   .mem
    move.l  d7,d1
    move.l  d6,d0
    Rbsr    L_ReadFile
    beq.s   .noerr
    Rbsr    L_CloseFile
    Rbra    L_IIOError
.noerr  Rbsr    L_CloseFile
    rts
.mem    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbra    L_IOoMem
.Bkwork dc.b    'Work    '
    even

    Lib_Par      WSave         *** Wsave name$,bank
    
    move.l  (a3)+,d0        ;bank
    Rjsr    L_Bnk.OrAdr
    move.l  d0,d6
    move.w  -12(a0),d0
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom
.noicon move.l  (a3)+,a0
    Rbsr    L_OpenFileW
    bne.s   .good
    Rbra    L_IIOError
.good   move.l  d6,a0
    move.l  -20(a0),d0
    subq.l  #8,d0
    subq.l  #8,d0
    Rbsr    L_WriteFile
    beq.s   .noerr
    Rbsr    L_CloseFile
    Rbra    L_IIOError
.noerr  Rbsr    L_CloseFile
    rts

    Lib_Par      SLoad         *** SLoad filehandle To address,length
    
    move.l  (a3)+,d3
    Rbmi    L_IFonc
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a0
    move.l  (a3)+,d0
    cmp.l   #10,d0
    Rbcc    L_IFonc
    subq.l  #1,d0
    Rbmi    L_IFonc
    mulu    #TFiche,d0
    lea Fichiers(a5),a2
    add.w   d0,a2
    move.l  FhA(a2),d1
    Rbeq    L_IFonc
    move.l  d3,d0
    Rbsr    L_ReadFile
    rts

    Lib_Par      SSave         *** SSave filehandle,address To length
    
    move.l  (a3)+,d3
    Rbmi    L_IFonc
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a0
    sub.l   d0,d3
    move.l  (a3)+,d0
    cmp.l   #10,d0
    Rbcc    L_IFonc
    subq.l  #1,d0
    Rbmi    L_IFonc
    mulu    #TFiche,d0
    lea Fichiers(a5),a2
    add.w   d0,a2
    move.l  FhA(a2),d1
    Rbeq    L_IFonc
    move.l  d3,d0
    Rbsr    L_WriteFile
    rts

    Lib_Par      FCopy         *** File Copy source$ To target$
    
    dload   a2
    move.l  (a3)+,d4
    move.l  (a3)+,a0
    Rbsr    L_OpenFile
    bne.s   .good
    Rbra    L_IFNoFou
.good   move.l  d1,d7
    Rbsr    L_LengthOfFile
    move.l  d0,d6
    bne.s   .plusle
    Rbsr    L_CloseFile
    move.l  d4,a0
    Rbsr    L_OpenFileW
    bne.s   .good2
    Rbra    L_IFNoFou
.good2  Rbsr    L_CloseFile
    rts
.plusle move.l  d0,d5
.nomeml move.l  d5,d0
    moveq.l #1,d1
    move.l  a6,-(sp)
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  (sp)+,a6
    move.l  d0,O_BufferAddress(a2)
    bne.s   .memok
    lsr.l   d5
    cmp.l   #10*1024,d5
    bge.s   .nomeml 
    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbra    L_IOoMem
.memok  move.l  d5,O_BufferLength(a2)
    move.l  d6,d5
    move.l  d4,a0
    Rbsr    L_OpenFileW
    bne.s   .good3
    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbsr    L_FreeExtMem
    Rbra    L_IFNoFou
.good3  move.l  d1,d6
.coplop move.l  d7,d1
    move.l  O_BufferLength(a2),d0
    cmp.l   d0,d5
    bge.s   .filok
    move.l  d5,d0
.filok  move.l  d0,d4
    move.l  O_BufferAddress(a2),a0
    Rbsr    L_ReadFile
    beq.s   .noerr
    Rbsr    L_CloseFile
    move.l  d6,d1
    Rbsr    L_CloseFile
    Rbsr    L_FreeExtMem
    Rbra    L_IIOError
.noerr  move.l  d6,d1
    Rbsr    L_WriteFile
    beq.s   .noerr2
    Rbsr    L_CloseFile
    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbsr    L_FreeExtMem
    Rbra    L_IIOError
.noerr2 sub.l   d4,d5
    bne.s   .coplop
    Rbsr    L_CloseFile
    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbsr    L_FreeExtMem
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
;;    include "Amcaf/DOSObject.asm"
    Lib_Par      ExamineDir        *** Examine Dir name$
    
    Rbsr    L_ExamineStop
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a6,d6
    move.l  a0,d1
    moveq.l #-2,d2
    move.l  DosBase(a5),a6
    jsr _LVOLock(a6)
    move.l  d6,a6
    move.l  d0,d7
    Rbeq    L_IFNoFou
    move.l  d7,d1
    dload   a2
    move.l  d7,O_DirectoryLock(a2)
    lea O_FileInfo(a2),a2
    move.l  a2,d2
    move.l  DosBase(a5),a6
    jsr _LVOExamine(a6)
    move.l  d6,a6
    tst.l   d0
    bne.s   .contin
.error  Rbsr    L_ExamineStop
    Rbra    L_IIOError
.contin tst.l   4(a2)
    bmi.s   .error
    rts

    Lib_Par      ExamineNext       *** =Examine Next$
    
    dload   a2
    move.l  O_DirectoryLock(a2),d1
    Rbeq    L_IFonc
    lea O_FileInfo(a2),a2
    move.l  a2,d2
    move.l  a6,d6
    move.l  DosBase(a5),a6
    jsr _LVOExNext(a6)
    move.l  d6,a6
    tst.l   d0
    Rbne    L_FileName0
    Rbsr    L_ExamineStop
    lea .empty(pc),a0
    move.l  a0,d3
    moveq.l #2,d2
    rts
.empty  dc.l    0

    Lib_Par      ExamineStop       *** Examine Stop
    movem.l d0-d2/a0-a2/a6,-(sp)
    dload   a2
    move.l  O_DirectoryLock(a2),d1
    beq.s   .quit
    move.l  DosBase(a5),a6
    jsr _LVOUnLock(a6)
    clr.l   O_DirectoryLock(a2)
.quit   movem.l (sp)+,d0-d2/a0-a2/a6
    rts

    Lib_Par      ExamineFile       *** Examine Object name$
    
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a6,d6
    move.l  a0,d1
    moveq.l #-2,d2
    move.l  DosBase(a5),a6
    jsr _LVOLock(a6)
    move.l  d6,a6
    move.l  d0,d7
    Rbeq    L_IFNoFou
    move.l  d7,d1
    dload   a2
    lea O_FileInfo(a2),a2
    move.l  a2,d2
    move.l  DosBase(a5),a6
    jsr DosExam(a6)
    move.l  d0,d5
    move.l  d7,d1
    jsr _LVOUnLock(a6)
    move.l  d6,a6
    tst.l   d5
    Rbeq    L_IIOError
    rts

    Lib_Par      FileName1     *** =Object Name$(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileName0

    Lib_Par      FileName0     *** =Object Name$
    
    dload   a2
    lea O_FileInfo+8(a2),a0
    moveq.l #2,d2
    Rbsr    L_MakeAMOSString
    rts

    Lib_Par      FileType1     *** =Object Type(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileType0

    Lib_Par      FileType0     *** =Object Type
    
    dload   a2
    move.l  O_FileInfo+4(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      FileLength1       *** =Object Size(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileLength0

    Lib_Par      FileLength0       *** =Object Size
    
    dload   a2
    move.l  O_FileInfo+124(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      FileBlocks1       *** =Object Blocks(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileBlocks0

    Lib_Par      FileBlocks0       *** =Object Blocks
    
    dload   a2
    move.l  O_FileInfo+128(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      FileDate1     *** =Object Date(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileDate0

    Lib_Par      FileDate0     *** =Object Date
    
    dload   a2
    move.l  O_FileInfo+132(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      FileTime1     *** =Object Time(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileTime0

    Lib_Par      FileTime0     *** =Object Time
    
    dload   a2
    lea O_FileInfo+138(a2),a0
    move.w  (a0),d3
    swap    d3
    move.w  4(a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      FileProtection1   *** =Object Protection(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileProtection0

    Lib_Par      FileProtection0   *** =Object Protection
    
    dload   a2
    move.l  O_FileInfo+116(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      ProtectionStr     *** =Object Protection$(prot)
    
    moveq.l #10,d3
    Rjsr    L_Demande
    move.l  a0,d3
    move.w  #8,(a0)+
    moveq.l #7,d0
    move.l  (a3)+,d1
    lea .flags(pc),a1
.loop   btst    d0,d1
    bne.s   .bitset
    move.b  (a1,d0.w),(a0)+
    bra.s   .cont
.bitset move.b  4(a1,d0.w),(a0)+
.cont   dbra    d0,.loop
    move.l  a0,HiChaine(a5)
    moveq.l #2,d2
    rts
.flags  dc.b    'dewr----apsh'
    even

    Lib_Par      FileComment1      *** =Object Comment$(name$)
    
    Rbsr    L_ExamineFile
    Rbra    L_FileComment0

    Lib_Par      FileComment0      *** =Object Comment$
    
    dload   a2
    lea O_FileInfo+144(a2),a0
    moveq.l #2,d2
    Rbra    L_MakeAMOSString

    Lib_Par      SetProtection     *** Protect Object name$,mask
    
    move.l  (a3)+,d2
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a0,d1
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVOSetProtection(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IFNoFou
    rts

    Lib_Par      SetComment        *** Set Object Comment name$,comment$
    
    dload   a2
    move.l  (a3)+,a0
    lea O_TempBuffer(a2),a1
    move.l  a1,d2
    move.w  (a0)+,d0
    beq.s   .skip
    subq.w  #1,d0
.loop   move.b  (a0)+,(a1)+
    dbra    d0,.loop
.skip   clr.b   (a1)
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a0,d1
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVOSetComment(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IFNoFou
    rts

    Lib_Par      SetObjectDate     *** Set Object Date file$,date,time 
    
    Rbsr    L_CheckOS2
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_DateStamp+10(a2)
    swap    d0
    move.w  d0,O_DateStamp+6(a2)
    move.l  (a3)+,O_DateStamp(a2)
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a0,d1
    move.l  a6,d7
    lea O_DateStamp(a2),a0
    move.l  a0,d2
    move.l  DosBase(a5),a6
    jsr _LVOSetFileDate(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IFNoFou
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
;;    include "Amcaf/Ext.asm"
    Lib_Par      ExtDataBase       *** =Extbase(extnb)
    
    move.l  (a3)+,d0
    subq.l  #1,d0
    Rbmi    L_IFonc
    moveq.l #26,d1
    cmp.l   d1,d0
    Rbge    L_IFonc
    lsl.w   #4,d0
    moveq.l #0,d2
    lea ExtAdr(a5),a0
    move.l  (a0,d0.w),d3
    rts

    Lib_Par      DefCall       *** Extdefault ext
    
    move.l  (a3)+,d0
    subq.l  #1,d0
    Rbmi    L_IFonc
    moveq.l #26,d1
    cmp.l   d1,d0
    Rbge    L_IFonc
    lsl.w   #4,d0
    moveq.l #0,d2
    lea ExtAdr(a5),a0
    move.l  4(a0,d0.w),a1
    move.l  a1,d0
    beq.s   .skip
    movem.l a3-a6,-(sp)
    jsr (a1)
    movem.l (sp)+,a3-a6
.skip   rts

    Lib_Par      ExtRemove     *** Extremove ext
    
    move.l  (a3)+,d0
    subq.l  #1,d0
    Rbmi    L_IFonc
    moveq.l #26,d1
    cmp.l   d1,d0
    Rbge    L_IFonc
    lsl.w   #4,d0
    moveq.l #0,d2
    lea ExtAdr(a5),a0
    move.l  8(a0,d0.w),a1
    clr.l   8(a0,d0.w)
    move.l  a1,d0
    beq.s   .skip
    movem.l a3-a6,-(sp)
    jsr (a1)
    movem.l (sp)+,a3-a6
.skip   rts

    Lib_Par      ExtReinit     *** Extreinit ext
    
    move.l  (a3)+,d0
    subq.l  #1,d0
    Rbmi    L_IFonc
    moveq.l #26,d1
    cmp.l   d1,d0
    Rbge    L_IFonc
    lsl.w   #2,d0
    moveq.l #0,d2
    lea AdTokens(a5),a0
    move.l  4(a0,d0.w),a1
    move.l  a1,d0
    bne.s   .tokens
    rts
.tokens move.w  (a1)+,d0
    beq.s   .endtok
    addq.l  #2,a1
.nexchr move.b  (a1)+,d0
    cmp.b   #$F6,d0
    bcs.s   .nexchr
    move.l  a1,d0
    addq.l  #1,d0
    and.b   #$FE,d0
    move.l  d0,a1
    bra.s   .tokens
.notend addq.l  #2,a1
.endtok move.w  (a1),d0
    beq.s   .notend
    move.l  #'APex',d1
    movem.l a3-a6,-(sp)
    jsr (a1)
    movem.l (sp)+,a3-a6
    moveq.l #-1,d1
    cmp.l   d1,d0
    bne.s   .noerr
    moveq.l #14,d0
    Rbra    L_Custom
.noerr  rts
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
;;    include "Amcaf/FImp.asm"
    Lib_Par      FImpUnpack        *** Imploder Unpack sbank To tbank
    
    move.l  (a3)+,d5
    move.l  (a3)+,d0
    cmp.l   d0,d5
    Rbeq.s  L_IFonc
    Rjsr    L_Bnk.OrAdr
    cmp.l   d0,d5
    Rbeq.s  L_IFonc
.noicon move.l  a0,d7
    cmp.l   #'IMP!',(a0)+
    beq.s   .noerr
    moveq.l #2,d0
    Rbra    L_Custom
.noerr  move.l  (a0)+,d2
    moveq.l #0,d1
    move.l  d5,d0
    bpl.s   .nochip
    neg.l   d0
    moveq.l #(1<<Bnk_BitChip),d1
.nochip lea .bkwork(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,a1
    move.l  d7,a2
    move.l  8(a2),d0
    moveq.l #51,d3
    add.l   d3,d0
    lsr #1,d0
    move.l  d0,d1
    swap    d1
.coloop move.w  (a2)+,(a1)+
    dbra    d0,.coloop
    dbra    d1,.coloop
    Rbra    L_FImp
.bkwork dc.b    'Work    '

    Lib_Par      ImploderLoad      *** Imploder Load file$,tbank
    
    dload   a2
    Rbsr    L_FreeExtMem
    move.l  4(a3),a0
    Rbsr    L_OpenFile
    Rbeq    L_IFNoFou
    move.l  d1,d7
    Rbsr    L_LengthOfFile
    lea .minibu(pc),a0
    moveq.l #12,d0
    Rbsr    L_ReadFile
    beq.s   .norerr
.rerr   Rbsr    L_CloseFile
    Rbra    L_IIOError
.norerr cmp.l   #'IMP!',(a0)
    beq.s   .imfou
    cmp.l   #'PP20',(a0)
    beq.s   .ppfou
    Rbsr    L_CloseFile
    Rbra    L_WLoad
.ppfou  Rbsr    L_CloseFile
    Rbra    L_PPLoad
.imfou  move.l  .orglen(pc),d2
    moveq.l #0,d1
    move.l  (a3)+,d0
    bpl.s   .nochip
    neg.l   d0
    moveq.l #(1<<Bnk_BitChip),d1
.nochip addq.l  #4,a3
    lea .bkwork(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,a2
    lea .minibu(pc),a1
    move.l  (a1)+,(a0)+
    move.l  (a1)+,(a0)+
    move.l  (a1)+,d0
    move.l  d0,(a0)+
    move.l  d7,d1
    move.l  .pkdlen(pc),d0
    moveq.l #38,d2
    add.l   d2,d0
    Rbsr    L_ReadFile
    bne.s   .rerr
    Rbsr    L_CloseFile
    move.l  a2,a0
    Rbra    L_FImp
.minibu dc.l    0   ;'IMP!'
.orglen dc.l    0
.pkdlen dc.l    0
.bkwork dc.b    'Work    '
    even
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
;;    include "Amcaf/Font.asm"
    Lib_Par      MakeBankFont          *** Make Bank Font bank
    
    move.l  ScOnAd(a5),a0
    move.l  Ec_RastPort(a0),a0
    move.l  52(a0),a2
    move.w  20(a2),d7
    mulu    38(a2),d7
    moveq.l #0,d6
    move.b  33(a2),d6
    sub.b   32(a2),d6
    addq.w  #2,d6
    add.w   d6,d6
    moveq.l #24+52+30,d5
    add.l   d7,d5
    add.l   d6,d5
    add.l   d6,d5
    tst.l   44(a2)
    beq.s   .nospc
    add.l   d6,d5
.nospc  tst.l   48(a2)
    beq.s   .nokern
    add.l   d6,d5
.nokern move.l  (a3)+,d0
    moveq.l #3,d1
    move.l  d5,d2
    lea .bkfont(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,a1
    move.l  a0,d5
    move.l  #'FONT',(a1)+
    clr.l   (a1)+
    moveq.l #52+24+30,d0
    move.l  d0,(a1)+
    add.l   d7,d0
    move.l  d0,(a1)+
    add.l   d6,d0
    add.l   d6,d0
    tst.l   44(a2)
    beq.s   .nospc2
    move.l  d0,(a1)+
    add.l   d6,d0
    bra.s   .cont1
.nospc2 clr.l   (a1)+
.cont1  tst.l   48(a2)
    beq.s   .nokrn2
    move.l  d0,(a1)+
    bra.s   .cont2
.nokrn2 clr.l   (a1)+
.cont2  moveq.l #12,d0
    move.l  a2,a0
.loop1  move.l  (a0)+,(a1)+
    dbra    d0,.loop1
    move.l  10(a2),a0
    moveq.l #14,d0
.loop0  move.w  (a0)+,(a1)+
    dbra    d0,.loop0
;   move.l  d5,a1
;   add.l   8(a1),a1
    move.l  34(a2),a0
    move.l  d7,d0
    lsr.l   #1,d0
    subq.l  #1,d0
    move.l  d0,d1
    swap    d1
.loop2  move.w  (a0)+,(a1)+
    dbra    d0,.loop2
    dbra    d1,.loop2
;   move.l  d5,a1
;   add.l   12(a1),a1
    move.l  40(a2),a0
    move.w  d6,d0
    subq.w  #1,d0
.loop3  move.w  (a0)+,(a1)+
    dbra    d0,.loop3
    move.l  44(a2),d0
    beq.s   .nospc3
;   move.l  d5,a1
;   add.l   16(a1),a1
    move.l  d0,a0
    move.w  d6,d0
    lsr.w   #1,d0
    subq.w  #1,d0
.loop4  move.w  (a0)+,(a1)+
    dbra    d0,.loop4
.nospc3 move.l  48(a2),d0
    beq.s   .nokrn3
;   move.l  d5,a1
;   add.l   20(a1),a1
    move.l  d0,a0
    move.w  d6,d0
    lsr.w   #1,d0
    subq.w  #1,d0
.loop5  move.w  (a0)+,(a1)+
    dbra    d0,.loop5
.nokrn3 move.l  d5,a0
    move.w  #9999,24+30(a0)
    rts
.bkfont dc.b    'BankFont'
    even

    Lib_Par      ChangeBankFont    *** Change Bank Font bank
    
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    cmp.l   #'FONT',(a0)
    Rbne    L_IFonc
    and.b   #%01111101,24+23(a0)
    or.b    #%00000001,24+23(a0)
    clr.l   24+0(a0)
    clr.l   24+4(a0)
    clr.l   24+14(a0)
    moveq.l #24+52,d0
    add.l   a0,d0
    move.l  d0,24+10(a0)
    move.l  8(a0),d0
    add.l   a0,d0
    move.l  d0,24+34(a0)
    move.l  12(a0),d0
    add.l   a0,d0
    move.l  d0,24+40(a0)
    move.l  16(a0),d0
    beq.s   .nospc
    add.l   a0,d0
    move.l  d0,24+44(a0)
    bra.s   .cont1
.nospc  clr.l   24+44(a0)
.cont1  move.l  20(a0),d0
    beq.s   .nokern
    add.l   a0,d0
    move.l  d0,24+48(a0)
.nokern clr.l   24+48(a0)
.cont2  move.l  a0,d6
    lea 24(a0),a0
    move.l  ScOnAd(a5),a1
    move.l  Ec_RastPort(a1),a1
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVOSetFont(a6)
    move.l  d7,a6
;   rts
    move.l  d6,a0
    move.l  ScOnAd(a5),a1
    move.l  Ec_RastPort(a1),a1
    move.l  52(a1),a1
    move.l  20(a0),d0
    beq.s   .ende
    add.l   d0,a0
    move.l  a0,48(a1)
.ende   rts

    Lib_Par      ChangePrintFont   *** Change Print Font bank
    
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  ScOnAd(a5),a1
    move.l  EcWindow(a1),a1
    move.l  a0,WiFont(a1)
    rts

    Lib_Par      ChangeFont1       *** Change Font font$
    
    moveq.l #8,d0
    move.l  d0,-(a3)
    Rbra    L_ChangeFont2

    Lib_Par      ChangeFont2       *** Change Font font$,height
    
    clr.l   -(a3)
    Rbra    L_ChangeFont3

    Lib_Par      ChangeFont3       *** Change Font font$,height,style
    
    dload   a2
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_RastPort(a1),a1
    move.l  52(a1),a1
    move.l  a6,d6
    move.l  T_GfxBase(a5),a6
    jsr -78(a6)
    move.l  d6,a6
    lea O_FontTextAttr(a2),a0
    move.l  (a3)+,d0
    move.b  d0,6(a0)
    move.l  (a3)+,d0
    move.w  d0,4(a0)
    move.b  #2,7(a0)
    lea O_TempBuffer(a2),a1
    move.l  a1,(a0)
    move.l  (a3)+,a0
    move.w  (a0)+,d3
    subq.w  #1,d3
.coplop move.b  (a0)+,(a1)+
    dbra    d3,.coplop
    cmp.b   #'.',-5(a1)
    beq.s   .skip
    move.b  #'.',(a1)+
    move.b  #'f',(a1)+
    move.b  #'o',(a1)+
    move.b  #'n',(a1)+
    move.b  #'t',(a1)+
.skip   clr.b   (a1)
    move.l  a6,d6
    move.l  O_DiskFontLib(a2),d0
    bne.s   .alrdop
    move.l  4.w,a6
    lea .dsknam(pc),a1
    moveq.l #0,d0
    jsr _LVOOpenLibrary(a6)
    move.l  d0,O_DiskFontLib(a2)
    bne.s   .alrdop
    move.l  d6,a6
    moveq.l #9,d0
    Rbra    L_Custom
.alrdop move.l  d0,a6
    lea O_FontTextAttr(a2),a0
    jsr _LVOOpenDiskFont(a6)
    move.l  d6,a6
    tst.l   d0
    bne.s   .allok
    moveq.l #10,d0
    Rbra    L_Custom
.allok  move.l  d0,a0
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_RastPort(a1),a1
    move.l  T_GfxBase(a5),a6
    jsr _LVOSetFont(a6)
    move.l  d6,a6
    rts
.dsknam dc.b    'diskfont.library',0
    even

    Lib_Par      FontStyle     *** =Font Style
    
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_RastPort(a1),a1
    move.l  52(a1),a1
    moveq.l #0,d3
    move.b  23(a1),d3
    moveq.l #0,d2
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
    Lib_Par      KalmsC2P32
    Rbra    L_KalmsC2P

    Lib_Par      Custom32
    IFNE    demover
    moveq.l #0,d0
    ENDC
    Rbra    L_Custom

    Lib_Par      IFonc32
    Rbra    L_IFonc

    Lib_Par      IOoMem32
    Rbra    L_IOoMem

    Lib_Par      Precalc32
    Rbra    L_PrecalcTables

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
;;    include "Amcaf/Ham.asm"
    Lib_Par      HamPoint      *** =Ham Point(x,y)
    
    move.l  ScOnAd(a5),a1
    lea EcPal-4(a1),a0
    move.l  (a3)+,d7
    bmi.s   .backgr
    cmp.w   EcTy(a1),d7
    bge.s   .backgr
    move.l  (a3)+,d6
    bmi.s   .backg2
    move.w  EcTx(a1),d5
    cmp.w   d5,d6
    bge.s   .backg2
    bra.s   .nbackg
.backgr addq.l  #4,a3
.backg2 moveq.l #0,d3
    move.w  (a0),d3
    moveq.l #0,d2
    rts
.nbackg moveq.l #0,d0
    movem.l a3-a6,-(sp)
    lsr.w   #3,d5
    move.l  4(a1),a2
    move.l  8(a1),a3
    move.l  12(a1),a4
    move.l  16(a1),a5
    move.l  20(a1),a6
    move.l  (a1),a1
    mulu    d5,d7
    moveq.l #0,d3
.maloop move.l  d6,d4
    lsr.w   #3,d4
    add.l   d7,d4
    move.w  d6,d5
    and.w   #$7,d5
    not.w   d5
    btst    d5,(a5,d4.l)
    beq.s   .bx0
    btst    d5,(a6,d4.l)
    bne.s   .green
.blue   move.w  d0,d1
    and.w   #$00F,d1
;   tst.w   d1
    bne.s   .donot
    bsr.s   .get4bi
    or.w    #$00F,d0
    or.w    d2,d3
    bra.s   .donot
.bx0    btst    d5,(a6,d4.l)
    bne.s   .red
    bsr.s   .get4bi
    add.w   d2,d2
.bk0    move.w  (a0,d2.l),d2
    move.w  d0,d1
    not.w   d1
    and.w   d1,d2
    or.w    d2,d3
    moveq.l #0,d2
    movem.l (sp)+,a3-a6
    rts
.green  move.w  d0,d1
    and.w   #$0F0,d1
;   tst.w   d1
    bne.s   .donot
    bsr.s   .get4bi
    or.w    #$0F0,d0
    lsl.w   #4,d2
    or.w    d2,d3
    bra.s   .donot
.red    move.w  d0,d1
    and.w   #$F00,d1
;   tst.w   d1
    bne.s   .donot
    bsr.s   .get4bi
    or.w    #$F00,d0
    lsl.w   #8,d2
    or.w    d2,d3
.donot  cmp.w   #$FFF,d0
    bne.s   .again
    moveq.l #0,d2
    movem.l (sp)+,a3-a6
    rts
.again  subq.w  #1,d6
    bpl .maloop
    moveq.l #0,d2
    bra.s   .bk0
.get4bi moveq.l #0,d2
    btst    d5,(a1,d4.l)
    beq.s   .skip1
    addq.l  #1,d2
.skip1  btst    d5,(a2,d4.l)
    beq.s   .skip2
    addq.l  #2,d2
.skip2  btst    d5,(a3,d4.l)
    beq.s   .skip4
    addq.l  #4,d2
.skip4  btst    d5,(a4,d4.l)
    beq.s   .skip8
    addq.l  #8,d2
.skip8  rts

    Lib_Par      HamColor      *** =Ham Color(c,rgb)
    
    move.l  (a3)+,d3
    move.l  (a3)+,d0
    moveq.l #0,d2
    cmp.w   #15,d0
    bls.s   .low16
    cmp.w   #31,d0
    bls.s   .blu16
    cmp.w   #47,d0
    bls.s   .red16
    sub.w   #48,d0
    lsl.b   #4,d0
    and.b   #$0F,d3
    or.b    d0,d3
    rts
.blu16  sub.w   #16,d0
    and.b   #$F0,d3
    or.b    d0,d3
    rts
.red16  sub.w   #32,d0
    lsl.w   #8,d0
    and.w   #$0FF,d3
    or.w    d0,d3
    rts
.low16  add.w   d0,d0
    move.l  ScOnAd(a5),a1
    move.l  a1,d1
    Rbeq    L_IScNoOpen
    move.w  EcPal-4(a1,d0.w),d3
    rts

    IFEQ    1
    Lib_Par      HamBest       *** =Ham Best(rgb,rgb)
    
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    dload   a2
    moveq.l #0,d2           ;Exact colour?
    move.l  ScOnAd(a5),a1
    lea EcPal-4(a1),a0
    moveq.l #15,d0
.exloop move.w  (a0)+,d1
    cmp.w   d1,d6
    bne.s   .nofou
    clr.l   O_HamRed(a2)
    eor.b   #15,d0
    moveq.l #0,d3
    move.b  d0,d3
    rts
.nofou  dbra    d0,.exloop

    cmp.w   d7,d6           ;Same Color
    bne.s   .nosame
    clr.l   O_HamRed(a2)
    moveq.l #0,d3
    moveq.l #0,d2
    move.b  d7,d3
    and.b   #$F,d3
    add.b   #16,d3
    rts

.nosame moveq.l #16,d3
    move.b  O_HamGreen(a2),d0
    add.b   O_HamBlue(a2),d0
    bne.s   .alrred
    move.w  #$0FF,d0
    bsr.s   .cmpcol
    cmp.b   #16,d3
    beq.s   .alrred
    addq.b  #4,O_HamGreen(a2)
    addq.b  #4,O_HamBlue(a2)
    moveq.l #0,d2
    rts
.alrred move.b  O_HamRed(a2),d0
    add.b   O_HamBlue(a2),d0
    bne.s   .alrgre
    move.w  #$F0F,d0
    bsr.s   .cmpcol
    cmp.b   #16,d3
    beq.s   .alrgre
    addq.b  #4,O_HamRed(a2)
    addq.b  #4,O_HamBlue(a2)
    moveq.l #0,d2
    rts
.alrgre move.b  O_HamRed(a2),d0
    add.b   O_HamGreen(a2),d0
    bne.s   .alrblu
    move.w  #$FF0,d0
    bsr.s   .cmpcol
    cmp.b   #16,d3
    beq.s   .alrblu
    addq.b  #4,O_HamRed(a2)
    addq.b  #4,O_HamGreen(a2)
    moveq.l #0,d2
    rts
.cmpcol move.l  ScOnAd(a5),a1
    lea EcPal-4(a1),a0
    move.w  d6,d5
    and.w   d0,d5
    moveq.l #15,d1
    move.w  #$1000,d2
.cmloop move.w  (a0)+,d2
    and.w   d0,d2
    cmp.w   d2,d5
    bne.s   .nofou2
    move.w  d6,d4
    eor.b   d5,d4
    cmp.w   d2,d4
    bgt.s   .cmloop
    move.w  d4,d2
    eor.b   #15,d1
    move.b  d1,d3
    bra.s   .cmloop
.nofou2 dbra    d1,.cmloop
    rts
.alrblu moveq.l #0,d0           ;Get Absolute
    move.b  d7,d5
    move.b  d6,d4
    and.b   #$F,d5
    and.b   #$F,d4
    cmp.b   d5,d4
    bpl.s   .gr1
    exg d5,d4
.gr1    sub.b   d5,d4
    move.b  d4,d0
    move.b  d7,d5
    move.b  d6,d4
    and.b   #$F0,d5
    and.b   #$F0,d4
    cmp.b   d5,d4
    bpl.s   .gr2
    exg d5,d4
.gr2    sub.b   d5,d4
    or.b    d4,d0
    move.w  d7,d5
    move.w  d6,d4
    and.w   #$F00,d5
    and.w   #$F00,d4
    cmp.w   d5,d4
    bpl.s   .gr3
    exg d5,d4
.gr3    sub.w   d5,d4
    or.w    d4,d0
    move.l  d0,d5

    dload   a2
    lsr.w   #8,d4           ;Extract Differences
    sub.b   O_HamRed(a2),d4
    move.b  d5,d3
    lsr.b   #4,d3
    sub.b   O_HamGreen(a2),d3
    move.b  d5,d2
    and.b   #$F,d2
    sub.b   O_HamBlue(a2),d2

    cmp.b   d3,d4           ;Compare
    blt.s   .grecon
    cmp.b   d2,d4
    blt.s   .grecon
    addq.b  #4,O_HamRed(a2)
    clr.b   O_HamGreen(a2)
    clr.b   O_HamBlue(a2)
    moveq.l #0,d2
    moveq.l #0,d3
    move.w  d6,d3
    lsr.w   #8,d3
    add.b   #32,d3
    rts
.grecon cmp.b   d4,d3
    blt.s   .blucon
    cmp.b   d2,d3
    blt.s   .blucon
    clr.b   O_HamRed(a2)
    addq.b  #4,O_HamGreen(a2)
    clr.b   O_HamBlue(a2)
    moveq.l #0,d2
    moveq.l #0,d3
    move.b  d6,d3
    lsr.b   #4,d3
    add.b   #48,d3
    rts
.blucon clr.w   O_HamRed(a2)
    addq.b  #4,O_HamBlue(a2)
    moveq.l #0,d2
    moveq.l #0,d3
    move.b  d6,d3
    and.b   #$F,d3
    add.b   #16,d3
    rts

    ELSE

    Lib_Par      HamBest       *** =Ham Best(rgb,rgb)
    
    move.l  (a3)+,d7        ;last
    move.l  (a3)+,d6        ;new
    moveq.l #0,d2           ;Exact colour?
    cmp.w   d6,d7
    bne.s   .skip99
    move.l  d6,d3
    and.w   #$F,d3
    add.w   #16,d3
    rts
.skip99 lea .coltab(pc),a2
    move.l  ScOnAd(a5),a1
    lea EcPal-4+16*2(a1),a0
    moveq.l #0,d3
    move.w  #1000,d5        ;error
    moveq.l #15,d4          ;curcol
.exloop move.w  -(a0),d0
    bsr .cmpcol
    tst.w   d0
    bne.s   .skip0
    move.w  d4,d3
    rts
.skip0  cmp.w   d0,d5
    blt.s   .skip1
    move.w  d0,d5
    move.w  d4,d3
.skip1  dbra    d4,.exloop
    move.w  d6,d4
    and.w   #$F00,d4
    move.w  d7,d0
    and.w   #$0FF,d0
    or.w    d4,d0
    lsr.w   #8,d4
    bsr.s   .cmpcol
    tst.w   d0
    bne.s   .skip2
    move.l  d4,d3
    add.w   #32,d3
    moveq.l #0,d2
    rts
.skip2  cmp.w   d0,d5
    blt.s   .skip3
    move.w  d0,d5
    move.w  d4,d3
    add.w   #32,d3
.skip3  move.w  d6,d4
    and.w   #$0F0,d4
    move.w  d7,d0
    and.w   #$F0F,d0
    or.w    d4,d0
    lsr.w   #4,d4
    bsr.s   .cmpcol
    tst.w   d0
    bne.s   .skip4
    move.l  d4,d3
    add.w   #48,d3
    moveq.l #0,d2
    rts
.skip4  cmp.w   d0,d5
    blt.s   .skip5
    move.w  d0,d5
    move.w  d4,d3
    add.w   #48,d3
.skip5  move.w  d6,d4
    and.w   #$00F,d4
    move.w  d7,d0
    and.w   #$FF0,d0
    or.w    d4,d0
    bsr.s   .cmpcol
    tst.w   d0
    bne.s   .skip6
    move.l  d4,d3
    add.w   #16,d3
    moveq.l #0,d2
    rts
.skip6  cmp.w   d0,d5
    blt.s   .skip7
    move.w  d0,d5
    move.w  d4,d3
    add.w   #16,d3
.skip7  moveq.l #0,d2
    rts
.cmpcol movem.l d1-d3/d5-d7,-(sp)
    cmp.w   d0,d6
    bne.s   .err
    moveq.l #0,d0
    movem.l (sp)+,d1-d3/d5-d7
    rts
.err    move.w  d0,d1
    move.w  d0,d2
    and.w   #$F00,d0
    move.w  d6,d5
    and.w   #$0F0,d1
    move.w  d6,d7
    and.w   #$00F,d2
    lsr.w   #8,d0
    and.w   #$F00,d5
    lsr.w   #4,d1
    and.w   #$0F0,d6
    lsr.w   #8,d5
    and.w   #$00F,d7
    lsr.w   #4,d6
    sub.w   d0,d5
    bpl.s   .nosgn1
    neg.w   d5
.nosgn1 sub.w   d1,d6
    bpl.s   .nosgn2
    neg.w   d6
.nosgn2 sub.w   d2,d7
    bpl.s   .nosgn3
    neg.w   d7
.nosgn3 moveq.l #0,d0
    moveq.l #0,d1
    move.b  (a2,d5.w),d0
    move.b  (a2,d6.w),d1
;   ext.w   d1
    add.w   d1,d0
    move.b  (a2,d7.w),d1
;   ext.w   d1
    add.w   d1,d0
    movem.l (sp)+,d1-d3/d5-d7
    rts
.coltab dc.b    0,1,3,5,8,12,16,20,30,40,50,60,70,80,90,100
    ENDC

    Lib_Par      HamFadeOut        *** Ham Fade Out screen
    
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcCon0(a0),d0
    btst    #11,d0
    Rbeq    L_IFonc
    lea EcPal-4(a0),a1
    moveq.l #15,d7
.paloop move.w  (a1),d0
    move.w  d0,d1
    and.w   #$F00,d1
    tst.w   d1
    beq.s   .nored
    sub.w   #$100,d0
.nored  move.b  d0,d1
    and.b   #$F0,d1
    tst.b   d1
    beq.s   .nogre
    sub.b   #$10,d0
.nogre  move.b  d0,d1
    and.b   #$F,d1
    tst.b   d1
    beq.s   .noblu
    subq.b  #$1,d0
.noblu  move.w  d0,(a1)+
    dbra    d7,.paloop
    move.l  a0,d7
    EcCall  CopMake
    move.l  d7,a0
    movem.l a3-a6,-(sp)
    move.w  EcTx(a0),d7
    lsr.w   #5,d7
    mulu    EcTy(a0),d7
    subq.w  #1,d7
    movem.l (a0)+,a1-a6
;   bra.s   .loop
;   cnop    0,4
.loop   move.l  (a5)+,d0

    move.l  (a1),d1
    move.l  d1,d2
    or.l    (a6)+,d0
    move.l  (a2),d3
    or.l    d3,d1
    move.l  (a3),d4
    or.l    d4,d1
    or.l    (a4),d1
    and.l   d1,d0

    eor.l   d0,d2
    move.l  d2,(a1)+
    and.l   d2,d0
    eor.l   d0,d3
    move.l  d3,(a2)+
    and.l   d3,d0
    eor.l   d0,d4
    move.l  d4,(a3)+
    and.l   d4,d0
    eor.l   d0,(a4)+
    dbra    d7,.loop
    movem.l (sp)+,a3-a6
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
;;    include "Amcaf/Smouse.asm"
    Lib_Par      XSmouse       *** =X Smouse
    
    dload   a2
    move.w  O_MouseX(a2),d3
    move.w  O_MouseSpeed(a2),d0
    asr.w   d0,d3
    ext.l   d3
    moveq.l #0,d2
    rts

    Lib_Par      YSmouse       *** =Y Smouse
    
    dload   a2
    move.w  O_MouseY(a2),d3
    move.w  O_MouseSpeed(a2),d0
    asr.w   d0,d3
    ext.l   d3
    moveq.l #0,d2
    rts

    Lib_Par      SetXSmouse        *** X Smouse=x
    
    dload   a2
    move.l  (a3)+,d0
    move.w  O_MouseSpeed(a2),d1
    asl.w   d1,d0
    move.w  d0,O_MouseX(a2)
    rts

    Lib_Par      SetYSmouse        *** Y Smouse=y
    
    dload   a2
    move.l  (a3)+,d0
    move.w  O_MouseSpeed(a2),d1
    asl.w   d1,d0
    move.w  d0,O_MouseY(a2)
    rts

    Lib_Par      LimitSmouse0      *** Limit Smouse
    
    dload   a2
    move.l  ScOnAd(a5),a0
    moveq.l #0,d0
    moveq.l #0,d1
    moveq.l #0,d2
    moveq.l #0,d3
    move.w  EcWx(a0),d0
    move.w  EcWy(a0),d1
    and.w   #$3FF,d0
    and.w   #$3FF,d1
    move.w  EcTx(a0),d2
    move.w  EcTy(a0),d3
    add.w   d0,d2
    add.w   d1,d3
    subq.w  #1,d2
    subq.w  #1,d3
    move.w  d0,O_MouseLim(a2)
    move.w  d1,O_MouseLim+2(a2)
    move.w  d2,O_MouseLim+4(a2)
    move.w  d3,O_MouseLim+6(a2)
    rts

    Lib_Par      LimitSmouse4      *** Limit Smouse x1,y1 To x2,y2
    
    dload   a2
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.w  d0,O_MouseLim(a2)
    move.w  d1,O_MouseLim+2(a2)
    move.w  d2,O_MouseLim+4(a2)
    move.w  d3,O_MouseLim+6(a2)
    rts

    Lib_Par      SmouseSpeed       *** Set Smouse Speed
    
    dload   a2
    move.l  (a3)+,d4
    move.w  O_MouseSpeed(a2),d3
    move.w  O_MouseX(a2),d0
    move.w  O_MouseY(a2),d1
    asr.w   d3,d0
    asr.w   d3,d1
    asl.w   d4,d0
    asl.w   d4,d1
    move.w  d0,O_MouseX(a2)
    move.w  d1,O_MouseY(a2)
    move.w  d4,O_MouseSpeed(a2)
    rts

    Lib_Par      SmouseKey     *** =Smouse Key
    
    dload   a2
    moveq.l #0,d3
    lea $DFF000,a0
    move.w  #$f000,$34(a0)
    btst    #7,$BFE001
    bne.s   .nolmb
    addq.w  #1,d3
.nolmb  btst    #6,$16(a0)
    bne.s   .normb
    addq.w  #2,d3
.normb  btst    #4,$16(a0)
    bne.s   .nommb
    addq.w  #4,d3
.nommb  moveq.l #0,d2
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
;;    include "Amcaf/IOError.asm"
    Lib_Par      IOError       *** =Io Error
    
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVOIoErr(a6)
    move.l  d7,a6
    move.l  d0,d3
    moveq.l #0,d2
    rts

    Lib_Par      IOErrorString     *** =Io Error$(Error)
    
    Rbra    L_IOErrorStringNoToken
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
;;    include "Amcaf/MaskCopy.asm"
    Lib_Par      MaskCopy3     *** Mask Copy s1 To s2,mk
    
    move.l  (a3)+,d7
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  Ec_RastPort(a0),d6
    moveq.l #0,d4
    moveq.l #0,d5
;   move.w  EcTx(a0),d4
;   move.w  EcTy(a0),d5
    move.l  (a3)+,d1
    Rjsr    L_GetEc
;   cmp.w   EcTx(a0),d4
;   Rbhi    L_IPicNoFit
;   cmp.w   EcTy(a0),d5
;   Rbhi    L_IPicNoFit
    move.w  EcTx(a0),d4
    move.w  EcTy(a0),d5
    move.l  Ec_BitMap(a0),a0
    move.l  d6,a1
    moveq.l #0,d0
    moveq.l #0,d1
    moveq.l #0,d2
    moveq.l #0,d3
    moveq.l #0,d6
    move.b  #$e0,d6
    move.l  d7,a2
    move.l  a6,-(sp)
    move.l  T_GfxBase(a5),a6
    jsr _LVOBltMaskBitMapRastPort(a6)
    move.l  (sp)+,a6
    rts

    Lib_Par      MaskCopy9     *** Mask Copy s1,x1,y1,x2,y2 To s2,x3,y3,mk
    
    moveq.l #0,d0
    move.b  #$e0,d0
    move.l  d0,-(a3)
    Rbra    L_MaskCopy10

    Lib_Par      MaskCopy10        *** Mask Copy s1,x1,y1,x2,y2 To s2,x3,y3,mk,mt
    
    move.l  (a3)+,d6
    move.l  (a3)+,a2
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  Ec_RastPort(a0),a1
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    sub.l   d0,d4
    sub.l   d1,d5
    movem.l d0-d2/a1/a2,-(sp)
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    movem.l (sp)+,d0-d2/a1/a2
    move.l  Ec_BitMap(a0),a0
    move.l  a6,-(sp)
    move.l  T_GfxBase(a5),a6
    jsr _LVOBltMaskBitMapRastPort(a6)
    move.l  (sp)+,a6
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
;;    include "Amcaf/MiscFun.asm"
    Lib_Par      LeadZeroStr       *** =Lzstr(number,digits)
    
    move.l  (a3)+,d3
    Rbeq    L_IFonc
    cmp.w   #10,d3
    Rbhi    L_IFonc

    move.l  (a3)+,d7
    move.w  d3,d4
    addq.w  #3,d3
    and.w   #$FFFE,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3
    move.w  d4,(a0)+

    moveq.l #2,d2
    lea .endtab-4(pc),a1
    subq.w  #1,d4
    moveq.l #0,d5
    move.w  d4,d5
    lsl.w   #2,d5
    sub.l   d5,a1
    move.l  d7,d0
    bpl.s   .notneg
    move.b  #'-',(a0)+
    subq.w  #1,d4
    bpl.s   .conta
    rts             ;one-digit neg number
.conta  move.l  (a1)+,d1
    neg.l   d0
.loop   cmp.l   d1,d0
    bge.s   .overfl
.notneg move.b  #'0',(a0)
    move.l  (a1)+,d1
    bra.s   .entry
.cmloop cmp.b   #'9',(a0)
    beq.s   .overfl
    addq.b  #1,(a0)
    sub.l   d1,d0
.entry  cmp.l   d1,d0
    bge.s   .cmloop
.skip   addq.l  #1,a0
.skip0  dbra    d4,.notneg
    rts
.overfl move.b  #'9',(a0)+
    dbra    d4,.overfl
    rts
    Rdata
.digtab dc.l    1000000000
    dc.l    100000000
    dc.l    10000000
    dc.l    1000000
    dc.l    100000
    dc.l    10000
    dc.l    1000
    dc.l    100
    dc.l    10
    dc.l    1
.endtab

    Lib_Par      LeadSpaceStr      *** =Lsstr(number,digits)
    
    move.l  (a3)+,d3
    Rbeq    L_IFonc
    cmp.w   #10,d3
    Rbhi    L_IFonc

    move.l  (a3)+,d7

    move.w  d3,d4
    addq.w  #3,d3
    and.w   #$FFFE,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3
    move.w  d4,(a0)+

    move.l  d7,d0
    lea .endtab-4(pc),a1
    subq.w  #1,d4
    moveq.l #0,d5
    move.w  d4,d5
    lsl.w   #2,d5
    sub.l   d5,a1
    moveq.l #0,d2
    moveq.l #0,d6
    moveq.l #0,d7
    tst.l   d0
    bpl.s   .notneg
    neg.l   d0
    moveq.l #1,d6
    cmp.l   (a1),d0
    bge.s   .overf2
.notneg move.b  #'0',(a0)
    move.l  (a1)+,d1
    cmp.l   d1,d0
    bge.s   .cmloop
    tst.w   d2
    bne.s   .nextd
    tst.w   d4
    beq.s   .nextd
    move.b  #' ',(a0)
    bra.s   .nextd
.cmloop tst.w   d6
    beq.s   .skip
    move.l  #0,d6
    tst.w   d7
    beq.s   .skip
    move.b  #'-',-1(a0)
.skip   cmp.b   #'9',(a0)
    beq.s   .overfl
    addq.b  #1,(a0)
    sub.l   d1,d0
    cmp.l   d1,d0
    bge.s   .cmloop
    st  d2
.nextd  addq.w  #1,d7
    addq.l  #1,a0
    dbra    d4,.notneg
    moveq.l #2,d2
    rts
.overf2 move.b  #'-',(a0)+
    subq.w  #1,d4
    bmi.s   .quit
.overfl move.b  #'9',(a0)+
    dbra    d4,.overfl
.quit   moveq.l #2,d2
    rts
    Rdata
.digtab dc.l    1000000000
    dc.l    100000000
    dc.l    10000000
    dc.l    1000000
    dc.l    100000
    dc.l    10000
    dc.l    1000
    dc.l    100
    dc.l    10
    dc.l    1
.endtab

    Lib_Par      ChrWord       *** =Chr.w$(word)
    
    moveq.l #4,d3
    Rjsr    L_Demande
    move.l  a0,d3
    move.w  #2,(a0)+
    move.l  (a3)+,d0
    move.w  d0,(a0)+
    move.l  a0,HiChaine(a5)
    moveq.l #2,d2
    rts

    Lib_Par      ChrLong       *** =Chr.l$(longword)
    
    moveq.l #6,d3
    Rjsr    L_Demande
    move.l  a0,d3
    move.w  #4,(a0)+
    move.l  (a3)+,(a0)+
    move.l  a0,HiChaine(a5)
    moveq.l #2,d2
    rts

    Lib_Par      AscWord       *** =Asc.w(word$)
    
    move.l  (a3)+,a0
    move.w  (a0)+,d0
    cmp.w   #2,d0
    Rblt    L_IFonc
    moveq.l #0,d3
    move.w  (a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      AscLong       *** =Asc.l(longword$)
    
    move.l  (a3)+,a0
    move.w  (a0)+,d0
    cmp.w   #4,d0
    Rblt    L_IFonc
    move.l  (a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      Vclip         *** =Vclip(val,lower To upper)
    
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.l  (a3)+,d3
    moveq.l #0,d2
    cmp.l   d1,d3
    ble.s   .noup
    move.l  d1,d3
.noup   cmp.l   d3,d0
    ble.s   .nodown
    move.l  d0,d3
.nodown rts

    Lib_Par      Vin           *** =Vin(val,lower To upper)
    
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.l  (a3)+,d4
    moveq.l #0,d2
    moveq.l #-1,d3
    cmp.l   d1,d4
    ble.s   .noup
    moveq.l #0,d3
    rts
.noup   cmp.l   d4,d0
    ble.s   .nodown
    moveq.l #0,d3
.nodown rts

    Lib_Par      Vmod2         *** =Vmod(val,upper)
    
    moveq.l #0,d2
    move.l  (a3)+,d5
    Rbmi    L_IFonc
    Rbeq    L_IFonc
    move.l  (a3)+,d3
    bmi.s   .neg
    addq.l  #1,d5
    divu    d5,d3
    clr.w   d3
    swap    d3
    rts
.neg    neg.l   d3
    addq.l  #1,d5
    divu    d5,d3
    clr.w   d3
    swap    d3
    neg.l   d3
    add.l   d5,d3
    rts

    Lib_Par      Vmod3         *** =Vmod(val,lower To upper)
    
    moveq.l #0,d2
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    sub.l   d4,d5
    Rbmi    L_IFonc
    Rbeq    L_IFonc
    move.l  (a3)+,d3
    sub.l   d4,d3
    bmi.s   .neg
    addq.l  #1,d5
    divs    d5,d3
    clr.w   d3
    swap    d3
    add.l   d4,d3
    rts
.neg    neg.l   d3
    addq.l  #1,d5
    divu    d5,d3
    clr.w   d3
    swap    d3
    neg.l   d3
    add.l   d5,d3
    add.l   d4,d3
    rts

    Lib_Par      Insstr        *** =Insstr$(a$,b$,pos)
    
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    move.l  (a3)+,a2
    move.l  (a3)+,a1
    move.w  (a1)+,d5
    cmp.w   d5,d7
    Rbhi    L_IFonc
    move.w  (a2)+,d6
    bne.s   .cont1
    subq.l  #2,a1
    move.l  a1,d3
    moveq.l #2,d2
    rts
.cont1  move.w  d5,d3
    add.w   d6,d3

    and.w   #$FFFE,d3
    addq.w  #2,d3
    movem.l a1/a2,-(sp)
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    movem.l (sp)+,a1/a2
    move.l  a0,d3

    move.w  d5,(a0)
    add.w   d6,(a0)+
    moveq.l #0,d4
.loop1  cmp.w   d7,d4
    beq.s   .loop2
    subq.w  #1,d5
    move.b  (a1)+,(a0)+
    addq.w  #1,d4
    bra.s   .loop1
.loop2  tst.w   d6
    beq.s   .loop3
    subq.w  #1,d6
    move.b  (a2)+,(a0)+
    bra.s   .loop2
.loop3  tst.w   d5
    beq.s   .quit
    subq.w  #1,d5
    move.b  (a1)+,(a0)+
    bra.s   .loop3
.quit   moveq.l #2,d2
    rts

    Lib_Par      CutStr        *** =Cutstr(a$,pos1 To pos2)
    
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    move.l  (a3)+,d6
    Rbmi    L_IFonc
    Rbeq    L_IFonc
    move.l  d7,d5
    sub.l   d6,d5
    Rbmi    L_IFonc
    move.l  (a3)+,a2
    move.w  (a2)+,d4
    cmp.w   d6,d4
    Rbmi    L_IFonc
    cmp.w   d7,d4
    Rbmi    L_IFonc
    move.w  d4,d3
    sub.w   d5,d3

    and.w   #$FFFE,d3
    addq.w  #2,d3
    movem.l a1/a2,-(sp)
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    movem.l (sp)+,a1/a2
    move.l  a0,d3

    move.w  d4,(a0)
    sub.w   d5,(a0)+
    moveq.l #1,d1
.loop1  cmp.w   d1,d6
    beq.s   .loop2
    subq.w  #1,d4
    move.b  (a2)+,(a0)+
    addq.w  #1,d1
    bra.s   .loop1
.loop2  lea 1(a2,d5.w),a2
    sub.w   d5,d4
.loop3  tst.w   d4
    beq.s   .quit
    subq.w  #1,d4
    move.b  (a2)+,(a0)+
    bra.s   .loop3
.quit   moveq.l #2,d2
    rts

    Lib_Par      Replacestr        *** =Replacestr$(a$,b$ To c$)
    
    move.l  8(a3),a2
    move.l  4(a3),a1
    move.w  (a2)+,d5
    move.w  d5,d2
    bne.s   .nempty
.empty  lea 12(a3),a3
    move.l  -4(a3),d3
    moveq.l #2,d2
    rts
.nempty move.w  (a1)+,d6
    Rbeq    L_IFonc
    move.l  a1,d4
    moveq.l #0,d7
.sealop move.l  d4,a1
    tst.w   d5
    beq.s   .qsearc
    cmp.b   (a2)+,(a1)+
    bne.s   .cont1
    move.w  -3(a1),d6
    movem.l a2/d5,-(sp)
.flop   subq.w  #1,d5
    subq.w  #1,d6
    tst.w   d6
    beq.s   .fouone
    tst.w   d5
    beq.s   .nofou
    cmp.b   (a2)+,(a1)+
    bne.s   .nofou
    bra.s   .flop
.fouone addq.l  #1,d7
    addq.l  #8,sp
    bra.s   .sealop
.nofou  movem.l (sp)+,a2/d5
.cont1  subq.w  #1,d5
    bra.s   .sealop
.qsearc tst.l   d7
    beq.s   .empty
    move.l  (a3),a0
    move.l  4(a3),a1
    move.w  (a0),d3
    move.w  (a1),d6
    sub.w   d6,d3
    ext.l   d3
    muls    d7,d3
    add.w   d2,d3
    move.w  d3,d7

    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.w  d7,(a0)+
    movem.l a4-a6,-(sp)
    move.l  (a3)+,a6
    move.l  (a3)+,d4
    move.l  (a3)+,a2
    addq.l  #2,d4
    move.w  (a2)+,d5

.replop move.l  d4,a1
    tst.w   d5
    beq.s   .qreplc
    cmp.b   (a2)+,(a1)+
    bne.s   .cont2
    move.w  -3(a1),d6
    movem.l a2/d5,-(sp)
.flop2  subq.w  #1,d5
    subq.w  #1,d6
    tst.w   d6
    beq.s   .fouon2
    tst.w   d5
    beq.s   .nofou2
    cmp.b   (a2)+,(a1)+
    bne.s   .nofou2
    bra.s   .flop2
.fouon2 addq.l  #8,sp
    move.l  a6,a4
    move.w  (a4)+,d0
    beq.s   .replop
    subq.w  #1,d0
.cpylop move.b  (a4)+,(a0)+
    dbra    d0,.cpylop
    bra.s   .replop
.nofou2 movem.l (sp)+,a2/d5
.cont2  move.b  -1(a2),(a0)+
    subq.w  #1,d5
    bra.s   .replop
.qreplc movem.l (sp)+,a4-a6
    moveq.l #2,d2
    rts

    Lib_Par      Itemstr2      *** =Itemstr$(a$,itemnum)
    
    lea .mdefsp(pc),a0
    move.l  a0,-(a3)
    Rbra    L_Itemstr3
.mdefsp dc.w    1
    dc.b    '|'
    even

    Lib_Par      Itemstr3      *** =Itemstr$(a$,itemnum,sep$)
    
    move.l  (a3)+,a0
    move.w  (a0)+,d0
    cmp.w   #1,d0
    Rbne    L_IFonc
    move.b  (a0),d7
    move.l  (a3)+,d6
    Rbmi    L_IFonc
    move.l  (a3)+,a0
    move.w  (a0)+,d5
    Rbeq    L_IFonc
.chklop tst.w   d6
    beq.s   .found
    cmp.b   (a0)+,d7
    beq.s   .cont1
    subq.w  #1,d5
    Rbeq    L_IFonc
    bra.s   .chklop
.cont1  subq.w  #1,d6
    beq.s   .found
    subq.w  #1,d5
    Rbeq    L_IFonc
    bra.s   .chklop
.found  moveq.l #0,d4
    move.l  a0,d6
    move.l  a0,a2
.chelop subq.w  #1,d5
    beq.s   .endit
    cmp.b   (a2)+,d7
    beq.s   .endit
    addq.w  #1,d4
    bra.s   .chelop
.endit  moveq.l #0,d3
    move.w  d4,d3

    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.w  d4,(a0)+
    move.l  d6,a2
    tst.w   d4
    beq.s   .end
    subq.w  #1,d4
.cpylop move.b  (a2)+,(a0)+
    dbra    d4,.cpylop
.end    move.l  a0,d0
    addq.l  #1,d0
    and.b   #$FE,d0
    move.l  d0,HiChaine(a5)
    moveq.l #2,d2
    rts

    Lib_Par      Odd           *** =Odd(number)
    
    move.l  (a3)+,d3
    moveq.l #0,d2
    moveq.l #1,d0
    and.l   d0,d3
    neg.l   d3
    rts

    Lib_Par      Even          *** =Even(number)
    
    move.l  (a3)+,d0
    moveq.l #0,d2
    moveq.l #0,d3
    btst    #0,d0
    bne.s   .odd
    moveq.l #-1,d3
.odd    rts

    Lib_Par      PowerOfTwo        *** =Secexp(number)
    
    moveq.l #1,d3
    moveq.l #0,d2
    move.l  (a3)+,d0
    beq.s   .skip
    Rbmi    L_IFonc
    moveq.l #32,d1
    cmp.l   d1,d0
    Rbge    L_IFonc
    lsl.l   d0,d3
.skip   rts
    
    Lib_Par      RootOfTwo     *** =Seclog(number)
    
    move.l  (a3)+,d0
    Rbeq    L_IFonc
    moveq.l #0,d3
    moveq.l #0,d2
    btst    d2,d0
    bne.s   .end
.loop   lsr.l   d0
    addq.l  #1,d3
    btst    d2,d0
    beq.s   .loop
.end    lsr.l   d0
    tst.l   d0
    Rbne    L_IFonc
    rts

    Lib_Par      Lsl           *** =Lsl(number,bits)
    
    move.l  (a3)+,d0
    moveq.l #0,d2
    move.l  (a3)+,d3
    asl.l   d0,d3
    rts

    Lib_Par      Lsr           *** =Lsr(number,bits)
    
    move.l  (a3)+,d0
    moveq.l #0,d2
    move.l  (a3)+,d3
    asr.l   d0,d3
    rts

    Lib_Par      MCSwap        *** =Wordswap(number)
    
    move.l  (a3)+,d3
    swap    d3
    moveq.l #0,d2
    rts

    Lib_Par      SgnDeek       *** =Sdeek(address)
    
    move.l  (a3)+,a0
    move.l  a0,d0
    move.w  (a0),d3
    ext.l   d3
    moveq.l #0,d2
    rts

    Lib_Par      SgnPeek       *** =Speek(address)
    
    move.l  (a3)+,a0
    move.l  a0,d0
    move.b  (a0),d3
    ext.w   d3
    ext.l   d3
    moveq.l #0,d2
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
;;    include "Amcaf/MiscGfx.asm"
    Lib_Par      SetRainCol        *** Set Rain Colour rainnr,colour
    
    move.l  (a3)+,d7
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #NbRain,d0
    Rbge.s  L_IFonc
    lea T_RainTable(a5),a1
    tst.w   d0
    beq.s   .noadd
    subq.w  #1,d0
.rnloop lea RainLong(a1),a1
    dbra    d0,.rnloop
.noadd  move.w  d7,RnColor(a1)
    rts

    Lib_Par      RainFade2     *** Rain Fade rainnr,colour
    
    move.l  (a3)+,d6
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #NbRain,d0
    Rbge.s  L_IFonc
    lea T_RainTable(a5),a1
    tst.w   d0
    beq.s   .noadd
    subq.w  #1,d0
.rnloop lea RainLong(a1),a1
    dbra    d0,.rnloop
.noadd  move.w  RnLong(a1),d7
    Rbeq    L_IFonc
    lsr.w   #1,d7
    subq.w  #1,d7
    move.l  RnBuf(a1),a1
.loop   move.w  (a1),d0
    cmp.w   d0,d6
    beq.s   .skipb
    move.w  d0,d1
    move.w  d6,d3
    and.w   #$F00,d1
    and.w   #$F00,d3
    sub.w   d3,d1
    beq.s   .skipr
    bcs.s   .addr
    sub.w   #$100,d0
    bra.s   .skipr
.addr   add.w   #$100,d0
.skipr  move.b  d0,d1
    move.b  d6,d3
    and.b   #$F0,d1
    and.b   #$F0,d3
    sub.b   d3,d1
    beq.s   .skipg
    bcs.s   .addg
    sub.b   #$10,d0
    bra.s   .skipg
.addg   add.b   #$10,d0
.skipg  move.b  d0,d1
    move.b  d6,d3
    and.b   #$0F,d1
    and.b   #$0F,d3
    sub.b   d3,d1
    beq.s   .skipb
    bcs.s   .addb
    subq.b  #$1,d0
    bra.s   .skipb
.addb   addq.b  #$1,d0
.skipb  move.w  d0,(a1)+
    dbra    d7,.loop
    rts

    Lib_Par      RainFadet2        *** Rain Fade rainnr To rainnr
    
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #NbRain,d0
    Rbge.s  L_IFonc
    move.l  (a3)+,d1
    Rbmi    L_IFonc
    cmp.w   #NbRain,d1
    Rbge.s  L_IFonc
    cmp.w   d0,d1
    Rbeq    L_IFonc
    lea T_RainTable(a5),a1
    move.l  a1,a2
    tst.w   d0
    beq.s   .noadd
    subq.w  #1,d0
.rnloop lea RainLong(a2),a2
    dbra    d0,.rnloop
.noadd  tst.w   d1
    beq.s   .noadd2
    subq.w  #1,d1
.rnlop2 lea RainLong(a1),a1
    dbra    d1,.rnlop2
.noadd2 move.w  RnLong(a1),d7
    Rbeq    L_IFonc
    subq.w  #1,d7
    lsr.w   #1,d7
    move.w  RnLong(a2),d6
    Rbeq    L_IFonc
    subq.w  #1,d6
    lsr.w   #1,d6
    cmp.w   d6,d7
    blt.s   .notgt
    move.w  d6,d7
.notgt  move.l  RnBuf(a1),a1
    move.l  RnBuf(a2),a2
.loop   move.w  (a2)+,d0
    move.w  (a1),d2
    cmp.w   d0,d2
    beq.s   .skipb
    move.w  d0,d1
    move.w  d2,d3
    and.w   #$F00,d1
    and.w   #$F00,d3
    sub.w   d3,d1
    beq.s   .skipr
    bcc.s   .addr
    sub.w   #$100,d2
    bra.s   .skipr
.addr   add.w   #$100,d2
.skipr  move.b  d0,d1
    move.b  d2,d3
    and.b   #$F0,d1
    and.b   #$F0,d3
    sub.b   d3,d1
    beq.s   .skipg
    bcc.s   .addg
    sub.b   #$10,d2
    bra.s   .skipg
.addg   add.b   #$10,d2
.skipg  move.b  d0,d1
    move.b  d2,d3
    and.b   #$0F,d1
    and.b   #$0F,d3
    sub.b   d3,d1
    beq.s   .skipb
    bcc.s   .addb
    subq.b  #$1,d2
    bra.s   .skipb
.addb   addq.b  #$1,d2
.skipb  move.w  d2,(a1)+
    dbra    d7,.loop
    rts

    Lib_Par      RasterX       *** =Raster X
    
    moveq   #0,d3
    moveq   #0,d2
    move.b  $DFF007,d3
    add.w   d3,d3
    rts

    Lib_Par      RasterY       *** =Raster Y
    
    moveq   #0,d3
    moveq   #0,d2
    lea $DFF005,a0
    move.b  (a0)+,d3
    lsl.w   #8,d3
    move.b  (a0),d3
    rts

    Lib_Par      RasterWait1       *** Raster Wait y
    
    move.l  (a3)+,d3
    lea $DFF004,a0
    moveq.l #0,d0
.loop   move.w  d0,d1
    move.l  (a0),d0         ;l000000yyyyyyyyyxxxxxxxx
    lsr.l   #8,d0
    cmp.w   d1,d0
    blt.s   .quit
    cmp.w   d3,d0
    blt.s   .loop
.quit   tst.w   d0          ;Ausnahme bei 255->256
    beq.s   .loop
    rts

    Lib_Par      RasterWait2       *** Raster Wait x,y
    
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    lsr.l   d2
    moveq   #0,d1
    lea $DFF004,a0
    lea 3(a0),a1
.loop   move.w  d0,d1
    move.l  (a0),d0
    lsr.l   #8,d0
    cmp.w   d1,d0
    blt.s   .quit
    cmp.w   d3,d0
    blt.s   .loop
.loop2  move.b  (a1),d0
    cmp.b   d2,d0
    blt.s   .loop2
.quit   tst.w   d0
    beq.s   .loop
    rts

    Lib_Par      SetNTSC       *** Set Ntsc
    
    move.w  #0,$DFF1DC
    move.l  4.w,a0
    move.b  #60,530(a0)
    rts

    Lib_Par      SetPAL        *** Set Pal
    
    move.w  #$20,$DFF1DC
    move.l  4.w,a0
    move.b  #50,530(a0)
    rts

    Lib_Par      SpritePriority    *** Set Sprite Priority pri
    
    move.l  (a3)+,d0
    move.l  ScOnAd(a5),a0
    and.w   #%111111,d0
    move.w  d0,EcCon2(a0)
    rts

    Lib_Par      CopPos        *** =Cop Pos
    
    moveq.l #0,d2
    move.l  T_CopPos(a5),d3
    rts

    Lib_Par      ExchangeBob       *** Exchange Bob i1,i2
    
    Rjsr    L_Bnk.GetBobs
    Rbeq    L_IFonc
    move.w  (a0)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    cmp.w   d2,d0
    Rbhi    L_IFonc
    cmp.w   d2,d1
    Rbhi    L_IFonc
    cmp.l   d0,d1
    bne.s   .cont
    rts
.cont   subq.w  #1,d0
    lsl.w   #3,d0
    subq.w  #1,d1
    lsl.w   #3,d1
    move.l  (a0,d0.w),d2
    move.l  4(a0,d0.w),d3
    move.l  (a0,d1.w),(a0,d0.w)
    move.l  4(a0,d1.w),4(a0,d0.w)
    move.l  d2,(a0,d1.w)
    move.l  d3,4(a0,d1.w)
    rts

    Lib_Par      ExchangeIcon      *** Exchange Icon i1,i2
    
    Rjsr    L_Bnk.GetIcons
    Rbeq    L_IFonc
    move.w  (a0)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    cmp.w   d2,d0
    Rbhi    L_IFonc
    cmp.w   d2,d1
    Rbhi    L_IFonc
    cmp.l   d0,d1
    bne.s   .cont
    rts
.cont   subq.w  #1,d0
    lsl.w   #3,d0
    subq.w  #1,d1
    lsl.w   #3,d1
    move.l  (a0,d0.w),d2
    move.l  4(a0,d0.w),d3
    move.l  (a0,d1.w),(a0,d0.w)
    move.l  4(a0,d1.w),4(a0,d0.w)
    move.l  d2,(a0,d1.w)
    move.l  d3,4(a0,d1.w)
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
;;    include "Amcaf/MiscSys.asm"
    Lib_Par      WriteCLI      *** Write Cli s$
    
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOOutput(a6)
    move.l  d0,d1
    move.l  (a3)+,a0
    moveq.l #0,d3
    move.w  (a0)+,d3
    move.l  a0,d2
    jsr _LVOWrite(a6)
    move.l  (sp)+,a6
    rts

    Lib_Par      ResetComputer     *** Reset Computer
    
    Rbsr    L_GetKickVer
    cmp.w   #37,d0
    blt.s   .kick13
    move.l  4.w,a6
    jmp _LVOColdReboot(a6)
.kick13 lea .reset(pc),a5
    move.l  4.w,a6
    jmp _LVOSupervisor(a6)
    cnop    4,0
.reset  lea $1000000,a0
    sub.l   -20(a0),a0
    move.l  4(a0),a0
    subq.l  #2,a0
    reset
    jmp (a0)

    Lib_Par      CPU           *** =Cpu
    
    move.l  4.w,a0
    move.w  296(a0),d0
    move.l  #68000,d3
    btst    #0,d0
    beq.s   .skip1
    move.w  #(68010&$FFFF),d3
.skip1  btst    #1,d0
    beq.s   .skip2
    move.w  #(68020&$FFFF),d3
.skip2  btst    #2,d0
    beq.s   .skip3
    move.w  #(68030&$FFFF),d3
.skip3  btst    #3,d0
    beq.s   .skip4
    move.w  #(68040&$FFFF),d3
.skip4  btst    #7,d0
    beq.s   .skip5
    move.w  #(68060&$FFFF),d3
.skip5  moveq.l #0,d2
    rts

    Lib_Par      FPU           *** =Fpu
    
    move.l  4.w,a0
    move.w  296(a0),d0
    moveq.l #0,d3
    btst    #4,d0
    beq.s   .skip1
    move.l  #68881,d3
.skip1  btst    #5,d0
    beq.s   .skip2
    move.w  #68882&$FFFF,d3
.skip2  btst    #6,d0
    beq.s   .skip3
    move.l  #68040,d3
    btst    #7,d0
    beq.s   .skip3
    move.w  #(68060&$FFFF),d3
.skip3  moveq.l #0,d2
    rts

    Lib_Par      AgaDetect     *** =Aga Detect
    
    moveq.l #0,d2
    moveq.l #0,d3
    move.l  T_GfxBase(a5),a0
    move.w  20(a0),d0
    cmp.w   #39,d0
    blt .noaga
    move.b  gb_ChipRevBits0(a0),d0
    btst    #GFXB_AA_ALICE,d0
    beq.s   .noaga
    moveq.l #-1,d3
.noaga  rts

    Lib_Par      FlushLibs     *** Flush Libs
    
    Rbsr    L_FreeExtMem
    dload   a2
    move.l  a6,d3
    move.l  4.w,a6
    move.l  O_PowerPacker(a2),d0
    beq.s   .nopp
    move.l  d0,a1
    jsr _LVOCloseLibrary(a6)
    clr.l   O_PowerPacker(a2)
.nopp   move.l  O_DiskFontLib(a2),d0
    beq.s   .nodsfn
    move.l  d0,a1
    jsr _LVOCloseLibrary(a6)
    clr.l   O_DiskFontLib(a2)
.nodsfn moveq.l #0,d1
    moveq.l #$7f,d0
    swap    d0
    jsr _LVOAllocMem(a6)
    tst.l   d0
    bne.s   .sigh
.quit   move.l  d3,a6
    rts
.sigh   move.l  d0,a1
    moveq.l #$7f,d0
    swap    d0
    jsr _LVOFreeMem(a6)
    bra.s   .quit

    Lib_Par      OpenWorkbench     *** Open Workbench
    
    move.l  a6,d5
    move.l  T_IntBase(a5),a6
    jsr _LVOOpenWorkBench(a6)
    move.l  d5,a6
    tst.l   d0
    bpl.s   .skip
.error  moveq.l #1,d0
    Rbra    L_Custom
.skip   clr.b   WB_Closed(a5)       ;AMOS-Flag
    rts

    Lib_Par      CreateProc1       *** Launch name$
    
    moveq.l #0,d0
    move.w  #4096,d0
    move.l  d0,-(a3)
    Rbra    L_CreateProc2

    Lib_Par      CreateProc2       *** Launch name$,stack
    
    move.l  (a3)+,d4
    move.l  (a3)+,a0
    Rbsr    L_MakeZeroFile
    move.l  a0,d1
    move.l  a0,d6
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVOLoadSeg(a6)
    move.l  d7,a6
    move.l  d0,d3
    Rbeq    L_IFNoFou
    move.l  d6,d1
    moveq.l #0,d2
    move.l  DosBase(a5),a6
    jsr _LVOCreateProc(a6)
    move.l  d0,d5
;   move.l  d6,d1
;   jsr _LVOUnLoadSeg(a6)   ;Unload erlaubt????????????
    move.l  d7,a6
    tst.l   d5
    beq.s   .error
    rts
.error  move.l  d3,d1
    move.l  DosBase(a5),a6
    jsr _LVOUnLoadSeg(a6)
    move.l  d7,a6
    moveq.l #11,d0
    Rbra    L_Custom
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
;;    include "Amcaf/Pix.asm"
    Lib_Par      ShadePix2     *** Shade Pix x,y
    
    moveq.l #6,d0
    move.l  d0,-(a3)
    Rbra    L_ShadePix

    Lib_Par      ShadePix      *** Shade Pix x,y,planes
    
    move.l  ScOnAd(a5),a2
    move.l  (a3)+,d4
    subq.l  #1,d4
    move.l  (a3)+,d7
    bpl.s   .cont
    addq.l  #4,a3
    rts
.cont   move.l  (a3)+,d6
    bmi.s   .end
    cmp.w   EcTy(a2),d7
    bge.s   .end
    move.w  EcTx(a2),d0
    cmp.w   d0,d6
    bge.s   .end
    lsr.w   #3,d0
    mulu    d0,d7
    move.b  d6,d3
    not.b   d3
    lsr.w   #3,d6
    add.w   d6,d7
.loop   move.l  (a2)+,a0
    move.l  a0,d0
    beq.s   .end
    add.w   d7,a0
    btst    d3,(a0)
    beq.s   .dot
    bclr    d3,(a0)
    dbra    d4,.loop
    bra.s   .end
.dot    bset    d3,(a0)
.end    rts

    Lib_Par      MakePixTemplate   *** Make Pix Mask s,x1,y1 To x2,y2,bank
    
    lea -16(sp),sp
    move.l  (a3)+,d3
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
;   move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    move.w  d6,d2
    mulu    d7,d2
    move.l  d3,d0
    moveq.l #0,d1
    lea .bktemp(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,a1
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
    move.l  (a2),a2
    moveq.l #0,d2
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  move.w  d5,d3
    move.w  d1,d4
    lsr.w   #3,d4
    add.l   d4,d3
    move.b  d1,d4
    not.b   d4
.gloop  btst    d4,(a2,d3.l)
    beq.s   .skip
    move.b  #1,(a1)+
    bra.s   .cont
.skip   clr.b   (a1)+
.cont   addq.w  #1,d1
    dbra    d6,.xloop
    add.l   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts
.bktemp dc.b    'Pix Mask'
    even

    Lib_Par      PixShiftUp2       *** Pix Shift Up s,c1,c2,x1,y1 To x2,y2,adr
    
    lea -16(sp),sp
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a1
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  tst.b   (a1)+
    beq.s   .nopix
    movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    bmi.s   .quit
    cmp.b   18(sp),d4
    bhi.s   .quit
    addq.b  #1,d4
    cmp.b   18(sp),d4
    ble.s   .putpix
    move.b  16(sp),d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop2 move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbi2
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.setbi2 bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.putpix move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbit
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.setbit bset    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
.nopix  addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixShiftUp        *** Pix Shift Up s,c1,c2,x1,y1 To x2,y2
    
    lea -16(sp),sp
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    bmi.s   .quit
    cmp.b   18(sp),d4
    bhi.s   .quit
    addq.b  #1,d4
    cmp.b   18(sp),d4
    ble.s   .putpix
    move.b  16(sp),d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop2 move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbi2
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.setbi2 bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.putpix move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbit
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.setbit bset    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
    addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixShiftDown2     *** Pix Shift Down s,c1,c2,x1,y1 To x2,y2,adr
    
    lea -16(sp),sp
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a1
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  tst.b   (a1)+
    beq.s   .nopix
    movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    bmi.s   .quit
    cmp.b   18(sp),d4
    bhi.s   .quit
    subq.b  #1,d4
    cmp.b   16(sp),d4
    bge.s   .putpix
    move.b  18(sp),d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop2 move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbit
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.setbit bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.putpix move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    beq.s   .clrbit
    bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.clrbit bclr    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
.nopix  addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixShiftDown      *** Pix Shift Down s,c1,c2,x1,y1 To x2,y2
    
    lea -16(sp),sp
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    bmi.s   .quit
    cmp.b   18(sp),d4
    bhi.s   .quit
    subq.b  #1,d4
    cmp.b   16(sp),d4
    bge.s   .putpix
    move.b  18(sp),d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop2 move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbit
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.setbit bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop2
    bra.s   .quit
.putpix move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    beq.s   .clrbit
    bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.clrbit bclr    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
    addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixBrighten2      *** Pix Brighten s,c1,c2,x1,y1 To x2,y2,adr
    
    lea -16(sp),sp
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a1
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  tst.b   (a1)+
    beq.s   .nopix
    movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    bmi.s   .quit
    cmp.b   18(sp),d4
    bge.s   .quit
    addq.b  #1,d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbit
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.setbit bset    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
.nopix  addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixBrighten       *** Pix Brighten s,c1,c2,x1,y1 To x2,y2
    
    lea -16(sp),sp
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    bmi.s   .quit
    cmp.b   18(sp),d4
    bge.s   .quit
    addq.b  #1,d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    bne.s   .setbit
    bclr    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.setbit bset    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
    addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixDarken2        *** Pix Darken s,c1,c2,x1,y1 To x2,y2,adr
    
    lea -16(sp),sp
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a1
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  tst.b   (a1)+
    beq.s   .nopix
    movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    ble.s   .quit
    cmp.b   18(sp),d4
    bhi.s   .quit
    subq.b  #1,d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    beq.s   .clrbit
    bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.clrbit bclr    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
.nopix  addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
    rts

    Lib_Par      PixDarken     *** Pix Darken s,c1,c2,x1,y1 To x2,y2
    
    lea -16(sp),sp
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.l  (a3)+,d4
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.w  d5,6(sp)        ;y1
    move.w  d4,4(sp)        ;x1
    move.b  d2,2(sp)        ;c2
    move.b  d1,(sp)         ;c1
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a2
    sub.w   d4,d6
    sub.w   d5,d7
    subq.w  #1,d6
    subq.w  #1,d7
    move.w  d6,8(sp)
    move.w  d7,10(sp)
    move.w  EcNPlan(a2),d3
    subq.b  #1,d3
    move.w  EcTx(a2),d0
    lsr.w   #3,d0
    mulu    d0,d5
.yloop  move.w  8(sp),d6
    move.w  4(sp),d1
.xloop  movem.w d0-d5,-(sp)
    move.l  a2,-(sp)
    move.w  d1,d2
    lsr.w   #3,d2
    add.w   d2,d5
    not.b   d1
    move.w  d3,d0
    moveq.l #0,d4
    moveq.l #0,d2
.gloop  move.l  (a2)+,a0
    btst    d1,(a0,d5.w)
    beq.s   .skip
    bset    d2,d4
.skip   addq.b  #1,d2
    dbra    d3,.gloop
    cmp.b   16(sp),d4
    ble.s   .quit
    cmp.b   18(sp),d4
    bhi.s   .quit
    subq.b  #1,d4
    move.l  (sp),a2
    moveq.l #0,d2
.sloop  move.l  (a2)+,a0
    btst    d2,d4
    beq.s   .clrbit
    bset    d1,(a0,d5.w)
    addq.b  #1,d2
    dbra    d0,.sloop
    bra.s   .quit
.clrbit bclr    d1,(a0,d5.w)
.quit   move.l  (sp)+,a2
    movem.w (sp)+,d0-d5
    addq.w  #1,d1
    dbra    d6,.xloop
    add.w   d0,d5
    dbra    d7,.yloop
    lea 16(sp),sp
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
;;    include "Amcaf/PP.asm"
    Lib_Par      PPSave1       *** Pptodisk file$,sbank,efficiency
    
    dload   a2
    Rbsr    L_FreeExtMem
    Rbsr    L_PPOpenLib
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.l  (a3)+,d7
    move.l  d1,-(a3)
    Rjsr    L_Bnk.OrAdr
    move.l  d0,d6
    move.w  -12(a0),d0
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom
.noicon move.l  d7,a0
    Rbsr    L_OpenFileW
    bne.s   .good
    Rbra    L_IIOError
.good   move.l  d1,d7
    move.l  d6,a0
    move.l  -20(a0),d0
    subq.l  #8,d0
    subq.l  #8,d0
    move.l  d0,d4
    move.l  #$10001,d1
    move.l  a6,-(sp)
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  (sp)+,a6
    tst.l   d0
    bne.s   .gotmem
    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbra    L_IOoMem
.gotmem move.l  d0,O_BufferAddress(a2)
    move.l  d0,d5
    move.l  d4,O_BufferLength(a2)
    move.l  d0,a1
    move.l  d6,a0
    move.l  d4,d0
    lsr.l   d0
    subq.w  #1,d0
    move.l  d0,d1
    swap    d1
.coplop move.w  (a0)+,(a1)+
    dbra    d0,.coplop
    dbra    d1,.coplop
    btst    #0,d4
    beq.s   .even
    move.b  (a0)+,(a1)+
.even   move.l  (a3),d1
    move.l  d7,d0
    moveq.l #0,d2
    moveq.l #0,d3
    move.l  a6,-(sp)
    move.l  O_PowerPacker(a2),a6
    jsr _LVOppWriteDataHeader(a6)
    move.l  (a3)+,d0
    moveq.l #0,d1
    sub.l   a0,a0
    jsr _LVOppAllocCrunchInfo(a6)
    move.l  d0,O_PPCrunchInfo(a2)
    move.l  d0,a0
    move.l  O_BufferAddress(a2),a1
    move.l  O_BufferLength(a2),d0
    jsr _LVOppCrunchBuffer(a6)
    move.l  (sp)+,a6
    tst.l   d0
    bne.s   .noerr
    bpl.s   .noerr
    move.l  d7,d1
    Rbsr    L_CloseFile
    move.l  O_PPCrunchInfo(a2),a0
    move.l  a6,-(sp)
    move.l  O_PowerPacker(a2),a6
    jsr _LVOppFreeCrunchInfo(a6)
    move.l  (sp)+,a6
    Rbsr    L_FreeExtMem
    moveq.l #6,d0
    Rbra    L_Custom
.noerr  move.l  d5,a0
    move.l  d7,d1
    Rbsr    L_WriteFile
    sne.s   d5
    Rbsr    L_CloseFile
    move.l  O_PPCrunchInfo(a2),a0
    move.l  a6,-(sp)
    move.l  O_PowerPacker(a2),a6
    jsr _LVOppFreeCrunchInfo(a6)
    move.l  (sp)+,a6    
    Rbsr    L_FreeExtMem    
    tst.b   d5
    Rbne    L_IIOError
    rts

    Lib_Par      PPSave0       *** Pptodisk file$,sbank
    
    moveq.l #4,d0
    move.l  d0,-(a3)
    Rbra    L_PPSave1

    Lib_Par      PPUnpack      *** Ppunpack sbank To tbank
    
    dload   a2
    Rbsr    L_FreeExtMem
    Rbsr    L_PPOpenLib
    move.l  (a3)+,d7
    move.l  (a3)+,d0
    cmp.l   d0,d7
    Rbeq    L_IFonc
    Rjsr    L_Bnk.OrAdr
    move.l  d0,d5
    move.w  -12(a0),d0
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom
.noicon cmp.l   #'PP20',(a0)
    beq.s   .ppfou
    cmp.l   #'PX20',(a0)
    beq.s   .pxfou
    moveq.l #8,d0
    Rbra    L_Custom
.pxfou  moveq.l #7,d0
    Rbra    L_Custom
.ppfou  move.l  -20(a0),d6
    subq.l  #8,d6
    subq.l  #8,d6
    move.l  -4(a0,d6.l),d2
    lsr.l   #8,d2
    moveq.l #0,d1   ;Flags
    move.l  d7,d0           ;Number
    bpl.s   .nochip
    neg.l   d0
    moveq.l #(1<<Bnk_BitChip),d1
.nochip lea .bkwork(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq.s  L_IOoMem
    moveq.l #4,d0
    move.l  a0,a1
    move.l  d5,a0
    move.l  a6,-(sp)
    move.l  O_PowerPacker(a2),a6
    lea 4(a0),a2
    add.l   d6,a0
    jsr _LVOppDecrunchBuffer(a6)
    move.l  (sp)+,a6
    rts
.bkwork dc.b    'Work    '
    even
    
    Lib_Par      PPLoad        *** Ppfromdisk file$,tbank
    
    dload   a2
    Rbsr    L_FreeExtMem
    Rbsr    L_PPOpenLib
    move.l  4(a3),a0
    Rbsr    L_OpenFile
    Rbeq    L_IFNoFou
    move.l  d1,d7
    Rbsr    L_LengthOfFile
    move.l  d0,d6
    subq.l  #4,d6
    lea .minibu(pc),a0
    moveq.l #8,d0
    Rbsr    L_ReadFile
    beq.s   .norerr
.rerr   Rbsr    L_CloseFile
    Rbra    L_IIOError
.norerr cmp.l   #'PP20',(a0)
    beq.s   .ppfou
    cmp.l   #'PX20',(a0)
    beq.s   .pxfou
    cmp.l   #'IMP!',(a0)
    beq.s   .imfou
    Rbsr    L_CloseFile
    Rbra    L_WLoad
.imfou  Rbsr    L_CloseFile
    Rbra    L_ImploderLoad
.pxfou  Rbsr    L_CloseFile
    moveq.l #7,d0
    Rbsr    L_Custom
.ppfou  move.l  d6,d0
    moveq.l #1,d1
    move.l  a6,-(sp)
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  (sp)+,a6
    tst.l   d0
    bne.s   .gotmem
    move.l  d7,d1
    Rbsr    L_CloseFile
    Rbra    L_IOoMem
.gotmem move.l  d0,O_BufferAddress(a2)
    move.l  d6,O_BufferLength(a2)
    move.l  d0,a0
    move.l  .effptr(pc),(a0)+
    move.l  d7,d1
    move.l  d6,d0
    subq.l  #4,d0
    Rbsr    L_ReadFile
    beq.s   .noerr
    Rbsr    L_CloseFile
    Rbsr    L_FreeExtMem
    Rbra    L_IIOError
.noerr  Rbsr    L_CloseFile
    move.l  -8(a0,d6.l),d2
    lsr.l   #8,d2
    move.l  d2,d5
    moveq.l #0,d1           ;Flags
    move.l  (a3)+,d0        ;Number
    bpl.s   .nochip
    neg.l   d0
    moveq.l #(1<<Bnk_BitChip),d1
.nochip addq.l  #4,a3
    lea .bkwork(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq.s  L_IOoMem
    moveq.l #4,d0
    move.l  a0,a1
    move.l  O_BufferAddress(a2),a0
    move.l  a6,-(sp)
    move.l  O_PowerPacker(a2),a6
    move.l  a0,a2
    add.l   d6,a0
    jsr _LVOppDecrunchBuffer(a6)
    move.l  (sp)+,a6
    Rbsr    L_FreeExtMem
    rts
.minibu dc.l    0   ;'PP20'
.effptr dc.l    0   ;efficiency
.bkwork dc.b    'Work    '
    even
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
;;    include "Amcaf/Protracker.asm"
ciatalo equ $400
ciatahi equ $500
ciatblo equ $600
ciatbhi equ $700
ciacra  equ $E00
ciacrb  equ $F00

    Lib_Par      PTFreeVoice0      *** =Pt Free Voice
    moveq.l #15,d0
    move.l  d0,-(a3)
    Rbra    L_PTFreeVoice1

    Lib_Par      PTFreeVoice1      *** =Pt Free Voice(bitmask)
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    moveq.l #0,d2
    moveq.l #0,d3
    move.l  O_PTDataBase(a2),a1
    move.l  (a3)+,d7
    bne.s   .cont
    rts
.ret1   move.w  d7,d3
.quit   rts
.cont   and.w   #%1111,d7
    cmp.w   #1,d7
    beq.s   .ret1
    cmp.w   #2,d7
    beq.s   .ret1
    cmp.w   #4,d7
    beq.s   .ret1
    cmp.w   #8,d7
    beq.s   .ret1       

    moveq.l #0,d4

    btst    #3,d7
    beq.s   .ss4
    tst.b   MT_SfxEnable+3(a1)
    beq.s   .ss4
    moveq.l #8,d3
    addq.w  #1,d4
.ss4
    btst    #2,d7
    beq.s   .ss3
    tst.b   MT_SfxEnable+2(a1)
    beq.s   .ss3
    moveq.l #4,d3
    addq.w  #1,d4
.ss3
    btst    #1,d7
    beq.s   .ss2
    tst.b   MT_SfxEnable+1(a1)
    beq.s   .ss2
    moveq.l #2,d3
    addq.w  #1,d4
.ss2
    btst    #0,d7
    beq.s   .ss1
    tst.b   MT_SfxEnable(a1)
    beq.s   .ss1
    moveq.l #1,d3
    addq.w  #1,d4
.ss1
    cmp.w   #1,d4
    beq.s   .quit           ;just one free sfx channel
    tst.w   d4
    bne.s   .deep

    moveq.l #1,d1           ;search for voice with shortest duration
    moveq.l #0,d3
    move.w  #$FFFF,d4
    lea MT_VblDisable(a1),a0
.chlop1 move.w  (a0)+,d0
    move.w  d7,d5
    and.w   d1,d5
    beq.s   .skipch
    cmp.w   d0,d4
    bpl.s   .skipch
    move.w  d0,d4
    move.w  d1,d3
.skipch add.w   d1,d1
    cmp.w   #16,d1
    bne.s   .chlop1
    rts

.deep   moveq.l #0,d4
    tst.b   MT_SfxEnable(a1)
    beq.s   .sk1
    addq.w  #1,d4
.sk1    tst.b   MT_SfxEnable+1(a1)
    beq.s   .sk2
    addq.w  #2,d4
.sk2    tst.b   MT_SfxEnable+2(a1)
    beq.s   .sk3
    addq.w  #4,d4
.sk3    tst.b   MT_SfxEnable+3(a1)
    beq.s   .sk4
    addq.w  #8,d4
.sk4    and.w   d7,d4

    move.w  O_PTVblOn(a2),d0
    or.w    O_PTCiaOn(a2),d0
    tst.w   d0
    bne.s   .chmusi
.nomus  btst    #0,d4           ;no music, so just use any voice
    beq.s   .ll1
    moveq.l #1,d3
    rts
.ll1    btst    #1,d4
    beq.s   .ll2
    moveq.l #2,d3
    rts
.ll2    btst    #2,d4
    beq.s   .ll3
    moveq.l #4,d3
    rts
.ll3    moveq.l #8,d3
    rts

.chmusi moveq.l #0,d5           ;create non-music chanmask
    tst.b   MT_MusiEnable(a1)
    bne.s   .sv1
    addq.w  #1,d5
.sv1    tst.b   MT_MusiEnable+1(a1)
    bne.s   .sv2
    addq.w  #2,d5
.sv2    tst.b   MT_MusiEnable+2(a1)
    bne.s   .sv3
    addq.w  #4,d5
.sv3    tst.b   MT_MusiEnable+3(a1)
    bne.s   .sv4
    addq.w  #8,d5
.sv4    and.w   d4,d5
    tst.w   d5
    beq.s   .evndep
    move.w  d5,d4           ;select channel without music
    bra.s   .nomus

.evndep moveq.l #1,d1           ;search for voice with shortest replop
    moveq.l #0,d3
    move.w  #$FFFF,d6
    lea -318(a1),a0
.chlop2 move.w  14(a0),d0
    move.w  d4,d5
    and.w   d1,d5
    tst.w   d5
    beq.s   .skipc2
    cmp.w   d0,d6
    bcs.s   .skipc2
    cmp.w   #1,d0
    ble.s   .findsh
    move.w  d0,d6
    move.w  d1,d3
.skipc2 add.w   d1,d1
    lea 44(a0),a0
    cmp.w   #16,d1
    bne.s   .chlop2
    rts

.findsh move.w  8(a0),d0        ;Find shortest
    move.w  d4,d5
    and.w   d1,d5
    tst.w   d5
    beq.s   .skipc3
    cmp.w   #1,14(a0)
    bgt.s   .skipc3
    cmp.w   d0,d6
    bcs.s   .skipc3
    move.w  d0,d6
    move.w  d1,d3
.skipc3 add.w   d1,d1
    lea 44(a0),a0
    cmp.w   #16,d1
    bne.s   .findsh
    rts

    Lib_Par      PTCPattern        *** =Pt Cpattern
    
    dload   a2
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  O_PTDataBase(a2),a0
    move.b  MT_SongPos(a0),d3
    rts

    Lib_Par      PTCPos        *** =Pt Cpos
    
    dload   a2
    moveq.l #0,d3
    moveq.l #0,d2
    move.l  O_PTDataBase(a2),a0
    move.w  MT_PatternPos(a0),d3
    lsr.w   #4,d3
    rts

    Lib_Par      PTCInstr      *** =Pt Cinstr(channel)
    
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    cmp.b   #4,d7
    Rbge    L_IFonc
    dload   a2
    move.l  O_PTDataBase(a2),a0
    moveq.l #0,d3
    moveq.l #0,d2
    mulu    #44,d7
    lea -318(a0),a0
    move.b  N_Cmd(a0,d7),d3
    lsr.w   #4,d3
    rts

    Lib_Par      PTCNote       *** =Pt Cnote(channel)
    
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    cmp.b   #4,d7
    Rbge    L_IFonc
    dload   a2
    move.l  O_PTDataBase(a2),a0
    moveq.l #0,d3
    moveq.l #0,d2
    mulu    #44,d7
    lea -318(a0),a0
    move.w  N_Period(a0,d7.w),d3
    beq.s   .nul
    move.l  #3579545,d0
    exg d0,d3
    divu    d0,d3
    swap    d3
    clr.w   d3
    swap    d3
.nul    rts

    Lib_Par      PTSamVolume1      *** Pt Sam Volume volume
    
    dload   a2
    move.l  (a3)+,d0
    bpl.s   .cont1
    moveq.l #0,d0
.cont1  cmp.w   #64,d0
    ble.s   .cont2
    moveq.l #64,d0
.cont2  move.w  d0,O_PTSamVolume(a2)
    rts

    Lib_Par      PTSamVolume2      *** Pt Sam Volume voice,volume
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  O_PTDataBase(a2),a0
    lea MT_SfxEnable(a0),a1
    lea $DFF0A0,a0
    move.l  (a3)+,d3
    bpl.s   .cont1
    moveq.l #0,d3
.cont1  cmp.w   #64,d3
    ble.s   .cont2
    moveq.l #64,d3
.cont2  move.l  (a3)+,d0
    moveq.l #3,d7
.loop   btst    #0,d0
    beq.s   .skip
    tst.b   (a1)
    bne.s   .skip
    move.w  d3,8(a0)
.skip   addq.l  #1,a1
    lea $10(a0),a0
    lsr.w   #1,d0
    dbra    d7,.loop
    rts

    Lib_Par      PTSamFreq     *** Pt Sam Freq voice,volume
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  O_PTDataBase(a2),a0
    lea MT_SfxEnable(a0),a1
    lea $DFF0A0,a0
    move.l  (a3)+,d1
    bpl.s   .cont1
    moveq.l #0,d1
.cont1  cmp.w   #400,d1
    bgt.s   .cont2
    move.w  #400,d1
.cont2  cmp.w   #30000,d1
    blt.s   .cont3
    move.w  #30000,d1
.cont3  move.l  #3579545,d3
    divu    d1,d3
    move.l  (a3)+,d0
    moveq.l #3,d7
.loop   btst    #0,d0
    beq.s   .skip
    tst.b   (a1)
    bne.s   .skip
    move.w  d3,6(a0)
.skip   addq.l  #1,a1
    lea $10(a0),a0
    lsr.w   #1,d0
    dbra    d7,.loop
    rts

    Lib_Par      PTSamStop     *** Pt Sam Stop voice
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  O_PTDataBase(a2),a0
    lea MT_SfxEnable(a0),a1
    lea $DFF0A0,a0
    move.l  (a3)+,d0
    moveq.l #1,d1
    moveq.l #3,d7
.loop   btst    #0,d0
    beq.s   .skip
    st  (a1)
    move.w  d1,$DFF096
    clr.w   $8(a0)
.skip   lsl.w   #1,d1
    addq.l  #1,a1
    lea $10(a0),a0
    lsr.w   #1,d0
    dbra    d7,.loop
    rts

    Lib_Par      PTRawPlay     *** Pt Raw Play voice,adr,len,fre
    
    moveq.l #0,d6
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    bpl.s   .noloop
    neg.l   d7
    moveq.l #1,d6
.noloop move.l  (a3)+,a0
    move.l  (a3)+,d2
    Rbra    L_PTPlaySam

    Lib_Par      PTSamBank     *** Pt Sam Bank bank
    
    dload   a2
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  d0,O_PTSamBank(a2)
    rts

    Lib_Par      PTSamPlay1        *** Pt Sam Play samnr
    
    dload   a2
    move.l  O_PTSamBank(a2),d0
    Rbeq    L_IFonc
    move.l  d0,a0
    moveq.l #0,d6
    move.l  (a3)+,d7
    Rbeq    L_IFonc
    bpl.s   .noloop
    neg.l   d7
    moveq.l #1,d6
.noloop cmp.w   (a0),d7
    Rbhi    L_IFonc
    add.w   d7,d7
    add.w   d7,d7
    add.l   -2(a0,d7.w),a0
    addq.l  #8,a0
    move.w  (a0)+,d1
    move.l  (a0)+,d0
;   add.l   d0,d0
    moveq.l #15,d2
    Rbra    L_PTPlaySam

    Lib_Par      PTSamPlay2        *** Pt Sam Play voice,samnr
    
    dload   a2
    move.l  O_PTSamBank(a2),d0
    Rbeq    L_IFonc
    move.l  d0,a0
    moveq.l #0,d6
    move.l  (a3)+,d7
    Rbeq    L_IFonc
    bpl.s   .noloop
    neg.l   d7
    moveq.l #1,d6
.noloop cmp.w   (a0),d7
    Rbhi    L_IFonc
    add.w   d7,d7
    add.w   d7,d7
    add.l   -2(a0,d7.w),a0
    addq.l  #8,a0
    move.w  (a0)+,d1
    move.l  (a0)+,d0
;   add.l   d0,d0
    move.l  (a3)+,d2
    Rbra    L_PTPlaySam

    Lib_Par      PTSamPlay3        *** Pt Sam Play voice,samnr,freq
    
    dload   a2
    move.l  O_PTSamBank(a2),d0
    Rbeq    L_IFonc
    move.l  d0,a0
    moveq.l #0,d6
    move.l  (a3)+,d1
    move.l  (a3)+,d7
    Rbeq    L_IFonc
    bpl.s   .noloop
    neg.l   d7
    moveq.l #1,d6
.noloop cmp.w   (a0),d7
    Rbhi    L_IFonc
    add.w   d7,d7
    add.w   d7,d7
    add.l   -2(a0,d7.w),a0
    lea 10(a0),a0
    move.l  (a0)+,d0
;   add.l   d0,d0
    move.l  (a3)+,d2
    Rbra    L_PTPlaySam

    Lib_Par      PTDataBase        *** =Pt Data Base
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  O_PTDataBase(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      PTInstrPlay1      *** Pt Instr Play samnr
    
    move.l  (a3)+,d0
    moveq.l #15,d1
    move.l  d1,-(a3)
    move.l  d0,-(a3)
    move.l  #15625,-(a3)
    Rbra    L_PTInstrPlay3

    Lib_Par      PTInstrPlay2      *** Pt Instr Play voice,samnr
    
    move.l  #15625,-(a3)
    Rbra    L_PTInstrPlay3

    Lib_Par      PTInstrPlay3      *** Pt Instr Play voice,samnr,freq
    
    dload   a2
    moveq.l #0,d6
    move.l  (a3)+,-(sp)
    move.l  (a3)+,d0
    bpl.s   .cont
    neg.l   d0
    moveq.l #1,d6
.cont   move.l  d0,-(a3)
    Rbsr    L_PTInstrAdr
    move.l  d3,-(sp)
    subq.l  #4,a3
    Rbsr    L_PTInstrLen
    move.l  d3,d0
    move.l  (sp)+,a0
    move.l  (sp)+,d1
    move.l  (a3)+,d2
    Rbra    L_PTPlaySam

    Lib_Par      PTInstrAdr        *** =Pt Instr Address(samnr)
    
    dload   a2
    move.l  O_PTAddress(a2),d0
    Rbeq    L_IFonc
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    Rbeq    L_IFonc
    cmp.w   #31,d0
    Rbhi    L_IFonc
    add.l   d0,d0
    add.l   d0,d0
    lea MT_SongDataPtr(a0),a0
    move.l  -32*4(a0,d0.w),d3
    moveq.l #0,d2
    rts

    Lib_Par      PTInstrLen        *** =Pt Instr Length(samnr)
    
    dload   a2
    move.l  O_PTAddress(a2),d0
    Rbeq    L_IFonc
    move.l  d0,a0
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    Rbeq    L_IFonc
    cmp.w   #31,d0
    Rbhi    L_IFonc
    mulu    #30,d0
    moveq.l #0,d3
    move.w  20+22-30(a0,d0.w),d3
    add.l   d3,d3
    moveq.l #0,d2
    rts

    Lib_Par      PTCiaSpeed        *** Pt Cia Speed bpm
    
    dload   a2
    move.l  (a3)+,d1
    beq.s   .vbl
    clr.w   O_PTCiaVbl(a2)
    tst.w   O_PTVblOn(a2)
    beq.s   .novbl
    move.l  d1,-(sp)
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.w  d1,MT_CiaSpeed(a0)
    Rbsr    L_PTTurnVblOff
    Rbsr    L_PTTurnCiaOn
    move.l  (sp)+,d1
.novbl  move.l  O_PTDataBase(a2),a0
    move.w  d1,MT_CiaSpeed(a0)
    moveq.l #5,d0
    Rbra    L_PT_Routines
.vbl    move.w  #-1,O_PTCiaVbl(a2)
    tst.w   O_PTCiaOn(a2)
    beq.s   .nocia
    Rbsr    L_PTTurnCiaOff
    Rbra    L_PTTurnVblOn
.nocia  rts

    Lib_Par      PTVumeter     *** =Pt Vu(channel)
    
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    cmp.b   #4,d7
    Rbge    L_IFonc
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    moveq.l #0,d3
    moveq.l #0,d2
    move.b  MT_Vumeter(a0,d7.w),d3
    clr.b   MT_Vumeter(a0,d7.w)
    rts

    Lib_Par      PTVolume      *** Pt Volume vol
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  (a3)+,d0
    bpl.s   .higher
    moveq.l #0,d0
.higher cmp.w   #$40,d0
    bls.s   .nottop
    moveq.l #$40,d0
.nottop move.w  d0,MT_Volume(a0)
    rts

    Lib_Par      PTVoice       *** Pt Voice bitmap
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  (a3)+,d0
    moveq.l #-1,d1
    move.l  d1,MT_MusiEnable(a0)
    lea $DFF000,a1
    btst    #0,d0
    bne.s   .nov1
    move.w  #1,$096(a1)
    clr.w   $0A8(a1)
    clr.b   MT_MusiEnable(a0)
.nov1   btst    #1,d0
    bne.s   .nov2
    move.w  #2,$096(a1)
    clr.w   $0B8(a1)
    clr.b   MT_MusiEnable+1(a0)
.nov2   btst    #2,d0
    bne.s   .nov3
    move.w  #4,$096(a1)
    clr.w   $0C8(a1)
    clr.b   MT_MusiEnable+2(a0)
.nov3   btst    #3,d0
    bne.s   .nov4
    move.w  #8,$096(a1)
    clr.w   $0D8(a1)
    clr.b   MT_MusiEnable+3(a0)
.nov4   rts

    Lib_Par      PTBank        *** Pt Bank bank
    
    dload   a2
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a0
    move.l  d0,O_PTAddress(a2)
    cmp.l   #$200000,a0
    Rbge    L_IFonc
    moveq.l #0,d1
    moveq.l #1,d0
    Rbra    L_PT_Routines

    Lib_Par      PTPlay1       *** Pt Play bank
    
    clr.l   -(a3)
    Rbra    L_PTPlay2

    Lib_Par      PTPlay2       *** Pt Play bank,songpos
    
    dload   a2
    Rbsr    L_PTStop
    move.l  (a3)+,d7
    move.l  (a3)+,d0
    move.l  d0,O_PTBank(a2)
    Rjsr    L_Bnk.OrAdr
    move.l  d0,a0
    move.l  d0,O_PTAddress(a2)
    cmp.l   #$200000,a0
    Rbge    L_IFonc
    move.l  d7,d1
    moveq.l #1,d0
    Rbsr    L_PT_Routines
    tst.w   O_PTCiaVbl(a2)
    Rbeq    L_PTTurnCiaOn
    Rbra    L_PTTurnVblOn

    Lib_Par      PTContinue        *** Pt Contiune
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    move.l  O_PTAddress(a2),d0
    Rbeq    L_IFonc
    cmp.l   #$200000,d0
    Rbge    L_IFonc
    tst.w   O_PTCiaVbl(a2)
    Rbeq    L_PTTurnCiaOn
    Rbra    L_PTTurnVblOn

    Lib_Par      PTStop        *** Pt Stop
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    tst.w   O_PTCiaOn(a2)
    bne.s   .cont
    tst.w   O_PTVblOn(a2)
    bne.s   .cont
    rts
.cont   Rbsr    L_PTTurnCiaOff
    Rbsr    L_PTTurnVblOff
    moveq.l #3,d0
    Rbra    L_PT_Routines

    Lib_Par      PTSignal      *** =Pt Signal
    
    dload   a2
    moveq.l #4,d0
    Rbsr    L_PT_Routines
    moveq.l #0,d3
    moveq.l #0,d2
    move.b  MT_Signal(a0),d3
    clr.b   MT_Signal(a0)
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
;;    include "Amcaf/PTile.asm"
    Lib_Par      PTileBank     *** Ptile Bank n
    
    dload   a2
    move.l  (a3)+,d0
    move.l  d0,O_PTileBank(a2)
    rts

    Lib_Par      PastePTile        *** Paste Ptile x,y,c
    
    dload   a2
    moveq.l #0,d4
    move.l  O_PTileBank(a2),d0
    Rbeq    L_IFonc
    Rjsr    L_Bnk.OrAdr
    move.l  (a3)+,d7
    cmp.w   (a0)+,d7
    Rbge    L_IFonc
    move.w  (a0)+,d0
    move.w  d0,d5
    lsl.l   #5,d7
    moveq.l #0,d6
.loop   add.l   d7,d6
    dbra    d0,.loop
    lea (a0,d6.l),a1
    move.l  ScOnAd(a5),a0
    moveq.l #0,d0
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    move.w  d0,d4
    move.l  (a3)+,d1
    lsl.w   #4,d1
    mulu    d1,d0
    move.l  (a3)+,d1
    add.l   d1,d0
    add.l   d1,d0
    movem.l a3-a6,-(sp)
    move.l  d4,d7
    add.l   d7,d7
.cloop  move.l  (a0)+,a2
    add.l   d0,a2
    rept    2
    movem.w (a1)+,d1-d3/d6/a3-a6
    move.w  d1,(a2)
    move.w  d2,(a2,d4.w)
    add.l   d7,a2
    move.w  d3,(a2)
    move.w  d6,(a2,d4.w)
    add.l   d7,a2
    move.w  a3,(a2)
    move.w  a4,(a2,d4.w)
    add.l   d7,a2
    move.w  a5,(a2)
    move.w  a6,(a2,d4.w)
    add.l   d7,a2
    endr
    dbra    d5,.cloop
    movem.l (sp)+,a3-a6
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
;;    include "Amcaf/Qfunctions.asm"
    Lib_Par      QSqr          *** =Qsqr(value)
    
    move.l  (a3)+,d2
    bne.s   .cont
.null   moveq.l #0,d3
    rts
.cont   Rbmi    L_IFonc
    moveq.l #1,d6
    swap    d6
    cmp.l   d6,d2
    bge.s   .bignum
    moveq.l #0,d0
    move.l  d2,d3
.loop   move.l  d3,d4
    move.l  d2,d3
    divu    d4,d3
    and.l   #$FFFF,d3
    add.l   d4,d3
    lsr.l   d3
    addx.l  d0,d3
    cmp.l   d3,d4
    bne.s   .loop
    moveq.l #0,d2
    rts
.bignum moveq.l #0,d5
.argl   addq.w  #1,d5
    lsr.l   #2,d2
    cmp.l   d6,d2
    bge.s   .argl
    tst.w   d2
    bne.s   .cont2
    moveq.l #1,d2
    bra.s   .null2
.cont2  moveq.l #0,d0
    move.l  d2,d3
.loop2  move.l  d3,d4
    move.l  d2,d3
    divu    d4,d3
    and.l   #$FFFF,d3
    add.l   d4,d3
    lsr.l   d3
    addx.l  d0,d3
    cmp.l   d3,d4
    bne.s   .loop2
.null2  lsl.l   d5,d3
    moveq.l #0,d2
    rts

    Lib_Par      QRnd          *** =Qrnd(number)
    
    dload   a2
    moveq.l #0,d2
    move.w  $DFF006,d1
    rol.w   d1,d1
    add.w   d1,O_QRndSeed(a2)
    move.l  (a3)+,d0
    beq.s   .last
    move.w  O_QRndSeed(a2),d3
    lsr.w   d3
    moveq.l #15,d1
    mulu    d0,d3
    lsr.l   d1,d3
    addx.l  d2,d3
    move.w  d3,O_QRndLast(a2)
    rts
.last   moveq.l #0,d3
    move.w  O_QRndLast(a2),d3
    rts

    Lib_Par      QCos          *** =Qcos(angle,factor)
    
    add.w   #256,6(a3)
    Rbra    L_QSin

    Lib_Par      QSin          *** =Qsin(angle,factor)
    
    dload   a2
    move.l  O_SineTable(a2),a0
    moveq.l #0,d2
    move.l  (a3)+,d0
    bne.s   .cont
    addq.l  #4,a3
    moveq.l #0,d3
    rts
.cont   move.l  (a3)+,d1
    and.w   #$3ff,d1
    add.w   d1,d1
    move.w  (a0,d1.w),d3
    muls    d0,d3
    asr.l   #8,d3
    addx.w  d2,d3
    ext.l   d3
    rts

    Lib_Par      QArc          *** =Qarc(dx,dy)
    
    dload   a2
    move.l  O_TanTable(a2),a0
    move.l  (a3)+,d7
    move.l  (a3)+,d6
    bne.s   .nz
    tst.w   d7
    bne.s   .nz
    moveq.l #0,d3
    moveq.l #0,d2
    rts
.nz move.l  d6,d4
    bpl.s   .nonegx
    neg.l   d4
.nonegx move.l  d7,d5
    bpl.s   .nonegy
    neg.l   d5
.nonegy cmp.l   d5,d4
    bpl.s   .belo45
    lsl.l   #8,d4
    moveq.l #0,d3
    add.l   d4,d4
    moveq.l #0,d2
    divu    d5,d4
    move.b  (a0,d4.w),d3
    neg.w   d3
;   add.w   #768,d3
    add.w   #256,d3
    bra.s   .goon
.belo45 lsl.l   #8,d5
    moveq.l #0,d3
    add.l   d5,d5
    moveq.l #0,d2
    divu    d4,d5
    move.b  (a0,d5.w),d3
;   add.w   #512,d3
.goon   tst.w   d6
    bpl.s   .xhi
    tst.w   d7
    bpl.s   .yhi1
    sub.w   #512,d3
    bra.s   .cont
.yhi1   neg.w   d3
    add.w   #512,d3
    bra.s   .cont
.xhi    tst.w   d7
    bpl.s   .cont
    neg.w   d3
;   bra.s   .cont
.cont
    and.w   #$3ff,d3
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
;;    include "Amcaf/RNC.asm"
    Lib_Par      RNCUnpack     *** Rnc Unpack sbank To tbank
    
    move.l  (a3)+,d5
    move.l  (a3)+,d0
    rts
    cmp.l   d0,d5
    Rbeq.s  L_IFonc
    Rjsr    L_Bnk.OrAdr
    cmp.l   d0,d5
    Rbeq.s  L_IFonc
    move.w  -12(a0),d0
    and.w   #%1100,d0
    tst.w   d0
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom
.noicon move.l  a0,-(sp)
    cmp.l   #$524E4301,(a0)+
    beq.s   .noerr
    moveq.l #2,d0
    Rbra    L_Custom
.noerr  move.l  (a0)+,d2
    moveq.l #0,d1
    move.l  d5,d0
    bpl.s   .nochip
    neg.l   d0
    moveq.l #(1<<Bnk_BitChip),d1
.nochip lea .bkwork(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,a1
    move.l  (sp)+,a0
;    bra.s   Unpack
.bkwork dc.b    'Work    '
    even








;    include "s/RNCUnpack.lnk"

    Lib_Par      RobNothern        *** =Rnp
    
    IFEQ    1
    movem.l a3-a6,-(sp)
    dload   a2
    Rbsr    L_FreeExtMem
    move.l  #(.endrob-.startrob),d0
    move.l  d0,d5
    move.l  #$10003,d1
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    tst.l   d0
    Rbeq    L_IOoMem
    move.l  d0,O_BufferAddress(a2)
    move.l  d5,O_BufferLength(a2)
    move.l  d0,a1
    move.l  d0,a2
    lea .startrob(pc),a0
    lsr.l   d5
    subq.l  #1,d5
.loop   move.w  (a0)+,(a1)+
    dbra    d5,.loop
    jsr (a2)
    move.l  d0,d3
    Rbsr    L_FreeExtMem
    movem.l (sp)+,a3-a6
    moveq.l #0,d2
    rts
    Rdata
.startrob
    incbin  "Data/CopyProtection.bin"
    even
.endrob
    ELSE
    rts
    ENDC
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
;;    include "Amcaf/ScanStr.asm"
    Lib_Par      ScanStr       *** =Scan$(scancode)
    
    move.l  (a3)+,d0
    cmp.w   #103,d0
    Rbhi    L_IFonc
    and.b   #$7f,d0
    lea .scanam(pc),a0
    tst.b   d0
    beq.s   .found
.loop   tst.b   (a0)+
    bne.s   .loop
    subq.b  #1,d0
    beq.s   .found
    bra.s   .loop
.found  tst.b   (a0)
    Rbeq    L_IFonc
    moveq.l #2,d2
    Rbra    L_MakeAMOSString

    Rdata
.scanam dc.b    "`",0,"1",0,"2",0,"3",0,"4",0,"5",0,"6",0,"7",0
    dc.b    "8",0,"9",0,"0",0,"ß",0,"",0,"\",0,0,"keypad 0",0
    dc.b    "q",0,"w",0,"e",0,"r",0,"t",0,"z",0,"u",0,"i",0
    dc.b    "o",0,"p",0,"ü",0,"+",0,0,"keypad 1",0,"keypad 2",0,"keypad 3",0
    dc.b    "a",0,"s",0,"d",0,"f",0,"g",0,"h",0,"j",0,"k",0
    dc.b    "l",0,"ö",0,"ä",0,"#",0,0,"keypad 4",0,"keypad 5",0,"keypad 6",0
    dc.b    "<",0,"y",0,"x",0,"c",0,"v",0,"b",0,"n",0,"m",0
    dc.b    ",",0,".",0,"-",0,0,"keypad .",0,"keypad 7",0,"keypad 8",0,"keypad 9",0
    dc.b    "space",0,"backspace",0,"tab",0,"enter",0,"return",0,"escape",0,"del",0,0
    dc.b    0,0,"keypad -",0,0,"curs up",0,"curs down",0,"curs right",0,"curs left",0
    dc.b    "F 1",0,"F 2",0,"F 3",0,"F 4",0,"F 5",0,"F 6",0,"F 7",0,"F 8",0
    dc.b    "F 9",0,"F10",0,"keypad [",0,"keypad ]",0,"keypad /",0,"keypad *",0,"keypad +",0,"help",0
    dc.b    "l-shift",0,"r-shift",0,"caps lock",0,"ctrl",0,"l-alt",0,"r-alt",0,"l-amiga",0,"r-amiga",0
;   dc.b    0,0,0,0,0,0,0,0
;   ds.b    16
    even
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
;;    include "Amcaf/Scrn.asm"
    Lib_Par      ScreenRastport    *** =Scrn Rastport
    
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_RastPort(a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      ScreenBitmap      *** =Scrn Bitmap
    
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_BitMap(a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      ScreenLayerInfo   *** =Scrn Layerinfo
    
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_LayerInfo(a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      ScreenLayer       *** =Scrn Layer
    
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_Layer(a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      ScreenRegion      *** =Scrn Region
    
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_Region(a0),d3
    moveq.l #0,d2
    rts

    IFEQ    1
    Lib_Par      ScrnOpen      *** Screen Open s,w,h,c,mode
    move.l  (a3)+,d6        ;mode
    move.l  (a3)+,d5        ;c
    move.l  (a3)+,d3        ;h: right
    move.l  (a3)+,d2        ;w: right
    move.l  (a3)+,d4        ;s: right
    EcCall  Cree
    rts
    ENDC
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
;;    include "Amcaf/ShadeBobs.asm"
    Lib_Par      ShadeBobMask      *** Shade Bob Mask flag
    
    dload   a2
    move.l  (a3)+,d0
    beq.s   .nomask
    move.w  #1,O_SBobMask(a2)
    rts
.nomask clr.w   O_SBobMask(a2)
    rts

    Lib_Par      ShadeBobPlanes    *** Shade Bob Planes planes
    
    dload   a2
    move.l  (a3)+,d0
    Rbeq    L_IFonc
    Rbmi    L_IFonc
    moveq.l #6,d1
    cmp.l   d1,d0
    Rbhi    L_IFonc
    subq.w  #1,d0
    move.w  d0,O_SBobPlanes(a2)
    rts

    Lib_Par      ShadeBobUp        *** Shade Bob Up s,x,y,i
    
    dload   a2
    movem.l a5/a6,-(sp)
    Rbsr    L_GetBobInfos
    tst.w   d6
    bmi .end
    move.w  O_BobX(a2),d0
    and.w   #%1111,d0
    tst.w   d0
    bne .shifte
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    mulu    d0,d3
    subq.w  #1,d6
    bmi.s   .end
    move.w  O_BobWidth(a2),d7
    moveq.l #0,d0
    move.w  O_BobX(a2),d0
    bpl.s   .nolcli
    neg.w   d0
    lsr.w   #4,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    add.w   d0,a5
    move.w  d0,O_SBobImageMod(a2)
    bra.s   .skiplc
.nolcli clr.w   O_SBobImageMod(a2)
    lsr.w   #4,d0
    add.l   d0,d3
    add.l   d0,d3
.skiplc move.w  d7,d0
    subq.w  #1,d0
    lsl.w   #4,d0
    add.w   O_BobX(a2),d0
    sub.w   EcTx(a0),d0
    bmi.s   .norcli
    lsr.w   #4,d0
    addq.w  #1,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    add.w   d0,O_SBobImageMod(a2)
.norcli subq.w  #1,d7
    bmi.s   .end
    move.w  d7,O_SBobWidth(a2)
.yloop  move.w  O_SBobWidth(a2),d7
.xloop  move.w  (a5)+,d1
    beq.s   .nomani
    move.w  O_SBobPlanes(a2),d5
    move.l  a6,a0
.ploop  move.l  (a0)+,a1
    add.l   d3,a1
    move.w  (a1),d0
    move.w  d0,d2
    eor.w   d1,d0
    move.w  d0,(a1)
    and.w   d2,d1
    dbra    d5,.ploop
.nomani addq.l  #2,d3
    dbra    d7,.xloop
    add.w   O_SBobImageMod(a2),a5
    add.l   d4,d3
    dbra    d6,.yloop
.end    movem.l (sp)+,a5/a6
    rts
.shifte move.w  d0,O_SBobLsr(a2)
    neg.w   d0
    add.w   #16,d0
    move.w  d0,O_SBobLsl(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    mulu    d0,d3
    subq.w  #1,d6
    bmi.s   .end
    move.w  O_BobWidth(a2),d7
    moveq.l #0,d0
    move.w  O_BobX(a2),d0
    bpl.s   .nolcl2
    neg.w   d0
    lsr.w   #4,d0
    addq.w  #1,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    add.w   d0,a5
    st  O_SBobFirst(a2)
    move.w  d0,O_SBobImageMod(a2)
    bra.s   .skipl2
.nolcl2 clr.w   O_SBobImageMod(a2)
    clr.b   O_SBobFirst(a2)
    lsr.w   #4,d0
    add.l   d0,d3
    add.l   d0,d3
.skipl2 clr.b   O_SBobLast(a2)
    addq.w  #1,d7
    move.w  d7,d0
    subq.w  #1,d0
    lsl.w   #4,d0
    add.w   O_BobX(a2),d0
    sub.w   EcTx(a0),d0
    bmi.s   .norcl2
    lsr.w   #4,d0
    addq.w  #1,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    subq.w  #2,d0
    add.w   d0,O_SBobImageMod(a2)
    st  O_SBobLast(a2)
.norcl2 subq.w  #2,d4
    subq.w  #1,d7
    bmi .end
    move.w  d7,O_SBobWidth(a2)
.yloop2 move.w  O_SBobWidth(a2),d7
    tst.b   O_SBobFirst(a2)
    bne.s   .xloop2
    move.w  (a5)+,d1
    move.w  O_SBobLsr(a2),d0
    lsr.w   d0,d1
    bra.s   .first2
.last   tst.b   O_SBobLast(a2)
    bne.s   .first
    move.w  -2(a5),d1
    move.w  O_SBobLsl(a2),d0
    lsl.w   d0,d1
    bra.s   .first2
.xloop2 tst.w   d7
    beq.s   .last
.first  move.w  -2(a5),d5
    move.w  O_SBobLsl(a2),d0
    lsl.w   d0,d5
    move.w  (a5)+,d1
.last2  move.w  O_SBobLsr(a2),d0
    lsr.w   d0,d1
    or.w    d5,d1
.first2 move.w  O_SBobPlanes(a2),d5
    move.l  a6,a0
.ploop2 move.l  (a0)+,a1
    add.l   d3,a1
    move.w  (a1),d0
    move.w  d0,d2
    eor.w   d1,d0
    move.w  d0,(a1)
    and.w   d2,d1
    dbra    d5,.ploop2
.noman2 addq.l  #2,d3
    dbra    d7,.xloop2
    add.w   O_SBobImageMod(a2),a5
    add.l   d4,d3
    dbra    d6,.yloop2
    movem.l (sp)+,a5/a6
    rts

    Lib_Par      ShadeBobDown      *** Shade Bob Down s,x,y,i
    
    dload   a2
    movem.l a5/a6,-(sp)
    Rbsr    L_GetBobInfos
    tst.w   d6
    bmi .end
    move.w  O_BobX(a2),d0
    and.w   #%1111,d0
    tst.w   d0
    bne .shifte
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    mulu    d0,d3
    subq.w  #1,d6
    bmi.s   .end
    move.w  O_BobWidth(a2),d7
    moveq.l #0,d0
    move.w  O_BobX(a2),d0
    bpl.s   .nolcli
    neg.w   d0
    lsr.w   #4,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    add.w   d0,a5
    move.w  d0,O_SBobImageMod(a2)
    bra.s   .skiplc
.nolcli clr.w   O_SBobImageMod(a2)
    lsr.w   #4,d0
    add.l   d0,d3
    add.l   d0,d3
.skiplc move.w  d7,d0
    subq.w  #1,d0
    lsl.w   #4,d0
    add.w   O_BobX(a2),d0
    sub.w   EcTx(a0),d0
    bmi.s   .norcli
    lsr.w   #4,d0
    addq.w  #1,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    add.w   d0,O_SBobImageMod(a2)
.norcli subq.w  #1,d7
    bmi.s   .end
    move.w  d7,O_SBobWidth(a2)
.yloop  move.w  O_SBobWidth(a2),d7
.xloop  move.w  (a5)+,d1
    beq.s   .nomani
    move.w  O_SBobPlanes(a2),d5
    move.l  a6,a0
.ploop  move.l  (a0)+,a1
    add.l   d3,a1
    move.w  (a1),d0
    eor.w   d1,d0
    move.w  d0,(a1)
    and.w   d0,d1
    dbra    d5,.ploop
.nomani addq.l  #2,d3
    dbra    d7,.xloop
    add.w   O_SBobImageMod(a2),a5
    add.l   d4,d3
    dbra    d6,.yloop
.end    movem.l (sp)+,a5/a6
    rts
.shifte move.w  d0,O_SBobLsr(a2)
    neg.w   d0
    add.w   #16,d0
    move.w  d0,O_SBobLsl(a2)
    move.w  EcTx(a0),d0
    lsr.w   #3,d0
    mulu    d0,d3
    subq.w  #1,d6
    bmi.s   .end
    move.w  O_BobWidth(a2),d7
    moveq.l #0,d0
    move.w  O_BobX(a2),d0
    bpl.s   .nolcl2
    neg.w   d0
    lsr.w   #4,d0
    addq.w  #1,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    add.w   d0,a5
    st  O_SBobFirst(a2)
    move.w  d0,O_SBobImageMod(a2)
    bra.s   .skipl2
.nolcl2 clr.w   O_SBobImageMod(a2)
    clr.b   O_SBobFirst(a2)
    lsr.w   #4,d0
    add.l   d0,d3
    add.l   d0,d3
.skipl2 clr.b   O_SBobLast(a2)
    addq.w  #1,d7
    move.w  d7,d0
    subq.w  #1,d0
    lsl.w   #4,d0
    add.w   O_BobX(a2),d0
    sub.w   EcTx(a0),d0
    bmi.s   .norcl2
    lsr.w   #4,d0
    addq.w  #1,d0
    sub.w   d0,d7
    add.w   d0,d0
    add.w   d0,d4
    subq.w  #2,d0
    add.w   d0,O_SBobImageMod(a2)
    st  O_SBobLast(a2)
.norcl2 subq.w  #2,d4
    subq.w  #1,d7
    bmi .end
    move.w  d7,O_SBobWidth(a2)
.yloop2 move.w  O_SBobWidth(a2),d7
    tst.b   O_SBobFirst(a2)
    bne.s   .xloop2
    move.w  (a5)+,d1
    move.w  O_SBobLsr(a2),d0
    lsr.w   d0,d1
    bra.s   .first2
.last   tst.b   O_SBobLast(a2)
    bne.s   .first
    move.w  -2(a5),d1
    move.w  O_SBobLsl(a2),d0
    lsl.w   d0,d1
    bra.s   .first2
.xloop2 tst.w   d7
    beq.s   .last
.first  move.w  -2(a5),d5
    move.w  O_SBobLsl(a2),d0
    lsl.w   d0,d5
    move.w  (a5)+,d1
.last2  move.w  O_SBobLsr(a2),d0
    lsr.w   d0,d1
    or.w    d5,d1
.first2 move.w  O_SBobPlanes(a2),d5
    move.l  a6,a0
.ploop2 move.l  (a0)+,a1
    add.l   d3,a1
    move.w  (a1),d0
    eor.w   d1,d0
    move.w  d0,(a1)
    and.w   d0,d1
    dbra    d5,.ploop2
.noman2 addq.l  #2,d3
    dbra    d7,.xloop2
    add.w   O_SBobImageMod(a2),a5
    add.l   d4,d3
    dbra    d6,.yloop2
    movem.l (sp)+,a5/a6
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
;;    include "Amcaf/Splinters.asm"
    Lib_Par      SplinterBank      *** Splinters Bank bank,splinters
    
    dload   a2
    move.l  (a3)+,d2
    Rbeq    L_IFonc
    moveq.l #0,d1
    move.l  (a3)+,d0
    move.w  d2,d4
    subq.w  #1,d4
    move.w  d4,O_NumSpli(a2)
    mulu    #Sp_SizeOf,d2
    lea .bkspli(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,O_SpliBank(a2)
    rts
.bkspli dc.b    'Splinter'
    even

    Lib_Par      SplinterMax       *** Splinters Max splinters
    
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_MaxSpli(a2)
    rts

    Lib_Par      SplinterFuel      *** Splinters Fuel
    
    dload   a2
    move.l  (a3)+,d0
    move.w  d0,O_SpliFuel(a2)
    rts

    Lib_Par      SplinterLimitAll  *** Splinters Limit
    
    dload   a2
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    clr.l   O_SpliLimits(a2)
    move.w  EcTx(a0),d0
    lsl.w   #4,d0
    subq.w  #1,d0
    swap    d0
    move.w  EcTy(a0),d0
    lsl.w   #4,d0
    subq.w  #1,d0
    move.l  d0,O_SpliLimits+4(a2)
    rts

    Lib_Par      SplinterLimit     *** Splinters Limit x1,y1 To x2,y2
    
    dload   a2
    lea O_SpliLimits(a2),a0
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    lsl.w   #4,d0
    lsl.w   #4,d1
    lsl.w   #4,d2
    lsl.w   #4,d3
    subq.l  #1,d2
    subq.l  #1,d3
    cmp.w   d0,d2
    bhi.s   .noswp1
    exg d0,d2
.noswp1 cmp.w   d1,d3
    bhi.s   .noswp2
    exg d1,d3
.noswp2 move.w  d0,(a0)+
    move.w  d1,(a0)+
    move.w  d2,(a0)+
    move.w  d3,(a0)+
    rts

    Lib_Par      SplinterGravity   *** Splinters Gravity sx,sy
    
    dload   a2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.w  d0,O_SpliGravity(a2)
    move.w  d1,O_SpliGravity+2(a2)
    rts

    Lib_Par      SplinterColor     *** Splinters Colour bkcol,planes
    
    dload   a2
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  EcNPlan(a1),d0
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    subq.w  #1,d2
    cmp.w   d2,d0
    Rble    L_IFonc
    move.w  d2,O_SpliPlanes(a2)
    move.w  d1,O_SpliBkCol(a2)
    rts

    Lib_Par      SplinterInit      *** Splinters Init
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    moveq.l #-1,d0
    lea Sp_Col(a0),a0
.stloop move.l  d0,(a0)
    lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop
    rts

    Lib_Par      SplinterDo1       *** Splinters Single Do
    
    Rbsr    L_SplinterDel1
    Rbsr    L_SplinterMove
    Rbsr    L_SplinterBack
    Rbra    L_SplinterDraw

    Lib_Par      SplinterDo2       *** Splinters Double Do
    
    Rbsr    L_SplinterDel2
    Rbsr    L_SplinterMove
    Rbsr    L_SplinterBack
    Rbra    L_SplinterDraw

    Lib_Par      SplinterDel1      *** Splinters Single Del
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  O_SpliPlanes(a2),d4
    move.l  a1,-(sp)
    move.l  a0,d6
.stloop move.b  Sp_BkCol(a0),d5
    cmp.b   #$FF,d5
    beq.s   .quit
    tst.b   Sp_First(a0)
    bne.s   .quit
    move.l  Sp_Pos(a0),d1
    move.b  d1,d2
    not.b   d2
    lsr.l   #3,d1
    move.w  d4,d0
    moveq.l #0,d3
    move.l  (sp),a1
.sloop2 move.l  (a1)+,a2
    btst    d3,d5
    bne.s   .setbi2
    bclr    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop2
    bra.s   .quit
.setbi2 bset    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop2
.quit   lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop

    dload   a2
    move.l  d6,a0
    move.w  O_NumSpli(a2),d7
    move.b  O_SpliBkCol+1(a2),d5
.dlloop tst.b   Sp_First(a0)
    beq.s   .quit2
    move.b  Sp_BkCol(a0),d0
    cmp.b   #$FF,d0
    beq.s   .quit2
    clr.b   Sp_First(a0)
    move.l  Sp_Pos(a0),d1
    move.b  d1,d2
    not.b   d2
    lsr.l   #3,d1
    move.w  d4,d0
    moveq.l #0,d3
    move.l  (sp),a1
.sloop  move.l  (a1)+,a2
    btst    d3,d5
    bne.s   .setbi
    bclr    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop
    bra.s   .quit2
.setbi  bset    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop
.quit2  lea Sp_SizeOf(a0),a0
    dbra    d7,.dlloop
    addq.l  #4,sp
    rts

    Lib_Par      SplinterDel2      *** Splinters Double Del
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  O_SpliPlanes(a2),d4
    move.l  a1,-(sp)
    move.l  a0,d6
.stloop move.b  Sp_DbBkCol(a0),d5
    cmp.b   #$FF,d5
    beq.s   .quit
    move.l  Sp_DbPos(a0),d1
    move.b  d1,d2
    not.b   d2
    lsr.l   #3,d1
    move.w  d4,d0
    moveq.l #0,d3
    move.l  (sp),a1
.sloop2 move.l  (a1)+,a2
    btst    d3,d5
    bne.s   .setbi2
    bclr    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop2
    bra.s   .quit
.setbi2 bset    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop2
.quit   lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop

    dload   a2
    move.l  d6,a0
    move.w  O_NumSpli(a2),d7
    move.b  O_SpliBkCol+1(a2),d5
.dlloop move.b  Sp_BkCol(a0),d0
    cmp.b   #$FF,d0
    beq.s   .quit2
    beq.s   .quit2
    move.b  Sp_First(a0),d1
    beq.s   .quit2
    cmp.b   #$FF,d1
    bne.s   .nofir
    move.b  #$01,Sp_First(a0)
    bra.s   .nofir2
.nofir  clr.b   Sp_First(a0)
.nofir2 move.l  Sp_Pos(a0),d1
    move.b  d1,d2
    not.b   d2
    lsr.l   #3,d1
    move.w  d4,d0
    moveq.l #0,d3
    move.l  (sp),a1
.sloop  move.l  (a1)+,a2
    btst    d3,d5
    bne.s   .setbi
    bclr    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop
    bra.s   .quit2
.setbi  bset    d2,(a2,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop
.quit2  lea Sp_SizeOf(a0),a0
    dbra    d7,.dlloop
    addq.l  #4,sp
    rts

    Lib_Par      SplinterMove      *** Splinters Move
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    move.l  O_CoordsBank(a2),d0
    Rbeq    L_IFonc
    movem.l a3/a4,-(sp)
    move.l  ScOnAd(a5),a4
    move.l  d0,a3
    move.w  O_MaxSpli(a2),d5
    lea $DFF006,a1
    move.w  (a1),d6
.stloop Rbsr    L_MoveSplinter
    lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop
    movem.l (sp)+,a3/a4
    rts

    Lib_Par      SplinterBack      *** Splinters Back
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  O_SpliPlanes(a2),d4
    move.l  a3,-(sp)
    move.l  a1,-(sp)
.stloop move.b  Sp_Col(a0),d5
    cmp.b   #$FF,d5
    beq.s   .quit
    move.l  Sp_Pos(a0),d1
    move.b  d1,d2
    not.b   d2
    lsr.l   #3,d1
    move.w  d4,d0
    moveq.l #0,d5
    moveq.l #0,d3
    move.l  (sp),a1
.gloop  move.l  (a1)+,a3
    btst    d2,(a3,d1.l)
    beq.s   .skip
    bset    d3,d5
.skip   addq.b  #1,d3
    dbra    d0,.gloop
    move.b  d5,Sp_BkCol(a0)
    cmp.b   #$FF,Sp_First(a0)
    bne.s   .quit
    move.b  d5,Sp_Col(a0)
.quit   lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop
    addq.l  #4,sp
    move.l  (sp)+,a3
    rts

    Lib_Par      SplinterDraw      *** Splinters Draw
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  O_SpliPlanes(a2),d4
    move.l  a3,-(sp)
    move.l  a1,-(sp)
.stloop move.b  Sp_Col(a0),d5
    cmp.b   #$FF,d5
    beq.s   .quit
    move.l  Sp_Pos(a0),d1
    move.b  d1,d2
    not.b   d2
    lsr.l   #3,d1
    move.w  d4,d0
    moveq.l #0,d3
    move.l  (sp),a1
.sloop2 move.l  (a1)+,a3
    btst    d3,d5
    bne.s   .setbi2
    bclr    d2,(a3,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop2
    bra.s   .quit
.setbi2 bset    d2,(a3,d1.l)
    addq.b  #1,d3
    dbra    d0,.sloop2
.quit   lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop
    addq.l  #4,sp
    move.l  (sp)+,a3
    rts

    Lib_Par      SplinterActive    *** =Splinters Active
    
    dload   a2
    move.l  O_SpliBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumSpli(a2),d7
    moveq.l #0,d3
    moveq.l #0,d2
    moveq.l #-1,d0
.stloop cmp.w   Sp_Col(a0),d0
    bne.s   .cont
    cmp.b   Sp_DbBkCol(a0),d0
    bne.s   .cont
    lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop
    rts
.cont   addq.l  #1,d3
    lea Sp_SizeOf(a0),a0
    dbra    d7,.stloop
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
;;    include "Amcaf/TdStars.asm"
    Lib_Par      TdStarBank        *** Td Stars Bank bank,stars
    
    dload   a2
    move.l  (a3)+,d2
    Rbeq    L_IFonc
    moveq.l #0,d1
    move.l  (a3)+,d0
    move.w  d2,d4
    subq.w  #1,d4
    move.w  d4,O_NumStars(a2)
    mulu    #St_SizeOf,d2
    lea .bkstar(pc),a0
    Rjsr    L_Bnk.Reserve
    Rbeq    L_IOoMem
    move.l  a0,O_StarBank(a2)
    rts
.bkstar dc.b    'Stars   '
    even

    Lib_Par      TdStarLimitAll    *** Td Stars Limit
    
    dload   a2
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IScNoOpen
    clr.l   O_StarLimits(a2)
    move.w  EcTx(a0),d0
    lsl.w   #6,d0
    move.w  d0,d1
    subq.w  #1,d0
    lsr.w   d1
    swap    d0
    swap    d1
    move.w  EcTy(a0),d0
    lsl.w   #6,d0
    move.w  d0,d1
    subq.w  #1,d0
    lsr.w   d1
    move.l  d0,O_StarLimits+4(a2)
    move.l  d1,O_StarOrigin(a2)
    rts

    Lib_Par      TdStarLimit       *** Td Stars Limit x1,y1 To x2,y2
    
    dload   a2
    lea O_StarLimits(a2),a0
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    lsl.w   #6,d0
    lsl.w   #6,d1
    lsl.w   #6,d2
    lsl.w   #6,d3
    subq.l  #1,d2
    subq.l  #1,d3
    cmp.w   d0,d2
    bhi.s   .noswp1
    exg d0,d2
.noswp1 cmp.w   d1,d3
    bhi.s   .noswp2
    exg d1,d3
.noswp2 move.w  d0,(a0)+
    move.w  d1,(a0)+
    move.w  d2,(a0)+
    move.w  d3,(a0)+
    add.w   d1,d0
    lsr.w   d0
    add.w   d3,d2
    lsr.w   d2
    move.w  d0,(a0)+
    move.w  d2,(a0)+
    rts

    Lib_Par      TdStarOrigin      *** Td Stars Origin x,y
    
    dload   a2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    lsl.w   #6,d0
    lsl.w   #6,d1
    move.w  d0,O_StarOrigin(a2)
    move.w  d1,O_StarOrigin+2(a2)
    rts

    Lib_Par      TdStarInit        *** Td Stars Init
    
    dload   a2
    move.l  O_StarBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumStars(a2),d7
    lea $DFF006,a1
    move.w  (a1),d6
.stloop Rbsr    L_InitStar
    clr.l   St_DbX(a0)
    add.w   (a1),d5
    and.w   #$1F,d5
.mvloop Rbsr    L_MoveStar
    dbra    d5,.mvloop
    lea St_SizeOf(a0),a0
    dbra    d7,.stloop
    rts

    Lib_Par      TdStarGravity     *** Td Stars Gravity sx,sy
    
    dload   a2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.w  d0,O_StarGravity(a2)
    move.w  d1,O_StarGravity+2(a2)
    rts

    Lib_Par      TdStarAccelOn     *** Td Stars Accelerate On
    
    dload   a2
    st  O_StarAccel(a2)
    rts

    Lib_Par      TdStarAccelOff    *** Td Stars Accelerate Off
    
    dload   a2
    clr.w   O_StarAccel(a2)
    rts

    Lib_Par      TdStarPlanes      *** Td Stars Planes p1,p2
    
    dload   a2
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  EcNPlan(a1),d0
    cmp.w   #2,d0
    bge.s   .enplan
    moveq.l #15,d0
    Rbra    L_Custom
.enplan move.l  (a3)+,d2
    move.l  (a3)+,d1
    cmp.w   d1,d0
    Rble    L_IFonc
    cmp.w   d2,d0
    Rble    L_IFonc
    add.w   d1,d1
    add.w   d1,d1
    add.w   d2,d2
    add.w   d2,d2
    move.w  d1,O_StarPlanes(a2)
    move.w  d2,O_StarPlanes+2(a2)
    rts

    Lib_Par      TdStarDo1     *** Td Stars Single Do
    
    Rbsr    L_TdStarDel1
    Rbsr    L_TdStarMove
    Rbra    L_TdStarDraw

    Lib_Par      TdStarDo2     *** Td Stars Double Do
    
    Rbsr    L_TdStarDel2
    Rbsr    L_TdStarMove
    Rbra    L_TdStarDraw

    Lib_Par      TdStarDel1        *** Td Stars Single Del
    
    dload   a2
    move.l  O_StarBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumStars(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  EcNPlan(a1),d0
    cmp.w   #2,d0
    bge.s   .enplan
    moveq.l #15,d0
    Rbra    L_Custom
.enplan move.w  EcTx(a1),d6
    lsr.w   #3,d6           ;Modulo
    move.w  O_StarPlanes(a2),d0
    move.w  O_StarPlanes+2(a2),d1
    move.l  (a1,d0.w),a2
    move.l  (a1,d1.w),a1
.stloop move.w  (a0),d0         ;St_X
    lsr.w   #6,d0
    move.b  d0,d2
    not.b   d2
    lsr.w   #3,d0
    ext.l   d0
    move.w  St_Y(a0),d1
    lsr.w   #6,d1
    mulu    d6,d1
    add.l   d0,d1
    bclr    d2,(a2,d1.l)
    bclr    d2,(a1,d1.l)
    lea St_SizeOf(a0),a0
    dbra    d7,.stloop
    rts

    Lib_Par      TdStarDel2        *** Td Stars Double Del
    
    dload   a2
    move.l  O_StarBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumStars(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  EcNPlan(a1),d0
    cmp.w   #2,d0
    bge.s   .enplan
    moveq.l #15,d0
    Rbra    L_Custom
.enplan move.w  EcTx(a1),d6
    lsr.w   #3,d6           ;Modulo
    move.w  O_StarPlanes(a2),d0
    move.w  O_StarPlanes+2(a2),d1
    move.l  (a1,d0.w),a2
    move.l  (a1,d1.w),a1
.stloop move.w  St_DbX(a0),d0
    lsr.w   #6,d0
    move.b  d0,d2
    not.b   d2
    lsr.w   #3,d0
    ext.l   d0
    move.w  St_DbY(a0),d1
    lsr.w   #6,d1
    mulu    d6,d1
    add.l   d0,d1
    bclr    d2,(a2,d1.l)
    bclr    d2,(a1,d1.l)
    lea St_SizeOf(a0),a0
    dbra    d7,.stloop
    rts

    Lib_Par      TdStarMove        *** Td Stars Move
    
    dload   a2
    move.l  O_StarBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumStars(a2),d7
    lea $DFF006,a1
    move.w  (a1),d6
.stloop Rbsr    L_MoveStar
    lea St_SizeOf(a0),a0
    dbra    d7,.stloop
    rts

    Lib_Par      TdStarMoveSingle  *** Td Stars Move n
    
    dload   a2
    move.l  O_StarBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumStars(a2),d7
    move.l  (a3)+,d0
    cmp.w   d0,d7
    Rbmi    L_IFonc
    lsl.w   #4,d0
    add.w   d0,a0
    lea $DFF006,a1
    move.w  (a1),d6
    Rbra    L_MoveStar

    Lib_Par      TdStarDraw        *** Td Stars Draw
    
    dload   a2
    move.l  O_StarBank(a2),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    move.w  O_NumStars(a2),d7
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.w  EcNPlan(a1),d0
    cmp.w   #2,d0
    bge.s   .enplan
    moveq.l #15,d0
    Rbra    L_Custom
.enplan move.w  EcTx(a1),d6
    lsr.w   #3,d6           ;Modulo
    move.w  O_StarPlanes(a2),d0
    move.w  O_StarPlanes+2(a2),d1
    move.l  (a1,d0.w),a2
    move.l  (a1,d1.w),a1
.stloop move.w  (a0),d0         ;St_X
    lsr.w   #6,d0
    move.b  d0,d2
    not.b   d2
    lsr.w   #3,d0
    ext.l   d0
    move.w  St_Y(a0),d1
    lsr.w   #6,d1
    mulu    d6,d1
    add.l   d0,d1
    move.w  St_Sx(a0),d3
    bpl.s   .plus1
    neg.w   d3
.plus1  move.w  St_Sy(a0),d4
    bpl.s   .plus2
    neg.w   d4
.plus2  add.w   d4,d3
    lsr.w   #6,d3
    cmp.w   #3,d3
    blt.s   .grey
    bset    d2,(a2,d1.l)
    bset    d2,(a1,d1.l)
.cont   lea St_SizeOf(a0),a0
    dbra    d7,.stloop
    rts
.grey   cmp.w   #2,d3
    blt.s   .drkgry
    bclr    d2,(a2,d1.l)
    bset    d2,(a1,d1.l)
    bra.s   .cont
.drkgry ;tst.w  d3
    ;beq.s  .black
    bclr    d2,(a1,d1.l)
    bset    d2,(a2,d1.l)
.black  bra.s   .cont
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
;;    include "Amcaf/Time.asm"
    Lib_Par      CurrentDate       *** =Current Date
    
    dload   a2
    lea O_DateStamp(a2),a2
    move.l  a2,d1
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVODateStamp(a6)
    move.l  d7,a6
    move.l  (a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      CurrentTime       *** =Current Time
    
    dload   a2
    lea O_DateStamp(a2),a2
    move.l  a2,d1
    move.l  a6,d7
    move.l  DosBase(a5),a6
    jsr _LVODateStamp(a6)
    move.l  d7,a6
    move.w  6(a2),d3
    swap    d3
    move.w  10(a2),d3
    moveq.l #0,d2
    rts

    Lib_Par      CdYear        *** =Cd Year(date)
    
    move.l  (a3)+,d0
    moveq.l #0,d3
    moveq.l #0,d1
    move.w  #1978,d3
    move.w  #365,d1
    move.w  d1,d2
.yrloop cmp.l   d1,d0
    blt.s   .quit
    addq.w  #1,d3
    sub.l   d1,d0
    move.w  d2,d1
    move.b  d3,d4
    and.b   #%11,d4
    bne.s   .yrloop
    addq.w  #1,d1
    bra.s   .yrloop
.quit   moveq.l #0,d2
    rts

    Lib_Par      CdMonth       *** =Cd Month(date)
    
    Rbsr    L_CdYear
    Rbra    L_CdMonth2
    
    Lib_Par      CdDay         *** =Cd Day(date)
    
    Rbsr    L_CdMonth
    move.l  d0,d3
    addq.b  #1,d3
    rts

    Lib_Par      CdWeekDay     *** =Cd Weekday(date)
    
    move.l  (a3)+,d3
    addq.l  #6,d3
    moveq.l #0,d2
    divu    #7,d3
    move.w  d2,d3
    swap    d3
    addq.b  #1,d3
    rts

    Lib_Par      CtString      *** =Ct String(time$)
    
    Rbsr    L_CheckOS2
    dload   a2
    move.l  (a3)+,a0
    lea O_TempBuffer(a2),a1
    move.w  (a0)+,d0
    beq.s   .bad
    subq.w  #1,d0
.cploop move.b  (a0)+,(a1)+
    dbra    d0,.cploop
    clr.b   (a1)
    lea O_TempBuffer(a2),a0
    lea O_DateStamp(a2),a1
    clr.w   dat_Format(a1)
    clr.l   dat_StrDay(a1)
    clr.l   dat_StrDate(a1)
    move.l  a0,dat_StrTime(a1)
    move.l  a1,d1
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOStrToDate(a6)
    move.l  (sp)+,a6
    tst.l   d0
    bne.s   .good
.bad    moveq.l #0,d2
    moveq.l #-1,d3
    rts
.good   moveq.l #0,d2
    move.w  O_DateStamp+6(a2),d3
    swap    d3
    move.w  O_DateStamp+10(a2),d3
    rts

    Lib_Par      CdString      *** =Cd String(date$)
    
    Rbsr    L_CheckOS2
    dload   a2
    move.l  (a3)+,a0
    lea O_TempBuffer(a2),a1
    move.w  (a0)+,d0
    beq.s   .bad
    subq.w  #1,d0
.cploop move.b  (a0)+,(a1)+
    dbra    d0,.cploop
    clr.b   (a1)
    lea O_TempBuffer(a2),a0
    lea O_DateStamp(a2),a1
    clr.w   dat_Format(a1)
    clr.l   dat_StrDay(a1)
    clr.l   dat_StrTime(a1)
    move.l  a0,dat_StrDate(a1)
    move.l  a1,d1
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOStrToDate(a6)
    move.l  (sp)+,a6
    tst.l   d0
    bne.s   .good
.bad    moveq.l #0,d2
    moveq.l #-1,d3
    rts
.good   moveq.l #0,d2
    move.l  O_DateStamp(a2),d3
    rts

    Lib_Par      ConvDate      *** =Cd Date$(date)
    
    moveq.l #16,d3
    Rjsr    L_Demande
    move.l  a0,-(sp)
    move.w  #13,(a0)+
    lea 14(a0),a1
    move.l  a1,HiChaine(a5)
    move.l  (a3),d0
    addq.l  #6,d0
    divu    #7,d0
    swap    d0
    lsl.w   #2,d0
    move.l  .weekda(pc,d0.w),(a0)+
    Rbsr    L_CdYear
    move.l  d3,d7
    Rbsr    L_CdMonth2
    move.l  d3,d6
    addq.b  #1,d0
    bsr.s   .insnum
    lsl.w   #2,d6
    move.l  .month-4(pc,d6.w),(a0)+
    move.b  #'-',(a0)+
    move.l  d7,d0
    divu    #100,d0
    swap    d0
    bsr.s   .insnum
    move.l  (sp)+,d3
    moveq.l #2,d2
    rts
.insnum move.b  #'0',(a0)
.loop1  cmp.b   #10,d0
    blt.s   .cont
    addq.b  #1,(a0)
    sub.b   #10,d0
    bra.s   .loop1
.cont   addq.l  #1,a0
    move.b  #'0',(a0)
    tst.b   d0
    beq.s   .cont2
.loop2  addq.b  #1,(a0)
    subq.b  #1,d0
    bne.s   .loop2
.cont2  addq.l  #1,a0
    rts
    Rdata
.weekda dc.b    'Mon Tue Wed Thu Fri Sat Sun '
.month  dc.b    '-Jan-Feb-Mar-Apr-May-Jun-Jul-Aug-Sep-Oct-Nov-Dec'
    even

    Lib_Par      CtHour        *** =Ct Hour(time)
    
    move.l  (a3)+,d0
    moveq.l #0,d2
    moveq.l #0,d3
    move.w  d2,d0
    swap    d0
    divu    #60,d0
    move.w  d0,d3
    rts

    Lib_Par      CtMinute      *** =Ct Minute(time)
    
    move.l  (a3)+,d3
    moveq.l #0,d2
    move.w  d2,d3
    swap    d3
    divu    #60,d3
    move.w  d2,d3
    swap    d3
    rts

    Lib_Par      CtSecond      *** =Ct Second(time)
    
    move.l  (a3)+,d0
    moveq.l #0,d1
    moveq.l #0,d2
    moveq.l #0,d3
    move.w  d0,d1
    divu    #50,d1
    move.w  d1,d3
    rts

    Lib_Par      CtTick        *** =Ct Tick(time)
    
    move.l  (a3)+,d0
    moveq.l #0,d2
    moveq.l #0,d3
    move.w  d0,d3
    divu    #50,d3
    move.w  d2,d3
    swap    d3
    rts

    Lib_Par      ConvTime      *** =Ct Time$(time)
    
    moveq.l #10,d3
    Rjsr    L_Demande
    move.l  a0,d3
    move.w  #8,(a0)+
    move.l  (a3)+,d6
    move.l  d6,d0
    moveq.l #0,d2
    move.w  d2,d0
    swap    d0
    divu    #60,d0
    bsr.s   .insnum
    move.b  #':',(a0)+
    swap    d0
    bsr.s   .insnum
    move.b  #':',(a0)+
    moveq.l #0,d0
    move.w  d6,d0
    divu    #50,d0
    bsr.s   .insnum
    move.l  a0,d0
    move.l  d0,HiChaine(a5)
    moveq.l #2,d2
    rts
.insnum move.b  #'0',(a0)
.loop1  cmp.b   #10,d0
    blt.s   .cont
    addq.b  #1,(a0)
    sub.b   #10,d0
    bra.s   .loop1
.cont   addq.l  #1,a0
    move.b  #'0',(a0)
    tst.b   d0
    beq.s   .cont2
.loop2  addq.b  #1,(a0)
    subq.b  #1,d0
    bne.s   .loop2
.cont2  addq.l  #1,a0
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
;;    include "Amcaf/Palette.asm"
    Lib_Par      PalSpread     *** Pal Spread c1,rgb1 To c2,rgb2
    
    move.l  ScOnAd(a5),a0
    lea EcPal-4(a0),a1
    move.l  (a3)+,d5
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    cmp.w   #32,d7
    Rbge    L_IFonc
    move.l  (a3)+,d4
    move.l  (a3)+,d6
    Rbmi    L_IFonc
    cmp.w   #32,d6
    Rbge    L_IFonc
    cmp.w   d6,d7
    bgt.s   .noswap
    exg d6,d7
    exg d4,d5
.noswap sub.w   d6,d7
    add.w   d6,d6
    move.l  ScOnAd(a5),a0
    lea EcPal-4(a0,d6.w),a1
    tst.w   d7
    bne.s   .cont
    move.w  d4,(a1)
    rts
.cont   ;subq.w #1,d7
    move.w  d7,d6
    moveq.l #0,d0
.loop   moveq.l #0,d2
    move.w  d4,d1
    and.w   #$F00,d1
    lsr.w   #7,d1
    mulu    d7,d1
    divu    d6,d1
    lsr.w   #1,d1
    addx.w  d2,d1
    move.w  d5,d2
    and.w   #$F00,d2
    lsr.w   #7,d2
    mulu    d0,d2
    divu    d6,d2
    lsr.w   #1,d2
    addx.w  d1,d2
    cmp.w   #$f,d2
    ble.s   .nover1
    moveq.l #$f,d2
.nover1 lsl.w   #8,d2
    move.w  d2,d3
        
    moveq.l #0,d2
    move.w  d4,d1
    and.w   #$0F0,d1
    lsr.w   #3,d1
    mulu    d7,d1
    divu    d6,d1
    lsr.w   #1,d1
    addx.w  d2,d1
    move.w  d5,d2
    and.w   #$0F0,d2
    lsr.w   #3,d2
    mulu    d0,d2
    divu    d6,d2
    lsr.w   #1,d2
    addx.w  d1,d2
    cmp.w   #$f,d2
    ble.s   .nover2
    moveq.l #$f,d2
.nover2 lsl.w   #4,d2
    or.w    d2,d3
    
    moveq.l #0,d2
    move.w  d4,d1
    and.w   #$00F,d1
    add.w   d1,d1
    mulu    d7,d1
    divu    d6,d1
    lsr.w   #1,d1
    addx.w  d2,d1
    move.w  d5,d2
    and.w   #$00F,d2
    add.w   d2,d2
    mulu    d0,d2
    divu    d6,d2
    lsr.w   #1,d2
    addx.w  d1,d2
    cmp.w   #$f,d2
    ble.s   .nover3
    moveq.l #$f,d2
.nover3 or.w    d2,d3
    move.w  d3,(a1)+
    addq.l  #1,d0
    dbra    d7,.loop
    EcCall  CopMake
    rts

    Lib_Par      PalGetScreen      *** Pal Get Screen pals,screen
    
    dload   a2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #8,d0
    Rbge    L_IFonc
    lea EcPal-4(a0),a1
    lea O_PaletteBufs(a2),a2
    lsl.w   #6,d0
    add.l   d0,a2
    moveq.l #15,d7
.loop   move.l  (a1)+,(a2)+
    dbra    d7,.loop
    rts

    Lib_Par      PalSetScreen      *** Pal Set Screen pals,screen
    
    dload   a2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #8,d0
    Rbge    L_IFonc
    lea EcPal-4(a0),a1
    lea O_PaletteBufs(a2),a2
    lsl.w   #6,d0
    add.l   d0,a2
    moveq.l #15,d7
.loop   move.l  (a2)+,(a1)+
    dbra    d7,.loop
    EcCall  CopMake
    rts

    Lib_Par      PalGet        *** =Pal Get(pal,colour)
    
    dload   a2
    move.l  (a3)+,d1
    Rbmi    L_IFonc
    cmp.w   #32,d1
    Rbge    L_IFonc
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #8,d0
    Rbge    L_IFonc
    add.w   d1,d1
    lsl.w   #6,d0
    or.w    d0,d1
    lea O_PaletteBufs(a2),a0
    move.w  (a0,d1.w),d3
    moveq.l #0,d2
    rts

    Lib_Par      PalSet        *** Pal Set pal,colindex,colour
    
    dload   a2
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    Rbmi    L_IFonc
    cmp.w   #32,d1
    Rbge    L_IFonc
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    cmp.w   #8,d0
    Rbge    L_IFonc
    add.w   d1,d1
    lsl.w   #6,d0
    or.w    d0,d1
    lea O_PaletteBufs(a2),a0
    move.w  d2,(a0,d1.w)
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
;    include "Amcaf/ToolTypes.asm"
    Lib_Par      GetTask       *** =Amos Task
    
    move.l  a6,d7
    sub.l   a1,a1
    move.l  4.w,a6
    jsr _LVOFindTask(a6)
    move.l  d7,a6
    move.l  d0,d3
    moveq.l #0,d2
    rts

    Lib_Par      CommandName       *** =Command Name$
    
    move.l  a6,d7
    sub.l   a1,a1
    move.l  4.w,a6
    jsr _LVOFindTask(a6)
    move.l  d7,a6
    move.l  d0,a0
    tst.l   140(a0)
    beq.s   .fromWB
    move.l  172(a0),a0      ;Vom CLI
    move.l  a0,d0
    add.l   a0,a0
    add.l   a0,a0
    move.l  16(a0),a0
    add.l   a0,a0
    add.l   a0,a0
    moveq.l #2,d2
    Rbra    L_BCPLAMOSString
.fromWB move.l  Sys_Message(a5),a0  ;Von Workbench
    move.l  a0,d0
    beq.s   .compil
    move.l  36(a0),a0
    move.l  4(a0),a0
    moveq.l #2,d2
    Rbra    L_MakeAMOSString
.compil move.l  1060(a5),a0     ;Compiliert von WB
    addq.l  #8,a0
    addq.l  #4,a0
    moveq.l #2,d2
    Rbra    L_MakeAMOSString

    Lib_Par      Cli           *** =Amos Cli
    
    move.l  a6,d7
    sub.l   a1,a1
    move.l  4.w,a6
    jsr _LVOFindTask(a6)
    move.l  d7,a6
    move.l  d0,a0
    move.l  140(a0),d3
    moveq.l #0,d2
    rts

    Lib_Par      ToolTypes     *** =Tool Types$(name$)
    
    dload   a2
    move.l  a6,d7
    move.l  IconBase(a5),d0
    bne.s   .foicon
    lea .iconam(pc),a1
    moveq.l #0,d0
    move.l  4.w,a6
    jsr _LVOOpenLibrary(a6)
    move.l  d7,a6
    move.l  d0,IconBase(a5)
    bne.s   .foicon
    moveq.l #13,d0
    Rbra    L_Custom
.foicon move.l  d0,d6
    move.l  (a3)+,a0
    move.w  (a0)+,d0
    Rbeq    L_IFonc
    lea O_TempBuffer(a2),a1
    subq.w  #1,d0
.cloop  move.b  (a0)+,(a1)+
    dbra    d0,.cloop
    clr.b   (a1)
    lea O_TempBuffer(a2),a0
    move.l  d6,a6
    jsr _LVOGetDiskObject(a6)
    move.l  d7,a6
    move.l  d0,d5
    Rbeq    L_IIOError
    move.l  d0,a1
    move.l  $36(a1),a1
    lea O_TempBuffer(a2),a0
.ttloop move.l  (a1)+,a2
    move.l  a2,d0
    beq.s   .endtt
.chloop move.b  (a2)+,d0
    bne.s   .nexcha
    move.b  #13,(a0)+
    move.b  #10,(a0)+
    bra.s   .ttloop
.nexcha move.b  d0,(a0)+
    bra.s   .chloop
.endtt  clr.b   (a0)
    move.l  d5,a0
    move.l  d6,a6
    jsr _LVOFreeDiskObject(a6)
    move.l  d7,a6
    dload   a2
    lea O_TempBuffer(a2),a0
    moveq.l #2,d2
    Rbra    L_MakeAMOSString
.iconam dc.b    'icon.library',0
    even
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
;    include "Amcaf/Turbo.asm"
;    IFEQ    1
    Lib_Par      TurboText3        *** Turbo Text x,y,t$
    clr.l   -(a3)
    Rbra    L_TurboText4

    Lib_Par      TurboText4        *** Turbo Text x,y,t$,trans
    moveq.l #-1,d0
    move.l  d0,-(a3)
    Rbra    L_TurboText5

    Lib_Par      TurboText5        *** Turbo Text x,y,t$,trans,planes
    
    move.l  (a3)+,d7        ;planes
    bne.s   .conto
    lea 16(a3),a3
    rts
.conto  move.l  (a3)+,d6        ;trans
    move.l  (a3)+,a1        ;string
    move.w  (a1)+,d5        ;strlength
    bne.s   .conti
    addq.l  #8,a3
    rts
.conti  subq.w  #1,d5
    move.l  (a3)+,d4        ;y
    Rbmi    L_IFonc
    move.l  ScOnAd(a5),a0
    move.l  a0,d0
    Rbeq    L_IFonc
    moveq.l #0,d1
    move.w  EcTx(a0),d1
    lsr.w   #3,d1           ;bytes per row
    move.w  EcTy(a0),d0
    subq.w  #8,d0
    cmp.w   d0,d4
    Rbhi    L_IFonc
    mulu    d1,d4
    move.l  (a3)+,d3        ;x
    Rbmi    L_IFonc
    move.w  d3,d0
    lsr.w   #3,d3
    and.w   #$7,d0
    tst.w   d0
    beq.s   .bound8
    cmp.w   d3,d1
    blt.s   .doit
    rts
.doit   rts
.bound8 movem.l a3-a6,-(sp)
    move.w  d3,d0
    add.w   d5,d0
    cmp.w   d0,d1
    bgt.s   .ntrunc
    move.w  d1,d5           ;trunc line
    sub.w   d3,d5
    subq.w  #1,d5
.ntrunc add.l   d3,d4           ;planeoffset
    move.l  EcWindow(a0),a2
    move.l  WiFont(a2),a2       ;font   
    move.l  Ec_RastPort(a0),a6
letlop75:
    moveq.l #0,d0
    move.b  (a1)+,d0
    lsl.w   #3,d0
    move.l  a0,a3
    move.w  EcNPlan(a0),d3      ;planes
    subq.w  #1,d3
    move.w  d7,d2
    lea (a2,d0.w),a5
    move.b  rp_FgPen(a6),d6
    move.b  rp_BgPen(a6),d0
pllop75  move.l  (a3)+,a4
    asr.w   #1,d2
    bcc     skippl75
    add.l   d4,a4
    asr.w   #1,d0
    bcs.s   .clrit
    REPT    7
    move.b  (a5)+,(a4)
    add.l   d1,a4
    ENDR
    move.b  (a5),(a4)
    subq.l  #7,a5
    lsr.w   #1,d6
    dbra    d3,pllop75
    bra.s   lopy75
.clrit  asr.w   #1,d6
    bcs     fillit7
    REPT    7
    clr.b   (a4)
    add.l   d1,a4
    ENDR
    clr.b   (a4)
    dbra    d3,pllop75
    bra.s   lopy75
fillit7:
    REPT    7
    st  (a4)
    add.l   d1,a4
    ENDR
    st  (a4)
    dbra    d3,pllop75
    bra.s   lopy75
skippl75:
 lsr.w   #1,d0
    lsr.w   #1,d6
    dbra    d3,pllop75
lopy75:
    addq.l  #1,d4
    dbra    d5,letlop75
    movem.l (sp)+,a3-a6
    rts
;    ENDC

    Lib_Par      TurboDraw5        *** Turbo Draw x1,y1 To x2,y2,c
    
    move.l  ScOnAd(a5),a0
    moveq.l #0,d0
    move.w  EcNPlan(a0),d1
    lea .platab(pc),a0
    move.b  -1(a0,d1),d0
    move.l  d0,-(a3)
    Rbra    L_TurboDraw6
.platab dc.b    %000001,%000011,%000111,%001111,%011111,%111111
    even

    Lib_Par      TurboDraw6        *** Turbo Draw x1,y1 To x2,y2,c,bitmap
    
    dload   a2
    move.l  (a3)+,d6
    bne.s   .cont
    lea 5*4(a3),a3
.nodraw rts
.cont   move.l  ScOnAd(a5),a0
    move.l  (a3)+,d5
    move.l  (a3)+,d3        ;y2
    move.l  (a3)+,d2        ;x2
    move.l  (a3)+,d1        ;y1
    move.l  (a3)+,d0        ;x1
    bpl.s   .noclp1
.clip1  tst.w   d2
    bmi.s   .nodraw
    cmp.w   d2,d0
    bne.s   .contc1
    moveq.l #0,d0
    bra.s   .noclp1
.contc1 move.w  d3,d4
    sub.w   d1,d4
    move.w  d2,d7
    sub.w   d0,d7
    muls    d2,d4
    asl.l   #1,d4
    divs    d7,d4
    moveq.l #0,d7
    asr.w   #1,d4
    addx.w  d7,d4
    move.w  d3,d1
    sub.w   d4,d1
    moveq.l #0,d0
.noclp1 tst.w   d2
    bpl.s   .noclp2
    exg.l   d0,d2
    exg.l   d1,d3
    bra.s   .clip1
.noclp2 tst.w   d1
    bpl.s   .noclp3
.clip2  tst.w   d3
    bmi.s   .nodraw
    cmp.w   d3,d1
    bne.s   .contc2
    moveq.l #0,d1
    bra.s   .noclp3
.contc2 move.w  d2,d4
    sub.w   d0,d4
    move.w  d3,d7
    sub.w   d1,d7
    muls    d3,d4
    asl.l   #1,d4
    divs    d7,d4
    moveq.l #0,d7
    asr.w   #1,d4
    addx.w  d7,d4
    move.w  d2,d0
    sub.w   d4,d0
    moveq.l #0,d1
.noclp3 tst.w   d3
    bpl.s   .noclp4
    exg.l   d0,d2
    exg.l   d1,d3
    bra.s   .clip2
.noclp4 move.w  EcTx(a0),d4
    subq.w  #1,d4
    cmp.w   d4,d0
    bls.s   .noclp5
.clip3  cmp.w   d4,d2
    bgt.s   .nodra3
    cmp.w   d1,d3
    bne.s   .contc3
    move.w  d4,d0
    bra.s   .noclp5
.nodra3 tst.l   d6
    bpl.s   .nobldr
    move.w  d4,d0
    move.w  d4,d2
    bra.s   .noclp5
.nobldr rts
.contc3 move.w  d3,d7
    sub.w   d1,d7
    sub.w   d2,d4
    muls    d4,d7
    move.w  d2,d4
    sub.w   d0,d4
    asl.l   #1,d7
    divs    d4,d7
    moveq.l #0,d4
    asr.w   #1,d7
    addx.w  d4,d7
    move.w  EcTx(a0),d4
    subq.w  #1,d4
    move.w  d4,d0
    tst.l   d6
    bpl.s   .noblli
    movem.l d0-d7/a0-a2,-(sp)
    move.l  d0,-(a3)
    move.l  d1,-(a3)
    move.w  d3,d1
    add.w   d7,d1
    move.l  d0,-(a3)
    move.l  d1,-(a3)
    move.l  d5,-(a3)
    move.l  d6,-(a3)
    Rbsr    L_TurboDraw6
    movem.l (sp)+,d0-d7/a0-a2
.noblli move.w  d3,d1
    add.w   d7,d1
.noclp5 cmp.w   d4,d2
    bls.s   .noclp6
    exg.l   d0,d2
    exg.l   d1,d3
    bra.s   .clip3
.noclp6 move.w  EcTy(a0),d4
    subq.w  #1,d4
    cmp.w   d4,d1
    bls.s   .noclp7
.clip4  cmp.w   d4,d3
    bgt.s   .nodra2
    cmp.w   d0,d2
    bne.s   .contc4
    move.w  d4,d1
    bra.s   .noclp7
.contc4 move.w  d2,d7
    sub.w   d0,d7
    sub.w   d3,d4
    muls    d4,d7
    move.w  d3,d4
    sub.w   d1,d4
    asl.l   #1,d7
    divs    d4,d7
    moveq.l #0,d4
    asr.w   #1,d7
    addx.w  d4,d7
    move.w  d2,d0
    add.w   d7,d0
    move.w  EcTy(a0),d4
    subq.w  #1,d4
    move.w  d4,d1
.noclp7 cmp.w   d4,d3
    bls.s   .noclp8
    exg.l   d0,d2
    exg.l   d1,d3
    bra.s   .clip4
.noclp8 lea O_Blit(a2),a1
    move.l  #-1,Bn_B44l(a1)
    move.w  EcTx(a0),d7
    lsr.w   #3,d7
    move.w  d7,Bn_B60w(a1)
    move.l  #$0bca0001,d4
    tst.l   d6
    bpl.s   .nobltm
    cmp.w   d3,d1
    bne.s   .cont2
.nodra2 rts
.cont2  move.l  #$0b480003,d4
    neg.l   d6
.nobltm movem.l d4-d6,-(sp)
    cmp d1,d3
    bgt.s   .nohi
    exg d0,d2
    exg d1,d3
.nohi   move.w  d0,d4
    move.w  d1,d5
    mulu    d7,d5
    sub.l   a2,a2
    move.w  d5,a2
    lsr.w   #4,d4
    add.w   d4,d4
    lea (a2,d4.w),a2        ; Zeiger auf 1st Word of line
    sub.w   d0,d2           ; DeltaX
    sub.w   d1,d3           ; DeltaY
    moveq.l #15,d5
    and.l   d5,d0           ; X & $f
    move.b  d0,d7
    ror.l   #4,d0           ; in Bits 12-15 von BLITCON0
    move.w  #4,d0
    tst.w   d2
    bpl.s   .l1
    addq.w  #1,d0
    neg.w   d2
.l1 cmp.w   d2,d3
    ble.s   .l2
    exg d2,d3
    subq.w  #4,d0
    add.w   d0,d0
.l2 move.w  d3,d4
    sub.w   d2,d4
    lsl.w   #2,d4
    add.w   d3,d3           ; 2 * A
    move.w  d3,d6
    sub.w   d2,d6           ; 2 * A - B
    bpl.s   .l3
    or.b    #16,d0
.l3 add.w   d3,d3
    lsl.w   #2,d0
    addq.w  #1,d2
    lsl.w   #6,d2           ; Länge of the Linie
    addq.w  #2,d2           ; BLITSIZE (Breite = 2)
    swap    d3
    move.w  d4,d3
    move.l  d3,Bn_B62l(a1)      ; B,A-MOD   : 2*A,2*(A-B)
    move.w  d6,Bn_B52w(a1)      ; A-POTH(lo)    : 2*A-B
    move.l  a2,Bn_B48l(a1)      ; C-POTH
    move.w  d2,Bn_B58w(a1)      ; BLITSIZE
    movem.l (sp)+,d4-d6
    move.w  d4,d2
    or.l    d4,d0
    move.l  d0,Bn_B40l(a1)

    move.l  a6,d4
    move.l  T_GfxBase(a5),a6
    jsr _LVOOwnBlitter(a6)
    move.l  d4,a6
    moveq.l #5,d4
.plloop btst    d4,d6
    beq .skip
    lea $DFF000,a2
.blifin move.w  #%1000010000000000,$96(a2)
    btst    #6,2(a2)
    bne.s   .blifin
    move.w  #%0000010000000000,$96(a2)
    move.w  d4,d0
    lsl.w   #2,d0
    move.l  (a0,d0.w),d3
    beq.s   .skip
    add.l   Bn_B48l(a1),d3
    cmp.w   #$0003,d2
    bne.s   .nodot
    move.l  d3,a2
    move.b  d7,d1
    btst    #3,d1
    beq.s   .noadd
    addq.l  #1,a2
.noadd  not.b   d1
    bchg    d1,(a2)
    lea $DFF000,a2
.nodot  btst    d4,d5
    beq.s   .blankl
    move.l  a0,d0
    move.l  Ec_RastPort(a0),a0
    move.w  34(a0),$72(a2)
    move.l  d0,a0
    bra.s   .filll
.blankl move.w  #0,$72(a2)
.filll  move.l  Bn_B44l(a1),$44(a2)
    move.w  Bn_B52w(a1),$52(a2)
    move.w  #$8000,$74(a2)
    move.w  Bn_B60w(a1),d0
    move.w  d0,$60(a2)
    move.w  d0,$66(a2)
    move.l  Bn_B62l(a1),$62(a2)
    move.l  d3,$48(a2)
    move.l  d3,$54(a2)
    move.l  Bn_B40l(a1),$40(a2)
    move.w  Bn_B58w(a1),$58(a2)
.skip   dbra    d4,.plloop
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVODisownBlitter(a6)
    move.l  d7,a6
    rts
    IFEQ    1
.noddra bsr.s   .maknod
    rts
.maknod movem.l d0/d1/a0,-(sp)
    moveq.l #Bn_SizeOf,d0
    moveq.l #0,d1
    move.l  a6,d7
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IOoMem
    move.l  d0,a1
    clr.l   (a1)
    lea .blirou(pc),a0
    move.l  a0,Bn_Function(a1)
    move.w  #$4000,Bn_Stat(a1)
    clr.l   Bn_Dummy(a1)
    lea .clenup(pc),a0
    move.l  a0,Bn_CleanUp(a1)
    movem.l (sp)+,d0/d1/a0
    rts
.blirou move.l  Bn_B40l(a1),d0
    move.l  d0,$40(a0)
    btst    #1,d0
    beq.s   .nodot2
    nop
.nodot2 move.l  Bn_B44l(a1),$44(a0)
    move.l  Bn_B48l(a1),$48(a0)
    move.w  Bn_B52w(a1),$52(a0)
    move.l  Bn_B54l(a1),$54(a0)
    move.w  Bn_B60w(a1),$60(a0)
    move.l  Bn_B62l(a1),$62(a0)
    move.w  Bn_B66w(a1),$66(a0)
    move.l  Bn_B72w(a1),$72(a0)
    move.w  Bn_B58w(a1),$58(a0)
    moveq.l #0,d0
    rts
.clenup movem.l a0/a1/a6/d1,-(sp)
    moveq.l #Bn_SizeOf,d0
    move.l  4.w,a6
    jsr _LVOFreeMem(a6)
    movem.l (sp)+,a0/a1/a6/d1
    moveq.l #0,d0
    rts
    ENDC

    IFEQ    1
    Lib_Par      TurboDraw6        *** Turbo Draw x1,y1 To x2,y2,c,bitmap
    
    move.l  (a3)+,d6
    bne.s   .cont
    lea 5*4(a3),a3
    rts
.cont   move.l  (a3)+,d5
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.l  ScOnAd(a5),a0
    moveq.l #5,d4
.plloop btst    d4,d6
    beq .skip
    bsr .maknod
    moveq.l #-1,d7
    btst    d4,d5
    beq.s   .blankl
    move.w  d7,Bn_B72w(a1)
    bra.s   .filll
.blankl clr.w   Bn_B72w(a1)
.filll  move.l  d7,Bn_B44l(a1)
    move.w  EcTx(a0),d7
    lsr.w   #3,d7
    move.w  d7,Bn_B60w(a1)
    move.w  d7,Bn_B66w(a1)
    move.w  #$8000,Bn_B74w(a1)
    movem.l d0-d6/a0/a4/a6,-(sp)
    lsl.w   #2,d4
    move.l  (a0,d4.w),a4

    cmp d1,d3
    bgt.s   .nohi
    exg d0,d2
    exg d1,d3
.nohi   move.w  d0,d4
    move.w  d1,d5
    mulu    d7,d5
    add.w   d5,a4
    lsr.w   #4,d4
    add.w   d4,d4
    lea (a4,d4.w),a4        ; Zeiger auf 1st Word of line
    sub.w   d0,d2           ; DeltaX
    sub.w   d1,d3           ; DeltaY
    moveq.l #15,d5
    and.l   d5,d0           ; X & $f
    ror.l   #4,d0           ; in Bits 12-15 von BLITCON0
    move.w  #4,d0
    tst.w   d2
    bpl.s   .l1
    addq.w  #1,d0
    neg.w   d2
.l1 cmp.w   d2,d3
    ble.s   .l2
    exg d2,d3
    subq.w  #4,d0
    add.w   d0,d0
.l2 move.w  d3,d4
    sub.w   d2,d4
    lsl.w   #2,d4
    add.w   d3,d3           ; 2 * A
    move.w  d3,d6
    sub.w   d2,d6           ; 2 * A - B
    bpl.s   .l3
    or.b    #16,d0
.l3 add.w   d3,d3
    lsl.w   #2,d0
    addq.w  #1,d2
    lsl.w   #6,d2           ; Länge of the Linie
    addq.w  #2,d2           ; BLITSIZE (Breite = 2)
    swap    d3
    move.w  d4,d3
    or.l    #$0bca0001,d0       ; BlitCons
    move.l  d3,Bn_B62l(a1)      ; B,A-MOD   : 2*A,2*(A-B)
    move.w  d6,Bn_B52w(a1)      ; A-POTH(lo)    : 2*A-B
    move.l  a4,Bn_B48l(a1)      ; C-POTH
    move.l  a4,Bn_B54l(a1)      ; D-POTH
    move.l  d0,Bn_B40l(a1)      ; BLITCON
    move.w  d2,Bn_B58w(a1)      ; BLITSIZE
    move.l  T_GfxBase(a5),a6
    jsr _LVOQBlit(a6)
    movem.l (sp)+,d0-d6/a0/a4/a6
.skip   dbra    d4,.plloop
    rts
.maknod movem.l d0/d1/a0,-(sp)
    moveq.l #Bn_SizeOf,d0
    moveq.l #0,d1
    move.l  a6,d7
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IOoMem
    move.l  d0,a1
    clr.l   (a1)
    lea .blirou(pc),a0
    move.l  a0,Bn_Function(a1)
    move.w  #$4000,Bn_Stat(a1)
    clr.l   Bn_Dummy(a1)
    lea .clenup(pc),a0
    move.l  a0,Bn_CleanUp(a1)
    movem.l (sp)+,d0/d1/a0
    rts
.blirou move.l  Bn_B40l(a1),$40(a0)
    move.l  Bn_B44l(a1),$44(a0)
    move.l  Bn_B48l(a1),$48(a0)
    move.w  Bn_B52w(a1),$52(a0)
    move.l  Bn_B54l(a1),$54(a0)
    move.w  Bn_B60w(a1),$60(a0)
    move.l  Bn_B62l(a1),$62(a0)
    move.w  Bn_B66w(a1),$66(a0)
    move.l  Bn_B72w(a1),$72(a0)
    move.w  Bn_B58w(a1),$58(a0)
    moveq.l #0,d0
    rts
.clenup movem.l a0/a1/a6/d1,-(sp)
    moveq.l #Bn_SizeOf,d0
    move.l  4.w,a6
    jsr _LVOFreeMem(a6)
    movem.l (sp)+,a0/a1/a6/d1
    moveq.l #0,d0
    rts
    ENDC

    Lib_Par      TurboPlot     *** Turbo Plot x,y,c
    
    move.l  (a3)+,d0
    move.l  (a3)+,d1
    bpl.s   .cont
    addq.w  #4,a3
.quit   rts
.cont   move.l  (a3)+,d2
    bmi.s   .quit
    move.l  ScOnAd(a5),a0
    move.w  a0,d3
    Rbeq    L_IScNoOpen
    moveq.l #0,d3
    cmp.w   EcTy(a0),d1
    bge.s   .quit
    move.w  EcTx(a0),d3
    cmp.w   d3,d2
    bge.s   .quit
    lsr.w   #3,d3
    move.w  EcNPlan(a0),d4
    subq.w  #1,d4
    beq.s   .onepla
    mulu    d3,d1
    move.w  d2,d3
    lsr.w   #3,d3
    add.l   d1,d3
    not.b   d2
    moveq.l #0,d1
.loop   move.l  (a0)+,a1
    btst    d1,d0
    bne.s   .setbit
    bclr    d2,(a1,d3.l)
    addq.b  #1,d1
    dbra    d4,.loop
    rts
.setbit bset    d2,(a1,d3.l)
    addq.b  #1,d1
    dbra    d4,.loop
    rts
.onepla mulu    d3,d1
    move.w  d2,d3
    lsr.w   #3,d3
    add.l   d1,d3
    not.b   d2
    move.l  (a0),a1
    btst    d4,d0
    bne.s   .setbt2
    bclr    d2,(a1,d3.l)
    rts
.setbt2 bset    d2,(a1,d3.l)
    rts

    Lib_Par      TurboPoint        *** =Turbo Point(x,y)
    
    move.l  (a3)+,d2
    bpl.s   .cont
    addq.l  #4,a3
.outof  moveq.l #0,d2
    moveq.l #-1,d3
    rts
.cont   move.l  (a3)+,d1
    bmi.s   .outof
    move.l  ScOnAd(a5),a0
;   move.w  a0,d0
;   Rbeq    L_IScNoOpen
    cmp.w   EcTy(a0),d2
    bge.s   .outof
    moveq.l #0,d0
    move.w  EcTx(a0),d0
    cmp.w   d0,d1
    bge.s   .outof
    lsr.w   #3,d0
    move.w  EcNPlan(a0),d4
    subq.w  #1,d4
    beq.s   .onepla
    mulu    d0,d2
    move.w  d1,d0
    lsr.w   #3,d0
    add.l   d2,d0
    not.b   d1
    moveq.l #0,d3
    moveq.l #0,d2
.loop   move.l  (a0)+,a1
    btst    d1,(a1,d0.l)
    beq.s   .skip
    bset    d2,d3
.skip   addq.w  #1,d2
    dbra    d4,.loop
    moveq.l #0,d2
    rts
.onepla move.l  (a0),a1
    mulu    d0,d2
    move.w  d1,d0
    lsr.w   #3,d0
    add.l   d2,d0
    not.b   d1
    moveq.l #0,d2
    btst    d1,(a1,d0.l)
    bne.s   .skip2
    moveq.l #0,d3
    rts
.skip2  moveq.l #1,d3
    rts

    Lib_Par      FilledCircle      *** Fcircle x,y,r
    
    dload   a2
    move.l  (a3),-(a3)
    Rbra    L_FilledEllipse

    Lib_Par      FilledEllipse     *** Fellipse x,y,r1,r2
    
    dload   a2
    move.l  ScOnAd(a5),a1
    move.l  a1,d0
    Rbeq    L_IScNoOpen
    move.l  Ec_RastPort(a1),a1
    move.l  a1,d6
    Rbsr    L_InitArea
    move.l  (a3)+,d3
    move.l  (a3)+,d2
    move.l  (a3)+,d1
    move.l  (a3)+,d0
    move.l  a6,d7
    move.l  T_GfxBase(a5),a6
    jsr _LVOAreaEllipse(a6)
    tst.l   d0
    beq.s   .ok
    move.l  d7,a6
    move.l  d6,a1
    Rbsr    L_RemoveArea
    Rbra    L_IFonc
.ok move.l  d6,a1
    jsr _LVOAreaEnd(a6)
    move.l  d7,a6
    move.l  d6,a1
    Rbsr    L_RemoveArea
    tst.l   d0
    beq.s   .quit
    Rbra    L_IFonc
.quit   rts

    Lib_Par      BZoom         *** BZoom s1,x1,y1,x2,y2 To s2,x3,y3,m
    
    dload   a2
    move.l  (a3)+,d0
    Rbmi    L_IFonc
    move.w  d0,d1
    and.w   #$F0,d0
    tst.w   d0
    Rbeq    L_IFonc
    lsr.w   #4,d0
    subq.w  #1,d0
    and.w   #$F,d1
    cmp.w   #1,d1
    beq.s   .good
    cmp.w   #2,d1
    beq.s   .good
    cmp.w   #4,d1
    beq.s   .good
    cmp.w   #8,d1
    Rbne    L_IFonc
.good   move.w  d0,O_BlitHeight(a2)
    move.w  d1,O_BlitWidth(a2)
    move.l  (a3)+,d7        ;y3
    move.l  (a3)+,d6        ;x3
    and.w   #$FF0,d6        ;x3 boundary
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  (a3)+,d5        ;y2
    move.l  (a3)+,d4        ;x2
    and.w   #$FF8,d4        ;x2 boundary
    move.l  (a3)+,d3        ;y1
    sub.l   d3,d5           ;height
    subq.l  #1,d5           ;dbra height
    move.l  (a3)+,d2        ;x1
    and.w   #$FF8,d2        ;x1 boundary
    sub.l   d2,d4           ;width
    lsr.w   #3,d2           ;x offset source
    lsr.w   #3,d4           ;width bytes
    move.w  EcTx(a0),d0
    lsr.w   #3,d0           ;target screen mod
    move.w  d0,d1
    move.w  d1,O_BlitTargetMod(a2)  ;target modulo
    mulu    d0,d7           ;y offset target
    lsr.w   #3,d6           ;x offset target
    add.l   d6,d7           ;offset target
    move.l  (a0)+,d0
    add.l   d7,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d7,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d7,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d7,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d7,d0
    move.l  d0,(a2)+
    move.l  (a0),d0
    add.l   d7,d0
    move.l  d0,(a2)
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.w  EcTx(a0),d0
    lsr.w   #3,d0           ;source screen mod
    move.w  d0,d1
    dload   a2
    move.w  d1,O_BlitSourceMod(a2)  ;source modulo
    move.w  EcNPlan(a0),O_BlitSourcePln(a2)
    subq.w  #1,O_BlitSourcePln(a2)  ;num bitplanes
    mulu    d0,d3           ;y offset source
    add.l   d2,d3           ;offset source 
    lea 4*6(a2),a2
    move.l  (a0)+,d0
    add.l   d3,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d3,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d3,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d3,d0
    move.l  d0,(a2)+
    move.l  (a0)+,d0
    add.l   d3,d0
    move.l  d0,(a2)+
    move.l  (a0),d0
    add.l   d3,d0
    move.l  d0,(a2)
    dload   a2
    moveq.l #0,d2
    moveq.l #0,d3
    subq.w  #1,d4
    move.w  O_BlitSourceMod(a2),d2
    move.w  O_BlitTargetMod(a2),d3
    move.w  O_BlitWidth(a2),d0
    cmp.w   #1,d0
    beq.s   .z0
    cmp.w   #2,d0
    beq.s   .z1
    cmp.w   #4,d0
    beq .z2
    cmp.w   #8,d0
    beq .z3
    rts
.z0 movem.l a3-a6,-(sp)
.loopy0 move.w  O_BlitSourcePln(a2),d7  ;planes loop
    lea 4*6(a2),a0      ;source bpl
    move.l  a2,a1           ;target bpl
.loopp0 move.w  d4,d6           ;x loop
    move.l  (a0),a4         ;bpl pointer source
    move.l  (a1),a5         ;bpl pointer target
.loopx0 moveq.l #0,d0
    move.b  (a4)+,(a5)+     ;get byte
    dbra    d6,.loopx0
    move.l  (a1),a6
    add.l   d2,(a0)+
    add.l   d3,(a1)+
    move.w  O_BlitHeight(a2),d1
    beq.s   .noyst0
    subq.l  #4,a1
    subq.w  #1,d1
.ywlop0 move.l  (a1),a5
    move.l  a6,a4
    move.w  d4,d6
.yclop0 move.b  (a4)+,(a5)+
    dbra    d6,.yclop0
    add.l   d3,(a1)
    dbra    d1,.ywlop0
    addq.l  #4,a1
.noyst0 dbra    d7,.loopp0
    dbra    d5,.loopy0
    movem.l (sp)+,a3-a6
    rts

.z1 movem.l a3-a6,-(sp)
    lea O_Zoom2Buf(a2),a3
.loopy1 move.w  O_BlitSourcePln(a2),d7  ;planes loop
    lea 4*6(a2),a0      ;source bpl
    move.l  a2,a1           ;target bpl
.loopp1 move.w  d4,d6           ;x loop
    move.l  (a0),a4         ;bpl pointer source
    move.l  (a1),a5         ;bpl pointer target
.loopx1 moveq.l #0,d0
    move.b  (a4)+,d0        ;get byte
    add.w   d0,d0
    move.w  (a3,d0.w),(a5)+     ;use table
    dbra    d6,.loopx1
    move.l  (a1),a6
    add.l   d2,(a0)+
    add.l   d3,(a1)+
    move.w  O_BlitHeight(a2),d1
    beq.s   .noyst1
    subq.l  #4,a1
    subq.w  #1,d1
.ywlop1 move.l  (a1),a5
    move.l  a6,a4
    move.w  d4,d6
.yclop1 move.w  (a4)+,(a5)+
    dbra    d6,.yclop1
    add.l   d3,(a1)
    dbra    d1,.ywlop1
    addq.l  #4,a1
.noyst1 dbra    d7,.loopp1
    dbra    d5,.loopy1
    movem.l (sp)+,a3-a6
    rts

.z2 movem.l a3-a6,-(sp)
    lea O_Zoom4Buf(a2),a3
.loopy2 move.w  O_BlitSourcePln(a2),d7  ;planes loop
    lea 4*6(a2),a0      ;source bpl
    move.l  a2,a1           ;target bpl
.loopp2 move.w  d4,d6           ;x loop
    move.l  (a0),a4         ;bpl pointer source
    move.l  (a1),a5         ;bpl pointer target
.loopx2 moveq.l #0,d0
    move.b  (a4)+,d0        ;get byte
    lsl.w   #2,d0
    move.l  (a3,d0.w),(a5)+     ;use table
    dbra    d6,.loopx2
    move.l  (a1),a6
    add.l   d2,(a0)+
    add.l   d3,(a1)+
    move.w  O_BlitHeight(a2),d1
    beq.s   .noyst2
    subq.l  #4,a1
    subq.w  #1,d1
.ywlop2 move.l  (a1),a5
    move.l  a6,a4
    move.w  d4,d6
.yclop2 move.l  (a4)+,(a5)+
    dbra    d6,.yclop2
    add.l   d3,(a1)
    dbra    d1,.ywlop2
    addq.l  #4,a1
.noyst2 dbra    d7,.loopp2
    dbra    d5,.loopy2
    movem.l (sp)+,a3-a6
    rts

.z3 movem.l a3-a6,-(sp)
    lea O_Zoom8Buf(a2),a3
.loopy3 move.w  O_BlitSourcePln(a2),d7  ;planes loop
    lea 4*6(a2),a0      ;source bpl
    move.l  a2,a1           ;target bpl
.loopp3 move.w  d4,d6           ;x loop
    move.l  (a0),a4         ;bpl pointer source
    move.l  (a1),a5         ;bpl pointer target
.loopx3 moveq.l #0,d0
    move.b  (a4)+,d0        ;get byte
    lsl.w   #3,d0
    move.l  (a3,d0.w),(a5)+     ;use table
    move.l  4(a3,d0.w),(a5)+
    dbra    d6,.loopx3
    move.l  (a1),a6
    add.l   d2,(a0)+
    add.l   d3,(a1)+
    move.w  O_BlitHeight(a2),d1
    beq.s   .noyst3
    subq.l  #4,a1
    subq.w  #1,d1
.ywlop3 move.l  (a1),a5
    move.l  a6,a4
    move.w  d4,d6
.yclop3 move.l  (a4)+,(a5)+
    move.l  (a4)+,(a5)+
    dbra    d6,.yclop3
    add.l   d3,(a1)
    dbra    d1,.ywlop3
    addq.l  #4,a1
.noyst3 dbra    d7,.loopp3
    dbra    d5,.loopy3
    movem.l (sp)+,a3-a6
    rts

    Lib_Par      BCircle       *** Bcircle x,y,r,plane
    
    move.l  (a3)+,d3
    Rbmi    L_IFonc
    cmp.w   #6,d3
    Rbge    L_IFonc
    move.l  ScOnAd(a5),a2
    lsl.l   #2,d3
    move.l  (a2,d3.l),a1
    move.l  a1,d0
    Rbeq    L_IFonc
    move.l  (a3)+,d7
    Rbmi    L_IFonc
    bne.s   .dcont
    addq.l  #8,a3
    rts
;   move.l  (a3)+,d1
;   move.l  (a3)+,d0
;   bra.s   .plot
.dcont  move.l  (a3)+,d6
    move.l  (a3)+,d5
    move.w  d5,d0
    move.w  d6,d1
    sub.w   d7,d0
    bsr.s   .plot
    move.w  d5,d0
    move.w  d6,d1
    add.w   d7,d0
    bsr.s   .plot
    move.l  d7,d4
    mulu    d4,d4
.loop   move.l  d7,d2
    mulu    d2,d2
    neg.l   d2
    add.l   d4,d2
    tst.l   d2
    bne.s   .sqcont
    moveq.l #0,d2
    bra.s   .sqrred
.sqcont Rbmi    L_IFonc
    moveq.l #0,d0
    move.l  d2,d3
.sqloop move.l  d2,d1
    move.l  d3,d2
    divu    d1,d2
    and.l   #$FFFF,d2
    add.l   d1,d2
    lsr.l   d2
    addx.l  d0,d2
    cmp.l   d2,d1
    bne.s   .sqloop
.sqrred move.w  d5,d0
    sub.w   d2,d0
    move.w  d6,d1
    sub.w   d7,d1
    bsr.s   .plot
    move.w  d5,d0
    add.w   d2,d0
    move.w  d6,d1
    sub.w   d7,d1
    bsr.s   .plot
    move.w  d5,d0
    sub.w   d2,d0
    move.w  d6,d1
    add.w   d7,d1
    bsr.s   .plot
    move.w  d5,d0
    add.w   d2,d0
    move.w  d6,d1
    add.w   d7,d1
    bsr.s   .plot
    tst.w   d7
    beq.s   .plquit
    subq.w  #1,d7
    bra.s   .loop
.plot   tst.w   d0
    bpl.s   .plcont
.plquit rts
.plcont tst.w   d1
    bmi.s   .plquit
    cmp.w   EcTy(a2),d1
    bge.s   .plquit
    move.w  EcTx(a2),d3
    cmp.w   d3,d0
    blt.s   .plnobo
    move.w  d3,d0
    subq.w  #1,d0
.plnobo lsr.w   #3,d3
    mulu    d3,d1
    move.w  d0,d3
    lsr.w   #3,d3
    add.w   d3,d1
    not.b   d0
    bchg    d0,(a1,d1.w)
    rts

    IFEQ    1
    Lib_Par      QZoom         *** Qzoom s1,x1,y1,x2,y2 To s2,x3,y3,x4,y4
    
;   MOVE.L  A3,-(SP)
    LEA -$1A(SP),SP
    MOVE.L  $24(A3),D1      ;s1
    Rjsr    L_GetEc
    MOVE.L  A0,A1           ;Sourcescreen
    MOVE.L  D0,8(SP)        ;Sourcenumber->8(sp)
    MOVE.L  $10(A3),D1      ;s2
    Rjsr    L_GetEc
    MOVE.L  A0,A2           ;Targetscreen
    MOVE.L  D0,12(SP)       ;Targetnumber->12(sp)
    MOVE.W  EcNPlan(A1),D0
    CMP.W   EcNPlan(A2),D0
    BLS.S   lbC00D584
    MOVE.W  EcNPlan(A2),D0
lbC00D584
    SUBQ.W  #1,D0
    MOVE.W  D0,$18(SP)      ;MaxPlanes->24(sp)
    MOVE.L  #$1000,D0
    SyCall  91          ;MemFast
    Rbeq    L_IOoMem
    MOVE.L  A0,(SP)         ;TempBuffer->(sp)
    MOVE.L  4(A3),D5        ;x4
    bmi lbC00D70C
    CMP.W   EcTx(A2),D5     ;EcTx
    BHI lbC00D70C
    MOVE.L  12(A3),D4       ;x3
    CMP.L   D5,D4
    BCC lbC00D70C
    MOVE.L  $18(A3),D3      ;x2
    BMI lbC00D70C
    CMP.W   EcTx(A1),D3     ;EcTx
    BHI lbC00D70C
    MOVE.L  $20(A3),D2      ;x1
    CMP.L   D3,D2
    BCC lbC00D70C
    MOVEQ.L #7,D6
    MOVEQ.L #7,D7
    MOVEQ.L #0,D0
    MOVE.W  D2,D0           ;x1
    LSR.W   #3,D0           ;x1 div 8
    MOVE.L  D0,$10(SP)      ;x1->16(sp)
    MOVE.W  D2,D0           ;x1
    AND.W   d6,D0           ;x1 mod 8
;   ASR.W   D5,D0           ;??? ->x1>>x4
    sub.w   d0,d6           ;7-(x3 mod 8)
    MOVE.W  D4,D0           ;x3
    LSR.W   #3,D0           ;x3 div 8
    MOVE.L  D0,$14(SP)      ;x3->20(sp)
    MOVE.W  D4,D0           ;x3
    AND.W   d7,D0           ;x3 mod 8
    SUB.W   D0,D7           ;7-(x3 mod 8)
    BSR lbC00D722
    MOVE.L  (A3),D5         ;y4
    BMI lbC00D70C
    CMP.W   $4E(A2),D5
    BHI lbC00D70C
    MOVE.L  8(A3),D4        ;y3
    CMP.L   D5,D4
    BCC lbC00D70C
    MOVE.L  $14(A3),D3      ;y2
    BMI lbC00D70C
    CMP.W   EcTy(A1),D3
    BHI lbC00D70C
    MOVE.L  $1C(A3),D2      ;y1
    CMP.L   D3,D2
    BCC lbC00D70C
    MOVE.W  D2,D0           ;y1
    MULU    $B2(A1),D0      ;??? (Modulo X)
    ADD.L   D0,$10(SP)      ;16(sp)=x1+y1*mx
    MOVE.W  D4,D0           ;y3
    MULU    $B2(A2),D0      ;??? (Modulo X)
    ADD.L   D0,$14(SP)      ;20(sp)=x3+y3*mx
    MOVE.L  A0,4(SP)        ;TempAddress->4(sp)
    BSR lbC00D722
    MOVEQ.L #0,D4
    MOVEQ.L #0,D5
    MOVE.W  $B2(A1),D4      ;??? (Modulo X)
    MOVE.W  $B2(A2),D5      ;??? (Modulo X)
    MOVE.L  (SP),A0         ;Tempbuffer
    MOVEQ.L #0,D0
    MOVE.W  (A0)+,D0        ;SX skip
    BEQ.S   lbC00D67C
    BMI lbC00D6E8
lbC00D668
    MOVE.W  D0,D1
    LSR.W   #3,D0           ;(SX skip) div 8
    AND.W   #7,D1           ;(SX skip)/8
    SUB.W   D1,D6           ;SX=SX-SX skip
    BCC.S   lbC00D678       ;(SX mod 8) still>-1
    ADDQ.L  #1,D0           ;Inc Screenpos
    ADDQ.W  #8,D6           ;SX=SX+8
lbC00D678
    ADD.L   D0,$10(SP)      ;Add to Screenpos
lbC00D67C
    MOVE.W  $18(SP),D1      ;Numb of Planes
    MOVE.L  8(SP),A4        ;Sourcenumber
    MOVE.L  12(SP),A5       ;Targetnumber
lbC00D688
    MOVE.L  (A4)+,A2        ;Logbase(n)
    MOVE.L  (A5)+,A3        ;Logbase(n)
    MOVE.L  $10(SP),D2      ;Screenpos1
    MOVE.L  $14(SP),D3      ;Screenpos2
    MOVE.L  4(SP),A1        ;TempAddress
    MOVE.W  (A1)+,D0        ;SY skip
lbC00D69A
    BMI.S   lbC00D6D2       ;End of Plane
    MULU    D4,D0           ;Modulo X1
    ADD.L   D0,D2
    BTST    D6,(A2,D2.L)        ;Test Sourcepixel
    BEQ.S   lbC00D6BC
    BSET    D7,(A3,D3.L)        ;Set Targetpixel
    ADD.L   D5,D3           ;Inc TY
    MOVE.W  (A1)+,D0        ;SY skip
    BNE.S   lbC00D69A       ;Next line
lbC00D6B0
    BSET    D7,(A3,D3.L)        ;Set TY Targetpixel
    ADD.L   D5,D3           ;Inc TY
    MOVE.W  (A1)+,D0        ;SY skip
    BEQ.S   lbC00D6B0       ;Same line
    BRA.S   lbC00D69A       ;Next line

lbC00D6BC
    BCLR    D7,(A3,D3.L)        ;Clr TY Targetpixel
    ADD.L   D5,D3           ;Inc TY
    MOVE.W  (A1)+,D0        ;SY skip
    BNE.S   lbC00D69A       ;Next line
lbC00D6C6
    BCLR    D7,(A3,D3.L)        ;Clr TY Targetpixel
    ADD.L   D5,D3           ;Inc TY
    MOVE.W  (A1)+,D0        ;SY skip
    BEQ.S   lbC00D6C6       ;Same line
    BRA.S   lbC00D69A       ;Next line

lbC00D6D2
    DBRA    D1,lbC00D688        ;Next plane
    SUBQ.W  #1,D7           ;Inc TX
    BCC.S   lbC00D6E0
    MOVEQ.L #7,D7
    ADDQ.L  #1,$14(SP)      ;Inc Screenpos
lbC00D6E0
    MOVEQ.L #0,D0
    MOVE.W  (A0)+,D0        ;SX skip
    BEQ.S   lbC00D67C       ;Same row
    BPL.S   lbC00D668       ;Next row
lbC00D6E8
    MOVE.L  (SP),A1         ;Tempbuffer
    LEA $1A(SP),SP
;   MOVE.L  (SP)+,A3
    LEA $28(A3),A3
    MOVE.L  #$1000,D0
    SyCall  88          ;MemFree
    RTS

lbC00D70C
    MOVE.L  (SP),A1
    MOVE.L  #$1000,D0
    SyCall  88          ;MemFree
    Rbra    L_IFonC

lbC00D722
    SUB.W   D2,D3
    SUB.W   D4,D5
    CMP.W   D3,D5
    BCC.S   lbC00D74A
    MOVEQ.L #-1,D0
    MOVE.W  D3,D2
    MOVE.W  D3,D4
    SUBQ.W  #1,D4
    SUBQ.W  #1,D2
lbC00D734
    ADDQ.W  #1,D0
    SUB.W   D5,D4
    BCC.S   lbC00D740
    ADD.W   D3,D4
    MOVE.W  D0,(A0)+
    MOVEQ.L #0,D0
lbC00D740
    DBRA    D2,lbC00D734
    MOVE.W  #$FFFF,(A0)+
    RTS

lbC00D74A
    CLR.W   (A0)+
    MOVE.W  D5,D4
    MOVE.W  D5,D2
    SUBQ.W  #2,D2
    BMI.S   lbC00D76C
    SUBQ.W  #1,D5
lbC00D756
    SUB.W   D3,D5
    BCC.S   lbC00D766
    ADD.W   D4,D5
    MOVE.W  #1,(A0)+
    DBRA    D2,lbC00D756
    BRA.S   lbC00D76C
 
lbC00D766
    CLR.W   (A0)+
    DBRA    D2,lbC00D756
lbC00D76C
    MOVE.W  #$FFFF,(A0)+
    RTS
    ENDC
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
;    include "Amcaf/Private.asm"
    IFEQ    1
    Lib_Par      PrivateA      *** Private A bank1,bank2,bp,r
    
    dload   a2
    move.l  (a3)+,d6
    move.l  (a3)+,d7
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  a0,O_TempBuffer(a2)
    move.l  a0,O_TempBuffer+4(a2)
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.l  a0,O_TempBuffer+8(a2)
.loop   move.l  O_TempBuffer+8(a2),a0
    tst.l   d6
    beq .nornd
    moveq.l #0,d5
    move.l  d6,-(a3)
    Rbsr    L_QRnd
    add.w   d3,d3
    sub.w   d6,d3
    asr.w   #1,d3
    move.w  (a0)+,d5
    cmp.w   #-999,d5
    beq .drlbak
    add.w   d3,d5
    move.l  d5,-(a3)
    move.l  d6,-(a3)
    Rbsr    L_QRnd
    add.w   d3,d3
    sub.w   d6,d3
    asr.w   #1,d3
    move.w  (a0)+,d5
    add.w   d3,d5
    move.l  d5,-(a3)
    move.l  d6,-(a3)
    Rbsr    L_QRnd
    add.w   d3,d3
    sub.w   d6,d3
    asr.w   #1,d3
    move.w  (a0)+,d5
    add.w   d3,d5
    move.l  d5,-(a3)
.rndbak move.l  a0,O_TempBuffer+8(a2)
    movem.l d6/d7,-(sp)
    Rbsr    L_VecRotX3
    movem.l (sp)+,d6/d7
    move.l  O_TempBuffer+4(a2),a0
    cmp.l   O_TempBuffer(a2),a0
    bne.s   .dralin
    add.w   #160,d3
    move.w  d3,(a0)+
    move.w  O_VecRotResY(a2),d3
    add.w   #128,d3
    move.w  d3,(a0)+
    move.l  a0,O_TempBuffer+4(a2)
    bra.s   .loop
.dralin moveq.l #0,d0
    move.w  -4(a0),d0
    move.l  d0,-(a3)
    move.w  -2(a0),d0
    move.l  d0,-(a3)
    add.w   #160,d3
    move.w  d3,(a0)+
    move.w  d3,d0
    move.l  d3,-(a3)
    move.w  O_VecRotResY(a2),d3
    add.w   #128,d3
    move.w  d3,d0
    move.l  d3,-(a3)
    moveq.l #15,d0
    move.l  d0,-(a3)
    move.l  d7,-(a3)
    move.w  d3,(a0)+
    move.l  a0,O_TempBuffer+4(a2)
    movem.l a0-a2/d6-d7,-(sp)
    Rbsr    L_TurboDraw6
    movem.l (sp)+,a0-a2/d6-d7
    bra .loop
.drlbak addq.l  #4,a0
    move.l  a0,O_TempBuffer+8(a2)
    move.l  O_TempBuffer(a2),a0
    move.l  O_TempBuffer+4(a2),a1
    cmp.l   a1,a0
    bne.s   .cont
    move.l  O_TempBuffer+4(a2),a0
    move.w  #-999,(a0)+
    move.w  #-999,(a0)+
    rts
.cont   moveq.l #0,d0
    move.w  -4(a1),d0
    move.l  d0,-(a3)
    move.w  -2(a1),d0
    move.l  d0,-(a3)
    move.w  (a0),d0
    move.l  d0,-(a3)
    move.w  2(a0),d0
    move.l  d0,-(a3)
    moveq.l #15,d0
    move.l  d0,-(a3)
    move.l  d7,-(a3)
    movem.l a0-a2/d6-d7,-(sp)
    Rbsr    L_TurboDraw6
    movem.l (sp)+,a0-a2/d6-d7
    move.l  a1,O_TempBuffer(a2)
    bra .loop

.nornd  moveq.l #0,d5
    move.w  (a0)+,d5
    cmp.w   #-999,d5
    beq .drlbak
    move.l  d5,-(a3)
    move.w  (a0)+,d5
    move.l  d5,-(a3)
    move.w  (a0)+,d5
    move.l  d5,-(a3)
    bra .rndbak

    Lib_Par      PrivateB      *** =PrivateB(bank)
    
    dload   a2
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.w  #320,d6
    moveq.l #0,d7
.loop   move.w  (a0),d0
    cmp.w   #-999,d0
    beq.s   .ende
    addq.l  #4,a0
    cmp.w   d6,d0
    bpl.s   .nomin
    move.w  d0,d6
.nomin  cmp.w   d0,d7
    bpl.s   .loop
    move.w  d0,d7
    bra.s   .loop
.ende   move.w  d6,d3
    swap    d3
    move.w  d7,d3
    moveq.l #0,d2
    rts

    Lib_Par      PrivateC      *** =PrivateC(bank)
    
    dload   a2
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    move.w  #256,d6
    moveq.l #0,d7
    addq.l  #2,a0
.loop   move.w  (a0),d0
    cmp.w   #-999,d0
    beq.s   .ende
    addq.l  #4,a0
    cmp.w   d6,d0
    bpl.s   .nomin
    move.w  d0,d6
.nomin  cmp.w   d0,d7
    bpl.s   .loop
    move.w  d0,d7
    bra.s   .loop
.ende   move.w  d6,d3
    swap    d3
    move.w  d7,d3
    moveq.l #0,d2
    rts
    ENDC

digitbits   EQU 9           ; 2er-Logarithmus von digitn
digitn      EQU 1<<digitbits    ; Anzahl der Werte

    IFEQ    1
    Lib_Par      FFTStop       *** Fft Stop
    dload   a2
    tst.w   O_FFTEnable(a2)
    beq.s   .skipit
    Rbsr    L_LLOpenLib
    move.l  O_FFTInt(a2),a1
    move.l  a6,d7
    move.l  O_LowLevelLib(a2),a6
    jsr _LVORemTimerInt(a6)
    move.l  d7,a6
    clr.w   O_FFTEnable(a2)
.skipit rts

    Lib_Par      FFTStart      *** Fft Start bank,rate
    Rbsr    L_FFTStop
    Rbsr    L_LLOpenLib
    dload   a2
    move.l  (a3)+,d6
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr
    add.l   #512,a0
    move.l  a0,O_FFTBank(a2)
    moveq.l #0,d0
    Rbsr    L_DoFFT
    clr.w   O_FFTState(a2)
    lea .sampleandfft(pc),a0
    move.l  a2,a1
    move.l  a6,d7
    move.l  O_LowLevelLib(a2),a6
    jsr _LVOAddTimerInt(a6)
    move.l  d7,a6
    move.l  d0,O_FFTInt(a2)
    beq.s   .err
    move.l  d6,d0
    moveq.l #-1,d1
    move.l  O_FFTInt(a2),a1
    move.l  O_LowLevelLib(a2),a6
    jsr _LVOStartTimerInt(a6)
    move.l  d7,a6
    st  O_FFTEnable(a2)
.err    rts

.sampleandfft
    move.w  O_FFTState(a1),d0
    move.l  O_FFTBank(a1),a0
;   clr.b   $BFE301
.busy   btst    #0,$BFD000
    beq.s   .busy
    move.b  $bfe101,d1
    add.b   #$80,d1
    move.b  d1,(a0,d0.w)
    addq.w  #1,d0
    cmp.w   #512,d0
    beq.s   .dofft
    move.w  d0,O_FFTState(a1)
    cmp.w   #128,d0
    beq.s   .dofft1
    cmp.w   #256,d0
    beq.s   .dofft2 
    cmp.w   #384,d0
    beq.s   .dofft3 
    moveq.l #0,d0
    rts
.dofft2 movem.l a2-a4/d2-d7,-(sp)
    lea 512(a0),a1
    lea -256(a0),a0
.dofftc Rbsr    L_DoFFT
    movem.l (sp)+,a2-a4/d2-d7
    moveq.l #0,d0
    rts
.dofft1 movem.l a2-a4/d2-d7,-(sp)
    lea 512(a0),a1
    lea -384(a0),a0
    bra.s   .dofftc
.dofft3 movem.l a2-a4/d2-d7,-(sp)
    lea 512(a0),a1
    lea -128(a0),a0
    bra.s   .dofftc
.dofft  movem.l a2-a4/d2-d7,-(sp)
    move.l  a0,a3
    clr.w   O_FFTState(a1)
    lea 512(a0),a1
    move.l  a1,a2
    moveq.l #63,d0
.cploop move.l  -(a2),-(a3)
    dbra    d0,.cploop
    Rbsr    L_DoFFT
.skipit movem.l (sp)+,a2-a4/d2-d7
    moveq.l #0,d0
    rts
    ENDC
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
    dc.b    '32K-LIMIT!'
    even

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
;    include "Amcaf/NonTokenFuncs.asm"
    Lib_Par      FreeExtMem        +++ FreeExtMem
    movem.l a0-a2/d0-d1,-(sp)
    dload   a2
    move.l  O_BufferLength(a2),d0
    beq.s   .nomem
    move.l  O_BufferAddress(a2),a1
    move.l  a6,-(sp)
    move.l  4.w,a6
    jsr _LVOFreeMem(a6)
    move.l  (sp)+,a6
    clr.l   O_BufferLength(a2)
    clr.l   O_BufferAddress(a2)
.nomem  movem.l (sp)+,a0-a2/d0-d1
    rts

    Lib_Par      CdMonth2      +++ Month
    move.b  d3,d4
    and.b   #%11,d4
    lea .monlen(pc),a1
    moveq.l #0,d3
    moveq.l #31,d1
.mnloop cmp.l   d1,d0
    blt.s   .quit
    addq.b  #1,d3
    sub.l   d1,d0
    move.b  (a1,d3.w),d1
    tst.b   d4
    bne.s   .mnloop
    cmp.b   #1,d3
    bne.s   .mnloop
    addq.b  #1,d1
    bra.s   .mnloop
.quit   addq.b  #1,d3
    rts
.monlen dc.b    99,28,31,30,31,30,31,31,30,31,30,31 
    even

    Lib_Par      ConvertGreyNoToken
    IFEQ    demover
    lea -24(sp),sp
    dload   a2
    lea O_ParseBuffer(a2),a0
    move.l  a0,4(sp)        ;Divison Table
    moveq.l #0,d0
    moveq.l #63,d1
.tbloop move.b  d0,(a0)+
    move.b  d0,(a0)+
    addq.b  #1,d0
    move.b  d0,(a0)+
    dbra    d1,.tbloop
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,8(sp)        ;Screen Base Target
    move.l  a0,a2
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a1
    moveq.l #0,d6
    move.w  EcTx(a1),d6     ;width
    lsr.w   #3,d6
    move.l  d6,12(sp)       ;Modulo Source
    move.w  EcTx(a2),d6     ;height
    lsr.w   #3,d6
    move.l  d6,16(sp)       ;Modulo Target
    move.w  EcTx(a1),d6     ;width
    move.w  EcTy(a1),d7     ;height
    move.w  EcTx(a2),d0
    cmp.w   d0,d6
    bls.s   .keepwi
    move.w  d0,d6
.keepwi subq.w  #1,d6
    move.w  EcTy(a2),d0
    cmp.w   d0,d7
    bls.s   .keephe
    move.w  d0,d7
.keephe subq.w  #1,d7
    move.w  d6,20(sp)       ;Width
    move.w  d7,22(sp)       ;Height
    move.w  EcNPlan(a2),d5
    subq.w  #1,d5
    move.w  d5,2(sp)        ;Planes Target
    move.w  EcNPlan(a1),d5
    subq.w  #1,d5
    move.w  d5,(sp)         ;Planes Source

    moveq.l #0,d1
    moveq.l #0,d2
    cmp.w   #5,d5
    bne.s   .yloop
    move.w  EcCon0(a1),d0
    btst    #11,d0
    beq.s   .yloope
    bra .ylooph
.yloop  move.w  20(sp),d6
    moveq.l #0,d0
.xloop  bsr.s   .getpix
    bsr .convgr
    bsr.s   .putpix
    addq.w  #1,d0
    dbra    d6,.xloop
    add.l   12(sp),d1       ;Add Modulo Source
    add.l   16(sp),d2       ;Add Modulo Target
    dbra    d7,.yloop
    lea 24(sp),sp
    rts
.yloope move.w  20(sp),d6
    moveq.l #0,d0
.xloope bsr.s   .getpix
    bsr .ehbcon
    bsr.s   .putpix
    addq.w  #1,d0
    dbra    d6,.xloope
    add.l   12(sp),d1       ;Add Modulo Source
    add.l   16(sp),d2       ;Add Module Target
    dbra    d7,.yloope
    lea 24(sp),sp
    rts
.getpix movem.l d1/d2,-(sp)
    move.w  d0,d5
    lsr.w   #3,d5
    add.l   d5,d1
    move.b  d0,d5
    not.b   d5
    moveq.l #0,d3
    moveq.l #0,d2
    move.w  12(sp),d4
    move.l  a1,a2
.gloop  move.l  (a2)+,a0
    btst    d5,(a0,d1.l)
    beq.s   .skip
    bset    d2,d3
.skip   addq.b  #1,d2
    dbra    d4,.gloop
    movem.l (sp)+,d1/d2
    rts
.putpix movem.l d1/d2,-(sp)
    move.w  d0,d1
    lsr.w   #3,d1
    add.l   d1,d2
    move.b  d0,d5
    not.b   d5
    moveq.l #0,d1
    move.w  2+12(sp),d4
    move.l  8+12(sp),a2
.sloop  move.l  (a2)+,a0
    btst    d1,d3
    bne.s   .setbit
    bclr    d5,(a0,d2.l)
    addq.b  #1,d1
    dbra    d4,.sloop
    movem.l (sp)+,d1/d2
    rts
.setbit bset    d5,(a0,d2.l)
    addq.w  #1,d1
    dbra    d4,.sloop
    movem.l (sp)+,d1/d2
    rts
.convgr add.w   d3,d3
    move.w  EcPal-4(a1,d3.w),d4
    move.w  d4,d3
    and.w   #$F,d3
    lsr.w   #4,d4
    move.w  d4,d5
    and.w   #$F,d5
    add.w   d5,d3
    lsr.w   #4,d4
    add.w   d4,d3
    move.w  2+4(sp),d4
    lsl.w   d4,d3
    lsr.w   #3,d3
    move.l  4+4(sp),a0
    move.b  (a0,d3.w),d3
    rts
.ehbcon cmp.w   #31,d3
    bls.s   .convgr
    add.w   d3,d3
    move.w  EcPal-4-32*2(a1,d3.w),d4
    move.w  d4,d3
    and.w   #$F,d3
    lsr.w   #4,d4
    move.w  d4,d5
    and.w   #$F,d5
    add.w   d5,d3
    lsr.w   #4,d4
    add.w   d4,d3
    move.w  2+4(sp),d4
    lsl.w   d4,d3
    lsr.w   #4,d3
    move.l  4+4(sp),a0
    move.b  (a0,d3.w),d3
    rts
.ylooph move.w  EcPal-4(a1),d5
    move.w  20(sp),d6
    moveq.l #0,d0
.xlooph bsr.s   .getham
    bsr.s   .hamcon
    bsr .putham
    addq.w  #1,d0
    dbra    d6,.xlooph
    add.l   12(sp),d1       ;Add Modulo Source
    add.l   16(sp),d2       ;Add Modulo Target
    dbra    d7,.ylooph
    lea 24(sp),sp
    rts
.getham movem.l d1/d2/d5,-(sp)
    move.w  d0,d5
    lsr.w   #3,d5
    add.l   d5,d1
    move.b  d0,d5
    not.b   d5
    moveq.l #0,d3
    moveq.l #0,d2
    moveq.w #5,d4
    move.l  a1,a2
.hloop  move.l  (a2)+,a0
    btst    d5,(a0,d1.l)
    beq.s   .skip2
    bset    d2,d3
.skip2  addq.b  #1,d2
    dbra    d4,.hloop
    movem.l (sp)+,d1/d2/d5
    rts
.hamcon cmp.b   #15,d3
    bls.s   .low16
    cmp.b   #31,d3
    bls.s   .blu16
    cmp.b   #47,d3
    bls.s   .red16
    sub.b   #48,d3
    lsl.b   #4,d3
    and.b   #$0F,d5
    or.b    d3,d5
    bra.s   .jmpham
.blu16  sub.b   #16,d3
    and.b   #$F0,d5
    or.b    d3,d5
    bra.s   .jmpham
.red16  sub.b   #32,d3
    lsl.w   #8,d3
    and.w   #$0FF,d5
    or.w    d3,d5
    bra.s   .jmpham
.low16  add.w   d3,d3
    move.w  EcPal-4(a1,d3.w),d5
.jmpham move.w  d5,d3
    move.w  d5,d4
    and.w   #$F,d3
    lsr.w   #4,d4
    and.w   #$F,d4
    add.w   d4,d3
    move.w  d5,d4
    lsr.w   #8,d4
    add.w   d4,d3
    move.w  2+4(sp),d4
    lsl.w   d4,d3
    lsr.w   #3,d3
    move.l  4+4(sp),a0
    move.b  (a0,d3.w),d3
    rts
.putham movem.l d1/d2/d5,-(sp)
    move.w  d0,d1
    lsr.w   #3,d1
    add.l   d1,d2
    move.b  d0,d5
    not.b   d5
    moveq.l #0,d1
    move.w  2+16(sp),d4
    move.l  8+16(sp),a2
.sloop2 move.l  (a2)+,a0
    btst    d1,d3
    bne.s   .setbi2
    bclr    d5,(a0,d2.l)
    addq.b  #1,d1
    dbra    d4,.sloop2
    movem.l (sp)+,d1/d2/d5
    rts
.setbi2 bset    d5,(a0,d2.l)
    addq.w  #1,d1
    dbra    d4,.sloop2
    movem.l (sp)+,d1/d2/d5
    rts
    ELSE
    addq.l  #8,a3
    rts
    ENDC

    Lib_Par      OpenFile      +++ a0=Filename->d0/d1=Filehandle 
    movem.l d2/a1,-(sp)
    Rbsr    L_MakeZeroFile
    move.l  a0,d1
    move.l  #1005,d2
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOOpen(a6)
    move.l  (sp)+,a6
    move.l  d0,d1
    movem.l (sp)+,d2/a1
    rts

    Lib_Par      OpenFileW     +++ a0=Filename->d0/d1=Filehandle 
    movem.l d2/a1,-(sp)
    Rbsr    L_MakeZeroFile
    move.l  a0,d1
    move.l  #1006,d2
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOOpen(a6)
    move.l  (sp)+,a6
    move.l  d0,d1
    movem.l (sp)+,d2/a1
    rts

    Lib_Par      LengthOfFile      +++ d1=Filehandle->d0=Filelength
    movem.l d2/d3/a6,-(sp)
    move.l  d1,-(sp)
    moveq   #0,d2
    moveq   #1,d3
    move.l  DosBase(a5),a6
    jsr _LVOSeek(a6)
    move.l  (sp),d1
    moveq   #0,d2
    moveq   #-1,d3
    move.l  DosBase(a5),a6
    jsr _LVOSeek(a6)
    move.l  (sp)+,d1
    movem.l (sp)+,d2/d3/a6
    rts

    Lib_Par      ReadFile      +++ a0=Buffer,d0=Length,d1=Filehandle
    movem.l a0/d1-d4,-(sp)
    move.l  a0,d2
    move.l  d0,d3
    move.l  d0,d4
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVORead(a6)
    move.l  (sp)+,a6
    cmp.l   d0,d4
    movem.l (sp)+,a0/d1-d4
    rts

    Lib_Par      WriteFile     +++ a0=Buffer,d0=Length,d1=Filehandle
    movem.l a0/d1-d4,-(sp)
    move.l  a0,d2
    move.l  d0,d3
    move.l  d0,d4
    move.l  a6,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOWrite(a6)
    move.l  (sp)+,a6
    cmp.l   d0,d4
    movem.l (sp)+,a0/d1-d4
    rts

    Lib_Par      CloseFile     +++ d1=Filehandle
    movem.l a6/a0/a1,-(sp)
    move.l  DosBase(a5),a6
    jsr _LVOClose(a6)
    movem.l (sp)+,a6/a0/a1
    rts

    Lib_Par      MakeZeroFile      +++ a0=AMOS String->a0=DOS String
    movem.l d0/a1-a2,-(sp)
    move.w  (a0)+,d0
    subq.w  #1,d0   
    cmp.w   #128,d0         ;String empty?
    Rbcc    L_IFonc         ;Yes, then Illegal function call
    move.l  Name1(a5),a1
.loop   move.b  (a0)+,(a1)+     ;Copy filename into buffer
    dbra    d0,.loop
    clr.b   (a1)
    Rjsr    L_Dsk.PathIt        ;And add path
    move.l  Name1(a5),a0
    movem.l (sp)+,d0/a1-a2
    rts

;   Lib_Par      GetScreenData     +++ Get Screen
;   movem.l d0/a0/a2,-(sp)
;   move.l  ScOnAd(a5),a0
;   move.l  a0,d0
;   Rbeq    L_IScNoOpen
;   dload   a2
;   move.l  a0,O_ScreenBase(a2)
;   move.w  EcTx(a0),d0
;   move.w  d0,O_ScreenWidth(a2)
;   lsr.w   #3,d0
;   move.w  d0,O_ScreenWdthByt(a2)
;   move.w  EcTy(a0),O_ScreenHeight(a2)
;   move.w  EcNPlan(a0),O_ScreenDepth(a2)
;   move.w  EcCon0(a0),O_ScreenMode(a2)
;   movem.l (sp)+,d0/a0/a2
;   rts

    Lib_Par      InitArea      +++ Init Area a1=Rastport
    movem.l d0/d1/d5-d7/a0-a2,-(sp)
    dload   a2
    Rbsr    L_FreeExtMem
    move.l  a1,d6
    move.l  a6,d7
    tst.l   16(a1)
    bne.s   .skipar
    lea O_AreaInfo(a2),a0
    move.l  a0,d5
    lea O_Coordsbuffer(a2),a1
    moveq.l #20,d0
    move.l  T_GfxBase(a5),a6
    jsr _LVOInitArea(a6)
    move.l  d7,a6
    move.l  d6,a1
    move.l  d5,16(a1)
    st  O_OwnAreaInfo(a2)
.skipar tst.l   12(a1)
    bne.s   .skiptm
    move.l  ScOnAd(a5),d0
    move.l  d0,a0
    Rbeq    L_IScNoOpen
    move.l  RasLock(a5),d0
    beq.s   .notmpr
    move.l  d0,a1
    moveq.l #0,d0
    move.w  RasSize(a5),d0
    bra.s   .contmp
.notmpr moveq.l #0,d0
    move.w  EcTx(a0),d0
    lsr.w   #3,d0           ;Security buffer! (2 not 3)
    mulu    EcTy(a0),d0
    move.l  d0,d5
    moveq.l #3,d1
    move.l  4.w,a6
    jsr _LVOAllocMem(a6)
    move.l  d7,a6
    tst.l   d0
    Rbeq    L_IOoMem
    dload   a2
    move.l  d0,O_BufferAddress(a2)
    move.l  d5,O_BufferLength(a2)
    move.l  d0,a1
    move.l  d5,d0
.contmp lea O_TmpRas(a2),a0
    move.l  T_GfxBase(a5),a6
    jsr _LVOInitTmpRas(a6)
    move.l  d7,a6
    move.l  d6,a1
    lea O_TmpRas(a2),a0
    move.l  a0,12(a1)
    st  O_OwnTmpRas(a2)
.skiptm movem.l (sp)+,d0/d1/d5-d7/a0-a2
    rts

    Lib_Par      RemoveArea        +++ RemoveArea a1=Rastport
    move.l  a2,-(sp)
    dload   a2
    tst.b   O_OwnAreaInfo(a2)
    beq.s   .skipar
    clr.l   16(a1)
    clr.b   O_OwnAreaInfo(a2)
.skipar tst.b   O_OwnTmpRas(a2)
    beq.s   .skiptm
    clr.l   12(a1)
    clr.b   O_OwnTmpRas(a2)
    Rbsr    L_FreeExtMem
.skiptm move.l  (sp)+,a2
    rts

    Lib_Par      MakeAMOSString    +++ a0=Dos String->d3 AMOS String
    movem.l a0-a2/d0-d2/d4,-(sp)
    move.l  a0,a2
    moveq.l #0,d3
.loop2  tst.b   (a0)+
    beq.s   .exit
    addq.w  #1,d3
    bra.s   .loop2
.exit   move.w  d3,d4
    beq.s   .empstr

    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.w  d4,(a0)+
.loop3  move.b  (a2)+,d0
    beq.s   .quit
    move.b  d0,(a0)+
    bra.s   .loop3
.empstr lea .empty(pc),a0
    move.l  a0,d3
.quit   movem.l (sp)+,a0-a2/d0-d2/d4
    rts
.empty  dc.l    0

    Lib_Par      BCPLAMOSString    +++ a0=BCPL String->d3 AMOS String
    movem.l a0-a2/d0-d2/d4,-(sp)
    moveq.l #0,d3
    move.b  (a0)+,d3
    move.l  a0,a2
    move.w  d3,d4
    beq.s   .empstr

    and.w   #$FFFE,d3
    addq.w  #2,d3
    Rjsr    L_Demande
    lea 2(a1,d3.w),a1
    move.l  a1,HiChaine(a5)
    move.l  a0,d3

    move.w  d4,(a0)+
.loop3  move.b  (a2)+,d0
    beq.s   .quit
    move.b  d0,(a0)+
    bra.s   .loop3
.empstr lea .empty(pc),a0
    move.l  a0,d3
.quit   movem.l (sp)+,a0-a2/d0-d2/d4
    rts
.empty  dc.l    0

    Lib_Par      PPOpenLib     +++ PPOpenLib
    movem.l a0-a2/d0,-(sp)
    dload   a2
    move.l  O_PowerPacker(a2),d0
    bne.s   .ppopen
    lea .ppnam(pc),a1
    moveq.l #35,d0
    move.l  a6,-(sp)
    move.l  4.w,a6
    jsr _LVOOpenLibrary(a6)
    move.l  (sp)+,a6
    move.l  d0,O_PowerPacker(a2)
    bne.s   .ppopen
    moveq.l #5,d0
    Rbra    L_Custom
.ppopen movem.l (sp)+,a0-a2/d0
    rts
.ppnam  dc.b    'powerpacker.library',0
    even

    Lib_Par      LLOpenLib     +++ LLOpenLib
    movem.l a0-a2/d0,-(sp)
    dload   a2
    move.l  O_LowLevelLib(a2),d0
    bne.s   .llopen
    lea .llnam(pc),a1
    moveq.l #39,d0
    move.l  a6,-(sp)
    move.l  4.w,a6
    jsr _LVOOpenLibrary(a6)
    move.l  (sp)+,a6
    move.l  d0,O_LowLevelLib(a2)
    bne.s   .llopen
    moveq.l #17,d0
    Rbra    L_Custom
.llopen movem.l (sp)+,a0-a2/d0
    rts
.llnam  dc.b    'lowlevel.library',0
    even

    Lib_Par      GetBankLength     +++ GetBankLength
    movem.l d0-d1/a0,-(sp)
    move.l  (a3)+,d0
    Rjsr    L_Bnk.OrAdr     ;bank???
    move.w  -12(a0),d1
    and.w   #%1100,d1
    tst.w   d1
    beq.s   .noicon
    moveq.l #4,d0
    Rbra    L_Custom
.noicon move.l  d0,-(a3)
    move.l  -20(a0),d1
    subq.l  #8,d1
    subq.l  #8,d1
    add.l   d1,d0
    move.l  d0,-(a3)
    movem.l (sp)+,d0-d1/a0
    rts

    Lib_Par      CheckOS2      +++ CheckOS2
    movem.l d0/a0,-(sp)
    move.l  4.w,a0
    move.w  20(a0),d0
    cmp.w   #37,d0
    Rblt    L_INotOS2
    movem.l (sp)+,d0/a0
    rts

    Lib_Par      GetKickVer        +++ GetKickVer
    move.l  a0,-(sp)
    move.l  4.w,a0
    move.w  20(a0),d0
    move.l  (sp)+,a0
    rts

    Lib_Par      VecRotDo      +++ x,y,z=-(a3)
    moveq.l #8,d7
    moveq.l #0,d2
    move.l  (a3)+,d3
    move.w  d3,d4
    move.w  d3,d5
    muls    O_VecConstants(a2),d3
    muls    O_VecConstants+6(a2),d4
    muls    O_VecConstants+12(a2),d5
    move.l  (a3)+,d0
    move.w  d0,d1
    move.w  d0,d6
    muls    O_VecConstants+2(a2),d0
    add.l   d0,d3
    muls    O_VecConstants+8(a2),d1
    add.l   d1,d4
    muls    O_VecConstants+14(a2),d6
    add.l   d6,d5
    move.l  (a3)+,d0
    move.w  d0,d1
    move.w  d0,d6
    muls    O_VecConstants+4(a2),d0
    add.l   d0,d3
    muls    O_VecConstants+10(a2),d1
    add.l   d1,d4
    muls    O_VecConstants+16(a2),d6
    add.l   d6,d5
;   moveq.l #0,d0
    move.w  O_VecRotPosX(a2),d0
    ext.l   d0
    asl.l   d7,d0
    add.l   d0,d3
;   moveq.l #0,d0
    move.w  O_VecRotPosY(a2),d0
    ext.l   d0
    asl.l   d7,d0
    add.l   d0,d4
    asr.l   d7,d5
    addx.w  d2,d5
    add.w   O_VecRotPosZ(a2),d5
    move.w  d5,O_VecRotResZ(a2)
    ext.l   d5
    tst.w   d5
    Rbeq    L_IFonc
    ext.l   d5
    divs    d5,d3
    move.w  d3,O_VecRotResX(a2)
    divs    d5,d4
    move.w  d4,O_VecRotResY(a2)
    rts

    Lib_Par      FImp          +++ a0=Decrunch buffer
;   incbin  "data/SanityImp.bin"
    MOVEM.L D2-D5/A2-A4,-(SP)
    MOVE.L  A0,A3
    MOVE.L  A0,A4
    addq.l  #4,a0
    ADD.L   (A0)+,A4
    ADD.L   (A0)+,A3
    MOVE.L  A3,A2
    MOVE.L  (A2)+,-(A0)
    MOVE.L  (A2)+,-(A0)
    MOVE.L  (A2)+,-(A0)
    MOVE.L  (A2)+,D2
    MOVE.W  (A2)+,D3
    BMI.S   .lb17EE
    SUBQ.L  #1,A3
.lb17EE LEA -$1C(SP),SP
    MOVE.L  SP,A1
    MOVEQ.L #6,D0
.lb17F6 MOVE.L  (A2)+,(A1)+
    DBRA    D0,.lb17F6
    MOVE.L  SP,A1
.lb1E70 TST.L   D2
    BEQ.S   .lb1E7A
.lb1E74 MOVE.B  -(A3),-(A4)
    SUBQ.L  #1,D2
    BNE.S   .lb1E74
.lb1E7A CMP.L   A4,A0
    BCS.S   .lb1E92
    LEA $1C(SP),SP
;   MOVEQ.L #-1,D0
;   CMP.L   A3,A0
;   BEQ.S   .lb1E8A
;   MOVEQ.L #0,D0
.lb1E8A MOVEM.L (SP)+,D2-D5/A2-A4
;   TST.L   D0
    RTS

.lb1E92 ADD.B   D3,D3
    BNE.S   .lb1E9A
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1E9A BCC.S   .lb1F04
    ADD.B   D3,D3
    BNE.S   .lb1EA4
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1EA4 BCC.S   .lb1EFE
    ADD.B   D3,D3
    BNE.S   .lb1EAE
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1EAE BCC.S   .lb1EF8
    ADD.B   D3,D3
    BNE.S   .lb1EB8
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1EB8 BCC.S   .lb1EF2
    MOVEQ.L #0,D4
    ADD.B   D3,D3
    BNE.S   .lb1EC4
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1EC4 BCC.S   .lb1ECE
    MOVE.B  -(A3),D4
    MOVEQ.L #3,D0
    SUBQ.B  #1,D4
    BRA.S   .lb1F08
.lb1ECE ADD.B   D3,D3
    BNE.S   .lb1ED6
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1ED6 ADDX.B  D4,D4
    ADD.B   D3,D3
    BNE.S   .lb1EE0
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1EE0 ADDX.B  D4,D4
    ADD.B   D3,D3
    BNE.S   .lb1EEA
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1EEA ADDX.B  D4,D4
    ADDQ.B  #5,D4
    MOVEQ.L #3,D0
    BRA.S   .lb1F08
.lb1EF2 MOVEQ.L #4,D4
    MOVEQ.L #3,D0
    BRA.S   .lb1F08
.lb1EF8 MOVEQ.L #3,D4
    MOVEQ.L #2,D0
    BRA.S   .lb1F08
.lb1EFE MOVEQ.L #2,D4
    MOVEQ.L #1,D0
    BRA.S   .lb1F08
.lb1F04 MOVEQ.L #1,D4
    MOVEQ.L #0,D0
.lb1F08 MOVEQ.L #0,D5
    MOVE.W  D0,D1
    ADD.B   D3,D3
    BNE.S   .lb1F14
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1F14 BCC.S   .lb1F2C
    ADD.B   D3,D3
    BNE.S   .lb1F1E
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1F1E BCC.S   .lb1F28
    MOVE.B  .lb1F8C(PC,D0.W),D5
    ADDQ.B  #8,D0
    BRA.S   .lb1F2C
.lb1F28 MOVEQ.L #2,D5
    ADDQ.B  #4,D0
.lb1F2C MOVE.B  .lb1F90(PC,D0.W),D0
.lb1F30 ADD.B   D3,D3
    BNE.S   .lb1F38
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1F38 ADDX.W  D2,D2
    SUBQ.B  #1,D0
    BNE.S   .lb1F30
    ADD.W   D5,D2
    MOVEQ.L #0,D5
    MOVE.L  D5,A2
    MOVE.W  D1,D0
    ADD.B   D3,D3
    BNE.S   .lb1F4E
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1F4E BCC.S   .lb1F6A
    ADD.W   D1,D1
    ADD.B   D3,D3
    BNE.S   .lb1F5A
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1F5A BCC.S   .lb1F64
    MOVE.W  8(A1,D1.W),A2
    ADDQ.B  #8,D0
    BRA.S   .lb1F6A
.lb1F64 MOVE.W  (A1,D1.W),A2
    ADDQ.B  #4,D0
.lb1F6A MOVE.B  $10(A1,D0.W),D0
.lb1F6E ADD.B   D3,D3
    BNE.S   .lb1F76
    MOVE.B  -(A3),D3
    ADDX.B  D3,D3
.lb1F76 ADDX.L  D5,D5
    SUBQ.B  #1,D0
    BNE.S   .lb1F6E
    ADDQ.W  #1,A2
    ADD.L   D5,A2
    ADD.L   A4,A2
.lb1F82 MOVE.B  -(A2),-(A4)
    DBRA    D4,.lb1F82
    BRA .lb1E70

.lb1F8C dc.l    $060A0A12
.lb1F90 dc.l    $01010101
    dc.l    $02030304
    dc.l    $0405070E

    Lib_Par      PTPlaySam     +++ a0=Adr d0=Len d1=Freq d2=Voice d6=Loop
    dload   a2
    tst.l   d0
    beq.s   .quit
    tst.w   d2
    bgt.s   .cont
    beq.s   .quit
    neg.w   d2
    and.w   #15,d2
    movem.l a0/d0-d1/d6,-(sp)
    move.l  d2,-(a3)
    Rbsr    L_PTFreeVoice1
    move.l  d3,d2
    movem.l (sp)+,a0/d0-d1/d6
    bra.s   .cont
.quit   rts
.cont   and.w   #15,d2
    moveq.l #-1,d5
    move.l  O_PTDataBase(a2),a1
    btst    #0,d2
    beq.s   .skip1
    clr.b   MT_SfxEnable(a1)
    move.w  d5,MT_VblDisable(a1)
.skip1  btst    #1,d2
    beq.s   .skip2
    clr.b   MT_SfxEnable+1(a1)
    move.w  d5,MT_VblDisable+2(a1)
.skip2  btst    #2,d2
    beq.s   .skip3
    clr.b   MT_SfxEnable+2(a1)
    move.w  d5,MT_VblDisable+4(a1)
.skip3  btst    #3,d2
    beq.s   .skip4
    clr.b   MT_SfxEnable+3(a1)
    move.w  d5,MT_VblDisable+6(a1)
.skip4  move.w  d2,$DFF096
    move.w  d2,d5
    movem.l a3/a4,-(sp)
    lsr.l   #1,d0
    cmp.w   #400,d1
    bgt.s   .notolo
    move.w  #400,d1
.notolo cmp.w   #30000,d1
    blt.s   .notohi
    move.w  #30000,d1
.notohi moveq.l #-2,d4          ;continous sound
    tst.l   d6
    bne.s   .loopin
    move.l  d0,d4
    mulu    #100,d4
    divu    d1,d4
    addq.w  #1,d4
.loopin move.l  #3579545,d3
    divu    d1,d3
    lea MT_VblDisable(a1),a1
    lea $DFF0A0,a4
    moveq.l #3,d7
.loop   btst    #0,d2
    beq.s   .novoi
    move.w  d4,(a1)
    move.l  a0,(a4)
    move.w  d0,4(a4)
    move.w  d3,6(a4)
    move.w  O_PTSamVolume(a2),8(a4)
.novoi  addq.l  #2,a1
    lea $10(a4),a4
    lsr.w   #1,d2
    dbra    d7,.loop
    bsr.s   WaitDMA
    move.w  d5,d2
    or.w    #$8000,d2
    move.w  d2,$DFF096
    tst.w   d6
    bne.s   .quit2
    bsr.s   WaitDMA
    lea $DFF0A0,a4
    moveq.l #3,d7
.loop2  btst    #0,d5
    beq.s   .novoi2
    move.l  O_4ByteChipBuf(a2),a3
    move.l  a3,(a4)
    move.w  #1,4(a4)
.novoi2 lea $10(a4),a4
    lsr.w   #1,d5
    dbra    d7,.loop2
.quit2  movem.l (sp)+,a3/a4
    rts
WaitDMA moveq   #5,d0
.loop   move.b  $DFF006,d1
.wait   cmp.b   $DFF006,d1
    beq.s   .wait
    dbf d0,.loop
    rts

    Lib_Par      PTTurnVblOn       +++
    dload   a2
    tst.w   O_PTVblOn(a2)
    beq.s   .cont
    rts
.cont   lea O_PTInterrupt(a2),a1
    lea .introu(pc),a0
    move.l  a0,18(a1)
    lea .intnam(pc),a0
    move.l  a0,10(a1)
    moveq.l #5,d0
    move.l  a6,d7
    move.l  4.w,a6
    jsr _LVOAddIntServer(a6)
    move.l  d7,a6
    move.w  #-1,O_PTVblOn(a2)
    rts
.introu moveq.l #2,d0
    Rbsr    L_PT_Routines
    moveq.l #0,d0
    rts
.intnam dc.b    'Protracker Vbl-Replay',0
    even

    Lib_Par      PTTurnCiaOn       +++
    dload   a2
    tst.w   O_PTCiaOn(a2)
    beq.s   .contci
    rts
.contci move.l  a6,d7
    move.l  T_GfxBase(a5),a1
    move.w  206(a1),d0
    btst    #2,d0
    beq.s   .ntsc
    move.l  #1773447,d6
    bra.s   .cont
.ntsc   move.l  #1789773,d6
.cont   move.l  d6,O_PTTimerSpeed(a2)
    move.l  O_PTDataBase(a2),a1
    divu    MT_CiaSpeed(a1),d6
    move.l  #$BFD000,O_PTCiaBase(a2)
    lea .cianam(pc),a1
    move.b  #'b',3(a1)
.aloop  move.l  4.w,a6
    jsr _LVOOpenResource(a6)
    move.l  d0,O_PTCiaResource(a2)
    beq .error
    move.l  d0,a6
    lea O_PTInterrupt(a2),a1
    lea .introu(pc),a0
    move.l  a0,18(a1)
    lea .intnam(pc),a0
    move.l  a0,10(a1)
    moveq.l #1,d0           ;Timer B
    jsr -6(a6)          ;AddICRVector
    tst.l   d0
    bne.s   .trytia
    move.l  O_PTCiaBase(a2),a1
    move.b  d6,ciatblo(a1)
    lsr.w   #8,d6
    move.b  d6,ciatbhi(a1)
    bset    #0,ciacrb(a1)
    move.w  #1,O_PTCiaTimer(a2)
    move.w  #-1,O_PTCiaOn(a2)
    move.l  d7,a6
    rts
.trytia lea O_PTInterrupt(a2),a1
    moveq.l #0,d0           ;Timer A
    jsr -6(a6)          ;AddICRVector
    tst.l   d0
    bne.s   .rtciaa
    move.l  O_PTCiaBase(a2),a1
    move.b  d6,ciatalo(a1)
    lsr.w   #8,d6
    move.b  d6,ciatahi(a1)
    bset    #0,ciacra(a1)
    clr.w   O_PTCiaTimer(a2)
    move.w  #-1,O_PTCiaOn(a2)
    move.l  d7,a6
    rts
.rtciaa clr.l   O_PTCiaResource(a2)
;   move.l  O_PTCiaResource(a2),a1
;   move.l  4.w,a6
;   jsr _LVOCloseResource(a6)
    move.l  #$BFE001,O_PTCiaBase(a2)
    lea .cianam(pc),a1
    cmp.b   #'a',3(a1)
    beq.s   .error
    move.b  #'a',3(a1)
    bra .aloop
.error  move.l  d7,a6
    moveq.l #16,d0
    Rbra    L_Custom
.cianam dc.b    'cia?.resource',0
    even
.introu moveq.l #2,d0
    Rbsr    L_PT_Routines
    moveq.l #0,d0
    rts
.intnam dc.b    'Protracker CIA-Replay',0
    even

    Lib_Par      PTTurnVblOff      +++
    dload   a2
    tst.w   O_PTVblOn(a2)
    bne.s   .cont
    rts
.cont   lea O_PTInterrupt(a2),a1
    moveq.l #5,d0
    move.l  a6,d7
    move.l  4.w,a6
    jsr _LVORemIntServer(a6)
    move.l  d7,a6
    clr.w   O_PTVblOn(a2)
    rts

    Lib_Par      PTTurnCiaOff      +++
    dload   a2
    tst.w   O_PTCiaOn(a2)
    bne.s   .contci
    rts
.contci move.l  a6,d7
    move.l  O_PTCiaResource(a2),a6
    move.l  O_PTCiaBase(a2),a1
    tst.w   O_PTCiaTimer(a2)
    beq.s   .kilta
    bclr    #0,ciacrb(a1)
    moveq.l #1,d0           ;Timer B
    bra.s   .cont
.kilta  bclr    #0,ciacra(a1)
    moveq.l #0,d0           ;Timer A
.cont   lea O_PTInterrupt(a2),a1
    jsr -12(a6)         ;RemICRVector
    clr.l   O_PTCiaResource(a2)
    move.l  d7,a6
    clr.w   O_PTCiaOn(a2)
    rts

    Lib_Par      DecodeRegData     +++ a0=Regdata
    move.l  a0,a2
    move.l  (a0)+,d4
    move.l  (a0)+,d7
    moveq.l #20,d0
    move.l  d7,d6
    move.l  d6,d5
    divu    #18543,d5
    clr.w   d5
    swap    d5
.declop eor.l   d6,(a0)+
    rol.l   #3,d5
    add.l   d5,d6
    dbra    d0,.declop
    move.l  -4(a0),d0
    sub.l   d4,d0
    cmp.l   d0,d7
    bne.s   .skip
;   moveq.l #2,d1
;   moveq.l #-1,d0
;.errlop    move.w  d0,$DFF180
;   dbra    d0,.errlop
;   dbra    d1,.errlop
    moveq   #ExtNb,d0       * NO ERRORS
.skip   moveq.l #22,d1
.clrlop clr.l   (a2)+
    dbra    d1,.clrlop
    rts

    Lib_Par      PT_Routines       +++ d0=Routinenumber
    movem.l d1-d7/a1-a6,-(sp)
    lea $DFF000,a5
    cmp.w   #1,d0
    beq.s   .mtinit         ;a0=Modaddress d1=Songpos
    cmp.w   #2,d0
    beq.s   .mtplay
    cmp.w   #3,d0
    beq.s   .mtend
    cmp.w   #4,d0
    beq.s   .getadr
    cmp.w   #5,d0
    beq.s   .setcia         ;d1=Speed
    bra.s   .end
.mtinit move.l  1080(a0),d0
    cmp.l   #'M.K.',d0
    beq.s   .goodmo
    cmp.l   #'M!K!',d0
    beq.s   .goodmo
    movem.l (sp)+,d1-d7/a1-a6
    Rbra    L_IFonc
.goodmo move.b  d1,d7
    bsr.s   MT_Init
    bra.s   .end
.mtplay bsr MT_Music
    bra.s   .end
.mtend  bsr MT_End
    bra.s   .end
.setcia move.l  d1,d0
    lea Variables(pc),a5
    bsr MT_SetCIA
    bra.s   .end
.getadr lea Variables(pc),a0
    move.l  a0,O_PTDataBase(a2)
    move.l  a2,MT_AmcafBase(a0)
.end    movem.l (sp)+,d1-d7/a1-a6
    rts

MT_Init move.l  a5,-(sp)
    lea Variables(pc),a5
    move.l  a0,MT_SongDataPtr(a5)
    lea 952(a0),a1
    moveq   #127,D0
    moveq   #0,D1
MTLoop  move.l  d1,d2
    subq.w  #1,d0
MTLoop2 move.b  (a1)+,d1
    cmp.b   d2,d1
    bgt.s   MTLoop
    dbf d0,MTLoop2
    addq.b  #1,d2
            
    move.l  a5,a1
    suba.w  #142,a1
    asl.l   #8,d2
    asl.l   #2,d2
    addi.l  #1084,d2
    add.l   a0,d2
    move.l  d2,a2
    moveq   #30,d0
MTLoop3
;   clr.l   (a2)
    move.l  a2,(a1)+
    moveq   #0,d1
    move.w  42(a0),d1
    add.l   d1,d1
    add.l   d1,a2
    adda.w  #30,a0
    dbf d0,MTLoop3

    ori.b   #2,$bfe001
    move.b  #6,MT_Speed(a5)
    move.w  #125,MT_CiaSpeed(a5)
    clr.b   MT_Counter(a5)
    move.b  d7,MT_SongPos(a5)
    moveq.l #-1,d0
    move.l  d0,MT_SfxEnable(a5)
    clr.l   MT_Vumeter(a5)
    clr.w   MT_Signal(a5)
    clr.w   MT_PatternPos(a5)
    clr.b   MT_PBreakPos(a5)
    clr.w   MT_PosJumpFlag(a5)
    clr.l   MT_LowMask(a5)
    moveq.l #3,d0
    lea MT_Chan1Temp(pc),a0
.crloop clr.l   (a0)+
    clr.l   (a0)+
    clr.l   (a0)+
    clr.l   (a0)+
    clr.l   (a0)+
    addq.l  #4,a0
    clr.l   (a0)+
    clr.l   (a0)+
    clr.l   (a0)+
    clr.l   (a0)+
    clr.l   (a0)+
    dbra    d0,.crloop
    move.l  (sp)+,a5
MT_End  clr.w   $0A8(a5)
    clr.w   $0B8(a5)
    clr.w   $0C8(a5)
    clr.w   $0D8(a5)
    move.w  #$f,$096(a5)
    rts

MT_SetCIA
    movem.l a0/d0/d2,-(sp)
    move.l  MT_AmcafBase(a5),a0
    cmp.w   #32,d0
    bge.s   .right
    moveq.l #32,d0
.right  and.w   #$FF,d0
    move.w  d0,MT_CiaSpeed(a5)
    tst.w   O_PTCiaOn(a0)
    beq.s   .skip
    move.l  O_PTTimerSpeed(a0),d2
    divu    d0,d2
    tst.w   O_PTCiaTimer(a0)
    beq.s   .settia
    move.l  O_PTCiaBase(a0),a0
    move.b  d2,ciatblo(a0)
    lsr.w   #8,d2
    move.b  d2,ciatbhi(a0)
.skip   movem.l (sp)+,a0/d0/d2
    rts
.settia move.l  O_PTCiaBase(a0),a0
    move.b  d2,ciatalo(a0)
    lsr.w   #8,d2
    move.b  d2,ciatahi(a0)
    movem.l (sp)+,a0/d0/d2
    rts
    
MT_Music
    movem.l d0-d4/a0-a6,-(a7)
    move.l  a5,a6
    lea Variables(pc),a5
    move.l  MT_MusiEnable(a5),d0
    and.l   MT_SfxEnable(a5),d0
    move.l  d0,MT_ChanEnable(a5)

    addq.b  #1,MT_Counter(a5)
    move.b  MT_Counter(a5),d0
    cmp.b   MT_Speed(a5),d0
    blo.s   MT_NoNewNote
    clr.b   MT_Counter(a5)
    tst.b   MT_PattDelTime2(a5)
    beq.s   MT_GetNewNote
    bsr.s   MT_NoNewAllChannels
    bra MT_Dskip

MT_NoNewNote:
    bsr.s   MT_NoNewAllChannels
    bra MT_NoNewPosYet
MT_NoNewAllChannels:
    move.l  a5,a4
    suba.w  #318,a4
    move.w  #$a0,d5
    moveq.l #0,d7
    bsr MT_CheckEfx
    adda.w  #44,a4
    move.w  #$b0,d5
    moveq.l #1,d7
    bsr MT_CheckEfx
    adda.w  #44,a4
    move.w  #$c0,d5
    moveq.l #2,d7
    bsr MT_CheckEfx
    adda.w  #44,a4
    move.w  #$d0,d5
    moveq.l #3,d7
    bra MT_CheckEfx

MT_GetNewNote
    move.l  MT_SongDataPtr(a5),a0
    lea 12(a0),a3
    lea 952(a0),a2  ;pattpo
    lea 1084(a0),a0 ;patterndata
    moveq   #0,d0
    moveq   #0,d1
    move.b  MT_SongPos(a5),d0
    move.b  (a2,d0.w),d1
    asl.l   #8,d1
    asl.l   #2,d1
    add.w   MT_PatternPos(a5),d1
    clr.w   MT_DMACONTemp(a5)

    move.l  a5,a4
    suba.w  #318,a4
    move.w  #$a0,d5
    moveq.l #0,d7
    bsr.s   MT_PlayVoice
    addq.l  #4,d1
    adda.w  #44,a4
    move.w  #$b0,d5
    moveq.l #1,d7
    bsr.s   MT_PlayVoice
    addq.l  #4,d1
    adda.w  #44,a4
    move.w  #$c0,d5
    moveq.l #2,d7
    bsr.s   MT_PlayVoice
    addq.l  #4,d1
    adda.w  #44,a4
    move.w  #$d0,d5
    moveq.l #3,d7
    bsr.s   MT_PlayVoice
    bra MT_SetDMA

MT_E_Commands2
    move.b  N_Cmdlo(a4),d0
    andi.b  #$f0,d0
    lsr.b   #4,d0
    beq MT_FilterOnOff
    cmpi.b  #3,d0
    beq MT_SetGlissControl
    cmpi.b  #4,d0
    beq MT_SetVibratoControl
    cmpi.b  #6,d0
    beq MT_JumpLoop
    cmpi.b  #7,d0
    beq MT_SetTremoloControl
    cmpi.b  #$e,d0
    beq MT_PatternDelay
    cmpi.b  #$f,d0
    beq MT_FunkIt
    rts

MT_PlayVoice
    tst.l   (a4)
    bne.s   MT_PlvSkip
    bsr MT_PerNop
MT_PlvSkip
    move.l  (a0,d1.l),(a4)
    moveq   #0,d2
    move.b  N_Cmd(a4),d2
    andi.b  #$f0,d2
    lsr.b   #4,d2
    move.b  (a4),d0
    andi.b  #$f0,d0
    or.b    d0,d2
    beq MT_SetRegs
    moveq   #0,d3
    move.l  a5,a1
    suba.w  #142,a1
    move    d2,d4
    subq.l  #1,d2
    asl.l   #2,d2
    mulu    #30,d4
    move.l  (a1,d2.l),N_Start(a4)
    move.w  (a3,d4.l),N_Length(a4)
    move.w  (a3,d4.l),N_RealLength(a4)
    move.b  2(a3,d4.l),N_FineTune(a4)
    move.b  3(a3,d4.l),N_Volume(a4)
    move.w  4(a3,d4.l),d3 ; Get repeat
    beq.s   MT_NoLoop
    move.l  N_Start(a4),d2 ; Get start
    add.w   d3,d3
    add.l   d3,d2       ; Add repeat
    move.l  d2,N_LoopStart(a4)
    move.l  d2,N_WaveStart(a4)
    move.w  4(a3,d4.l),d0   ; Get repeat
    add.w   6(a3,d4.l),d0   ; Add replen
    move.w  d0,N_Length(a4)
    move.w  6(a3,d4.l),N_Replen(a4) ; Save replen
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   MT_SetRegs
    moveq   #0,d0
    move.b  N_Volume(a4),d0
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.b  d0,MT_Vumeter(a5,d7.w)
    move.w  d0,8(a6,d5.w)   ; Set volume
    bra.s   MT_SetRegs

MT_NoLoop
    move.l  N_Start(a4),d2
    add.l   d3,d2
    move.l  d2,N_LoopStart(a4)
    move.l  d2,N_WaveStart(a4)
    move.w  6(a3,d4.l),N_Replen(a4) ; Save replen
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   MT_SetRegs
    moveq   #0,d0
    move.b  N_Volume(a4),d0
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.b  d0,MT_Vumeter(a5,d7.w)
    move.w  d0,8(a6,d5.w)   ; Set volume
MT_SetRegs
    move.w  (a4),d0
    andi.w  #$0fff,d0
    beq MT_CheckMoreEfx ; If no note
    move.w  2(a4),d0
    andi.w  #$0ff0,d0
    cmpi.w  #$0e50,d0
    beq.s   MT_DoSetFineTune
    move.b  2(a4),d0
    andi.b  #$0f,d0
    cmpi.b  #3,d0   ; TonePortamento
    beq.s   MT_ChkTonePorta
    cmpi.b  #5,d0
    beq.s   MT_ChkTonePorta
    cmpi.b  #9,d0   ; Sample Offset
    bne.s   MT_SetPeriod
    bsr MT_CheckMoreEfx
    bra.s   MT_SetPeriod

MT_DoSetFineTune
    bsr MT_SetFineTune
    bra.s   MT_SetPeriod

MT_ChkTonePorta
    bsr MT_SetTonePorta
    bra MT_CheckMoreEfx

MT_SetPeriod
    movem.l d0-d1/a0-a1,-(a7)
    move.w  (a4),d1
    andi.w  #$0fff,d1
    lea MT_PeriodTable(pc),a1
    moveq   #0,d0
    moveq   #36,d6
MT_FtuLoop
    cmp.w   (a1,d0.w),d1
    bhs.s   MT_FtuFound
    addq.l  #2,d0
    dbf d6,MT_FtuLoop
MT_FtuFound
    moveq   #0,d1
    move.b  N_FineTune(a4),d1
    mulu    #72,d1
    add.l   d1,a1
    move.w  (a1,d0.w),N_Period(a4)
    movem.l (a7)+,d0-d1/a0-a1

    move.w  2(a4),d0
    andi.w  #$0ff0,d0
    cmpi.w  #$0ed0,d0 ; Notedelay
    beq MT_CheckMoreEfx

    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  N_DMABit(a4),$096(a6)
.skipvo btst    #2,N_WaveControl(a4)
    bne.s   MT_Vibnoc
    clr.b   N_VibratoPos(a4)
MT_Vibnoc
    btst    #6,N_WaveControl(a4)
    bne.s   MT_Trenoc
    clr.b   N_TremoloPos(a4)
MT_Trenoc
    tst.b   MT_ChanEnable(a5,d7.w)
    beq MT_CheckMoreEfx
    move.l  N_Start(a4),(a6,d5.w)   ; Set start
    move.w  N_Length(a4),4(a6,d5.w) ; Set length
    move.w  N_Period(a4),d0
    move.w  d0,6(a6,d5.w)       ; Set period
    move.w  N_DMABit(a4),d0
    or.w    d0,MT_DMACONTemp(a5)
    bra MT_CheckMoreEfx
 
MT_SetDMA
    bsr MT_DMAWaitLoop
    move.w  MT_DMACONTemp(a5),d0
    ori.w   #$8000,d0
    move.w  d0,$096(a6)
    bsr MT_DMAWaitLoop
    move.l  a5,a4
    suba.w  #186,a4
    tst.b   MT_ChanEnable+3(a5)
    beq.s   .skipv4
    move.l  N_LoopStart(a4),$d0(a6)
    move.w  N_Replen(a4),$d4(a6)
.skipv4 suba.w  #44,a4
    tst.b   MT_ChanEnable+2(a5)
    beq.s   .skipv3
    move.l  N_LoopStart(a4),$c0(a6)
    move.w  N_Replen(a4),$c4(a6)
.skipv3 suba.w  #44,a4
    tst.b   MT_ChanEnable+1(a5)
    beq.s   .skipv2
    move.l  N_LoopStart(a4),$b0(a6)
    move.w  N_Replen(a4),$b4(a6)
.skipv2 suba.w  #44,a4
    tst.b   MT_ChanEnable(a5)
    beq.s   .skipv1
    move.l  N_LoopStart(a4),$a0(a6)
    move.w  N_Replen(a4),$a4(a6)
.skipv1
MT_Dskip
    addi.w  #16,MT_PatternPos(a5)
    move.b  MT_PattDelTime(a5),d0
    beq.s   MT_Dskc
    move.b  d0,MT_PattDelTime2(a5)
    clr.b   MT_PattDelTime(a5)
MT_Dskc tst.b   MT_PattDelTime2(a5)
    beq.s   MT_Dska
    subq.b  #1,MT_PattDelTime2(a5)
    beq.s   MT_Dska
    sub.w   #16,MT_PatternPos(a5)
MT_Dska tst.b   MT_PBreakFlag(a5)
    beq.s   MT_Nnpysk
    clr.b   MT_PBreakFlag(a5)
    moveq   #0,d0
    move.b  MT_PBreakPos(a5),d0
    clr.b   MT_PBreakPos(a5)
    lsl.w   #4,d0
    move.w  d0,MT_PatternPos(a5)
MT_Nnpysk
    cmpi.w  #1024,MT_PatternPos(a5)
    blo.s   MT_NoNewPosYet
MT_NextPosition 
    moveq   #0,d0
    move.b  MT_PBreakPos(a5),d0
    lsl.w   #4,d0
    move.w  d0,MT_PatternPos(a5)
    clr.b   MT_PBreakPos(a5)
    clr.b   MT_PosJumpFlag(a5)
    addq.b  #1,MT_SongPos(a5)
    andi.b  #$7F,MT_SongPos(a5)
    move.b  MT_SongPos(a5),d1
    move.l  MT_SongDataPtr(a5),a0
    cmp.b   950(a0),d1
    blo.s   MT_NoNewPosYet
    clr.b   MT_SongPos(a5)
    st  MT_Signal(a5)
MT_NoNewPosYet  
    tst.b   MT_PosJumpFlag(a5)
    bne.s   MT_NextPosition
    movem.l (a7)+,d0-d4/a0-a6
    rts

MT_CheckEfx
    bsr MT_UpdateFunk
    move.w  N_Cmd(a4),d0
    andi.w  #$0fff,d0
    beq.s   MT_PerNop
    move.b  N_Cmd(a4),d0
    andi.b  #$0f,d0
    beq.s   MT_Arpeggio
    cmpi.b  #1,d0
    beq MT_PortaUp
    cmpi.b  #2,d0
    beq MT_PortaDown
    cmpi.b  #3,d0
    beq MT_TonePortamento
    cmpi.b  #4,d0
    beq MT_Vibrato
    cmpi.b  #5,d0
    beq MT_TonePlusVolSlide
    cmpi.b  #6,d0
    beq MT_VibratoPlusVolSlide
    cmpi.b  #$E,d0
    beq MT_E_Commands
SetBack tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  N_Period(a4),6(a6,d5.w)
.skipvo cmpi.b  #7,d0
    beq MT_Tremolo
    cmpi.b  #$a,d0
    beq MT_VolumeSlide
MT_Return2
    rts

MT_PerNop
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    moveq   #0,d0
    move.b  N_Volume(a4),d0
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.w  d0,8(a6,d5.w)   ; Set volume
    move.w  N_Period(a4),6(a6,d5.w)
.skipvo rts

MT_Arpeggio
    moveq   #0,d0
    move.b  MT_Counter(a5),d0
    divs    #3,d0
    swap    d0
    tst.w   D0
    beq.s   MT_Arpeggio2
    cmpi.w  #2,d0
    beq.s   MT_Arpeggio1
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    lsr.b   #4,d0
    bra.s   MT_Arpeggio3

MT_Arpeggio1
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #15,d0
    bra.s   MT_Arpeggio3

MT_Arpeggio2
    move.w  N_Period(a4),d2
    bra.s   MT_Arpeggio4

MT_Arpeggio3
    add.w   d0,d0
    moveq   #0,d1
    move.b  N_FineTune(a4),d1
    mulu    #72,d1
    lea MT_PeriodTable(pc),a0
    add.w   d1,a0
    moveq   #0,d1
    move.w  N_Period(a4),d1
    moveq   #36,d6
MT_ArpLoop
    move.w  (a0,d0.w),d2
    cmp.w   (a0),d1
    bhs.s   MT_Arpeggio4
    addq.w  #2,a0
    dbf d6,MT_ArpLoop
    rts

MT_Arpeggio4
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  d2,6(a6,d5.w)
.skipvo rts

MT_FinePortaUp
    tst.b   MT_Counter(a5)
    bne MT_Return2
    move.b  #$0f,MT_LowMask(a5)
MT_PortaUp
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    and.b   MT_LowMask(a5),d0
    st  MT_LowMask(a5)
    sub.w   d0,N_Period(a4)
    move.w  N_Period(a4),d0
    andi.w  #$0fff,d0
    cmpi.w  #113,d0
    bpl.s   MT_PortaUskip
    andi.w  #$f000,N_Period(a4)
    ori.w   #113,N_Period(a4)
MT_PortaUskip
    move.w  N_Period(a4),d0
    andi.w  #$0fff,d0
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  d0,6(a6,d5.w)
.skipvo rts
 
MT_FinePortaDown
    tst.b   MT_Counter(a5)
    bne MT_Return2
    move.b  #$0f,MT_LowMask(a5)
MT_PortaDown
    clr.w   d0
    move.b  N_Cmdlo(a4),d0
    and.b   MT_LowMask(a5),d0
    st  MT_LowMask(a5)
    add.w   d0,N_Period(a4)
    move.w  N_Period(a4),d0
    andi.w  #$0fff,d0
    cmpi.w  #856,d0
    bmi.s   MT_PortaDskip
    andi.w  #$f000,N_Period(a4)
    ori.w   #856,N_Period(a4)
MT_PortaDskip
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  N_Period(a4),d0
    andi.w  #$0fff,d0
    move.w  d0,6(a6,d5.w)
.skipvo rts

MT_SetTonePorta
    move.l  a0,-(a7)
    move.w  (a4),d2
    andi.w  #$0fff,d2
    moveq   #0,d0
    move.b  N_FineTune(a4),d0
    mulu    #72,d0
    lea MT_PeriodTable(pc),a0
    add.w   d0,a0
    moveq   #0,d0
MT_StpLoop
    cmp.w   (a0,d0.w),d2
    bge.s   MT_StpFound
    addq.w  #2,d0
    cmpi.w  #72,d0
    blo.s   MT_StpLoop
    moveq   #70,d0
MT_StpFound
    move.b  N_FineTune(a4),d2
    andi.b  #8,d2
    beq.s   MT_StpGoss
    tst.w   d0
    beq.s   MT_StpGoss
    subq.w  #2,d0
MT_StpGoss
    move.w  (a0,d0.w),d2
    move.l  (a7)+,a0
    move.w  d2,N_WantedPeriod(a4)
    move.w  N_Period(a4),d0
    clr.b   N_TonePortDirec(a4)
    cmp.w   d0,d2
    beq.s   MT_ClearTonePorta
    bge MT_Return2
    move.b  #1,N_TonePortDirec(a4)
    rts

MT_ClearTonePorta
    clr.w   N_WantedPeriod(a4)
    rts

MT_TonePortamento
    move.b  N_Cmdlo(a4),d0
    beq.s   MT_TonePortNoChange
    move.b  d0,N_TonePortSpeed(a4)
    clr.b   N_Cmdlo(a4)
MT_TonePortNoChange
    tst.w   N_WantedPeriod(a4)
    beq MT_Return2
    moveq   #0,d0
    move.b  N_TonePortSpeed(a4),d0
    tst.b   N_TonePortDirec(a4)
    bne.s   MT_TonePortaUp
MT_TonePortaDown
    add.w   d0,N_Period(a4)
    move.w  N_WantedPeriod(a4),d0
    cmp.w   N_Period(a4),d0
    bgt.s   MT_TonePortaSetPer
    move.w  N_WantedPeriod(a4),N_Period(a4)
    clr.w   N_WantedPeriod(a4)
    bra.s   MT_TonePortaSetPer

MT_TonePortaUp
    sub.w   d0,N_Period(a4)
    move.w  N_WantedPeriod(a4),d0
    cmp.w   N_Period(a4),d0         ; was cmpi!!!!
    blt.s   MT_TonePortaSetPer
    move.w  N_WantedPeriod(a4),N_Period(a4)
    clr.w   N_WantedPeriod(a4)

MT_TonePortaSetPer
    move.w  N_Period(a4),d2
    move.b  N_GlissFunk(a4),d0
    andi.b  #$0f,d0
    beq.s   MT_GlissSkip
    moveq   #0,d0
    move.b  N_FineTune(a4),d0
    mulu    #72,d0
    lea MT_PeriodTable(pc),a0
    add.w   d0,a0
    moveq   #0,d0
MT_GlissLoop
    cmp.w   (a0,d0.w),d2
    bhs.s   MT_GlissFound
    addq.w  #2,d0
    cmpi.w  #72,d0
    blo.s   MT_GlissLoop
    moveq   #70,d0
MT_GlissFound
    move.w  (a0,d0.w),d2
MT_GlissSkip
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  d2,6(a6,d5.w) ; Set period
.skipvo rts

MT_Vibrato
    move.b  N_Cmdlo(a4),d0
    beq.s   MT_Vibrato2
    move.b  N_VibratoCmd(a4),d2
    andi.b  #$0f,d0
    beq.s   MT_VibSkip
    andi.b  #$f0,d2
    or.b    d0,d2
MT_VibSkip
    move.b  N_Cmdlo(a4),d0
    andi.b  #$f0,d0
    beq.s   MT_VibSkip2
    andi.b  #$0f,d2
    or.b    d0,d2
MT_VibSkip2
    move.b  d2,N_VibratoCmd(a4)
MT_Vibrato2
    move.b  N_VibratoPos(a4),d0
    lea MT_VibratoTable(pc),a0
    lsr.w   #2,d0
    andi.w  #$001f,d0
    moveq   #0,d2
    move.b  N_WaveControl(a4),d2
    andi.b  #$03,d2
    beq.s   MT_Vib_Sine
    lsl.b   #3,d0
    cmpi.b  #1,d2
    beq.s   MT_Vib_RampDown
    st  d2
    bra.s   MT_Vib_Set
MT_Vib_RampDown
    tst.b   N_VibratoPos(a4)
    bpl.s   MT_Vib_RampDown2
    st  d2
    sub.b   d0,d2
    bra.s   MT_Vib_Set
MT_Vib_RampDown2
    move.b  d0,d2
    bra.s   MT_Vib_Set
MT_Vib_Sine
    move.b  (a0,d0.w),d2
MT_Vib_Set
    move.b  N_VibratoCmd(a4),d0
    andi.w  #15,d0
    mulu    d0,d2
    lsr.w   #7,d2
    move.w  N_Period(a4),d0
    tst.b   N_VibratoPos(a4)
    bmi.s   MT_VibratoNeg
    add.w   d2,d0
    bra.s   MT_Vibrato3
MT_VibratoNeg
    sub.w   d2,d0
MT_Vibrato3
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.w  d0,6(a6,d5.w)
.skipvo move.b  N_VibratoCmd(a4),d0
    lsr.w   #2,d0
    andi.w  #$3C,d0
    add.b   d0,N_VibratoPos(a4)
    rts

MT_TonePlusVolSlide
    bsr MT_TonePortNoChange
    bra MT_VolumeSlide

MT_VibratoPlusVolSlide
    bsr.s   MT_Vibrato2
    bra MT_VolumeSlide

MT_Tremolo
    move.b  N_Cmdlo(a4),d0
    beq.s   MT_Tremolo2
    move.b  N_TremoloCmd(a4),d2
    andi.b  #$0f,d0
    beq.s   MT_TreSkip
    andi.b  #$f0,d2
    or.b    d0,d2
MT_TreSkip
    move.b  N_Cmdlo(a4),d0
    and.b   #$f0,d0
    beq.s   MT_TreSkip2
    andi.b  #$0f,d2
    or.b    d0,d2
MT_TreSkip2
    move.b  d2,N_TremoloCmd(a4)
MT_Tremolo2
    move.b  N_TremoloPos(a4),d0
    lea MT_VibratoTable(pc),a0
    lsr.w   #2,d0
    andi.w  #$1f,d0
    moveq   #0,d2
    move.b  N_WaveControl(a4),d2
    lsr.b   #4,d2
    andi.b  #3,d2
    beq.s   MT_Tre_Sine
    lsl.b   #3,d0
    cmpi.b  #1,d2
    beq.s   MT_Tre_RampDown
    st  d2
    bra.s   MT_Tre_Set
MT_Tre_RampDown
    tst.b   N_VibratoPos(a4)
    bpl.s   MT_Tre_RampDown2
    st  d2
    sub.b   d0,d2
    bra.s   MT_Tre_Set
MT_Tre_RampDown2
    move.b  d0,d2
    bra.s   MT_Tre_Set
MT_Tre_Sine
    move.b  (a0,d0.w),d2
MT_Tre_Set
    move.b  N_TremoloCmd(a4),d0
    andi.w  #15,d0
    mulu    d0,d2
    lsr.w   #6,d2
    moveq   #0,d0
    move.b  N_Volume(a4),d0
    tst.b   N_TremoloPos(a4)
    bmi.s   MT_TremoloNeg
    add.w   d2,d0
    bra.s   MT_Tremolo3
MT_TremoloNeg
    sub.w   d2,d0
MT_Tremolo3
    bpl.s   MT_TremoloSkip
    clr.w   d0
MT_TremoloSkip
    cmpi.w  #$40,d0
    bls.s   MT_TremoloOk
    move.w  #$40,d0
MT_TremoloOk
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.w  d0,8(a6,d5.w)
.skipvo move.b  N_TremoloCmd(a4),d0
    lsr.w   #2,d0
    andi.w  #$3c,d0
    add.b   d0,N_TremoloPos(a4)
    rts

MT_SampleOffset
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    beq.s   MT_SoNoNew
    move.b  d0,N_SampleOffset(a4)
MT_SoNoNew
    move.b  N_SampleOffset(a4),d0
    lsl.w   #7,d0
    cmp.w   N_Length(a4),d0
    bge.s   MT_SofSkip
    sub.w   d0,N_Length(a4)
    add.w   d0,d0
    add.l   d0,N_Start(a4)
    rts
MT_SofSkip
    move.w  #1,N_Length(a4)
    rts

MT_VolumeSlide
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    lsr.b   #4,d0
    tst.b   d0
    beq.s   MT_VolSlideDown
MT_VolSlideUp
    add.b   d0,N_Volume(a4)
    cmpi.b  #$40,N_Volume(a4)
    bmi.s   MT_VsuSkip
    move.b  #$40,N_Volume(a4)
MT_VsuSkip
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.b  N_Volume(a4),d0
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.w  d0,8(a6,d5.w)
.skipvo rts

MT_VolSlideDown
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
MT_VolSlideDown2
    sub.b   d0,N_Volume(a4)
    bpl.s   MT_VsdSkip
    clr.b   N_Volume(a4)
MT_VsdSkip
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    move.b  N_Volume(a4),d0
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.w  d0,8(a6,d5.w)
.skipvo rts

MT_PositionJump
    move.b  N_Cmdlo(a4),d0
    subq.b  #1,d0
    cmp.b   MT_SongPos(a5),d0
    bge.s   .nosign
    st  MT_Signal(a5)
.nosign move.b  d0,MT_SongPos(a5)
MT_PJ2  clr.b   MT_PBreakPos(a5)
    st  MT_PosJumpFlag(a5)
    rts

MT_VolumeChange
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    cmpi.b  #$40,d0
    bls.s   MT_VolumeOk
    moveq   #$40,d0
MT_VolumeOk
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skip
    move.b  d0,N_Volume(a4)
    mulu    MT_Volume(a5),d0
    lsr.w   #6,d0
    move.w  d0,8(a6,d5.w)
    move.w  (a4),d6
    andi.w  #$0fff,d6
    beq.s   .skip
    move.b  d0,MT_Vumeter(a5,d7.w)
.skip   rts

MT_PatternBreak
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    move.l  d0,d2
    lsr.b   #4,d0
    mulu    #10,d0
    andi.b  #$0f,d2
    add.b   d2,d0
    cmpi.b  #63,d0
    bhi.s   MT_PJ2
    move.b  d0,MT_PBreakPos(a5)
    st  MT_PosJumpFlag(a5)
    rts

MT_SetSpeed
    moveq.l #0,d0
    move.b  3(a4),d0
    beq MT_Return2
    cmp.b   #32,d0
    bhs.s   .ciatim
    clr.b   MT_Counter(a5)
    move.b  d0,MT_Speed(a5)
    rts
.ciatim bra MT_SetCIA

MT_CheckMoreEfx
    bsr MT_UpdateFunk
    move.b  2(a4),d0
    andi.b  #$0f,d0
    cmpi.b  #$8,d0
    beq MT_SetSignal
    cmpi.b  #$9,d0
    beq MT_SampleOffset
    cmpi.b  #$b,d0
    beq MT_PositionJump
    cmpi.b  #$d,d0
    beq.s   MT_PatternBreak
    cmpi.b  #$e,d0
    beq.s   MT_E_Commands
    cmpi.b  #$f,d0
    beq.s   MT_SetSpeed
    cmpi.b  #$c,d0
    beq MT_VolumeChange
    bra MT_PerNop

MT_E_Commands
    move.b  N_Cmdlo(a4),d0
    andi.b  #$f0,d0
    lsr.b   #4,d0
    beq.s   MT_FilterOnOff
    cmpi.b  #1,d0
    beq MT_FinePortaUp
    cmpi.b  #2,d0
    beq MT_FinePortaDown
    cmpi.b  #3,d0
    beq.s   MT_SetGlissControl
    cmpi.b  #4,d0
    beq MT_SetVibratoControl
    cmpi.b  #5,d0
    beq MT_SetFineTune
    cmpi.b  #6,d0
    beq MT_JumpLoop
    cmpi.b  #7,d0
    beq MT_SetTremoloControl
    cmpi.b  #9,d0
    beq MT_RetrigNote
    cmpi.b  #$a,d0
    beq MT_VolumeFineUp
    cmpi.b  #$b,d0
    beq MT_VolumeFineDown
    cmpi.b  #$c,d0
    beq MT_NoteCut
    cmpi.b  #$d,d0
    beq MT_NoteDelay
    cmpi.b  #$e,d0
    beq MT_PatternDelay
    cmpi.b  #$f,d0
    beq MT_FunkIt
    rts

MT_SetSignal
    move.b  N_Cmdlo(a4),MT_Signal(a5)
    bra MT_PerNop

MT_FilterOnOff
    move.b  N_Cmdlo(a4),d0
    andi.b  #1,d0
    add.b   d0,d0
    andi.b  #$fd,$bfe001
    or.b    d0,$bfe001
    rts

MT_SetGlissControl
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    andi.b  #$f0,N_GlissFunk(a4)
    or.b    d0,N_GlissFunk(a4)
    rts

MT_SetVibratoControl
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    andi.b  #$f0,N_WaveControl(a4)
    or.b    d0,N_WaveControl(a4)
    rts

MT_SetFineTune
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    move.b  d0,N_FineTune(a4)
    rts

MT_JumpLoop
    tst.b   MT_Counter(a5)
    bne MT_Return2
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    beq.s   MT_SetLoop
    tst.b   N_LoopCount(a4)
    beq.s   MT_JumpCnt
    subq.b  #1,N_LoopCount(a4)
    beq MT_Return2
MT_JmpLoop
    move.b  N_PattPos(a4),MT_PBreakPos(a5)
    st  MT_PBreakFlag(a5)
    rts

MT_JumpCnt
    move.b  d0,N_LoopCount(a4)
    bra.s   MT_JmpLoop

MT_SetLoop
    move.w  MT_PatternPos(a5),d0
    lsr.w   #4,d0
    move.b  d0,N_PattPos(a4)
    rts

MT_SetTremoloControl
    move.b  N_Cmdlo(a4),d0
*   andi.b  #$0f,d0
    lsl.b   #4,d0
    andi.b  #$0f,N_WaveControl(a4)
    or.b    d0,N_WaveControl(a4)
    rts

MT_RetrigNote
    move.l  d1,-(a7)
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    beq.s   MT_RtnEnd
    moveq   #0,d1
    move.b  MT_Counter(a5),d1
    bne.s   MT_RtnSkp
    move.w  (a4),d1
    andi.w  #$0fff,d1
    bne.s   MT_RtnEnd
    moveq   #0,d1
    move.b  MT_Counter(a5),d1
MT_RtnSkp
    divu    d0,d1
    swap    d1
    tst.w   d1
    bne.s   MT_RtnEnd
MT_DoRetrig
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   MT_RtnEnd
    move.w  N_DMABit(a4),$096(a6)   ; Channel DMA off
    move.l  N_Start(a4),(a6,d5.w)   ; Set sampledata pointer
    move.w  N_Length(a4),4(a6,d5.w) ; Set length
    bsr MT_DMAWaitLoop
    move.w  N_DMABit(a4),d0
    ori.w   #$8000,d0
*   bset    #15,d0
    move.w  d0,$096(a6)
    bsr MT_DMAWaitLoop
    move.l  N_LoopStart(a4),(a6,d5.w)
    move.l  N_Replen(a4),4(a6,d5.w)
MT_RtnEnd
    move.l  (a7)+,d1
    rts

MT_VolumeFineUp
    tst.b   MT_Counter(a5)
    bne MT_Return2
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$f,d0          ;rem $d
    bra MT_VolSlideUp

MT_VolumeFineDown
    tst.b   MT_Counter(a5)
    bne MT_Return2
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    bra MT_VolSlideDown2

MT_NoteCut
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    cmp.b   MT_Counter(a5),d0   ; was cmpi!!!
    bne MT_Return2
    clr.b   N_Volume(a4)
    tst.b   MT_ChanEnable(a5,d7.w)
    beq.s   .skipvo
    clr.w   8(a6,d5.w)
.skipvo rts

MT_NoteDelay
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    cmp.b   MT_Counter(a5),d0   ; was cmpi!!!
    bne MT_Return2
    move.w  (a4),d0
    beq MT_Return2
    move.l  d1,-(a7)
    bra MT_DoRetrig

MT_PatternDelay
    tst.b   MT_Counter(a5)
    bne MT_Return2
    moveq   #0,d0
    move.b  N_Cmdlo(a4),d0
    andi.b  #$0f,d0
    tst.b   MT_PattDelTime2(a5)
    bne MT_Return2
    addq.b  #1,d0
    move.b  d0,MT_PattDelTime(a5)
    rts

MT_FunkIt
    tst.b   MT_Counter(a5)
    bne MT_Return2
    move.b  N_Cmdlo(a4),d0
;   andi.b  #$0f,d0
    lsl.b   #4,d0
    andi.b  #$0f,N_GlissFunk(a4)
    or.b    d0,N_GlissFunk(a4)
    tst.b   d0
    beq MT_Return2
MT_UpdateFunk
    movem.l a0/d1,-(a7)
    moveq   #0,d0
    move.b  N_GlissFunk(a4),d0
    lsr.b   #4,d0
    beq.s   MT_FunkEnd
    lea MT_FunkTable(pc),a0
    move.b  (a0,d0.w),d0
    add.b   d0,N_FunkOffset(a4)
    btst    #7,N_FunkOffset(a4)
    beq.s   MT_FunkEnd
    clr.b   N_FunkOffset(a4)

    move.l  N_LoopStart(a4),d0
    moveq   #0,d1
    move.w  N_Replen(a4),d1
    add.l   d1,d0
    add.l   d1,d0
    move.l  N_WaveStart(a4),a0
    addq.w  #1,a0
    cmp.l   d0,a0
    blo.s   MT_FunkOk
    move.l  N_LoopStart(a4),a0
MT_FunkOk
    move.l  a0,N_WaveStart(a4)
    moveq   #-1,d0
    sub.b   (a0),d0
    move.b  d0,(a0)
MT_FunkEnd:
    movem.l (a7)+,a0/d1
    rts

MT_DMAWaitLoop
    move.w  d1,-(sp)
    moveq   #5,d0       ; wait 5+1 lines
.loop   move.b  6(a6),d1        ; read current raster position
.wait   cmp.b   6(a6),d1
    beq.s   .wait       ; wait until it changes
    dbf d0,.loop        ; do it again
    move.w  (sp)+,d1
    rts

    Rdata
MT_FunkTable
    dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

MT_VibratoTable
    dc.b 0,24,49,74,97,120,141,161
    dc.b 180,197,212,224,235,244,250,253
    dc.b 255,253,250,244,235,224,212,197
    dc.b 180,161,141,120,97,74,49,24

MT_PeriodTable
; Tuning 0, Normal
    dc.w    856,808,762,720,678,640,604,570,538,508,480,453
    dc.w    428,404,381,360,339,320,302,285,269,254,240,226
    dc.w    214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
    dc.w    850,802,757,715,674,637,601,567,535,505,477,450
    dc.w    425,401,379,357,337,318,300,284,268,253,239,225
    dc.w    213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
    dc.w    844,796,752,709,670,632,597,563,532,502,474,447
    dc.w    422,398,376,355,335,316,298,282,266,251,237,224
    dc.w    211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
    dc.w    838,791,746,704,665,628,592,559,528,498,470,444
    dc.w    419,395,373,352,332,314,296,280,264,249,235,222
    dc.w    209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
    dc.w    832,785,741,699,660,623,588,555,524,495,467,441
    dc.w    416,392,370,350,330,312,294,278,262,247,233,220
    dc.w    208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
    dc.w    826,779,736,694,655,619,584,551,520,491,463,437
    dc.w    413,390,368,347,328,309,292,276,260,245,232,219
    dc.w    206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
    dc.w    820,774,730,689,651,614,580,547,516,487,460,434
    dc.w    410,387,365,345,325,307,290,274,258,244,230,217
    dc.w    205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
    dc.w    814,768,725,684,646,610,575,543,513,484,457,431
    dc.w    407,384,363,342,323,305,288,272,256,242,228,216
    dc.w    204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
    dc.w    907,856,808,762,720,678,640,604,570,538,508,480
    dc.w    453,428,404,381,360,339,320,302,285,269,254,240
    dc.w    226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
    dc.w    900,850,802,757,715,675,636,601,567,535,505,477
    dc.w    450,425,401,379,357,337,318,300,284,268,253,238
    dc.w    225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
    dc.w    894,844,796,752,709,670,632,597,563,532,502,474
    dc.w    447,422,398,376,355,335,316,298,282,266,251,237
    dc.w    223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
    dc.w    887,838,791,746,704,665,628,592,559,528,498,470
    dc.w    444,419,395,373,352,332,314,296,280,264,249,235
    dc.w    222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
    dc.w    881,832,785,741,699,660,623,588,555,524,494,467
    dc.w    441,416,392,370,350,330,312,294,278,262,247,233
    dc.w    220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
    dc.w    875,826,779,736,694,655,619,584,551,520,491,463
    dc.w    437,413,390,368,347,328,309,292,276,260,245,232
    dc.w    219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
    dc.w    868,820,774,730,689,651,614,580,547,516,487,460
    dc.w    434,410,387,365,345,325,307,290,274,258,244,230
    dc.w    217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
    dc.w    862,814,768,725,684,646,610,575,543,513,484,457
    dc.w    431,407,384,363,342,323,305,288,272,256,242,228
    dc.w    216,203,192,181,171,161,152,144,136,128,121,114

MT_Chan1Temp
    dc.l    0,0,0,0,0,$00010000,0,0,0,0,0
MT_Chan2Temp
    dc.l    0,0,0,0,0,$00020000,0,0,0,0,0
MT_Chan3Temp
    dc.l    0,0,0,0,0,$00040000,0,0,0,0,0
MT_Chan4Temp
    dc.l    0,0,0,0,0,$00080000,0,0,0,0,0
MT_SampleStarts
    dc.l    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    dc.l    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
*MT_SongDataPtr
    dc.l 0
*MT_Speed
    dc.b 6
*MT_Counter
    dc.b 0
*MT_SongPos
    dc.b 0
*MT_PBreakPos
    dc.b 0
*MT_PosJumpFlag
    dc.b 0
*MT_PBreakFlag
    dc.b 0
*MT_LowMask
    dc.b 0
*MT_PattDelTime
    dc.b 0
*MT_PattDelTime2
    dc.b 0,0
*MT_PatternPos
    dc.w 0
*MT_DMACONtemp
    dc.w 0
Variables
*MT_CiaSpeed
    dc.w 125
*MT_Signal
    dc.w 0
*MT_Volume
    dc.w 64
*MT_ChanEnable
    dc.b -1,-1,-1,-1
*MT_MusiEnable
    dc.b -1,-1,-1,-1
*MT_SfxEnable
    dc.b -1,-1,-1,-1
*MT_VblDisable
    dc.w 0,0,0,0
*MT_Vumeter
    dc.b 0,0,0,0
*MT_AmcafBase
    dc.l 0

    Lib_Par      KalmsC2P
    bra.s   .noamos
    Rdata
.noamos
;
; Date: 24-Aug-1997         Mikael Kalms (Scout/C-Lous & more)
;
; 1x1 8bpl cpu5 C2P for arbitrary BitMaps
;
; Features:
; Performs CPU-only C2P conversion using rather state-of-the-art (as of
; the creation date, anyway) techniques
; Different routines for non-modulo and modulo C2P conversions
; Handles bitmaps of virtually any size (>4096x4096)
;
; Restrictions:
; Chunky-buffer must be an even multiple of 32 pixels wide
; X-Offset must be set to an even multiple of 8
; If these conditions not are met, the routine will abort.
; If incorrect/invalid parameters are specified, the routine will
; most probably crash.
;
; c2p1x1_8_c5_bm

; d0.w  chunkyx [chunky-pixels]
; d1.w  chunkyy [chunky-pixels]
; d2.w  scroffsx [screen-pixels]
; d3.w  scroffsy [screen-pixels]
; d4.w  (rowlen) [bytes] -- offset between one row and the next in a bpl
; d5.l  (bplsize) [bytes] -- offset between one row in one bpl and the next bpl

; a0    chunkyscreen
; a1    AMOS Screen struct

    movem.l a3-a6,-(sp)

    lea c2p_data(pc),a2
    move.l  a0,c2p_chkybuf(a2)
    move.w  EcTx(a1),d4
    move.w  EcNPlan(a1),c2p_numplanes(a2)
    move.w  d4,d5
    sub.w   d0,d4
    lsr.w   #3,d5
    lsr.w   #3,d4
    move.w  d4,c2p_modbytes(a2)
    ext.l   d5
    mulu    d3,d5
    and.w   #$fff0,d2
    lsr.w   #3,d2
    add.w   d5,d2
    move.w  d2,c2p_bploffset(a2)
;   andi.l  #$ffff,d0
;   mulu.w  d0,d3
;   lsr.l   #3,d3
;   move.l  d3,c2p_scroffs(a2)
;   move.w  d1,c2p_rows(a2)
    mulu.w  d0,d1
    add.l   a0,d1
    move.l  d1,c2p_pixels(a2)
    lsr.w   #5,d0
    subq.w  #1,d0
    move.w  d0,c2p_longsperrow(a2)
    moveq.l #5,d0
    lea c2p_planes(a2),a3
.pllop  move.l  (a1)+,(a3)+
    dbra    d0,.pllop

;   lea c2p_data(pc),a2

    move.l  #$00ff00ff,a6

    move.w  c2p_bploffset(a2),d6

;   move.l  c2p_pixels(a2),a2

    cmp.l   c2p_pixels(a2),a0
    beq .none

    move.l  (a0)+,d0
    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3
    move.w  c2p_longsperrow(a2),c2p_rowcount(a2)

    move.l  #$0f0f0f0f,d4       ; Merge 4x1, part 1
    and.l   d4,d0
    and.l   d4,d2
    lsl.l   #4,d0
    or.l    d2,d0

    and.l   d4,d1
    and.l   d4,d3
    lsl.l   #4,d1
    or.l    d3,d1

    move.l  d1,a3

    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3
    move.l  (a0)+,d7

    and.l   d4,d1           ; Merge 4x1, part 2
    and.l   d4,d2
    lsl.l   #4,d2
    or.l    d1,d2

    and.l   d4,d3
    and.l   d4,d7
    lsl.l   #4,d3
    or.l    d7,d3

    move.l  a3,d1

    move.w  d2,d7           ; Swap 16x2
    move.w  d0,d2
    swap    d2
    move.w  d2,d0
    move.w  d7,d2
    move.w  d3,d7
    move.w  d1,d3
    swap    d3
    move.w  d3,d1
    move.w  d7,d3

    bra.s   .start1
.x1
    move.l  (a0)+,d0
    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3

;   move.l  d7,BPLSIZE(a1)

    move.l  #$0f0f0f0f,d4       ; Merge 4x1, part 1
    move.l  c2p_planes+8(a2),a1
    move.l  d7,(a1,d6.w)
    and.l   d4,d0
    and.l   d4,d2
    lsl.l   #4,d0
    or.l    d2,d0

    and.l   d4,d1
    and.l   d4,d3
    lsl.l   #4,d1
    or.l    d3,d1

    move.l  d1,a3

    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3
    move.l  (a0)+,d7

;   move.l  a4,(a1)+

    and.l   d4,d1           ; Merge 4x1, part 2
    move.l  c2p_planes+4(a2),a1
    move.l  a4,(a1,d6.w)
    and.l   d4,d2
    lsl.l   #4,d2
    or.l    d1,d2

    and.l   d4,d3
    and.l   d4,d7
    lsl.l   #4,d3
    or.l    d7,d3

    move.l  a3,d1

    move.w  d2,d7           ; Swap 16x2
    move.w  d0,d2
    swap    d2
    move.w  d2,d0
    move.w  d7,d2
    move.w  d3,d7
    move.w  d1,d3
    swap    d3
    move.w  d3,d1
    move.l  c2p_planes(a2),a1
    move.w  d7,d3

;   move.l  a5,-BPLSIZE-4(a1)
    move.l  a5,(a1,d6.w)
    addq.w  #4,d6
    subq.w  #1,c2p_rowcount(a2)
    bpl.s   .start1
    move.w  c2p_longsperrow(a2),c2p_rowcount(a2)
    add.w   c2p_modbytes(a2),d6

.start1
    move.l  a6,d4

    move.l  #$33333333,d5
    move.l  d2,d7           ; Swap 2x2
    lsr.l   #2,d7
    eor.l   d0,d7
    and.l   d5,d7
    eor.l   d7,d0
    lsl.l   #2,d7
    eor.l   d7,d2

    move.l  d3,d7
    lsr.l   #2,d7
    eor.l   d1,d7
    and.l   d5,d7
    eor.l   d7,d1
    lsl.l   #2,d7
    eor.l   d7,d3

    move.l  d1,d7
    lsr.l   #8,d7
    eor.l   d0,d7
    and.l   d4,d7
    eor.l   d7,d0
    lsl.l   #8,d7
    eor.l   d7,d1

    move.l  #$55555555,d5
    move.l  d1,d7
    lsr.l   #1,d7
    eor.l   d0,d7
    and.l   d5,d7
    eor.l   d7,d0
    move.l  c2p_planes+12(a2),a1
    move.l  d0,(a1,d6.w)
;   move.l  d0,BPLSIZE*2(a1)
    add.l   d7,d7
    eor.l   d1,d7

    move.l  d3,d1
    lsr.l   #8,d1
    eor.l   d2,d1
    and.l   d4,d1
    eor.l   d1,d2
    lsl.l   #8,d1
    eor.l   d1,d3

    move.l  d3,d1
    lsr.l   #1,d1
    eor.l   d2,d1
    and.l   d5,d1
    eor.l   d1,d2
    add.l   d1,d1
    eor.l   d1,d3

    move.l  d2,a4
    move.l  d3,a5

    cmp.l   c2p_pixels(a2),a0
;   cmpa.l  a0,a2
    bne .x1

    addq.w  #4,d6
    move.l  c2p_planes+8(a2),a1
    move.l  d7,-4(a1,d6.w)
;   move.l  d7,BPLSIZE(a1)
    move.l  c2p_planes+4(a2),a1
    move.l  a4,-4(a1,d6.w)
;   move.l  a4,(a1)+
;   move.l  a5,-BPLSIZE-4(a1)
    move.l  c2p_planes(a2),a1
    move.l  a5,-4(a1,d6.w)

    cmp.w   #4,c2p_numplanes(a2)
    beq .none

    cmp.w   #5,c2p_numplanes(a2)
    beq .pl5

    move.l  c2p_chkybuf(a2),a0
    move.w  c2p_bploffset(a2),d6

;   add.l   #BPLSIZE*4,a1

    move.l  #$30303030,a5

    move.l  (a0)+,d0
    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3

    move.l  a5,d4           ; Merge 4x1, part 1
    and.l   d4,d0
    and.l   d4,d2
    lsr.l   #4,d2
    or.l    d2,d0

    and.l   d4,d1
    and.l   d4,d3
    lsr.l   #4,d3
    move.w  c2p_longsperrow(a2),c2p_rowcount(a2)
    or.l    d3,d1

    move.l  (a0)+,d2
    move.l  (a0)+,d5
    move.l  (a0)+,d3
    move.l  (a0)+,d7

    and.l   d4,d5           ; Merge 4x1, part 2
    and.l   d4,d2
    lsr.l   #4,d5
    or.l    d5,d2

    and.l   d4,d3
    and.l   d4,d7
    lsr.l   #4,d7
    or.l    d7,d3

    move.w  d2,d7           ; Swap 16x2
    move.w  d0,d2
    swap    d2
    move.w  d2,d0
    move.w  d7,d2
    move.w  d3,d7
    move.w  d1,d3
    swap    d3
    move.w  d3,d1
    move.w  d7,d3

    bra.s   .start2
.x2

    move.l  (a0)+,d0
    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3

    move.l  c2p_planes+16(a2),a1
    move.l  d7,(a1,d6.w)
;   move.l  d7,-BPLSIZE(a1)

    move.l  a5,d4           ; Merge 4x1, part 1
    and.l   d4,d0
    and.l   d4,d2
    lsr.l   #4,d2
    or.l    d2,d0

    and.l   d4,d1
    and.l   d4,d3
    lsr.l   #4,d3
    or.l    d3,d1

    move.l  (a0)+,d2
    move.l  (a0)+,d5
    move.l  (a0)+,d3
    move.l  (a0)+,d7

    move.l  c2p_planes+20(a2),a1
    move.l  a4,(a1,d6.w)
;   move.l  a4,(a1)+

    and.l   d4,d5           ; Merge 4x1, part 2
    and.l   d4,d2
    lsr.l   #4,d5
    addq.w  #4,d6
    or.l    d5,d2

    and.l   d4,d3
    and.l   d4,d7
    lsr.l   #4,d7
    or.l    d7,d3

    move.w  d2,d7           ; Swap 16x2
    move.w  d0,d2
    swap    d2
    move.w  d2,d0
    move.w  d7,d2
    move.w  d3,d7
    move.w  d1,d3
    swap    d3
    move.w  d3,d1
    move.w  d7,d3

    subq.w  #1,c2p_rowcount(a2)
    bpl.s   .start2
    move.w  c2p_longsperrow(a2),c2p_rowcount(a2)
    add.w   c2p_modbytes(a2),d6
.start2
    move.l  a6,d4

    lsl.l   #2,d0           ; Merge 2x2
    or.l    d2,d0
    lsl.l   #2,d1
    or.l    d3,d1

    move.l  d1,d7           ; Swap 8x1
    lsr.l   #8,d7
    eor.l   d0,d7
    and.l   d4,d7
    eor.l   d7,d0
    lsl.l   #8,d7
    eor.l   d7,d1

    move.l  d1,d7           ; Swap 1x1
    lsr.l   #1,d7
    eor.l   d0,d7
    and.l   #$55555555,d7
    eor.l   d7,d0
    add.l   d7,d7
    eor.l   d1,d7

    move.l  d0,a4

    cmp.l   c2p_pixels(a2),a0
;   cmpa.l  a0,a2
    bne .x2

    move.l  c2p_planes+16(a2),a1
    move.l  d7,(a1,d6.w)
;   move.l  d7,-BPLSIZE(a1)
    move.l  c2p_planes+20(a2),a1
    move.l  a4,(a1,d6.w)
;   move.l  a4,(a1)+

.none
    movem.l (sp)+,a3-a6
    rts

.pl5    move.l  c2p_chkybuf(a2),a0
    move.w  c2p_bploffset(a2),d6
    move.l  c2p_planes+4*4(a2),a1
    add.w   d6,a1

    move.l  #$30303030,a5

    move.l  (a0)+,d0
    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3

    move.l  a5,d4           ; Merge 4x1, part 1
    and.l   d4,d0
    and.l   d4,d2
    lsr.l   #4,d2
    or.l    d2,d0

    and.l   d4,d1
    and.l   d4,d3
    lsr.l   #4,d3
    move.w  c2p_longsperrow(a2),c2p_rowcount(a2)
    or.l    d3,d1

    move.l  (a0)+,d2
    move.l  (a0)+,d5
    move.l  (a0)+,d3
    move.l  (a0)+,d7

    and.l   d4,d5           ; Merge 4x1, part 2
    and.l   d4,d2
    lsr.l   #4,d5
    or.l    d5,d2

    and.l   d4,d3
    and.l   d4,d7
    lsr.l   #4,d7
    or.l    d7,d3

    move.w  d2,d7           ; Swap 16x2
    move.w  d0,d2
    swap    d2
    move.w  d2,d0
    move.w  d7,d2
    move.w  d3,d7
    move.w  d1,d3
    swap    d3
    move.w  d3,d1
    move.w  d7,d3

    bra.s   .start2pl5
.x2pl5

    move.l  (a0)+,d0
    move.l  (a0)+,d2
    move.l  (a0)+,d1
    move.l  (a0)+,d3

    move.l  d7,(a1)+

    move.l  a5,d4           ; Merge 4x1, part 1
    and.l   d4,d0
    and.l   d4,d2
    lsr.l   #4,d2
    or.l    d2,d0

    and.l   d4,d1
    and.l   d4,d3
    lsr.l   #4,d3
    or.l    d3,d1

    move.l  (a0)+,d2
    move.l  (a0)+,d5
    move.l  (a0)+,d3
    move.l  (a0)+,d7

    and.l   d4,d5           ; Merge 4x1, part 2
    and.l   d4,d2
    lsr.l   #4,d5
    addq.w  #4,d6
    or.l    d5,d2

    and.l   d4,d3
    and.l   d4,d7
    lsr.l   #4,d7
    or.l    d7,d3

    move.w  d2,d7           ; Swap 16x2
    move.w  d0,d2
    swap    d2
    move.w  d2,d0
    move.w  d7,d2
    move.w  d3,d7
    move.w  d1,d3
    swap    d3
    move.w  d3,d1
    move.w  d7,d3

    subq.w  #1,c2p_rowcount(a2)
    bpl.s   .start2pl5
    move.w  c2p_longsperrow(a2),c2p_rowcount(a2)
    add.w   c2p_modbytes(a2),a1
.start2pl5
    move.l  a6,d4

    lsl.l   #2,d0           ; Merge 2x2
    or.l    d2,d0
    lsl.l   #2,d1
    or.l    d3,d1

    move.l  d1,d7           ; Swap 8x1
    lsr.l   #8,d7
    eor.l   d0,d7
    and.l   d4,d7
    eor.l   d7,d0
    lsl.l   #8,d7
    eor.l   d7,d1

    move.l  d1,d7           ; Swap 1x1
    lsr.l   #1,d7
    eor.l   d0,d7
    and.l   #$55555555,d7
;   eor.l   d7,d0
    add.l   d7,d7
    eor.l   d1,d7

;   move.l  d0,a4

    cmp.l   c2p_pixels(a2),a0
    bne .x2pl5

    move.l  d7,(a1)+
    movem.l (sp)+,a3-a6
    rts

    cnop    0,4
c2p_data
    ds.l    16

    rsreset
c2p_chkybuf rs.l    1
c2p_numplanes   rs.l    1
c2p_longsperrow rs.l    1
c2p_rowcount    rs.l    1
c2p_modbytes    rs.l    1
c2p_pixels  rs.l    1
c2p_bploffset   rs.l    1
c2p_planes  rs.l    6

;c2p_datanew
;   ds.l    16

    Lib_Par      IOErrorStringNoToken  +++
    Rbsr    L_GetKickVer
    cmp.w   #37,d0
    blt.s   .kick13
    dload   a2
    move.l  (a3)+,d1
    lea .empty(pc),a0
    move.l  a0,d2
    lea O_ParseBuffer(a2),a0
    move.l  a0,d3
    moveq.l #127,d4
    move.l  a6,d6
    move.l  DosBase(a5),a6
    jsr _LVOFault(a6)
    move.l  d6,a6
    lea O_ParseBuffer+2(a2),a0
    moveq.l #2,d2
    Rbra    L_MakeAMOSString
.kick13 move.l  (a3)+,d0
    moveq.l #0,d1
    lea .errnam(pc),a0
.nextli move.b  (a0)+,d2
    beq.s   .nofou
    cmp.b   d0,d2
    beq.s   .found
.loop   tst.b   (a0)+
    bne.s   .loop
    bra.s   .nextli
.nofou  lea .empty(pc),a0
    move.l  a0,d3
    moveq.l #2,d2
    rts
.found  moveq.l #2,d2
    Rbra    L_MakeAMOSString
.empty  dc.l    0
    Rdata
    IFEQ    Languag-English
.errnam ;dc.b   47,'buffer overflow',0
;   dc.b    48,'***Break',0
    dc.b    49,'file not executable',0
    dc.b    103,'not enough memory available',0
;   dc.b    105,'process table full',0
;   dc.b    114,'bad template',0
;   dc.b    115,'bad number',0
;   dc.b    116,'required argument missing',0
;   dc.b    117,'value after keyword missing',0
;   dc.b    118,'wrong number of arguments',0
;   dc.b    119,'unmatched quotes',0
;   dc.b    120,'argument line invalid or too long',0
    dc.b    121,'file is not executable',0
;   dc.b    122,'invalid resident library',0
    dc.b    202,'object is in use',0
    dc.b    203,'object already exists',0
    dc.b    204,'directory not found',0
    dc.b    205,'object not found',0
;   dc.b    206,'invalid window description',0
    dc.b    207,'object is too large',0
;   dc.b    209,'packet request type unknown',0
    dc.b    210,'object name invalid',0
    dc.b    211,'invalid object lock',0
    dc.b    212,'object is not of required type',0
    dc.b    213,'disk is not validated',0
    dc.b    214,'disk is write-protected',0
    dc.b    215,'rename across devices attempted',0
    dc.b    216,'directory not empty',0
    dc.b    217,'too many levels',0
    dc.b    218,'device (or volume) is not mounted',0
    dc.b    219,'seek failure',0
    dc.b    220,'comment is too long',0
    dc.b    221,'disk full',0
    dc.b    222,'object is protected from deletion',0
    dc.b    223,'file is write protected',0
    dc.b    224,'file is read protected',0
    dc.b    225,'not a valid DOS disk',0
    dc.b    226,'no disk in drive',0
    dc.b    232,'no more entries in directory',0
;   dc.b    233,'object is in soft link',0
;   dc.b    234,'object is linked',0
;   dc.b    235,'bad loadfile hunk',0
;   dc.b    236,'function not implemented',0
;   dc.b    240,'record not locked',0
;   dc.b    241,'record lock collision',0
;   dc.b    242,'record lock timeout',0
;   dc.b    243,'record unlock error',0
    dc.b    0
    ENDC
    IFEQ    Languag-Deutsch
.errnam ;dc.b   47,'Pufferüberlauf',0
;   dc.b    48,'*** Abbruch',0
    dc.b    49,'Datei nicht ausführbar',0
    dc.b    103,'Speichermangel',0
;   dc.b    105,'Prozeßtabelle ist voll',0
;   dc.b    114,'Falsches Namensmuster',0
;   dc.b    115,'Ungültiges Zahlenwert',0
;   dc.b    116,'Gefordertes Argument fehlt',0
;   dc.b    117,'Argument nach Schlüsselwort fehlt',0
;   dc.b    118,'Falsche Anzahl an Argumenten',0
;   dc.b    119,'Ungerade Anzahl von Anführungszeichen',0
;   dc.b    120,'Argumentzeile ist ungültig oder zu lang',0
    dc.b    121,'Datei nicht ausführbar',0
;   dc.b    122,'Ungültige residente Library',0
    dc.b    202,'Objekt ist in Gebrauch',0
    dc.b    203,'Objekt existiert bereits',0
    dc.b    204,'Verzeichnis nicht gefunden',0
    dc.b    205,'Objekt nicht gefunden',0
;   dc.b    206,'Ungültige Fensterparameter',0
    dc.b    207,'Objekt ist zu groß',0
;   dc.b    209,'Unbekannter DOS-Packet-Request-Typ',0
    dc.b    210,'Ungültiger Objektname',0
    dc.b    211,'Ungültiger Zugriff auf Objekt',0
    dc.b    212,'Objekt ist nicht vom geforderten Typ',0
    dc.b    213,'Disk ist nicht gültig',0
    dc.b    214,'Disk ist schreibgeschützt',0
    dc.b    215,'Umbenennen auf anderen Datenträger versucht',0
    dc.b    216,'Verzeichnis ist nicht leer',0
    dc.b    217,'Zu tiefe Verschachtelung',0
    dc.b    218,'Gerät (oder Datenträger) ist nicht angemeldet',0
    dc.b    219,'Fehler beim Suchlesen',0
    dc.b    220,'Kommentar ist zu lang',0
    dc.b    221,'Disk ist voll',0
    dc.b    222,'Objekt ist löschgeschützt',0
    dc.b    223,'Objekt ist schreibgeschützt',0
    dc.b    224,'Objekt ist lesegeschützt',0
    dc.b    225,'Keine gültige DOS-Disk',0
    dc.b    226,'Keine Diskette im Laufwerk',0
    dc.b    232,'Keine weiteren Verzeichniseinträge',0
;   dc.b    233,'Objekt im Verbund',0
;   dc.b    234,'Verbundobjekt',0
;   dc.b    235,'Ungültiger Hunk in zu ladender Datei',0
;   dc.b    236,'Funktion ist nicht implementiert',0
;   dc.b    240,'Datensatz nicht gesperrt',0
;   dc.b    241,'Kollision bei Datensperre',0
;   dc.b    242,'Zeitüberschreitung bei Datensatzsperre',0
;   dc.b    243,'Fehler bei Datensatzfreigabe',0
    dc.b    0
    ENDC
    even
    Lib_Par      GetBobInfos       +++ -(a3)=image,x,y
    Rjsr    L_Bnk.GetBobs
    Rbeq    L_IFonc
    move.l  (a3)+,d0
    move.w  (a0)+,d1
    cmp.w   d1,d0
    Rbhi    L_IFonc
    subq.w  #1,d0
    lsl.w   #3,d0
    move.l  (a0,d0.w),d2
    Rbeq    L_IFonc
    move.l  d2,a1
    move.l  a1,O_BobAdr(a2)
    move.l  4(a0,d0.w),O_BobMask(a2)
    move.w  (a1),O_BobWidth(a2)
    move.w  2(a1),O_BobHeight(a2)
    move.w  8(a1),d0
    move.l  (a3)+,d1
    sub.w   d0,d1
    move.w  d1,O_BobY(a2)
    move.w  6(a1),d0
    ext.w   d0
    move.l  (a3)+,d1
    sub.w   d0,d1
    move.w  d1,O_BobX(a2)
    move.l  (a3)+,d1
    Rjsr    L_GetEc
    move.l  a0,a6
    move.w  O_SBobPlanes(a2),d0
.tstlop tst.l   (a6)+
    bne.s   .cont
    addq.w  #1,d0
    sub.w   d0,O_SBobPlanes(a2)
    bra.s   .quit
.cont   dbra    d0,.tstlop
.quit   move.l  a0,a6
    move.l  O_BobAdr(a2),a5
    lea 10(a5),a5
    tst.w   O_SBobMask(a2)
    beq.s   .image
    move.l  O_BobMask(a2),d0
    beq.s   .image
    move.l  d0,a5
    addq.l  #4,a5
.image  move.w  EcTx(a0),d4
    lsr.w   #3,d4
    move.w  O_BobWidth(a2),d7
    sub.w   d7,d4
    sub.w   d7,d4
    ext.l   d4
    moveq.l #0,d3
    move.w  O_BobHeight(a2),d6
    move.w  O_BobY(a2),d3
    bpl.s   .noucli
.ucllop subq.w  #1,d6
    add.w   O_BobWidth(a2),a5
    add.w   O_BobWidth(a2),a5
    addq.w  #1,d3
    bmi.s   .ucllop
.noucli move.w  d3,d0
    add.w   d6,d0
    cmp.w   EcTy(a0),d0
    bls.s   .nobcli
    move.w  EcTy(a0),d6
    sub.w   d3,d6
.nobcli rts

    Lib_Par      InitSplinter      +++ InitSplinter: a0=Splinteraddress
    tst.w   d5
    beq.s   .nonew
    moveq.l #0,d0
    move.w  (a3),d0
    move.w  2(a3),d1
    cmp.w   d0,d1
    beq.s   .nonew
    subq.w  #1,d5
    addq.w  #1,2(a3)
    move.l  4(a3),d0
    move.l  (a3,d0.l),Sp_X(a0)
    move.w  Sp_X(a0),d1
    lsr.w   #4,d1
    ext.l   d1
    move.w  Sp_Y(a0),d0
    lsr.w   #4,d0
    mulu    EcTx(a4),d0
    add.l   d1,d0
    move.l  d0,Sp_Pos(a0)
    addq.l  #4,4(a3)
    clr.b   Sp_Col(a0)
    st  Sp_First(a0)
    st  Sp_BkCol(a0)
    move.w  O_SpliFuel(a2),Sp_Fuel(a0)
.loop   add.w   (a1),d6
    move.w  d6,d0
    and.w   #%111111,d0
    beq.s   .loop
    sub.w   #31,d0
.loop2  add.w   (a1),d6
    move.w  d6,d1
    and.w   #%111111,d1
    beq.s   .loop2
    sub.w   #31,d1
    move.w  d0,Sp_Sx(a0)
    move.w  d1,Sp_Sy(a0)
    rts
.nonew  st  Sp_Col(a0)
    st  Sp_BkCol(a0)
    rts

    Lib_Par      MoveSplinter      +++ MoveSplinter: a0=Splinteraddress
    move.l  Sp_Pos(a0),Sp_DbPos(a0)
    move.b  Sp_BkCol(a0),Sp_DbBkCol(a0)
    move.b  Sp_Col(a0),d0
    cmp.b   #$FF,d0
    Rbeq    L_InitSplinter
    tst.b   Sp_First(a0)
    beq.s   .cont
    rts
.cont   tst.w   Sp_Fuel(a0)
    Rbeq    L_InitSplinter
    subq.w  #1,Sp_Fuel(a0)
    move.w  Sp_X(a0),d2
    move.w  Sp_Y(a0),d3
    add.w   Sp_Sx(a0),d2
    add.w   Sp_Sy(a0),d3
    cmp.w   O_SpliLimits(a2),d2
    bmi.s   .newst
    cmp.w   O_SpliLimits+2(a2),d3
    bmi.s   .newst
    cmp.w   O_SpliLimits+4(a2),d2
    bpl.s   .newst
    cmp.w   O_SpliLimits+6(a2),d3
    bpl.s   .newst
    move.w  d2,Sp_X(a0)
    lsr.w   #4,d2
    ext.l   d2
    move.w  d3,Sp_Y(a0)
    lsr.w   #4,d3
    mulu    EcTx(a4),d3
    add.l   d2,d3
    move.l  d3,Sp_Pos(a0)
    move.w  O_SpliGravity(a2),d2
    move.w  O_SpliGravity+2(a2),d3  
    add.w   d2,Sp_Sx(a0)
    add.w   d3,Sp_Sy(a0)
    rts
.newst  Rbra    L_InitSplinter

    Lib_Par      InitStar      +++ InitStar: a0=Staraddress
    moveq.l #0,d0
    move.l  O_StarOrigin(a2),(a0)
;   move.w  O_StarOrigin(a2),d0
;   add.w   (a1),d6
;   move.w  d6,d1
;   and.w   #%1110000,d1
;   sub.w   #64,d0
;   add.w   d1,d0
;   move.w  d0,(a0)         ;St_X
;   move.w  O_StarOrigin+2(a2),d0
;   add.w   (a1),d6
;   move.w  d6,d1
;   and.w   #%1110000,d1
;   sub.w   #64,d0
;   add.w   d1,d0
;   move.w  d0,St_Y(a0)
.loop   add.w   (a1),d6
    move.w  d6,d0
    and.w   #%1111111,d0
    sub.w   #63,d0
    move.w  d0,d2
    bpl.s   .plus1
    not.w   d2
.plus1  add.w   (a1),d6
    move.w  d6,d1
    and.w   #%1111111,d1
    sub.w   #63,d1
    move.w  d1,d3
    bpl.s   .plus2
    not.w   d3
.plus2  add.w   d3,d2
    cmp.w   #16,d2
    blt.s   .loop
    move.w  d0,St_Sx(a0)
    move.w  d1,St_Sy(a0)
    rts

    Lib_Def      MoveStar      +++ MoveStar: a0=Staraddress
    move.l  (a0),St_DbX(a0)     ;St_X
    move.w  (a0),d2         ;St_X
    move.w  St_Y(a0),d3
    add.w   St_Sx(a0),d2
    add.w   St_Sy(a0),d3
    cmp.w   O_StarLimits(a2),d2
    bcs.s   .newst
    cmp.w   O_StarLimits+2(a2),d3
    bcs.s   .newst
    cmp.w   O_StarLimits+4(a2),d2
    bcc.s   .newst
    cmp.w   O_StarLimits+6(a2),d3
    bcc.s   .newst
    move.w  d2,(a0)         ;St_X
    move.w  d3,St_Y(a0)
    move.w  O_StarGravity(a2),d2
    move.w  O_StarGravity+2(a2),d3  
    add.w   d2,St_Sx(a0)
    add.w   d3,St_Sy(a0)
    tst.w   O_StarAccel(a2)
    bne.s   .accl
    rts
.accl   move.w  St_Sx(a0),d2
    bpl.s   .addsx
    move.w  d2,d0
    not.w   d0
    lsr.w   #4,d0
    sub.w   d0,d2
    bra.s   .cont1
.addsx  move.w  d2,d0
    lsr.w   #4,d0
    add.w   d0,d2
.cont1  move.w  St_Sy(a0),d3
    bpl.s   .addsy
    move.w  d3,d0
    not.w   d0
    lsr.w   #4,d0
    sub.w   d0,d3
    bra.s   .cont2
.addsy  move.w  d3,d0
    lsr.w   #4,d0
    add.w   d0,d3
.cont2  move.w  d2,St_Sx(a0)
    move.w  d3,St_Sy(a0)
    rts
.newst  Rbra    L_InitStar
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
;    include "Amcaf/CustomErrors.asm"
    Lib_Def      IOoMem        +++ Out of memory
    Rbsr    L_FreeExtMem
    moveq   #24,d0
    Rjmp    L_Error

    Lib_Def      IFonc         +++ Illegal function call
    Rbsr    L_FreeExtMem
    moveq   #23,d0
    Rjmp    L_Error

    Lib_Def      IFNoFou       +++ File not found
    Rbsr    L_FreeExtMem
    moveq   #DEBase+2,d0
    Rjmp    L_Error

    Lib_Def      IIOError      +++ IO error
    Rbsr    L_FreeExtMem
    moveq   #DEBase+15,d0
    Rjmp    L_Error

    Lib_Def      IPicNoFit     +++ Pic doesn't fit
    Rbsr    L_FreeExtMem
    moveq   #32,d0
    Rjmp    L_Error

    Lib_Def      IScNoOpen     +++ Screen not open
    Rbsr    L_FreeExtMem
    moveq   #47,d0
    Rjmp    L_Error

    Lib_Def      INotOS2       +++ This command needs OS 2.04!
    Rbsr    L_FreeExtMem
    moveq   #12,d0
    Rbra    L_Custom

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
;;    include "Amcaf/PrecalcTables.asm"
    Lib_Def      PrecalcTables
    lea O_Div5Buf(a2),a1
    move.w  #255,d7
    moveq.l #0,d0
.d5loop move.b  d0,(a1)+
    move.b  d0,(a1)+
    move.b  d0,(a1)+
    cmp.b   #255,d0
    beq.s   .s255
    addq.w  #1,d0
.s255   move.b  d0,(a1)+
    move.b  d0,(a1)+
    dbra    d7,.d5loop
    lea O_SineBuf(a2),a1
    move.l  a1,O_SineTable(a2)
    move.w  #254,d1
    lea .sintab(pc),a0
.lop1   move.w  (a0)+,(a1)+
    dbra    d1,.lop1
    move.w  #256,(a1)+
    addq.l  #2,a0
    move.w  #255,d1
.lop2   move.w  -(a0),(a1)+
    dbra    d1,.lop2
    move.w  #254,d1
.lop3   move.w  (a0)+,(a1)
    neg.w   (a1)+
    dbra    d1,.lop3
    move.w  #-256,(a1)+
    addq.l  #2,a0
    move.w  #255,d1
.lop4   move.w  -(a0),(a1)
    neg.w   (a1)+
    dbra    d1,.lop4
    lea .tantab(pc),a0
    move.l  a0,O_TanTable(a2)
    movem.l d0-d7/a0-a6,-(sp)   ; Make Zoom Table
    dload   a2
    move.w  #255,d7
    lea O_Zoom2Buf+256*2(a2),a0
.loop1  moveq.l #7,d6
    moveq.l #0,d0
.loop2  lsl.w   #2,d0
    btst    d6,d7
    beq.s   .cnt
    addq.w  #3,d0
.cnt    dbra    d6,.loop2
    move.w  d0,-(a0)
    dbra    d7,.loop1
    move.w  #255,d7
    lea O_Zoom4Buf+256*4(a2),a0
.loop1b moveq.l #7,d6
    moveq.l #0,d0
.loop2b asl.l   #4,d0
    btst    d6,d7
    beq.s   .cntb
    add.w   #15,d0
.cntb   dbra    d6,.loop2b
    move.l  d0,-(a0)
    dbra    d7,.loop1b
    move.w  #255,d7
    lea O_Zoom8Buf+256*4*2(a2),a0
.loop1c moveq.l #3,d6
    moveq.l #7,d5
    moveq.l #0,d0
.loop2c asl.l   #8,d0
    btst    d5,d7
    beq.s   .cntc
    st  d0
.cntc   subq.w  #1,d5
    dbra    d6,.loop2c
    moveq.l #3,d6
    moveq.l #0,d1
.loop3c asl.l   #8,d1
    btst    d6,d7
    beq.s   .cntcd
    st  d1
.cntcd  dbra    d6,.loop3c
    move.l  d1,-(a0)
    move.l  d0,-(a0)
    dbra    d7,.loop1c
    movem.l (sp)+,d0-d7/a0-a6
    rts
    Rdata
.sintab:
;   incbin  "data/sinetablequad.bin"
.tantab:
;   incbin  "data/tantable.bin"
    even


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

;;    include "Amcaf/Error.asm"
    Lib_Def      Custom
    lea .ErrMes(pc),a0
    moveq   #0,d1           * Can be trapped
    moveq   #0,d3           * IMPORTANT!!!
    moveq   #ExtNb,d2       * Number of extension
    Rjmp    L_ErrorExt      * Jump to routine...
.ErrMes
    IFEQ    Languag-English
    dc.b    0
    dc.b    "Can't reopen Workbench",0          *1
    dc.b    "Not an RNC-packed file",0          *2
    dc.b    "Couldn't allocate channels",0          *3
    dc.b    "No icons- or spritesbanks allowed",0       *4
    dc.b    "No powerpacker.library",0          *5
    dc.b    "Crunching error",0             *6
    dc.b    "File/bank is encrypted",0          *7
    dc.b    "Not a PowerPacker/Imploder-Bank",0     *8
    dc.b    "No diskfont.library",0             *9
    dc.b    "Couldn't open font",0              *10
    dc.b    "Couldn't launch process",0         *11
    dc.b    "Kickstart 2.04 or greater required",0      *12
    dc.b    "No icon.library",0             *13
    dc.b    "Serious error during reinitialision",0     *14
    dc.b    "At least 4 colours required in screen",0   *15
    dc.b    "No CIA-Timer available",0          *16
    dc.b    "Cannot open lowlevel.library",0        *17
    dc.b    "At least 4 planes required!",0         *18
    dc.b    "MC68020 or higher required!",0         *19
    ENDC
    IFEQ    Languag-Deutsch
    dc.b    0
    dc.b    "Kann Workbench nicht öffnen",0         *1
    dc.b    "Datei nicht mit IMP! gepacked",0       *2
    dc.b    "Konnte die Kanäle nicht allokieren",0      *3
    dc.b    "Icons-oder Spritesbanks verboten",0        *4
    dc.b    "Keine powerpacker.library",0           *5
    dc.b    "Fehler während des Packens",0          *6
    dc.b    "Datei/Bank ist verschlüsselt",0        *7
    dc.b    "Keine PowerPacker/Imploder-Bank",0     *8
    dc.b    "Zu viele Fonts offen",0            *9
    dc.b    "Kann Font nicht öffnen",0          *10
    dc.b    "Kann Prozess nicht starten",0          *11
    dc.b    "Kickstart 2.04+ wird benötigt",0       *12
    dc.b    "Keine icon.library",0              *13
    dc.b    "Ernster Fehler bei Reinitialisierung",0    *14
    dc.b    "Mindestens 4 Farben im Screen benötigt",0  *15
    dc.b    "Kein CIA-Timer mehr frei",0            *16
    dc.b    "Kann die lowlevel.library nicht öffnen",0  *17
    dc.b    "Mindestens 4 Bitplanes benötigt!",0        *18
    dc.b    "MC68020 oder höher benötigt!",0        *19
    ENDC
    even

    Lib_Def      Custom2
    moveq   #0,d1
    moveq   #-1,d3
    moveq   #ExtNb,d2
    Rjmp    L_ErrorExt

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
