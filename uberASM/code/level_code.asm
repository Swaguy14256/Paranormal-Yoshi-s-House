;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;True LevelASM Code lies ahead.
;If you are too lazy to search for a level
;Use CTRL+F. The format is as following:
;levelx - Levels 0-F
;levelxx - Levels 10-FF
;levelxxx - Levels 100-1FF
;Should be pretty obvious...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level0:
	RTS
level1:
	RTS
level2:
	RTS
level3:
	RTS
level4:
	RTS
level5:
	RTS
level6:
	RTS
level7:
	RTS
level8:
	RTS
level9:
	RTS
levelA:
	RTS
levelB:
	RTS
levelC:
	RTS
levelD:
	RTS
levelE:
	RTS
levelF:
	RTS
level10:
	RTS
level11:
	RTS
level12:
	RTS
level13:
	RTS
level14:
	RTS
level15:
	RTS
level16:
	RTS
level17:
	RTS
level18:
	RTS
level19:
	RTS
level1A:
	RTS
level1B:
	RTS
level1C:
	RTS
level1D:
	RTS
level1E:
	RTS
level1F:
	RTS
level20:
	RTS
level21:
	RTS
level22:
	RTS
level23:
	RTS
level24:
	RTS
level25:
RESET:
	LDA #$28			;\
	STA $13BF			;/ Resets the level to level 104's translevel number.
	RTS				; Ends the code.
level26:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level27:
	JSR RESET			; Calls the translevel number reset routine.
	LDA $0F31			;\
	ORA $0F32			; |
	ORA $0F33			; | Branches if the time limit is at 0 seconds.
	BEQ TELEPORT			;/
	LDA $19				;\
	STA $79				;/ Preserves Mario's current power-up status.
	RTS				; Ends the code.
TELEPORT:
	LDA $79				;\
	STA $19				;/ Restores Mario's current power-up status.
	LDA #$06			;\
	STA $71				; | Activates the screen exit of whatever screen
	STZ $89				; | Mario is currently on.
	STZ $88				;/
	RTS				; Ends the code.
level28:
	LDA $5C				; Loads the message timer.
	BEQ NOTIME			; Branches if the timer is 0.
	STZ $15				;\
	STZ $16				; |
	STZ $17				; | Disables Mario's conrtols.
	STZ $18				;/
	LDA #$01			;\
	STA $13D3			;/ Disables pausing.
	DEC $5C				; Decreases the message timer.
NOTIME:
	LDA $13D4			;\
	BEQ RESUME			;/ Branches if the game is not paused.
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
RESUME:	
	LDA #$06			;\
	STA $13BF			;/ Changes the translevel number.
	RTS				; Ends the code.	
level29:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level2A:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level2B:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level2C:
	JSR RESET			; Calls the translevel number reset routine.
	LDA $1B9B			;\
	BEQ KEEPYOSHI			;/ Branches if Yoshi is allowed to appear when exiting the level.
	LDX #$0B			; Loads a loop count of 11.
YOSHILOOP:
	LDA $9E,x			;\
	CMP #$35			; | Branches if a Yoshi is not present.
	BNE NOYOSHI			;/
	LDA $14C8,x			;\
	BEQ NOYOSHI			;/ Branches if the present Yoshi is dead.
	STZ $0DC1			; Prevents Yoshi from being carried when exiting the level.
	STZ $1B9B			; Makes Yoshi appear when exiting the level.
	RTS				; Ends the code.
NOYOSHI:
	DEX				; Decreases the X Register.
	BPL YOSHILOOP			; Loops the Yoshi loop until it is -1.
KEEPYOSHI:
	RTS				; Ends the code.
level2D:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level2E:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level2F:
	JSR RESET			; Calls the translevel number reset routine.
	LDX #$0B			; Loads a loop count of 11.
KEYLOOP:
	LDA $9E,x			;\
	CMP #$80			; | Branches if a key is not present.
	BNE NOKEY			;/	
	STZ $15F6,x			; Makes the sprite use palette 8.
NOKEY:
	DEX				; Decreases the X Register.
	BPL KEYLOOP			; Loops the key loop until it is -1.
	LDA $71				;\
	CMP #$0A			; | Branches if the castle/ghost house intro is playing.
	BEQ RETURN			;/
	LDA $9D				;\
	ORA $13D4			; | Branches if the game is paused or locked.
	BNE RETURN			;/
	LDA $95				;\
	CMP #$06			; |
	BCC RETURN			; | Branches if Mario is not in screens 6 to B.
	CMP #$0C			; |
	BCS RETURN			;/
	CMP #$06			;\
	BNE KEEPGENERATORS		;/ Branches if Mario is not in screen 6.
	STZ $18B9			; Turns off generators.
KEEPGENERATORS:
	LDA $17				;\
	AND #$30			; | Branches if the L and R buttons are not pressed.
	CMP #$30			; |
	BNE RETURN			;/
	LDA #$01			;\
	STA $1DFC			;/ Sets the sound to play.
	LDA #$06			;\
	STA $71				; |
	STZ $88				; | Teleports the player.
	STZ $89				;/
RETURN:
	LDA $0DBF			;\
	CMP #$63			; | Branches if Mario has the specified number of coins.
	BEQ TURNONANIMATION		;/
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $7FC0FC			;\
	AND #$FFFE			; | Turns off the Custom 0 ExAnimation.
	STA $7FC0FC			;/
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	RTS				; Ends the code.
TURNONANIMATION:
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $7FC0FC			;\
	ORA #$0001			; | Turns on the Custom 0 ExAnimation.
	STA $7FC0FC			;/
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	RTS				; Ends the code.
level30:
	JSR RESET			; Calls the translevel number reset routine.
	STZ $0DBF			; Sets Mario's coin status to 0.
	LDX #$0B			; Loads a loop count of 11.
KEYLOOP2:
	LDA $9E,x			;\
	CMP #$80			; | Branches if a key is not present.
	BNE NOKEY2			;/
	LDA #$0E			;\	
	STA $15F6,x			;/ Makes the sprite use palette F.
NOKEY2:
	DEX				; Decreases the X Register.
	BPL KEYLOOP2			; Loops the key loop until it is -1.
	RTS				; Ends the code.
level31:
	JSR RESET			; Calls the translevel number reset routine.
	JSR ICEBLOCK			; Jumps to the ice block routine.
	JSR CLUSTERLOOP			; Jumps to the cluster loop and warning sign routine.
	JSR LIGHTNINGLOOP		; Jumps to the lightning loop routine.
	LDA $79				;\
	BEQ ENABLECONTROLS		;/ Branches if the disable controls flag is 0.
	STZ $15				;\
	STZ $16				; |
	STZ $17				; | Disables Mario's conrtols.
	STZ $18				;/
	LDA #$01			;\
	STA $13D3			;/ Disables pausing.
ENABLECONTROLS:
	LDA #$20            		;\ 
	TSB $0D9F           		;/ Enables HDMA channel 5.
	LDA $9D				;\
	BNE NOWAVES			;/ Branches if the lock sprites timer is not 0.
	LDY $87				;\
	BMI WAVES			;/ Branches if the thunder flash timer is -1.
	LDX #$00			; Loads 0 into the X Register.
	LDA SCANLINES,x			; Loads the number of scanlines for the thunder flash to write to.
	STA $0F5E,x			; Stores the scanlines to the thunder flash HDMA table.
THUNDERFLASHLOOP:
	INX				; Increases the X Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	STZ $0F5E,x			; Writes the first 2 bytes of the color value.
	INX				;\
	INX				;/ Increases the X Register 2 times.
	REP #$30			; Turns on 16-bit addressing mode for the A, X, and Y Registers.
	TYA				; Transfers the Y Register to the Accumulator.
	ASL				; Shifts the bits to the left.
	TAY				; Transfers the Accumulator to the Y Register.
	LDA CGRAMVALUES,y		;\
	STA $0F5E,x			;/ Loads the next 2 bytes of the color value.
	SEP #$30			; Turns on 8-bit addressing mode for the A, X, and Y Registers.
	INX				;\
	INX				;/ Increases the X Register 2 times.
	CPX #$0A			;\
	BCS NOMORESCANLINES		;/ Branches if the X Register is 10.
	PHX				; Preserves the X Register.
	LDX #$01			; Loads 1 into the X Register.
	LDA SCANLINES,x			; Loads the number of scanlines for the thunder flash to write to.
	PLX				; Pulls back the X Register.
	STA $0F5E,x			; Stores the scanlines to the thunder flash HDMA table.
	LDY $87				; Loads the thunder flash timer.
	BRA THUNDERFLASHLOOP		; Branches to the thunder flash loop.
