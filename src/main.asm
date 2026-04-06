.nolist
#include "include/ti84pce.inc"
.list
    .org UserMem-2
    .db tExtTok,tAsm84CeCmp

#DEFINE currentItem     pixelshadow2
#DEFINE currentMenu     pixelshadow2+1    

; Menu IDs
#DEFINE MENU_MAIN       0
#DEFINE MENU_PHYSICS    1
#DEFINE MENU_CHEMISTRY  2
#DEFINE MENU_ABOUT      3

_main:
    ; Hook already installed?
    bit getCSCHookActive, (iy + hookFlags2)
    jr z, _install
    
    ; Uninstall
    res getCSCHookActive, (iy + hookFlags2)
    call _ClrScrnFull
    call _HomeUp
    ld hl, msgUninstalled
    call _PutS
    call _GetKey
    ret

_install:
    ; Install 
    ld hl, hook
    ld de, pixelshadow2+6000
    ld bc, endHook - startHook
    ldir
    ld hl, pixelshadow2+6000
    call _SetGetCSCHook
    
    call _ClrScrnFull
    call _HomeUp
    ld hl, msgInstalled
    call _PutS
    call _GetKey
    ret

msgInstalled:
    .db "F5 hook installed!", 0
msgUninstalled:
    .db "Hook uninstalled", 0

hook:
    .org pixelshadow2+6000
startHook:
    .db 83h
    cp 1Bh
    ret nz
    ld a, b
    cp skGraph
    ret nz
    bit shiftAlpha, (iy+shiftFlags)
    jr nz, alphaPressed
    or a
    ret
alphaPressed:
    res shiftAlpha, (iy+shiftFlags)

menuInit:
    xor a
    ld (wintop), a
    ld (currentItem), a
    ld (currentMenu), a 
    ld hl, $000101
    ld (drawFGColor), hl

    call _cursorOff
    jp dispatchMenu

; Menu dispatcher - route based on currentMenu
dispatchMenu:
    ld a, (currentMenu)
    cp MENU_MAIN
    jp z, dispMainMenu
    cp MENU_PHYSICS
    jp z, dispPhysicsMenu
    cp MENU_CHEMISTRY
    jp z, dispChemMenu
    cp MENU_ABOUT
    jp z, dispAboutMenu
    jp quit  ; Invalid menu - exit

; Main menu 
dispMainMenu:
    call _ClrScrnFull
    call _HomeUp
    
    ld hl, HDR_MAIN
    set textInverse, (IY+textFlags)
    call _PutS
    res textInverse, (IY+textFlags)
    call _NewLine
    call _NewLine
    
    ; Item 0: Physics
    call _NewLine
    ld a, (currentItem)
    cp 0
    jr nz, mainNotItem0
    set textInverse, (IY+textFlags)
mainNotItem0:
    ld a, '1'
    call _PutC
    ld a, ':'
    call _PutC
    res textInverse, (IY+textFlags)
    ld hl, MAIN_ITEM0
    call _PutS
    
    ; Item 1: Chemistry
    call _NewLine
    ld a, (currentItem)
    cp 1
    jr nz, mainNotItem1
    set textInverse, (IY+textFlags)
mainNotItem1:
    ld a, '2'
    call _PutC
    ld a, ':'
    call _PutC
    res textInverse, (IY+textFlags)
    ld hl, MAIN_ITEM1
    call _PutS
    
    ; Item 2: About
    call _NewLine
    ld a, (currentItem)
    cp 2
    jr nz, mainNotItem2
    set textInverse, (IY+textFlags)
mainNotItem2:
    ld a, '3'
    call _PutC
    ld a, ':'
    call _PutC
    res textInverse, (IY+textFlags)
    ld hl, MAIN_ITEM2
    call _PutS
    
    call _NewLine
    call _NewLine
    ld hl, INSTR_MAIN_LINE1
    call _PutS
    call _NewLine
    ld hl, INSTR_MAIN_LINE2
    call _PutS

mainLoop:
    call _getkey
    cp kDown
    jr z, mainDown
    cp kUp
    jr z, mainUp
    cp kEnter
    jr z, mainEnter
    cp k1
    jr z, mainSelect0
    cp k2
    jr z, mainSelect1
    cp k3
    jr z, mainSelect2
    cp kQuit
    jp z, quit
    cp kClear
    jr nz, mainLoop
