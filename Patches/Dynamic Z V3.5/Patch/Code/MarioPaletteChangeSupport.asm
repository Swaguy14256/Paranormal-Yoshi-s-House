;#########################################################
;################ Mario Palette ##########################
;#########################################################
marioPalette:
	LDA $0D84|!base2
	BNE +
	RTS
+
	LDA !marioPal
	BNE +
	
	LDA $0100		;\
	CMP #$11		; | Branches if the gamemode number is less than 17.
	BCC .SKIP		;/
	JSR FRONTCOLORS		; Jumps to the front colors routine.
.SKIP
	REP #$20
	LDA $0D82|!base2
	STA $02
	SEP #$20
	STZ $0004|!base1
	LDY #$00
	LDA $0DA1		;\
	CMP #$07		; | Branches if the palette to use for Mario is palette F.
	BEQ .PALETTEF		;/
	LDA $0DA1		;\
	CMP #$08		; | Branches if the palette to use for Mario is not palette 8 with special behavior.
	BCC .PALETTEOFFSET	;/
	LDA #$86		;\
	STA $00			;/ Sets the start color index.
	LDA #$90		;\
	STA $01			;/ Sets the end color index.
	BRA .PALETTE		; Branches to the palette sublabel.
.PALETTEOFFSET
	ASL			;\
	ASL			; | Multiplies the palette to use by 16.
	ASL			; |
	ASL			;/
	CLC			;\
	ADC #$86		; | Sets the start color index.
	STA $00			;/
	ADC #$0A		;\
	STA $01			;/ Sets the end color index.
.PALETTE
	LDX $00			; Loads the start color index.
-
	STX $2121
	
	LDA [$02],y
	STA $2122
	INY
	LDA [$02],y
	STA $2122
	INY
	INX
	CPX $01			;\
	BCC -			;/ Branches if the color index is not the end color index.
	
	RTS
+
	LDY #$8F
	LDX #$09
-
	STY $2121
	
	LDA !marioPalLow,x
	STA $2122
	LDA !marioPalHigh,x
	STA $2122
	DEY
	DEX
	BPL -
	RTS

.PALETTEF
	LDX #$F6		; Loads the start color index.
.NOTCOLORF
	STX $2121		; Sets the color to write to.
	LDA [$02],y		;\
	STA $2122		;/ Sets the low byte of the color value.
	INY			; Increases the Y Register.
	LDA [$02],y		;\
	STA $2122		;/ Sets the high byte of the color value.
	INY			; Increases the Y Register.
	INX			; Increases the X Register.
	CPX #$FF		;\
	BCC .NOTCOLORF		;/ Branches if the color index is not color F.
	STX $2121		; Sets the color to write to.
	LDA [$02],y		;\
	STA $2122		;/ Sets the low byte of the color value.
	INY			; Increases the Y Register.
	LDA [$02],y		;\
	STA $2122		;/ Sets the high byte of the color value.
	INY			; Increases the Y Register.
	RTS			; Ends the code.

FRONTCOLORS:
	LDY #$00		; Sets the Y Register to 0.
	LDA $0DA1		;\
	CMP #$08		; | Branches if the palette to use for Mario is not palette 8 with special behavior.
	BCC NOPALETTEOFFSET	;/
	LDA #$81		;\
	STA $00			;/ Sets the start color index.
	LDA #$86		;\
	STA $01			;/ Sets the end color index.
	BRA COLOROVERWRITE	; Branches to the color overwrite routine.
NOPALETTEOFFSET:
	ASL			;\
	ASL			; | Multiplies the palette to use by 16.
	ASL			; |
	ASL			;/
	CLC			;\
	ADC #$81		; | Sets the start color index.
	STA $00			;/
	ADC #$05		;\
	STA $01			;/ Sets the end color index.
COLOROVERWRITE:
	LDX $00			; Loads the start color index.
COLORLOOP:
	STX $2121		; Sets the color to write to.
	LDA COLORS,y		;\
	STA $2122		;/ Sets the low byte of the color value.
	INY			; Increases the Y Register.
	LDA COLORS,y		;\
	STA $2122		;/ Sets the high byte of the color value.
	INY			; Increases the Y Register.
	INX			; Increases the X Register.
	CPX $01			;\
	BCC COLORLOOP		;/ Branches if the color index is not the end color index.
	RTS			; Ends the code.

COLORS: db $FF,$7F,$00,$00,$71,$0D,$9B,$1E,$7F,$3B