NOWAVES:
	RTS				; Ends the code.
NOMORESCANLINES:	
	DEC $87				; Decreases the thunder flash timer.
WAVES:
	LDA $7C				;\
	BEQ NOWAVES			;/ Branches if the level state is no waves.
	CMP #$02			;\
	BCC MAKEWAVES			;/ Branches if the level state is make waves.
	CMP #$07			;\
	BCS RESUMETIMER			;/ Branches if the level state is resume gameplay.
	LDA $06FB			;\
	STA $0F30			;/ Forces the time limit to pause.
RESUMETIMER:
	JMP KILLITEM			; Jumps to the kill item routine.
MAKEWAVES:
	LDY #$00			; Loads the wave counter.
	LDX #$00			; Loads 0 into the X Register.
	LDA $14				;\
	LSR #2				; | Sets the speed of the waves.
	STA $00				;/
	PHB				;\
	PHK				; | Preserves the Data Bank.
	PLB				;/
WAVELOOP:
	LDA #$06			;\
	STA $7F9E00,x			;/ Sets the scanline height for each wave.
	TYA				; Transfers the Y Register to the Accumulator.
	ADC $00				; Adds the speed of the waves to the wave counter.
	AND #$0F			; Keeps the last 4 bits.
	PHY				; Preserves the Y Register.
	TAY				; Transfers the Accumulator to the Y Register.
	LDA.w WAVEVALUES,y		; Loads the wave value.
	LSR				; Shifts the bits to the right.
	CLC				;\
	ADC $1A				; | Offsets the low byte of the wave's X position by the low byte of the current Layer 1 X position.
	STA $7F9E01,x			;/
	LDA $1B				;\
	ADC #$00			; | Offsets the high byte of the wave's X position by the high byte of the current Layer 1 X position.
	STA $7F9E02,x			;/
	PLY				; Pulls back the Y Register.
	CPY #$25			;\
	BPL WAVEEND			;/ Branches if the wave counter is 37.
	INX				;\
	INX				; | Increases the X Register 3 times.
	INX				;/ 
	INY				; Increases the Y Register.
	BRA WAVELOOP			; Branches to the wave loop routine.
WAVEEND:
	PLB				; Pulls back the Data Bank.
	LDA #$00			;\
	STA $7F9E03,x			;/ Sets the end HDMA value.
	LDY #$00			; Loads the wave counter.
	LDX #$00			; Loads 0 into the X Register.
	LDA $14				;\
	LSR #2				; | Sets the speed of the waves.
	STA $00				;/
	PHB				;\
	PHK				; | Preserves the Data Bank.
	PLB				;/
WAVELOOP2:
	LDA #$06			;\
	STA $7F9F00,x			;/ Sets the scanline height for each wave.
	TYA				; Transfers the Y Register to the Accumulator.
	ADC $00				; Adds the speed of the waves to the wave counter.
	AND #$0F			; Keeps the last 4 bits.
	PHY				; Preserves the Y Register.
	TAY				; Transfers the Accumulator to the Y Register.
	LDA.w WAVEVALUES,y		; Loads the wave value.
	LSR				; Shifts the bits to the right.
	CLC				;\
	ADC $1E				; | Offsets the low byte of the wave's X position by the low byte of the current Layer 2 X position.
	STA $7F9F01,x			;/
	LDA $1F				;\
	ADC #$00			; | Offsets the high byte of the wave's X position by the high byte of the current Layer 2 X position.
	STA $7F9F02,x			;/
	PLY				; Pulls back the Y Register.
	CPY #$25			;\
	BPL WAVEEND2			;/ Branches if the wave counter is 37.
	INX				;\
	INX				; | Increases the X Register 3 times.
	INX				;/ 
	INY				; Increases the Y Register.
	BRA WAVELOOP2			; Branches to the wave loop routine.
WAVEEND2:
	PLB				; Pulls back the Data Bank.
	LDA #$00			;\
	STA $7F9F03,x			;/ Sets the end HDMA value.
	RTS				; Ends the code.

WAVEVALUES:
db $00,$01,$02,$03,$04,$05,$06,$07
db $07,$06,$05,$04,$03,$02,$01,$00

SCANLINES:
db $80,$60

CGRAMVALUES:
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
dw $0000,$0000,$0000,$0000,$0000,$0000,$0421,$0842
dw $0C63,$1084,$14A5,$18C6,$1CE7,$2108,$2529,$294A
dw $2D6B,$318C,$35AD,$39CE,$3DEF,$4210,$4631,$4A52
dw $4E73,$5294,$56B5,$5AD6,$5EF7,$6318,$6739,$6B5A
dw $6F7B,$739C,$77BD,$7BDE,$7FFF

KILLITEM:
	LDX $0DB3			;\
	LDA $0DC3,x			; | Restores Mario/Luigi's coins.
	STA $0DBF			;/
	LDA $06FA			;\
	BEQ REMOVEITEMS			;/ Branches if the kill item timer is 0.
	BRL KEEPITEMS			; Branches to the keep item routine.
REMOVEITEMS:
	LDA $7C				;\
	CMP #$03			; | Branches if the level state is not spawn door.
	BCS SPAWNDOOR			;/
	LDX #$0B			; Loads a loop count of 11.
FINDMOREITEMSLOOP:
	LDA $9E,x			;\
	CMP #$74			; |
	BCS KILLPOWERUP			; | Branches if a power up is on screen.
	CMP #$78			; |
	BCC KILLPOWERUP			;/
DEADITEM:
	DEX				; Decreases the X Register.
	BPL FINDMOREITEMSLOOP		; Loops the find more items loop until it is -1.
	LDA $0DC2			;\
	BEQ NORESERVEITEM		;/ Branches if Mario has a reserve item.
	STZ $0DC2			; Removes Mario's reserve item.
	LDA #$12			;\
	STA $06FA			;/ Sets the kill item timer.
	LDA #$08			;\
	STA $1DF9			;/ Sets the sound to play.
	JSR ITEMSMOKE			; Jumps to the item smoke routine.
	LDA #$D0			;\
	STA $17C4,y			; |
	LDA #$00			; | Sets the Y position of the smoke.
	STA $18C5,y			;/
	LDA #$78			;\
	STA $17C8,y			; |
	LDA #$00			; | Sets the X position of the smoke.
	STA $18C9,y			;/
NORESERVEITEM:
	LDA #$03			;\
	STA $7C				;/ Sets the level state to spawn door.
	RTS				; Ends the code.
KILLPOWERUP:
	LDA $14C8,x			;\
	BEQ DEADITEM			;/ Branches if the power up is dead.
	STZ $14C8,x			; Deletes the power up.
	LDA #$12			;\
	STA $06FA			;/ Sets the kill item timer.
	LDA #$08			;\
	STA $1DF9			;/ Sets the sound to play.
ITEMSMOKE:
	LDY #$03			; Loads a loop count of 3.
ITEMSMOKELOOP:
	LDA $17C0,y			;\
	BEQ FREEITEMSMOKE		;/ Branches if a free smoke slot is available.
	DEY				; Decreases the Y Register.
	BPL ITEMSMOKELOOP		; Loops the find item smoke loop until it is -1.
	RTS				; Ends the code
FREEITEMSMOKE:
	LDA #$01			;\
	STA $17C0,y			;/ Sets the smoke sprite.
	LDA #$1B			;\
	STA $17CC,y			;/ Sets the smoke timer.
	LDA $D8,x			;\
	STA $17C4,y			; |
	LDA $14D4,x			; | Sets the Y position of the smoke.
	STA $18C5,y			;/
	LDA $E4,x			;\
	STA $17C8,y			; |
	LDA $14E0,x			; | Sets the X position of the smoke.
	STA $18C9,y			;/
	RTS				; Ends the code.
