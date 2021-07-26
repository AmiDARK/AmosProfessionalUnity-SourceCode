# APU-SpecialFX-Extension-Releases
Here is the official repository for the binaries releases of the SpecialFX extension for Amos Professional Unity

Special FX Extension is the first official extension for the Amos Professional Unity project.



# Webpage of the project :
  http://amos-professional-aga.frederic-cordier.fr/?specialfx-extension-previously-personal-unity

# You can see the details of all commands available in this Public Alpha Release 1 here
  http://amos-professional-aga.frederic-cordier.fr/?amos-professional-unity---specialfx-extension---commands-set

# Here is the list of the available commands in the Public Alpha Release 1 :

=Get FileSize(FILENAME$)
Set Ntsc
Set Pal
=Right Click
=Fire(1,BUTTONID)
=Ehb
=Ham6
Create Memblock MEMBLOCKID,SIZE_IN_BYTES
=Memblock Exist(MEMBLOCKID)
SIZE_IN_BYTES = Get Memblock Size( MEMBLOCKID )
Write Memblock Long MEMBLOCKID, POSITION, LONG_VALUE
Write Memblock Word MEMBLOCKID, POSITION, WORD_VALUE
Write Memblock Byte MEMBLOCKID, POSITION, BYTE_VALUE
VALUE = Memblock Long( MEMBLOCKID, POSITION )
VALUE = Memblock Word( MEMBLOCKID, POSITION )
VALUE = Memblock Byte( MEMBLOCKID, POSITION )
Reserve F Icon ICON_BANK_ID, AMOUNT_OF_ICONS
Set Current F Icon Bank ICON_BANK_ID
ICON_BANK_ID = Get Current F Icon Bank
Get F Icon ICONID, XPOS, YPOS
Paste F Icon ICONID,XPOS,YPOS,(optional)MASK
Create Playfield From Sprite YSTART, HEIGHT
Remove Sprite Playfield
Set Playfield Prioritie
