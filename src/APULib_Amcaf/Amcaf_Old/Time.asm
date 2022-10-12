	AddLabl	L_CurrentDate		*** =Current Date
	demotst
	dload	a2
	lea	O_DateStamp(a2),a2
	move.l	a2,d1
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVODateStamp(a6)
	move.l	d7,a6
	move.l	(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_CurrentTime		*** =Current Time
	demotst
	dload	a2
	lea	O_DateStamp(a2),a2
	move.l	a2,d1
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVODateStamp(a6)
	move.l	d7,a6
	move.w	6(a2),d3
	swap	d3
	move.w	10(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_CdYear		*** =Cd Year(date)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d3
	moveq.l	#0,d1
	move.w	#1978,d3
	move.w	#365,d1
	move.w	d1,d2
.yrloop	cmp.l	d1,d0
	blt.s	.quit
	addq.w	#1,d3
	sub.l	d1,d0
	move.w	d2,d1
	move.b	d3,d4
	and.b	#%11,d4
	bne.s	.yrloop
	addq.w	#1,d1
	bra.s	.yrloop
.quit	moveq.l	#0,d2
	rts

	AddLabl	L_CdMonth		*** =Cd Month(date)
	demotst
	Rbsr	L_CdYear
	Rbra	L_CdMonth2
	
	AddLabl	L_CdDay			*** =Cd Day(date)
	demotst
	Rbsr	L_CdMonth
	move.l	d0,d3
	addq.b	#1,d3
	rts

	AddLabl	L_CdWeekDay		*** =Cd Weekday(date)
	demotst
	move.l	(a3)+,d3
	addq.l	#6,d3
	moveq.l	#0,d2
	divu	#7,d3
	move.w	d2,d3
	swap	d3
	addq.b	#1,d3
	rts

	AddLabl	L_CtString		*** =Ct String(time$)
	demotst
	Rbsr	L_CheckOS2
	dload	a2
	move.l	(a3)+,a0
	lea	O_TempBuffer(a2),a1
	move.w	(a0)+,d0
	beq.s	.bad
	subq.w	#1,d0
.cploop	move.b	(a0)+,(a1)+
	dbra	d0,.cploop
	clr.b	(a1)
	lea	O_TempBuffer(a2),a0
	lea	O_DateStamp(a2),a1
	clr.w	dat_Format(a1)
	clr.l	dat_StrDay(a1)
	clr.l	dat_StrDate(a1)
	move.l	a0,dat_StrTime(a1)
	move.l	a1,d1
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOStrToDate(a6)
	move.l	(sp)+,a6
	tst.l	d0
	bne.s	.good
.bad	moveq.l	#0,d2
	moveq.l	#-1,d3
	rts
.good	moveq.l	#0,d2
	move.w	O_DateStamp+6(a2),d3
	swap	d3
	move.w	O_DateStamp+10(a2),d3
	rts

	AddLabl	L_CdString		*** =Cd String(date$)
	demotst
	Rbsr	L_CheckOS2
	dload	a2
	move.l	(a3)+,a0
	lea	O_TempBuffer(a2),a1
	move.w	(a0)+,d0
	beq.s	.bad
	subq.w	#1,d0
.cploop	move.b	(a0)+,(a1)+
	dbra	d0,.cploop
	clr.b	(a1)
	lea	O_TempBuffer(a2),a0
	lea	O_DateStamp(a2),a1
	clr.w	dat_Format(a1)
	clr.l	dat_StrDay(a1)
	clr.l	dat_StrTime(a1)
	move.l	a0,dat_StrDate(a1)
	move.l	a1,d1
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOStrToDate(a6)
	move.l	(sp)+,a6
	tst.l	d0
	bne.s	.good
.bad	moveq.l	#0,d2
	moveq.l	#-1,d3
	rts
.good	moveq.l	#0,d2
	move.l	O_DateStamp(a2),d3
	rts

	AddLabl	L_ConvDate		*** =Cd Date$(date)
	demotst
	moveq.l	#16,d3
	Rjsr	L_Demande
	move.l	a0,-(sp)
	move.w	#13,(a0)+
	lea	14(a0),a1
	move.l	a1,hichaine(a5)
	move.l	(a3),d0
	addq.l	#6,d0
	divu	#7,d0
	swap	d0
	lsl.w	#2,d0
	move.l	.weekda(pc,d0.w),(a0)+
	Rbsr	L_CdYear
	move.l	d3,d7
	Rbsr	L_CdMonth2
	move.l	d3,d6
	addq.b	#1,d0
	bsr.s	.insnum
	lsl.w	#2,d6
	move.l	.month-4(pc,d6.w),(a0)+
	move.b	#'-',(a0)+
	move.l	d7,d0
	divu	#100,d0
	swap	d0
	bsr.s	.insnum
	move.l	(sp)+,d3
	moveq.l	#2,d2
	rts
.insnum	move.b	#'0',(a0)
.loop1	cmp.b	#10,d0
	blt.s	.cont
	addq.b	#1,(a0)
	sub.b	#10,d0
	bra.s	.loop1
.cont	addq.l	#1,a0
	move.b	#'0',(a0)
	tst.b	d0
	beq.s	.cont2
.loop2	addq.b	#1,(a0)
	subq.b	#1,d0
	bne.s	.loop2
.cont2	addq.l	#1,a0
	rts
	Rdata
.weekda	dc.b	'Mon Tue Wed Thu Fri Sat Sun '
.month	dc.b	'-Jan-Feb-Mar-Apr-May-Jun-Jul-Aug-Sep-Oct-Nov-Dec'
	even

	AddLabl	L_CtHour		*** =Ct Hour(time)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.w	d2,d0
	swap	d0
	divu	#60,d0
	move.w	d0,d3
	rts

	AddLabl	L_CtMinute		*** =Ct Minute(time)
	demotst
	move.l	(a3)+,d3
	moveq.l	#0,d2
	move.w	d2,d3
	swap	d3
	divu	#60,d3
	move.w	d2,d3
	swap	d3
	rts

	AddLabl	L_CtSecond		*** =Ct Second(time)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d1
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.w	d0,d1
	divu	#50,d1
	move.w	d1,d3
	rts

	AddLabl	L_CtTick		*** =Ct Tick(time)
	demotst
	move.l	(a3)+,d0
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.w	d0,d3
	divu	#50,d3
	move.w	d2,d3
	swap	d3
	rts

	AddLabl	L_ConvTime		*** =Ct Time$(time)
	demotst
	moveq.l	#10,d3
	Rjsr	L_Demande
	move.l	a0,d3
	move.w	#8,(a0)+
	move.l	(a3)+,d6
	move.l	d6,d0
	moveq.l	#0,d2
	move.w	d2,d0
	swap	d0
	divu	#60,d0
	bsr.s	.insnum
	move.b	#':',(a0)+
	swap	d0
	bsr.s	.insnum
	move.b	#':',(a0)+
	moveq.l	#0,d0
	move.w	d6,d0
	divu	#50,d0
	bsr.s	.insnum
	move.l	a0,d0
	move.l	d0,hichaine(a5)
	moveq.l	#2,d2
	rts
.insnum	move.b	#'0',(a0)
.loop1	cmp.b	#10,d0
	blt.s	.cont
	addq.b	#1,(a0)
	sub.b	#10,d0
	bra.s	.loop1
.cont	addq.l	#1,a0
	move.b	#'0',(a0)
	tst.b	d0
	beq.s	.cont2
.loop2	addq.b	#1,(a0)
	subq.b	#1,d0
	bne.s	.loop2
.cont2	addq.l	#1,a0
	rts
