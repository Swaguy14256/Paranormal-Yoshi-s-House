db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

!Coins = $05

MarioAbove:
MarioSide:
MarioCorner:
RTL					; Ends the code.
MarioBelow:
LDA $0DBF				;\
PHA					;/ Takes Mario's coin counter and pushes it to the stack.
CMP #!Coins				;\
BCC NOTENOUGHCOINS			;/ Branches if Mario has less than the configured amount of coins.
PLA					; Pulls the coin counter from the stack.
STA $0EF9				; Stores the value into the "M/L" character in the status bar.
LDA #$29				;\
STA $1DFC				;/ Sets the sound to play.
RTL					; Ends the code.
NOTENOUGHCOINS:
PLA					; Pulls the coin counter from the stack.
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

print "A block that changes the M/L tile on Mario/Luigi part of the status bar if you have at least ",dec(!Coins)," coins. The tile itself depends on how many coins you curently have."