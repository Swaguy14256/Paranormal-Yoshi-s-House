;; extended sprite -> mario interaction.
   LDA $171F|!Base2,x
	CLC
	ADC #$03
	STA $04
	LDA $1733|!Base2,x
	ADC #$00
	STA $0A
	LDA #$0A
	STA $06
	STA $07
	LDA $1715|!Base2,x
	CLC
	ADC #$03
	STA $05
	LDA $1729|!Base2,x
	ADC #$00
	STA $0B
	JSL $03B664|!BankB
	JSL $03B72B|!BankB
	BCC .skip
	LDA #!StunTimer		;\
	STA $18BD		;/ Stuns Mario.
	LDA #$1C		;\
	STA $1DFC		;/ Sets the sound to play.
	LDA #$01		;\
	STA $5C			;/ Sets the ice block flag.
	STZ $170B,x		; Destroys the extended sprite.
.skip
	RTL