KEEPITEMS:
	DEC $06FA			; Decreases the kill item timer.
	RTS				; Ends the code.
SPAWNDOOR:
	CMP #$04			;\
	BCS ENDDOORSPAWN		;/ Branches if the level state is end door spawn.
	LDX #$02			; Loads a loop count of 2.
DOORLOOP:
	TXA				; Transfers the X Register to the Accumulator.
	ASL				; Shifts the bits to the left.
	TAX				; Transfers the Accumulator to the X Register.
	REP #$30			; Turns on 16-bit addressing mode for the Accumulator.
	LDA #$0010			;\
	STA $9A				;/ Sets the X position of the door.
	LDA DOORYPOSITIONS,x		;\
	STA $98				;/ Sets the Y position of the door.
	LDA DOORTILES,x			; Loads the current door tile to use.
	JSR CHANGEMAP16			; Jumps to the change Map16 routine.
	SEP #$30			; Turns on 8-bit addressing mode for the Accumulator.
	TXA				; Transfers the X Register to the Accumulator.
	LSR				; Shifts the bits to the right.
	TAX				; Transfers the Accumulator to the X Register.
	DEX				; Decreases the X Register.
	BPL DOORLOOP			; Loops the door loop until it is -1.
	LDX #$02			; Loads a loop count of 2.
DOORSMOKELOOP:
	JSR ITEMSMOKE			; Jumps to the item smoke routine.
	LDA DOORSMOKEYPOSITIONS,x	;\
	STA $17C4,y			; |
	LDA #$01			; | Sets the Y position of the smoke.
	STA $18C5,y			;/
	LDA #$10			;\
	STA $17C8,y			; |
	LDA #$00			; | Sets the X position of the smoke.
	STA $18C9,y			;/
	DEX				; Decreases the X Register.
	BPL DOORSMOKELOOP		; Loops the door smoke loop until it is -1.
	INC $7C				; Increases the level state.
	LDA #$38			;\
	STA $1DFC			;/ Sets the sound to play.
	LDA #$1F			;\
	STA $06FA			;/ Sets door smoke timer.
	RTS				; Ends the code.
ENDDOORSPAWN:
	CMP #$05			;\
	BCS PICKUPITEM			;/ Branches if the level state is pick up item.
	LDA $06FA			;\
	BNE SMOKEREMAINS		;/ Branches if the door smoke timer is not 0.
	LDA $0DB3			;\
	BNE LUIGI			;/ Branches if the current character is Luigi.
	LDA #$42			;\
	STA $13BF			;/ Sets the translevel number.
	BRA DISPLAYPLAYERMESSAGE	; Branches to the display player message routine.
LUIGI:
	LDA #$43			;\
	STA $13BF			;/ Sets the translevel number.
DISPLAYPLAYERMESSAGE:
	LDA #$01			;\
	STA $1426			;/ Displays level message 1.
	INC $7C				; Increases the level state.
	LDA #$01			;\
	STA $06FA			;/ Sets the message timer.
SMOKEREMAINS:
	RTS				; Ends the code.
PICKUPITEM:
	CMP #$06			;\
	BCS LASTMESSAGE			;/ Branches if the level state is last message.
	LDA $06FA			;\
	BNE FINDWMS			;/ Branches if the message timer is not 0.
	LDA #$0B			;\
	STA $1DFC			;/ Sets the sound to play.
	LDA #$44			;\
	STA $13BF			;/ Sets the translevel number.
	LDA #$01			;\
	STA $1426			;/ Displays level message 1.
	INC $7C				; Increases the level state.
	LDA #$01			;\
	STA $06FA			;/ Sets the message timer.
FINDWMS:
	RTS				; Ends the code.
LASTMESSAGE:
	CMP #$07			;\
	BCS WAITSOMEMORE		;/ Branches if the level state is resume level.
	LDA $06FA			;\
	BNE WAITSOMEMORE		;/ Branches if the message timer is not 0.
	LDA $0DB3			;\
	BNE LUIGI2			;/ Branches if the current character is Luigi.
	LDA #$42			;\
	STA $13BF			;/ Sets the translevel number.
	BRA DISPLAYPLAYERMESSAGE2	; Branches to the display player message routine.
LUIGI2:
	LDA #$43			;\
	STA $13BF			;/ Sets the translevel number.
DISPLAYPLAYERMESSAGE2:
	LDA #$02			;\
	STA $1426			;/ Displays level message 2.
	INC $7C				; Increases the level state.
	STZ $79				; Enables Mario's controls.
WAITSOMEMORE:
	RTS				; Ends the code.

DOORYPOSITIONS:
dw $0170,$0160,$0150

DOORSMOKEYPOSITIONS:
db $70,$60,$50

DOORTILES:
dw $0020,$0020,$001F

incsrc changemap16.asm

ICEBLOCK:
	LDA $18BD			;\
	BEQ NOSTUN			;/ Branches if Mario is not stunned.
	LDA $06F9			;\
	BNE NOSTUN			;/ Branches if the regular stun flag is not 0.
	LDA $71				;\
	CMP #$09			; | Branches if Mario is dying.
	BEQ NOSTUN			;/
	JSR ICEBLOCKGRAPHICS		; Jumps to the graphics routine of the ice block.
	RTS				; Ends the code.
NOSTUN:
	LDA $5C				;\
	BEQ NOSHATTER			;/ Branches if the shatter block flag is 0.
	LDA $D1				;\
	STA $9A				; | Stores Mario's X position into the block's X position.
	LDA $D2				; |
	STA $9B				;/
	LDA $D3				;\
	CLC				; |
	ADC #$08			; |
	STA $98				; | Stores Mario's Y position into the block's Y position and offsets it.
	LDA $D4				; |
	ADC #$00			; |
	STA $99				;/
	LDA $19				;\
	BNE KEEPOFFSET			;/ Branches if Mario is not small.
	LDA $98				;\
	ADC #$04			; | Lowers the block's Y position by 4.
	STA $98				;/
KEEPOFFSET:
	PHB				;\
	LDA #$82			; | Sets the Data Bank to $82.
	PHA				; |
	PLB				;/
	LDA #$FF			;\
	JSL $828663			;/ Jumps to the flashing exploding block routine.
	PLB				; Restores the Data Bank.
	JSL $80F5B7			; Hurts Mario.
	STZ $5C				; Resets the shatter block flag.
NOSHATTER:
	RTS				; Ends the code.
ICEBLOCKGRAPHICS:
	LDX #$01			; Loads the number of times to loop the graphics routine.
ICEBLOCKLOOP:
	LDA $D1				;\
	STA $00				; | Stores Mario's X position into the sprite's X position.
	LDA $D2				; |
	STA $01				;/
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $00				;\
	SEC				; | Offsets the X position of the sprite by the Layer 1 X position.
	SBC $1A				; |
	STA $00				;/
	CMP #$FFF1			;\
	BCS ICEBLOCKYPOSITION		; | Branches if the sprite is onscreen.
	CMP #$0100			; |
	BCC ICEBLOCKYPOSITION		;/
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	BRA NODRAWICEBLOCK		; Branches to the end of the graphics routine.
ICEBLOCKYPOSITION:
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	LDA $19				;\
	BEQ SMALLYPOSITION		;/ Branches if Mario is small.
	LDA $D3				;\
	AND #$FF			; |
	CLC				; | Stores the low byte of Mario's Y position into the low byte of the sprite's Y position and offsets it.
	ADC ICEBLOCKYDISP,x		; |
	STA $02				;/
	BRA STOREICEBLOCKYPOSITIONHIGH	; Branches to the store Y position high byte routine.
SMALLYPOSITION:
	LDA $D3				;\
	AND #$FF			; |
	CLC				; | Stores the low byte of Mario's Y position into the low byte of the sprite's Y position and offsets it.
	ADC SMALLICEBLOCKYDISP,x	; |
	STA $02				;/
