
;-----> Position du faisceau
PosVbl:
    move.l     $004(a6),d0
    lsr.l      #8,d0
    and.w      #$1FF,d0
    rts
