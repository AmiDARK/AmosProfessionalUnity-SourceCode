	AddLabl	L_XSmouse		*** =X Smouse
	demotst
	dload	a2
	move.w	O_MouseX(a2),d3
	move.w	O_MouseSpeed(a2),d0
	asr.w	d0,d3
	ext.l	d3
	moveq.l	#0,d2
	rts

	AddLabl	L_YSmouse		*** =Y Smouse
	demotst
	dload	a2
	move.w	O_MouseY(a2),d3
	move.w	O_MouseSpeed(a2),d0
	asr.w	d0,d3
	ext.l	d3
	moveq.l	#0,d2
	rts

	AddLabl	L_SetXSmouse		*** X Smouse=x
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	O_MouseSpeed(a2),d1
	asl.w	d1,d0
	move.w	d0,O_MouseX(a2)
	rts

	AddLabl	L_SetYSmouse		*** Y Smouse=y
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	O_MouseSpeed(a2),d1
	asl.w	d1,d0
	move.w	d0,O_MouseY(a2)
	rts

	AddLabl	L_LimitSmouse0		*** Limit Smouse
	demotst
	dload	a2
	move.l	ScOnAd(a5),a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.w	EcWX(a0),d0
	move.w	EcWY(a0),d1
	and.w	#$3FF,d0
	and.w	#$3FF,d1
	move.w	EcTx(a0),d2
	move.w	EcTy(a0),d3
	add.w	d0,d2
	add.w	d1,d3
	subq.w	#1,d2
	subq.w	#1,d3
	move.w	d0,O_MouseLim(a2)
	move.w	d1,O_MouseLim+2(a2)
	move.w	d2,O_MouseLim+4(a2)
	move.w	d3,O_MouseLim+6(a2)
	rts

	AddLabl	L_LimitSmouse4		*** Limit Smouse x1,y1 To x2,y2
	demotst
	dload	a2
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.w	d0,O_MouseLim(a2)
	move.w	d1,O_MouseLim+2(a2)
	move.w	d2,O_MouseLim+4(a2)
	move.w	d3,O_MouseLim+6(a2)
	rts

	AddLabl	L_SmouseSpeed		*** Set Smouse Speed
	demotst
	dload	a2
	move.l	(a3)+,d4
	move.w	O_MouseSpeed(a2),d3
	move.w	O_MouseX(a2),d0
	move.w	O_MouseY(a2),d1
	asr.w	d3,d0
	asr.w	d3,d1
	asl.w	d4,d0
	asl.w	d4,d1
	move.w	d0,O_MouseX(a2)
	move.w	d1,O_MouseY(a2)
	move.w	d4,O_MouseSpeed(a2)
	rts

	AddLabl	L_SmouseKey		*** =Smouse Key
	demotst
	dload	a2
	moveq.l	#0,d3
	lea	$DFF000,a0
	move.w	#$f000,$34(a0)
	btst	#7,$BFE001
	bne.s	.nolmb
	addq.w	#1,d3
.nolmb	btst	#6,$16(a0)
	bne.s	.normb
	addq.w	#2,d3
.normb	btst	#4,$16(a0)
	bne.s	.nommb
	addq.w	#4,d3
.nommb	moveq.l	#0,d2
	rts
