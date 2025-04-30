db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside : JMP WallFeet : JMP WallBody

!Coins = $63

MarioAbove:
MarioSide:
MarioCorner:
MarioBelow:
HeadInside:
BodyInside:
WallFeet:
WallBody:
LDA $0DBF	;\
CMP #!Coins	; | Branches if Mario has the configured number of coins.
BEQ TELEPORT	;/
RTL		; Ends the code.
TELEPORT:
LDA #$2B	;\
STA $1693	; | Makes the tile act like a coin.
LDY #$00	;/
LDA $14AD	;\
BNE PSWITCH	;/ Branches if a P-Switch is active.
REP #$20	; Switches to 16-bit mode addressing.
LDA $7FC0FC	;\
AND #$FFFE	; | Deactivates the Custom Trigger 0 ExAnmiation in Lunar Magic.
STA $7FC0FC	;/
SEP #$20	; Switches back to 8-bit addressing mode.
LDA #$06	;\
STA $71		; |
STZ $88		; | Teleports Mario.
STZ $89		;/
PSWITCH:
SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
RTL		; Ends the code.

print "A coin that teleports you to the next area set by the screen it was placed in if you have at least ",dec(!Coins)," coins."