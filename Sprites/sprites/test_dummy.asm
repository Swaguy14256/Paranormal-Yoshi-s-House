;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Dummy
;;
;; Description: A dummy that walks back and forth, jumping every 
;; 3 and a half seconds. It takes certain number of hits (5 by
;; default) to destroy and disappears in a puff of smoke.
;;
;; Uses the Extra Bit?: No
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!HP = $05		; The Hit Points for the Test Dummy.
!JumpSFX = $01		; The sound to use when the sprite jumps.
!JumpSFXBank = $1DFA	; The sound bank for the jump sound.

;;;;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
LDA #!HP		;\
STA $1528,x		;/ Sets the sprite's Hit Points.
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

;;;;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;;;;

LEFTSPD: db $00,$E8,$EB,$EF,$F4,$F8
RIGHTSPD: db $00,$18,$15,$11,$0C,$08

RETURN:
RTS			; Ends the routine.

SPRITECODE:
LDA $154C,x		;\
BEQ GFX			;/ Branches if the hit invincibility timer is not running.
LSR			;\
LSR			; |
AND #$01		; | Skips the GFX routine every eight frames.
BNE SKIPGFX		;/ 
GFX:
JSR GRAPHICS		; Jumps to the graphics routine.
SKIPGFX:
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

LDA $B6,x		;\
EOR #$FF		; | Inverts the sprite's X speed to prevent a bug where if the sprite jumps, it clips into the wall.
INC A			; |
STA $B6,x		;/

NOTTOUCHINGWALL:
LDA $1588,x		;\
AND #$08		; | Branches if the sprite is touching the ceiling.
BEQ UNDERTHECEILING	;/
STZ $AA,x		; Resets the Y speed to 0.

UNDERTHECEILING:
LDY $1528,x		;\
LDA $157C,x		; |
BEQ RIGHT		; |
LDA LEFTSPD,y		; | Loads the X speed indexed by the number of Hit Points remaining.
BRA SPEED		; |
RIGHT:			; |
LDA RIGHTSPD,y		;/
SPEED:
STA $B6,x		; Stores the speed to the X speed table.

LDA $1588,x		; Loads the sprite blocked status table.
AND #$04		; Sets the bits if the sprite is on the ground.
BEQ NOTONGROUND		; Branches if the sprite is in the air.
LDA #$10		; Loads the Y speed for the sprite on the ground.
STA $AA,x		; Stores the Y speed.

NOTONGROUND:
JSL $81802A		; Applies the speed with gravity.
LDA $1588,x		; Loads the sprite blocked status table.
AND #$04		; Sets the bits if the sprite is on the ground.
BEQ SHARED		; Branches if the sprite is in the air.
LDA $1594,x		;\
CMP #$D5		; | Branches if 3 1/2 seconds have passed.
BEQ TIMETOJUMP		;/
INC $1594,x		; Increments the sprite table every frame.
BRA SHARED		; Branches to the contact routine.

TIMETOJUMP:
LDA #$C0		;\
STA $AA,x		; | Sets the Y speed of the sprite.
JSL $81802A		;/
LDA #!JumpSFX		;\ Sets the sound to play.
STA !JumpSFXBank	;/ Unless you fix and make $1DFA sounds not conflict with $1DFC and $1DF9 sounds, use the jump sounds in $1DF9 and $1DFC if AddmusicK is installed in the ROM.
STZ $1594,x		; Clears the sprite table.

SHARED:
JSL $818032		; Makes the sprite interact with others.
JSL $81A7DC		; Jumps to the sprite interaction with Mario.
BCC NOCONTACT		; Returns if Mario is not touching the sprite.

%SubVertPos()		; Checks Mario and the sprite's vertical position.
LDA $154C,x		;\
BNE NOCONTACT		;/ Branches if the sprite invincibility timer is running.
LDA $0E			;\
CMP #$EC		;/ Checks if Mario is hitting the sprite from the top side.
BPL SPRITEWINS		; Branches if he is touching from any side but the top.
LDA $7D			;\
BMI NOCONTACT		;/ Branches if Mario's Y speed is negative.

;;;;;;;;;;;;;;;;;;;;;;;;;
; Mario Hurts The Sprite
;;;;;;;;;;;;;;;;;;;;;;;;;

