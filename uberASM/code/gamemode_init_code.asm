gamemode_init_0:
	RTS
gamemode_init_1:
	RTS
gamemode_init_2:
	RTS
gamemode_init_3:
	RTS
gamemode_init_4:
	LDA #$FF		;\
	STA $0F43		; | Initializes the BGM and SFX test track numbers.
	STA $0F44		;/
	STA $0DDB		; Allows all music to restart.
	RTS			; Ends the code.
gamemode_init_5:
	RTS
gamemode_init_6:
	RTS
gamemode_init_7:
	RTS
gamemode_init_8:
SFXTEST:
	LDA $16			;\
	ORA $18			; | Branches if the A, B, X, or Y buttons are pressed.
	AND #$C0		; |
	BNE NOR			;/
	LDA $16			;\
	AND #$02		; | Branches if the left button is not pressed.
	BEQ NOLEFT		;/
	DEC $0F43		; Decreases the SFX Test ID.
	LDA $0F43		;\
	BPL NOUNDERFLOW		;/ Branches if the SFX Test ID is positive.
	LDA #$74		;\
	STA $0F43		;/ Sets the SFX Test ID to 116.
NOUNDERFLOW:
	JSR DRAWSFXTEXT		; Jumps to the draw SFX text routine.
NOLEFT:
	LDA $18			;\
	AND #$20		; | Branches if the L button is not pressed.
	BEQ NOL			;/
	DEC $0F43		; Decreases the SFX Test ID.
	LDA $0F43		;\
	BPL NOUNDERFLOW2	;/ Branches if the SFX Test ID is positive.
	LDA #$74		;\
	STA $0F43		;/ Sets the SFX Test ID to 116.
NOUNDERFLOW2:
	JSR DRAWSFXTEXT		; Jumps to the draw SFX text routine.
	JSR HANDLESFX		; Jumps to the handle SFX ID routine.
NOL:
	LDA $16			;\
	AND #$01		; | Branches if the right button is not pressed.
	BEQ NORIGHT		;/
	INC $0F43		; Increases the SFX Test ID.
	LDA $0F43		;\
	CMP #$75		; | Branches if the SFX Test ID is less than 110.
	BCC NOOVERFLOW		;/
	STZ $0F43		; Sets the SFX Test ID to 0.
NOOVERFLOW:
	JSR DRAWSFXTEXT		; Jumps to the draw SFX text routine.
NORIGHT:
	LDA $18			;\
	AND #$10		; | Branches if the R button is not pressed.
	BEQ NOR			;/
	INC $0F43		; Increases the SFX Test ID.
	LDA $0F43		;\
	CMP #$75		; | Branches if the SFX Test ID is less than 110.
	BCC NOOVERFLOW2		;/
	STZ $0F43		; Sets the SFX Test ID to 0.
NOOVERFLOW2:
	JSR DRAWSFXTEXT		; Jumps to the draw SFX text routine.
	JSR HANDLESFX		; Jumps to the handle SFX ID routine.
NOR:
	RTS			; Ends the code.
DRAWSFXTEXT:
	LDY #$00		; Sets the Y Register to 0.
	LDA $7F837B		; Loads the length of the text stripe image.
	TAX			; Transfers the Accumulator to the X Register.
SFXTEXTLOOP:
	LDA SFXTEXT,y		;\
	STA $7F837D,x		;/ Loads and stores the SFX Test string tiles and properties into the stripe image.
	INX			; Increases the X Register.
	INY			; Increases the Y Register.
	CPY #$0C		;\
	BMI SFXTEXTLOOP		;/ Loops until the Y Register is 12.
	PHX			; Preserves the X Register.
	LDA $0F43		;\
	JSL $80974C		;/ Converts the SFX Test ID into a decimal number.
	STA $02			; Stores the ones value into scratch RAM.
	TXA			; Transfers the X Register to the Accumulator.
	JSL $80974C		; Converts the tens value of the SFX Test ID into a decimal number.
	STA $01			; Stores the tens value into scratch RAM.
	STX $00			; Stores the hundreds value into scratch RAM.
	PLX			; Pulls back the X Register.
	LDY #$00		; Loads the length of the text stripe image.
