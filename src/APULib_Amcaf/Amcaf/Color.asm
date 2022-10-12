	AddLabl	L_AgaNotationOn		*** Amcaf Aga Notation On
	demotst
	dload	a2
	move.w	#4,O_AgaColor(a2)
	rts

	AddLabl	L_AgaNotationOf		*** Amcaf Aga Notation Off
	demotst
	dload	a2
	move.w	#8,O_AgaColor(a2)
	rts

	AddLabl	L_BestPen1		*** =Best Pen(rgb)
	demotst
	move.l	ScOnAd(a5),a0
	move.w	EcNPlan(a0),d0
	moveq.l	#1,d1
	lsl.w	d0,d1
	subq.l	#1,d1
	clr.l	-(a3)
	move.l	d1,-(a3)
	Rbra	L_BestPen3

	AddLabl	L_BestPen3		*** =Best Pen(rgb,c1 To c2)
	demotst
	move.l	(a3)+,d7
	Rbmi	L_IFonc32
	cmp.w	#63,d7
	Rbhi	L_IFonc32
	move.l	(a3)+,d6
	Rbmi	L_IFonc32
	cmp.w	#63,d6
	Rbhi	L_IFonc32
	sub.l	d6,d7
	Rbmi.s	L_IFonc32
	move.l	ScOnAd(a5),a0
	lea	EcPal-4(a0),a0
	add.l	d6,a0
	add.l	d6,a0
	move.l	(a3)+,d5
	moveq.l	#0,d3
	move.l	#1000,d4
	lea	.coltab(pc),a2
.loop	movem.l	d5-d7,-(sp)
	move.w	(a0)+,d0
	cmp.w	#31,d6
	bls.s	.noehb
	move.w	-66(a0),d0
	and.w	#$EEE,d0
	lsr.w	#1,d0
.noehb	cmp.w	d0,d5
	bne.s	.noequ
	movem.l	(sp)+,d5-d7
	move.l	d6,d3
	moveq.l	#0,d2
	rts	
.noequ	move.w	d0,d1
	move.w	d0,d2
	and.w	#$F00,d0
	move.w	d5,d6
	and.w	#$0F0,d1
	move.w	d5,d7
	and.w	#$00F,d2
	lsr.w	#8,d0
	and.w	#$F00,d5
	lsr.w	#4,d1
	and.w	#$0F0,d6
	lsr.w	#8,d5
	and.w	#$00F,d7
	lsr.w	#4,d6
	sub.w	d0,d5
	bpl.s	.nosgn1
	neg.w	d5
.nosgn1	sub.w	d1,d6
	bpl.s	.nosgn2
	neg.w	d6
.nosgn2	sub.w	d2,d7
	bpl.s	.nosgn3
	neg.w	d7
.nosgn3	moveq.l	#0,d0
	move.b	(a2,d5.w),d0
	move.b	(a2,d6.w),d1
	ext.w	d1
	add.w	d1,d0
	move.b	(a2,d7.w),d1
	ext.w	d1
	add.w	d1,d0
	movem.l	(sp)+,d5-d7
	cmp.w	d0,d4
	blt.s	.nogood
	move.w	d0,d4
	move.w	d6,d3
.nogood	addq.l	#1,d6
	dbra	d7,.loop
	moveq.l	#0,d2
	rts
.coltab	dc.b	0,1,3,5,8,12,16,20,30,40,50,60,70,80,90,100
	

	AddLabl	L_MixColor2		*** =Mix Colour(rgb1,rgb2)
	demotst
	moveq.l	#4,d3
	moveq.l	#$F,d7
	move.l	(a3)+,d2
	move.w	d2,d1
	and.w	d7,d2
	lsr.w	d3,d1
	move.w	d1,d0
	and.w	d7,d1
	lsr.w	d3,d0
	move.l	(a3)+,d6
	move.w	d6,d5
	and.w	d7,d6
	lsr.w	d3,d5
	move.w	d5,d4
	and.w	d7,d5
	lsr.w	d3,d4
	add.b	d0,d4
	add.b	d1,d5
	add.b	d2,d6
	lsr.w	d4
	lsr.w	d5
	lsr.w	d6
	move.w	d6,d3
	lsl.w	#4,d5
	or.w	d5,d3
	lsl.w	#8,d4
	or.w	d4,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_MixColor4		*** =Mix Colour(rgb1,rgb2,lrgb To urgb)
	demotst
	moveq.l	#4,d3
	moveq.l	#$F,d7
	move.l	12(a3),d6
	move.w	d6,d5
	and.w	d7,d6
	lsr.w	d3,d5
	move.w	d5,d4
	and.w	d7,d5
	lsr.w	d3,d4
	move.l	8(a3),d2
	bmi.s	.minus
	move.w	d2,d1
	and.w	d7,d2
	lsr.w	d3,d1
	move.w	d1,d0
	and.w	d7,d1
	lsr.w	d3,d0
	add.w	d0,d4
	add.w	d1,d5
	add.w	d2,d6
	move.l	(a3),d2
	move.w	d2,d1
	and.w	d7,d2
	lsr.w	d3,d1
	move.w	d1,d0
	and.w	d7,d1
	lsr.w	d3,d0
	cmp.w	d0,d4
	blt.s	.lower1
	move.w	d0,d4