STOREICEBLOCKYPOSITIONHIGH:
	LDA $D4				;\
	ADC #$00			; | Stores the high byte of Mario's Y position into the high byte of the sprite's Y position.
	STA $03				;/
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $02				;\
	SEC				; | Offsets the Y position of the sprite by the Layer 1 Y position.
	SBC $1C				; |
	STA $02				;/
	CMP #$FFF0			;\
	BCS DRAWICEBLOCK		; | Branches if the sprite is onscreen.
	CMP #$00F0			; |
	BCC DRAWICEBLOCK		;/
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	BRA NODRAWICEBLOCK		; Branches to the end of the graphics routine.
DRAWICEBLOCK:
	JMP DRAWICEBLOCKSPRITE		; Jumps to the draw sprite routine.
NODRAWICEBLOCK:
	DEX				; Decreases the number of times to loop the graphics routine.
	BPL ICEBLOCKLOOP		; Loops until the X Register is a negative value.
	RTS				; Ends the code.

ICEBLOCKOAM: db $B0,$B4
ICEBLOCKYDISP: db $00,$10
SMALLICEBLOCKYDISP: db $08,$10
ICEBLOCKTILEMAP: db $30,$24
SMALLICEBLOCKTILEMAP: db $26,$36
ICEBLOCKPROP: db $0D,$0D

DRAWICEBLOCKSPRITE:
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	LDY ICEBLOCKOAM,X		; Loads the OAM slots for each tile.
	LDA $00				;\
	STA $0200,y			;/ Draws the X position of the sprite.
	LDA $02				;\
	STA $0201,y			;/ Draws the Y position of the sprite.
	LDA $19				;\
	BEQ SMALLTILEMAP		;/ Branches if Mario is small.
	LDA ICEBLOCKTILEMAP,x		;\
	STA $0202,y			;/ Loads the tilemap table and draws the tiles in the table.
	BRA STOREPROP			; Branches to the store properties routine.
SMALLTILEMAP:
	LDA SMALLICEBLOCKTILEMAP,x	;\
	STA $0202,y			;/ Loads the tilemap table and draws the tiles in the table.
STOREPROP:
	LDA ICEBLOCKPROP,x		; Loads the property byte table indexed by the X Register.
	ORA $64				;\
	STA $0203,y			;/ Stores the property byte.
	TYA				; Transfers the Y Register to the Accumulator.
	LSR				;\
	LSR				;/ Shifts the bits to the right twice.
	TAY				; Transfers the Accumulator to the Y Register.
	LDA $01				;\
	BNE ICEBLOCKOFF			;/ Branches if the high byte of the X position is not zero.
	LDA #$02			;\
	STA $0420,y			;/ Loads and stores the sprite tile size.
	JMP NODRAWICEBLOCK		; Jumps to the end of the graphics routine.
ICEBLOCKOFF:
	LDA #$03			;\
	STA $0420,y			;/ Loads and stores the sprite tile size and X position high bit.
	JMP NODRAWICEBLOCK		; Jumps to the end of the graphics routine.
CLUSTERLOOP:
	LDX #$24			; Loads the starting OAM Index.
SPRITELOOP:
	LDA $0301,x			;\
	CMP #$F0			; | Branches if the sprite tile is offscreen.
	BEQ SPRITEISOFFSCREEN		;/
	INX				;\
	INX				; |
	INX				; | Increments the X Register 4 times.
	INX				;/
	CPX #$FC			;\
	BCC SPRITELOOP			;/ Branches if the end of the OAM is not reached.
SPRITEISOFFSCREEN:
	STX $60				; Stores the OAM Index for the extra cluster sprite tiles.
	LDX #$00			; Loads 0 into the X Register.
OAMLOOP:
	LDY CLUSTEROAM,x		; Loads the OAM into the Y register.
	LDA $0201,y			;\
	CMP #$F0			; | Branches if the sprite tile is offscreen.
	BEQ EXTENDEDSPRITEISOFFSCREEN	;/
	INX				; Increments the X register.
	CPX #$14			;\
	BCC OAMLOOP			;/ Branches if there are less than 20 sprite tiles onscreen.
EXTENDEDSPRITEISOFFSCREEN:
	STX $63				; Stores the number of used sprite tiles.
	LDA $13D4			;\		
	STA $08				;/ Stores the pause flag into scratch RAM.
	PHB				; Preserves the current Data Bank.
	LDA #$7F			;\
	PHA				; | Changes the Data Bank to 7F.
	PLB				;/
	LDX #$2F			; Loads the number of slots to draw the warning sign.
WARNINGLOOP:
	LDA $B920,x			;\
	BEQ WARNINGSLOTSEMPTY		;/ Branches if the warning sign is inactive.
	JSR WARNINGSIGN			; Jumps to the warning sign routine.
WARNINGSLOTSEMPTY:
	DEX				; Decrements the X Register.
	BPL WARNINGLOOP			; Loops until the X Register is negative.
	PLB				; Restores the old Data Bank.
	RTS				; Ends the code.
WARNINGSIGN:
	LDA $08				;\
	BNE SETUPWARNINGANIMATION	;/ Branches if the game is paused.
	STZ $07				; Sets the warning timer scratch RAM to zero.
	LDA $B950,x			;\
	STA $00				; |
	LDA $B980,x			; | Stores the X position of the warning sign.
	STA $01				;/
	LDA $B9B0,x			;\
	STA $02				; |
	LDA $B9E0,x			; | Stores the Y position of the warning sign.
	STA $03				;/
	LDA #$E0			;\
	STA $04				;/ Stores the first tile to use.
	LDA $B920,x			;\
	CMP #$05			; | Branches if the first warning timer is below frame 5.
	BCC CHANGEWARNINGFRAME		;/
	LDA $BA10,x			;\
	CMP #$04			; | Branches if the second warning timer is above frame 4.
	BCS DONOTCHANGEWARNINGFRAME	;/
CHANGEWARNINGFRAME:
	LDA #$C8			;\
	STA $04				;/ Stores the second tile to use.
DONOTCHANGEWARNINGFRAME:
	LDA #$39			;\
	ORA $64				; | Stores the properties to use.
	STA $05				;/
	LDA #$02			;\
	STA $06				;/ Stores the tile size to use.
	PHB				;\  
	PHK				; | Changes the Data Bank to the one the warning sign runs from.
	PLB				;/
	JSR CLUSTERDRAWING		; Jumps to the cluster drawing routine.
	PLB				; Restores the old Data Bank.
	LDA $07				;\
	BNE SETUPWARNINGANIMATION	;/ Branches if the warning timer scratch RAM is not 0.
	LDA #$00			;\
	STA $B920,x			;/ Sets the first warning timer to 0.
	RTS				; Ends the code.
SETUPWARNINGANIMATION:
	LDA $9D				;\
	ORA $08				; | Branches if the game is locked or paused.
	BNE ENDWARNINGDRAWING		;/
	LDA $BA10,x			;\
	INC				; | Increments the second warning timer.
	STA $BA10,x			;/
	LDA $B920,x			;\
	DEC				; | Decrements the first warning timer.
	STA $B920,x			;/
ENDWARNINGDRAWING:
	RTS				; Ends the code.

CLUSTEROAM: db $70,$74,$78,$7C,$80,$84,$88,$8C,$90,$94,$98,$9C,$A0,$A4,$A8,$AC,$B0,$B4,$B8,$BC

CLUSTERDRAWING:
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $00				;\
	PHA				; |
	SEC				; | Preserves the Accumulator and offsets the X position of the sprite by the Layer 1 X position.
	SBC $1A				; |
	STA $00				;/
	CMP #$FFF1			;\
	BCS CLUSTERYPOSITION		;/ Branches if the sprite is onscreen.
	CMP #$0100			;\
	BCS NODRAWCLUSTER		;/ Branches if the sprite is offscreen.