quit:
    call _setupHome
    jp _JForceCmdNoChar

mainSelect0:
    xor a
    ld (currentItem), a
    jr mainEnter
mainSelect1:
    ld a, 1
    ld (currentItem), a
    jr mainEnter
mainSelect2:
    ld a, 2
    ld (currentItem), a
    jr mainEnter

mainDown:
    ld a, (currentItem)
    cp 2
    jr z, mainLoop
    inc a
    ld (currentItem), a
    jp dispMainMenu

mainUp:
    ld a, (currentItem)
    cp 0
    jr z, mainLoop
    dec a
    ld (currentItem), a
    jp dispMainMenu

mainEnter:
    ld a, (currentItem)
    cp 0
    jr z, mainGoPhysics
    cp 1
    jr z, mainGoChemistry
    cp 2
    jr z, mainGoAbout
    jr mainLoop

mainGoPhysics:
    ld a, MENU_PHYSICS
    ld (currentMenu), a
    xor a
    ld (currentItem), a
    jp dispatchMenu

mainGoChemistry:
    ld a, MENU_CHEMISTRY
    ld (currentMenu), a
    xor a
    ld (currentItem), a
    jp dispatchMenu

mainGoAbout:
    ld a, MENU_ABOUT
    ld (currentMenu), a
    xor a
    ld (currentItem), a
    jp dispatchMenu

; Physics constants
dispPhysicsMenu:
    call _ClrScrnFull
    call _HomeUp
    
    ld hl, HDR_PHYSICS
    set textInverse, (IY+textFlags)
    call _PutS
    res textInverse, (IY+textFlags)
    call _NewLine
    call _NewLine
    
    ; Item 0: Speed of light
    call _NewLine
    ld a, (currentItem)
    cp 0
    jr nz, physNotItem0
    set textInverse, (IY+textFlags)
physNotItem0:
    ld a, '1'
    call _PutC
    ld a, ':'
    call _PutC
    res textInverse, (IY+textFlags)
    ld hl, PHYS_ITEM0
    call _PutS
    
    ; Item 1: Planck's constant
    call _NewLine
    ld a, (currentItem)
    cp 1
    jr nz, physNotItem1
    set textInverse, (IY+textFlags)
physNotItem1:
    ld a, '2'
    call _PutC
    ld a, ':'
    call _PutC
    res textInverse, (IY+textFlags)
    ld hl, PHYS_ITEM1
    call _PutS
    
    ; Item 2: Gravitational constant
    call _NewLine
    ld a, (currentItem)
    cp 2
    jr nz, physNotItem2
    set textInverse, (IY+textFlags)
physNotItem2:
    ld a, '3'
    call _PutC
    ld a, ':'
    call _PutC
    res textInverse, (IY+textFlags)
    ld hl, PHYS_ITEM2
    call _PutS
    
    call _NewLine
    call _NewLine
    ld hl, INSTR_DETAIL_LINE1
    call _PutS
    call _NewLine
    ld hl, INSTR_DETAIL_LINE2
    call _PutS

physLoop:
    call _getkey
    cp kDown
    jr z, physDown
    cp kUp
    jr z, physUp
    cp kEnter
    jr z, physEnter
    cp k1
    jr z, physSelect0
    cp k2
    jr z, physSelect1
    cp k3
    jr z, physSelect2
    cp kQuit
    jp z, quit
    cp kClear
    jr z, physBack
    jr physLoop

physBack:
    ld a, MENU_MAIN
    ld (currentMenu), a
    xor a
    ld (currentItem), a
    jp dispatchMenu

physSelect0:
    xor a
    ld (currentItem), a
    jr physEnter
physSelect1:
    ld a, 1
    ld (currentItem), a
    jr physEnter
physSelect2:
    ld a, 2
    ld (currentItem), a
    jr physEnter

physDown:
    ld a, (currentItem)
    cp 2
    jr z, physLoop
    inc a
    ld (currentItem), a
    jp dispPhysicsMenu

physUp:
    ld a, (currentItem)
    cp 0
    jr z, physLoop
    dec a
    ld (currentItem), a
    jp dispPhysicsMenu

