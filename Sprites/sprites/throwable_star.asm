;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Throwable Star
;;
;; Description: A star that follows Mario. It can be thrown with
;; the Y or X buttons in 8 directons and kills enemies that come
;; in contact with it (unless the enemy does not interact with
;; other sprites).
;;
;; Uses the Extra Bit?: No
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
LDA #$01			;\
STA $1534,x			;/ Sets a flag that indicates whether the sprite follows Mario or not.
LDA #$10			;\
STA $1DF9			;/ Sets the sound to play.
JSL FOLLOWMARIO			; Jumps to the follow Mario routine.
JSL SMOKE			; Jumps to a unique smoke spawn routine.
RTL				; Ends the code.
FOLLOWMARIO:
LDA $D3				;\
CLC 				; |
ADC #$10			; | Stores the player's Y position into the sprite's Y position
STA $D8,x			; | and offsets it by 10.
LDA $D4				; |
ADC #$00			; |
STA $14D4,x			;/
LDA $76				;\
BEQ RIGHT			;/ Branches if the player is facing right.
LDA $D1				;\
SEC				; |
SBC #$08			; |
STA $E4,x			; | Stores the player's X position when facing left into the
LDY $76				; | sprite's X position and offsets it by 8.
LDA $D2				; |
ADC OFFSETS,y			; |
STA $14E0,x			;/
BRA INITRETURN			; Branches to the end of the sprite initialization.
RIGHT:
LDA $D1				;\
CLC				; |
ADC #$08			; |
STA $E4,x			; | Stores the player's X position when facing right into the
LDY $76				; | sprite's X position and offsets it by 8.
LDA $D2				; |
ADC OFFSETS,y			; |
STA $14E0,x			;/
INITRETURN:
RTL				; Ends the code.

OFFSETS: db $00,$FF

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

XSPEED: db $C0,$40

RETURN:
RTS				; Ends the routine.

SPRITECODE:
LDA $1534,x			;\
BEQ SKIPFOLLOWING		;/ Branches if the follow Mario flag is 0.
JSL FOLLOWMARIO			; Jumps to the follow Mario routine.
LDA $1686,x			;\
ORA #$01			; | Makes the sprite inedible.
STA $1686,x			;/
SKIPFOLLOWING:
JSR GRAPHICS			; Jumps to the graphics routine.
LDA $9D				; Loads the lock animation and sprites flag.
BNE RETURN			; Branches if the sprite is locked.
%DisplaySparkle()		; Displays a sparkle effect on the sprite.

LDA $1534,x			;\
BEQ CONTACT			;/ Branches if the follow Mario flag is 0.
;LDA $1470			;\
;ORA $148F			; | Branches if Mario is carrying something or riding Yoshi.
;ORA $187A			; |
;BNE RETURN			;/
LDA $16				;\
AND #$40			; | Branches if the Y or X buttons are not pressed.
BEQ RETURN			;/
STZ $1534,x			; Sets the follow Mario flag to 0.
STZ $1626,x			; Clears the consecutive enemies killed by sprites table.
LDA #$0A			;\
STA $14C8,x			;/ Sets the sprite status to thrown/kicked.
LDA #$20			;\
STA $154C,x			;/ Sets a timer to disable contact with Mario.
LDA $D1				;\
STA $E4,x			; | 
LDA $D2				; | Stores the player's X position into the sprite's X position.
STA $14E0,x			;/
LDA $15				;\
AND #$08			; | Branches if up on the directional pad is pressed.
BNE THROWUP			;/
LDA $15				;\
AND #$04			; | Branches if down on the directional pad is pressed.
BNE THROWDOWN			;/
LDA $15				;\
AND #$03			; | Branches if left or right on the directional pad are not pressed.
BEQ STILL			;/
JSR MORESPEED			; Jumps to an X speed routine indexed by left or right on the directional pad.
BRA YSPEED			; Branches to the Y speed storage.
STILL:
LDY $76				; Loads Mario's direction into the Y Register.
LDA XSPEED,y			; Loads the speed indexed by the Y Register.
STA $B6,x			; Stores the speed to the X speed table.
YSPEED:
LDA #$E0			; Loads the Y speed for the sprite.
STA $AA,x			; Stores the Y speed.
BRA OBJECTINTERACTION		; Branches to the object interaction routine.

