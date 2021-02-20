; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                 Données de Configuration Interpréteur
;
PI_Start    equ    __RS
; Initialisation de la trappe
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
PI_ParaTrap    rs.l    1        0 - Adresse actualisation
PI_AdMouse    rs.l    1        4 - Adresse souris
        rs.w    1        8 - Nombre de bobs
        rs.w    1        10- Position par defaut ecran!!
        rs.l    1        12- Taille liste copper
        rs.l    1        16- Nombre lignes sprites
; Taille des buffers 
; ~~~~~~~~~~~~~~~~~~
PI_VNmMax    rs.l    1        20- Buffer des noms de variable
PI_TVDirect    rs.w    1        24- Variables mode direct
PI_DefSize    rs.l    1        26- Taille buffer par defaut
; Directory
; ~~~~~~~~~
PI_DirSize    rs.w    1        30- Taille nom directory
PI_DirMax    rs.w    1        32- Nombre max de noms
; Faire carriage return lors de PRINT?
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PI_PrtRet    rs.b    1        34- Return lors de 10
; Faire des icones?
; ~~~~~~~~~~~~~~~~~
PI_Icons    rs.b    1        35- Faire de icones
; Autoclose workbench?
; ~~~~~~~~~~~~~~~~~~~~
PI_AutoWB    rs.b    1        36- Fermer automatiquement
PI_AllowWB    rs.b    1        37- Close Workbench effective?
; Close editor?
; ~~~~~~~~~~~~~~~~~~~~
PI_CloseEd    rs.b    1        38- Autoriser fermeture
PI_KillEd    rs.b    1        39- Autoriser fermeture
PI_FsSort    rs.b    1        40- Sort files
PI_FsSize    rs.b    1        41- Size of files
PI_FsStore    rs.b    1        42- Store directories
; Securite flags
; ~~~~~~~~~~~~~~
        rs.b    1        43- Flag libre
        rs.b    4        44- 4 flags libres!
; Text reader
; ~~~~~~~~~~~
PI_RtSx        rs.w    1        48- Taille X ecran Readtext
PI_RtSy        rs.w    1        50- Taille Y ecran Readtext
PI_RtWx        rs.w    1        52- Position X
PI_RtWy        rs.w    1        54- Position Y
PI_RtSpeed    rs.w    1        56- Vitesse apparition
; File selector
; ~~~~~~~~~~~~
PI_FsDSx    rs.w    1        58- Taille X fsel
PI_FsDSy    rs.w    1        60- Taille Y fsel
PI_FsDWx    rs.w    1        62- Position X
PI_FsDWy    rs.w    1        64- Position Y
PI_FsDVApp    rs.w    1        66- Vitesse app
; Ecran par defaut
; ~~~~~~~~~~~~~~~~
PI_DefETx    rs.w    1
PI_DefETy    rs.w    1
PI_DefECo    rs.w    1
PI_DefECoN    rs.w    1
PI_DefEMo    rs.w    1
PI_DefEBa    rs.w    1
PI_DefEPa    rs.w    32
PI_DefEWx    rs.w    1
PI_DefEWy    rs.w    1
PI_DefAmigA    rs.l    1
        rs.l    6        Pour extension!
PI_End        equ    __RS
;
;        Fin de la zone configuration interpreteur
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~