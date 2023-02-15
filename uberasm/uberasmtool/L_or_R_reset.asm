main:
LDA $71		;\
CMP #$0A	; | Branch if the castle/ghost house intro is playing.
BEQ RETURN	;/
LDA $9D		;\
ORA $13D4	; | Branch if the game is paused or locked.
BNE RETURN	;/
LDA $95		;\
CMP #$06	; |
BCC RETURN	; | Branch if Mario is not in the specified screen range.
CMP #$0C	; |
BCS RETURN	;/
LDA $18		;\
AND #$30	; | Branch if the L/R buttons are not pressed.
BEQ RETURN	;/
LDA #$01	;\
STA $1DFC	;/ Sound effect to play.
LDA #$06	;\
STA $71		; |
STZ $88		; | Teleports the player.
STZ $89		;/
RETURN:
RTL		; Ends the code.