Version    MACRO
           dc.b "2.00",0
           ENDM
VerNumber  equ $200

; ******** 2021.02.19 Build version added here for the Amos Professional Unity Editor "ABOUT" popup
BuildVersion MACRO
           dc.b "Alpha Rel.1 ",0 ; 11 characters are copied to the ABOUT popup.
           even
           ENDM