SFXNUMBERLOOP:
	LDA $0000,y		;\
	STA $7F837D,x		;/ Loads and stores the SFX Test ID tiles into the stripe image.
	INX			; Increases the X Register.
	LDA #$28		;\
	STA $7F837D,x		;/ Stores the SFX Test ID properties.
	INX			; Increases the X Register.
	INY			; Increases the Y Register.
	CPY #$03		;\
	BMI SFXNUMBERLOOP	;/ Loops until the Y Register is 3.
	LDA #$FF		;\
	STA $7F837D,x		;/ Ends the stripe image table.
	TXA			; Transfers the X Register to the Accumulator.
	STA $7F837B		; Stores the stripe image length.
	RTS			; Ends the code.
HANDLESFX:
;	LDA $1DFB		;\
;	CMP #$25		; | Branches if the music number is less than 37.
;	BCC NOMUTE		;/
;MUTE:
;	LDA #$09		;\
;	STA $1DFA		;/ Mutes the music.
;	BRA CONTINUESFX		; Branches to the continue SFX routine.
;NOMUTE:
;	CMP #$1E		;\
;	BEQ MUTE		;/ Branches if the music number is 30
;CONTINUESFX:
	LDY $0F43		;\
	LDA SFXLIST,y		;/ Loads the sound effect indexed by the SFX Test ID.
	CPY #$30		;\
	BCS NEXTPORT		;/ Branches if the SFX Test ID is 45 or higher.
	STA $1DF9		; Sets the sound to play.
	RTS			; Ends the code.
NEXTPORT:
	CPY #$3C		;\
	BCS NEXTPORT2		;/ Branches if the SFX Test ID is 55 or higher.
	STA $1DFA		; Sets the sound to play.
	RTS			; Ends the code.
NEXTPORT2:
	STA $1DFC		; Sets the sound to play.
	RTS			; Ends the code.
SFXLIST:
db $00,$01,$02,$03,$04,$05,$06,$07
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
db $10,$11,$12,$13,$14,$15,$16,$17
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F
db $20,$21,$22,$23,$24,$25,$26,$27
db $28,$29,$2A,$2B,$2C,$2D,$2E,$80

db $00,$01,$02,$03,$04,$05,$06,$07
db $08,$09,$0A,$00

db $00,$01,$02,$03,$04,$05,$06,$07
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
db $10,$11,$12,$13,$14,$15,$16,$17
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F
db $20,$21,$22,$23,$24,$25,$26,$27
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F
db $30,$31,$32,$33,$34,$35,$36,$37
db $38

SFXTEXT:
db $53,$22,$00,$0D
db $1C,$28,$0F,$28,$21,$28,$78,$28

gamemode_init_9:
	RTS
gamemode_init_A:
BGMTEST:
	LDA $16			;\
	ORA $18			; | Branches if the A, B, X, or Y buttons are pressed.
	AND #$C0		; |
	BNE NOR2		;/
	LDA $16			;\
	AND #$02		; | Branches if the left button is not pressed.
	BEQ NOLEFT2		;/
	DEC $0F44		; Decreases the BGM Test ID.
	LDA $0F44		;\
	BPL NOUNDERFLOW3	;/ Branches if the BGM Test ID is positive.
	LDA #$31		;\
	STA $0F44		;/ Sets the BGM Test ID to 49.
NOUNDERFLOW3:
	JSR DRAWBGMTEXT		; Jumps to the draw BGM text routine.
NOLEFT2:
	LDA $18			;\
	AND #$20		; | Branches if the L button is not pressed.
	BEQ NOL2		;/
	DEC $0F44		; Decreases the BGM Test ID.
	LDA $0F44		;\
	BPL NOUNDERFLOW4	;/ Branches if the BGM Test ID is positive.
	LDA #$31		;\
	STA $0F44		;/ Sets the BGM Test ID to 49.
NOUNDERFLOW4:
	JSR DRAWBGMTEXT		; Jumps to the draw BGM text routine.
	JSR HANDLEBGM		; Jumps to the handle BGM ID routine.
NOL2:
	LDA $16			;\
	AND #$01		; | Branches if the right button is not pressed.
	BEQ NORIGHT2		;/
	INC $0F44		; Increases the BGM Test ID.
	LDA $0F44		;\
	CMP #$32		; | Branches if the BGM Test ID is less than 50.
	BCC NOOVERFLOW3		;/
	STZ $0F44		; Sets the BGM Test ID to 0.
