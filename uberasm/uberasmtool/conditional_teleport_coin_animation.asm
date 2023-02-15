main:
LDA $6DBF		;\
CMP #$63		; | Branch if Mario has the specified amount of coins.
BEQ TURNONANIMATION	;/
REP #$20		; Turns on 16-bit addressing mode.
LDA $7FC0FC		;\
AND #$FFFE		; | Turns off the Custom 0 ExAnimation.
STA $7FC0FC		;/
SEP #$20		; Turns back on 8-bit addressing mode.
RTL			; Ends the code.
TURNONANIMATION:
REP #$20		; Turns on 16-bit addressing mode.
LDA $7FC0FC		;\
ORA #$0001		; | Turns on the Custom 0 ExAnimation.
STA $7FC0FC		;/
SEP #$20		; Turns back on 8-bit addressing mode.
RTL			; Ends the code.