db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

MarioAbove:
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
LDA $19					;\
BEQ MAKEBIG				;/ Branches if Mario is small.
LDA #$2A				;\
STA $1DFC				;/ Sets the sound to play.
RTL
MAKEBIG:
LDA #$02				;\
STA $71					;/ Sets a player animation trigger.
LDA #$2F				;\
STA $1496				; | Loads the player animation timer and also stores it to the lock sprites and animation timer.
STA $9D					;/
LDA #$0A				;\
STA $1DF9				;/ Sets the sound to play.    
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
MarioCape:
JMP MarioBelow				; Jumps to the hit below routine.
MarioFireBall:
RTL					; Ends the code.

print "A ? block that functions like a midway gate bar."