NOOVERFLOW3:
	JSR DRAWBGMTEXT		; Jumps to the draw BGM text routine.
NORIGHT2:
	LDA $18			;\
	AND #$10		; | Branches if the R button is not pressed.
	BEQ NOR2		;/
	INC $0F44		; Increases the BGM Test ID.
	LDA $0F44		;\
	CMP #$32		; | Branches if the BGM Test ID is less than 50.
	BCC NOOVERFLOW4		;/
	STZ $0F44		; Sets the BGM Test ID to 0.
NOOVERFLOW4:
	JSR DRAWBGMTEXT		; Jumps to the draw BGM text routine.
	JSR HANDLEBGM		; Jumps to the handle BGM ID routine.
NOR2:	
	RTS			; Ends the code.
DRAWBGMTEXT:
	LDY #$00		; Sets the Y Register to 0.
	LDA $7F837B		; Loads the length of the text stripe image.
	TAX			; Transfers the Accumulator to the X Register.
BGMTEXTLOOP:
	LDA BGMTEXT,y		;\
	STA $7F837D,x		;/ Loads and stores the BGM Test string tiles and properties into the stripe image.
	INX			; Increases the X Register.
	INY			; Increases the Y Register.
	CPY #$0C		;\
	BMI BGMTEXTLOOP		;/ Loops until the Y Register is 12.
	PHX			; Preserves the X Register.
	LDA $0F44		;\
	JSL $80974C		;/ Converts the BGM Test ID into a decimal number.
	STA $02			; Stores the ones value into scratch RAM.
	TXA			; Transfers the X Register to the Accumulator.
	JSL $80974C		; Converts the tens value of the BGM Test ID into a decimal number.
	STA $01			; Stores the tens value into scratch RAM.
	STX $00			; Stores the hundreds value into scratch RAM.
	PLX			; Pulls back the X Register.
	LDY #$00		; Loads the length of the text stripe image.
BGMNUMBERLOOP:
	LDA $0000,y		;\
	STA $7F837D,x		;/ Loads and stores the SFX Test ID tiles into the stripe image.
	INX			; Increases the X Register.
	LDA #$28		;\
	STA $7F837D,x		;/ Stores the SFX Test ID properties.
	INX			; Increases the X Register.
	INY			; Increases the Y Register.
	CPY #$03		;\
	BMI BGMNUMBERLOOP	;/ Loops until the Y Register is 3.
	LDA #$FF		;\
	STA $7F837D,x		;/ Ends the stripe image table.
	TXA			; Transfers the X Register to the Accumulator.
	STA $7F837B		; Stores the stripe image length.
	RTS			; Ends the code.
HANDLEBGM:
	LDA $0F44		;\
	CMP #$30		; | Branches if the BGM Test ID is less than 49.
	BCC NOBGMOFFSET		;/
	CLC
	ADC #$CE
NOBGMOFFSET:
	STA $1DFB		; Sets the music to play.
	RTS			; Ends the code.
BGMTEXT:
db $53,$22,$00,$0D
db $0B,$28,$10,$28,$16,$28,$78,$28

gamemode_init_B:
	STZ $0DDB		; Only allows some music to restart.
	RTS
gamemode_init_C:
	STZ $0DA1		; Resets the Mario palette index.
	STZ $0F3E		; Resets the fullscreen Layer 3 flag.
	RTS			; Ends the code.
gamemode_init_D:
	RTS
gamemode_init_E:
	LDA $1F34		;\
	AND #$80		; | Branches if Mario has not collected all Dragon Coins in level 104.
	BEQ NODRAGONCOINS	;/
	LDA #$01		;\
	STA $0F3A		;/ Sets the all Dragon Coins flag.
NODRAGONCOINS:
	LDA $1F41		;\
	AND #$80		; | Branches if Mario has not collected the Invisible 1-Up Mushroom in level 104.
	BEQ NOMUSHROOM		;/
	LDA #$01		;\
	STA $0F3B		;/ Sets the all Invisible 1-Up Mushrooms flag.
NOMUSHROOM:
	LDA $1FF3		;\
	AND #$80		; | Branches if Mario has not collected the 3-Up Moon in level 104.
	BEQ NOMOON		;/
	LDA #$01		;\
	STA $0F3C		;/ Sets the all 3-Up Moons flag.
NOMOON:
	LDX #$01		; Loads a loop count of 1.
