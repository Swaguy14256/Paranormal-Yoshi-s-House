;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Snowflake
;;
;; Description: A snowflake that freezes Mario if he touches it.
;; When it freezes him, it changes into an ice block sprite.
;; The ice block sprite requires uberASM in order to be spawned.
;; The stun timer can also be configured.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!StunTimer = $40	; The amount of time to stun Mario for when he touches this sprite.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

print "MAIN ",pc
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
LDA $9D			; Loads the lock animation and sprites flag.
BNE RETURN		; Branches if the sprite is locked.
%SpeedY()		; Applies the sprite's Y speed.
%SpeedX()		; Applies the sprite's X speed.
JSL FIREBALLCONTACT	; Jumps to the fireball contact routine.
BCC NOCONTACT		; Branches if there is no contact.
LDA #$03                ;\
STA $1DF9               ;/ Sets the sound to play.
LDA #$0F                ;\
STA $1777,y             ;/ Sets the smoke timer.
LDA #$01               	;\
STA $1713,y		;/ Turns the fireball into a puff of smoke.
STZ $170B,x		; Destroys the extended sprite.
NOCONTACT:
%ExtendedFreeze()	; Makes the sprite interact with Mario and freezes him if in contact with it.
RTS			; Ends the code.

FIREBALLCONTACT:
PHX			; Preserves the X Register.
LDY #$00		; Resets the fireball index.
FIREBALLLOOP:
LDA $1713,y		;\
CMP #$05		; | Branches if the extended sprite is not a fireball.
BNE NOFIREBALLS		;/
LDA $1727,y		;\
SEC			; |
SBC #$02		; |
STA $00			; | Stores the X position of the fireball collision.
LDA $173B,y		; |
SBC #$00		; |
STA $08			;/
LDA #$0C		;\
STA $02			;/ Sets the width of the fireball collision.
LDA $171D,y		;\
SEC			; |
SBC #$04		; |
STA $01			; | Stores the Y position of the fireball collision.
LDA $1731,y		; |
SBC #$00		; |
STA $09			;/
LDA #$13		;\
STA $03			;/ Sets the height of the fireball collision.
PHY			; Preserve the fireball index.
JSL SNOWFLAKECLIPPING	; Jumps to the snowflake clipping routine.
JSL $83B72B		; Jumps to the check contact routine.
BCS FIREBALLCONTACT2	; Branches if there is contact.
PLY			; Pulls back the fireball index.
NOFIREBALLS:
CPY #$00		;\
BNE NOFIREBALLS2	;/ Branches if 2 or more fireballs were checked.
INY			; Increments the fireball index.
BRA FIREBALLLOOP	; Loops to recheck the fireball contact routine.
FIREBALLCONTACT2:
PLY			; Pulls back the fireball index.
PLX			; Pulls back the X register.
SEC			; Sets the carry flag.
RTL			; Ends the code.
NOFIREBALLS2:
LDY #$FF		; Sets the fireball index to 255.
PLX			; Pulls back the X register.
CLC			; Clears the carry flag.
RTL			; Ends the code.

SNOWFLAKECLIPPING:
LDA $171F,x		;\
STA $04			; | Sets the X position of the clipping.
LDA $1733,x		; |
STA $0A			;/
LDA #$0C		;\
STA $06			;/ Sets the width of the clipping.
LDA $1715,x		;\
STA $05			; | Sets the Y position of the clipping.
LDA $1729,x		; |
STA $0B			;/
LDA #$0A		;\
STA $07			;/ Sets the height of the clipping.
RTL			; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

GRAPHICS:
%ExtendedGetDrawInfo()	; Jumps to the extended sprite OAM handler.

LDA $01			;\
STA $0200,y		;/ Draws the X position of the sprite.

LDA $02			;\
DEC			; | Draws the Y position of the sprite.
STA $0201,y		;/

LDA #$E4		;\
STA $0202,y		;/ Loads the tile to draw.

LDA #$0D		;\
ORA $64			;/ Loads the property byte.
STA $0203,y		; Stores the property byte.

TYA			; Transfers the Y Register to the Accumulator.
LSR			;\
LSR			;/ Shifts the bits to the right twice.
TAY			; Transfers the Accumulator to the Y Register.
LDA #$02		;\ Loads and stores the sprite tile size.
STA $0420,y		;/
RTS			; Ends the code.

print "CAPE",pc
RTL			; Ends the code.