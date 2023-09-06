org $01EC3B
autoclean JML THANKYOUMESSAGE	; Jumps to the thank you message routine.
NOP				; Clears unused remaining bytes.

freecode

THANKYOUMESSAGE:
LDA $0DB3			;\
BNE LUIGI			;/ Branches if the current character is Luigi.
LDA #$03			;\
STA $1426			;/ Display the Rescue Yoshi Message.
JML $81EC40			; Jumps back to the original code.
LUIGI:
LDA #$41			;\
STA $13BF			;/ Changes the translevel number.
LDA #$02			;\
STA $1426			;/ Displays Message 2 of the current translevel number.
JML $81EC40			; Jumps back to the original code.