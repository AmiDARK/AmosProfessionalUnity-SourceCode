	AddLabl	L_LeadZeroStr		*** =Lzstr(number,digits)
	demotst
	move.l	(a3)+,d3
	Rbeq	L_IFonc
	cmp.w	#10,d3
	Rbhi	L_IFonc

	move.l	(a3)+,d7
	move.w	d3,d4
	addq.w	#3,d3
	and.w	#$FFFE,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3
	move.w	d4,(a0)+

	moveq.l	#2,d2
	lea	.endtab-4(pc),a1
	subq.w	#1,d4
	moveq.l	#0,d5
	move.w	d4,d5
	lsl.w	#2,d5
	sub.l	d5,a1
	move.l	d7,d0
	bpl.s	.notneg
	move.b	#'-',(a0)+
	subq.w	#1,d4
	bpl.s	.conta
	rts				;one-digit neg number
.conta	move.l	(a1)+,d1
	neg.l	d0
.loop	cmp.l	d1,d0
	bge.s	.overfl
.notneg	move.b	#'0',(a0)
	move.l	(a1)+,d1
	bra.s	.entry
.cmloop	cmp.b	#'9',(a0)
	beq.s	.overfl
	addq.b	#1,(a0)
	sub.l	d1,d0
.entry	cmp.l	d1,d0
	bge.s	.cmloop
.skip	addq.l	#1,a0
.skip0	dbra	d4,.notneg
	rts
.overfl	move.b	#'9',(a0)+
	dbra	d4,.overfl
	rts
	Rdata
.digtab	dc.l	1000000000
	dc.l	100000000
	dc.l	10000000
	dc.l	1000000
	dc.l	100000
	dc.l	10000
	dc.l	1000
	dc.l	100
	dc.l	10
	dc.l	1
.endtab

	AddLabl	L_LeadSpaceStr		*** =Lsstr(number,digits)
	demotst
	move.l	(a3)+,d3
	Rbeq	L_IFonc
	cmp.w	#10,d3
	Rbhi	L_IFonc

	move.l	(a3)+,d7

	move.w	d3,d4
	addq.w	#3,d3
	and.w	#$FFFE,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3
	move.w	d4,(a0)+

	move.l	d7,d0
	lea	.endtab-4(pc),a1
	subq.w	#1,d4
	moveq.l	#0,d5
	move.w	d4,d5
	lsl.w	#2,d5
	sub.l	d5,a1
	moveq.l	#0,d2
	moveq.l	#0,d6
	moveq.l	#0,d7
	tst.l	d0
	bpl.s	.notneg
	neg.l	d0
	moveq.l	#1,d6
	cmp.l	(a1),d0
	bge.s	.overf2
.notneg	move.b	#'0',(a0)
	move.l	(a1)+,d1
	cmp.l	d1,d0
	bge.s	.cmloop
	tst.w	d2
	bne.s	.nextd
	tst.w	d4
	beq.s	.nextd
	move.b	#' ',(a0)
	bra.s	.nextd
.cmloop	tst.w	d6
	beq.s	.skip
	move.l	#0,d6
	tst.w	d7
	beq.s	.skip
	move.b	#'-',-1(a0)
.skip	cmp.b	#'9',(a0)
	beq.s	.overfl
	addq.b	#1,(a0)
	sub.l	d1,d0
	cmp.l	d1,d0
	bge.s	.cmloop
	st	d2
.nextd	addq.w	#1,d7
	addq.l	#1,a0
	dbra	d4,.notneg
	moveq.l	#2,d2
	rts
.overf2	move.b	#'-',(a0)+
	subq.w	#1,d4
	bmi.s	.quit
.overfl	move.b	#'9',(a0)+
	dbra	d4,.overfl
.quit	moveq.l	#2,d2
	rts
	Rdata
.digtab	dc.l	1000000000
	dc.l	100000000
	dc.l	10000000
	dc.l	1000000
	dc.l	100000
	dc.l	10000
	dc.l	1000
	dc.l	100
	dc.l	10
	dc.l	1
