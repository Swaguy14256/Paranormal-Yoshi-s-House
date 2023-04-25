;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defused Bob-omb
;;
;; Description: A Bob-omb that walks back and forth like a
;; Goomba, save for fireballs making it explode.
;;
;; Uses the Extra Bit?: No
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
%SubHorzPos()		;\
TYA			; |
STA $157C,x		; | Makes the sprite face Mario.
RTL			;/ Ends the code.

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

XSPEED: db $08,$F8

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

LDA $1588,x		; Loads the sprite blocked status table.
AND #$03		; Sets the bits if the sprite is touching a wall.
BEQ NOTTOUCHINGWALL	; Branches if the sprite is not touching a wall.

LDA $157C,x		;\
EOR #$01		; | Flips the sprite's direction.
STA $157C,x		;/

NOTTOUCHINGWALL:
LDY $157C,x		; Loads the direction into the Y Register.
LDA XSPEED,y		; Loads the speed indexed by the Y Register.
STA $B6,x		; Stores the speed to the X speed table.

LDA $1588,x		; Loads the sprite blocked status table.
AND #$04		; Sets the bits if the sprite is on the ground.
BEQ NOTONGROUND		; Branches if the sprite is in the air.
LDA #$10		; Loads the Y speed for the sprite on the ground.
STA $AA,x		; Stores the Y speed.

NOTONGROUND:
JSL $81802A		; Applies the speed with gravity.
JSL $818032		; Makes the sprite interact with others.
JSR CHECK_FIREBALL	; Jumps to the fireball contact routine.
LDA $04			;\
BEQ NOFIRECONTACT	;/ Branches if there is no contact.
LDA $157C,x		;\
BEQ RIGHT		;/ Branches if the sprite is facing right.
LDA #$0D		;\
STA $9E,x		;/ Turns the sprite into a Bob-omb.
LDA #$09		;\
STA $14C8,x		;/ Stuns the sprite.
JSL $87F7D2		; Resets the sprite tables.
LDA #$01		;\ Makes the sprite face left.
STA $157C,x		;/ There is a bug where the sprite always faces right when hit by a fireball. This fixes that.
BRA FUSE		; Branches to the timer routine.
RIGHT:
LDA #$0D		;\ Turns the sprite into a Bob-omb.
STA $9E,x		;/ This is repeated code because it is easier and more efficient to do this than to duplicate the Bob-omb sprite routines.
LDA #$09		;\ Stuns the sprite.
STA $14C8,x		;/ If I duplicated the Bob-omb sprite routines, it wastes space and it is literally duplicated code.
JSL $87F7D2		; Resets the sprite tables.
FUSE:
LDA #$40		;\ Sets the timer for the explosion.
STA $1540,x		;/
NOFIRECONTACT:
JSL $81A7DC		; Jumps to the sprite interaction with Mario.
RTS			; Ends the code.


;;;;;;;;;;;;;;;;;;;;;;
; Fireball Contact
;;;;;;;;;;;;;;;;;;;;;;

CHECK_FIREBALL:
PHX			;\ Preserves the X and Y Registers.
PHY			;/
LDY #$00		; Resets the fireball index.
FIRELOOP:
LDA $1713,y		;\
CMP #$05		; | Branches if there are no fireballs.
BNE NOTHING		;/
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
PHY			; Pushes the fireball index.
JSL $83B69F 		;\ Gets the sprite clippings for the sprite.
JSL $83B72B 		;/
BCS FOUNDFIRE		; Branches if a fireball is touching the sprite.
PLY			; Pulls back the fireball index.
NOTHING:
CPY #$00		;\
BNE NOFIRE		;/ Branches if 2 or more fireballs were checked.
INY			; Increments the fireball index.
BRA FIRELOOP		; Loops to recheck the fireball contact routine.
FOUNDFIRE:
PLY			; Pulls back the fireball index.
INY			;\
INY			; |
INY			; |
INY			; | Increments the Y Register 8 times to load the fireballs.
INY			; |
INY			; |
INY			; |
INY			;/
;LDA $1713,y		; Loads the fireballs.
TYX			; Transfers the Y Register to the X Register.
PHK			;
PEA ENDJSR-1		; Branches if the address jumped to finishes its routine.
PEA $94F4-1		; Preserves a Return address.
JML $82A045		; Jumps to the destroy fireball routine.
ENDJSR:
PLX			; Pulls back the X register.
PLX			; Pulls back the X register again.
LDA #$01		;\
STA $04			;/ Sets the fireball contact flag to true.
RTS			; Ends the code.
NOFIRE:
PLY			;\
PLX			;/ Pulls back the X and Y registers.
LDA #$00		;\
STA $04			;/ Sets the fireball contact flag to false.
RTS			; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

TILEMAP: db $CC,$CA

PROPERTIES: db $47,$07

GRAPHICS:
%GetDrawInfo()		; Jumps to the OAM handler.

LDA $157C,x		; Loads the sprite direction table into the X Register.
STA $02			; Stores it into scratch RAM.

LDA $00			;\
STA $0300,y		;/ Draws the X position of the sprite.

LDA $01			;\
STA $0301,y		;/ Draws the Y position of the sprite.

PHX			; Preserves the X register.
LDA $14C8,x		;\
CMP #$08		; | Branches if the sprite is alive.
BCS ALIVE		;/
LDA #$CA		;\
STA $0302,y		;/ Loads the tile to draw.
BRA STOREPROPERTIES	; Branches to the property storing routine.
ALIVE:
LDA $14			; Loads the animation frame counter.
LSR			;\
LSR			; | Reduces the animation speed.
LSR			;/
AND #$01		; Sets the number of frames the sprite uses -1.
TAX			; Transfers the Accumulator into the X Register.
LDA TILEMAP,x		;\
STA $0302,y		;/ Loads the tilemap table and draws the tiles in the table.

STOREPROPERTIES:
LDX $02			; Loads the direction stored in scratch RAM in the X Register.
LDA PROPERTIES,x	;\ Loads the property byte table indexed by the X Register.
ORA $64			;/
STA $0303,y		; Stores the property byte.
PLX			; Pulls back the X register.

LDA $14C8,x		;\
CMP #$08		; | Branches if the sprite is alive.
BCS NOTDEAD		;/
LDA $0303,y		;\
ORA #$80		; | Y flips the sprite.
STA $0303,y		;/

NOTDEAD:
LDY #$02		; Loads the sprite tile size.
LDA #$00		; Loads the number of tiles drawn -1.

JSL $81B7B3		; Calls the routine that draws the sprite.
RTS			; Ends the code.