physEnter:
    ; Display details and store to variable
    call _ClrScrnFull
    call _HomeUp
    
    ld a, (currentItem)
    cp 0
    jp z, physShowC
    cp 1
    jp z, physShowH
    cp 2
    jp z, physShowG
    jp physLoop

physShowC:
    call showConstantC
    jp dispPhysicsMenu

physShowH:
    call showConstantH
    jp dispPhysicsMenu

physShowG:
    ; Display info
    ld hl, DETAIL_G_LINE1
    call _PutS
    call _NewLine
    ld hl, DETAIL_G_LINE2
    call _PutS
    call _NewLine
    ld hl, DETAIL_G_LINE3
    call _PutS
    call _NewLine
    call _NewLine
    
    ; Prompt for confirmation
    ld hl, MSG_PROMPT_G
    call _PutS
    call _NewLine
    ld hl, MSG_PROMPT_CLEAR
    call _PutS
    
physShowG_wait:
    call _getkey
    cp kEnter
    jr z, physShowG_store
    cp kClear
    jp z, dispPhysicsMenu
    jr physShowG_wait
    
physShowG_store:
    ; Store to variable G
    ld hl, CONST_G_VALUE
    call storeToVar_G
    
    call _ClrScrnFull
    call _HomeUp
    ld hl, MSG_STORED_G
    call _PutS
    call _getkey
    jp dispPhysicsMenu

; Constant display routines (shared)
showConstantC:
    call _ClrScrnFull
    call _HomeUp
    ld hl, DETAIL_C_LINE1
    call _PutS
    call _NewLine
    ld hl, DETAIL_C_LINE2
    call _PutS
    call _NewLine
    ld hl, DETAIL_C_LINE3
    call _PutS
    call _NewLine
    call _NewLine
    ld hl, MSG_PROMPT_C
    call _PutS
    call _NewLine
    ld hl, MSG_PROMPT_CLEAR
    call _PutS
showConstantC_wait:
    call _getkey
    cp kEnter
    jr z, showConstantC_store
    cp kClear
    ret
    jr showConstantC_wait
showConstantC_store:
    ld hl, CONST_C_VALUE
    call storeToVar_C
    call _ClrScrnFull
    call _HomeUp
    ld hl, MSG_STORED_C
    call _PutS
    call _getkey
    ret

showConstantH:
    call _ClrScrnFull
    call _HomeUp
    ld hl, DETAIL_H_LINE1
    call _PutS
    call _NewLine
    ld hl, DETAIL_H_LINE2
    call _PutS
    call _NewLine
    ld hl, DETAIL_H_LINE3
    call _PutS
    call _NewLine
    call _NewLine
    ld hl, MSG_PROMPT_H
    call _PutS
    call _NewLine
    ld hl, MSG_PROMPT_CLEAR
    call _PutS
showConstantH_wait:
    call _getkey
    cp kEnter
    jr z, showConstantH_store
    cp kClear
    ret
    jr showConstantH_wait
showConstantH_store:
    ld hl, CONST_H_VALUE
    call storeToVar_H
    call _ClrScrnFull
    call _HomeUp
    ld hl, MSG_STORED_H
    call _PutS
    call _getkey
    ret

; Variable storage routines 
; Input: HL = pointer to 9-byte constant data
storeToVar_C:
    call _Mov9ToOP1     ; Load     
    call _PushRealO1    ; Push to stack      
    call _ZeroOP1	; Clear OP1
    ld a, RealObj	; Variable type
    ld (OP1), a
    ld a, 'C'	
    ld (OP1+1), a
    call _StoOther	; Store
    ret

storeToVar_H:
    call _Mov9ToOP1
    call _PushRealO1
    call _ZeroOP1
    ld a, RealObj
    ld (OP1), a
    ld a, 'H'        
    ld (OP1+1), a
    call _StoOther  
    ret

storeToVar_G:
    call _Mov9ToOP1 
    call _PushRealO1 
    call _ZeroOP1   
    ld a, RealObj  
    ld (OP1), a
    ld a, 'G'     
    ld (OP1+1), a
    call _StoOther  
    ret

storeToVar_Na:
    call _Mov9ToOP1
    call _PushRealO1
    call _ZeroOP1
    ld a, RealObj
    ld (OP1), a
    ld a, 'N'
    ld (OP1+1), a
    call _StoOther
    ret

