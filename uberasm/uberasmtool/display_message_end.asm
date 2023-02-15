!LEVELNNUMBER = $31
!TIMER = $0F
init:
LDA #!TIMER		;\
STA $58			;/ Stores a timer to a freeram address as a message timer.
INC $5C			; Increments a freeram address as a resume level flag.
RTL			; Ends the code.

main:
LDA $60			;\
BNE RESUMELEVEL		;/ Branch if the freeram address used for skipping this routine is not zero.
LDA $58			;\
BNE NOMESSAGE		;/ Branch if the message timer freeram address is zero.
LDA #!LEVELNNUMBER	;\
STA $13BF		;/ Changes the translevel number.
LDA #$01		;\
STA $1426		;/ Displays level message 1.
INC $58			; Increments the message timer freeram address.
STZ $5C			; Clears the resume level flag freeram address.
RTL			; Ends the code.
NOMESSAGE:
LDA $5C			;\
BNE RESUMELEVEL		;/ Branch if the resume level flag freeram address is not zero.
LDA #$FF		;\
STA $1493		;/ Makes Mario freeze at the level end.
INC $13C6		; Enables a boss sequence cutscene.
LDA #$03		;\
STA $1DFB		;/ Music to play.
LDA #$01		;\
STA $60			;/ Stores a value to the routine skip freeram address.
RTL			; Ends the code.
RESUMELEVEL:
DEC $58			; Decrements the message timer freeram address.
JSR RESET		; Calls the translevel number reset routine.
STZ $1B96		; Disables the ability to side exit a level.
RTL			; Ends the code.