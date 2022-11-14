db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

MarioAbove:
MarioSide:
MarioCorner:
RTL		; Ends the code.
MarioBelow:
LDA $7D		;\
CMP #$80	; | Branches if Mario is descending.
BCC RETURN	;/
LDA #$1A	;\
STA $1693	; | Makes the block act like a block with a Star 2/1-UP/Vine.
LDY #$01	;/
RETURN:
HeadInside:
BodyInside:
SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
RTL		; Ends the code.

print "An invisible block that contains a star 2, 1-UP, or vine depending on its X position. It can only be hit from below."

