;        File Selector specials
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        RsReset
Fs_Sp        rs.l    1
Fs_OldEc    rs.w    1
Fs_AdEc        rs.l    1
Fs_Channel    rs.l    1
Fs_Variables    rs.l    1
Fs_Input    rs.w    1
Fs_Command    rs.w    1
Fs_Waiting    rs.w    1
Fs_Click    rs.w    1

Fs_Array    rs.b    1
        rs.b    1
Fs_ASize    rs.w    1    
Fs_AMagic    rs.l    1
Fs_ACall    rs.l    1

Fs_LimSave    rs.w    4

Fs_Opened    rs.b    1
Fs_Blocked    rs.b    1
Fs_DirOn    rs.b    1
Fs_DevFlag    rs.b    1
Fs_Long        equ    __RS

Fs_ChannelN    equ    $AABBCCDD
Fs_SliderN    equ    12
Fs_ListN    equ    13
Fs_PathN    equ    14
Fs_FileN    equ    15
Fs_SliderS    equ    18

FsV_Titre0    equ    0*4
FsV_Titre1    equ    1*4
FsV_Sort    equ    7*4
FsV_Size    equ    8*4
FsV_PList    equ    10*4
FsV_Array    equ    11*4
FsV_Tx        equ    12*4
FsV_Ty        equ    13*4
FsV_Path    equ    15*4
FsV_File    equ    14*4
FsV_Store    equ    16*4
FsV_PosFirst    equ    25*4
FsV_AffFlag    equ    26*4
FsV_Max        equ    27
Fs_MaxStore    equ    10
