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
BEQ SMALL	;/ Branches if Mario is small.
LDA #$01	;\
STA $71		;/ Sets a player animation trigger.
LDA #$2F	;\
STA $1496	; | Loads the player animation timer and also stores it to the lock sprites and animation timer.
STA $9D		;/
STZ $19		; Makes the player small.
LDA #$04	;\
STA $1DF9	;/ Sets the sound to play.
STZ $1407	;\
STZ $188A	;/ Disables cape flying.
SMALL:
SpriteV:
SpriteH:
Cape:
Fireball:
RTL		; Ends the code.

print "A gate that always turns you into Small Mario."