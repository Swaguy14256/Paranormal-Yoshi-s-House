db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall : JMP MarioCorner : JMP HeadInside : JMP BodyInside

MarioAbove:
MarioSide:
MarioCorner:
MarioBelow:
HeadInside:
BodyInside:
SpriteV:
SpriteH:
MarioCape:
RTL
MarioFireBall:
%create_smoke()	;\
%erase_block()	;/ Calls the smoke and erase block macro routines.
RTL

print "An ice block that can be only melted with a fireball."