!TIMER = $2B
!LEVELNUMBER = $06

init:
LDA #!TIMER		;\
STA $58			;/ Stores a value to freeram as a timer.
STZ $76			; Makes the player face left.
RTL			; Ends the code.

main:
LDA $58			; Loads the freeram used as the timer.
BEQ NOTIME		; Branch if the timer reaches zero.
STZ $15			;\
STZ $16			; |
STZ $17			; | Disables Mario's conrtols.
STZ $18			;/
LDA #$01		;\
STA $79			;/ Disables pausing.
DEC $58			; Decrements the freeram timer.
NOTIME:
LDA $13D4		;\
BEQ RESUME		;/ Branch if the game is paused.
RTL			; Ends the code.
RESUME:	
LDA #!LEVELNUMBER	;\
STA $13BF		;/ Changes the translevel number.
RTL			; Ends the code.