CLUSTERYPOSITION:
	LDA $02				;\
	PHA				; |
	SEC				; | Preserves the Accumulator and offsets the Y position of the sprite by the Layer 1 Y position.
	SBC $1C				; |
	STA $02				;/
	CMP #$FFF1			;\
	BCS SETCLUSTEROAM		; | Branches if the sprite is onscreen.
	CMP #$00F0			; |
	BCC SETCLUSTEROAM		;/
	PLA				; Pulls back the Accumulator.
	STA $02				; Stores the Accumulator into the Y position scratch RAM.
NODRAWCLUSTER:
	PLA				; Pulls back the Accumulator.
	STA $00				; Stores the Accumulator into the X position scratch RAM.
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	RTS				; Ends the code.
SETCLUSTEROAM:
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	PHX				; Preserves the X Register.
	LDA $63				;\
	CMP #$14			; | Branches if there are more than 20 tiles being drawn.
	BEQ MORETHANTWENTY		;/
	INC $63				; Increments the number used sprite tiles.
	TAX				; Transfers the Accumulator to the X Register.
	LDA CLUSTEROAM,x		; Loads the cluster OAM to use.
	REP #$30			; Turns on 16-bit addressing mode for the Accumulator and the X and Y Registers.
	AND #$00FF			; Sets the last 8 bits.
	TAY				; Transfers the Accumulator to the Y Register.
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator
	BRA CONTINUECLUSTERDRAWING	; Branches to the continue cluster drawing routine.
MORETHANTWENTY:
	LDA #$01			;\
	XBA				;/ Loads the high byte and switches it with the low byte.
	LDA $60				; Loads the OAM Index for the extra cluster sprite tiles.
	TAX				; Transfers the Accumulator to the X Register. 
	CLC				;\
	ADC #$04			; | Increases the OAM Index by 4.
	STA $60				;/
	TXA				; Transfers the X Register to the Accumulator. 
	REP #$30			; Turns on 16-bit addressing mode for the Accumulator and the X and Y Registers.
	TAY				; Transfers the Accumulator to the Y Register.
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
CONTINUECLUSTERDRAWING:
	LDA $00				;\
	STA $0200,y			;/ Draws the X position of the sprite.
	LDA $02				;\
	STA $0201,y			;/ Draws the Y position of the sprite.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $04				;\
	STA $0202,y			;/ Loads the tiles to draw.
	TYA				; Transfers the Y Register to the Accumulator. 
	LSR				;\
	LSR				;/ Shifts the bits to the right twice.
	TAY				; Transfers the Accumulator to the Y Register.
	SEP #$30			; Turns back on 8-bit addressing mode for the Accumulator and the X and Y Registers.
	LDA $01				;\
	BNE CLUSTEROFF			;/ Branches if the high byte of the X position is not zero.
	LDA $06				;\
	STA $0420,y			;/ Sets the tile size.
	PLX				; Pulls back the X Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	PLA				; Pulls back the Accumulator.
	STA $02				; Stores the Accumulator into the Y position scratch RAM.
	PLA				; Pulls back the Accumulator.
	STA $00				; Stores the Accumulator into the X position scratch RAM.
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	INC $07				; Increments the timer scratch RAM.
	RTS				; Ends the code.
CLUSTEROFF:
	LDA $06				;\
	INC				; | Increments the tile size scratch RAM and stores it.
	STA $0420,y			;/
	PLX				; Pulls back the X Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	PLA				; Pulls back the Accumulator.
	STA $02				; Stores the Accumulator into the Y position scratch RAM.
	PLA				; Pulls back the Accumulator.
	STA $00				; Stores the Accumulator into the X position scratch RAM.
	SEP #$20			; Turns back on 8-bit addressing mode for the Accumulator.
	INC $07				; Increments the timer scratch RAM.
	RTS				; Ends the code.
LIGHTNINGLOOP:
	LDA #$00			; Loads the new lightning strike value.
	PHA				; Preserves the Accumulator.
	LDX #$00			; Loads 0 into the X Register.
LIGHTNINGCHECKLOOP:
	LDA $7FBA70,x			;\
	BEQ NOLIGHTNING			;/ Branches if the lightning timer is 0.
	PLA				; Pulls back the Accumulator.
	CMP #$00			;\
	BNE MORELIGHTNING		;/ Branches if more than 1 lightning strike is present.
	LDA #$01			; Sets the new lightning strike value.
MORELIGHTNING:
	PHA				; Preserves the Accumulator.
	JSR LIGHTNING			; Jumps to the lightning strike routine.
NOLIGHTNING:
	INX				; Increases the X Register.
	CPX #$08			;\
	BCC LIGHTNINGCHECKLOOP		;/ Branches if the X Register is less than 8.
	PLA				; Pulls back the Accumulator
	RTS				; Ends the code.
LIGHTNING:
	LDA $13D4			;\
	BNE LIGHTNINGCODE		;/ Branches if the game is paused.
	LDA $7FBA78,x			;\
	STA $08				; |
	LDA $7FBA80,x			; |
	STA $09				; | Stores the X and Y positions of the lightning strike into scratch RAM.
	LDA $7FBA88,x			; |
	STA $0A				; |
	LDA $7FBA90,x			; |
	STA $0B				;/
	STZ $07				; Clears the timer scratch RAM.
	LDA $7FBA70,x			;\
	BEQ LIGHTNINGRETURN		;/ Branches if the lightning timer is 0.
	CMP #$03			;\
	BCS SHOWFRAME3			;/ Branches if the lightning timer is 3 or more.
	JSR FRAME4			; Jumps to the frame 4 routine.
	BRA LIGHTNINGCODE		; Branches to the lightning code routine.
SHOWFRAME3:
	CMP #$05			;\
	BCS SHOWFRAME2			;/ Branches if the lightning timer is 5 or more.
SHOWFRAME3A:
	JSR FRAME3			; Jumps to the frame 3 routine.
	BRA LIGHTNINGCODE		; Branches to the lightning code routine.
SHOWFRAME2:
	CMP #$07			;\
	BCS SHOWFRAME1			;/ Branches if the lightning timer is 7 or more.
	JSR FRAME2			; Jumps to the frame 2 routine.
	BRA LIGHTNINGCODE		; Branches to the lightning code routine.
SHOWFRAME1:
	CMP #$09			;\
	BEQ SHOWFRAME3A			;/ Branches if the lightning timer is 9.
	JSR FRAME1			; Jumps to the frame 1 routine.
	BRA LIGHTNINGCODE		; Branches to the lightning code routine.
LIGHTNINGRETURN:
	RTS				; Ends the code.
LIGHTNINGCODE:
	LDA $9D				;\
	ORA $13D4			; | Branches if the game is not locked or paused.
	BEQ RUNLIGHTNING		;/
	RTS				; Ends the code.
RUNLIGHTNING:
	LDA $7FBA70,x			;\
	BEQ LIGHTNINGRETURN		;/ Branches if the lightning timer is 0.
	DEC				;\
	STA $7FBA70,x			;/ Decreases the lightning timer.
	CPY #$00			;\
	BEQ NOLIGHTNINGCONTACT		;/ Branches if the Y Register is 0.
	LDA $7FBA78,x			;\
	CLC				; |
	ADC #$04			; |
	STA $04				; | Sets the X position of the clipping.
	LDA $7FBA80,x			; |
	ADC #$00			; |
	STA $0A				;/
	LDA $7FBA88,x			;\
	SEC				; |
	SBC #$18			; |
	STA $05				; | Sets the Y position of the clipping.
	LDA $7FBA90,x			; |
	SBC #$00			; |
	STA $0B				;/
	LDA #$08			;\
	STA $06				;/ Sets the width of the clipping.
	LDA #$FF			;\
	STA $07				;/ Sets the height of the clipping.
	JSL $83B664			; Jumps to the get player clipping routine.
	JSR CHECKCOLLISION		; Jumps to the check collision routine.
	BCC NOLIGHTNINGCONTACT		; Branches if Mario and the lightning strike are not interacting.
	JSL $80F5B7			; Hurts Mario.
NOLIGHTNINGCONTACT:
	RTS				; Ends the code.
FRAME1:
	LDY #$1D			; Loads the number of tiles to draw for the lightning strike.
