	AddLabl	L_Init
	cmp.l	#'APex',d1				;Check for AMOS Pro
	bne.s	.error
	move.l	#O_SizeOf,d0				;Get extension memory
	move.l	#$10001,d1				;Cleared memory
	move.l	a6,d5					;Save a6
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d5,a6					;Restore a6
	move.l	d0,ExtAdr+ExtNb*16(a5)			;Move address to a
	beq.s	.error					;available place
	move.l	d0,a2

	lea	ResetToDefault(pc),a0			;Insert 'Default' routine
	move.l	a0,ExtAdr+ExtNb*16+4(a5)
	lea	ExtQuit(pc),a0				;Insert termination
	move.l	a0,ExtAdr+ExtNb*16+8(a5)
	lea	BkCheck(pc),a0				;Insert bank check
	move.l	a0,ExtAdr+ExtNb*16+12(a5)

	bsr	ResetToDefault				;Default once.
	move.w	#$0110,d1				;AMOS Pro version needed
	moveq	#ExtNb,d0				;Extension number
 	rts
.error	sub.l	a0,a0					;Error has occured.
	moveq.l	#-1,d0
	rts

ResetToDefault						;Default Routine.
	movem.l	a3-a6/d6-d7,-(sp)
	dload	a2
;	Rbsr	L_PTStop				;e.g Protracker Stop
	movem.l	(sp)+,a3-a6/d6-d7
	rts

ExtQuit
	movem.l	a3-a6/d6-d7,-(sp)
	bsr	ResetToDefault				;Call the Default Routine
	dload	a2
	move.l	a6,d3
	move.l	4.w,a6
	move.l	a2,a1					;Free Extension memory.
	move.l	#O_SizeOf,d0
	jsr	_LVOFreeMem(a6)
	move.l	d3,a6
	movem.l	(sp)+,a3-a6/d6-d7
	rts

BkCheck	rts						;Bank Changed-check.

	AddLabl						;Empty label.
