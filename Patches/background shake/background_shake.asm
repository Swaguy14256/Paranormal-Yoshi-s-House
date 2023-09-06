org $00826B
autoclean JML BACKGROUNDSHAKE	; Jumps to the background shake routine.
NOP #6				; Clears unused remaining bytes.

freecode

BACKGROUNDSHAKE:
REP #$20			; Turns on 16-bit addressing for the Accumulator.
LDA $010B			;\
CMP #$0031			;/ Checks if Mario is in level 31.
SEP #$20			; Turns on 8-bit addressing for the Accumulator.
BNE REGULARYPOSITION		; Branches if Mario is not in level 31.
LDA $20				;\
CLC				; |
ADC $1888			; |
STA $2110			; | Sets the Layer 2 Y position and offsets it by the Layer 1 shake offset.
LDA $21				; |
ADC $1889			; |
STA $2110			;/
JML $808275			; Jumps back to original code.
REGULARYPOSITION:
LDA $20				;\
STA $2110			; | Sets the Layer 2 Y position.
LDA $21				; |
STA $2110			;/
JML $808275			; Jumps back to the original code.