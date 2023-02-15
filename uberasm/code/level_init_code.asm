;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;True levelinitASM Code lies ahead.
;If you are too lazy to search for a levelinit
;Use CTRL+F. The format is as following:
;levelinitx - levelinits 0-F
;levelinitxx - levelinits 10-FF
;levelinitxxx - levelinits 100-1FF
;Should be pretty obvious...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

levelinit0:
	RTS
levelinit1:
	RTS
levelinit2:
	RTS
levelinit3:
	RTS
levelinit4:
	RTS
levelinit5:
	RTS
levelinit6:
	RTS
levelinit7:
	RTS
levelinit8:
	RTS
levelinit9:
	RTS
levelinitA:
	RTS
levelinitB:
	RTS
levelinitC:
	RTS
levelinitD:
	RTS
levelinitE:
	RTS
levelinitF:
	RTS
levelinit10:
	RTS
levelinit11:
	RTS
levelinit12:
	RTS
levelinit13:
	RTS
levelinit14:
	RTS
levelinit15:
	RTS
levelinit16:
	RTS
levelinit17:
	RTS
levelinit18:
	RTS
levelinit19:
	RTS
levelinit1A:
	RTS
levelinit1B:
	RTS
levelinit1C:
	RTS
levelinit1D:
	RTS
levelinit1E:
	RTS
levelinit1F:
	RTS
levelinit20:
	RTS
levelinit21:
	RTS
levelinit22:
	RTS
levelinit23:
	RTS
levelinit24:
	RTS
levelinit25:
	RTS
levelinit26:
	RTS
levelinit27:
	RTS
levelinit28:
	LDA #$2B		;\
	STA $5C			;/ Sets the message timer
	STZ $76			; Makes the player face left.
	RTS			; Ends the code.
levelinit29:
	RTS
levelinit2A:
	LDA $06FD		;\
	BNE REMEMBER		;/ Branches if the music block translevel number is not 0.
	LDA #$35		;\
	STA $06FF		;/ Sets the music block translevel number.
	LDA #$02		;\
	STA $0700		;/ Sets the music block message to display.
REMEMBER:
	RTS			; Ends the code.
levelinit2B:
	RTS
levelinit2C:
	RTS
levelinit2D:
	RTS
levelinit2E:
	RTS
levelinit2F:
	RTS
levelinit30:
	LDX $0DB3		;\
	LDA $0DC3,x		; |
	CLC			; | Backs up Mario/Luigi's coins additively.
	ADC $0DBF		; |
	STA $0DC3,x		;/
	LDA $0DC3,x		;\	
	CMP #$64		; | Branches if the coin backup is 100 or more.
	BCC MORECOINS		;/
	LDA #$63		;\
	STA $0DC3,x		;/ Sets the coin backup to 99.
MORECOINS:
	RTS			; Ends the code.
levelinit31:
	REP #$20		; Turns on 16-bit addressing mode.
	LDA $2137		; Loads the software latch for the horizontal/vertical counter.
	LDA $213C		; Loads the scanline location.
	ADC $13			;\
	ADC $14			;/ Adds both frame counters to the Accumulator.
	XBA			; Switches the high byte with the low byte.
	STA $148B		; Stores the value to the random number state.
	SEP #$20		; Turns on 8-bit addressing mode.
	STZ $0DBF		; Sets Mario's coin status to 0.
	STZ $5C			; Resets the shatter block flag.
	LDA #$00		; Loads the value to reset the timers.
	LDX #$2F		; Loads a loop count of 48.
WARNINGRESETLOOP:
	STA $7FB920,x		; Clears the warning sign timers.
	DEX			; Decreases the X Register.
	BPL WARNINGRESETLOOP	; Loops the warning reset loop until it is -1.
	LDX #$07		; Loads a loop count of 8.
