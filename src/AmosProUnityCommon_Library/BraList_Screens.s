******* Jumps to screen functions
EcIn:
    bra    EcRaz        ;Raz:        
    bra    EcCopper    ;CopMake:    
    bra    EcCopper    ;*        
    bra    EcCree        ;Cree:        
    bra    EcDel        ;Del:        
    bra    EcFirst        ;First:        
    bra    EcLast        ;Last:        
    bra    EcMarch        ;Active:        
    bra    EcForceCop    ;CopForce:    
    bra    EcView        ;AView:        
    bra    EcOffs        ;OffSet:        
    bra    EcEnd        ;Visible:    
    bra    EcDAll        ;DelAll:        
    bra    EcGCol        ;GCol:        
    bra    EcSCol        ;SCol:        
    bra    EcSPal        ;SPal:        
    bra    EcSColB        ;SColB:        
    bra    FlStop        ;FlRaz:        
    bra    FlStart        ;Flash:        
    bra    ShStop        ;ShRaz:        
    bra    ShStart        ;Shift:        
    bra    EcHide        ;EHide:        
    bra    MakeCBloc    ;CBlGet:        
    bra    DrawCBloc    ;CBlPut:        
    bra    FreeCBloc    ;CBlDel:        
    bra    RazCBloc    ;CBlRaz:        
    bra    EcLibre        ;Libre:        
    bra    EcCClo        ;CCloEc:        
    bra    EcCrnt        ;Current:    
    bra    EcDouble    ;Double:        
    bra    ScSwap        ;SwapSc:        
    bra    ScSwapS        ;SwapScS:    
    bra    EcAdres        ;AdrEc:        
    bra    Duale        ;SetDual:    
    bra    DualP        ;PriDual:    
    bra    EcCls        ;ClsEc:        
    bra    SPat        ;Pattern:    
    bra    TGFonts        ;GFonts:        
    bra    TFFonts        ;FFonts:        
    bra    TGFont        ;GFont:        
    bra    TSFont        ;SFont:        
    bra    TSClip        ;SetClip:    
    bra    MakeBloc    ;- BlGet:        Routine blocs normaux
    bra    DelBloc        ;-BlDel:        
    bra    RazBloc        ;-BlRaz:        
    bra    DrawBloc    ;-BlPut:        
    bra    SliVer        ;- VerSli:        Slider vertical
    bra    SliHor        ;- HorSli:        Slider horizontal
    bra    SliSet        ;- SetSli:        Set slider params
    bra    StaMn        ;- MnStart:    Sauve l''ecran 
    bra    StoMn        ;- MnStop:        Remet l''ecran
    bra    TRDel        ;- RainDel:    Delete RAINBOW
    bra    TRSet        ;- RainSet:    Set RAINBOW
    bra    TRDo        ;- RainDo:        Do RAINBOW
    bra    TRHide        ;- RainHide:    Hide / Show RAINBOW
    bra    TRVar        ;- RainVar:    Var RAINBOW
    bra    FadeTOn        ;- FadeOn:        Fade
    bra    FadeTOf        ;- FadeOf:        Fade Off
    bra    TCopOn        ;- CopOnOff:    Copper ON/OFF
    bra    TCopRes        ;- CopReset:    Copper RESET
    bra    TCopSw        ;- CopSwap:    Copper SWAP
    bra    TCopWt        ;- CopWait:    Copper WAIT
    bra    TCopMv        ;- CopMove:    Copper MOVE
    bra    TCopMl        ;- CopMoveL:    Copper MOVEL
    bra    TCopBs        ;- CopBase:    Copper BASE ADDRESS
    bra    TAbk1        ;- AutoBack1:    Autoback 1
    bra    TAbk2        ;- AutoBack2:    Autoback 2
    bra    TAbk3        ;- AutoBack3:    Autoback 3
    bra    TAbk4        ;- AutoBack4:    Autoback 4
    bra    TPaint        ;- SuPaint:    Super paint!
    bra    RevBloc        ;- BlRev:        Retourne le bloc
    bra    RevTrap        ;- DoRev:        Retourne dans la banque
    bra    TAmosWB        ;- AMOS_WB        AMOS/WorkBench
    bra    WScCpy        ;- ScCpyW        New_W_2.s
    bra    TMaxRaw        ;- MaxRaw        Maximum raw number
    bra    TNTSC        ;- NTSC        NTSC?
    bra    SliPour        ;- PourSli        Calculs slider
    bra    EcGet                       ; 2020.10.11 Added to allow it to be callable from Amos Pro .lib plugins
    bra    Ec_Active                   ; 2020.10.11 Added to allow it to be callable from Amos Pro .lib plugins
***********************************************************
*    Instructions de gestion des ecrans
***********************************************************

