	AddLabl	L_AudioLock		*** Audio Lock
	demotst
	dload	a2
	tst.w	O_AudioOpen(a2)
	beq.s	.cont
	rts
.cont	move.l	a6,d6
	move.l	4.w,a6
	lea	O_AudioPort(a2),a1
	tst.w	O_AudioPortOpen(a2)
	bne.s	.skip
	lea	.portna(pc),a0
	move.l	a0,10(a1)
	move.w	#$0400,8(a1)
	clr.w	14(a1)
	sub.l	a1,a1
	jsr	_LVOFindTask(a6)
	lea	O_AudioPort(a2),a1
	move.l	d0,16(a1)
	jsr	_LVOAddPort(a6)
.skip	lea	O_AudioIO(a2),a0
	move.b	#127,9(a0)		;Priority
	move.l	a1,14(a0)
	lea	O_ChanMap(a2),a1
	move.b	#$0F,(a1)
	move.l	a1,$22(a0)
	move.b	#64,$1e(a0)
	moveq.l	#1,d7
	move.l	d7,$26(a0)
	move.l	a0,a1
	lea	.audion(pc),a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	jsr	_LVOOpenDevice(a6)
	move.l	d6,a6
	tst.l	d0
	beq.s	.cont2
	moveq.l	#3,d0
	Rbra	L_Custom32
.cont2	st	O_AudioOpen(a2)
	rts
.portna	dc.b	'AMOSPro Soundport',0
	even
.audion	dc.b	'audio.device',0
	even

	AddLabl	L_AudioFree		*** Audio Free
	dload	a2
	move.l	a6,d7
	tst.w	O_AudioOpen(a2)
	bne.s	.cont
	tst.w	O_AudioPortOpen(a2)
	bne.s	.cont2
	rts
.cont	lea	O_AudioIO(a2),a1
	move.w	#9,$1c(a1)
	move.l	4.w,a6
	jsr	_LVODoIO(a6)
	jsr	_LVOCloseDevice(a6)
.cont2	lea	O_AudioPort(a2),a1
	jsr	_LVORemPort(a6)
	clr.w	O_AudioOpen(a2)
	move.l	d7,a6
	rts
