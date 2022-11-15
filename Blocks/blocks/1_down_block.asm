db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

MarioAbove:
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
LDA $0DBE				;\
BNE MORETHANONE				;/ Branches if Mario has only one life left.
LDA #$2A				;\
STA $1DFC				;/ Sets the sound to play.
RTL					; Ends the code.
MORETHANONE:
DEC $0DBE				; Decrements the lives counter.
LDA #$2A				;\
STA $1DFC				;/ Sets the sound to play.
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
MarioCape:
JMP MarioBelow				; Jumps to the hit below routine.
MarioFireBall:
RTL					; Ends the code.

print "A ? block that takes away one of Mario's lives."