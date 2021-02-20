; Entete d''une zone active
; ~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
Dia_Ln        rs.w    1        0 Long
Dia_Id        rs.w    1        2 Id
Dia_ZoId    rs.w    1        4 ZoId
Dia_ZoX        rs.w    1        6 ZoX
Dia_ZoY        rs.w    1        8 ZoY
Dia_ZoSx    rs.w    1        10 ZoSx
Dia_ZoSy    rs.w    1        12 ZoSy
Dia_ZoNumber    rs.w    1        14 ZoNumber
Dia_ZoRChange    rs.w    1        16 Routine change
Dia_ZoPos    rs.l    1        18 Position
Dia_ZoVar    rs.l    1        22 Variable interne
Dia_ZoFlags    rs.b    1        26
        rs.b    1
Dia_ZoLong    equ    __RS

; Entete d''un bouton dialogue
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
        rs.b    Dia_ZoLong    Entete zone active
Dia_BtRDraw    rs.w    1
Dia_BtRChange    rs.w    1
Dia_BtMin    rs.w    1
Dia_BtMax    rs.w    1
Dia_BtLong    equ    __RS

; Entete d''une ligne d''edition
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
        rs.b    Dia_ZoLong    Entete zone active
Dia_LEd        rs.b    LEd_Size
Dia_EdLong    equ    __RS
Dia_DiValue    rs.l    1
Dia_DiBuffer    rs.b    16
Dia_DiLong    equ    __RS

; Entete d''une liste active
; ~~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
        rs.b    Dia_ZoLong    Entete zone active
Dia_LiTx    rs.w    1
Dia_LiTy    rs.w    1
Dia_LiPos    rs.w    1
Dia_LiMaxAct    rs.w    1
Dia_LiArray    rs.l    1
Dia_LiLArray    rs.w    1
Dia_LiActNumber    rs.w    1
Dia_LiLong    equ    __RS

; Entete d''un texte actif
; ~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
        rs.b    Dia_ZoLong    Entete zone active
Dia_TxTx    rs.w    1
Dia_TxTy    rs.w    1
Dia_TxPos    rs.w    1
Dia_TxNLine    rs.w    1
Dia_TxText    rs.l    1
Dia_TxDisplay    rs.l    1
Dia_TxDispSize    rs.w    1
Dia_TxDispMax    rs.w    1
Dia_TxAdress    rs.l    1
Dia_TxAct    rs.l    1
Dia_TxYAct    rs.w    1
Dia_TxPen    rs.b    1
Dia_TxPaper    rs.b    1
Dia_TxPp    rs.b    8
Dia_TxBuffer    rs.b    64
Dia_TxBufferEnd    equ    __RS
Dia_TxLong    equ    __RS
; Definition des zones actives
Dia_TxDispZone    equ    8

; Entete d''un slider
; ~~~~~~~~~~~~~~~~~~
        RsReset
        rs.b    Dia_ZoLong    Entete zone active
Dia_Sl        rs.b    Sl_Long        Données gestion slider
Dia_SlLong    equ    __RS

; Entete d''une definition de touche
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
        rs.w    2
Dia_KyCode    rs.b    1
Dia_KyShift    rs.b    1
Dia_KyZone    rs.l    1
Dia_KyLong    equ    __RS

; Entete d''une sauvegarde de block
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
        rs.w    2
Dia_BlNumber    rs.w    1
Dia_BlLong    equ    __RS
; Marques de reconnaissance
; ~~~~~~~~~~~~~~~~~~~~~~~~~
Dia_BtMark    equ    "Bt"
Dia_StMark    equ    "St"
Dia_EdMark    equ    "Ed"
Dia_KyMark    equ    "Ky"
Dia_BlMark    equ    "Bl"
Dia_ZoMark    equ    "Zo"
Dia_SlMark    equ    "Sl"
Dia_LiMark    equ    "Li"
Dia_TxMark    equ    "Tx"
Dia_TaMark    equ    "Ta"
Dia_TdMark    equ    "Td"

; Numero des messages d''erreur
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EDia_Syntax    equ    1
EDia_OMem    equ    2
EDia_LabAD    equ    3
EDia_LabND    equ    4
EDia_ChanAD    equ    5
EDia_ChanND    equ    6
EDia_Screen    equ    7
EDia_VarND    equ    8
EDia_FCall    equ    9
EDia_Type    equ    10
EDia_OBuffer    equ    11
EDia_NPar    equ    12
