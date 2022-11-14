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
LDA #$30	;\
STA $1693	; | Makes the block act like a cement block.
LDY #$01	;/
SpriteV:
SpriteH:
RTL		; Ends the code.
MarioCape:
MarioFireBall:
LDA #$30	;\
STA $1693	; | Makes the block act like a cement block.
LDY #$01	;/
RTL		; Ends the code.

print "A block that does not let Mario, his cape, and his fireballs through."