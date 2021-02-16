

; Define the size of a full 256 colors CMAP palette in IFF/ILBM file format to save
aga_iffPalSize equ 828 contains : FORM/ILBM/BMHD/CMAP/DPI


       RsReset
def_FORM:              rs.l 1          ; "FORM" header
def_FORM_size:         rs.l 1          ; Size of full file without aga_FORM nor aga_FORM_size
def_ILBM:              rs.l 1          ; "ILBM" header
def_BMHD:              rs.l 1          ; "BMHD" header
def_BMHD_size:         rs.l 1          ; Size of BMHD bloc without aga_BMHD_size (nor aga_BMHD)
def_BMHD_W:            rs.w 1          ; raster width in pixels
def_BMHD_H:            rs.w 1          ; raster height in pixels
def_BMHD_X:            rs.w 1          ; Pixel position for this image
def_BMHD_Y:            rs.w 1          ; Pixel position for this image
def_BMHD_nPlanes:      rs.b 1          ; # Source bitplanes (count/amount)
def_BMHD_masking:      rs.b 1          ; Masking
def_BMHD_compression:  rs.b 1          ; Compression
def_BMHD_pad1:         rs.b 1          ; Set as 0 (Unised)
def_BMHD_transparentC: rs.w 1          ; Transparent "color number" (sort of)
def_BMHD_xAspect:      rs.b 1          ; Pixel aspect, a ratio width : height
def_BMHD_yAspect:      rs.b 1          ; Pixel aspect, a ratio width : height
def_BMHD_pageWidth:    rs.w 1          ; Source "page" size in pixels
def_BMHD_pageHeight:   rs.w 1          ; Source "page" size in pixels
def_CMAP:              rs.l 1          ; "CMAP"
def_CMAP_size:         rs.l 1          ; Size of CMAP bloc without aga_CMAP_size (nor aga_CMAP)
def_CMAP_Colors:       rs.b 256*3      ; All the colors components stores in RGB24 file format, 1 byte for each color component R,G,B
def_DPI_:              rs.l 1          ; "DPI "
def_DPI__size:         rs.l 1          ; Size of "DPI " bloc without aga_DPI__size (nor aga_DPI_)
def_DPI_data:          rs.l 1          ; set at 0
; Set the size of the whole file.
def_ILBM_SIZE          equ __RS

ColorPaletteSize    equ     780

; *******************************************************
; Amiga IFF/ILBM Palette content :
; *******************************************************
; Source : https://wiki.amigaos.net/wiki/ILBM_IFF_Interleaved_Bitmap
; dc.b "FORM"
; dc.l fSize                           ; Ths full size of the file -( "FORM" + fSize )
; dc.b "ILBM"
; dc.b "BMHD"
; dc.b bmhdSize = $14 (=20) = Size of BMHD Structure
; dc.w 0,0                             ; UWORD w, h;                  /* raster width & height in pixels      */
; dc.w 0,0                             ; WORD  x, y;                  /* pixel position for this image        */
; dc.b nPlaned                         ; UBYTE nPlanes;               /* # source bitplanes                   */
; dc.b Masking                         ; UBYTE masking;               /* mskNone(=0), mskHasMask(=1), mskHasTransparentColor(=2), mskLasso(=3) */
; dc.b Compression                     ; UBYTE compression;           /* cmpNone(=0), cmpByteRun1(=1) */
; dc.b pad1=0                          ; UBYTE pad1;                  /* unused; ignore on read, write as 0   */
; dc.w TransparentColor                ; UWORD transparentColor;      /* transparent "color number" (sort of) */
; dc.b xAspect, yAspect                ; UBYTE xAspect, yAspect;      /* pixel aspect, a ratio width : height */
; dc.w pageWidth, pageHeight           ; WORD  pageWidth, pageHeight; /* source "page" size in pixels    */
; dc.b "CMAP"
; dc.l cmapSize =$300 (256*3) = Size of color map
; dc.b (256*3 times) = 768 .b bytes
; dc.b "DPI "
; dc.l dpiSize
; dc.l dpiDatas
; Checked with Personal Paint 7 "Save palette" with 256 colors