init:
LDA #$05	;\
STA $1DFA|!addr	;/ Makes the sound effects not echo.
RTL		; Ends the code.