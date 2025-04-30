db $42		; enable corner and inside offsets
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

	!MIDWAY_POINT_NUMBER = $03	; 00 = regular midway point, 01 = midway point 2, ect

	!RAM_MIDWAY	= $7FB4D9	; holds which midway point to use (96 bytes, one for each level)

MarioBelow:
MarioAbove:
MarioSide:
MarioCorner:
HeadInside:
BodyInside:
	LDA $13BF	; get translevel number
	TAX		; stick in x
	LDA !RAM_MIDWAY,x	; get current midway point number
	CMP #!MIDWAY_POINT_NUMBER; compare with which midway point number we're setting
	BCS DONT_SET_MIDWAY	; if higher or equal, don't set the midway point number
	LDA #!MIDWAY_POINT_NUMBER; otherwise set the midway point number
	STA !RAM_MIDWAY,x	;
DONT_SET_MIDWAY:

SpriteV:
SpriteH:
MarioCape:
MarioFireBall:
	LDA #$38
	STA $1693	; act like midway point bar no matter what it's set to act like
	LDY #$00
	RTL

