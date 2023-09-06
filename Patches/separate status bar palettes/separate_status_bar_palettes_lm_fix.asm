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
!Color08 = $15D2
!Color09 = $0000
!Color0A = $0CFB
!Color0B = $2FEB
!Color0C = $7393
!Color0D = $6B55
!Color0E = $7398
!Color0F = $7FDD
	
; Second half of palette 1
!Color18 = $7393
!Color19 = $0000
!Color1A = $7AAB
!Color1B = $7FFF
!Color1C = $7393
!Color1D = $0000
!Color1E = $1E9B
!Color1F = $3B7F

; Second half of palette 0 for cutscene
!Color28 = $6318
!Color29 = $0000
!Color2A = $3DEF
!Color2B = $56B5
!Color2C = $6318
!Color2D = $0000
!Color2E = $7BDE
!Color2F = $56B5
	
; Second half of palette 1 for cutscene
!Color38 = $6318
!Color39 = $0000
!Color3A = $5294
!Color3B = $7FFF
!Color3C = $6318
!Color3D = $0000
!Color3E = $4631
!Color3F = $5AD6

; You probably don't want to touch these
!VCount1 = $25
!VCount2 = !VCount1+2
!VCount3 = !VCount2+2

!free_dp = $61				; 2 bytes needed

; The default v count has been moved down a scanline, since SMW normally
; waits for an extra scanline using a waste-time loop, anyway

;-----------------------------------------------------------------------------------

org $0081C9
	autoclean JML NMI_Hijack
	NOP

org $008275
	autoclean JML NMI_hijack
	
org $008292
oos:
	LDY #!VCount1
	
org $00838F
	autoclean JML IRQ_Hijack
	NOP

org $00AE5E
	autoclean JML BACKGROUNDCOLORHIJACK	; Jumps to the background color hijack routine.

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
	JML $8082C4
.upload_palettes
;	LDA $0F3E				;\
;	BEQ .NOBLACK				;/ Branches if the fullscreen Layer 3 flag is set.
;	REP #$20				; Turns on 16-bit addressing for the Accumulator.
;	LDA #$0000				;\
;	ASL #3					;/ Multiplies the black color by 8.
;	SEP #$21				; Turns on 8-bit addressing for the Accumulator and sets the carry flag.
;	ROR #3					; Shifts the color to the right 3 times.
;	XBA					; Exchanges the high byte with the low byte.
;	ORA #$40				;\
;	STA $2132				;/ Writes the first background color byte.
;	LDA #$00				;\
;	LSR A					;/ Shifts the high byte of the color to the right.
;	SEC					; Sets the carry flag.
;	ROR					; Shifts the high byte of the color to the right again.
;	STA $2132				; Writes the second background color byte.
;	XBA					; Exchanges the high byte with the low byte.
;	STA $2132				; Writes the third background color byte.
;.NOBLACK
;	JMP FIXBACKGROUNDCOLOR			; Jumps to the fix background color routine.
.RESUME
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
	JML $8081CE

NMI_hijack:
	STZ !free_dp
	STZ !free_dp+1
	LDA $0D9B
	BNE .special
	LDA $7FC01A			; LM layer 3 settings stuff
	AND #$08
	BEQ .not_enabled
	REP #$20
	LDA $0D9D		; put the status bar on the main screen
	STA !free_dp
	AND #$FBFF
	ORA #$0004
	STA $212C
	; STA $212E
	SEP #$20
.not_enabled
	JML $808292
	
.special
	JML $80827A

IRQ_Hijack:
;	LDA $1487
;	XBA
;	LDX $1488
;	LDY $1489
-	BIT $4212		; wait for h-blank to end
	BVS -

	LDA $11			; determine which IRQ we're in
	LSR A
	BCS IRQ2
	LSR A
	BCC IRQ1				; Branches if the carry flag is not set.
	BRL IRQ3				; Branches to the third IRQ routine.
IRQ1:
	LDA #!VCount2		; set up another IRQ for the next scanline
	STA $4209
	STZ $420A
	INC $11
	LDA #$A1		
	STA $4200
	XBA
-	BIT $4212		; wait for h-blank to fire
	BVC -
;	STA $2132
;	STX $2132
;	STY $2132
	NOP
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
;	JML $8083B2
	REP #$30
	LDA !free_dp			; it is never not time to fast
	BEQ .not_enabled
	STA $212C			; put layer 3 on the sub screen
	; STA $212E
.not_enabled
	PLA				;\
	STA $04				; |
	PLA				; | Restores scratch RAM addresses $00-$04.
	STA $02				; |
	PLA				; |
	STA $00				;/
	PLB
	PLY
	PLX
	PLA
	PLP	
	RTI

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
	JML $8083B2

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
	JML $8083B2


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
	JML $80A5EB


Palette_Fade_Hijack:
	TXA
	CMP #$003E		; don't touch status bar colors at all
	BEQ .skip_slots
	CMP #$001E
	BEQ .skip_slots
	LDA $04
	STA $0905,x
	JML $80AF63
	
.skip_slots
	LDA $00
	SEC
	SBC #$0008
	STA $00
	TXA
	SEC
	SBC #$0010
	TAX
	JML $80AF53
FIXBACKGROUNDCOLOR:
	JMP NMI_Hijack_RESUME			; Jumps to the NMI hijack resume sublabel.

BACKGROUNDCOLORHIJACK:
	PHA					; Preserves the Accumulator.
	LDA $0F3E				;\
	BNE SKIPBACKGROUNDCOLOR			;/ Branches if the fullscreen layer 3 flag is set.
	PLA					; Pulls back the Accumulator.
	STA $2132				; Sets the background color.
	DEX					; Decreases the X Register.
	JML $80AE62				; Jumps back to the original code.
SKIPBACKGROUNDCOLOR:
	PLA					; Pulls back the Accumulator.
	LDA #$25				;\
	STA $0F5E				; | Sets the scanline count for the black background.
	STA $0F65				;/
	LDA #$80				;\
	STA $0F61				; | Sets the scanline count for the background color and the blue color value for the black background.
	STA $0F66				; |
	STA $0F67				;/
	LDA #$20				;\
	STA $0F5F				;/ Sets the red color value for the black background.
	ASL					;\
	STA $0F60				;/ Sets the green color value for the black background.
;	STA $2132				; Sets the background color.
;	DEX					; Decreases the X Register.
;	JML $80AE62				; Jumps back to original code.
	REP #$20				; Turns on 16-bit addressing for the Accumulator.
	LDA $0701				;\
	ASL #3					;/ Multiplies the background color by 8.
	SEP #$21				; Turns on 8-bit addressing for the Accumulator and sets the carry flag.
	ROR #3					; Shifts the color to the right 3 times.
	XBA					; Exchanges the high byte with the low byte.
	ORA #$40				;\
	STA $0F62				;/ Writes the first background color byte.
	LDA $0702				;\
	LSR A					;/ Shifts the high byte of the color to the right.
	SEC					; Sets the carry flag.
	ROR					; Shifts the high byte of the color to the right again.
	STA $0F63				; Writes the second background color byte.
	XBA					; Exchanges the high byte with the low byte.
	STA $0F68				; Writes the third background color byte.
	STZ $0F64				;\
	STZ $0F69				;/ Sets the termination bytes for the background color and the black background.
	JML $80AE64				; Jumps back to the original code.

Pal2and3:		
	dw !Color08, !Color09, !Color0A, !Color0B
	dw !Color0C, !Color0D, !Color0E, !Color0F
	
Pal6and7:
	dw !Color18, !Color19, !Color1A, !Color1B
	dw !Color1C, !Color1D, !Color1E, !Color1F
