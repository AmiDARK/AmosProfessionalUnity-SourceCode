*************** AMOS system library
Inkey:        equ 0
ClearKey:    equ 1
Shifts:        equ 2
Instant:    equ 3
KeyMap:        equ 4
Joy:        equ 5
PutKey:        equ 6
Hide:        equ 7
Show:        equ 8
ChangeM:    equ 9
XyMou:        equ 10
XyHard:        equ 11
XyScr:        equ 12
MouseKey:    equ 13
SetM:        equ 14
ScIn:        equ 15
XyWin:        equ 16
LimitM:        equ 17
ZoHd:        equ 18
ResZone:    equ 19
RazZone:    equ 20
SetZone:    equ 21
GetZone:    equ 22
WaitVbl:    equ 23
SetHs:        equ 24
USetHs:        equ 25
SetFunk:    equ 26
GetFunk:    equ 27
AffHs:        equ 28
SetSpBank:    equ 29
NXYAHs:        equ 30
XOffHs:        equ 31
OffHs:        equ 32
ActHs:        equ 33
SBufHs:        equ 34
StActHs:    equ 35
ReActHs:    equ 36
StoreM:        equ 37
RecallM:    equ 38
PriHs:        equ 39
AMALTok:    equ 40
AMALCre:    equ 41
AMALMvO:    equ 42
AMALDAll:    equ 43
AMAL:        equ 44
AMALReg:    equ 45
AMALClr:    equ 46
AMALFrz:    equ 47
AMALUFrz:    equ 48
SetBob:        equ 49
OffBob:        equ 50
OffBobS:    equ 51
ActBob:        equ 52
AffBob:        equ 53
EffBob:        equ 54
SyChip:        equ 55
SyFast:        equ 56
LimBob:        equ 57
ZoGr:        equ 58
SprGet:        equ 59
MaskMk:        equ 60
SpotHot:    equ 61
ColBob:        equ 62
ColGet:        equ 63
ColSpr:        equ 64
SetSync:    equ 65
Synchro:    equ 66
PlaySet:    equ 67
XYBob:        equ 68
XYSp:        equ 69
PutBob:        equ 70
Patch:        equ 71
MouRel:        equ 72
LimitMEc:    equ 73
SyFree:        equ 74
SetHCol:    equ 75
GetHCol:    equ 76
MovOn:        equ 77
KeySpeed:    equ 78
ChanA:        equ 79
ChanM:        equ 80
SPrio:        equ 81
GetDisc:    equ 82
RestartVBL    equ 83
StopVBL        equ 84
KeyWaiting    equ 85        (P) Une touche en attente?
MouScrFront    equ 86        (P) Souris dans ecran de front
MemReserve    equ 87        (P) Reservation memoire
MemFree        equ 88        (P) Liberation memoire
MemCheck    equ 89        (P) Verification memoire
MemFastClear    equ 90
MemChipClear    equ 91
MemFast        equ 92
MemChip        equ 93
Send_FakeEvent    equ 94        Envoi d''un faux event clavier
Test_Cyclique    equ 95        Tests cyclique AMOS
AddFlushRoutine    equ 96        Ajoute une routine flush
MemFlush    equ 97        Force un flush memoire
AddRoutine    equ 98        Ajoute une routine
CallRoutines    equ 99        Appelle une liste de routines
Request_OnOff    equ 100        Set requester AMOS/WB
FatalQuit        equ 101        ; 2020.10.12 Added to allow CpInit with AGA support to be push into agaSupport.lib using plugin system 

SyCall:        MACRO
        move.l    T_SyVect(a5),a0
        jsr    \1*4(a0)
        ENDM

; **************** 2020.10.12 Added SyCallA1
SyCallA1:        MACRO
        move.l    T_SyVect(a5),a1
        jsr    \1*4(a1)
        ENDM

SyCallA2:        MACRO
        move.l    T_SyVect(a5),a2
        jsr    \1*4(a2)
        ENDM

SyJmp:           MACRO
        move.l    T_SyVect(a5),a0
        jmp    \1*4(a0)
        ENDM

; **************** 2020.10.12 Added SyCallA1

SyCalA:        MACRO
        lea    \2,a1
        move.l    T_SyVect(a5),a0
        jsr    \1*4(a0)
        ENDM
SyCalD:        MACRO
        moveq    #\2,d1
        move.l    T_SyVect(a5),a0
        jsr    \1*4(a0)
        ENDM
SyCal2:        MACRO
        moveq    #\2,d1
        move.l    #\3,a1
        move.l    T_SyVect(a5),a0
        jsr    \1*4(a0)
        ENDM
