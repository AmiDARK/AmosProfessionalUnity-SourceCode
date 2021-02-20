***********************************************************
*        EQUATES BOBS
        RsReset
BbPrev:        rs.l 1          ; Previous bob in the chain list
BbNext:        rs.l 1          ; Next bob in the chain-list
BbNb:          rs.w 1          ; Amount of Bobs or Bob number ?
BbAct:         rs.w 1          ; Bob is Active ( -1 = Inactive, 1 = Active )
BbX:           rs.w 1          ; Bob X Position in BbEc screen
BbY:           rs.w 1          ; Bob Y Position in BbEc Screen
BbI:           rs.w 1          ; Bob Image used for render
BbEc:          rs.l 1          ; Screen in which the bob will be drawn
BbAAEc:        rs.l 1          ; 2019.12.21 No need to change, already in .l = Bitplane shift to draw image in.
BbAData:       rs.l 1
BbAMask:       rs.l 1
BbNPlan:       rs.w 1
BbAPlan:       rs.w 1
BbASize:       rs.w 1
BbAMaskG:      rs.w 1
BbAMaskD:      rs.w 1
BbTPlan:       rs.l 1          ; 2019.12.06 Update Taille Plan to handle .l instead of .w
BbTLigne:      rs.w 1
BbAModO:       rs.w 1
BbAModD:       rs.w 1
BbACon:        rs.w 1
BbACon0:       rs.w 1
BbACon1:       rs.w 1
BbADraw:       rs.l 1
BbLimG:        rs.w 1
BbLimD:        rs.w 1          ; Bob right limit = BbEc Screen Width
BbLimH:        rs.w 1          ; Bob bottom limit = BbEc Screen Height
BbLimB:        rs.w 1
* Datas retournement des bobs
BbARetour      rs.l 1
BbRetour       rs.w 1
* Datas decor
BbDecor:       rs.w 1
BbEff:         rs.w 1
BbDCur1:       rs.w 1
BbDCur2:       rs.w 1
BbDCpt:        rs.w 1
BbEMod:        rs.w 1
BbECpt:        rs.w 1
BbEAEc:        rs.w 1
BbESize:       rs.w 1
BbETPlan:      rs.l 1          ; 2019.12.06 Update from .w to .l
* Datas pour une sauvegarde de decor
BbDABuf:       rs.l 1          ; * 0  Adresse buffer
BbDLBuf:       rs.w 1          ; * 4  Longueur buffer
BbDAEc:        rs.w 1          ; * 6  Decalage ecran
BbDAPlan:      rs.l 1          ; * 8  Plans sauves
BbDNPlan:      rs.l 1          ; * 12 Max plans
BbDMod:        rs.w 1          ; * 16 Modulo ecran
BbDASize:      rs.w 1          ; * 18 Taille blitter
Decor:         equ 20          ; * 20 Taille totale
* Datas pour seconde sauvegarde!
               rs.l Decor
BbLong:        equ __RS