.endtab

	AddLabl	L_ChrWord		*** =Chr.w$(word)
	demotst
	moveq.l	#4,d3
	Rjsr	L_Demande
	move.l	a0,d3
	move.w	#2,(a0)+
	move.l	(a3)+,d0
	move.w	d0,(a0)+
	move.l	a0,HiChaine(a5)
	moveq.l	#2,d2
	rts

	AddLabl	L_ChrLong		*** =Chr.l$(longword)
	demotst
	moveq.l	#6,d3
	Rjsr	L_Demande
	move.l	a0,d3
	move.w	#4,(a0)+
	move.l	(a3)+,(a0)+
	move.l	a0,HiChaine(a5)
	moveq.l	#2,d2
	rts

	AddLabl	L_AscWord		*** =Asc.w(word$)
	demotst
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	cmp.w	#2,d0
	Rblt	L_IFonc
	moveq.l	#0,d3
	move.w	(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_AscLong		*** =Asc.l(longword$)
	demotst
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	cmp.w	#4,d0
	Rblt	L_IFonc
	move.l	(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_Vclip			*** =Vclip(val,lower To upper)
	demotst
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	(a3)+,d3
	moveq.l	#0,d2
	cmp.l	d1,d3
	ble.s	.noup
	move.l	d1,d3
.noup	cmp.l	d3,d0
	ble.s	.nodown
	move.l	d0,d3
.nodown	rts

	AddLabl	L_Vin			*** =Vin(val,lower To upper)
	demotst
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	(a3)+,d4
	moveq.l	#0,d2
	moveq.l	#-1,d3
	cmp.l	d1,d4
	ble.s	.noup
	moveq.l	#0,d3
	rts
.noup	cmp.l	d4,d0
	ble.s	.nodown
	moveq.l	#0,d3
.nodown	rts

	AddLabl	L_Vmod2			*** =Vmod(val,upper)
	demotst
	moveq.l	#0,d2
	move.l	(a3)+,d5
	Rbmi	L_IFonc
	Rbeq	L_IFonc
	move.l	(a3)+,d3
	bmi.s	.neg
	addq.l	#1,d5
	divu	d5,d3
	clr.w	d3
	swap	d3
	rts
.neg	neg.l	d3
	addq.l	#1,d5
	divu	d5,d3
	clr.w	d3
	swap	d3
	neg.l	d3
	add.l	d5,d3
	rts

	AddLabl	L_Vmod3			*** =Vmod(val,lower To upper)
	demotst
	moveq.l	#0,d2
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	sub.l	d4,d5
	Rbmi	L_IFonc
	Rbeq	L_IFonc
	move.l	(a3)+,d3
	sub.l	d4,d3
	bmi.s	.neg
	addq.l	#1,d5
	divs	d5,d3
	clr.w	d3
	swap	d3
	add.l	d4,d3
	rts
.neg	neg.l	d3
	addq.l	#1,d5
	divu	d5,d3
	clr.w	d3
	swap	d3
	neg.l	d3
	add.l	d5,d3
	add.l	d4,d3
	rts

	AddLabl	L_Insstr		*** =Insstr$(a$,b$,pos)
	demotst
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	move.l	(a3)+,a2
	move.l	(a3)+,a1
	move.w	(a1)+,d5
	cmp.w	d5,d7
	Rbhi	L_IFonc
	move.w	(a2)+,d6
	bne.s	.cont1
	subq.l	#2,a1
	move.l	a1,d3
	moveq.l	#2,d2
	rts
.cont1	move.w	d5,d3
	add.w	d6,d3

	and.w	#$FFFE,d3
	addq.w	#2,d3
	movem.l	a1/a2,-(sp)
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	movem.l	(sp)+,a1/a2
	move.l	a0,d3

	move.w	d5,(a0)
	add.w	d6,(a0)+
	moveq.l	#0,d4
.loop1	cmp.w	d7,d4
	beq.s	.loop2
	subq.w	#1,d5
	move.b	(a1)+,(a0)+
	addq.w	#1,d4
	bra.s	.loop1
.loop2	tst.w	d6
	beq.s	.loop3
	subq.w	#1,d6
	move.b	(a2)+,(a0)+
	bra.s	.loop2
.loop3	tst.w	d5
	beq.s	.quit
	subq.w	#1,d5
	move.b	(a1)+,(a0)+
	bra.s	.loop3
.quit	moveq.l	#2,d2
	rts

	AddLabl	L_CutStr		*** =Cutstr(a$,pos1 To pos2)
	demotst
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	move.l	(a3)+,d6
	Rbmi	L_IFonc
	Rbeq	L_IFonc
	move.l	d7,d5
	sub.l	d6,d5
	Rbmi	L_IFonc
	move.l	(a3)+,a2
	move.w	(a2)+,d4
	cmp.w	d6,d4
	Rbmi	L_IFonc
	cmp.w	d7,d4
	Rbmi	L_IFonc
	move.w	d4,d3
	sub.w	d5,d3

	and.w	#$FFFE,d3
	addq.w	#2,d3
	movem.l	a1/a2,-(sp)
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	movem.l	(sp)+,a1/a2
	move.l	a0,d3

	move.w	d4,(a0)
	sub.w	d5,(a0)+
	moveq.l	#1,d1
.loop1	cmp.w	d1,d6
	beq.s	.loop2
	subq.w	#1,d4
	move.b	(a2)+,(a0)+
	addq.w	#1,d1
	bra.s	.loop1
.loop2	lea	1(a2,d5.w),a2
	sub.w	d5,d4
.loop3	tst.w	d4
	beq.s	.quit
	subq.w	#1,d4
	move.b	(a2)+,(a0)+
	bra.s	.loop3
.quit	moveq.l	#2,d2
	rts

	AddLabl	L_Replacestr		*** =Replacestr$(a$,b$ To c$)
	demotst
	move.l	8(a3),a2
	move.l	4(a3),a1
	move.w	(a2)+,d5
	move.w	d5,d2
	bne.s	.nempty
.empty	lea	12(a3),a3
	move.l	-4(a3),d3
	moveq.l	#2,d2
	rts
.nempty	move.w	(a1)+,d6
	Rbeq	L_IFonc
	move.l	a1,d4
	moveq.l	#0,d7
.sealop	move.l	d4,a1
	tst.w	d5
	beq.s	.qsearc
	cmp.b	(a2)+,(a1)+
	bne.s	.cont1
	move.w	-3(a1),d6
	movem.l	a2/d5,-(sp)
.flop	subq.w	#1,d5
	subq.w	#1,d6
	tst.w	d6
	beq.s	.fouone
	tst.w	d5
	beq.s	.nofou
	cmp.b	(a2)+,(a1)+
	bne.s	.nofou
	bra.s	.flop
.fouone	addq.l	#1,d7
	addq.l	#8,sp
	bra.s	.sealop
.nofou	movem.l	(sp)+,a2/d5
.cont1	subq.w	#1,d5
	bra.s	.sealop
.qsearc	tst.l	d7
	beq.s	.empty
	move.l	(a3),a0
	move.l	4(a3),a1
	move.w	(a0),d3
	move.w	(a1),d6
	sub.w	d6,d3
	ext.l	d3
	muls	d7,d3
	add.w	d2,d3
	move.w	d3,d7

	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.w	d7,(a0)+
	movem.l	a4-a6,-(sp)
	move.l	(a3)+,a6
	move.l	(a3)+,d4
	move.l	(a3)+,a2
	addq.l	#2,d4
	move.w	(a2)+,d5

.replop	move.l	d4,a1
	tst.w	d5
	beq.s	.qreplc
	cmp.b	(a2)+,(a1)+
	bne.s	.cont2
	move.w	-3(a1),d6
	movem.l	a2/d5,-(sp)
.flop2	subq.w	#1,d5
	subq.w	#1,d6
	tst.w	d6
	beq.s	.fouon2
	tst.w	d5
	beq.s	.nofou2
	cmp.b	(a2)+,(a1)+
	bne.s	.nofou2
	bra.s	.flop2
.fouon2	addq.l	#8,sp
	move.l	a6,a4
	move.w	(a4)+,d0
	beq.s	.replop
	subq.w	#1,d0
.cpylop	move.b	(a4)+,(a0)+
	dbra	d0,.cpylop
	bra.s	.replop
.nofou2	movem.l	(sp)+,a2/d5
.cont2	move.b	-1(a2),(a0)+
	subq.w	#1,d5
	bra.s	.replop
.qreplc	movem.l	(sp)+,a4-a6
	moveq.l	#2,d2
	rts

	AddLabl	L_Itemstr2		*** =Itemstr$(a$,itemnum)
	demotst
	lea	.mdefsp(pc),a0
	move.l	a0,-(a3)
	Rbra	L_Itemstr3
.mdefsp	dc.w	1
	dc.b	'|'
	even

	AddLabl	L_Itemstr3		*** =Itemstr$(a$,itemnum,sep$)
	demotst
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	cmp.w	#1,d0
	Rbne	L_IFonc
	move.b	(a0),d7
	move.l	(a3)+,d6
	Rbmi	L_IFonc
	move.l	(a3)+,a0
	move.w	(a0)+,d5
	Rbeq	L_IFonc
.chklop	tst.w	d6
	beq.s	.found
	cmp.b	(a0)+,d7
	beq.s	.cont1
	subq.w	#1,d5
	Rbeq	L_IFonc
	bra.s	.chklop
.cont1	subq.w	#1,d6
	beq.s	.found
	subq.w	#1,d5
	Rbeq	L_IFonc
	bra.s	.chklop
.found	moveq.l	#0,d4
	move.l	a0,d6
	move.l	a0,a2
.chelop	subq.w	#1,d5
	beq.s	.endit
	cmp.b	(a2)+,d7
	beq.s	.endit
	addq.w	#1,d4
	bra.s	.chelop
.endit	moveq.l	#0,d3
	move.w	d4,d3

	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.w	d4,(a0)+
	move.l	d6,a2
	tst.w	d4
	beq.s	.end
	subq.w	#1,d4
.cpylop	move.b	(a2)+,(a0)+
	dbra	d4,.cpylop
.end	move.l	a0,d0
	addq.l	#1,d0
	and.b	#$FE,d0
	move.l	d0,HiChaine(a5)
	moveq.l	#2,d2
	rts

	AddLabl	L_Odd			*** =Odd(number)
	demotst
	move.l	(a3)+,d3
	moveq.l	#0,d2
	moveq.l	#1,d0
	and.l	d0,d3
	neg.l	d3
	rts

	AddLabl	L_Even			*** =Even(number)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d2
	moveq.l	#0,d3
	btst	#0,d0
	bne.s	.odd
	moveq.l	#-1,d3
.odd	rts

	AddLabl	L_PowerOfTwo		*** =Secexp(number)
	demotst
	moveq.l	#1,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.skip
	Rbmi	L_IFonc
	moveq.l	#32,d1
	cmp.l	d1,d0
	Rbge	L_IFonc
	lsl.l	d0,d3
.skip	rts
	
	AddLabl	L_RootOfTwo		*** =Seclog(number)
	demotst
	move.l	(a3)+,d0
	Rbeq	L_IFonc
	moveq.l	#0,d3
	moveq.l	#0,d2
	btst	d2,d0
	bne.s	.end
.loop	lsr.l	d0
	addq.l	#1,d3
	btst	d2,d0
	beq.s	.loop
.end	lsr.l	d0
	tst.l	d0
	Rbne	L_IFonc
	rts

	AddLabl	L_Lsl			*** =Lsl(number,bits)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d2
	move.l	(a3)+,d3
	asl.l	d0,d3
	rts

	AddLabl	L_Lsr			*** =Lsr(number,bits)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d2
	move.l	(a3)+,d3
	asr.l	d0,d3
	rts

	AddLabl	L_MCSwap		*** =Wordswap(number)
	demotst
	move.l	(a3)+,d3
	swap	d3
	moveq.l	#0,d2
	rts

	AddLabl	L_SgnDeek		*** =Sdeek(address)
	demotst
	move.l	(a3)+,a0
	move.l	a0,d0
	move.w	(a0),d3
	ext.l	d3
	moveq.l	#0,d2
	rts

	AddLabl	L_SgnPeek		*** =Speek(address)
	demotst
	move.l	(a3)+,a0
	move.l	a0,d0
	move.b	(a0),d3
	ext.w	d3
	ext.l	d3
	moveq.l	#0,d2
	rts

