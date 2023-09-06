header
lorom

org $837E
autoclean JML Main2
NOP

org $8174
autoclean JML Main
NOP

org $82B9
autoclean JML Exit
NOP

org $83B2
autoclean JML Exit2
NOP

freecode

Main2:
	SEP #$30
	PEI ($00)
	PEI ($02)
	PEI ($04)
	LDA $4211
	JML $808383
	
Main:
	SEP #$30
	PEI ($00)
	PEI ($02)
	PEI ($04)
	LDA $4210
	JML $808179
	
	
Exit2:
	REP #$30
	PLA
	STA $04
	PLA
	STA $02
	PLA
	STA $00
	PLB
	PLY
	PLX
	PLA	
	PLP		
	RTI	

Exit:
	STA.w $420C
	REP #$30
	PLA
	STA $04
	PLA
	STA $02
	PLA
	STA $00
	JML $8082BE
