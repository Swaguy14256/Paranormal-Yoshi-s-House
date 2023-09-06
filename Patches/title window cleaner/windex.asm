header
lorom
if read1($00FFD5) == $23
	sa1rom
endif

org $009AA4
;JSL $84F675
;autoclean JSL Mymain
autoclean JML Mymain	; Jumps to the window cleaning routine.

;freespace noram
freecode
Mymain:
JSL $84F675
JSL $7F8000
JML $009AA8		; Jumps back to the original code.