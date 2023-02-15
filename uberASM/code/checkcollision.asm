CHECKCOLLISION:
	PHX
	LDX #$01
-	LDA $00,x : STA $0C	;\ Pos1 in $0C
	LDA $08,x : STA $0D	;/
	LDA $0A,x : XBA
	LDA $04,x
	REP #$20
	STA $0E			; > Pos2 in $0E
	LDA $02,x		;\
	AND #$00FF		; | Pos1 + Dim1 - Pos2
	CLC : ADC $0C		; |
	CMP $0E			;/
	BCC .Return		; > Return if smaller
	LDA $06,x		;\
	AND #$00FF		; | Pos2 + Dim2 - Pos1
	CLC : ADC $0E		; |
	CMP $0C			;/
	BCC .Return		; > Return if smaller
	SEP #$20
	DEX : BPL -		; > Check Y coordinates/height too
	PLX
	RTS

	.Return
	SEP #$20
	PLX
	RTS