PLAYERLOOP:
	LDA $0DB4,x		;\
	CMP #$62		; | Branches if either Mario or Luigi has 99 lives.
	BCS MAXLIVES		;/
	DEX			; Decreases the X Register.
	BPL PLAYERLOOP		; Loops the player loop until it is negative.
;	STZ $0F3D		; Clears the 99 lives flag.
	BRA FINISHSAVE		; Branches to the finish save routine.
MAXLIVES:
	LDA #$01		;\
	STA $0F3D		;/ Sets the 99 lives flag.
FINISHSAVE:
	LDX #$03		; Loads a loop count of 3.
	LDA #$00		; Loads 0.
	CLC			; Clears the carry flag.
COMPLETIONLOOP:
	ADC $0F3A,x		;\
	STA $0DDC		;/ Adds each completion flag to the total number of completions.
	DEX			; Decreases the X Register.
	BPL COMPLETIONLOOP	; Loops the completion loop until it is negative.
	RTS			; Ends the code.
gamemode_init_F:
	RTS
gamemode_init_10:
	RTS
gamemode_init_11:
	RTS
gamemode_init_12:
	REP #$10		; Turns on 16-bit addressing mode for the X and Y Registers.
	LDX $010B		;\
	LDA MARIOPALETTEINDEX,x	; | Loads the Mario palette index for each level.
	STA $0DA1		;/
	LDA FULLSCREENLAYER3,x	;\
	STA $0F3E		;/ Loads the fullscreen Layer 3 flags for each level
	SEP #$10		; Turns on 8-bit addressing mode for the X and Y Registers.
	REP #$20		; Turns on 16-bit addressing mode for the Accumulator.
	LDA $010B		;\
	CMP #$002E		; | Branches if Mario is in level 2E.
	BEQ NOITEM		;/
	CMP #$002F		;\
	BEQ NOITEM		;/ Branches if Mario is in level 2F.
	CMP #$0104		;\
	BEQ NOITEM		;/ Branches if Mario is in level 104.
	SEP #$20		; Turns on 8-bit addressing mode for the Accumulator.
	RTS			; Ends the code.
NOITEM:
	SEP #$20		; Turns on 8-bit addressing mode for the Accumulator.
	STZ $0DC2		; Removes Mario's reserve item.
	LDA.B #$01                
	STA.W $0DB1
	RTS			; Ends the code.

MARIOPALETTEINDEX: fillbyte $00 : fill $0025
db $08,$07,$00,$08,$00,$00,$00,$00
db $00,$00,$00,$07,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$07,$00,$00,$00,$00,$00,$00
db $08,$00,$07
fillbyte $00 : fill $01B8

FULLSCREENLAYER3: fillbyte $00 : fill $0032
db $01,$01,$00,$00,$01,$00,$00,$01
db $01,$00,$00,$01
fillbyte $00 : fill $01C3

SFXECHOINDEX:  fillbyte $06 : fill $0025
db $05,$05,$05,$05,$05,$05,$05,$05
db $05,$05,$05,$05,$05,$05,$05,$06
db $05,$05,$05,$05,$05,$05,$06,$05
db $05,$05,$05,$05,$05,$05,$05,$05
db $05,$05,$05,$05,$05,$05,$05
fillbyte $06 : fill $00B8
db $05,$05,$05
fillbyte $06 : fill $00F9

gamemode_init_13:
	REP #$10		; Turns on 16-bit addressing mode for the X and Y Registers.
	LDX $010B		;\
	LDA SFXECHOINDEX,x	; | Loads the sound effect echo settings for each level.
	STA $1DFA		;/
	SEP #$10		; Turns on 8-bit addressing mode for the X and Y Registers.
	RTS			; Ends the code.
gamemode_init_14:
	RTS
gamemode_init_15:
	RTS
gamemode_init_16:
	RTS
gamemode_init_17:
	RTS
gamemode_init_18:
	RTS
gamemode_init_19:
	RTS
gamemode_init_1A:
	RTS
gamemode_init_1B:
	RTS
gamemode_init_1C:
	RTS
gamemode_init_1D:
	RTS
gamemode_init_1E:
	RTS
gamemode_init_1F:
	RTS
gamemode_init_20:
	RTS
gamemode_init_21:
	RTS
gamemode_init_22:
	RTS
gamemode_init_23:
	RTS
