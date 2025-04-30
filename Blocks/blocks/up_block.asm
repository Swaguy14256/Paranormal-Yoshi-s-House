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
LDA #$C1	;\
STA $7D		;/ Sets Mario's Y speed.
LDA #$0B	;\
STA $1DF9	; |
LDA #$08	; | Sets the sounds to play.
STA $1DFC	;/
SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
RTL		; Ends the code.

print "A block that throws Mario upwards."