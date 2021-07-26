; *******************************************************
; *                                                     *
; * Vampire V4 StandAlone Chipset Registers             *
; *                                                     *
; *-----------------------------------------------------*
; *                                                     *
; * Version 2020.11.17                                  *
; * Builded By : Frédéric Cordier (AmiDARK)             *
; * Source : http://www.apollo-core.com/sagadoc/        *
; *                                                     *
; *******************************************************
; Also see : http://www.apollo-core.com/AMMX.doc.txt for special CPU memory copy (Soft Sprites/Bobs)
; Detect Vampire : Exec->AttnFlags & Bit10 means 080 means must be a vampire
; Detect SAGA : DFF3FC register.
;
    ; Chipset Base to add to chipset registers for direct writes
    ChipsetBase    equ     $dff000     ; This value must be added to chipset registers values for direct registers write

    ; This value must be added to the register values when long writes must be done inside a copperlist
    longWrite      equ     $000800     ; Used to long copper list instructions (instead of default word ones)

    ;
    BPLHMOD        equ     $0001e6     ; Chunky plane modulo
    SPRHPTH        equ     $0001e8     ; (Not documented) UHRes Sprite pointer (high 5 bits)
    SPRHPTL        equ     $0001ea     ; (Not documented) UHRes Sprite pointer (low 16 bits)
    BPLHPTH        equ     $0001ec     ; Chunky Bitplane Pointer (hi 15 bits)
    BPLHPTL        equ     $0001ee     ; Chunky Bitplane Pointer (low 16 bits)
    GFXMODE        equ     $0001f4     ; Set Resolution and Pixel format
    FMODE          equ     $0001fc     ; Fetch mode register
    ;
    DMACON2Read    equ     $000202
    INTENA2Read    equ     $00021c
    INTREQ2Read    equ     $00021e
    joy0buttons    equ     $000220     ; Joystick 0 connection/buttons (Undated)
    joy1buttons    equ     $000222     ; Joystick 1 connection/buttons (Undated)
    joy2buttons    equ     $000222     ; Joystick 2 connection/buttons (Undated)
    joy3buttons    equ     $000222     ; Joystick 3 connection/buttons (Undated)
    ;
    clxdat0        equ     $000230     ; Sprite 0 Detailled collision
    clxdat1        equ     $000232     ; Sprite 1 Detailled collision
    clxdat2        equ     $000234     ; Sprite 2 Detailled collision
    clxdat3        equ     $000236     ; Sprite 3 Detailled collision
    clxdat4        equ     $000238     ; Sprite 4 Detailled collision
    clxdat5        equ     $00023a     ; Sprite 5 Detailled collision
    clxdat6        equ     $00023c     ; Sprite 6 Detailled collision
    clxdat7        equ     $00023e     ; Sprite 7 Detailled collision
    ;
    DMACON2        equ     $000296
    INTENA2        equ     $00029a
    INTREQ2        equ     $00029c
    ;
    PlanarCOLH     equ     $000380     ; 32bit Planar COLOR Port register
    PlanarCOLL     equ     $000382     ;       256 Color Register, Format [ID,RR,GG,BB]
    SpriteCOLH     equ     $000384     ; 32bit Sprite COLOR Port register
    SpriteCOLL     equ     $000386     ;       256 Color Register, Format [ID,RR,GG,BB]
    ChunkyCOLH     equ     $000388     ; 32bit Chunky COLOR Port register
    ChunkyCOLL     equ     $00038a     ;       256 Color Register, Format [ID,RR,GG,BB]
    PIPCOLH        equ     $00038c     ; 32bit PIP COLOR Port register
    PIPCOLL        equ     $00038e     ;       256 Color Register, Format [ID,RR,GG,BB]
    ;
    PinXStrt       equ     $0003d0    ; (Not documented)
    PinYStrt       equ     $0003d2    ; (Not documented)
    PinXStop       equ     $0003d4    ; (Not documented)
    PinYStop       equ     $0003d6    ; (Not documented)
    PipPtr         equ     $0003d8    ; (Not documented) 32 bit Pointer
    PipFormat      equ     $0003dc    ; (Not documented) Color Format (8bit/16bit/15bit/YUV)
    PipModulo      equ     $0003de    ; (Not documented) PipModulo
    PipColorKey    equ     $0003e0    ; (Not documented) ColorKey 1000,RRRR,GGGG,BBBB
    PipDMARowLen   equ     $0003e2    ; (Not documented) PipDMARowLen
    VAMPIREVERSION equ     $0003fc    ; 8bit Card Version / 8bit clock Multiplier
    ;
    Aud0PtrH       equ     $000400
    Aud0PtrL       equ     $000402
    Aud0LenH       equ     $000404
    Aud0LenL       equ     $000406
    Aud0Vol        equ     $000408
    Aud0Crtl       equ     $00040a
    Aud0Per        equ     $00040c
    Aud1PTrH       equ     $000410
    Aud1PtrL       equ     $000412
    Aud1LenH       equ     $000414
    Aud1LenL       equ     $000416
    Aud1Vol        equ     $000418
    Aud1Crtl       equ     $00041a
    Aud1Per        equ     $00041c
    Aud2PtrH       equ     $000400
    Aud2PtrL       equ     $000402
    Aud2LenH       equ     $000404
    Aud2LenL       equ     $000406
    Aud2Vol        equ     $000408
    Aud2Crtl       equ     $00040a
    Aud2Per        equ     $00040c
    Aud3PTrH       equ     $000410
    Aud3PtrL       equ     $000412
    Aud3LenH       equ     $000414
    Aud3LenL       equ     $000416
    Aud3Vol        equ     $000418
    Aud3Crtl       equ     $00041a
    Aud3Per        equ     $00041c
    Aud4PtrH       equ     $000400
    Aud4PtrL       equ     $000402
    Aud4LenH       equ     $000404
    Aud4LenL       equ     $000406
    Aud4Vol        equ     $000408
    Aud4Crtl       equ     $00040a
    Aud4Per        equ     $00040c
    Aud5PTrH       equ     $000410
    Aud5PtrL       equ     $000412
    Aud5LenH       equ     $000414
    Aud5LenL       equ     $000416
    Aud5Vol        equ     $000418
    Aud5Crtl       equ     $00041a
    Aud5Per        equ     $00041c
    Aud6PtrH       equ     $000400
    Aud6PtrL       equ     $000402
    Aud6LenH       equ     $000404
    Aud6LenL       equ     $000406
    Aud6Vol        equ     $000408
    Aud6Crtl       equ     $00040a
    Aud6Per        equ     $00040c
    Aud7PTrH       equ     $000410
    Aud7PtrL       equ     $000412
    Aud7LenH       equ     $000414
    Aud7LenL       equ     $000416
    Aud7Vol        equ     $000418
    Aud7Crtl       equ     $00041a
    Aud7Per        equ     $00041c