LIGHTNINGRESETLOOP:
	STA $7FBA70,x		; Clears the lightning strike timer.
	DEX			; Decreases the X Register.
	BPL LIGHTNINGRESETLOOP	; Loops the lightning reset loop until it is -1.
	STZ $15			;\
	STZ $16			; |
	STZ $17			; | Disables Mario's conrtols.
	STZ $18			;/
	LDA #$30		;\
	STA $13D3		;/ Disables pausing.
	STA $79			; Sets the disable controls flag.
	LDA #$04		;\
	STA $212C		;/ Puts Layer 3 on the main screen.
	LDA #$13		;\
	STA $212D		;/ Puts Layers 1, 2, 4, and Sprites on the subscreen.
	REP #$20		; Turns on 16-bit addressing mode.
	LDA #$2103		;\
	STA $4330 		;/ Sets the mode and registers for channel 3.
	LDA #$0F5E		;\
	STA $4332		;/ Loads the CGRAM HDMA values from a RAM address.
	SEP #$20		; Turns on 8-bit addressing mode.
	PHK			;\
	PLA			; | Sets the bank byte of the table.
	STA $4334		;/
	REP #$20		; Turns on 16-bit addressing mode. 
	LDA #$0D02		;\
	STA $4340		;/ Sets the mode and registers for channel 4.
	LDA #$9E00		;\
	STA $4342		;/ Loads the wave HDMA values from a RAM address.
	SEP #$20		; Turns on 8-bit addressing mode.
	LDA.b #$7F		;\
	STA $4344		;/ Sets the bank byte of the table.
   	REP #$20		; Turns on 16-bit addressing mode.
   	LDA #$0000		;\
   	STA $4350		;/ Sets the mode and registers for channel 5.
   	LDA #LIGHTTABLE		;\
   	STA $4352		;/ Loads the brightness HDMA values.
   	SEP #$20		; Turns on 8-bit addressing mode.
   	LDA.b #LIGHTTABLE>>16	;\
   	STA $4354		;/ Sets the bank byte of the table.
	REP #$20		; Turns on 16-bit addressing mode.
	LDA #$0F02		;\
	STA $4360		;/ Sets the mode and registers for channel 6.
	LDA #$9F00		;\
	STA $4362		;/ Loads the wave HDMA values from a RAM address.
	SEP #$20		; Turns on 8-bit addressing mode.
	LDA.b #$7F		;\
	STA $4364		;/ Sets the bank byte of the table.
	RTS			; Ends the code.

LIGHTTABLE:
db $80,$08,$60,$08,$00

levelinit32:
	RTS
levelinit33:
	RTS
levelinit34:
	RTS
levelinit35:
	RTS
levelinit36:
	RTS
levelinit37:
	RTS
levelinit38:
	RTS
levelinit39:
	RTS
levelinit3A:
	RTS
levelinit3B:
	RTS
levelinit3C:
	RTS
levelinit3D:
	STZ $5C			; Resets a message timer.
	RTS			; Ends the code.
levelinit3E:
	RTS
levelinit3F:
	RTS
levelinit40:
	RTS
levelinit41:
	RTS
levelinit42:
	RTS
levelinit43:
	RTS
levelinit44:
	RTS
levelinit45:
	RTS
levelinit46:
	RTS
levelinit47:
	RTS
levelinit48:
	RTS
levelinit49:
	STZ $5C			; Resets Red Yoshi's walking timer.
	STZ $60			; Resets Red Yoshi's halt timer.
	STZ $15			;\
	STZ $16			; |
	STZ $17			; | Disables Mario's conrtols.
	STZ $18			;/
	LDA #$01		;\
	STA $13D3		;/ Disables pausing.
	RTS			; Ends the code.
levelinit4A:
	LDA #$04		;\
	STA $5C			;/ Sets a message timer.
	STZ $60			; Resets the message number.
	STZ $15			;\
	STZ $16			; |
	STZ $17			; | Disables Mario's conrtols.
	STZ $18			;/
	LDA #$01		;\
	STA $13D3		;/ Disables pausing.
	RTS			; Ends the code.
levelinit4B:
	LDA #$04		;\
	STA $5C			;/ Sets a message timer.
	STZ $60			; Resets the level state.
	STZ $15			;\
	STZ $16			; |
	STZ $17			; | Disables Mario's conrtols.
	STZ $18			;/
	LDA #$01		;\
	STA $13D3		;/ Disables pausing.
	RTS			; Ends the code.
levelinit4C:
	RTS
levelinit4D:
	RTS
levelinit4E:
	RTS
levelinit4F:
	RTS
levelinit50:
	RTS
levelinit51:
	RTS
levelinit52:
	RTS
levelinit53:
	RTS
levelinit54:
	RTS
levelinit55:
	RTS
levelinit56:
	RTS
levelinit57:
	RTS
levelinit58:
	RTS
levelinit59:
	RTS
levelinit5A:
	RTS
levelinit5B:
	RTS
levelinit5C:
	RTS
levelinit5D:
	RTS
levelinit5E:
	RTS
levelinit5F:
	RTS
levelinit60:
	RTS
levelinit61:
	RTS
