;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Golden Mushroom
;;
;; Description: A golden mushroom that gives Mario certain number
;; of coins (50 by default). It stays in place if it is placed on
;; the ground, but it moves to the right if it is placed in the
;; air. It can also be spawned from ? Blocks.
;;
;; Uses the Extra Bit?: No
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Coins = 50			; The number of coins to give Mario when he touches the sprite.

macro CallJSR(address)
LDA #$81			; Loads the bank number.
PHA				; Preserves the Accumulator.
PLB				;\
PHK				;/ Changes the Data Bank.
PEA ?END-$01			; Branches if the address jumped to finishes its routine.
PEA $8020			; Preserves a Return address.
JML <address>			; Jumps to the address specified in the macro argument.
?END:
PHK				;\
PLB				;/ Restores the Data Bank.
endmacro

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
INC $C2,x			; Increments the sprite state. (It does not move.)
RTL				; Ends the code.

PRINT "MAIN ",pc
PHB				;\  
PHK				; | Changes the Data Bank to the one the sprite code runs from.
PLB				; | Makes certain sprite tables work properly.
JSR SPRITECODE			; | Jumps to the sprite code.
PLB				; | Restores the old Data Bank.
RTL				;/ Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;

SPRITECODE:
LDA $64				;\
PHA				;/ Loads and preserves the property byte.
JSR INTERACTION			; Jumps to the Mario interaction routine.
LDA $1540,x			;\
BEQ NOTINQUESTIONBLOCK		;/ Branches if the spawn from ? Block timer is 0.
JSL $819138			; Makes the sprite interact with objects.
LDA $1528,x			;\
BNE INFLYINGQUESTIONBLOCK	;/ Branches if the sprite is being spawned from a Flying ? Block.
LDA #$10			;\
STA $64				;/ Sets the property byte for the sprite.

INFLYINGQUESTIONBLOCK:
LDA $9D				; Loads the lock animation and sprites flag.
BNE LOCKED			; Branches if the sprite is locked.
LDA #$FC			; Loads the Y speed for the sprite.
STA $AA,x			; Stores the Y speed.
JSL $81801A			; Applies the Y speed without gravity.
LOCKED:
JMP NOTTOUCHINGWALL		; Jumps to the not touching wall routine.

NOTINQUESTIONBLOCK:
LDA $9D				; Loads the lock animation and sprites flag.
BNE LOCKED			; Branches if the sprite is locked.
LDA $14C8,x			;\
CMP #$0C			; | Branches if the sprite is a powerup from being carried past a Goal Tape.
BEQ LOCKED			;/
INC $1570,x			; Increments a frame counter sprite table.
JSR GETXSPEED			; Jumps to the X speed routine.
LDA $151C,x			;\
BNE ROULETTE			;/ Branches if sprite is the power-up roulette sprite.
STZ $B6,x			; Sets the sprite's X speed to zero.

ROULETTE:
LDA $C2,x			;\
BEQ MOVING			;/ Branches if the sprite state is 0. (It is moving.)
BMI NEGATIVE			; Branches if the sprite state is negative.
%CallJSR($819140)		; Jumps to the object interaction routine.
LDA $1588,x			; Loads the sprite blocked status table. 
BNE NEGATIVE			; Branches if the table is more than 0.
STZ $C2,x			; Sets the sprite state to 0.
NEGATIVE:
BRA OBJECTINTERACT		; Branches to the object interaction routine.

MOVING:
STZ $1588,x			; Sets the sprite blocked status table to 0.
STZ $B6,x			; Sets the sprite's X speed to 0.
JSR GETXSPEED			; Jumps to the X speed routine.
BIT $0D9B			;\
BVC GRAVITY			;/ Branches if the overflow flag of the IRQ/NMI behavior flag is cleared. (The sprite is not in the Bowser Battle room.)
LDA $14D4,x			;\
BNE APPLYSPEED			;/ Branches if the high byte of the sprite's Y position is not 0.
LDA $D8,x			;\
CMP #$A0			; | Branches if the sprite's Y position is less than -96.
BCC APPLYSPEED			;/
AND #$F0			;\
STA $D8,x			;/ Sets the Y position to multiple of 16.
LDA $1588,x			;\
ORA #$04			; | Sets the sprite to act like it is on the ground.
STA $1588,x			;/
APPLYSPEED:
JSL $818022			; Applies the X speed without gravity.
JSL $81801A			; Applies the Y speed without gravity.
INC $AA,x			;\
INC $AA,x			; | Increments the sprite's Y speed 3 times.
INC $AA,x			;/
BRA DECREASEYSPEED		; Branches to the decrease Y speed routine.

GRAVITY:
JSL $81802A			; Applies the speed with gravity.

DECREASEYSPEED:
LDA $13				; Loads the frame counter.
AND #$03			;\
BEQ OBJECTINTERACT		;/ Branches if 4 frames have not passed.
DEC $AA,x			; Decrements the sprite's Y speed.