FRAME1LOOP:
	LDA FRAME1TILES,y		;\
	STA $04				;/ Loads the tiles to draw.
	LDA #$0D			;\
	ORA $64				; | Loads the properties of the sprite.
	STA $05				;/
	LDA #$02			;\
	STA $06				;/ Loads the size for each tile.
	PHY				; Preserves the Y Register.
	TYA				; Transfers the Y Register to the Accumulator.
	ASL				; Shifts the bits to the left.
	TAY				; Transfers the Accumulator to the Y Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $08				;\
	CLC				; | Sets the X displacement for each tile.
	ADC FRAME1XDISP,y		; |
	STA $00				;/
	LDA $0A				;\
	CLC				; | Sets the Y displacement for each tile.
	ADC FRAME1YDISP,y		; |
	STA $02				;/
	SEP #$20			; Turns on 8-bit addressing mode for the Accumulator.
	JSR CLUSTERDRAWING		; Jumps to the cluster drawing routine.
	PLY				; Pulls back the Y Register.
	DEY				; Decreases the Y Register.
	BPL FRAME1LOOP			; Loops the graphics routine until it is -1.
	LDY #$02			; Sets the Y Register to 2.
	RTS				; Ends the code.

FRAME1XDISP:
dw $FFFF,$0007,$FFFF,$0007,$0000,$0008,$FFF8,$0000
dw $FFF8,$0008,$0000,$0008,$0000,$0008,$0000,$0008
dw $FFF8,$0000,$FFF8,$0008,$0000,$0008,$0000,$0008
dw $0000,$0008,$FFF8,$0000,$FFF8,$0000

FRAME1YDISP:
dw $FFE8,$FFE8,$FFF0,$FFF0,$0000,$0000,$0010,$0010
dw $0020,$0020,$0030,$0030,$0040,$0040,$0050,$0050
dw $0060,$0060,$0070,$0070,$0080,$0080,$0090,$0090
dw $00A0,$00A0,$00B0,$00B0,$00B0,$00B0

FRAME1TILES:
db $2A,$2B,$3A,$3B,$A6,$A7,$A9,$AA
db $CA,$CC,$64,$65,$3D,$3E,$A6,$A7
db $A9,$AA,$CA,$CC,$64,$65,$3D,$3E
db $A6,$A7,$A9,$AA,$57,$58

FRAME2:
	LDY #$0D			; Loads the number of tiles to draw for the lightning strike.
FRAME2LOOP:
	LDA FRAME2TILES,y		;\
	STA $04				;/ Loads the tiles to draw.
	LDA #$0D			;\
	ORA $64				; | Loads the properties of the sprite.
	STA $05				;/
	LDA #$02			;\
	STA $06				;/ Loads the size for each tile.
	PHY				; Preserves the Y Register.
	TYA				; Transfers the Y Register to the Accumulator.
	ASL				; Shifts the bits to the left.
	TAY				; Transfers the Accumulator to the Y Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $08				;\
	STA $00				;/ Sets the X position for each tile.
	LDA $0A				;\
	CLC				; | Sets the Y displacement for each tile.
	ADC FRAME2YDISP,y		; |
	STA $02				;/
	SEP #$20			; Turns on 8-bit addressing mode for the Accumulator.
	JSR CLUSTERDRAWING		; Jumps to the cluster drawing routine.
	PLY				; Pulls back the Y Register.
	DEY				; Decreases the Y Register.
	BPL FRAME2LOOP			; Loops the graphics routine until it is -1.
	LDY #$01			; Sets the Y Register to 1.
	RTS				; Ends the code.

FRAME2YDISP:
dw $FFF0,$0000,$0010,$0020,$0030,$0040,$0050,$0060
dw $0070,$0080,$0090,$00A0,$00B0,$00B0

FRAME2TILES:
db $28,$8A,$A0,$A2,$A4,$C4,$8A,$A0
db $A2,$A4,$C4,$8A,$A0,$44

FRAME3:
	LDY #$0D			; Loads the number of tiles to draw for the lightning strike.
FRAME3LOOP:
	LDA FRAME3TILES,y		;\
	STA $04				;/ Loads the tiles to draw.
	LDA #$0D			;\
	ORA $64				; | Loads the properties of the sprite.
	STA $05				;/
	LDA #$02			;\
	STA $06				;/ Loads the size for each tile.
	PHY				; Preserves the Y Register.
	TYA				; Transfers the Y Register to the Accumulator.
	ASL				; Shifts the bits to the left.
	TAY				; Transfers the Accumulator to the Y Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $08				;\
	SEC				; | Sets the X displacement for each tile.
	SBC #$0004			; |
	STA $00				;/
	LDA $0A				;\
	CLC				; | Sets the Y displacement for each tile.
	ADC FRAME3YDISP,y		; |
	STA $02				;/
	SEP #$20			; Turns on 8-bit addressing mode for the Accumulator.
	JSR CLUSTERDRAWING		; Jumps to the cluster drawing routine.
	PLY				; Pulls back the Y Register.
	DEY				; Decreases the Y Register.
	BPL FRAME3LOOP			; Loops the graphics routine until it is -1.
	LDY #$00			; Sets the Y Register to 0.
	RTS				; Ends the code.

FRAME3TILES:
db $62,$E8,$E8,$E8,$E8,$E8,$E8,$E8
db $E8,$E8,$E8,$E8,$E8,$42

FRAME3YDISP:
dw $FFF0,$0000,$0010,$0020,$0030,$0040,$0050,$0060
dw $0070,$0080,$0090,$00A0,$00B0,$00B0

FRAME4:
	LDY #$0D			; Loads the number of tiles to draw for the lightning strike.
FRAME4LOOP:
	LDA FRAME4TILES,y		;\
	STA $04				;/ Loads the tiles to draw.
	LDA #$0D			;\
	ORA $64				; | Loads the properties of the sprite.
	STA $05				;/
	LDA #$02			;\
	STA $06				;/ Loads the size for each tile.
	PHY				; Preserves the Y Register.
	TYA				; Transfers the Y Register to the Accumulator.
	ASL				; Shifts the bits to the left.
	TAY				; Transfers the Accumulator to the Y Register.
	REP #$20			; Turns on 16-bit addressing mode for the Accumulator.
	LDA $08				;\
	CLC				; | Sets the X displacement for each tile.
	ADC #$0004			; |
	STA $00				;/
	LDA $0A				;\
	CLC				; | Sets the Y displacement for each tile.
	ADC FRAME3YDISP,y		; |
	STA $02				;/
	SEP #$20			; Turns on 8-bit addressing mode for the Accumulator.
	JSR CLUSTERDRAWING		; Jumps to the cluster drawing routine.
	PLY				; Pulls back the Y Register.
	DEY				; Decreases the Y Register.
	BPL FRAME4LOOP			; Loops the graphics routine until it is -1.
	LDY #$00			; Sets the Y Register to 0.
	RTS				; Ends the code.

FRAME4TILES:
db $60,$D6,$E6,$D6,$E6,$D6,$E6,$D6
db $E6,$D6,$E6,$D6,$E6,$22

incsrc checkcollision.asm

level32:
	JSR RESET			; Calls the translevel number reset routine.
	STZ $1B96			; Disables the ability to side exit a level.
	RTS				; Ends the code.
level33:
	JSR RESET			; Calls the translevel number reset routine.
RESETBUZZYBEETLEPALETTE:
	LDX #$0B			; Loads a loop count of 11.
BUZZYBEETLELOOP:
	LDA $9E,x			;\
	CMP #$11			; | Branches if a Buzzy Beetle is not present.
	BNE NOBUZZYBEETLE		;/
	LDA $15F6,x			;\
	AND #$F1			; |
	ORA #$0D			; | Makes the sprite use palette E.
	STA $15F6,x			;/
NOBUZZYBEETLE:
	DEX				; Decreases the X Register.
	BPL BUZZYBEETLELOOP		; Loops the Buzzy Beetle loop until it is -1.
	RTS				; Ends the code.
level34:
	JSR RESET			; Calls the translevel number reset routine.
	LDX #$0B			; Loads a loop count of 11.
