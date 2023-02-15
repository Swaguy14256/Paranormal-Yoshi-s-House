!LEVELNUMBER = #$2E
!TIMER = #$0F
init:
LDA #!TIMER		;\
STA $58			; |
STA $5C			; | Stores a timer to three freeram addresses.
STA $60			;/
RTL			; Ends the code.

main:
LDA #$FF		;\
STA $9D			;/ Locks the game.
LDA $58			;\
BNE MESSAGE1		;/ Branch if the first freeram address is not zero.
LDA $5C			;\
BNE MESSAGE2		;/ Branch if the second freeram address is not zero.
LDA $60			;\
BNE MESSAGE3		;/ Branch if the third freeram address is not zero.
LDA #$06		;\
STA $71			; |
STZ $88			; | Teleports the player.
STZ $89			;/
RTL			; Ends the code.			
MESSAGE1:
LDA #!LEVELNUMBER	;\
STA $13BF|!addr		;/ Changes the translevel number.
LDA #$02		;\
STA $1426|!addr		;/ Displays level message 2.
STZ $58			; Clears the first freeram address.
RTL			; Ends the code.
MESSAGE2:
INC $13BF|!addr		; Changes the translevel number.
LDA #$01		;\
STA $1426|!addr		;/ Displays level message 1.
STZ $5C			; Clears the second freeram address.
RTL			; Ends the code.
MESSAGE3:
LDA #$02		;\
STA $1426|!addr		;/ Displays level message 2.
STZ $60			; Clears the third freeram address.
RTL			; Ends the code.