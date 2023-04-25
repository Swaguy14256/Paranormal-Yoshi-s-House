;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Large Fireball
;;
;; Description: A Fireball that moves horizontally towards Mario.
;; If the extra bit is set, then it will disappear when it hits
;; an object.
;; 
;; Uses the Extra Bit?: Yes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
LDA #$17		;\
STA $1DFC		;/ Sets the sound to play.
LDA $C2,x		;\
BNE NOFACING		;/ Branches if the sprite is spawned from a shooter.
%SubHorzPos()		;\
TYA			; | Makes the sprite face Mario.
STA $157C,x		;/
NOFACING:
RTL			; Ends the code.

PRINT "MAIN ",pc
PHB			;\  
PHK			; | Changes the Data Bank to the one the sprite code runs from.
PLB			; | Makes certain sprite tables work properly.
JSR SPRITECODE		; | Jumps to the sprite code.
PLB			; | Restores the old Data Bank.
RTL			;/ Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;

RETURN:
RTS			; Ends the routine.

SPRITECODE:
JSR GRAPHICS		; Jumps to the graphics routine.

LDA $14C8,x		; Loads the sprite status table.
CMP #$08		; Checks if the sprite is alive.
BNE RETURN		; Branches if the sprite is dead.
LDA $9D			; Loads the lock animation and sprites flag.
BNE RETURN		; Branches if the sprite is locked.

%SubOffScreen()		; Jumps to the off screen handler.

LDA $7FAB10,x		;\
AND #$04		; | Branches if the extra bit is not set.
BEQ NOEXTRABIT		;/
JSL $819138		; Interacts with objects.
LDA $151C,x		;\
BEQ NOGRAVITY		;/ Branches if the gravity flag is disabled.
JSL $81802A		; Applies the speed with gravity.
NOGRAVITY:
LDA $1588,x		;\
BEQ NOEXTRABIT		;/ Branches if the sprite is not hitting an object.
STZ $00			;\
STZ $01			; |
LDA #$1B		; | Jumps to the draw smoke routine.
STA $02			; |
LDA #$01		; |
%SpawnSmoke()		;/
LDA #$01		;\
STA $1DF9		;/ Sound to play.
STZ $14C8,x		; Kills the sprite.
NOEXTRABIT:
LDA $1504,x		;\
BNE CUSTOMSPEED		;/ Branches if the custom X speed flag is disabled.
LDY $157C,x		; Loads the direction into the Y Register.
LDA XSPEED,y		; Loads the speed indexed by the Y Register.
STA $B6,x		; Stores the speed to the X speed table.
CUSTOMSPEED:
LDA $1510,x		;\
BEQ KEEPYVELOCITY	;/ Branches if the negative Y acceleration flag is disabled.
LDA $AA,x		;\
BEQ ZEROY		;/ Branches if the sprite's Y speed is 0.
DEC A			;\
STA $AA,x		;/ Decrements the sprite's Y speed.
BRA KEEPYVELOCITY	; Branches to the apply Y speed routine.
ZEROY:
STZ $AA,x		; Sets the sprite's Y speed to 0.
KEEPYVELOCITY:
LDA $151C,x		;\
BNE GRAVITY		;/ Branches if the gravity flag is enabled.
JSL $818022		;\
JSL $81801A		;/ Applies the speed without gravity.
GRAVITY:
JSL $81A7DC		; Jumps to the sprite interaction with Mario.
RTS			; Ends the code.

XSPEED: db $20,$E0

;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

TILEMAP: db $EC,$EA,$EC,$EA

PROPERTIES: db $05,$C5,$C5,$05

GRAPHICS:
%GetDrawInfo()		; Jumps to the OAM handler.

LDA $157C,x		; Loads the sprite direction table into the X Register.
STA $02			; Stores it into scratch RAM.

LDA $00			;\
STA $0300,y		;/ Draws the X position of the sprite.

LDA $01			;\
DEC			; | Draws the Y position of the sprite.
STA $0301,y		;/

PHX			; Preserves the X register.
LDA $14			; Loads the animation frame counter.
LSR
AND #$03		; Sets the number of frames the sprite uses -1.
TAX			; Transfers the Accumulator into the X Register.
LDA TILEMAP,x		;\
STA $0302,y		;/ Loads the tilemap table and draws the tiles in the table.

LDA PROPERTIES,x	; Loads the property byte table indexed by the X Register.
LDX $02			; Loads the direction stored in scratch RAM in the X Register.
BNE NOTXFLIPPED		; Branches if the sprite's direction is not X flipped.
EOR #$40		; X flips the properties of the sprite.
NOTXFLIPPED:
ORA $64			;\
STA $0303,y		;/ Stores the property byte.
PLX			; Pulls back the X register.

LDY #$02		; Loads the sprite tile size.
LDA #$00		; Loads the number of tiles drawn -1.

JSL $81B7B3		; Calls the routine that draws the sprite.
RTS			; Ends the code.