levelinit62:
	RTS
levelinit63:
	RTS
levelinit64:
	RTS
levelinit65:
	RTS
levelinit66:
	RTS
levelinit67:
	RTS
levelinit68:
	RTS
levelinit69:
	RTS
levelinit6A:
	RTS
levelinit6B:
	RTS
levelinit6C:
	RTS
levelinit6D:
	RTS
levelinit6E:
	RTS
levelinit6F:
	RTS
levelinit70:
	RTS
levelinit71:
	RTS
levelinit72:
	RTS
levelinit73:
	RTS
levelinit74:
	RTS
levelinit75:
	RTS
levelinit76:
	RTS
levelinit77:
	RTS
levelinit78:
	RTS
levelinit79:
	RTS
levelinit7A:
	RTS
levelinit7B:
	RTS
levelinit7C:
	RTS
levelinit7D:
	RTS
levelinit7E:
	RTS
levelinit7F:
	RTS
levelinit80:
	RTS
levelinit81:
	RTS
levelinit82:
	RTS
levelinit83:
	RTS
levelinit84:
	RTS
levelinit85:
	RTS
levelinit86:
	RTS
levelinit87:
	RTS
levelinit88:
	RTS
levelinit89:
	RTS
levelinit8A:
	RTS
levelinit8B:
	RTS
levelinit8C:
	RTS
levelinit8D:
	RTS
levelinit8E:
	RTS
levelinit8F:
	RTS
levelinit90:
	RTS
levelinit91:
	RTS
levelinit92:
	RTS
levelinit93:
	RTS
levelinit94:
	RTS
levelinit95:
	RTS
levelinit96:
	RTS
levelinit97:
	RTS
levelinit98:
	RTS
levelinit99:
	RTS
levelinit9A:
	RTS
levelinit9B:
	RTS
levelinit9C:
	RTS
levelinit9D:
	RTS
levelinit9E:
	RTS
levelinit9F:
	RTS
levelinitA0:
	RTS
levelinitA1:
	RTS
levelinitA2:
	RTS
levelinitA3:
	RTS
levelinitA4:
	RTS
levelinitA5:
	RTS
levelinitA6:
	RTS
levelinitA7:
	RTS
levelinitA8:
	RTS
levelinitA9:
	RTS
levelinitAA:
	RTS
levelinitAB:
	RTS
levelinitAC:
	RTS
levelinitAD:
	RTS
levelinitAE:
	RTS
levelinitAF:
	RTS
levelinitB0:
	RTS
levelinitB1:
	RTS
levelinitB2:
	RTS
levelinitB3:
	RTS
levelinitB4:
	RTS
levelinitB5:
	RTS
levelinitB6:
	RTS
levelinitB7:
	RTS
levelinitB8:
	RTS
levelinitB9:
	RTS
levelinitBA:
	RTS
levelinitBB:
	RTS
levelinitBC:
	RTS
levelinitBD:
	RTS
levelinitBE:
	RTS
levelinitBF:
	RTS
levelinitC0:
	RTS
levelinitC1:
	RTS
levelinitC2:
	RTS
levelinitC3:
	RTS
levelinitC4:
	RTS
levelinitC5:
	RTS
levelinitC6:
	RTS
levelinitC7:
	RTS
levelinitC8:
	RTS
levelinitC9:
	RTS
levelinitCA:
	RTS
levelinitCB:
	RTS
levelinitCC:
	RTS
levelinitCD:
	RTS
levelinitCE:
	RTS
levelinitCF:
	RTS
levelinitD0:
	RTS
levelinitD1:
	RTS
levelinitD2:
	RTS
levelinitD3:
	RTS
levelinitD4:
	RTS
levelinitD5:
	RTS
levelinitD6:
	RTS
levelinitD7:
	RTS
levelinitD8:
	RTS
levelinitD9:
	RTS
levelinitDA:
	RTS
levelinitDB:
	RTS
levelinitDC:
	RTS
levelinitDD:
	RTS
levelinitDE:
	RTS
levelinitDF:
	RTS
levelinitE0:
	RTS
levelinitE1:
	RTS
levelinitE2:
	RTS
levelinitE3:
	RTS
levelinitE4:
	RTS
levelinitE5:
	RTS
levelinitE6:
	RTS
levelinitE7:
	RTS
levelinitE8:
	RTS
levelinitE9:
	RTS
levelinitEA:
	RTS
levelinitEB:
	RTS
levelinitEC:
	RTS
levelinitED:
	RTS
