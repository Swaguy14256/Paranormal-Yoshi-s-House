db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside : JMP WallFeet : JMP WallBody

MarioAbove:
MarioSide:
MarioCorner:
MarioBelow:
HeadInside:
BodyInside:
WallFeet:
WallBody:
LDA $5C		;\
BEQ EMPTYTIMER	;/ Branches if the message timer is 0.
DEC $5C		; Decreases the message timer.
EMPTYTIMER:
CMP #$01	;\
BEQ MESSAGE	;/ Branches if the message timer is 1.
LDA $72		;\
BNE RETURN	;/ Branches if Mario is in the air.
LDA $16		;\
AND #$08	; | Branches if Mario is pressing up.
BEQ RETURN	;/
STZ $7B		; Sets Mario's speed to 0.
LDA #$22	;\
STA $1DFC	;/ Sets the sound to play.	
LDA $93		;\
STA $76		;/ Makes Mario face towards the block.
LDA #$02	;\
STA $5C		;/ Sets the message timer.
BRA RETURN	; Branches to the return routine.
MESSAGE:
LDA #$47	;\
STA $13BF	;/ Sets the translevel number.
LDA #$01	;\
STA $1426	;/ Displays level message 1.
SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
RETURN:
RTL		; Ends the code.

print "A note that can be read by pressing up."