db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside	

!Lives = 05
!Coins = 50

MarioAbove: 
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
LDA $0DBF				;\
CMP #!Coins				; | Branches if Mario has the configured amount of coins or more.
BCS HASCOINS				;/
LDA #$2A				;\
STA $1DFC				;/ Sets the sound to play.
RTL					; Ends the code.		
HASCOINS:
LDA $18E4				;\
CLC					; |
ADC #!Lives				; | Gives Mario the configured amount of lives. 
STA $18E4				;/
LDA $0DD9				;\
CLC					; |
ADC #!Coins				; | Removes the configured amount of coins from Mario.
STA $0DD9				;/
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
JMP MarioBelow	; Jumps to the hit below routine.
MarioFireBall:
RTL		; Ends the code.

print "A ? block that gives you ",dec(!Lives)," lives for at least !Coins coins."