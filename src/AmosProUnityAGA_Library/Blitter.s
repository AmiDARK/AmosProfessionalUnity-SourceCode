;-----> OWN BLITTER
OwnBlit:
    movem.l    d0/d1/a0/a1/a6,-(sp)
    move.l     GfxBase(pc),a6
    jsr        _LVOOwnBlitter(a6)        OwnBlitter
    movem.l    (sp)+,d0/d1/a0/a1/a6

;-----> Wait blitter fini
BlitWait
    move.l     a6,-(sp)
    move.l     GfxBase(pc),a6
    jsr        _LVOWaitBlit(a6)
    move.l     (sp)+,a6
    rts

;-----> DISOWN BLITTER
DOwnBlit
    movem.l    d0/d1/a0/a1/a6,-(sp)
    move.l     GfxBase(pc),a6
    jsr        DisownBlitter(a6)
    movem.l    (sp)+,d0/d1/a0/a1/a6
    rts

