	AddLabl	L_IOoMem		+++ Out of memory
	Rbsr	L_FreeExtMem
	moveq	#24,d0
	Rjmp	L_Error

	AddLabl	L_IFonc			+++ Illegal function call
	Rbsr	L_FreeExtMem
	moveq	#23,d0
	Rjmp	L_Error

	AddLabl	L_IFNoFou		+++ File not found
	Rbsr	L_FreeExtMem
	moveq	#DEBase+2,d0
	Rjmp	L_Error

	AddLabl	L_IIOError		+++ IO error
	Rbsr	L_FreeExtMem
	moveq	#DEBase+15,d0
	Rjmp	L_Error

	AddLabl	L_IPicNoFit		+++ Pic doesn't fit
	Rbsr	L_FreeExtMem
	moveq	#32,d0
	Rjmp	L_Error

	AddLabl	L_IScNoOpen		+++ Screen not open
	Rbsr	L_FreeExtMem
	moveq	#47,d0
	Rjmp	L_Error

	AddLabl	L_INotOS2		+++ This command needs OS 2.04!
	Rbsr	L_FreeExtMem
	moveq	#12,d0
	Rbra	L_Custom