levelinitEE:
	RTS
levelinitEF:
	RTS
levelinitF0:
	RTS
levelinitF1:
	RTS
levelinitF2:
	RTS
levelinitF3:
	RTS
levelinitF4:
	RTS
levelinitF5:
	RTS
levelinitF6:
	RTS
levelinitF7:
	RTS
levelinitF8:
	RTS
levelinitF9:
	RTS
levelinitFA:
	RTS
levelinitFB:
	RTS
levelinitFC:
	RTS
levelinitFD:
	RTS
levelinitFE:
	RTS
levelinitFF:
	RTS
levelinit100:
	RTS
levelinit101:
	RTS
levelinit102:
	RTS
levelinit103:
	RTS
levelinit104:
	RTS
levelinit105:
	RTS
levelinit106:
	RTS
levelinit107:
	RTS
levelinit108:
	RTS
levelinit109:
	RTS
levelinit10A:
	RTS
levelinit10B:
	RTS
levelinit10C:
	RTS
levelinit10D:
	RTS
levelinit10E:
	RTS
levelinit10F:
	RTS
levelinit110:
	RTS
levelinit111:
	RTS
levelinit112:
	RTS
levelinit113:
	RTS
levelinit114:
	RTS
levelinit115:
	RTS
levelinit116:
	RTS
levelinit117:
	RTS
levelinit118:
	RTS
levelinit119:
	RTS
levelinit11A:
	RTS
levelinit11B:
	RTS
levelinit11C:
	RTS
levelinit11D:
	RTS
levelinit11E:
	RTS
levelinit11F:
	RTS
levelinit120:
	RTS
levelinit121:
	RTS
levelinit122:
	RTS
levelinit123:
	RTS
levelinit124:
	RTS
levelinit125:
	RTS
levelinit126:
	RTS
levelinit127:
	RTS
levelinit128:
	RTS
levelinit129:
	RTS
levelinit12A:
	RTS
levelinit12B:
	RTS
levelinit12C:
	RTS
levelinit12D:
	RTS
levelinit12E:
	RTS
levelinit12F:
	RTS
levelinit130:
	RTS
levelinit131:
	RTS
levelinit132:
	RTS
levelinit133:
	RTS
levelinit134:
	RTS
levelinit135:
	RTS
levelinit136:
	RTS
levelinit137:
	RTS
levelinit138:
	RTS
levelinit139:
	RTS
levelinit13A:
	RTS
levelinit13B:
	RTS
levelinit13C:
	RTS
levelinit13D:
	RTS
levelinit13E:
	RTS
levelinit13F:
	RTS
levelinit140:
	RTS
levelinit141:
	RTS
levelinit142:
	RTS
levelinit143:
	RTS
levelinit144:
	RTS
levelinit145:
	RTS
levelinit146:
	RTS
levelinit147:
	RTS
levelinit148:
	RTS
levelinit149:
	RTS
levelinit14A:
	RTS
levelinit14B:
	RTS
levelinit14C:
	RTS
levelinit14D:
	RTS
levelinit14E:
	RTS
levelinit14F:
	RTS
levelinit150:
	RTS
levelinit151:
	RTS
levelinit152:
	RTS
levelinit153:
	RTS
levelinit154:
	RTS
levelinit155:
	RTS
levelinit156:
	RTS
levelinit157:
	RTS
levelinit158:
	RTS
levelinit159:
	RTS
levelinit15A:
	RTS
levelinit15B:
	RTS
levelinit15C:
	RTS
levelinit15D:
	RTS
levelinit15E:
	RTS
levelinit15F:
	RTS
levelinit160:
	RTS
levelinit161:
	RTS
levelinit162:
	RTS
levelinit163:
	RTS
levelinit164:
	RTS
levelinit165:
	RTS
levelinit166:
	RTS
levelinit167:
	RTS
levelinit168:
	RTS
levelinit169:
	RTS
levelinit16A:
	RTS
levelinit16B:
	RTS
levelinit16C:
	RTS
levelinit16D:
	RTS
levelinit16E:
	RTS
levelinit16F:
	RTS
levelinit170:
	RTS
levelinit171:
	RTS
levelinit172:
	RTS
levelinit173:
	RTS
levelinit174:
	RTS
levelinit175:
	RTS
levelinit176:
	RTS
levelinit177:
	RTS
levelinit178:
	RTS
levelinit179:
	RTS
levelinit17A:
	RTS
levelinit17B:
	RTS
levelinit17C:
	RTS
