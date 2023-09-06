;-----------------------------------------------------------------------------------
; Separate Status Bar Palettes - by Lui37
;-----------------------------------------------------------------------------------
; Ever wanted to use more palettes in your Layer 3 backgrounds, or change certain
; colors without messing the status bar up? Now you can! This patch works by
; overwriting the second halves of palettes 0 and 1, at the start of each frame,
; with the colors used by the status bar. Then, the actual palettes of the level
; will be restored right below it.
;
; By default, this will use the same status bar colors as the original SMW.
; However you can easily change that if needed, just modify the content of the
; !ColorXX defines right below this text.
;-----------------------------------------------------------------------------------

; Protip: you can copy the SNES RGB color values from Lunar Magic's palette editor

; Second half of palette 0
!Color08 = $7393
!Color09 = $0000
!Color0A = $0CFB
!Color0B = $2FEB
!Color0C = $7393
!Color0D = $0000
!Color0E = $7FDD
!Color0F = $2D7F
	
; Second half of palette 1
!Color18 = $7393
!Color19 = $0000
!Color1A = $7AAB
!Color1B = $7FFF
!Color1C = $7393
!Color1D = $0000
!Color1E = $1E9B
!Color1F = $3B7F

; You probably don't want to touch these
!VCount1 = $25
!VCount2 = !VCount1+2
!VCount3 = !VCount2+2

; The default v count has been moved down a scanline, since SMW normally
; waits for an extra scanline using a waste-time loop, anyway

;-----------------------------------------------------------------------------------

org $0081C9
	autoclean JML NMI_Hijack
	NOP
	
org $008292
	LDY #!VCount1
	
org $00838F
	autoclean JML IRQ_Hijack
	NOP

org $00A5E7
	autoclean JML Palette_Copy_Hijack
	
org $00AF5E
	autoclean JML Palette_Fade_Hijack
	NOP

assert read1($00AF71) != $A2, "Please, save your ROM in Lunar Magic first."

; code below nukes some nice lunar magic hack
if read1($00AF71) == $22
	!Address = read3($00AF72)-$08
	org !Address : rep 59 : db $00
endif
	
org $00AF71	
	BRA + : NOP #21 : +
	

freecode

NMI_Hijack:
	BEQ .upload_palettes	; only regular levels
	BPL .return
	JML $0082C4
.upload_palettes
	REP #$20
	LDX #$08		; set CGRAM address for first write
	STX $2121
	LDA #$2202		; write twice to $2122
	STA $4310
	LDA #Pal2and3		; set source address and bank
	STA $4312
	LDX #Pal2and3>>16
	STX $4314
	LDY #$10		; transfer size = 16 bytes
	STY $4315
	LDX #$02		; start first DMA
	STX $420B
	STY $4315		; transfer size = 16 bytes again
	LDY #$18		; CGRAM address for second write
	STY $2121
	LDA #Pal6and7		; set source address, bank is the same
	STA $4312
	STX $420B		; start second DMA on the same channel
	SEP #$20
.return
	JML $0081CE


IRQ_Hijack:
-	BIT $4212		; wait for h-blank to end
	BVS -

	LDA $11			; determine which IRQ we're in
	LSR A
	BCS IRQ2
	LSR A
	BCS IRQ3
IRQ1:
	LDA #!VCount2		; set up another IRQ for the next scanline
	STA $4209
	STZ $420A
	INC $11
	LDA #$A1		
	STA $4200
-	BIT $4212		; wait for h-blank to fire
	BVC -
	LDA $22			; I could simply JML $008394, sure
	STA $2111		; but that screws up the timing on a real SNES
	LDA $23
	STA $2111
	LDA $24
	STA $2112
	LDA $25
	STA $2112
	LDA $3E
	STA $2105
	LDA $40
	STA $2131
	JML $0083B2

IRQ2:
	REP #$20
	LDX #$08		; CGRAM address for first write
	STX $2121
	LDA #$2202		; write twice to $2122
	STA $4310
	LDA #$0713		; source address = $7E0713
	STA $4312
	LDX #$7E
	STX $4314
	LDX #$10		; transfer size = 16 bytes
	STX $4315
	SEP #$20
	LDA #$02		; prepare the DMA channel
-	BIT $4212
	BVC -
	STA $420B		; start DMA just as soon as h-blank fires
	LDA #!VCount3		; set up yet another IRQ for the next scanline
	STA $4209
	STZ $420A
	INC $11
	LDA #$A1		
	STA $4200
	JML $0083B2

IRQ3:
	REP #$20
	LDX #$18		; set CGRAM address for second write
	STX $2121
	LDA #$2202		; write twice to $2122
	STA $4310
	LDA #$0733		; source address = $7E0733
	STA $4312
	LDX #$7E
	STX $4314
	LDX #$10		; transfer size = 16 bytes
	STX $4315
	SEP #$20
	LDA #$02
-	BIT $4212
	BVC -
	STA $420B
	STZ $11
	JML $0083B2

Palette_Copy_Hijack:
	LDA $0100
	AND #$00FF
	CMP #$0012
	BNE .return
	PHK			; DBR was already preserved before the MVN
	PLB
	SEP #$10		; and A/X/Y are 16-bit
	LDX #$0E		; write the status bar colors to the palette backup
-	LDA Pal2and3,x
	STA $0915,x
	DEX
	DEX
	BPL -
	LDX #$0E
-	LDA Pal6and7,x
	STA $0935,x
	DEX
	DEX
	BPL -
	REP #$10
.return
	PLB			; hijacked code
	LDX $0701
	JML $00A5EB


Palette_Fade_Hijack:
	TXA
	CMP #$003E		; don't touch status bar colors at all
	BEQ .skip_slots
	CMP #$001E
	BEQ .skip_slots
	LDA $04
	STA $0905,x
	JML $00AF63
	
.skip_slots
	LDA $00
	SEC
	SBC #$0008
	STA $00
	TXA
	SEC
	SBC #$0010
	TAX
	JML $00AF53
	
	
Pal2and3:		
	dw !Color08, !Color09, !Color0A, !Color0B
	dw !Color0C, !Color0D, !Color0E, !Color0F
	
Pal6and7:
	dw !Color18, !Color19, !Color1A, !Color1B
	dw !Color1C, !Color1D, !Color1E, !Color1F