BUZZYBEETLELOOP2:
	LDA $9E,x			;\
	CMP #$11			; | Branches if a Buzzy Beetle is not present.
	BNE NOBUZZYBEETLE2		;/
	LDA $15F6,x			;\
	AND #$F1			; |
	ORA #$03			; | Makes the sprite use palette 9.
	STA $15F6,x			;/
NOBUZZYBEETLE2:
	DEX				; Decreases the X Register.
	BPL BUZZYBEETLELOOP2		; Loops the Buzzy Beetle loop until it is -1.
	RTS				; Ends the code.
level35:
	JSR RESET			; Calls the translevel number reset routine.
	JSR RESETBUZZYBEETLEPALETTE	; Jumps to the reset Buzzy Beetle palette routine.
	RTS				; Ends the code.
level36:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level37:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level38:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level39:
	JSR RESET			; Calls the translevel number reset routine.
	STZ $1B96			; Disables the ability to side exit a level.
	RTS				; Ends the code.
level3A:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level3B:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level3C:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level3D:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level3E:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level3F:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level40:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level41:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level42:
	JSR RESET			; Calls the translevel number reset routine.
	STZ $1B9B			; Makes Yoshi appear when exiting the level.
	STZ $0DC1			; Silently dismounts Mario off Yoshi.
	RTS				; Ends the code.
level43:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level44:
	JSR RESET			; Calls the translevel number reset routine.
	LDA #$01			;\
	STA $1B9B			;/ Makes Yoshi disappear when exiting the level.
	RTS				; Ends the code.
level45:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level46:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level47:
	JSR RESET			; Calls the translevel number reset routine.
	RTS				; Ends the code.
level48:
	JSR RESET			; Calls the translevel number reset routine.
	STZ $1B96			; Disables the ability to side exit a level.
	RTS
level49:
DISABLECONTROLS:
	STZ $15				;\
	STZ $16				; |
	STZ $17				; | Disables Mario's conrtols.
	STZ $18				;/
	LDA #$01			;\
	STA $13D3			;/ Disables pausing.
	RTS				; Ends the code.
level4A:
	JSR DISABLECONTROLS		; Calls the disable controls routine.
	LDA $5C				;\
	BEQ CONTINUE			;/ Branches if the message timer is not 0.
	DEC $5C				; Decreases the message timer.
	RTS				; Ends the code.
CONTINUE:
	LDA $60				;\
	BEQ MESSAGE1			;/ Branches if the message number is 1.
	CMP #$01			;\
	BEQ MESSAGE2			;/ Branches if the message number is 2.
	CMP #$02			;\
	BEQ MESSAGE3			;/ Branches if the message number is 3.
	LDA #$06			;\
	STA $71				; |
	STZ $88				; | Teleports the player.
	STZ $89				;/
DONOTSHOW:
	RTS				; Ends the code.			
MESSAGE1:
	LDA #$2E			;\
	STA $13BF			;/ Changes the translevel number.
	LDA #$02			;\
	STA $1426			;/ Displays level message 2.
	INC $60				; Increases the message number.
	INC $5C				; Increases the message timer.
	RTS				; Ends the code.
MESSAGE2:
	INC $13BF			; Changes the translevel number.
	LDA #$01			;\
	STA $1426			;/ Displays level message 1.
	INC $60				; Increases the message state.
	INC $5C				; Increases the message number.
	RTS				; Ends the code.
MESSAGE3:
	LDA #$02			;\
	STA $1426			;/ Displays level message 2.
	INC $60				; Increases the message state.
	INC $5C				; Increases the message number.
	RTS				; Ends the code.
level4B:
	JSR DISABLECONTROLS		; Calls the disable controls routine.
	LDA $5C				;\
	BNE NOMESSAGE			;/ Branches if the message timer is not 0.
	LDA $0DB3			;\
	BEQ MARIO			;/ Branches if the current character is Mario.
	LDA #$41			;\
	STA $13BF			;/ Changes the translevel number.
	BRA DISPLAYMESSAGE		; Branches to the display message routine.
MARIO:
	LDA #$31			;\
	STA $13BF			;/ Changes the translevel number.
DISPLAYMESSAGE:
	LDA #$01			;\
	STA $1426			;/ Displays level message 1.
	INC $5C				; Increases the message timer.
	INC $60				; Sets the level state to clear level.
	RTS				; Ends the code.
NOMESSAGE:
	LDA $60				;\
	CMP #$01			; | Branches if the level state is not clear level.
	BNE RESUMELEVEL			;/	
	LDA #$FF			;\
	STA $1493			;/ Makes Mario freeze at the level end.
	INC $13C6			; Enables a boss sequence cutscene.
	LDA #$03			;\
	STA $1DFB			;/ Sets the music to play.
	INC $60				; Sets the level state to resume level.
	RTS				; Ends the code.
RESUMELEVEL:
	CMP #$02			;\
	BCS FINISHLEVEL			;/ Branches if the level state is finish level.
	DEC $5C				; Decreases the message timer.
FINISHLEVEL:
	JSR RESET			; Calls the translevel number reset routine.
	STZ $1B96			; Disables the ability to side exit a level.
	RTS				; Ends the code.
level4C:
	RTS
level4D:
	RTS
level4E:
	RTS
level4F:
	RTS
level50:
	RTS
level51:
	RTS
level52:
	RTS
level53:
	RTS
level54:
	RTS
level55:
	RTS
level56:
	RTS
level57:
	RTS
level58:
	RTS
level59:
	RTS
level5A:
	RTS
level5B:
	RTS
level5C:
	RTS
level5D:
	RTS
level5E:
	RTS
level5F:
	RTS
level60:
	RTS
level61:
	RTS
level62:
	RTS
level63:
	RTS
level64:
	RTS
level65:
	RTS
level66:
	RTS
level67:
	RTS
level68:
	RTS
level69:
	RTS
level6A:
	RTS
level6B:
	RTS
level6C:
	RTS
level6D:
	RTS
level6E:
	RTS
level6F:
	RTS
level70:
	RTS
level71:
	RTS
level72:
	RTS
level73:
	RTS
level74:
	RTS
level75:
	RTS
level76:
	RTS
level77:
	RTS
level78:
	RTS
level79:
	RTS
level7A:
	RTS
level7B:
	RTS
level7C:
	RTS
level7D:
	RTS
level7E:
	RTS
level7F:
	RTS
level80:
	RTS
level81:
	RTS
level82:
	RTS
level83:
	RTS
level84:
	RTS
level85:
	RTS
level86:
	RTS
level87:
	RTS
level88:
	RTS
level89:
	RTS
level8A:
	RTS
level8B:
	RTS
level8C:
	RTS
level8D:
	RTS
level8E:
	RTS
level8F:
	RTS
level90:
	RTS
level91:
	RTS
level92:
	RTS
level93:
	RTS
level94:
	RTS
level95:
	RTS
level96:
	RTS
level97:
	RTS
level98:
	RTS
level99:
	RTS
level9A:
	RTS
level9B:
	RTS
level9C:
	RTS
level9D:
	RTS
level9E:
	RTS
level9F:
	RTS
levelA0:
	RTS
levelA1:
	RTS
levelA2:
	RTS
levelA3:
	RTS
levelA4:
	RTS
levelA5:
	RTS
levelA6:
	RTS
levelA7:
	RTS
levelA8:
	RTS
levelA9:
	RTS
levelAA:
	RTS
levelAB:
	RTS
levelAC:
	RTS
levelAD:
	RTS
levelAE:
	RTS
levelAF:
	RTS
levelB0:
	RTS
levelB1:
	RTS
levelB2:
	RTS
levelB3:
	RTS
levelB4:
	RTS
levelB5:
	RTS
levelB6:
	RTS
levelB7:
	RTS
levelB8:
	RTS
levelB9:
	RTS
levelBA:
	RTS
levelBB:
	RTS
levelBC:
	RTS
levelBD:
	RTS
levelBE:
	RTS
levelBF:
	RTS
levelC0:
	RTS