; **************************************************************************************************
; Videos modes from : http://wiki.apollo-accelerators.com/doku.php/saga:registers:saga_video_mode

; A valid SAGA Video Mode value ( GFXMODE(=$DFF1F4) ) is an addition of :
;     -> Low byte: SAGA_VIDEO_FORMAT
;     -> High byte: SAGA_VIDEO_DBLSCAN

; Low byte: SAGA_VIDEO_FORMAT
; This enumeration is used to describe the PixelFormat of the Video.
;-----------------------------------------------------------------------------
;   Name                       Value    ; Bytes per Pixel ; Description
;-----------------------------------------------------------------------------
    SAGA_VIDEO_FORMAT_OFF      equ 0    ;        -        ;  Chunky DMA Off
    SAGA_VIDEO_FORMAT_CLUT8    equ 1    ;        1        ;  CLUT8
    SAGA_VIDEO_FORMAT_RGB16    equ 2    ;        2        ;  R5|G6|B5
    SAGA_VIDEO_FORMAT_RGB15    equ 3    ;        2        ;  -|R5|G5|B5
    SAGA_VIDEO_FORMAT_RGB24    equ 4    ;        3        ;  R8|G8|B8
    SAGA_VIDEO_FORMAT_RGB32    equ 5    ;        4        ;  -|R8|G8|B8
    SAGA_VIDEO_FORMAT_YUV422   equ 6    ;        2        ;  Y4|U2|V2
