	AddLabl	L_VecRotPos		*** Vec Rot Pos midx,midy,midz
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_VecRotPosZ(a2)
	move.l	(a3)+,d0
	move.w	d0,O_VecRotPosY(a2)
	move.l	(a3)+,d0
	move.w	d0,O_VecRotPosX(a2)
	rts

	AddLabl	L_VecRotAngles		*** Vec Rot Angles angx,angy,angz
	demotst
	dload	a2
	move.l	(a3)+,d0
	and.w	#$3ff,d0
	add.w	d0,d0
	move.w	d0,O_VecRotAngX(a2)
	move.l	(a3)+,d0
	and.w	#$3ff,d0
	add.w	d0,d0
	move.w	d0,O_VecRotAngY(a2)
	move.l	(a3)+,d0
	and.w	#$3ff,d0
	add.w	d0,d0
	move.w	d0,O_VecRotAngZ(a2)
	rts

	AddLabl	L_VecRotPrecalc		*** Vec Rot Precalc
	demotst
	dload	a2
	move.l	O_SineTable(a2),a1
	lea	O_VecCosSines(a2),a0
	move.w	O_VecRotAngX(a2),d0
	move.w	(a1,d0.w),(a0)
        add.w	#$200,d0
	and.w	#$7fe,d0
	move.w	(a1,d0.w),2(a0)
	move.w	O_VecRotAngY(a2),d0
	move.w	(a1,d0.w),4(a0)
	add.w	#$200,d0
	and.w	#$7fe,d0
	move.w	(a1,d0.w),6(a0)
	move.w	O_VecRotAngZ(a2),d0
	move.w	(a1,d0.w),8(a0)
	add.w	#$200,d0
	and.w	#$7fe,d0
	move.w	(a1,d0.w),10(a0)
	lea	O_VecConstants(a2),a1
	move.w	6(a0),d0
	move.w	(a0),d1
	move.w	d1,d2
	muls	d0,d1
	asr.l	#8,d1
	move.w	2(a0),d3
	muls	d3,d0
	asr.l	#8,d0
	move.w	d0,(a1)
;	neg.w	d1
	move.w	d1,2(a1)
	move.w	4(a0),4(a1)
	move.w	8(a0),d4
	move.w	d4,d6
	muls	4(a0),d4
	asr.l	#8,d4
	move.w	d4,d5
	muls	d2,d5
	muls	10(a0),d2
	muls	d3,d4
	muls	10(a0),d3
	add.l	d4,d2
	sub.l	d5,d3
	asr.l	#8,d2
	asr.l	#8,d3
	move.w	d2,6(a1)
	neg.w	d3
	move.w	d3,8(a1)
	muls	6(a0),d6
	asr.l	#8,d6
	neg.w	d6
	move.w	d6,10(a1)
	move.w	10(a0),d0
	move.w	d0,d4
	muls	4(a0),d0
	asr.l	#8,d0
	move.w	d0,d1
	move.w	8(a0),d2
	move.w	d2,d3
	muls	(a0),d0
	muls	2(a0),d1
	muls	(a0),d2
	muls	2(a0),d3
	sub.l	d1,d2
	asr.l	#8,d2
	move.w	d2,12(a1)
	add.l	d0,d3
	asr.l	#8,d3
	neg.w	d3
	move.w	d3,14(a1)
	muls	6(a0),d4
	asr.l	#8,d4
	move.w	d4,16(a1)
	rts

	AddLabl	L_VecRotX3		*** =Vec Rot X(x,y,z)
	demotst
	dload	a2
	Rbsr	L_VecRotDo
	ext.l	d3
	rts

	AddLabl	L_VecRotX		*** =Vec Rot X
	demotst
	dload	a2
	moveq.l	#0,d2
	move.w	O_VecRotResX(a2),d3
	ext.l	d3
	rts

	AddLabl	L_VecRotY3		*** =Vec Rot Y(x,y,z)
	demotst
	dload	a2
	Rbsr	L_VecRotDo
	move.w	d4,d3
	ext.l	d3
	rts

	AddLabl	L_VecRotY		*** =Vec Rot Y
	demotst
	dload	a2
	moveq.l	#0,d2
	move.w	O_VecRotResY(a2),d3
	ext.l	d3
	rts

	AddLabl	L_VecRotZ3		*** =Vec Rot Z(x,y,z)
	demotst
	dload	a2
	Rbsr	L_VecRotDo
	move.w	d5,d3
	ext.l	d3
	rts

	AddLabl	L_VecRotZ		*** =Vec Rot Z
	demotst
	dload	a2
	moveq.l	#0,d2
	move.w	O_VecRotResZ(a2),d3
	ext.l	d3
	rts

