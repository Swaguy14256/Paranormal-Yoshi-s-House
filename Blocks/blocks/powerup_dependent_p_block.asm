db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

MarioAbove:
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
PHY					; Preserves the Y Register.
LDY $19					;\
LDA TIMER_TYPE,y			; | Loads the P-Switch timer values indexed by the Y Register
STA $14AD				;/
PLY					; Pulls back the Y Register.
LDA #$0B				;\
STA $1DF9				;/ Sets the sound to play.
HeadInside:
BodyInside:
RTL					; Ends the code.
SpriteV:
%check_sprite_kicked_vertical()		; Jumps to the check for vertical kicked sprites macro.
BCC NOCONTACT				; Branches if there is no contact.
JMP MarioBelow				; Jumps to the hit below routine.
SpriteH:
%check_sprite_kicked_horizontal()	; Jumps to the check for horizontal kicked sprites macro.
BCC NOCONTACT				; Branches if there is no contact.
JMP MarioBelow				; Jumps to the hit below routine.
NOCONTACT:
RTL					; Ends the code.
TIMER_TYPE:
db $3F,$7F,$FF,$FF
MarioCape:
JMP MarioBelow				; Jumps to the hit below routine.
MarioFireBall:
RTL					; Ends the code.

print "A tile that activates the effects of a P-Switch. The amount of time depends on Mario's power-up status and the values in the table can be changed."