;-----------------------------------------------------------------------------

; High byte: SAGA_VIDEO_DBLSCAN
; This enumeration is used to describe the DoubleScan flag of the Video.
;-----------------------------------------------------------------------------
;   Name                       Value    ; Description
;-----------------------------------------------------------------------------
    SAGA_VIDEO_DBLSCAN_OFF     equ 0    ; Normal Display
    SAGA_VIDEO_DBLSCAN_X       equ 1    ; Double output each X-Pixel (X-DoubleScan)
    SAGA_VIDEO_DBLSCAN_Y       equ 2    ; Double output each Row (Y-DoubleScan)
    SAGA_VIDEO_DBLSCAN_XY      equ 3    ; DOuble output (XY-DoubleScan)
;-----------------------------------------------------------------------------

; *********************************************************************************************
; 
; BPLHMOD
; 
;          This is the number (sign extended) that is added to the UHRES bitplane
;          pointer (BPLHPTL,H) every line, just like the other modulos.
; 
; *********************************************************************************************
; 
; BPLHPTH-BPLHPTL
; 
;          32bit pointer to Chunky plane.
;          The Chunky plane can show 8bit/16Bit/15bit/24bit/32bit screens.
; 
; *********************************************************************************************
; 
; GFXMODE
;
;          16bit register selecting the screen size and the pixelformat for the Chunky plane.      
;
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                             |
;          +-------+----------+-----------------------------------------+
;          | 15.08 | Resolution  | $00                                  |
;          |       |               $01 = 320x200                        |
;          |       |               $02 = 320x240                        |
;          |       |               $03 = 320x256                        |
;          |       |               $04 = 640x400                        |
;          |       |               $05 = 640x480                        |
;          |       |               $06 = 640x512                        |
;          |       |               $07 = 960x240                        |
;          |       |               $08 = 480x270                        |
;          |       |               $09 = 304x224                        |
;          |       |               $0A = 1280x720                       |
;          |       |               $0B = 640x360                        |
;          +-------+----------+-----------------------------------------+ 
;          | 07.00 | Pixelformat | $00                                  |
;          |       |               $01 = 8bit0                          |
;          |       |               $02 = 16bit R5G6B5                   |
;          |       |               $03 = 15bit 1R5G5B5                  |
;          |       |               $04 = 24bit R8G8B8                   |
;          |       |               $05 = 32bit A8R8G8B8                 |
;          |       |               $06 = YUV                            |
;          |       |               $07 =                                |
;          |       |               $08 = PLANAR 1BIT                    |
;          |       |               $09 = PLANAR 2BIT                    |
;          |       |               $0A = PLANAR 4BIT                    |
;          |       |               $0B =                                |
;          +-------+----------+-----------------------------------------+ 
; 
; *********************************************************************************************
; 
; FMODE
; 
;          This register controls the fetch mechanism for different
;          types of Chip RAM accesses:
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 15    | SSCAN2   | Global enable for sprite scan-doubling.   |
;          | 14    | BSCAN2   | Enables the use of 2nd P/F modulus on an  |
;          |       |          | alternate line basis to support bitplane  |
;          |       |          | scan-doubling.                            |
;          | 13-05 | Unused   |                                           |
;          | 04    | SAGA     | Enable SAGA New features                  |
;          | 03    | SPAGEM   | Sprite page mode (double CAS)             |
;          | 02    | SPR32    | Sprite 32 bit wide mode                   |
;          | 01    | BPAGEM   | Bitplane Page Mode (double CAS)           |
;          | 00    | BLP32    | Bitplane 32 bit wide mode                 |
;          +-------+----------+-------------------------------------------+
; 
; *********************************************************************************************
; 
; DMACON2(Read)
; 
;          This register contains detailed Sprite collision detection
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 15    |         | SET/CLR                                    |
;          | 14    |         |                                            |
;          | 13    | ETH     | Ethernet                                   |
;          | 12    |         |                                            |
;          | 11    | AUD15   | Audio channel 15                           |
;          | 10    | AUD14   | Audio channel 14                           |
;          | 09    | AUD13   | Audio channel 13                           |
;          | 08    | AUD12   | Audio channel 12                           |
;          | 07    | AUD11   | Audio channel 11                           |
;          | 06    | AUD10   | Audio channel 10                           |
;          | 05    | AUD9    | Audio channel 9                            |
;          | 04    | AUD8    | Audio channel 8                            |
;          | 03    | AUD7    | Audio channel 7                            |
;          | 02    | AUD6    | Audio channel 6                            |
;          | 01    | AUD5    | Audio channel 5                            |
;          | 00    | AUD4    | Audio channel 4                            |
;          +-------+----------+-------------------------------------------+
; 
; *********************************************************************************************
; 
; INTENA2(Read)
; 
; This register contains interrupt enable bits. The bit assignment for
; both the request, and enable registers is given below
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 15    |         | SET/CLR                                    |
;          | 14    |         |                                            |
;          | 13    | ETH     | Ethernet                                   |
;          | 12    |         |                                            |
;          | 11    | AUD15   | Audio channel 15 block finished            |
;          | 10    | AUD14   | Audio channel 14 block finished            |
;          | 09    | AUD13   | Audio channel 13 block finished            |
;          | 08    | AUD12   | Audio channel 12 block finished            |
;          | 07    | AUD11   | Audio channel 11 block finished            |
;          | 06    | AUD10   | Audio channel 10 block finished            |
;          | 05    | AUD9    | Audio channel 9 block finished             |
;          | 04    | AUD8    | Audio channel 8 block finished             |
;          | 03    | AUD7    | Audio channel 7 block finished             |
;          | 02    | AUD6    | Audio channel 6 block finished             |
;          | 01    | AUD5    | Audio channel 5 block finished             |
;          | 00    | AUD4    | Audio channel 4 block finished             |
;          +-------+----------+-------------------------------------------+
; 
; *********************************************************************************************
; 
; INTREQ2(Read)
; 
; This register contains interrupt request bits (or flags). These bits
; may be polled by the processor, and if enabled by the bits listed in
; the next register, they may cause processor interrupts. Both a set
; and clear operation are required to load arbitrary data into this register.
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 15    |         | SET/CLR                                    |
;          | 14    |         |                                            |
;          | 13    | ETH     | Ethernet                                   |
;          | 12    |         |                                            |
;          | 11    | AUD15   | Audio channel 15 block finished            |
;          | 10    | AUD14   | Audio channel 14 block finished            |
;          | 09    | AUD13   | Audio channel 13 block finished            |
;          | 08    | AUD12   | Audio channel 12 block finished            |
;          | 07    | AUD11   | Audio channel 11 block finished            |
;          | 06    | AUD10   | Audio channel 10 block finished            |
;          | 05    | AUD9    | Audio channel 9 block finished             |
;          | 04    | AUD8    | Audio channel 8 block finished             |
;          | 03    | AUD7    | Audio channel 7 block finished             |
;          | 02    | AUD6    | Audio channel 6 block finished             |
;          | 01    | AUD5    | Audio channel 5 block finished             |
;          | 00    | AUD4    | Audio channel 4 block finished             |
;          +-------+----------+-------------------------------------------+
; 
; *********************************************************************************************
; 
; joy0buttons joy1buttons joy2buttons joy3buttons -
; 
;          This register contains extra fire buttons (USB joyspads)
; 
;         +-------+----------+-------------------------------------------+
;         | BIT#  | FUNCTION | DESCRIPTION                               |
;         +-------+----------+-------------------------------------------+
;         | 15    | Right   | Move RIGHT                                 |
;         | 14    | Left    | Move Left                                  |
;         | 13    | Down    | Move Down                                  |
;         | 12    | Up      | Move Up                                    |
;         | 11    | Reserved|                                            |
;         | 10    | Start   | Start                                      |
;         | 09    | Back    | Back                                       |
;         | 08    | FIRE8   | Firebutton 8                               |
;         | 07    | FIRE7   | Firebutton 7                               |
;         | 06    | FIRE6   | Firebutton 6                               |
;         | 05    | FIRE5   | Firebutton 5                               |
;         | 04    | FIRE4   | Firebutton 4                               |
;         | 03    | FIRE3   | Firebutton 3                               |
;         | 02    | FIRE2   | Firebutton 2                               |
;         | 01    | FIRE1   | Firebutton 1                               |
;         | 00    | PLUG    | Joypad connected                           |
;         +-------+----------+-------------------------------------------+
; 
; *********************************************************************************************
; 
; CLXDAT
;
;         This register contains detailed Sprite collision detection
;
;         +-------+----------+-------------------------------------------+
;         | BIT#  | FUNCTION | DESCRIPTION                               |
;         +-------+----------+-------------------------------------------+
;         | 15    | HIT15   | Sprite to SpriteF                          |
;         | 14    | HIT14   | Sprite to SpriteE                          |
;         | 13    | HIT13   | Sprite to SpriteD                          |
;         | 12    | HIT12   | Sprite to SpriteC                          |
;         | 11    | HIT11   | Sprite to SpriteB                          |
;         | 10    | HIT10   | Sprite to SpriteA                          |
;         | 09    | HIT9    | Sprite to Sprite9                          |
;         | 08    | HIT8    | Sprite to Sprite8                          |
;         | 07    | HIT7    | Sprite to Sprite7                          |
;         | 06    | HIT6    | Sprite to Sprite6                          |
;         | 05    | HIT5    | Sprite to Sprite5                          |
;         | 04    | HIT4    | Sprite to Sprite4                          |
;         | 03    | HIT3    | Sprite to Sprite3                          |
;         | 02    | HIT2    | Sprite to Sprite2                          |
;         | 01    | HIT1    | Sprite to Sprite1                          |
;         | 00    | HIT0    | Sprite to Sprite0                          |
;         +-------+----------+-------------------------------------------+
;
; *********************************************************************************************
; 
; PlanarCOLH-PlanarCOLL COLOR PORT
; 
;          This register allows direct setting of 256 Planar colors registers
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 31-24 | BLUE    | 8bit Colornumber                           |
;          | 23-16 | RED     | 8bit Red                                   |
;          | 15-08 | GREEN   | 8bit Green                                 |
;          | 07-00 | BLUE    | 8bit Blue                                  |
;          +-------+----------+-------------------------------------------+
; 
; Example:
; 
;  move.l #$00FF0000,$000380   -- set color0 = RED
;  move.l #$01FFFF00,$000380   -- set color1 = YELLOW
; 
; Copper:
;  dc.w  $8380,$00FF,$0000     -- set color0 = RED
; 
; *********************************************************************************************
; 
; SpriteCOLH-SpriteCOLL COLOR PORT
; 
;          This register allows direct setting of 256 Sprite colors
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 31-24 | BLUE    | 8bit Colornumber                           |
;          | 23-16 | RED     | 8bit Red                                   |
;          | 15-08 | GREEN   | 8bit Green                                 |
;          | 07-00 | BLUE    | 8bit Blue                                  |
;          +-------+----------+-------------------------------------------+
; 
; Example:
; 
;  move.l #$00FF0000,$000384   -- set color0 = RED
;  move.l #$01FFFF00,$000384   -- set color1 = YELLOW
; 
; Copper:
;  dc.w  $8384,$00FF,$0000     -- set color0 = RED
; 
; *********************************************************************************************
; 
; ChunkyCOLH-ChunkyCOLL COLOR PORT
; 
;          This register allows direct setting of 256 Planar colors registers
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 31-24 | BLUE    | 8bit Colornumber                           |
;          | 23-16 | RED     | 8bit Red                                   |
;          | 15-08 | GREEN   | 8bit Green                                 |
;          | 07-00 | BLUE    | 8bit Blue                                  |
;          +-------+----------+-------------------------------------------+
; 
; Example:
; 
;  move.l #$00FF0000,$000388   -- set color0 = RED
;  move.l #$01FFFF00,$000388   -- set color1 = YELLOW
; 
; Copper:
;  dc.w  $8388,$00FF,$0000     -- set color0 = RED
; 
; 
; *********************************************************************************************
; 
; PIPCOLH-PIPCOLL COLOR PORT
; 
;          This register allows direct setting of 256 PIP colors registers
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 31-24 | BLUE    | 8bit Colornumber                           |
;          | 23-16 | RED     | 8bit Red                                   |
;          | 15-08 | GREEN   | 8bit Green                                 |
;          | 07-00 | BLUE    | 8bit Blue                                  |
;          +-------+----------+-------------------------------------------+
; 
; Example:
; 
;  move.l #$00FF0000,$00038C   -- set color0 = RED
;  move.l #$01FFFF00,$00038C   -- set color1 = YELLOW
; 
; Copper:
;  dc.w  $838C,$00FF,$0000     -- set color0 = RED
; 
; *********************************************************************************************
; 
; VAMP VERSION
; 
;          This register card version and CPU Clockrate
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 15-08 | Card    | Card Version                               |
;          |       |         | 1=V600, 2=V500, 3=V4_500, 4=V1200, 5=V4SA  |
;          | 07-00 | Clock   | Clock multiplier                           |
;          +-------+----------+-------------------------------------------+
; 
; https://github.com/flype44/VControl/blob/master/DOCUMENTATION.md#vcontrol-boardid
; 0 = Unidentified, 1=V600, 2=V500, 3=V4 Accelerator, 4=V4 Stand Alone, 5=V1200
; 
; *********************************************************************************************
; 
; AUDxPTRH - AUDxPTRL
; 
;          32bit pointer to Audio data.
; 
; *********************************************************************************************
; 
; AUDxLEN
; 
;          32bit length of audio data.
;          Count is in pair of samples!
; 
; 
; *********************************************************************************************
; 
; AUDxVOL
; 
;          16bit Audio LEFT/RIGHT Register
; 
;          +-------+----------+-------------------------------------------+
;          | BIT#  | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 15-08 | VOLL   | 8bit - $80=Max $00=off                      |
;          | 07-00 | VOLR   | 8bit - $80=Max $00=off                      |
;          +-------+----------+-------------------------------------------+
; 
; Volume maximum = 128 ($80)
; 
; *********************************************************************************************
; 
; AUDxCTRL
; 
;          16bit Audio CONTROL Register
; 
;          +-------+----------+-------------------------------------------+
;          | BIT# | FUNCTION | DESCRIPTION                               |
;          +-------+----------+-------------------------------------------+
;          | 1    | OneShot  | Channel will turn itself off at sample end |
;          | 0    | 16bit    | 0=8bit, 1=16bit samples                    |
;          +-------+----------+-------------------------------------------+
; 
; *********************************************************************************************
; 
; AUDxPER
; 
;          16bit PERIOD COUNT
; 
;  This register contains the period (rate) of
;  audio channel x DMA data transfer.
;  The minimum period is 65 color clocks. This means
;  that the smallest number that should be placed in
;  this register is 65 decimal.  This corresponds to
;  a maximum sample frequency of 56 khz.
; 
; *********************************************************************************************
