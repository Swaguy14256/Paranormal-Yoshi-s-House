	STA $05
	LDA #$0F
	TRB $98
	TRB $9A
	PHB
	LDA #$02|!bank8
	PHA
	PLB
	JSL $02887D|!bank
	PLB
	RTL
