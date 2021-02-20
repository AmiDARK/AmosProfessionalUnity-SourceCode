; _____________________________________________________________________________
; 
;     GESTION DES DIALOGUES
; 

; __________________________________________
;
;    Base de la zone de dialogue
;
        RsReset
Dia_Channel    rs.l    1
Dia_NVar    rs.l    1
Dia_Sp        rs.l    1
Dia_Screen    rs.l    1
Dia_ScreenNb    rs.w    1
Dia_ScreenOld    rs.w    1
Dia_WindOld    rs.w    1
Dia_WindOn    rs.w    1
Dia_Programs    rs.l    1
Dia_ProgLong    rs.l    1
Dia_Labels    rs.l    1
Dia_Messages    rs.l    1
Dia_ABuffer    rs.l    1
Dia_PBuffer    rs.l    1
Dia_Buffer    rs.l    1
Dia_Pile    rs.l    1
Dia_PUsers    rs.l    1
Dia_NPUsers    rs.w    1
Dia_Users    rs.w    1
Dia_Edited    rs.l    1
Dia_Timer    rs.l    1
Dia_TimerPos    rs.l    1
Dia_LastZone    rs.l    1
Dia_NextZone    rs.l    1
Dia_Release    rs.l    1
Dia_BaseX    rs.l    1
Dia_BaseY    rs.l    1
Dia_Sx        rs.l    1
Dia_Sy        rs.l    1
Dia_XA        rs.w    1
Dia_YA        rs.w    1
Dia_XB        rs.w    1
Dia_YB        rs.w    1
Dia_Puzzle    rs.l    1
Dia_PuzzleSx    rs.l    1
Dia_PuzzleSy    rs.l    1
Dia_PuzzleI    rs.l    1
Dia_LastKey    rs.l    1
Dia_Error    rs.w    1
Dia_ErrorPos    rs.w    1
Dia_Return    rs.w    1
Dia_Exit    rs.w    1
Dia_Writing    rs.w    1
Dia_RFlags    rs.b    1
Dia_Flags    rs.b    1
Dia_SlDefault    rs.b    16
        rs.l    4
Dia_Vars    equ    __RS
Dia_Source    equ    Dia_LastKey
Dia_FSource    equ    Dia_Edited
