	AddLabl	L_PrecalcTables
	lea	O_Div5Buf(a2),a1
	move.w	#255,d7
	moveq.l	#0,d0
.d5loop	move.b	d0,(a1)+
	move.b	d0,(a1)+
	move.b	d0,(a1)+
	cmp.b	#255,d0
	beq.s	.s255
	addq.w	#1,d0
.s255	move.b	d0,(a1)+
	move.b	d0,(a1)+
	dbra	d7,.d5loop
	lea	O_SineBuf(a2),a1
	move.l	a1,O_SineTable(a2)
	move.w	#254,d1
	lea	.sintab(pc),a0
.lop1	move.w	(a0)+,(a1)+
	dbra	d1,.lop1
	move.w	#256,(a1)+
	addq.l	#2,a0
	move.w	#255,d1
.lop2	move.w	-(a0),(a1)+
	dbra	d1,.lop2
	move.w	#254,d1
.lop3	move.w	(a0)+,(a1)
	neg.w	(a1)+
	dbra	d1,.lop3
	move.w	#-256,(a1)+
	addq.l	#2,a0
	move.w	#255,d1
.lop4	move.w	-(a0),(a1)
	neg.w	(a1)+
	dbra	d1,.lop4
	lea	.tantab(pc),a0
	move.l	a0,O_TanTable(a2)
	movem.l	d0-d7/a0-a6,-(sp)	; Make Zoom Table
	dload	a2
	move.w	#255,d7
	lea	O_Zoom2Buf+256*2(a2),a0
.loop1	moveq.l	#7,d6
	moveq.l	#0,d0
.loop2	lsl.w	#2,d0
	btst	d6,d7
	beq.s	.cnt
	addq.w	#3,d0
.cnt	dbra	d6,.loop2
	move.w	d0,-(a0)
	dbra	d7,.loop1
	move.w	#255,d7
	lea	O_Zoom4Buf+256*4(a2),a0
.loop1b	moveq.l	#7,d6
	moveq.l	#0,d0
.loop2b	asl.l	#4,d0
	btst	d6,d7
	beq.s	.cntb
	add.w	#15,d0
.cntb	dbra	d6,.loop2b
	move.l	d0,-(a0)
	dbra	d7,.loop1b
	move.w	#255,d7
	lea	O_Zoom8Buf+256*4*2(a2),a0
.loop1c	moveq.l	#3,d6
	moveq.l	#7,d5
	moveq.l	#0,d0
.loop2c	asl.l	#8,d0
	btst	d5,d7
	beq.s	.cntc
	st	d0
.cntc	subq.w	#1,d5
	dbra	d6,.loop2c
	moveq.l	#3,d6
	moveq.l	#0,d1
.loop3c	asl.l	#8,d1
	btst	d6,d7
	beq.s	.cntcd
	st	d1
.cntcd	dbra	d6,.loop3c
	move.l	d1,-(a0)
	move.l	d0,-(a0)
	dbra	d7,.loop1c
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	Rdata
.sintab	incbin	"data/sinetablequad.bin"
.tantab	incbin	"data/tantable.bin"
	even
