;---------------------------------------------------------------------
;    **   **   **  ***   ***   
;   ****  *** *** ** ** **     
;  **  ** ** * ** ** **  ***   
;  ****** **   ** ** **    **  
;  **  ** **   ** ** ** *  **  
;  **  ** **   **  ***   ***   
;---------------------------------------------------------------------
;  Includes all includes - Francois Lionet / Europress 1992
;---------------------------------------------------------------------

; These ones are for me!
		IFND	Finale
Finale:		equ 	1
		ENDC
		IFND	VDemo
VDemo:		equ 	0
		ENDC
		IFND	ROnly
ROnly:		equ 	0
		ENDC
;
		Incdir  "includes/"
		Include "lvo/exec_lib.i"
		Include "lvo/dos_lib.i"
		Include "lvo/layers_lib.i"
		Include "lvo/graphics_lib.i"
		Include "lvo/mathtrans_lib.i"
		Include "lvo/rexxsyslib_lib.i"
		Include "lvo/mathffp_lib.i"
		Include "lvo/mathieeedoubbas_lib.i"
		Include "lvo/intuition_lib.i"
		Include "lvo/diskfont_lib.i"
		Include "lvo/icon_lib.i"
		Include "lvo/console_lib.i"

		Include	"src/AmosProUnity_Debug.s" ; Just one flag
		Include "src/AmosProUnity_Equ.s"
		RsSet	DataLong
		Include	"src/AmosProUnity_CEqu.s"
		Include	"src/AmosProUnity_Library_Equ.s" 
		Include "src/AmosProUnity_Lib_Equ.s" 

		IFNE	Debug
		Include	"src/APULib_Music/APUMusic_lib_Labels.s"
		ENDC
