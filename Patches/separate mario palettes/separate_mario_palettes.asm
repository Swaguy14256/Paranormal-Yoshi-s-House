org $00E3CA
autoclean JML MARIOOAM	; Jumps to the background shake routine.
NOP			; Clears unused remaining bytes.

org $00E448
autoclean JML MARIOOAM2	; Jumps to the background shake routine.
NOP #2			; Clears unused remaining bytes.

freecode

MARIOOAM:
PHA			; Preserves the Accumulator.
LDA $0100		;\
CMP #$14		; | Branches if Mario is not in a level.
BNE DEFAULT		;/
REP #$20		; Turns on 16-bit addressing for the Accumulator.
LDA $010B		;\
CMP #$0031		; | Branches if Mario is in level 31.
BEQ NEWOAMINDEX		;/
SEP #$20		; Turns on 8-bit addressing for the Accumulator.
DEFAULT:
LDA $0DA1		;\
CMP #$08		; | Branches if the Mario palette index is less than 8.
BCC OFFSETPALETTE	;/
PLA			; Pulls back the Accumulator.
LDY $E2B2,x		; Loads the OAM index for Mario's tiles.
LDX $76			; Loads Mario's direction.
JML $80E3CF		; Jumps back to the original code.

OFFSETPALETTE:
LDA $0DA1		;\
ASL			;/ Shifts the palette index left.
STA $00			; Sets the palette bits.
PLA			; Pulls back the Accumulator.
LDY $E2B2,x		; Loads the OAM index for Mario's tiles.
LDX $76			; Loads Mario's direction.
ORA $E18C,x		; Loads the properties for Mario's tiles.
ORA $00			; Sets the palette for Mario's tiles.
JML $80E3D2		; Jumps back to the original code.

NEWOAMINDEX:
SEP #$20		; Turns on 8-bit addressing for the Accumulator.
LDA $60			; Loads the OAM index for Mario's tiles.
CLC			;\
ADC #$08		;/ Increases the index by 8.
TAY			; Transfers the Accumulator to the Y Register.
PLA			; Pulls back the Accumulator.
LDX $76			; Loads Mario's direction.
JML $80E3CF		; Jumps back to the original code.

MARIOOAM2:
PHA			; Preserves the Accumulator.
LDA $0100		;\
CMP #$14		; | Branches if Mario is not in a level.
BNE DEFAULT2		;/
REP #$20		; Turns on 16-bit addressing for the Accumulator.
LDA $010B		;\
CMP #$0031		; | Branches if Mario is in level 31.
BEQ NEWOAMINDEX2	;/
SEP #$20		; Turns on 8-bit addressing for the Accumulator.
DEFAULT2:
PLA			; Pulls back the Accumulator.
LDX $13F9		; Loads the behind scenery flag.
LDY $E2B6,x		; Loads the OAM index for Mario's extra tiles.
JML $80E44E		; Jumps back to the original code.

NEWOAMINDEX2:
SEP #$20		; Turns on 8-bit addressing for the Accumulator.
PLA			; Pulls back the Accumulator.
LDX $13F9		; Loads the behind scenery flag.
LDY $60			; Loads the OAM index for Mario's extra tiles.
JML $80E44E		; Jumps back to the original code.