gamemode_init_24:
	RTS
gamemode_init_25:
	RTS
gamemode_init_26:
	RTS
gamemode_init_27:
	RTS
gamemode_init_28:
	RTS
gamemode_init_29:
	RTS
gamemode_init_2A:
	RTS
gamemode_init_2B:
	RTS
gamemode_init_2C:
	RTS
gamemode_init_2D:
	RTS
gamemode_init_2E:
	RTS
gamemode_init_2F:
	RTS
gamemode_init_30:
	RTS
gamemode_init_31:
	RTS
gamemode_init_32:
	RTS
gamemode_init_33:
	RTS
gamemode_init_34:
	RTS
gamemode_init_35:
	RTS
gamemode_init_36:
	RTS
gamemode_init_37:
	RTS
gamemode_init_38:
	RTS
gamemode_init_39:
	RTS
gamemode_init_3A:
	RTS
gamemode_init_3B:
	RTS
gamemode_init_3C:
	RTS
gamemode_init_3D:
	RTS
gamemode_init_3E:
	RTS
gamemode_init_3F:
	RTS
gamemode_init_40:
	RTS
gamemode_init_41:
	RTS
gamemode_init_42:
	RTS
gamemode_init_43:
	RTS
gamemode_init_44:
	RTS
gamemode_init_45:
	RTS
gamemode_init_46:
	RTS
gamemode_init_47:
	RTS
gamemode_init_48:
	RTS
gamemode_init_49:
	RTS
gamemode_init_4A:
	RTS
gamemode_init_4B:
	RTS
gamemode_init_4C:
	RTS
gamemode_init_4D:
	RTS
gamemode_init_4E:
	RTS
gamemode_init_4F:
	RTS
gamemode_init_50:
	RTS
gamemode_init_51:
	RTS
gamemode_init_52:
	RTS
gamemode_init_53:
	RTS
gamemode_init_54:
	RTS
gamemode_init_55:
	RTS
gamemode_init_56:
	RTS
gamemode_init_57:
	RTS
gamemode_init_58:
	RTS
gamemode_init_59:
	RTS
gamemode_init_5A:
	RTS
gamemode_init_5B:
	RTS
gamemode_init_5C:
	RTS
gamemode_init_5D:
	RTS
gamemode_init_5E:
	RTS
gamemode_init_5F:
	RTS
gamemode_init_60:
	RTS
gamemode_init_61:
	RTS
gamemode_init_62:
	RTS
gamemode_init_63:
	RTS
gamemode_init_64:
	RTS
gamemode_init_65:
	RTS
gamemode_init_66:
	RTS
gamemode_init_67:
	RTS
gamemode_init_68:
	RTS
gamemode_init_69:
	RTS
gamemode_init_6A:
	RTS
gamemode_init_6B:
	RTS
gamemode_init_6C:
	RTS
gamemode_init_6D:
	RTS
gamemode_init_6E:
	RTS
gamemode_init_6F:
	RTS
gamemode_init_70:
	RTS
gamemode_init_71:
	RTS
gamemode_init_72:
	RTS
gamemode_init_73:
	RTS
gamemode_init_74:
	RTS
gamemode_init_75:
	RTS
gamemode_init_76:
	RTS
gamemode_init_77:
	RTS
gamemode_init_78:
	RTS
gamemode_init_79:
	RTS
gamemode_init_7A:
	RTS
gamemode_init_7B:
	RTS
gamemode_init_7C:
	RTS
gamemode_init_7D:
	RTS
gamemode_init_7E:
	RTS
gamemode_init_7F:
	RTS
gamemode_init_80:
	RTS
gamemode_init_81:
	RTS
gamemode_init_82:
	RTS
gamemode_init_83:
	RTS
gamemode_init_84:
	RTS
gamemode_init_85:
	RTS
gamemode_init_86:
	RTS
gamemode_init_87:
	RTS
gamemode_init_88:
	RTS
gamemode_init_89:
	RTS
gamemode_init_8A:
	RTS
gamemode_init_8B:
	RTS
gamemode_init_8C:
	RTS
gamemode_init_8D:
	RTS
gamemode_init_8E:
	RTS
gamemode_init_8F:
	RTS
gamemode_init_90:
	RTS
gamemode_init_91:
	RTS
gamemode_init_92:
	RTS
gamemode_init_93:
	RTS
