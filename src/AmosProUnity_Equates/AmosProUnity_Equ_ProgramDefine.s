; _____________________________________________________________________________
;
;                     Définition d''un programme
; _____________________________________________________________________________
;

        RsReset

Prg_Next    rs.l    1        0 Prochain dans la liste

Prg_NLigne:    rs.w     1        2 Nombre de lignes

Prg_StMini    rs.l    1        6 Buffer de stockage
Prg_StTTexte    rs.l     1        10
Prg_StHaut    rs.l     1        14
Prg_StBas    rs.l     1        18
Prg_Banks    rs.l    1
Prg_Dialogs    rs.l    1
Prg_StModif    rs.b     1        Listing modifie
Prg_Change    rs.b    1        Sauver le programme
Prg_Edited    rs.b    1        Une fenetre?
Prg_NoNamed    rs.b    1        Numero de la structure
Prg_Not1.3    rs.b    1        Compatible 1.3?
Prg_Reloaded    rs.b    1        Program modified?
Prg_MathFlags    rs.b    1        Flags mathematiques
        rs.b    1

Prg_Previous    rs.l    1        Programme precedent
Prg_RunData    rs.l    1        Donnée si PRUN
Prg_ZapData    rs.l    1
Prg_AdEProc    rs.l     1        Procedure d''erreur
Prg_XEProc    rs.w     1

Prg_Undo    rs.l    1        Buffer undo
Prg_PUndo    rs.l    1        Position dans buffer
Prg_LUndo    rs.l    1        Longueur du buffer actuel
Prg_TUndo    rs.l    1        Longueur totale buffer
Prg_Marks    rs.l     10        

Prg_NamePrg    rs.b    128        Nom du programme
Prg_Long    equ    __RS
        