OBJECTINTERACT:
LDA #$00			;\
%SubOffScreen()			;/ Jumps to the off screen handler.
LDA $1588,x			; Loads the sprite blocked status table.
AND #$08			; Sets the bits if the sprite is touching a wall.
BEQ NOTTOUCHINGCEILING		; Branches if the sprite is not touching a wall.
STZ $AA,x			; Sets the sprite's Y speed to 0.

NOTTOUCHINGCEILING:
LDA $1588,x			; Loads the sprite blocked status table.
AND #$04			; Sets the bits if the sprite is on the ground.
BNE ONGROUND			; Branches if the sprite is on the ground.
STZ $C2,x			; Sets the sprite state to 0.
BRA NOTONGROUND			; Branches to the not on ground routine.

ONGROUND:
%CallJSR($819A04)		; Jumps to the set Y speed routine.

NOTONGROUND:
LDA $1558,x			; Loads an unused timer to disable side interaction.
ORA $C2				; Sets the bits for the sprite state.
BNE NOTTOUCHINGWALL		; Branches if the both the timer and sprite state are more than 0. (It is not moving.)
LDA $1588,x			; Loads the sprite blocked status table.
AND #$03			; Sets the bits if the sprite is touching a wall.
BEQ NOTTOUCHINGWALL		; Branches if the sprite is not touching a wall.
LDA $157C,x			;\
EOR #$01			; | Flips the sprite's direction.
STA $157C,x			;/
LDA $B6,x			;\
EOR #$F0			; | Inverts the sprite's X speed to prevent a bug where if the sprite is ascending in the air, it clips into the wall.
STA $B6,x			;/

NOTTOUCHINGWALL:
LDA $1540,x			;\
CMP #$36			; | Branches if the ? Block timer is more than 54.
BCS RESTOREPROPERTYBYTE		;/
LDA $C2,x			;\
BEQ STATE0			;/ Branches if the sprite state is 0. (It is moving.)
CMP #$FF			;\
BNE NOTNEGATIVE			;/ Branches if the sprite state is not -1.

STATE0:
LDA $1632,x			;\
BEQ DRAWGFX			;/ Branches if the sprite is behind scenery flag is 0.

NOTNEGATIVE:
LDA #$10			;\
STA $64				;/ Sets the property byte for the sprite.

DRAWGFX:
JSR GRAPHICS			; Jumps to the graphics routine.

RESTOREPROPERTYBYTE:
PLA				; Pulls back the Accumulator.
STA $64				; Stores the original property byte.
RTS				; Ends the code.

GETXSPEED:
LDY $157C,x			; Loads the direction into the Y Register.
LDA XSPEED,y			; Loads the speed indexed by the Y Register.
STA $B6,x			; Stores the speed to the X speed table.
RTS				; Ends the code.

INTERACTION:
JSL $81A7DC			; Jumps to the sprite interaction with Mario.
BCC NOCONTACT			; Returns if Mario is not touching the sprite.
LDA $151C,x			;\
BEQ PROCESSINTERACTION		;/ Branches if the sprite is the power-up roulette sprite.
LDA $C2,x			;\
BNE NOCONTACT			;/ Branches if the sprite is more than 0. (It is moving.)
PROCESSINTERACTION:
LDA $154C,x			;\
BNE NOCONTACT			;/ Branches if the disable interaction timer is more than 0.
LDA $1540,x			;\
CMP #$18			; | Branches if the spawn from ? Block timer is 24 or more.
BCS NOCONTACT			;/

;;;;;;;;;;;;;;;;;;;;;;;
; Mario Contact
;;;;;;;;;;;;;;;;;;;;;;;

LDA $13CC			;\
CLC				; |
ADC #!Coins			; | Gives Mario the configured number of coins.
STA $13CC			;/
LDA #$01			;\
STA $1DFC			;/ Sets the sound to play.
STZ $14C8,x			; Erases the sprite.

;;;;;;;;;;;;;;;;;;;;;;;
; No Contact
;;;;;;;;;;;;;;;;;;;;;;;

NOCONTACT:
RTS				; Ends the code.

XSPEED: db $10,$F0

;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

PROPERTIES: db $4E,$0E

GRAPHICS:
%GetDrawInfo()			; Jumps to the OAM handler.

LDA $157C,x			; Loads the sprite direction table into the X Register.
STA $02				; Stores it into scratch RAM.

LDA $00				;\
STA $0300,y			;/ Draws the X position of the sprite.

LDA $01				;\
DEC				; | Draws the Y position of the sprite.
STA $0301,y			;/

LDA #$24			;\
STA $0302,y			;/ Loads the tile to draw.

PHX				; Preserves the X register.
LDX $02				; Loads the direction stored in scratch RAM in the X Register.
LDA PROPERTIES,x		;\
ORA $64				;/ Loads the property byte indexed by the X Register.
STA $0303,y			; Stores the property byte.
PLX				; Pulls back the X register.

LDY #$02			; Loads the sprite tile size.
LDA #$00			; Loads the number of tiles drawn -1.

JSL $81B7B3			; Calls the routine that draws the sprite.
RTS				; Ends the code.	