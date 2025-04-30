db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside : JMP WallFeet : JMP WallBody

MarioAbove:
MarioSide:
MarioCorner:
MarioBelow:
WallFeet:
WallBody:
LDA $187A	;\
BNE YOSHI	;/ Branches if Mario is on a Yoshi.
STUCK:
LDA #$25	;\
STA $1693	; | Makes the block act like a blank tile.
LDY #$00	;/
YOSHI:
RTL		; Ends the code.
HeadInside:
BodyInside:
LDA $187A	;\
BEQ STUCK	;/ Branches if Mario is not on a Yoshi.
JSL $80F606	; Kills Mario.
SpriteV:
SpriteH:
MarioCape:
RTL		; Ends the code.
MarioFireBall:
LDA #$25	;\
STA $1693	; | Makes the block act like a blank tile.
LDY #$00	;/
RTL		; Ends the code.

print "A block that only lets Mario, his cape, and his fireballs through. He also must not be on a Yoshi to get through."