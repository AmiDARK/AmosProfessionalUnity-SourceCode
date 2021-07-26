; *******************************************************
; *                                                     *
; * Vampire V4 StandAlone Chipset Registers             *
; *                                                     *
; *-----------------------------------------------------*
; *                                                     *
; * Version 2020.11.17                                  *
; * Builded By : Frédéric Cordier (AmiDARK)             *
; * Source : http://www.apollo-core.com/sagadoc/        *
; *                                                     *
; *******************************************************
; Also see : http://www.apollo-core.com/AMMX.doc.txt for special CPU memory copy (Soft Sprites/Bobs)
; Detect Vampire : Exec->AttnFlags & Bit10 means 080 means must be a vampire
; Detect SAGA : DFF3FC register.

_v_cpu_is080:
    movem.l d1-a6,-(sp)
    move.l  $4.w,a6
    move.w  AttnFlags(a6),d0
    and.w   #AFF_68080,d0
    beq.s   .fail
    moveq.l #1,d0
    bra.s   .done
.fail
    moveq.l #0,d0
.done
    movem.l (sp)+,d1-a6
    rts
