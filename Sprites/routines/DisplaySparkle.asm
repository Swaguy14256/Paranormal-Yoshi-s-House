;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set sparkle position routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LDA $13
AND #$1F
ORA $186C,x
BNE +
JSL $01ACF9
AND #$0F
CLC
LDY #$00
ADC #$FC
BPL SKIP
DEY
SKIP:
CLC
ADC $E4,x
STA $02
TYA
ADC $14E0,x
PHA
LDA $02
CMP $1A
PLA
SBC $1B
BNE +
LDA $148E
AND #$0F
CLC
ADC #$FE
ADC $D8,x
STA $00
LDA $14D4,x
ADC #$00
STA $01
JSR DISPLAY_SPARKLE
+
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; display sparkle routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

DISPLAY_SPARKLE:	LDY #$0B		; \ find a free slot to display effect
.loop
			LDA $17F0,y		;  |
			BEQ +			;  |
			DEY			;  |
			BPL .loop		;  |
			RTS			; / return if no slots open

+			LDA #$05		; \ set effect graphic to sparkle graphic
			STA $17F0,y		; /
			LDA #$00		; \ set time to show sparkle
			STA $1820,y		; /
			LDA $00			; \ sparkle y position
			STA $17FC,y		; /
 			LDA $02			; \ sparkle x position
			STA $1808,y		; /
			LDA #$17		; \ load generator x position and store it for later
			STA $1850,y		; /
			RTS			; return