JSL $81AB99		; Displays the star smash graphic.
JSL $81AA33		;\
LDA #$A0		; | Sets Mario's Y speed.
STA $7D			; |
JSL $81802A		;/
HURTSPRITE:
LDA #$2F		;\ Makes the sprite invincible for a bit.
STA $154C,x		;/
LDA #$13		;\
STA $1DF9		; |
LDA #$28		; | Sets the sounds to play.
STA $1DFC		;/
DEC $1528,x		; Decrements the sprite's Hit Points.
LDA $1528,x		;\
BEQ KILLSPRITE		;/ Branches if the sprite has no more Hit Points.
RTS			; Ends the routine

KILLSPRITE:
LDA #$08		;\
STA $00			;/ Sets the X offsets of the smoke.
LDA #$08		;\
STA $01			;/ Sets the Y offsets of the smoke.
LDA #$1B		;\
STA $02			;/ Sets the timer for the smoke sprite.
LDA #$01		;\
%SpawnSmoke()		;/ Jumps to the draw smoke routine.
LDA $1697		;\
CLC			; | Increases the number of consecutive enemies stomped.
ADC $1626,x		; |
INC $1697		;/
LDA $1697		;\
CMP #$08		; | Branches if the number of consecutive enemies stomped is less than 8.
BCC FEWERTHANEIGHT	;/
LDA #$08		;\ Keeps the number killed at 8.
STA $1697		;/
FEWERTHANEIGHT:
JSL $82ACE5		; Gives Mario points.
STZ $14C8,x		; Kills the sprite.
RTS			; Ends the routine.

;;;;;;;;;;;;;;;;;;;;;;;;;
; The Sprite Hurts Mario
;;;;;;;;;;;;;;;;;;;;;;;;;

SPRITEWINS:
LDA $1490		;\
BNE NOCONTACT		;/ Branches if Mario is under the effect of a Star.
JSL $80F5B7		; Hurts Mario.
NOCONTACT:
RTS			; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;;;;


PROPERTIES: db $4B,$0B

TILEMAP: db $E0,$E2,$E4,$E6
	 db $E8,$EA,$EC,$EE

	 db $E0,$E2,$E4,$E6
	 db $E8,$EA,$EC,$EE

YDISP:	db $00,$00,$10,$10

	db $00,$00,$10,$10

	db $00,$00,$10,$10
	db $00,$00,$10,$10

XDISP:	db $00,$10,$00,$10
	db $00,$10,$00,$10

	db $10,$00,$10,$00
        db $10,$00,$10,$00

GRAPHICS:
%GetDrawInfo()		; Jumps to the OAM handler.

LDA $14			; Loads the animation frame counter.
LSR			;\
LSR			; | Reduces the animation speed.
LSR			;/
AND #$01		; Sets the number of frames the sprite uses -1.
ASL A			;\
ASL A			;/ Makes the frame counter switch between the first and fifth bytes.
STA $03			; Stores the counter into scratch RAM.

LDA $157C,x		; Loads the sprite direction table into the X Register.
STA $02			; Stores it into scratch RAM.
BNE NOADD		; Branches if the sprite faces right.
LDA $03			;\
CLC			; |
ADC #$08		; | Adds 8 more bytes to the frame counter.
STA $03			;/

NOADD:
PHX			; Preserves the X Register.
LDX #$03		; Loads the number of times to loop the graphics routine.

LOOP:
PHX			; Preserves the X register.
TXA			;\
ORA $03			;/ Transfers the frame counter to the Accumulator and adds in the "left displacement" if it is necessary.
TAX			; Transfers the Accumulator back into the X Register.

LDA $00			;\
CLC			; |
ADC XDISP,x		; | Draws the X displacement of the sprite.
STA $0300,y		;/

LDA $01			;\
CLC			; |
ADC YDISP,x		; | Draws the Y displacement of the sprite.
STA $0301,y		;/

LDA TILEMAP,x		;\
STA $0302,y		;/ Loads the tilemap table and draws the tiles in the table.

PHX			; Preserves the X register.
LDX $02			; Loads the direction stored in scratch RAM in the X Register.
LDA PROPERTIES,x	; Loads the property byte table indexed by the X Register.
ORA $64			;\
STA $0303,y		;/ Stores the property byte.
PLX			; Pulls back the X register.

INY			;\
INY			; | Increments the OAM to prevent the tiles from overwriting each other.
INY			; |
INY			;/

PLX			; Pulls back the X register.
DEX			; Decreases the number of times to loop the graphics routine.

BPL LOOP		; Loops until the X Register is a negative value.
PLX			; Pulls back the X register.

LDY #$02		; Loads the sprite tile size.
LDA #$03		; Loads the number of tiles drawn -1.

JSL $81B7B3		; Calls the routine that draws the sprite.
RTS			; Ends the code.