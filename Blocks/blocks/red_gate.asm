db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
JMP WallFeet : JMP WallBody

MarioBelow:
MarioAbove:
MarioSide:
MarioCorner:
MarioBody:
MarioHead:
WallFeet:
WallBody:
LDA $19		;\
CMP #$03	; | Branches if Mario is not firey.
BEQ FIREY	;/
LDA #$03	;\
STA $19		;/ Makes Mario firey
LDA #$20	;\
STA $149B	; | Sets the timer for Mario to flash through palettes and also stores it to the lock sprites and animation timer.
STA $9D		;/
LDA #$04	;\
STA $71		;/ Sets a player animation trigger.
LDA #$0A	;\
STA $1DF9	;/ Sets the sound to play.
STZ $1407	;\
STZ $188A	;/ Disables cape flying.
FIREY:
SpriteV:
SpriteH:
Cape:
Fireball:
RTL		; Ends the code.

print "A gate that always turns you into Fire Mario."