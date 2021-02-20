; _____________________________________________________________________________
;
;                     Définition d''une edition
; _____________________________________________________________________________
;

        RsReset
Edt_Next    rs.l    1        Edition suivante
Edt_Prg        rs.l    1        Adresse structure programme
Edt_BufE    rs.l    1        Adresse buffer edition

; Données affichage
Edt_Order    rs.w    1        Numero d''ordre dans l''affichage
Edt_Window    rs.w    1        Numero des diverse zones / fenetres
Edt_WindEtat    rs.w    1
Edt_Zones    rs.w    1
Edt_ZEtat    rs.w    1
Edt_ZBas    rs.w    1

Edt_X        rs.w    1        Coordonnees de la fenetre
Edt_Y        rs.w    1
Edt_Sy        rs.w    1
Edt_WindX    rs.w    1
Edt_WindY    rs.w    1
Edt_WindSx    rs.w    1
Edt_WindSy    rs.w    1
Edt_WindTx    rs.w    1
Edt_WindTy    rs.w    1
Edt_WindOldTy    rs.w    1
Edt_WindEX    rs.w    1
Edt_WindEY    rs.w    1
Edt_WindESx    rs.w    1
Edt_BasY    rs.w    1
Edt_EtMess    rs.w     1        
Edt_EtAlert    rs.l     1        

Edt_SInit    equ    __RS        Zone à remettre à zero
Edt_SReload    equ    __RS
Edt_SSplit    equ    __RS
Edt_XPos    rs.w     1        Positions texte dans fenetre
Edt_YPos    rs.w     1
Edt_XCu        rs.w     1        Positions curseur
Edt_YCu        rs.w     1
Edt_DebProc    rs.l     1
Edt_CurLigne    rs.l     1        Recherche
Edt_LEdited    rs.w    1        Flag ligne editee
Edt_EInit    equ    __RS
Edt_EReload    equ    __RS
Edt_ESplit    equ    __RS

Edt_XBloc    rs.w    1        Position bloc
Edt_YBloc    rs.w    1
Edt_YOldBloc    rs.w    1

Edt_LinkPrev    rs.l    1        Links de fenetre
Edt_LinkNext    rs.l    1
Edt_LinkScroll    rs.l    1
Edt_LinkYOld    rs.w    1

Edt_Hidden    rs.b    1        Fenetre cachee
Edt_LinkFlag    rs.b    1        Fenetre linkee
Edt_First    rs.b    1        Premiere fenetre affichee?
Edt_Last    rs.b    1        Derniere fenetre affichee?
Edt_EtatAff    rs.b    1        Flags ligne d''etat
Edt_PrgDelete    rs.b    1        Programme à effacer en retour
Edt_ASlY    rs.b    1        Compteur affichage slider
        rs.b    1

Edt_SlV        rs.b    Sl_Long        Structure slider
Edt_Bt1        rs.b    Bt_Long        Structures bouton
Edt_Bt2        rs.b    Bt_Long
Edt_Bt3        rs.b    Bt_Long
        rs.w    1
Edt_Long    equ    __RS        Longueur de la structure
