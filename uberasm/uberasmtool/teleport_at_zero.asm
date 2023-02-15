main:
LDA $0F31	;\
ORA $0F32	; | 
ORA $0F33	; | Branch if the timer is at zero.
BEQ TELEPORT	;/
RTL		; Ends the code.
TELEPORT:
LDA #$06	;\
STA $71		; | Activates the screen exit of whatever screen
STZ $89		; | Mario is currently on.
STZ $88		;/
RTL		; Ends the code.