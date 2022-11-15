db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

!Coins = 05
!Addcoins = 42

MarioAbove:
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
LDA $0DBF				;\
CMP #!Coins				; | Branches if Mario has the configured number of coins or more.
BCS HASCOINS				;/
LDA #$2A				;\
STA $1DFC				;/ Sets the sound to play.
RTL					; Ends the code.
HASCOINS:
LDA #!Addcoins				;\
STA $13CC				;/ Adds the configured number of coins.
LDA $0DC0				;\
SEC					; |
SBC #!Addcoins				; | Decreases the Bonus Block coin count.
STA $0DC0				;/
BPL ENOUGHCOINS				; Branches if the Bonus Block coin count is negative.
STZ $0DC0				; Sets the Bonus Block coin count to 0.
ENOUGHCOINS:
LDA #$01				;\
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

print "A ? block that gives you a !Addcoins coins if you have at least ",dec(!Coins)," coins."