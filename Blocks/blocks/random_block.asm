db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

MarioAbove:
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
LDA $13					;\
AND #$03				; | Sets the bits in the frame counter and stores the bits to the power-up status.
STA $19					;/
STZ $1407				;\
STZ $188A				;/ Disables cape flying.
PHY					; Preserves the Y Register.
LDY $19					;\
LDA ANIMATION,y				; | Loads the player animation values indexed by the Y Register.
STA $71					;/
LDA SFX,y				;\ Sets the sounds to play indexed by the Y Register.
STA $1DF9				;/
PLY					; Pulls back the Y Register.
LDA $71					;\
CMP #$02				; | Branches if the player animation value is not the growing animation.
BNE GROWING				;/
DEC $19					; Decrements the power-up status.
GROWING:
LDA $19					;\
CMP #$03				; | Branch if Mario is fiery.
BEQ FIERY				;/
CMP #$02				;\ Branch if Mario is not caped.
BNE NOTCAPED				;/
JSL $01C5AE				; Displays the smoke effect.
NOTCAPED:
LDA #$2F				;\
STA $1496				; | Loads the player animation timer and also stores it to the lock sprites and animation timer.
STA $9D					;/
RTL					; Ends the code.
FIERY:
LDA #$20				;\
STA $149B				; | Sets the timer for Mario to flash through palettes and also stores it to the lock sprites and animation timer.
STA $9D					;/
HeadInside:
BodyInside:
RTL					; Ends the code.
SpriteV:
%check_sprite_kicked_vertical()		; Jumps to the check for vertical kicked sprites macro.
BCC NOCONTACT				; Branches if there is no contact.
JMP MarioBelow				; Jumps to the hit below routine.
SpriteH:
%check_sprite_kicked_horizontal()	; Jumps to the check for horizontal kicked sprites macro.
BCC NOCONTACT				; Branches if there is no contact.
JMP MarioBelow				; Jumps to the hit below routine.
NOCONTACT:
RTL					; Ends the code.
ANIMATION: db $01,$02,$03,$04
SFX: db $04,$0A,$0D,$0A
MarioCape:
STZ $13E8				; Disables cape interaction to prevent softlocking.
JMP MarioBelow				; Jumps to the hit below routine.
MarioFireBall:
RTL					; Ends the code.

print "A ? block that randomly turns you into either Small, Super, Cape, or Fire Mario."