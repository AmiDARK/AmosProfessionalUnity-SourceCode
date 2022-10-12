	AddLabl	L_BankPermanent		*** Bank Permanent bank
	demotst
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr		;bank???
	move.w	-12(a0),d0
	bset	#0,d0
	move.w	d0,-12(a0)
	rts

	AddLabl	L_BankTemporary		*** Bank Temporary bank
	demotst
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr		;bank???
	move.w	-12(a0),d0
	bclr	#0,d0
	move.w	d0,-12(a0)
	rts

	AddLabl	L_BankChip		*** Bank To Chip bank
	demotst
	move.l	(a3)+,d0
	move.l	d0,d7
	Rjsr	L_Bnk.OrAdr		;bank???
	move.w	-12(a0),d0
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom32
.noicon	move.w	-12(a0),d1		;Flags
	btst	#1,d1
	beq.s	.nochip
	rts
.nochip	bset	#1,d1
	move.l	-20(a0),d2		;Length
	subq.l	#8,d2
	subq.l	#8,d2
	moveq.l	#-1,d0			;Number
	move.w	#0,d0
	swap	d0
	move.l	a0,d6
	subq.l	#8,a0			;Name
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	a0,d5
	move.l	d6,a1
	move.l	-20(a1),d0
	move.l	d0,d6
	lsr.l	d0
	subq.l	#8,d0
	subq.l	#1,d0
	move.l	d0,d1
	swap	d1
.loop	move.w	(a1)+,(a0)+
	dbra	d0,.loop
	dbra	d1,.loop
	btst	#0,d6
	beq.s	.even
	move.b	(a1)+,(a0)+
.even	move.l	d7,d0
	Rjsr	L_Bnk.Eff
	move.l	d5,a0
	move.l	d7,-16(a0)
	rts

	AddLabl	L_BankFast		*** Bank To Fast bank
	demotst
	move.l	(a3)+,d0
	move.l	d0,d7
	Rjsr	L_Bnk.OrAdr		;bank???
	move.w	-12(a0),d0
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom32
.noicon	move.w	-12(a0),d1		;Flags
	btst	#1,d1
	bne.s	.nofast
	rts
.nofast	bclr	#1,d1
	move.l	-20(a0),d2		;Length
	subq.l	#8,d2
	subq.l	#8,d2
	moveq.l	#-1,d0			;Number
	move.w	#0,d0
	swap	d0
	move.l	a0,d6
	subq.l	#8,a0			;Name
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	a0,d5
	move.l	d6,a1
	move.l	-20(a1),d0
	move.l	d0,d6
	lsr.l	d0
	subq.l	#8,d0
	subq.l	#1,d0
	move.l	d0,d1
	swap	d1
.loop	move.w	(a1)+,(a0)+
	dbra	d0,.loop
	dbra	d1,.loop
	btst	#0,d6
	beq.s	.even
	move.b	(a1)+,(a0)+
.even	move.l	d7,d0
	Rjsr	L_Bnk.Eff
	move.l	d5,a0
	move.l	d7,-16(a0)
	rts

	AddLabl	L_DeltaEncode2		*** Bank Delta Encode start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#2,d7
	move.l	d7,d6
	swap	d6
	move.b	(a0)+,d0
	move.b	(a0),d1
	sub.b	d0,(a0)+
	move.b	d1,d0
.loop	move.b	(a0),d1
	sub.b	d0,(a0)+
	move.b	d1,d0
	move.b	(a0),d1
	sub.b	d0,(a0)+
	move.b	d1,d0
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_DeltaEncode1		*** Bank Delta Encode bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_DeltaEncode2

	AddLabl	L_DeltaDecode2		*** Bank Delta Decode start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#2,d7
	move.l	d7,d6
	swap	d6
	move.b	(a0)+,d0
	add.b	(a0),d0
	move.b	d0,(a0)+
.loop	add.b	(a0),d0
	move.b	d0,(a0)+
	add.b	(a0),d0
	move.b	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_DeltaDecode1		*** Bank Delta Decode bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_DeltaDecode2

	AddLabl	L_BankCodeXor2		*** Bank Code Xor.b code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	eor.b	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeXor1		*** Bank Code Xor.b code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeXor2

	AddLabl	L_BankCodeAdd2		*** Bank Code Add.b code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	add.b	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeAdd1		*** Bank Code Add.b code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeAdd2

	AddLabl	L_BankCodeMix2		*** Bank Code Mix.b code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
	move.l	d0,d1
	eor.b	#$AA,d1
.loop	add.b	d1,d0
	eor.b	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeMix1		*** Bank Code Mix.b code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeMix2

	AddLabl	L_BankCodeRol2		*** Bank Code Rol.b code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	move.b	(a0),d1
	rol.b	d0,d1
	move.b	d1,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeRol1		*** Bank Code Rol.b code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeRol2

	AddLabl	L_BankCodeRor2		*** Bank Code Ror.b code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	move.b	(a0),d1
	ror.b	d0,d1
	move.b	d1,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeRor1		*** Bank Code Ror.b code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeRor2

	AddLabl	L_BankCodeXorw2		*** Bank Code Xor.w code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	eor.w	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeXorw1		*** Bank Code Xor.w code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeXorw2

	AddLabl	L_BankCodeAddw2		*** Bank Code Add.w code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	add.w	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeAddw1		*** Bank Code Add.w code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeAddw2

	AddLabl	L_BankCodeMixw2		*** Bank Code Mix.w code,start To end
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
	move.l	d0,d1
	eor.w	#$FACE,d1
