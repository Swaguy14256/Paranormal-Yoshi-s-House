db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside : JMP WallFeet : JMP WallBody

!Coins = $03

MarioAbove:
MarioSide:
MarioCorner:
MarioBelow:
HeadInside:
BodyInside:
WallFeet:
WallBody:
LDA $14AD	;\
BNE PSWITCH	;/ Branches if a P-Switch is active.
LDA $13CC	;\
CLC		; |
ADC #!Coins	; | Gives Mario the configured number of coins.
STA $13CC	;/
LDA $0DC0	;\
SEC		; |
SBC #!Coins	; | Decreases the Bonus Block coin count.
STA $0DC0	;/
BPL PSWITCH	; Branches if the Bonus Block coin count is negative.
STZ $0DC0	; Sets the Bonus Block coin count to 0.
PSWITCH:
SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
RTL		; Ends the code.

print "A green coin that is worth ",dec(!Coins+1)," coins instead of one."