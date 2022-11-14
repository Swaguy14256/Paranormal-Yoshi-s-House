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
LDA $19			;\
BEQ SMALL		;/ Branches if Mario is small.
STZ $1407		;\
STZ $188A		;/ Disables cape flying.
LDA $19			;\
CMP #$02		; | Branches if Mario is not caped or firey.
BCC NOTCAPEDORFIREY	;/
BEQ CAPED		;  Branches if Mario is caped.
LDA #$01		;\
STA $19			;/ Makes Mario big.
LDA #$20		;\
STA $149B		; | Sets the timer for Mario to flash through palettes and also stores it to the lock sprites and animation timer.
STA $9D			;/
LDA #$04		;\
STA $71			;/ Sets a player animation trigger.
LDA #$7F		;\
STA $1497		;/ Sets the invulnerability timer.
LDA #$04		;\
STA $1DF9|!addr		;/ Sets the sound to play.
NOTCAPEDORFIREY:
RTL			; Ends the code.
CAPED:
JSL $01C5AE		; Jumps to the cape transform routine.
INC $9D			; Increases the lock timer.
LDA #$0C		;\
STA $1DF9|!addr		;/ Sets the sound to play.
LDA #$01		;\
STA $19			;/ Makes Mario big.
RTL			; Ends the code.
SMALL:
LDA #$02		;\
STA $71			;/ Sets a player animation trigger.
LDA #$2F		;\
STA $1496|!addr		; | Loads the player animation timer and also stores it to the lock sprites and animation timer.
STA $9D			;/
LDA #$0A		;\
STA $1DF9|!addr		;/ Sets the sound to play.
SpriteV:
SpriteH:
Cape:
Fireball:
RTL			; Ends the code.

print "A gate that always turns you into Super Mario."