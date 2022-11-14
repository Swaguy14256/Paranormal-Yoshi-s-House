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
JSL $80F5B7	; Hurts Mario.
SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
RTL		; Ends the code.

print "A water tile that hurts you and erases sprites."