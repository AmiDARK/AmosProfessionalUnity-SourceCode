******* Table des sauts
SyIn:
    bra        ClInky                ;0 -Inkey:        
    bra        ClVide                ;1 -ClearKey:    
    bra        ClSh                  ;2 -Shifts:        
    bra        ClInst                ;3 -Instant:    
    bra        ClKeyM                ;4 -KeyMap:        
    bra        ClJoy                 ;5 -Joy:        
    bra        ClPutK                ;6 -PutKey:        
    bra        MHide                 ;7 -Hide:        
    bra        MShow                 ;8 -Show:        
    bra        MChange               ;9 -ChangeM:          ChMouse
    bra        MXy                   ;10-XyMou:            XY Mouse
    bra        CXyHard               ;11-XyHard:           Conversion SCREEN-> HARD
    bra        CXyScr                ;12-XyScr:            Conversion HARD-> SCREEN
    bra        MBout                 ;13-MouseKey:    
    bra        MSetAb                ;14-SetM:        
    bra        GetSIn                ;15-ScIn:             Get screen IN
    bra        CXyWi                 ;16-XyWin:            Conversion SCREEN-> WINDOW courante
    bra        MLimA                 ;17-LimitM:           Limit mouse
    bra        SyZoHd                ;18-ZoHd:             Zone coordonnees HARD
    bra        SyResZ                ;19-ResZone:          Reserve des zones
    bra        SyRazZ                ;20-RazZone:          Effacement zones
    bra        SySetZ                ;21-SetZone:          Set zone
    bra        SyMouZ                ;22-GetZone:          Zone souris!    
    bra        WVbl                  ;23-WaitVbl:    
    bra        HsSet                 ;24-SetHs:            Affiche un hard sprite
    bra        HsUSet                ;25-USetHs:           Efface un hard sprite
    bra        ClFFk                 ;26-SetFunk:    
    bra        ClGFFk                ;27-GetFunk:    
    bra        HsAff                 ;28-AffHs:            Recalcule les hard sprites
    bra        HsBank                ;29-SetSpBank:        Fixe la banque de sprites
    bra        HsNXYA                ;30-NXYAHs:           Instruction sprite
    bra        HsXOff                ;31-XOffHs:           Sprite off n
    bra        HsOff                 ;32-OffHs:            All sprite off
    bra        HsAct                 ;33-ActHs:            Actualisation HSprite    
    bra        HsSBuf                ;34-SBufHs:           Set nombre de lignes
    bra        HsStAct               ;35-StActHs:          Arrete les HS sans deasctiver!
    bra        HsReAct               ;36-ReActHs:          Re-Active tous!
    bra        MStore                ;37-StoreM:           Stocke etat souris / Show on
    bra        MRecall               ;38-RecallM:          Remet la souris 
    bra        HsPri                 ;39-PriHs:            Priorites SPRITES/PLAYFIELD
    bra        TokAMAL               ;40-AMALTok:          Tokenise AMAL
    bra        CreAMAL               ;41-AMALCre:          Demarre AMAL
    bra        MvOAMAL               ;42-AMALMvO:          On/Off/Freeze AMAL
    bra        DAllAMAL              ;43-AMALDAll:         Enleve TOUT!
    bra        Animeur               ;44-AMAL:             Un coup d''animation
    bra        RegAMAL               ;45-AMALReg:          Registre!
    bra        ClrAMAL               ;46-AMALClr:          Clear
    bra        FrzAMAL               ;47-AMALFrz:          FREEZE all
    bra        UFrzAMAL              ;48-AMALUFrz:         UNFREEZE all
    bra        BobSet                ;49-SetBob:           Entree set bob
    bra        BobOff                ;50-OffBob:           Arret bob
    bra        BobSOff               ;51-OffBobS:          Arret tous bobs
    bra        BobAct                ;52-ActBob:           Actualisation bobs
    bra        BobAff                ;53-AffBob:           Affichage bobs
    bra        BobEff                ;54-EffBob:           Effacement bobs
    bra        ChipMM                ;55-SyChip:           Reserve CHIP
    bra        FastMM                ;56-SyFast:           Reserve FAST
    bra        BobLim                ;57-LimBob:           Limite bobs!
    bra        SyZoGr                ;58-ZoGr:             Zone coord graphiques
    bra        GetBob                ;59-SprGet:           Saisie graphique
    bra        Masque                ;60-MaskMk:           Calcul du masque
    bra        SpotH                 ;61-SpotHot:          Fixe le point chaud
    bra        BbColl                ;62-ColBob:           Collisions bob
    bra        GetCol                ;63-ColGet:           Fonction collision
    bra        SpColl                ;64-ColSpr:           Collisions sprites
    bra        SyncO                 ;65-SetSync:          Synchro on/off
    bra        Sync                  ;66-Synchro:          Synchro step
    bra        SetPlay               ;67-PlaySet:          Set play direction...
    bra        BobXY                 ;68-XYBob:            Get XY Bob
    bra        HsXY                  ;69-XYSp:             Get XY Sprite
    bra        BobPut                ;70-PutBob:           Put Bob!
    bra        TPatch                ;71-Patch:            Patch icon/bob!
    bra        MRout                 ;72-MouRel:           Souris relachee
    bra        MLimEc                ;73-LimitMEc:         Limit mouse ecran
    bra        FreeMM                ;74-SyFree:           Libere mem
    bra        HColSet               ;75-SetHCol:          Set HardCol
    bra        HColGet               ;76-GetHCol:          Get HardCol
    bra        TMovon                ;77-MovOn:            Movon!
    bra        TKSpeed               ;78-KeySpeed:         Key speed
    bra        TChanA                ;79-ChanA:            =ChanAn
    bra        TChanM                ;80-ChanM:            =ChanMv
    bra        TPrio                 ;81-SPrio:            Set priority
    bra        TGetDisc              ;82-GetDisc:          State of disc drive
    bra        Add_VBL               ;83-RestartVBL        Restart VBL
    bra        Rem_VBL               ;84-StopVBL           Stop VBL
    bra        ClKWait               ;85-KeyWaiting        (P) Une touche en attente?
    bra        WMouScrFront          ;86-MouScrFront       (P) Coordonnees souris dans ecran front
    bra        WMemReserve           ;87-MemReserve        (P) Reservation memoire secure
    bra        WMemFree              ;88-MemFree           (P) Liberation memoire secure
    bra        WMemCheck             ;89-MemCheck          (P) Verification memoire
    bra        WMemFastClear         ;90-MemFastClear      (P) 
    bra        WMemChipClear         ;91-MemChipClear    
    bra        WMemFast              ;92-MemFast        
    bra        WMemChip              ;93-MemChip        
    bra        WSend_FakeEvent       ;94-Send_FakeEvent    Envoi d''un faux event souris
    bra        WTest_Cyclique        ;95-Test_Cyclique     Tests cyclique AMOS
    bra        WAddFlushRoutine      ;96-AddFlushRoutine   Ajoute une routine FLUSH
    bra        WMemFlush             ;97-MemFlush          Force un memory FLUSH
    bra        WAddRoutine           ;98-AddRoutine        Ajoute une routine
    bra        WCallRoutines         ;99-CallRoutines      Appelle les routines
    bra        WRequest_OnOff        ;100-Set Requester    Change le requester
    bra        GFatal                ;101-FatalQuit 2020.10.13 Addition to put AGA copper startup in agaSupport.lib plugin system.