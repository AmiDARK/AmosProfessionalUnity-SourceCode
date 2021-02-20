; ___________________________________
;
;     BITMAP PACKER/UNPACKER
; ___________________________________

; Packed screen header
        RsReset
PsCode         rs.l 1
PsTx           rs.w 1
PsTy           rs.w 1
PsAWx          rs.w 1
PsAWy          rs.w 1
PsAWTx         rs.w 1
PsAWTy         rs.w 1
PsAVx          rs.w 1
PsAVy          rs.w 1
PsCon0         rs.w 1
PsNPlan        rs.w 1
PsAGAP         rs.l 1                     ; 2020.09.10 Added PsAGAP
PsNbCol        rs.w 1                     ; 2020.09.10 Moved PsNbCol after PsAGAP to not duplicate register
PsPal          rs.w 32                    ; 2019.11.22 Updated SPacked palette from 32 to 256
PsPalAga       rs.w 224
PsPalSepar1    rs.w 1                     ; 2020.09.09 Separator for palette copy
PsPalL         rs.w 32                    ; 2020.09.09 Updated SPacked palette from 32 to 256 Low Bits
PsPalAgaL      rs.w 224
PsPalSepar2    rs.w 1                     ; 2020.09.09 Separator for palette copy
PsLong         equ __RS
SCCode         equ $12031990

; Packed bitmap header
; ~~~~~~~~~~~~~~~~~~~~
        RsReset
Pkcode         rs.l 1
Pkdx           rs.w 1
Pkdy           rs.w 1
Pktx           rs.w 1
Pkty           rs.w 1
Pktcar         rs.w 1
Pknplan        rs.w 1
PkDatas2       rs.l 1
PkPoint2       rs.l 1
PkLong         equ __RS
PkDatas1       equ __RS
BMCode         equ $06071963