OBJECTINTERACTION:
JSL $819138			; Makes the sprite interact with objects.
LDA $14C8,x			;\
CMP #$08			; | Branches if the sprite is dead.
BCC NOCONTACT			;/
LDA #$10			;\
STA $1DF9			;/ Sets the sound to play.
CONTACT:
LDA $154C,x			;\
BNE TIMERISNOT0			;/ Branches if the disable contact with Mario timer is not 0.
LDA $1686,x			;\
AND #$FE			; | Makes the sprite edible and keeps any other settings.
STA $1686,x			;/

TIMERISNOT0:
LDA #$00			;\
%SubOffScreen()			;/ Jumps to the off screen handler.

LDA $14C8,x			;\
CMP #$08			; | Branches if the sprite is dead.
BCC NOCONTACT			;/

LDA $1534,x			;\
BNE NOSPRITEINTERACTION		;/ Branches if the sprite is following Mario.
LDA $1588,x			;\
AND #$04			; | Branches if the sprite is on the ground.
BNE NOSPRITEINTERACTION		;/
JSR SPRITEINTERACTION		; Jumps to the sprite interaction routine.

NOSPRITEINTERACTION:
JSL $81A7DC			; Jumps to the sprite interaction with Mario.
BCC NOCONTACT			; Returns if Mario is not touching the sprite.
LDA $154C,x			;\
BNE NOCONTACT			;/ Branches if the disable contact with Mario timer is not 0. 
LDA #$01			;\
STA $1534,x			;/ Sets a flag that indicates whether the sprite follows Mario or not.
STZ $B6,x			;\
STZ $AA,x			;/ Resets the X and Y speeds of the sprite.
LDA #$0B			;\
STA $1DFC			;/ Sets the sound to play.
LDA #$08			;\
STA $14C8,x			;/ Sets the sprite state to alive.

NOCONTACT:
RTS				; Ends the routine.

THROWUP:
LDA $15				;\
AND #$03			; | Branches if left or right on the directional pad are not pressed.
BEQ ONLYUP			;/
JSR MORESPEED			; Jumps to an X speed routine indexed by left or right on the directional pad.
ONLYUP:
LDA #$A0			; Loads the Y speed for the sprite.
STA $AA,x			; Stores the Y speed.
BRA OBJECTINTERACTION		; Branches to the object interaction routine.

THROWDOWN:
LDA $15				;\
AND #$03			; | Branches if left or right on the directional pad are not pressed.
BEQ ONLYDOWN			;/
JSR MORESPEED			; Jumps to an X speed routine indexed by left or right on the directional pad.
ONLYDOWN:
LDA #$40			; Loads the Y speed for the sprite.
STA $AA,x			; Stores the Y speed.
BRA OBJECTINTERACTION		; Branches to the object interaction routine.

MORESPEED:
LDA $15				;\
AND #$08			; | Branches if up on the directional pad is pressed.
BNE SLOWER			;/
LDA $15				;\
AND #$02			; | Branches if left on the directional pad is pressed.
BNE LEFTDIR			;/
LDA #$40			; Loads the X speed.
STA $B6,x			; Stores the speed to the X speed table.
RTS				; Ends the code.

LEFTDIR:
LDA #$C0			; Loads the X speed.
STA $B6,x			; Stores the speed to the X speed table.
RTS				; Ends the code.

SLOWER:
LDA $15				;\
AND #$02			; | Branches if left on the directional pad is pressed.
BNE SLOWLEFTDIR			;/
LDA #$34			; Loads the X speed.
STA $B6,x			; Stores the speed to the X speed table.
RTS				; Ends the code.

SLOWLEFTDIR:
LDA #$CC			; Loads the X speed.
STA $B6,x			; Stores the speed to the X speed table.
RTS				; Ends the code.

SMOKE:
LDY #$03			; Loads the number of slots for the routine.
LOOP:
LDA $17C0,y			;\
BEQ FREE			;/ Branches if the slot has no sprite.
DEY				; Decrements the Y Register.
BPL LOOP			; Loops the routine until no slots are free.
SEC				; Sets the carry flag. It indicates that the sprite failed to spawn.
RTL 				; Ends the code.

FREE:
LDA #$01			;\
STA $17C0,y			;/ Spawns the puff of smoke sprite.
LDA #$1B			;\
STA $17CC,y			;/ Sets the time to show the smoke.

