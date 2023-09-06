org $008F28
autoclean JML COINCAP	; Jumps to the coin cap routine.
NOP #15			; Clears unused remaining bytes.

freecode

COINCAP:
REP #$20		; Turns on 16-bit addressing for the Accumulator.
LDA $010B		;\
CMP #$0033		; |
BCC NOCAPPING		; | Branches if Mario is not in levels 33-35.
CMP #$0036		; |
BCS NOCAPPING		;/
SEP #$20		; Turns on 8-bit addressing for the Accumulator.
LDA $0DBF		;\
CMP #$63		; | Branches if Mario has less than 99 coins.
BCC DONOTCAP		;/
LDA #$63		;\
STA $0DBF		;/ Sets Mario's coins to 99.
DONOTCAP:
JML $808F3B		; Jumps back to the original code.

NOCAPPING:
SEP #$20		; Turns on 8-bit addressing for the Accumulator.
LDA $0DBF		;\
CMP #$64		; | Branches if Mario has less than 100 coins.
BCC NOTENOUGHCOINS	;/
INC $18E4		; Gives Mario 1 life.
LDA $0DBF		;\
SEC			; | Subtracts 100 coins from Mario.
SBC #$64		; |
STA $0DBF		;/
NOTENOUGHCOINS:
JML $808F3B		; Jumps back to the original code.