.lower1	cmp.w	d1,d5
	blt.s	.lower2
	move.w	d1,d5
.lower2	cmp.w	d2,d6
	blt.s	.lower3
	move.w	d2,d6
.lower3	move.w	d6,d3
	lsl.w	#4,d5
	or.w	d5,d3
	lsl.w	#8,d4
	or.w	d4,d3
	lea	16(a3),a3
	moveq.l	#0,d2
	rts
.minus	neg.l	d2
	move.w	d2,d1
	and.w	d7,d2
	lsr.w	d3,d1
	move.w	d1,d0
	and.w	d7,d1
	lsr.w	d3,d0
	sub.w	d0,d4
	sub.w	d1,d5
	sub.w	d2,d6
	move.l	4(a3),d2
	move.w	d2,d1
	and.w	d7,d2
	lsr.w	d3,d1
	move.w	d1,d0
	and.w	d7,d1
	lsr.w	d3,d0
	cmp.w	d0,d4
	bge.s	.highe1
	move.w	d0,d4
.highe1	cmp.w	d1,d5
	bge.s	.highe2
	move.w	d1,d5
.highe2	cmp.w	d2,d6
	bge.s	.highe3
	move.w	d2,d6
.highe3	move.w	d6,d3
	lsl.w	#4,d5
	or.w	d5,d3
	lsl.w	#8,d4
	or.w	d4,d3
	lea	16(a3),a3
	moveq.l	#0,d2
	rts

	AddLabl	L_GlueColor		*** =Glue Colour(r,g,b)
	demotst
	move.l	(a3)+,d3
	move.l	(a3)+,d4
	move.l	(a3)+,d5
	moveq.l	#15,d0
	and.w	d0,d3
	and.b	d0,d4
	and.w	d0,d5
	lsl.b	#4,d4
	lsl.w	#8,d5
	or.b	d4,d3
	or.w	d5,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_RedValue		*** =Red Val(rgb/rrggbb)
	demotst
	move.l	(a3)+,d3
	moveq.l	#0,d2
	dload	a2
	move.w	O_AgaColor(a2),d0
	cmp.w	#4,d0
	bne.s	.aga
	lsl.l	#8,d3
	move.w	d2,d3
	swap	d3
	rts
.aga	move.w	d2,d3
	swap	d3
	rts

	AddLabl	L_GreenValue		*** =Green Val(rgb/rrggbb)
	demotst
	move.l	(a3)+,d3
	moveq.l	#0,d2
	dload	a2
	move.w	O_AgaColor(a2),d0
	cmp.w	#4,d0
	bne.s	.aga
	lsr.l	#4,d3
	and.l	#%1111,d3
	rts
.aga	lsr.l	#8,d3
	and.l	#$FF,d3
	rts

	AddLabl	L_BlueValue		*** =Blue Val(rgb/rrggbb)
	demotst
	move.l	(a3)+,d3
	moveq.l	#0,d2
	dload	a2
	move.w	O_AgaColor(a2),d0
	cmp.w	#4,d0
	bne.s	.aga
	and.l	#%1111,d3
	rts
.aga	and.l	#$FF,d3
	rts

	AddLabl	L_AgaToOldRGB		*** =Rrggbb To Rgb(rrggbb)
	demotst
	move.l	(a3)+,d3		;RRGGBB
	lsr.l	#4,d3			;0RRGGB
	move.l	d3,d1
	and.l	#$F,d3			;00000B
	lsr.l	#4,d1			;00RRGG
	move.w	d1,d2
	and.w	#$F0,d1			;0000G0
	lsr.w	#4,d2			;000RRG
	and.w	#$F00,d2		;000R00
	or.w	d1,d3			;0000GB
	or.w	d2,d3			;000RGB
	moveq.l	#0,d2
	rts

	AddLabl	L_OldToAgaRGB		*** =Rgb To Rrggbb(rgb)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d1
	and.l	#$FFF,d0
	move.l	d0,d2
	and.w	#$F00,d2
	lsl.l	#4,d2
	lsl.l	#8,d2
	or.l	d2,d1
	move.l	d0,d2
	and.w	#$F0,d2
	lsl.l	#8,d2
	or.l	d2,d1
	move.l	d0,d2
	and.w	#$F,d2
	lsl.l	#4,d2
	or.l	d2,d1
	move.l	d1,d0
	move.l	d0,d3
	moveq.l	#0,d2
	rts
