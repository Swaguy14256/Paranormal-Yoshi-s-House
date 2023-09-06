if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
else
	lorom
	!addr = $0000
	!bank = $800000
endif

org $008EA4|!bank
SBC #$4240

org $008EB0|!bank
LDA #$10

org $008EC6|!bank
autoclean JSL Code
NOP
Return:

org $008EF4|!bank
autoclean JSL Code2
NOP

freecode

Code2:
LDA $0F39|!addr
BRA Codecopy

Code:
LDA $0F36|!addr
Codecopy:
LDX #$00
CMP #$10
BNE Done
LDX #$09
DEC A
Done:
STX $0F2F|!addr
STA $00
RTL