levelC1:
	RTS
levelC2:
	RTS
levelC3:
	RTS
levelC4:
	RTS
levelC5:
	RTS
levelC6:
	RTS
levelC7:
	RTS
levelC8:
	RTS
levelC9:
	RTS
levelCA:
	RTS
levelCB:
	RTS
levelCC:
	RTS
levelCD:
	RTS
levelCE:
	RTS
levelCF:
	RTS
levelD0:
	RTS
levelD1:
	RTS
levelD2:
	RTS
levelD3:
	RTS
levelD4:
	RTS
levelD5:
	RTS
levelD6:
	RTS
levelD7:
	RTS
levelD8:
	RTS
levelD9:
	RTS
levelDA:
	RTS
levelDB:
	RTS
levelDC:
	RTS
levelDD:
	RTS
levelDE:
	RTS
levelDF:
	RTS
levelE0:
	RTS
levelE1:
	RTS
levelE2:
	RTS
levelE3:
	RTS
levelE4:
	RTS
levelE5:
	RTS
levelE6:
	RTS
levelE7:
	RTS
levelE8:
	RTS
levelE9:
	RTS
levelEA:
	RTS
levelEB:
	RTS
levelEC:
	RTS
levelED:
	RTS
levelEE:
	RTS
levelEF:
	RTS
levelF0:
	RTS
levelF1:
	RTS
levelF2:
	RTS
levelF3:
	RTS
levelF4:
	RTS
levelF5:
	RTS
levelF6:
	RTS
levelF7:
	RTS
levelF8:
	RTS
levelF9:
	RTS
levelFA:
	RTS
levelFB:
	RTS
levelFC:
	RTS
levelFD:
	RTS
levelFE:
	RTS
levelFF:
	RTS
level100:
	RTS
level101:
	RTS
level102:
	RTS
level103:
	RTS
level104:
	RTS
level105:
	RTS
level106:
	RTS
level107:
	RTS
level108:
	RTS
level109:
	RTS
level10A:
	RTS
level10B:
	RTS
level10C:
	RTS
level10D:
	RTS
level10E:
	RTS
level10F:
	RTS
level110:
	RTS
level111:
	RTS
level112:
	RTS
level113:
	RTS
level114:
	RTS
level115:
	RTS
level116:
	RTS
level117:
	RTS
level118:
	RTS
level119:
	RTS
level11A:
	RTS
level11B:
	RTS
level11C:
	RTS
level11D:
	RTS
level11E:
	RTS
level11F:
	RTS
level120:
	RTS
level121:
	RTS
level122:
	RTS
level123:
	RTS
level124:
	RTS
level125:
	RTS
level126:
	RTS
level127:
	RTS
level128:
	RTS
level129:
	RTS
level12A:
	RTS
level12B:
	RTS
level12C:
	RTS
level12D:
	RTS
level12E:
	RTS
level12F:
	RTS
level130:
	RTS
level131:
	RTS
level132:
	RTS
level133:
	RTS
level134:
	RTS
level135:
	RTS
level136:
	RTS
level137:
	RTS
level138:
	RTS
level139:
	RTS
level13A:
	RTS
level13B:
	RTS
level13C:
	RTS
level13D:
	RTS
level13E:
	RTS
level13F:
	RTS
level140:
	RTS
level141:
	RTS
level142:
	RTS
level143:
	RTS
level144:
	RTS
level145:
	RTS
level146:
	RTS
level147:
	RTS
level148:
	RTS
level149:
	RTS
level14A:
	RTS
level14B:
	RTS
level14C:
	RTS
level14D:
	RTS
level14E:
	RTS
level14F:
	RTS
level150:
	RTS
level151:
	RTS
level152:
	RTS
level153:
	RTS
level154:
	RTS
level155:
	RTS
level156:
	RTS
level157:
	RTS
level158:
	RTS
level159:
	RTS
level15A:
	RTS
level15B:
	RTS
level15C:
	RTS
level15D:
	RTS
level15E:
	RTS
level15F:
	RTS
level160:
	RTS
level161:
	RTS
level162:
	RTS
level163:
	RTS
level164:
	RTS
level165:
	RTS
level166:
	RTS
level167:
	RTS
level168:
	RTS
level169:
	RTS
level16A:
	RTS
level16B:
	RTS
level16C:
	RTS
level16D:
	RTS
level16E:
	RTS
level16F:
	RTS
level170:
	RTS
level171:
	RTS
level172:
	RTS
level173:
	RTS
level174:
	RTS
level175:
	RTS
level176:
	RTS
level177:
	RTS
level178:
	RTS
level179:
	RTS
level17A:
	RTS
level17B:
	RTS
level17C:
	RTS
level17D:
	RTS
level17E:
	RTS
level17F:
	RTS
level180:
	RTS
level181:
	RTS
level182:
	RTS
level183:
	RTS
level184:
	RTS
level185:
	RTS
level186:
	RTS
level187:
	RTS
level188:
	RTS
level189:
	RTS
level18A:
	RTS
level18B:
	RTS
level18C:
	RTS
level18D:
	RTS
level18E:
	RTS
level18F:
	RTS
level190:
	RTS
level191:
	RTS
level192:
	RTS
level193:
	RTS
level194:
	RTS
level195:
	RTS
level196:
	RTS
level197:
	RTS
level198:
	RTS
level199:
	RTS
level19A:
	RTS
level19B:
	RTS
level19C:
	RTS
level19D:
	RTS
level19E:
	RTS
level19F:
	RTS
level1A0:
	RTS
level1A1:
	RTS
level1A2:
	RTS
level1A3:
	RTS
level1A4:
	RTS
level1A5:
	RTS
level1A6:
	RTS
level1A7:
	RTS
level1A8:
	RTS
level1A9:
	RTS
level1AA:
	RTS
level1AB:
	RTS
level1AC:
	RTS
level1AD:
	RTS
level1AE:
	RTS
level1AF:
	RTS
level1B0:
	RTS
level1B1:
	RTS
level1B2:
	RTS
level1B3:
	RTS
level1B4:
	RTS
level1B5:
	RTS
level1B6:
	RTS
level1B7:
	RTS
level1B8:
	RTS
level1B9:
	RTS
level1BA:
	RTS
level1BB:
	RTS
level1BC:
	RTS
level1BD:
	RTS
level1BE:
	RTS
level1BF:
	RTS
level1C0:
	RTS
level1C1:
	RTS
level1C2:
	RTS
level1C3:
	RTS
level1C4:
	RTS
level1C5:
	RTS
level1C6:
	RTS
level1C7:
	RTS
level1C8:
	RTS
level1C9:
	RTS
level1CA:
	RTS
level1CB:
	RTS
level1CC:
	RTS
level1CD:
	RTS
level1CE:
	RTS
level1CF:
	RTS
level1D0:
	RTS
level1D1:
	RTS
level1D2:
	RTS
level1D3:
	RTS
level1D4:
	RTS
level1D5:
	RTS
level1D6:
	RTS
level1D7:
	RTS
level1D8:
	RTS
level1D9:
	RTS
level1DA:
	RTS
level1DB:
	RTS
level1DC:
	RTS
level1DD:
	RTS
level1DE:
	RTS
level1DF:
	RTS
level1E0:
	RTS
level1E1:
	RTS
level1E2:
	RTS
level1E3:
	RTS
level1E4:
	RTS
level1E5:
	RTS
level1E6:
	RTS
level1E7:
	RTS
level1E8:
	RTS
level1E9:
	RTS
level1EA:
	RTS
level1EB:
	RTS
level1EC:
	RTS
level1ED:
	RTS
level1EE:
	RTS
level1EF:
	RTS
level1F0:
	RTS
level1F1:
	RTS
level1F2:
	RTS
level1F3:
	RTS
level1F4:
	RTS
level1F5:
	RTS
level1F6:
	RTS
level1F7:
	RTS
level1F8:
	RTS
level1F9:
	RTS
level1FA:
	RTS
level1FB:
	RTS
level1FC:
	RTS
level1FD:
	RTS
level1FE:
	RTS
level1FF:
	RTS
