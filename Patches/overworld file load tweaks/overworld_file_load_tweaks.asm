org $00976F
autoclean JSL GAMEOVERCHECK	; Jumps to the Game Over check routine.
NOP #2				; Clears unused remaining bytes.

org $009BC0
autoclean JML FORCECONTINUE	; Jumps to the force continue routine.

org $009E1C
autoclean JSL CONTINUEGAME	; Jumps to the continue game routine.
BRA SKIP			; Branches over the NOPs used to clear the unused remaining bytes.
NOP #58				; Clears unused remaining bytes.

org $009E5C
SKIP:

org $00A0F6
autoclean JML CONTINUECHECK	; Jumps to the continue check routine.
NOP				; Clears unused remaining bytes.

org $00A195
autoclean JSL RELOADSAVE	; Jumps to the reload save routine.
NOP				; Clears unused remaining bytes.

freecode

GAMEOVERCHECK:
LDA $0DB2			;\
BEQ ONEPLAYER			;/ Branches if the game is a 1 player game.
LDA $0DB4			;\
ORA $0DB5			;/ Checks if both Mario and Luigi have 0 lives.
RTL				; Ends the code.
ONEPLAYER:
LDA $0DBE			; Loads the current number of lives.
RTL				; Ends the code.

FORCECONTINUE:
LDA #$01			;\
STA $0F45			;/ Sets the force continue screen flag.
JSL $809BC9			; Jumps to the save routine.
JML $809BC4			; Jumps back to the original code.

CONTINUEGAME:
LDY $0DB2			; Loads the number of players.
LDX $0DB3			; Loads the current player.
NEWLIVESLOOP:
LDA $0DB4,x			;\
BPL KEEPLIVES			;/ Branches if the current player has more than 0 lives.
LDA #$04			;\
STA $0DB4,x			; | Sets the current number of lives to 5.
STA $0DBE			;/
STZ $0DBC,x			; Clears the current character's reserve item.
KEEPLIVES:
TXA				; Transfers the X Register to the Accumulator.
EOR #$01			; Swaps the character played.
TAX				; Transfers the Accumulator to the X Register.
DEY				; Decreases the Y Register.
BPL NEWLIVESLOOP		; Loops the new lives loop until it is -1.
STZ $13C9			; Sets the continue screen state to nothing.
LDX $0DB3			; Loads the current character.
LDA $0DB4,x			;\
STA $0DBE			;/ Sets the current number of lives.
LDA $0DB6,x			;\
STA $0DBF			;/ Sets the current number of coins.
LDA $0DB8,x			;\
STA $19				;/ Sets the player's power-up status.
LDA $0DBA,x			;\
STA $13C7			;/ Sets the player's Yoshi color.
LDA $0DBC,x			;\
STA $0DC2			;/ Sets the player's reserve item.
RTL				; Ends the code.

CONTINUECHECK:
LDA $1F2E			;\
BNE CONTINUESCREEN		;/ Branches if at least 1 event has been activated.
LDA $0F45			;\
BNE CONTINUESCREEN		;/ Branches if the force continue screen flag is set.
JML $80A0FB			; Jumps back to the original code.
CONTINUESCREEN:
JML $80A101			; Jumps back to the original code.

RELOADSAVE:
LDA $13C9			;\
BEQ RELOADSKIP			;/ Branches if the continue screen is not displayed.
LDX $010A			; Loads the current save file number.
PHK				; Preserves the current bank.
PER EMPTYCHECK-$01		; Sets the address to return to after the address jumped to finishes its routine.
PEA $84CE			; Preserves a Return address.
JML $809DB5			; Jumps to the check empty file routine.
EMPTYCHECK:
PHP				; Preserves the processor flags.
BEQ NOTEMPTY			; Branches if the save file is not empty.
BRA RESETPLAYERSTATUS		; Branches to the reset player status routine.
NOTEMPTY:
LDA #$70			;\
STA $4314			;/ Sets the source address bank for DMA Channel 1.
REP #$20			; Turns on 16-bit addressing for the Accumulator.
LDA #$8000			;\
STA $4310			;/ Sets the destination register for DMA Channel 1.
PHK				; Preserves the current bank.
PER RELOADFILE-$01		; Sets the address to return to after the address jumped to finishes its routine.
PEA $84CE			; Preserves a Return address.
JML $809DC7			; Jumps to the reload save file routine.
RELOADFILE:
PLP				; Pulls back the processor flags.
SEP #$30			; Turns on 8-bit addressing for the A, X, and Y Registers.
RESETPLAYERSTATUS:
STZ $19				; Clears the player's power-up status.
STZ $0DC2			; Clears the player's reserve item.
STZ $13C7			; Clears the player's Yoshi color.
LDX $0DB3			; Loads the current character.
STZ $0DB8,x			; Clears the current character's power-up status.
STZ $0DBA,x			; Clears the current character's Yoshi color.
STZ $0DBC,x			; Clears the current character's reserve item.
LDA #$FF			;\
STA $0DB4,x			;/ Sets the current character's lives to 0.
TXA				; Transfers the X Register to the Accumulator.
EOR $0DB2			; Swaps the character played.
TAX				; Transfers the Accumulator to the X Register.
STZ $0DB8,x			; Clears the other character's power-up status.
STZ $0DBA,x			; Clears the other character's Yoshi color.
STZ $0DBC,x			; Clears the other character's reserve item.
LDA #$FF			;\
STA $0DB4,x			;/ Sets the other character's lives to 0.
STA $0DBE			; Sets the player's lives to 0.
RELOADSKIP:
REP #$10			; Turns on 16-bit addressing for the X and Y Registers.
LDX #$0015			; Loads a loop count of 21.
POSITIONRESTORELOOP:
LDA $1F85,x			;\
STA $1F11,x			;/ Restores the player overworld positions.
DEX				; Decreases the X Register.
BPL POSITIONRESTORELOOP		; Loops the position restore loop until it is -1.
LDX #$008C			; Loads a loop count of 140.
RTL				; Ends the code.