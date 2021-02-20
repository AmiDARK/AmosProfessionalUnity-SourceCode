; __________________________________
;
;     Definition d''un bouton
; __________________________________
;
Bt_FlagNew    equ    0
Bt_FlagNoWait    equ    1
Bt_FlagOnOf    equ    2
        RsReset
Bt_Number    rs.w    1
Bt_X        rs.w    1
Bt_Y        rs.w    1
Bt_Image    rs.w    1
Bt_Zone        rs.w    1
Bt_Pos        rs.w    1
Bt_Routines    rs.l    1
Bt_Dx        rs.b    1
Bt_Dy        rs.b    1
Bt_Sx        rs.b    1
Bt_Sy        rs.b    1
Bt_RDraw    rs.b    1
Bt_RChange    rs.b    1
Bt_RPos        rs.b    1
Bt_Flags    rs.b    1
Bt_Long        equ    __RS
