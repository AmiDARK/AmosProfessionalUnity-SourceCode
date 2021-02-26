; ___________________________________
;
;     BITMAP PACKER/UNPACKER
; ___________________________________

; *********************************************************************
; Amos Professional Unity : Packed screen header
        RsReset
PsCode      rs.l 1
PsTx        rs.w 1
PsTy        rs.w 1
PsAWx       rs.w 1
PsAWy       rs.w 1
PsAWTx      rs.w 1
PsAWTy      rs.w 1
PsAVx       rs.w 1
PsAVy       rs.w 1
PsCon0      rs.w 1
OldPsNbCol  rs.w 1                        ; Not Used on Aga but keep for PsNpPlan compatibility
PsNPlan     rs.w 1
; Next are different between ECS/OCS and AGA
AgaPsAGAP      rs.l 1                     ; 2020.09.10 Added PsAGAP
AgaPsNbCol     rs.w 1                     ; 2020.09.10 Moved PsNbCol after PsAGAP to not duplicate register
AgaPsPal       rs.w 32                    ; 2019.11.22 Updated SPacked palette from 32 to 256
AgaPsPalAga    rs.w 224
AgaPsPalSepar1 rs.w 1                     ; 2020.09.09 Separator for palette copy
AgaPsPalL      rs.w 32                    ; 2020.09.09 Updated SPacked palette from 32 to 256 Low Bits
AgaPsPalAgaL   rs.w 224
AgaPsPalSepar2 rs.w 1                     ; 2020.09.09 Separator for palette copy
AgaPsLong      equ __RS
AgaSCCode      equ $08081975

; Original Amos Professional 2.0 : Packed screen header
        RsReset
_PsCode        rs.l 1
_PsTx          rs.w 1
_PsTy          rs.w 1
_PsAWx         rs.w 1
_PsAWy         rs.w 1
_PsAWTx        rs.w 1
_PsAWTy        rs.w 1
_PsAVx         rs.w 1
_PsAVy         rs.w 1
_PsCon0        rs.w 1
; Next are different between ECS/OCS and AGA
EcsPsNbCol     rs.w 1
_PsNPlan     rs.w 1
EcsPsPal       rs.w 32
EcsPsLong      equ __RS
EcsSCCode      equ $12031990

; *********************************************************************
; Amos Professional Unity : Packed bitmap header
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

; Original Amos Professional 2.0 : Packed bitmap header
; ~~~~~~~~~~~~~~~~~~~~
;        RsReset
;Pkcode       rs.l 1
;Pkdx         rs.w 1
;Pkdy         rs.w 1
;Pktx         rs.w 1
;Pkty         rs.w 1
;Pktcar       rs.w 1
;Pknplan    rs.w 1
;PkDatas2     rs.l 1
;PkPoint2     rs.l 1
;PkLong      equ __RS
;PkDatas1    equ __RS
;BMCode        equ $06071963
