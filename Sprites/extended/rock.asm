;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rock
;;
;; Description: A rock that falls and shatters when it hits the
;; ground. It will hurt Mario if he touches it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "MAIN ",pc
PHB				;\  
PHK				; | Changes the Data Bank to the one the sprite code runs from.
PLB				; | Makes certain sprite tables work properly.
JSR SPRITECODE			; | Jumps to the sprite code.
PLB				; | Restores the old Data Bank.
RTL				;/ Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;

RETURN:
RTS				; Ends the routine.

SPRITECODE:
JSR GRAPHICS			; Jumps to the graphics routine.
LDA $9D				; Loads the lock animation and sprites flag.
BNE RETURN			; Branches if the sprite is locked.
%Speed()			; Applies the sprite's Y speed.
%ExtendedBlockInteraction()	; Makes the sprite interact with objects.
BCC INTERACT			; Branches if the sprite is in the air.
LDA $171F,x			;\
STA $9A				; |
LDA $1733,x			; |
STA $9B				; | Stores the sprite's X and Y positions into the block's X and Y positions.
LDA $1715,x			; |
STA $98				; |
LDA $1729,x			; |
STA $99				;/
PHB				;\
LDA #$82			; |
PHA				; | Changes the Data Bank to 2. (82 on FastROM.)
PLB				;/
LDA #$00			;\
JSL $828663			;/ Jumps to the exploding block routine.
PLB				; Restores the old Data Bank.
STZ $170B,x			; Destroys the extended sprite.
RTS				; Ends the code.
INTERACT:
%ExtendedHurt()			; Makes the sprite interact with Mario and hurts him if in contact with it.
RTS				; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

GRAPHICS:
%ExtendedGetDrawInfo()		; Jumps to the extended sprite OAM handler.

LDA $01				;\
STA $0200,y			;/ Draws the X position of the sprite.

LDA $02				;\
DEC				; | Draws the Y position of the sprite.
STA $0201,y			;/

LDA #$CE			;\
STA $0202,y			;/ Loads the tile to draw.

LDA #$0D			;\
ORA $64				;/ Loads the property byte.
STA $0203,y			; Stores the property byte.

TYA				; Transfers the Y Register to the Accumulator.
LSR				;\
LSR				;/ Shifts the bits to the right twice.
TAY				; Transfers the Accumulator to the Y Register.
LDA #$02			;\ Loads and stores the sprite tile size.
STA $0420,y			;/
RTS				; Ends the code.

print "CAPE",pc
STZ $00				; Sets the X offset of the clipping.
LDA #$0C			;\
STA $01				;/ Sets the width of the clipping.
STZ $02				; Sets the Y offset of the clipping.
LDA #$0A			;\
STA $03				;/ Sets the height of the clipping.
%ExtendedCapeClipping()		; Jumps to the extended cape clipping routine.
BCC NOCAPE			; Branches if there is no contact.
LDA $171F,x			;\
STA $9A				; |
LDA $1733,x			; |
STA $9B				; | Stores the sprite's X and Y positions into the block's X and Y positions.
LDA $1715,x			; |
STA $98				; |
LDA $1729,x			; |
STA $99				;/
PHB				;\
LDA #$82			; |
PHA				; | Changes the Data Bank to 2. (82 on FastROM.)
PLB				;/
LDA #$00			;\
JSL $828663			;/ Jumps to the exploding block routine.
PLB				; Restores the old Data Bank.
STZ $170B,x			; Destroys the extended sprite.
NOCAPE:
RTL			; Ends the code.