levelinit17D:
	RTS
levelinit17E:
	RTS
levelinit17F:
	RTS
levelinit180:
	RTS
levelinit181:
	RTS
levelinit182:
	RTS
levelinit183:
	RTS
levelinit184:
	RTS
levelinit185:
	RTS
levelinit186:
	RTS
levelinit187:
	RTS
levelinit188:
	RTS
levelinit189:
	RTS
levelinit18A:
	RTS
levelinit18B:
	RTS
levelinit18C:
	RTS
levelinit18D:
	RTS
levelinit18E:
	RTS
levelinit18F:
	RTS
levelinit190:
	RTS
levelinit191:
	RTS
levelinit192:
	RTS
levelinit193:
	RTS
levelinit194:
	RTS
levelinit195:
	RTS
levelinit196:
	RTS
levelinit197:
	RTS
levelinit198:
	RTS
levelinit199:
	RTS
levelinit19A:
	RTS
levelinit19B:
	RTS
levelinit19C:
	RTS
levelinit19D:
	RTS
levelinit19E:
	RTS
levelinit19F:
	RTS
levelinit1A0:
	RTS
levelinit1A1:
	RTS
levelinit1A2:
	RTS
levelinit1A3:
	RTS
levelinit1A4:
	RTS
levelinit1A5:
	RTS
levelinit1A6:
	RTS
levelinit1A7:
	RTS
levelinit1A8:
	RTS
levelinit1A9:
	RTS
levelinit1AA:
	RTS
levelinit1AB:
	RTS
levelinit1AC:
	RTS
levelinit1AD:
	RTS
levelinit1AE:
	RTS
levelinit1AF:
	RTS
levelinit1B0:
	RTS
levelinit1B1:
	RTS
levelinit1B2:
	RTS
levelinit1B3:
	RTS
levelinit1B4:
	RTS
levelinit1B5:
	RTS
levelinit1B6:
	RTS
levelinit1B7:
	RTS
levelinit1B8:
	RTS
levelinit1B9:
	RTS
levelinit1BA:
	RTS
levelinit1BB:
	RTS
levelinit1BC:
	RTS
levelinit1BD:
	RTS
levelinit1BE:
	RTS
levelinit1BF:
	RTS
levelinit1C0:
	RTS
levelinit1C1:
	RTS
levelinit1C2:
	RTS
levelinit1C3:
	RTS
levelinit1C4:
	RTS
levelinit1C5:
	RTS
levelinit1C6:
	RTS
levelinit1C7:
	RTS
levelinit1C8:
	RTS
levelinit1C9:
	RTS
levelinit1CA:
	RTS
levelinit1CB:
	RTS
levelinit1CC:
	RTS
levelinit1CD:
	RTS
levelinit1CE:
	RTS
levelinit1CF:
	RTS
levelinit1D0:
	RTS
levelinit1D1:
	RTS
levelinit1D2:
	RTS
levelinit1D3:
	RTS
levelinit1D4:
	RTS
levelinit1D5:
	RTS
levelinit1D6:
	RTS
levelinit1D7:
	RTS
levelinit1D8:
	RTS
levelinit1D9:
	RTS
levelinit1DA:
	RTS
levelinit1DB:
	RTS
levelinit1DC:
	RTS
levelinit1DD:
	RTS
levelinit1DE:
	RTS
levelinit1DF:
	RTS
levelinit1E0:
	RTS
levelinit1E1:
	RTS
levelinit1E2:
	RTS
levelinit1E3:
	RTS
levelinit1E4:
	RTS
levelinit1E5:
	RTS
levelinit1E6:
	RTS
levelinit1E7:
	RTS
levelinit1E8:
	RTS
levelinit1E9:
	RTS
levelinit1EA:
	RTS
levelinit1EB:
	RTS
levelinit1EC:
	RTS
levelinit1ED:
	RTS
levelinit1EE:
	RTS
levelinit1EF:
	RTS
levelinit1F0:
	RTS
levelinit1F1:
	RTS
levelinit1F2:
	RTS
levelinit1F3:
	RTS
levelinit1F4:
	RTS
levelinit1F5:
	RTS
levelinit1F6:
	RTS
levelinit1F7:
	RTS
levelinit1F8:
	RTS
levelinit1F9:
	RTS
levelinit1FA:
	RTS
levelinit1FB:
	RTS
levelinit1FC:
	RTS
levelinit1FD:
	RTS
levelinit1FE:
	RTS
levelinit1FF:
	RTS