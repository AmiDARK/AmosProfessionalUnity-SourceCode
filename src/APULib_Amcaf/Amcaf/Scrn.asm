	AddLabl	L_ScreenRastport	*** =Scrn Rastport
	demotst
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_RastPort(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_ScreenBitmap		*** =Scrn Bitmap
	demotst
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_BitMap(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_ScreenLayerInfo	*** =Scrn Layerinfo
	demotst
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_LayerInfo(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_ScreenLayer		*** =Scrn Layer
	demotst
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_Layer(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_ScreenRegion		*** =Scrn Region
	demotst
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_Region(a0),d3
	moveq.l	#0,d2
	rts

	IFEQ	1
	AddLabl	L_ScrnOpen		*** Screen Open s,w,h,c,mode
	debug
	move.l	(a3)+,d6		;mode
	move.l	(a3)+,d5		;c
	move.l	(a3)+,d3		;h: right
	move.l	(a3)+,d2		;w: right
	move.l	(a3)+,d4		;s: right
	EcCall	Cree
	rts
	ENDC
