;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SRAM Plus
;
; This patch basically rewrites all of the SRAM saving, loading, and erasing
; save file routines that SMW uses. It uses DMA to copy the values, meaning that
; it is much more efficient than before. The patch also frees up 141 bytes at
; $1F49 by moving the SRAM buffer to $1EA2.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $009B41
		LDY #$04			; Initialize the loop counter.
		
	-	LSR $0DDE			; If the bit is set to clear this save file,
		BCC +
		
		REP #$30
		LDX sram_locs,y
		LDA #$DEAD			; invalidate the SRAM validation bytes.
		STA $6FFFFE,x
		SEP #$30
		
	+	DEY
		DEY
		BPL -				; Loop to the next save file.
		JMP $9C89
		
		autoclean JML sram_table	; Clean the SRAM table (this is never executed, of course).
		
org $009BC9
		LDA #$70
		STA $4314			; Set the DMA destination bank to $70.
		
		LDA $010A
		ASL
		TAX
		REP #$30
		LDA #$8080
		STA $4310			; Read bytes from $2180 into SRAM.
		LDA.l sram_locs,x
		TAX
		LDA #$BEEF
		STA $6FFFFE,x			; Set the SRAM validation bytes.
		JSR load_save_dma		; DMA the RAM addresses into the SRAM addresses.
		SEP #$30
		RTL
		
org $009CCB
sram_locs:	dw $0002,$2002,$4002
		
org $009CF2
		JSR is_empty
		PHP
		BEQ .not_empty			; If the save file is empty,
		
		LDX.w #sram_defaults
		LDA.b #sram_defaults>>16	; DMA SRAM defaults.
		BRA +
		
	.not_empty
		STZ $0109			; Otherwise, don't go to the intro,
		
		LDA #$70			; and DMA SRAM.
	+	STA $4314
		
		REP #$20
		LDA #$8000
		STA $4310			; Write bytes to $2180.
		JSR load_save_dma		; DMA the SRAM addresses into the RAM addresses.
		
		PLP
		SEP #$30
		BEQ +
		
		JSR $9F06
		
	+	INC $0100			; Set the next game mode.
		LDA #$12
		STA $12				; Set the next stripe image.
		LDX #$00
		JMP $9ED4
		
org $009DB5
is_empty:	TXA
		ASL
		TAY				; Multiply the save file by two.
		REP #$30
		LDX sram_locs,y
		LDA $6FFFFE,x
		CMP #$BEEF			; Check if the first two bytes are $BEEF.
		SEP #$20
		RTS
		
load_save_dma:	STX $4312			; Set the DMA destination/source.
		
		LDX #$0000			; Initialize the loop counter.
	-	LDA.l sram_table,x
		STA $2181			; Set the lower two bytes of the RAM address.
		LDA.l sram_table+3,x
		STA $4315			; Set the number of bytes to transfer.
		SEP #$20
		LDA.l sram_table+2,x
		STA $2183			; Set the high bit of the RAM address.
		LDA #$02
		STA $420B			; Enable channel 1 DMA.
		REP #$21
		TXA
		ADC #$0005			; Add five for the next RAM address and size to use.
		TAX
		CPX.w #sram_table_end-sram_table
		BNE -
		RTS
		
org $00FFD8
		db $07				; Set the SRAM size to 128 KB.
		
org $009F08
		STZ $1EA1,x			; $1F49 remaps from below onwards.
		
org $009F16
		STA $1EA2,y
		
if read1($009F19) == $22			; LM hijack #1.
	if read1(read3($009F1A)+$1) == $C2
		org read3($009F1A)+$A		; LM version >= 2.53
			STA $001EA2,x
	else
		org read3($009F1A)+$B		; LM version < 2.53
			STA $1EA2,x
	endif
endif
		
org $009F22
		STA $1F85,x			; Sets the initial overworld backup status.
		
org $00A19A
		LDA $1EA2,x
		
if read1($01E762) == $22			; LM hijack #2.	
	org read3($01E763)+$7
			RTL
;else
	; was causing an issue with message sprite fix LM hijack
	;org $01E765
	;		STA $1F11		
endif
		
org $048F94
		LDX #$15			; Loads a loop count of 21.
		LDA $1F11,x			;\
		STA $1F85,x			;/ Backs up the overworld status.
		
org $048FA9
		LDA $1F8B,x			; Loads the current character's X position.
		
org $048FAC
		STA $1F8B,y			; Sets the other character's X position.
		
org $048FAF
		LDA $1F8D,x			; Loads the current character's Y position.
		
org $048FB2
		STA $1F8D,y			; Sets the other character's Y position.
		
org $048FB5
		LDA $1F93,x			; Loads the current character's X position pointer.
		
org $048FB8
		STA $1F93,y			; Sets the other character's X position pointer.
		
org $048FBB
		LDA $1F95,x			; Loads the current character's Y position pointer.
		
org $048FBE
		STA $1F95,y			; Sets the other character's Y position pointer.
		
org $048FC8
		LDA $1F87,x			; Loads the current character's overworld animation.
		
org $048FCB
		STA $1F87,y			; Sets the other character's overworld animation.
		
org $048FD6
		LDA $1F85,x			; Loads the current character's submap.
		
org $048FD9
		STA $1F85,y			; Sets the other character's submap.
		
org $049046
		STA $1EA2,x

freedata
reset bytes
		incsrc "sram_table.asm"

print "Bytes inserted: ", bytes