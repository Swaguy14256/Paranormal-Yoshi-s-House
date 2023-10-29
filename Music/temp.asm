arch spc700-raw

org $000000
incsrc "asm/main.asm"
base $1F59

org $008000


	jmp UnpauseMusic_silent
