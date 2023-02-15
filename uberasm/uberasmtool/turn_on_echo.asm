init:
LDA #$06	;\
STA $1DFA|!addr	;/ Makes the sound effects echo.
RTL		; Ends the code.