.loop	add.w	d1,d0
	eor.w	d0,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeMixw1		*** Bank Code Mix.w code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeMixw2

	AddLabl	L_BankCodeRolw2		*** Bank Code Rol.w code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	move.w	(a0),d1
	rol.w	d0,d1
	move.w	d1,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeRolw1		*** Bank Code Rol.w code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeRolw2

	AddLabl	L_BankCodeRorw2		*** Bank Code Ror.w code,start To end
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	move.l	(a3)+,d0
.loop	move.w	(a0),d1
	ror.w	d0,d1
	move.w	d1,(a0)+
	dbra	d7,.loop
	dbra	d6,.loop
	rts

	AddLabl	L_BankCodeRorw1		*** Bank Code Ror.w code,bank
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCodeRorw2

	AddLabl	L_BankStretch		*** Bank Stretch bank To length
	demotst
	move.l	(a3)+,d6
	move.l	(a3)+,d0
	move.l	d0,-(sp)
	Rjsr	L_Bnk.OrAdr		;bank???
	move.w	-12(a0),d0
	move.w	d0,d1
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom32
.noicon	move.l	-20(a0),d4		;Length
	subq.l	#8,d4
	subq.l	#8,d4
	move.l	d6,d2
	moveq.l	#-1,d0			;Number
	move.w	#0,d0
	swap	d0
	move.l	a0,d7
	subq.l	#8,a0			;Name
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	d4,d0
	cmp.l	d6,d4
	bls.s	.stretc
	move.l	d6,d0
.stretc	move.l	a0,d5
	move.l	d7,a1
	lsr.l	d0
	subq.l	#1,d0
	move.l	d0,d1
	swap	d1
.loop	move.w	(a1)+,(a0)+
	dbra	d0,.loop
	dbra	d1,.loop
	btst	#0,d4
	beq.s	.even
	move.b	(a1)+,(a0)+
.even	move.l	(sp),d0
	Rjsr	L_Bnk.Eff
	move.l	d5,a0
	move.l	(sp)+,-16(a0)
	rts

	AddLabl	L_BankCheckSum2		*** =Bank Checksum(bank To end)
	demotst
	move.l	(a3)+,d7		;End
	move.l	(a3)+,a0
	sub.l	a0,d7
	lsr.l	#2,d7
	subq.l	#1,d7
	move.l	d7,d6
	swap	d6
	moveq.l	#0,d3
.loop	add.l	(a0)+,d3
	dbra	d7,.loop
	dbra	d6,.loop
	eor.l	#$FACEFACE,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_BankCheckSum1		*** =Bank Checksum(bank)
	demotst
	Rbsr	L_GetBankLength
	Rbra	L_BankCheckSum2
	
	AddLabl	L_BankCopy2		*** Bank Copy bank,end To bank
	demotst
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d0
	move.l	d0,a0
	move.w	-12(a0),d1
	and.w	#%1111111111110000,d1
	tst.w	d1
	bne.s	.nobank
	move.l	-16(a0),d1
	cmp.l	d1,d7
	Rbeq	L_IFonc32
	move.w	-12(a0),d1
	move.l	d6,d2
	move.l	a0,d6
	subq.l	#8,a0			;Name
	bra.s	.bank
.nobank	moveq.w	#0,d1
	move.l	d6,d2
	move.l	a0,d6
	lea	.bkwork(pc),a0		;Name
.bank	sub.l	d6,d2
	move.l	d2,d5
	move.l	d7,d0			;Number
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	d6,a1
	move.l	d5,d0
	lsr.l	d0
	subq.l	#1,d0
	move.l	d0,d1
	swap	d1
.loop	move.w	(a1)+,(a0)+
	dbra	d0,.loop
	dbra	d1,.loop
	btst	#0,d5
	beq.s	.even
	move.b	(a1)+,(a0)+
.even	rts
.bkwork	dc.b	'Work    '
	even

	AddLabl	L_BankCopy1		*** Bank Copy bank To bank
	demotst
	move.l	(a3)+,d7
	Rbsr	L_GetBankLength
	move.l	d7,-(a3)
	Rbra	L_BankCopy2

	AddLabl	L_BankNameC		*** Bank Name bank,name$
	demotst
	move.l	(a3)+,a2
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	#'    ',d0
	move.l	d0,-8(a0)
	move.l	d0,-4(a0)
	move.w	(a2)+,d0
	beq.s	.zero
	cmp.w	#8,d0
	bls.s	.normal
	moveq.w	#8,d0
.normal	subq.w	#1,d0
	subq.l	#8,a0
.loop	move.b	(a2)+,(a0)+
	dbra	d0,.loop
.zero	rts

	AddLabl	L_BankNameF		*** =Bank Name$(bank)
	demotst
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	a0,a2
	subq.l	#8,a2
	moveq.l	#10,d3
	Rjsr	L_Demande
	move.l	a0,d3
	move.w	#8,(a0)+
	move.l	(a2)+,(a0)+
	move.l	(a2),(a0)+
	move.l	a0,HiChaine(a5)
	moveq.l	#2,d2
	rts
