	AddLabl	L_MaskCopy3		*** Mask Copy s1 To s2,mk
	demotst
	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	Ec_RastPort(a0),d6
	moveq.l	#0,d4
	moveq.l	#0,d5
;	move.w	EcTx(a0),d4
;	move.w	EcTy(a0),d5
	move.l	(a3)+,d1
	Rjsr	L_GetEc
;	cmp.w	EcTx(a0),d4
;	Rbhi	L_IPicNoFit
;	cmp.w	EcTy(a0),d5
;	Rbhi	L_IPicNoFit
	move.w	EcTx(a0),d4
	move.w	EcTy(a0),d5
	move.l	Ec_BitMap(a0),a0
	move.l	d6,a1
	moveq.l	#0,d0
	moveq.l	#0,d1
	moveq.l	#0,d2
	moveq.l	#0,d3
	moveq.l	#0,d6
	move.b	#$e0,d6
	move.l	d7,a2
	move.l	a6,-(sp)
	move.l	T_GfxBase(a5),a6
	jsr	_LVOBltMaskBitMapRastPort(a6)
	move.l	(sp)+,a6
	rts

	AddLabl	L_MaskCopy9		*** Mask Copy s1,x1,y1,x2,y2 To s2,x3,y3,mk
	demotst
	moveq.l	#0,d0
	move.b	#$e0,d0
	move.l	d0,-(a3)
	Rbra	L_MaskCopy10

	AddLabl	L_MaskCopy10		*** Mask Copy s1,x1,y1,x2,y2 To s2,x3,y3,mk,mt
	demotst
	move.l	(a3)+,d6
	move.l	(a3)+,a2
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	Ec_RastPort(a0),a1
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	sub.l	d0,d4
	sub.l	d1,d5
	movem.l	d0-d2/a1/a2,-(sp)
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	movem.l	(sp)+,d0-d2/a1/a2
	move.l	Ec_BitMap(a0),a0
	move.l	a6,-(sp)
	move.l	T_GfxBase(a5),a6
	jsr	_LVOBltMaskBitMapRastPort(a6)
	move.l	(sp)+,a6
	rts
