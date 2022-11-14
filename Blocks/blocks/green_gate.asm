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
CMP #$02	; | Branches if Mario is caped.
BEQ CAPED	;/
LDA #$02	;\
STA $19		;/ Makes Mario caped.
LDA #$03	;\
STA $71		;/ Sets a player animation trigger.
LDA #$2F	;\
STA $1496	; | Loads the player animation timer and also stores it to the lock sprites and animation timer.
STA $9D		;/
JSL $01C5AE	; Displays the smoke effect.
LDA #$0D	;\
STA $1DF9	;/ Sets the sound to play.
CAPED:
SpriteV:
SpriteH:
Cape:
Fireball:
RTL		; Ends the code.

print "A gate that always turns you into Cape Mario."