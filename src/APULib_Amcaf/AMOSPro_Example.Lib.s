* Extension Header V1.0.
* Written by Chris Hodges.
* Last changes: Sun 28-Aug-94 09:58:47

	opt	c-,o+,w-

version	MACRO						;Version macro
	dc.b	"1.0 28-Aug-94"
	ENDM

debugvs	equ	0					;Set to 0 to remove
							;all debugging codes
							;To 1 to enable single
							;debugging macros
							;Or 2 to debug every
							;Function.

ExtNb	equ	16-1					;Extension number 16
NumLabl	equ	5					;Number of Labels

English	equ	$FACE					;Any symbol can be used
							;but FACE is nicer :)
Deutsch	equ	$AFFE					;Same for this

Languag	equ	Deutsch					;Choose the language

	IncDir	"dh1:Assembler"				;Set the includes
							;path.
	Include	"AMOS/|AMOSPro_Includes.s"

	output	dh1:APSystem/AMOSPro_Example.Lib

debug	MACRO						;This is to debug
	IFEQ	debugvs-1				;if the switch is set to 1
	illegal
	ENDC
	ENDM
dload	MACRO						;Load the address
	move.l	ExtAdr+ExtNb*16(a5),\1			;of the data-space
	ENDM
L_Func	set	0
AddLabl	MACRO						;Macro for adding
	IFEQ	NARG-1					;functions
\1	equ	L_Func					;One or non argument
	ENDC
L\<L_Func>:
L_Func	set	L_Func+1
	IFEQ	debugvs-2				;If debug is 2 then
	illegal						;fill in a illegal.
	ENDC
	ENDM

LC	set	0
LS	MACRO						;Macro for the label-
LC0	set	LC					;length part.
LC	set	LC+1
	dc.w	(L\<LC>-L\<LC0>)/2
	ENDM

Start	dc.l	C_Tk-C_Off	;First, a pointer to the token list
	dc.l	C_Lib-C_Tk	;Then, a pointer to the first library function
	dc.l	C_Title-C_Lib	;Then to the title
	dc.l	C_End-C_Title	;From title to the end of the program

	dc.w	0		;A value of -1 forces the copy of the first library routine...

		rsreset					;Extension Main Datazone
O_TempBuffer	rs.b	80
O_FileInfo	rs.b	260
O_SizeOf	rs.l	0

C_Off							;Automatic labellength
							;generation.
	REPT	NumLabl
	LS
	ENDR

C_Tk	dc.w 	1,0
	dc.b 	$80,-1

; Commands & Functions
; Nop						Implemented

; Now the real tokens...

	dc.w	-1,L_Nop
	dc.b	"no","p"+$80,"I",-1

	dc.w 	0

C_Lib	include	"ExampleInitRou.lnk"			;Initroutines

	AddLabl	L_Nop					;Example command
	rts

;	include	"Turbo.lnk"				;Other extension commands

;	include	"NonTokenFuncs.lnk"			;All functions, that
							;Dont have tokens should
							;be placed here, when
							;the extensions grows
							;over 32 KB.
	include	"ExampleError.lnk"			;Error routines.

	AddLabl	L_TheEnd				;Last label.

	IFNE	(L_TheEnd-NumLabl)			;Checks, if labels
;	PRINTT	"Incorrect amount of Labels: "		;are missing.
;	PRINTT	"Expected:"
;	PRINTT	_NumLabl
;	PRINTT	"Real:"
;	PRINTT	_L_TheEnd
	FAIL
	ENDC

C_Title	dc.b	"AMOSPro Example extension V "
	version
	dc.b	0,"$VER: V"
	version
	dc.b	0
	even
C_End	;dc.w	0
