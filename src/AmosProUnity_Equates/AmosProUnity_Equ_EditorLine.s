; ______________________________________________________________________________
;
;        EDITEUR LIGNE
;
        RsReset
LEd_Buffer    rs.l    1
LEd_Start    rs.w    1
LEd_Large    rs.w    1
LEd_Max        rs.w    1
LEd_Long    rs.w    1
LEd_Cur        rs.w    1
LEd_X        rs.w    1
LEd_Y        rs.w    1
LEd_Screen    rs.w    1
LEd_Flags    rs.w    1
LEd_Mask    rs.l    3
LEd_Size    equ    __RS
LEd_FKeys    equ    0
LEd_FOnce    equ    1
LEd_FCursor    equ    2
LEd_FFilter    equ    3
LEd_FMouse    equ    4
LEd_FTests    equ    5
LEd_FMulti    equ    6
LEd_FMouCur    equ    7
