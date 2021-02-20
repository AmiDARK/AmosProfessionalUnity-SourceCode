; ____________________________________________________________________________
;
;                            VARIABLES RUN-TIME
; ____________________________________________________________________________
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Debut de la zone poussee par PRUN
;
DebSave:    equ __RS

;        Adresse de la liste de Banques/Dialogues
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Cur_Banks    rs.l     1
Cur_Dialogs    rs.l    1
Cur_ChrJump    rs.l    1

;         Donnnes du programme
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Stack_ProcSize    equ    42
Stack_Size    rs.w     1
Stack_CSize    rs.w     1
Prg_Source    rs.l     1
Prg_FullSource    rs.l    1
Prg_Includes    rs.l    1
Prg_Run        rs.l    1
Prg_Test    rs.l    1
Prg_JError    rs.l    1
Prg_ChrGet    rs.l    1

;         Verification / Buffers
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Passe:        rs.w 1
VarBuf:        rs.l 1        
VarBufL:    rs.l 1        
VarBufFlg:    rs.w 1        
LabHaut:    rs.l 1        
LabBas:        rs.l 1
LabMini:    rs.l 1
DVNmBas:    rs.l 1        
DVNmHaut:    rs.l 1
VNmLong:    rs.l 1
VNmHaut:    rs.l 1
VNmBas:        rs.l 1
VNmMini:    rs.l 1
VDLigne:    rs.l 1
Ver_TablA    rs.l 1        
Ver_CTablA    rs.l 1
VarLong:    rs.w 1
GloLong:    rs.w 1
VarGlo:        rs.l 1
VarLoc:        rs.l 1
TabBas:        rs.l 1
ChVide:        rs.l 1
LoChaine:    rs.l 1        
HiChaine:    rs.l 1        
HoLoop:        rs.l 1
BaLoop:        rs.l 1

;        Donnees RUN
; ~~~~~~~~~~~~~~~~~~~~~~~~~
PLoop:        rs.l 1
MinLoop:    rs.l 1
BasA3:        rs.l 1
ErrRet:        rs.l 1        
ErrRAd:        rs.l 1
Phase:        rs.w 1
Ver_FTablA    rs.l 1
Ver_MainTablA    rs.l 1
Ver_PTablA    rs.l 1
Ver_SPConst    rs.b 1
Ver_DPConst    rs.b 1
ActuMask:    rs.w 1        
IffMask:    rs.l 1
ExpFlg:        rs.w 1
FixFlg:        rs.w 1

;         DEVICES / LIBRARIES
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Dev_Max        equ    7
Dev_List    rs.b    12*Dev_Max
Lib_Max        equ    7
Lib_List    rs.l    4*Lib_Max

;         MENUS
; ~~~~~~~~~~~~~~~~~~~
MnNDim:        equ 8
Mn_SSave    equ    __RS        Debut du flip de l''editeur
MnBase:        rs.l     1        ~~~~~~~~~~~~~~~~~~~~~~~~~~
MnBaseX:    rs.w     1
MnBaseY:    rs.w     1
MnChange:    rs.w     1
MnMouse:    rs.w     1
MnError:    rs.w     1
MnAdEc:        rs.l     1
MnScOn:        rs.w     1
MgFlags:    rs.w     1
MnNZone:    rs.w     1
MnZoAct:    rs.w    1
MnAct:        rs.l    1
MnTDraw:    rs.l    1
MnTable:    rs.l     MnNDim+1
MnChoix:    rs.w     MnNDim
MnDFlags:    rs.b     MnNDim
MnDAd:        rs.l     1
MnProc:        rs.w     1
Mn_ESave    equ    __RS        Fin du flip editeur
MnRA3:        rs.l     1        ~~~~~~~~~~~~~~~~~~~
MnRA4:        rs.l     1
MnPile:        rs.l     1
OMnBase:    rs.l     1
OMnNb:        rs.w     1
OMnType:    rs.w    1

;        Def Scroll, reduit à 10 zones!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NDScrolls    equ    10
DScrolls:    rs.w     6*NDScrolls

;        Zone extra en plus, 72 octets libres!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GoTest_Dialog    rs.l    1        * 0
GoTest_Menus    rs.l    1        * 4
GoTest_MenuKey    rs.l    1        * 8
GoTest_GoMenu    rs.l    1        * 12
GoTest_Every    rs.l    1        * 16
GoTest_OnBreak    rs.l    1        * 20
        rs.l    1        * 24
