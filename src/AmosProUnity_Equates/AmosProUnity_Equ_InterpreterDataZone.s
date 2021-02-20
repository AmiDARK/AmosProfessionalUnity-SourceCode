***************************************************************
*        Interpretor datas zone
*        Pointed to by A5
***************************************************************
Bit_PaSaut    equ    0

        RsReset

;        VBL Routines
; ~~~~~~~~~~~~~~~~~~~~~~~~~~ 
VblRout:    rs.l     8

;        Extensions
; ~~~~~~~~~~~~~~~~~~~~~~~~
AdTokens:    rs.l     27        
AdTTokens:    rs.l     27
ExtAdr:        rs.l     26*4
ExtTests:    rs.l     8

;         Adresses Kickstart
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DosBase:    rs.l     1
DFloatBase    rs.l    1
DMathBase    rs.l    1
FloatBase:    rs.l    1
MathBase:    rs.l     1
IconBase:    rs.l     1

;         Données systeme
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Sys_AData    rs.l    1
Sys_LData    rs.l    1
Sys_Message    rs.l    1
Sys_WAd        rs.l    1
Sys_WSegment    rs.l    1
Sys_Messages    rs.l    1
Sys_Banks    rs.l    1
        rs.l    1        Libre
        rs.l    1        Libre
        rs.l    1        Libre
Sys_Editor    rs.l    1
Fs_Liste    rs.l    1
Sys_Resource    rs.l    1
Sys_WStarted    rs.b    1
Sys_LibStarted    rs.b    1
Sys_Pathname    rs.b    76
Sys_DefaultRoutines    rs.l    1        A modifier!

Sys_Jumps    rs.l    1
Prg_List    rs.l    1
Prg_Runned    rs.l    1

;        Graphics
; ~~~~~~~~~~~~~~~~~~~~~~
AAreaSize:    equ     16
AAreaInfo:    rs.b     24
AAreaBuf:    rs.b     AAreaSize*5+10
        rs.b     16
ATmpRas:    rs.l     2
AppNPlan    rs.w     1
SccEcO:        rs.l     1
SccEcD:        rs.l     1

;        File selector
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
Mon_Base    rs.l     1            
Mon_Banks    rs.l     1            
    
TRd_OldEc    rs.w     1
CurTab        rs.w     1    
FillFPosPoke    rs.w    1    
Mon_Segment    rs.l     1        
Edit_Segment    rs.l     1        
Sys_ClearRoutines     rs.l     1    Routines appellees par ClearVar
Sys_ErrorRoutines    rs.l    1    Routines appellees par RunErr

WB2.0:        rs.w     1        
Fs_Base        rs.l    1
Fs_Saved    rs.l    1
Fs_SaveList    rs.l    1
Test_Flags    rs.b    1
FillFSorted    rs.b    1

BasSp:        rs.l     1    
Fs_PosStore    rs.w     1        
ColBack:    rs.w     1
DefFlag:    rs.w     1    

;        Float
; ~~~~~~~~~~~~~~~~~~~
BuFloat:    rs.b     64
DeFloat:    rs.b     32
TempFl:        rs.l     1
TempBuf:    rs.l     1
MemChipTotal    rs.l     1
MemFastTotal    rs.l     1

;        Disque I/O
; ~~~~~~~~~~~~~~~~~~~~~~~~
IffParam:    rs.l     1
IffFlag:    rs.l     1
IffReturn    rs.l     1
BufFillF:    rs.l     1
FillFLong:    rs.w     1
FillFSize:    rs.w     1
FillFNb:    rs.w     1
FillF32:    rs.w     1
DirLong:    rs.l     1
DirComp:    rs.w     1
DirLNom:    rs.w     1    
PathAct:    rs.l     1
DirFNeg:    rs.l     1    
BufBMHD:    rs.l     1
BufCMAP:    rs.l     1
BufCAMG:    rs.l     1
BufCCRT:    rs.l     1
BufAMSC:    rs.l     1

;         Tokenisation / Stockage
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TkAd:        rs.l     1    
TkChCar:    rs.w     1    
VerPos:        rs.l     1    
VerBase:    rs.l     1    
VerNInst    rs.l    1
VerNot1.3    rs.b    1
VerCheck1.3    rs.b    1
Parenth:    rs.w     1    
WBench        rs.b    1
WB_Closed    rs.b    1

TBuffer:       equ 8192            ; 2020.05.01 Increase default buffer from 1Ko to 8Ko for SPack 256 colors palette updates. +B.s/LDataWork (L1406) automatically update.
TMenage:    equ     160*10-64
Buffer:        rs.l     1     ; Buffer for Load iFF / IFF Anim
BMenage:    rs.l     1

LimSave:    rs.w     4
FsLimSave:    rs.w     4
Name1:        rs.l     1    
Name2:        rs.l     1

Access:        rs.l     1        
AcLdTemp:    rs.l     1
AccFlag:    rs.w     1

RasAd:        rs.l     1        
RasLong:    rs.l     1
RasSize:    rs.w     1
RasLock:    rs.l     1
ScOn:        rs.w     1
ScOnAd:        rs.l     1
BufBob:        rs.l     1
BufLabel:    rs.l     1
LMouse:        rs.l     1
VBLOCount:    rs.w     1
VBLDelai:    rs.w     1
SScan:        rs.w     1
Seed:        rs.l     1
OldRnd:        rs.l     1
PAmalE:        rs.w     1
ReqSave:    rs.l     1
ReqSSave:    rs.l     1
SNoFlip:    rs.w     1
LockSave:    rs.l     1
Handle:        rs.l     1
PrtHandle:    rs.l     1
PosFillF:    rs.w     1
TempBuffer    rs.l     1

;        Canaux d''animation
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AnCanaux:    rs.w 64
InterOff:    rs.w 1

