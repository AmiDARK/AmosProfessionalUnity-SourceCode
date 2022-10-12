	AddLabl	L_IOError		*** =Io Error
	demotst
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVOIoErr(a6)
	move.l	d7,a6
	move.l	d0,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_IOErrorString		*** =Io Error$(Error)
	demotst
	Rbra	L_IOErrorStringNoToken
