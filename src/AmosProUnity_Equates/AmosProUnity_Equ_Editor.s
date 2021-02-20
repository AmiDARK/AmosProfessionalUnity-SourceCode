; _______________________
;
;         Editeur
; _______________________
;

; Pointeurs sur zones de chaines
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ed_ConfigHead    equ    "ApCf"
Ed_QuitHead    equ    "ApLC"

; Adresse des elements de configuration
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ed_Config    rs.l    1
Ed_Systeme    rs.l    1        Ne pas changer l''ordre
EdM_Messages    rs.l    1
Ed_Messages    rs.l    1
Ed_TstMessages    rs.l    1
Ed_RunMessages    rs.l    1
Ed_MnPrograms    rs.l    1
EdM_User    rs.l    1
EdM_Definition    rs.l    1


; Données normales
; ~~~~~~~~~~~~~~~~
Ed_Banks    rs.l    1
Ed_Dialogs    rs.l    1

Edt_List    rs.l    1
Edt_Current    rs.l    1
Edt_Runned    rs.l    1

Ed_Prg2ReLoad    rs.l    1
Ed_BankGrab    rs.w     1
Ed_BankFlag    rs.w     1
Ed_ZapCounter    rs.w    1
Ed_ZapError    rs.w    1
Ed_ZapMessage    rs.l    1
Ed_ZapParam    rs.l    1
Ed_ADialogues    rs.l    1
Ed_VDialogues    rs.l    1
Ed_DiaCopyD    rs.l    1
Ed_DiaCopyC    rs.l    1

EdMa_Changed    rs.b    1
Ed_FUndo    rs.b    1
Ed_SCallFlags    rs.b    1
EdC_Changed    rs.b    1

EdMa_Head    equ    "ApMa"
EdMa_List    rs.l    1
EdMa_Play    rs.l    1
EdMa_Tape    rs.w    1
EdMa_Change    rs.b    1
Ed_CuFlag    rs.b    1

Ed_AutoSaveRef    rs.l    1
Ed_Avert    rs.w    1

Ed_Ty        rs.w    1
Ed_Block    rs.l    1
Ed_BufE:    rs.l     1    
Ed_BufT:    rs.l     1        
Ed_WindowToDel    rs.l    1
Ed_EtCps    rs.b     1
Ed_EtatAff    rs.b    1
Ed_EtXX        rs.b    8    
Ed_EtOCps    rs.b     1
EdC_Modified    rs.b    1
Ed_MemoryX    rs.w    1
Ed_MemorySx    rs.w    1

Ed_Resource    rs.l    1

Ed_ExtTitles    rs.l    26

Ed_MKey        rs.b    1
Ed_MkFl        rs.b    1
Ed_MkIns    rs.b    1
Ed_OMKey    rs.b    1
Ed_BigView    rs.b    1
Ed_LinkTokCur    rs.b    1

Ed_MkCpt    rs.w    1
Ed_WMax        rs.w    1
Ed_SchLong    rs.b    1
Ed_RepLong    rs.b     1
Ed_Opened    rs.b    1
Ed_TstMesOn    rs.b    1
Ed_NewAppear    rs.b    1
Ed_Ok        rs.b    1

Ed_NoAff    rs.b    1    
Ed_Warm        rs.b    1
Ed_Disk        rs.w    1
Ed_FSel        rs.w    1

Ed_SchBuf    rs.b     34
Ed_RepBuf    rs.b     34

EdM_Table    rs.l    1
EdM_TableSize    rs.l    1
EdM_TableAMOS    rs.l    1
EdM_MenuAMOS    rs.l    1
EdM_MessAMOS    rs.l    1
EdM_PosHidden    rs.w    1
EdM_Flag    rs.b    1
Ed_RunnedHidden    rs.b    1
Ed_MemCurrent    rs.l    1
Dia_Magic    rs.l    1

EdM_Copie    rs.b    Mn_ESave-Mn_SSave
Ed_Boutons    rs.b    Bt_Long*14


SlDelai        equ     10        

; Zone de sauvegarde de la config Editeur
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ed_DConfig    equ    __RS
; Screen definition
Ed_Sx        rs.w    1        
Ed_Sy        rs.w    1
Ed_Wx        rs.w    1
Ed_Wy        rs.w    1
Ed_VScrol    rs.w    1
Ed_Inter    rs.b    1
        rs.b    1
; Colour back
Ed_ColB        rs.w    1
; Length UNDO
Ed_LUndo    rs.l    1    
Ed_NUndo    rs.l    1
; Untok case
DtkMaj1        rs.b    1    
DtkMaj2        rs.b    1
; Flags
Ed_SvBak    rs.b    1
EdM_Keys    rs.b    1
Esc_KMemMax    rs.w    1
; Colour palette
Ed_Palette    rs.w    8               ; Editor color palette.
; Escape mode positions
Es_Y1        rs.w    1
Es_Y2        rs.w    1
; Security!
        rs.l    7
; Flags change within the editor
Ed_AutoSave    rs.l    1    
Ed_AutoSaveMn    rs.l    1    
Ed_SchMode    rs.w     1    
Ed_Tabs        rs.w    1
Esc_Output    rs.b    1
Ed_QuitFlags    rs.b    1
Ed_Insert    rs.b    1
Ed_Sounds    rs.b    1

; Programmes autoload
; ~~~~~~~~~~~~~~~~~~~
Ed_AutoLoad    rs.b    3*184
; Touches par defaut
; ~~~~~~~~~~~~~~~~~~
Ed_KFonc    rs.b    3*184
        rs.b    2

Ed_Code        rs.l    1

Ed_FConfig    equ    __RS

; Find de la config editeur        
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~