; ***************************** agaSupport.lib call
UnityLibCallsr MACRO
    move.l     T_AgaVect(a5),\2    ; This pointer is populated when the AgaSupport.lib is started
    jsr        \1*4(\2)
            ENDM

UnityLibCall   MACRO
    UnityLibCallsr \1,a2
            ENDM

UnityLibCallA0 MACRO
    UnityLibCallsr \1,a0
            ENDM

UnityLibSecureSR MACRO
    move.l     T_AgaVect(a5),\2    ; This pointer is populated when the AgaSupport.lib is started
    cmp.l      #0,a2               ; was the Plugin initialized ?
    beq.s      .er\@               ; No -> Jump .erXX
    add.l      \1*4,\2             ; Point to the chosen method to call 
    tst.l     (\2)                 ; is the method defined ?
    beq.s      .er\@               ; No -> Jump .erXX
    jsr        (\2)                ; Yes -> Jsr chosen Method.
.er\@:
            ENDM

UnityLibSecure   MACRO
    UnityLibSecureSR \1,a2
            ENDM

UnityLibSecureA0 MACRO
    UnityLibSecureSR \1,a0
            ENDM

UnityLibNotInitialized MACRO
    tst.l     T_AgaVect(a5)
    beq       \1
            ENDM
