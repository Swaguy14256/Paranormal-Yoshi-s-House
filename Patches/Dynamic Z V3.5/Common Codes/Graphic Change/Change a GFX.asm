!GraphicsToChange = #$0000 ;Here you must put the position into the VRAM that you will change, Look the Tutorial

GraphicChange:

	LDA !GFXNumber
	CMP #$0A
	BCC +
	RTS
+
	PHA
	INC A
	INC A
	STA !GFXNumber
	PLA
	ASL
	TAX

	PHB
	PLA
	STA !GFXBnk,x
	STA !GFXBnk+$02,x
	LDA #$00
	STA !GFXBnk+$01,x
	STA !GFXBnk+$03,x

	REP #$20
	LDA GFXPointer
	STA !GFXRec,x
	CLC
	ADC #$0800
	STA !GFXRec+$02,x

	LDA #$0800
	STA !GFXLenght,x
	STA !GFXLenght+$02,x

	LDA !GraphicsToChange
	STA !GFXVram,x
	CLC
	ADC #$0400
	STA !GFXVram+$02,x

	SEP #$20
	RTS

GFXPointer:
dw resource

resource:
incbin AnyGFXOf4kb.bin ;replace this for your GFX name	