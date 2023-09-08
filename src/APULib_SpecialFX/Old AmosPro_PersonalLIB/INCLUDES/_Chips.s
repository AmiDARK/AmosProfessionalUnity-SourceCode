; REGISTERS.I
;
CIAAPRA		Equ	$BFE001
CIAAPRB		Equ	$BFE101
CIAADDRA	Equ	$BFE201
CIAADDRB	Equ	$BFE301
CIAATALO	Equ	$BFE401
CIAATAHI	Equ	$BFE501
CIAATBLO	Equ	$BFE601
CIAATBHI	Equ	$BFE701
CIAAE.LSB	Equ	$BFE801
CIAAE.8.15	Equ	$BFE901
CIAAE.MSB	Equ	$BFEA01
CIAAUNUSED	Equ	$BFEB01
CIAASP		Equ	$BFEC01
CIAAICR		Equ	$BFED01
CIAACRA		Equ	$BFEE01
CIAACRB		Equ	$BFEF01
CIABPRA		Equ	$BFD000
CIABPRB		Equ	$BFD100
CIABDDRA	Equ	$BFD200
CIABDDRB	Equ	$BFD300
CIABTALO	Equ	$BFD400
CIABTAHI	Equ	$BFD500
CIABTBLO	Equ	$BFD600
CIABTBHI	Equ	$BFD700
CIABE.LSB	Equ	$BFD800
CIABE.8.15	Equ	$BFD900
CIABE.MSB	Equ	$BFDA00
CIABUNUSED	Equ	$BFDB00
CIABSP		Equ	$BFDC00
CIABICR		Equ	$BFDD00
CIABCRA		Equ	$BFDE00
CIABCRB		Equ	$BFDF00
;
BLTDAT		Equ	$DFF000
DMACONR		Equ	$DFF002
VPOSR		Equ	$DFF004
VHPOSR		Equ	$DFF006
DSDATR		Equ	$DFF008
JOY0DAT		Equ	$DFF00A
JOY1DAT		Equ	$DFF00C
CLXDAT		Equ	$DFF00E
ADKCONR		Equ	$DFF010
POT0DAT		Equ	$DFF012
POT1DAT		Equ	$DFF014
POTGOR		Equ	$DFF016
SERDATR		Equ	$DFF018
DSKBYTR		Equ	$DFF01A
INTENAR		Equ	$DFF01C
INTREQR		Equ	$DFF01E
DSKPTH		Equ	$DFF020
DSKPTL		Equ	$DFF022
DSKLEN		Equ	$DFF024
DSKDAT		Equ	$DFF026
REFPTR		Equ	$DFF028
VPOSW		Equ	$DFF02A
VHPOSW		Equ	$DFF02C
COPCON		Equ	$DFF02E
SERDAT		Equ	$DFF030
SERPER		Equ	$DFF032
POTGOT		Equ	$DFF034
JOYTEST		Equ	$DFF036
STREQU		Equ	$DFF038
STRVBL		Equ	$DFF03A
STRHOR		Equ	$DFF03C
STRLONG		Equ	$DFF03E
BLTCON0		Equ	$DFF040
BLTCON1		Equ	$DFF042
BLTAFWM		Equ	$DFF044
BLTALWM		Equ	$DFF046
BLTCPTH		Equ	$DFF048
BLTCPTL		Equ	$DFF04A
BLTBPTH		Equ	$DFF04C
BLTBPTL		Equ	$DFF04E
BLTAPTH		Equ	$DFF050
BLTAPTL		Equ	$DFF052
BLTDPTH		Equ	$DFF054
BLTDPTL		Equ	$DFF056
BLTSIZE		Equ	$DFF058
;		Equ	$DFF05A
;		Equ	$DFF05C
;		Equ	$DFF05E
BLTCMOD		Equ	$DFF060
BLTBMOD		Equ	$DFF062
BLTAMOD		Equ	$DFF064
BLTDMOD		Equ	$DFF066
;		Equ	$DFF068
;		Equ	$DFF06A
;		Equ	$DFF06C
;		Equ	$DFF06E
BLTCDAT		Equ	$DFF070
BLTBDAT		Equ	$DFF072
BLTADAT		Equ	$DFF074
;		Equ	$DFF076
;		Equ	$DFF078
;		Equ	$DFF07A
;		Equ	$DFF07C
DSKSYNC		Equ	$DFF07E
COP1LCH		Equ	$DFF080
COP1LCL		Equ	$DFF082
COP2LCH		Equ	$DFF084
COP2LCL		Equ	$DFF086
COPJMP1		Equ	$DFF088
COPJMP2		Equ	$DFF08A
COPINS		Equ	$DFF08C
DIWSTRT		Equ	$DFF08E
DIWSTOP		Equ	$DFF090
DDFSTRT		Equ	$DFF092
DDFSTOP		Equ	$DFF094
DMACON		Equ	$DFF096
CLXCON		Equ	$DFF098
INTENA		Equ	$DFF09A
INTREQ		Equ	$DFF09C
ADKCON		Equ	$DFF09E
AUD0LCH		Equ	$DFF0A0
AUD0LCL		Equ	$DFF0A2
AUD0LEN		Equ	$DFF0A4
AUD0PER		Equ	$DFF0A6
AUD0VOL		Equ	$DFF0A8
AUDODAT		Equ	$DFF0AA
;		Equ	$DFF0AC
;		Equ	$DFF0AE
AUD1LCH		Equ	$DFF0B0
AUD1LCL		Equ	$DFF0B2
AUD1LEN		Equ	$DFF0B4
AUD1PER		Equ	$DFF0B6
AUD1VOL		Equ	$DFF0B8
AUD1DAT		Equ	$DFF0BA
;		Equ	$DFF0BC
;		Equ	$DFF0BE
AUD2LCH		Equ	$DFF0C0
AUD2LCL		Equ	$DFF0C2
AUD2LEN		Equ	$DFF0C4
AUD2PER		Equ	$DFF0C6
AUD2VOL		Equ	$DFF0C8
AUD2DAT		Equ	$DFF0CA
;		Equ	$DFF0CC
;		Equ	$DFF0CE
AUD3LCH		Equ	$DFF0D0
AUD3LCL		Equ	$DFF0D2
AUD3LEN		Equ	$DFF0D4
AUD3PER		Equ	$DFF0D6
AUD3VOL		Equ	$DFF0D8
AUD3DAT		Equ	$DFF0DA
;		Equ	$DFF0DC
;		Equ	$DFF0DE
BPL1PTH		Equ	$DFF0E0
BPL1PTL		Equ	$DFF0E2
BPL2PTH		Equ	$DFF0E4
BPL2PTL		Equ	$DFF0E6
BPL3PTH		Equ	$DFF0E8
BPL3PTL		Equ	$DFF0EA
BPL4PTH		Equ	$DFF0EC
BPL4PTL		Equ	$DFF0EE
BPL5PTH		Equ	$DFF0F0
BPL5PTL		Equ	$DFF0F2
BPL6PTH		Equ	$DFF0F4
BPL6PTL		Equ	$DFF0F6
BPL7PTH		Equ	$DFF0F8
BPL7PTL		Equ	$DFF0FA
BPL8PTH		Equ	$DFF0FC
BPL8PTL		Equ	$DFF0FE
BPLCON0		Equ	$DFF100
BPLCON1		Equ	$DFF102
BPLCON2		Equ	$DFF104
BPLCON3		Equ	$DFF106
BPL1MOD		Equ	$DFF108
BPL2MOD		Equ	$DFF10A
;		Equ	$DFF10C
;		Equ	$DFF10E
BPL1DAT		Equ	$DFF110
BPL2DAT		Equ	$DFF112
BPL3DAT		Equ	$DFF114
BPL4DAT		Equ	$DFF116
BPL5DAT		Equ	$DFF118
BPL6DAT		Equ	$DFF11A
BPL7DAT		Equ	$DFF11C
BPL8DAT		Equ	$DFF11E
SPR0PTH		Equ	$DFF120
SPR0PTL		Equ	$DFF122
SPR1PTH		Equ	$DFF124
SPR1PTL		Equ	$DFF126
SPR2PTH		Equ	$DFF128
SPR2PTL		Equ	$DFF12A
SPR3PTH		Equ	$DFF12C
SPR3PTL		Equ	$DFF12E
SPR4PTH		Equ	$DFF130
SPR4PTL		Equ	$DFF132
SPR5PTH		Equ	$DFF134
SPR5PTL		Equ	$DFF136
SPR6PTH		Equ	$DFF138
SPR6PTL		Equ	$DFF13A
SPR7PTH		Equ	$DFF13C
SPR7PTL		Equ	$DFF13E
SPR0POS		Equ	$DFF140
SPR0CTL		Equ	$DFF142
SPR0DATAA	Equ	$DFF144
SPR0DATAB	Equ	$DFF146
SPR1POS		Equ	$DFF148
SPR1CTL		Equ	$DFF14A
SPR1DATAA	Equ	$DFF14C
SPR1DATAB	Equ	$DFF14E
SPR2POS		Equ	$DFF150
SPR2CTL		Equ	$DFF152
SPR2DATAA	Equ	$DFF154
SPR2DATAB	Equ	$DFF156
SPR3POS		Equ	$DFF158
SPR3CTL		Equ	$DFF15A
SPR3DATAA	Equ	$DFF15C
SPR3DATAB	Equ	$DFF15E
SPR4POS		Equ	$DFF160
SPR4CTL		Equ	$DFF162
SPR4DATAA	Equ	$DFF164
SPR4DATAB	Equ	$DFF166
SPR5POS		Equ	$DFF168
SPR5CTL		Equ	$DFF16A
SPR5DATAA	Equ	$DFF16C
SPR5DATAB	Equ	$DFF16E
SPR6POS		Equ	$DFF170
SPR6CTL		Equ	$DFF172
SPR6DATAA	Equ	$DFF174
SPR6DATAB	Equ	$DFF176
SPR7POS		Equ	$DFF178
SPR7CTL		Equ	$DFF17A
SPR7DATAA	Equ	$DFF17C
SPR7DATAB	Equ	$DFF17E
COLOR00		Equ	$DFF180
COLOR01		Equ	$DFF182
COLOR02		Equ	$DFF184
COLOR03		Equ	$DFF186
COLOR04		Equ	$DFF188
COLOR05		Equ	$DFF18A
COLOR06		Equ	$DFF18C
COLOR07		Equ	$DFF18E
COLOR08		Equ	$DFF190
COLOR09		Equ	$DFF192
COLOR10		Equ	$DFF194
COLOR11		Equ	$DFF196
COLOR12		Equ	$DFF198
COLOR13		Equ	$DFF19A
COLOR14		Equ	$DFF19C
COLOR15		Equ	$DFF19E
COLOR16		Equ	$DFF1A0
COLOR17		Equ	$DFF1A2
COLOR18		Equ	$DFF1A4
COLOR19		Equ	$DFF1A6
COLOR20		Equ	$DFF1A8
COLOR21		Equ	$DFF1AA
COLOR22		Equ	$DFF1AC
COLOR23		Equ	$DFF1AE
COLOR24		Equ	$DFF1B0
COLOR25		Equ	$DFF1B2
COLOR26		Equ	$DFF1B4
COLOR27		Equ	$DFF1B6
COLOR28		Equ	$DFF1B8
COLOR29		Equ	$DFF1BA
COLOR30		Equ	$DFF1BC
COLOR31		Equ	$DFF1BE
;		Equ	$DFF1C0
;		Equ	$DFF1C2
;		Equ	$DFF1C4
;		Equ	$DFF1C6
;		Equ	$DFF1C8
;		Equ	$DFF1CA
;		Equ	$DFF1CC
;		Equ	$DFF1CE
;		Equ	$DFF1D0
;		Equ	$DFF1D2
;		Equ	$DFF1D4
;		Equ	$DFF1D6
;		Equ	$DFF1D8
;		Equ	$DFF1DA
BEAMCON0	Equ	$DFF1DC
;		Equ	$DFF1DE
;		Equ	$DFF1E0
;		Equ	$DFF1E2
;		Equ	$DFF1E4
;		Equ	$DFF1E6
;		Equ	$DFF1E8
;		Equ	$DFF1EA
;		Equ	$DFF1EC
;		Equ	$DFF1EE
;		Equ	$DFF1F0
;		Equ	$DFF1F2
;		Equ	$DFF1F4
;		Equ	$DFF1F6
;		Equ	$DFF1F8
;		Equ	$DFF1FA
;		Equ	$DFF1FC
NOOP		Equ	$DFF1FE