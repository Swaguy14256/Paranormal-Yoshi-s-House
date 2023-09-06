org $008F22
autoclean JML ADDSOUND		; Jumps to the add sound routine.
NOP #2				; Clears unused remaining bytes.

org $008F3B
autoclean JML SUBTRACTCOINS	; Jumps to the subtract coins routine.
NOP				; Clears unused remaining bytes.

freecode

ADDSOUND:
CMP #$01			;\
BEQ REGULARCODE			;/ Branches if only 1 coin will be given to Mario.
DEC $13CC			; Decreases the coins to add counter.
INC $0DBF			; Increases Mario's coins by 1.
LDA $0DBF			;\
CMP #$64			; | Branches if Mario has 100 coins.
BEQ NOSOUND			;/
AND #$01			;\
BEQ NOSOUND			;/ Branches if the current number of coins Mario has is even.
LDA $0DD9			;\
BNE NOSOUND			;/ Branches if there are coins to subtract.
LDA #$01			;\
STA $1DFC			;/ Sets the sound to play.
NOSOUND:
JML $808F28			; Jumps back to the original code.
REGULARCODE:
DEC $13CC			; Decreases the coins to add counter.
INC $0DBF			; Increases Mario's coins by 1.
JML $808F28			; Jumps back to the original code.

SUBTRACTCOINS:
LDA $0DD9			;\
BEQ NOSOUND2			;/ Branches if there are no coins to subtract.
DEC $0DD9			; Decreases the coins to subtract counter.
LDA $0DBF			;\
BEQ NOSOUND2			;/ Branches if Mario has 0 coins.
DEC $0DBF			; Decreases Mario's coins by 1.
LDA $0DBF			;\
AND #$01			; | Branches if the current number of coins Mario has is even.
BEQ NOSOUND2			;/
LDA $13CC			;\
BNE NOSOUND2			;/ Branches if there are coins to add.
LDA #$01			;\
STA $1DFC			;/ Sets the sound to play.
NOSOUND2:
LDA $0DBE			;\
BMI NOLIVES			;/ Branches if Mario has less than 1 life.
JML $808F40			; Jumps back to the original code.
NOLIVES:
JML $808F49			; Jumps back to the original code.