; Chemistry constants
dispChemMenu:
    call _ClrScrnFull
    call _HomeUp

    ld hl, HDR_CHEMISTRY 
    set textInverse, (IY+textFlags) 
    call _PutS 
    res textInverse, (IY+textFlags) 
    call _NewLine 
    call _NewLine 

    call _NewLine 
    ld a, (currentItem) 
    cp 0 
    jr nz, chemNotItem0 
    set textInverse, (IY+textFlags) 
chemNotItem0: 
    ld a, '1' 
    call _PutC 
    ld a, ':'
    call _PutC 
    res textInverse, (IY+textFlags) 
    ld hl, CHEM_ITEM0
    call _PutS     
    
    call _NewLine 
    ld a, (currentItem) 
    cp 1 
    jr nz, chemNotItem1 
    set textInverse, (IY+textFlags) 
chemNotItem1: 
    ld a, '2'
    call _PutC 
    ld a, ':' 
    call _PutC 
    res textInverse, (IY+textFlags) 
    ld hl, CHEM_ITEM1 
    call _PutS 

    call _NewLine 
    ld a, (currentItem) 
    cp 2 
    jr nz, chemNotItem2 
    set textInverse, (IY+textFlags) 
chemNotItem2: 
    ld a, '3'
    call _PutC 
    ld a, ':'
    call _PutC 
    res textInverse, (IY+textFlags) 
    ld hl, CHEM_ITEM2 
    call _PutS 

    call _NewLine 
    call _NewLine 
    ld hl, INSTR_DETAIL_LINE1 
    call _PutS 
    call _NewLine 
    ld hl, INSTR_DETAIL_LINE2 
    call _PutS 

chemLoop: 
    call _getkey
    cp kDown 
    jr z, chemDown 
    cp kUp
    jr z, chemUp 
    cp kEnter 
    jr z, chemEnter 
    cp k1 
    jr z, chemSelect0 
    cp k2 
    jr z, chemSelect1 
    cp k3 
    jr z, chemSelect2 
    cp kQuit 
    jp z, quit 
    cp kClear 
    jr z, chemBack 
    jr chemLoop 

chemBack: 
    ld a, MENU_MAIN 
    ld (currentMenu), a 
    xor a 
    ld (currentItem), a 
    jp dispatchMenu 

chemSelect0: 
    xor a 
    ld (currentItem), a 
    jr chemEnter 
chemSelect1: 
    ld a, 1 
    ld (currentItem), a 
    jr chemEnter 
chemSelect2: 
    ld a, 2 
    ld (currentItem), a 
    jr chemEnter 

chemDown: 
    ld a, (currentItem) 
    cp 2 
    jr z, chemLoop 
    inc a 
    ld (currentItem), a 
    jp dispChemMenu 

chemUp: 
    ld a, (currentItem) 
    cp 0 
    jr z, chemLoop 
    dec a 
    ld (currentItem), a 
    jp dispChemMenu 

chemEnter: 
    ld a, (currentItem) 
    cp 0 
    jp z, chemShowC_redirect 
    cp 1 
    jp z, chemShowH_redirect 
    cp 2 
    jp z, chemShowNa 
    jp chemLoop 

; Redirect to shared routines but return to chem menu
chemShowC_redirect:
    call showConstantC
    jp dispChemMenu

chemShowH_redirect:
    call showConstantH
    jp dispChemMenu

chemShowNa:
    call _ClrScrnFull 
    call _HomeUp 
    ld hl, DETAIL_Na_LINE1 
    call _PutS 
    call _NewLine 
    ld hl, DETAIL_Na_LINE2 
    call _PutS 
    call _NewLine
    ld hl, DETAIL_Na_LINE3 
    call _NewLine 

    ld hl, MSG_PROMPT_Na 
    call _PutS 
    call _NewLine 
    ld hl, MSG_PROMPT_CLEAR 
    call _PutS 
    
chemShowNa_wait: 
    call _getkey 
    cp kEnter 
    jr z, chemShowNa_store 
    cp kClear 
    ret
    jr chemShowNa_wait 
    
