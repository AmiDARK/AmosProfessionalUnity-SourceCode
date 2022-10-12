	AddLabl	L_ConvertGrey		*** Convert Grey s1 To s2
	demotst
	IFEQ	demover
	Rbra	L_ConvertGreyNoToken
	ELSE
	addq.l	#8,a3
	rts
	ENDC