gamemode_init_94:
	RTS
gamemode_init_95:
	RTS
gamemode_init_96:
	RTS
gamemode_init_97:
	RTS
gamemode_init_98:
	RTS
gamemode_init_99:
	RTS
gamemode_init_9A:
	RTS
gamemode_init_9B:
	RTS
gamemode_init_9C:
	RTS
gamemode_init_9D:
	RTS
gamemode_init_9E:
	RTS
gamemode_init_9F:
	RTS
gamemode_init_A0:
	RTS
gamemode_init_A1:
	RTS
gamemode_init_A2:
	RTS
gamemode_init_A3:
	RTS
gamemode_init_A4:
	RTS
gamemode_init_A5:
	RTS
gamemode_init_A6:
	RTS
gamemode_init_A7:
	RTS
gamemode_init_A8:
	RTS
gamemode_init_A9:
	RTS
gamemode_init_AA:
	RTS
gamemode_init_AB:
	RTS
gamemode_init_AC:
	RTS
gamemode_init_AD:
	RTS
gamemode_init_AE:
	RTS
gamemode_init_AF:
	RTS
gamemode_init_B0:
	RTS
gamemode_init_B1:
	RTS
gamemode_init_B2:
	RTS
gamemode_init_B3:
	RTS
gamemode_init_B4:
	RTS
gamemode_init_B5:
	RTS
gamemode_init_B6:
	RTS
gamemode_init_B7:
	RTS
gamemode_init_B8:
	RTS
gamemode_init_B9:
	RTS
gamemode_init_BA:
	RTS
gamemode_init_BB:
	RTS
gamemode_init_BC:
	RTS
gamemode_init_BD:
	RTS
gamemode_init_BE:
	RTS
gamemode_init_BF:
	RTS
gamemode_init_C0:
	RTS
gamemode_init_C1:
	RTS
gamemode_init_C2:
	RTS
gamemode_init_C3:
	RTS
gamemode_init_C4:
	RTS
gamemode_init_C5:
	RTS
gamemode_init_C6:
	RTS
gamemode_init_C7:
	RTS
gamemode_init_C8:
	RTS
gamemode_init_C9:
	RTS
gamemode_init_CA:
	RTS
gamemode_init_CB:
	RTS
gamemode_init_CC:
	RTS
gamemode_init_CD:
	RTS
gamemode_init_CE:
	RTS
gamemode_init_CF:
	RTS
gamemode_init_D0:
	RTS
gamemode_init_D1:
	RTS
gamemode_init_D2:
	RTS
gamemode_init_D3:
	RTS
gamemode_init_D4:
	RTS
gamemode_init_D5:
	RTS
gamemode_init_D6:
	RTS
gamemode_init_D7:
	RTS
gamemode_init_D8:
	RTS
gamemode_init_D9:
	RTS
gamemode_init_DA:
	RTS
gamemode_init_DB:
	RTS
gamemode_init_DC:
	RTS
gamemode_init_DD:
	RTS
gamemode_init_DE:
	RTS
gamemode_init_DF:
	RTS
gamemode_init_E0:
	RTS
gamemode_init_E1:
	RTS
gamemode_init_E2:
	RTS
gamemode_init_E3:
	RTS
gamemode_init_E4:
	RTS
gamemode_init_E5:
	RTS
gamemode_init_E6:
	RTS
gamemode_init_E7:
	RTS
gamemode_init_E8:
	RTS
gamemode_init_E9:
	RTS
gamemode_init_EA:
	RTS
gamemode_init_EB:
	RTS
gamemode_init_EC:
	RTS
gamemode_init_ED:
	RTS
gamemode_init_EE:
	RTS
gamemode_init_EF:
	RTS
gamemode_init_F0:
	RTS
gamemode_init_F1:
	RTS
gamemode_init_F2:
	RTS
gamemode_init_F3:
	RTS
gamemode_init_F4:
	RTS
gamemode_init_F5:
	RTS
gamemode_init_F6:
	RTS
gamemode_init_F7:
	RTS
gamemode_init_F8:
	RTS
gamemode_init_F9:
	RTS
gamemode_init_FA:
	RTS
gamemode_init_FB:
	RTS
gamemode_init_FC:
	RTS
gamemode_init_FD:
	RTS
gamemode_init_FE:
	RTS
gamemode_init_FF:
	RTS
