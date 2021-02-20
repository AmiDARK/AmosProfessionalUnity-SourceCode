; __________________________________
;
;     Definition d''un slider
; __________________________________
;
Sl_FlagVertical    equ     0
        RsReset
; Variables positionnement
Sl_Sx        rs.w    1
Sl_Sy        rs.w    1
Sl_Global    rs.w    1
Sl_Position    rs.w    1
Sl_Window    rs.w    1
Sl_X        rs.w    1
Sl_Y        rs.w    1
Sl_ZDx        rs.w    1
Sl_ZDy        rs.w    1
; Variables fonctionnement
Sl_Flags    rs.w    1
Sl_Start    rs.w    1
Sl_Size        rs.w    1
Sl_Scroll    rs.w    1
Sl_Mouse1    rs.w    1
Sl_Mouse2    rs.w    1
Sl_Zone        rs.w    1
Sl_Routines    rs.l    1
; Encres
Sl_Inactive    rs.w    3+3+2
Sl_Active    rs.w    3+3+2
Sl_Long        equ    __RS