chemShowNa_store: 
    ld hl, CONST_Na_VALUE 
    call storeToVar_Na 
    call _ClrScrnFull 
    call _HomeUp 
    ld hl, MSG_STORED_Na 
    call _PutS 
    call _getkey 
    ret

; About page
dispAboutMenu:
    call _ClrScrnFull
    call _HomeUp
    ld hl, MSG_ABOUT
    call _PutS
    call _getkey
    ld a, MENU_MAIN
    ld (currentMenu), a
    xor a
    ld (currentItem), a
    jp dispatchMenu

; Data
HDR_MAIN:
    .db " CONSTANTS ", 0
MAIN_ITEM0:
    .db "Physics", 0
MAIN_ITEM1:
    .db "Chemistry", 0
MAIN_ITEM2:
    .db "About", 0
INSTR_MAIN_LINE1:
    .db "Arrows/1-3, ENTER=sel", 0
INSTR_MAIN_LINE2:
    .db "CLEAR=quit", 0

HDR_PHYSICS:
    .db " PHYSICS ", 0
PHYS_ITEM0:
    .db "c (speed of light)", 0
PHYS_ITEM1:
    .db "h (Planck)", 0
PHYS_ITEM2:
    .db "G (gravitational)", 0
INSTR_DETAIL_LINE1:
    .db "Arrows/1-3, ENTER=view", 0
INSTR_DETAIL_LINE2:
    .db "and store to var", 0

DETAIL_C_LINE1:
    .db "c = 2.998E8 m/s", 0
DETAIL_C_LINE2:
    .db "Speed of light", 0
DETAIL_C_LINE3:
    .db "in vacuum", 0

DETAIL_H_LINE1:
    .db "h = 6.626E-34 J*s", 0
DETAIL_H_LINE2:
    .db "Planck's constant", 0
DETAIL_H_LINE3:
    .db "", 0

DETAIL_G_LINE1:
    .db "G = 6.674E-11", 0
DETAIL_G_LINE2:
    .db "N*m^2/kg^2", 0
DETAIL_G_LINE3:
    .db "Gravitational const", 0

MSG_STORED_C:
    .db "Stored to var C!", 0
MSG_STORED_H:
    .db "Stored to var H!", 0
MSG_STORED_G:
    .db "Stored to var G!", 0

MSG_PROMPT_C:
    .db "ENTER to store to C", 0
MSG_PROMPT_H:
    .db "ENTER to store to H", 0
MSG_PROMPT_G:
    .db "ENTER to store to G", 0
MSG_PROMPT_CLEAR:
    .db "CLEAR to cancel", 0

MSG_ABOUT:
    .db "This is a custom menu for the unused F5 key. Hope you enjoy!", 0 

HDR_CHEMISTRY: 
    .db " CHEMISTRY ", 0
CHEM_ITEM0: 
    .db "c (speed of light)", 0
CHEM_ITEM1: 
    .db "h (Planck)", 0
CHEM_ITEM2: 
    .db "Na (Avogadro)", 0 

DETAIL_Na_LINE1: 
    .db "Na = 6.022E23", 0 
DETAIL_Na_LINE2: 
    .db "Avogadro's number", 0 
DETAIL_Na_LINE3: 
    .db "", 0

MSG_STORED_Na:
    .db "Stored to var N!", 0 

MSG_PROMPT_Na: 
    .db "ENTER to store to N", 0 

; Constant values 
; Format: [sign][exp+80h][14-digit BCD mantissa]
; c = 299792458 = 2.99792458E8
CONST_C_VALUE:
    .db 00h	; Positive
    .db 88h	; Exponent: 8 + 80h = 88h
    .db 29h, 97h, 92h, 45h, 80h, 00h, 00h	; 2.9979245800000

; h = 6.62607015E-34
CONST_H_VALUE:
    .db 00h        
    .db 5Eh       
    .db 66h, 26h, 07h, 01h, 50h, 00h, 00h 

; G = 6.67430E-11
CONST_G_VALUE:
    .db 00h         
    .db 75h        
    .db 66h, 74h, 30h, 00h, 00h, 00h, 00h 

; Na = 6.02214076E23
CONST_Na_VALUE: 
    .db 00h        
    .db 97h       
    .db 60h, 22h, 14h, 07h, 60h, 00h, 00h 

endHook:

.end