Cmp_CurBanks    rs.l    1        * 28
Cmp_CurDialogs    rs.l    1        * 32
Cmp_AForNext    rs.l    1        * 36
Cmp_AdLabels    rs.l    1        * 40
Cmp_LowPile    rs.l    1        * 44
Cmp_LowPileP    rs.l    1        * 48
Cmp_NumProc    rs.l    1        * 52
Cmp_ListInst    rs.l    1        * 56
Cmp_Ligne    rs.w    1        * 60
                    * 62
        rs.b    72-(__RS-GoTest_Dialog)


;         Dialogues
; ~~~~~~~~~~~~~~~~~~~~~~~
IDia_BankPuzzle    rs.l    1
IDia_Error    rs.l    1

;        Patch monitor
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Patch_ScCopy    rs.l    1
Patch_ScFront    rs.l    1
Patch_Errors    rs.l    1
Patch_Menage    rs.l    1

; Verification ¦¦
; ~~~~~~~~~~~~~~~
Ver_TableVerif    rs.b    1
Ver_NoReloc    rs.b    1

;         Fichiers
; ~~~~~~~~~~~~~~~~~~~~~~
FhA:        equ 0
FhT:        equ 4
FhF:        equ 6
TFiche:        equ 10
NFiche:        equ 10
ChrInp:        rs.w 1
Fichiers:    rs.b TFiche*NFiche

;         AREXX
; ~~~~~~~~~~~~~~~~~~~
Arx_Port    rs.l    1
Arx_Base    rs.l    1
Arx_Answer    rs.l    1
Arx_PortName    rs.b    32

;        Every
; ~~~~~~~~~~~~~~~~~~~
EveType:    rs.w     1
EveLabel:    rs.l     1
EveCharge:    rs.w     1

;        Miscellenous
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
BuffSize:    rs.l     1
AdrIcon:    rs.l     1
DefPal:        rs.w    32              ; 2019.11.23 Updated default palette from 032 colors to 256 High Bits
DefPalAga:     rs.w    224             ; 2020.09.09 Separated ECS & AGA components
DefPalL:       rs.w    32              ; 2020.09.08 Updated default palette from 000 colors to 032 Low Bits
DefPalAgaL:    rs.w    224             ; 2020.09.08 Updated default palette from 032 colors to 256 Low Bits
DBugge        rs.l     1
CallAd:        rs.l     1
VarLongs    rs.b    8
VarLsls        rs.b    8
MathFlags    rs.b    1
        rs.b    1

;         Données télécommande
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Prg_Accessory    rs.b    1 
Ed_Zappeuse    rs.b    1


;        Variables mises à zero par un RUN 
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DebRaz:        equ     __RS
PrintFlg:    rs.w     1
PrintPos:    rs.l     1
PrinType:    rs.w     1
PrintFile:    rs.l     1
UsingFlg:    rs.w     1
ImpFlg:        rs.w     1
ParamE:        rs.l     1
ParamF:        rs.l     1
ParamC:        rs.l     1
InputFlg:    rs.w     1
ContFlg:    rs.w     1
ContChr:    rs.l     1
ErrorOn:    rs.w     1
ErrorChr:    rs.l     1
OnErrLine:    rs.l     1
TrapAdr        rs.l    1
TrapErr        rs.w    1
TVMax:        rs.w     1
DProc:        rs.l     1
AData:        rs.l     1
PData:        rs.l     1
MenA4:        rs.l     1
LockOld:    rs.l     1
MnChoice:    rs.w     1
Angle:        rs.w     1
Ed_YaUTest    rs.b    1
ErrorRegs    rs.b    1
CallReg:    rs.l     8+7
OnBreak        rs.l    1
Long_Var    rs.l    1
ParamF2        rs.l    1
ErrorSave    rs.l    2        Sauvegarde D6-D7 pour erreurs
Chr_Debug    rs.l    3        *** Debuggage!

FinRaz:        equ     __RS
FinSave:    equ     __RS
;        Fin de la zone pousse par PRUN
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ver_Reloc    rs.l    1        Table de relocation
Ver_CReloc    rs.l    1        Current
Ver_FReloc    rs.l    1        Maxi
Ver_NBoucles    rs.w    1    
Ver_PBoucles    rs.w    1
Ver_PrevTablA    rs.l    1        
FakeEvent_Cpt    rs.w    1        Compteur pour blanker
Fs_ErrPatch    rs.l    1        Patch erreurs file selector...
Sys_EndRoutines    rs.l    2        Routines de fin...
Prg_InsRet    rs.l    1        Retour de zappeuse...