LDA $96				;\
CLC				; |
ADC #$10			; |
STA $17C4,y			; | Stores and offsets Mario's Y position (next frame) to the smoke's Y position.
LDA $97				; |
ADC #$00			; |
STA $18C5,y			;/
LDA $76				;\
BEQ SMOKERIGHT			;/ Branches if the player is facing right.
LDA $94				;\
SEC				; |
SBC #$08			; |
STA $17C8,y			; | Stores and offsets Mario's X position (next frame) to the smoke's X position.
LDA $95				; |
SBC #$00			; |
STA $18C9,y			;/
BRA ENDSMOKE			; Branches to the end smoke routine.
SMOKERIGHT:
LDA $94				;\
CLC				; |
ADC #$08			; | 
STA $17C8,y			; | Stores and offsets Mario's X position (next frame) to the smoke's X position.
LDA $95				; |
ADC #$00			; |
STA $18C9,y			;/
ENDSMOKE:
CLC				; Clears the carry flag. It indicates that the sprite spawned successfully.
RTL				; Ends the code.

SPRITEINTERACTION:
LDY.b #$0B			; Loads the number of sprites to interact with.
SPRITELOOP:
CPY $15E9			;\
BEQ NEXTSPRITE			;/ Branches if the sprite is interacting with itself.
LDA $14C8,y			;\
CMP #$08			; | Branches if the contacted sprite is dead.
BCC NEXTSPRITE			;/
LDA $1686,y			;\	
AND #$08			; | Branches if the contacted sprite does not interact with other sprites.
BNE NEXTSPRITE			;/
JSR SPRITETOSPRITECONTACT	; Jumps to the sprite to sprite contact routine.
NEXTSPRITE:	
DEY				; Decrements the Y Register.
BPL SPRITELOOP			; Loops the routine until there are no more sprites to interact with.
RTS				; Ends the code.

SPRITETOSPRITECONTACT:
JSL $83B69F			; Gets the 1st collision bytes of the contacted sprite.
PHX				; Preserves the X Register.
TYX				; Transfers the Y Register to the X Register.
JSL $83B6E5			; Gets the 2nd collision bytes of the contacted sprite.
PLX				; Pulls back the X Register.
JSL $83B72B			; Jumps to the sprite interaction with other sprites.
BCC NOSPRITECONTACT		; Branches if there is no contact.
;PHX				; Preserves the X Register.
;TYX				; Transfers the Y Register to the X Register.
LDA $B6,x			;\
ASL				;/ Loads the contacting sprite's X speed.
LDA #$10			; Loads the contacted sprite's X speed
BCC INVERTED			; Branches if the contacting sprite's X speed is inverted.
LDA #$F0			; Loads the inverted X speed.
INVERTED:
STA $B6,y			; Stores the contacted sprite's X speed.
LDA #$02			;\
STA $14C8,y			;/ Sets the contacted sprite's state to killed.
LDA #$D0			;\
STA $AA,y			;/ Sets the contacted sprite's Y speed.
	
JSL $81AB72			; Displays the star smash graphic.
;PLX				; Pulls back the X Register.

INC $1626,x			; Increases the consecutive enemies killed by sprites table.
LDA $1626,x			;\
CMP #$08			; | Branches if the consecutive enemies killed by sprites is less than 8.
BCC LESSTHAN8			;/
LDA #$08			;\
STA $1626,x			;/ Sets the consecutive enemies killed by sprites to 8.
LESSTHAN8:
JSL $82ACE5			; Gives Mario points.
LDY $1626,x			;\
CPY #$08			; | Branches if the consecutive enemies killed by sprites is 8 or more.
BCS NOSPRITECONTACT		;/
LDA SOUNDS,y			;\
STA $1DF9			;/ Sets the sounds to play based on the consecutive enemies killed by sprites table.
NOSPRITECONTACT:
RTS				; Ends the code.

SOUNDS: db $03,$13,$14,$15,$16,$17,$18,$19
;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

GRAPHICS:
%GetDrawInfo()			; Jumps to the OAM handler.

LDA $00				;\
STA $0300,y			;/ Draws the X position of the sprite.

LDA $01				;\
STA $0301,y			;/ Draws the Y position of the sprite.

LDA #$48			;\
STA $0302,y			;/ Loads the tile to draw.

LDA #$04			;\
ORA $64				;/ Loads the property byte.
STA $0303,y			; Stores the property byte.

LDY #$02			; Loads the sprite tile size.
LDA #$00			; Loads the number of tiles drawn -1.

JSL $81B7B3			; Calls the routine that draws the sprite.
RTS				; Ends the code.