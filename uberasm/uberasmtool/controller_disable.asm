main:
STZ $15		;\
STZ $16		; |
STZ $17		; | Disables Mario's conrtols.
STZ $18		;/
LDA #$01	;\
STA $79		;/ Disables pausing.
RTL		; Ends the code.