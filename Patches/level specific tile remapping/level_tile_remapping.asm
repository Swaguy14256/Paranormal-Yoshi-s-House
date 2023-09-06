org $019DF3
autoclean JML SPRITEREMAP		; Jumps to the first sprite remap routine.
NOP #8					; Clears unused remaining bytes.

org $019F24
autoclean JML SPRITEREMAP2		; Jumps to the second sprite remap routine.
NOP #2					; Clears unused remaining bytes.

org $01C197
autoclean JML VINEHEADREMAP		; Jumps to the Vine head remap routine.
NOP #11					; Clears unused remaining bytes.

org $01F483
autoclean JML TONGUEREMAP		; Jumps to the tongue remap routine.
NOP #9					; Clears unused remaining bytes.

org $029B8B
autoclean JML VOLCANOLOTUSFIREREMAP	; Jumps to the Volcano Lotus Fire remap routine.
NOP #13					; Clears unused remaining bytes.

org $02CA62
autoclean JML CHARGINCHUCKBODYREMAP	; Jumps to the Chargin' Chuck body remap routine.
NOP #8					; Clears unused remaining bytes.

org $02E011
autoclean JML VOLCANOLOTUSBOTTOMREMAP	; Jumps to the Volcano Lotus body remap routine.
NOP					; Clears unused remaining bytes.

org $0388AF
autoclean JML SWOOPERREMAP		; Jumps to the Swooper remap routine.
NOP #2					; Clears unused remaining bytes.

org $0396C3
autoclean JML REXREMAP			; Jumps to the Rex remap routine.
NOP #2					; Clears unused remaining bytes.

freecode

SPRITEREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$0034				; | Branches if Mario is in level 34.
BEQ CHANGE				;/
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $9B83,x				;\
STA $0306,y				; | Loads and stores the original tilemap data.
LDA $9B83+1,x				; |
STA $0302,y				;/
JML $819DFF				; Jumps back to the original code.
CHANGE:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA.L NEWSPRITETILEMAP,x		;\
STA $0306,y				; | Loads and stores the new tilemap data.
LDA.L NEWSPRITETILEMAP+1,x		; |
STA $0302,y				;/
LDA.L NEWPROPERTIES,x			;\
STA $05					;/ Sets the new properties offset.
LDX $15E9				; Loads the sprite index.
LDA $01					;\
STA $0301,y				; |
CLC					; | Sets the Y position for the tiles.
ADC #$10				; |
STA $0305,y				;/
LDA $00					;\
STA $0300,y				; | Sets the X position for the tiles.
STA $0304,y				;/
LDA $157C,x				; Loads the sprite direction.
LSR					; Shifts the sprite direction bits right.
LDA #$00				;\
ORA $15F6,x				;/ Sets the initial properties.
BCS NOFLIP				; Branches if the sprite is facing left.
ORA #$40				; Flips the sprite.
NOFLIP:
ORA $05					;\
ORA $64					; | Sets the new properties.
STA $0303,y				; |
STA $0307,y				;/
JML $819DC6				; Jumps back to the original code.

SPRITEREMAP2:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$002F				; | Branches if Mario is in level 2F.
BEQ CHANGE2				;/
CMP #$0033				;\
BEQ CHANGE2				;/ Branches if Mario is in level 33.
CMP #$0034				;\
BEQ CHANGE3				;/ Branches if Mario is in level 34.
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $9B83,x				;\
STA $0302,y				;/ Loads and stores the original tilemap data.
JML $819F2A				; Jumps back to the original code.
CHANGE2:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA.L NEWSPRITETILEMAP2,x		;\
STA $0302,y				;/ Loads and stores the new tilemap data.
JMP CHANGEPROPERTIES			; Jumps back to the original code.
CHANGE3:
SEP #$20				; Turns on 8-bit adressing mode.
LDA.L NEWSPRITETILEMAP,x		;\
STA $0302,y				;/ Loads and stores the new tilemap data.
CHANGEPROPERTIES:
LDA.L NEWPROPERTIES,x			;\
STA $05					;/ Sets the new properties offset.
LDX $15E9				; Loads the sprite index.
LDA $00					;\
STA $0300,y				;/ Sets the X position for the tile.
LDA $01					;\
STA $0301,y				;/ Sets the Y position for the tile.
LDA $157C,x				; Loads the sprite direction.
LSR					; Shifts the sprite direction bits right.
LDA #$00				;\
ORA $15F6,x				;/ Sets the initial properties.
BCS NOFLIP2				; Branches if the sprite is facing left.
EOR #$40				; Flips the sprite.
NOFLIP2:
ORA $04					;\
ORA $05					; | Sets the new properties.
ORA $64					; |
STA $0303,y				;/
JML $819F4B				; Jumps back to the original code.

NEWSPRITETILEMAP:	db $82,$A0,$82,$A2,$84,$A4,$8C,$8A
			db $8E,$C8,$CA,$CA,$CE,$CC,$86,$4E
			db $E0,$E2,$E2,$CE,$E4,$E0,$E0,$A3
			db $A3,$B3,$B3,$E9,$E8,$F9,$F8,$E8
			db $E9,$F8,$F9,$E2,$E6,$AA,$A8,$A8
			db $AA,$A2,$A2,$B2,$B2,$C3,$C2,$D3
			db $D2,$C2,$C3,$D2,$D3,$E2,$E6,$CA
			db $CC,$CA,$08,$EE,$AE,$EE,$83,$83
			db $C4,$C4,$83,$83,$C5,$C5,$8A,$A6
			db $A4,$A6,$A8,$80,$82,$80,$84,$84
			db $84,$84,$94,$94,$94,$94,$A0,$B0
			db $A0,$D0,$82,$80,$82,$00,$00,$00
			db $86,$84,$88,$EC,$8C,$A0,$A2,$8E
			db $E6,$AE,$8E,$EC,$EE,$CE,$EE,$A8
			db $EE,$40,$40,$A0,$C0,$A0,$C0,$A4
			db $C4,$A4,$C4,$A0,$C0,$A0,$C0,$40
			db $07,$27,$4C,$29,$4E,$2B,$82,$A0
			db $84,$A4,$6B,$69,$88,$CE,$8E,$AE
			db $A2,$A2,$B2,$B2,$00,$40,$44,$42
			db $2C,$42,$28,$28,$28,$28,$4C,$4C
			db $4C,$4C,$83,$83,$6F,$6F,$AC,$BC
			db $AC,$A6,$8C,$AA,$86,$84,$DC,$EC
			db $DE,$EE,$06,$06,$16,$16,$07,$07
			db $17,$17,$16,$16,$06,$06,$17,$17
			db $07,$07,$84,$86,$00,$00,$00,$0E
			db $2A,$24,$02,$06,$0A,$20,$22,$28
			db $26,$2E,$40,$42,$0C,$04,$2B,$6A
			db $ED,$88,$8C,$A8,$8E,$AA,$AE,$8C
			db $88,$A8,$AE,$AC,$8C,$8E,$CE,$EE
			db $C4,$C6,$82,$84,$86,$8C,$CE,$CE
			db $88,$89,$CE,$CE,$89,$88,$F3,$CE
			db $F3,$CE,$A7,$A9

NEWPROPERTIES:		db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$01,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00,$00,$00,$00,$00
			db $00,$00,$00,$00

NEWSPRITETILEMAP2:	db $82,$A0,$82,$A2,$84,$A4,$8C,$8A
			db $8E,$C8,$CA,$CA,$CE,$CC,$86,$4E
			db $E0,$E2,$E2,$CE,$E4,$E0,$E0,$A3
			db $A3,$B3,$B3,$E9,$E8,$F9,$F8,$E8
			db $E9,$F8,$F9,$E2,$E6,$AA,$A8,$A8
			db $AA,$A2,$A2,$B2,$B2,$C3,$C2,$D3
			db $D2,$C2,$C3,$D2,$D3,$E2,$E6,$CA
			db $CC,$CA,$08,$CE,$AE,$CE,$83,$83
			db $C4,$C4,$83,$83,$C5,$C5,$8A,$A6
			db $A4,$A6,$A8,$80,$82,$80,$84,$84
			db $84,$84,$94,$94,$94,$94,$A0,$B0
			db $A0,$D0,$E0,$AC,$E0,$00,$00,$00
			db $86,$A0,$88,$EC,$8C,$A8,$AA,$8E
			db $AC,$AE,$8E,$EC,$EE,$CE,$EE,$A8
			db $EE,$40,$40,$A0,$C0,$A0,$C0,$A4
			db $C4,$A4,$C4,$A0,$C0,$A0,$C0,$40
			db $07,$27,$4C,$29,$4E,$2B,$82,$A0
			db $84,$A4,$67,$69,$88,$CE,$8E,$AE
			db $A2,$A2,$B2,$B2,$00,$40,$44,$42
			db $2C,$42,$28,$28,$28,$28,$4C,$4C
			db $4C,$4C,$83,$83,$6F,$6F,$AC,$BC
			db $AC,$A6,$8C,$AA,$86,$84,$DC,$EC
			db $DE,$EE,$06,$06,$16,$16,$07,$07
			db $17,$17,$16,$16,$06,$06,$17,$17
			db $07,$07,$84,$86,$00,$00,$00,$0E
			db $2A,$24,$02,$06,$0A,$20,$22,$28
			db $26,$2E,$40,$42,$0C,$04,$2B,$6A
			db $ED,$88,$8C,$A8,$8E,$AA,$AE,$8C
			db $88,$A8,$AE,$AC,$8C,$8E,$CE,$EE
			db $C4,$C6,$82,$84,$86,$8C,$CE,$CE
			db $88,$89,$CE,$CE,$89,$88,$F3,$CE
			db $F3,$CE,$AC,$AE

VINEHEADREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$002F				; | Branches if Mario is in level 2F.
BEQ CHANGEVINEHEAD			;/
CMP #$0034				;\
BEQ CHANGEVINEHEAD			;/ Branches if Mario is in level 34.
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $14					; Loads the animation frame counter.
LSR					;\
LSR					; | Reduces the animation speed.
LSR					; |
LSR					;/
LDA #$AC				; Loads the first tile.
BCC STOREVINEHEAD			; Branches if bit 3 of the animation frame counter is set.
LDA #$AE				; Loads the second tile.
STOREVINEHEAD:
STA $0302,y				; Stores the tile.
JML $81C1A6				; Jumps back to the original code.
CHANGEVINEHEAD:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $14					; Loads the animation frame counter.
LSR					;\
LSR					; | Reduces the animation speed.
LSR					; |
LSR					;/
LDA #$08				; Loads the first tile.
BCC STOREVINEHEADPROPERTIES		; Branches if bit 3 of the animation frame counter is set.
LDA #$AE				; Loads the second tile.
STOREVINEHEADPROPERTIES:
STA $0302,y				; Stores the tile.
LDA #$4B				; Loads the first property byte.
BCC STOREPROPERTIES			; Branches if bit 3 of the animation frame counter is set.
LDA #$4A				; Loads the second property byte.
STOREPROPERTIES:
ORA $64					;\
STA $0303,y				;/ Stores the properties.
JML $81C1A6				; Jumps back to the original code.

TONGUEREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$002C				; | Branches if Mario is in level 2C.
BEQ CHANGETONGUE			;/
CMP #$0044				;\
BEQ CHANGETONGUE			;/ Branches if Mario is in level 44.
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $06					;\
CMP #$01				;/ Checks if the tip of the tongue is to be drawn.
LDA #$76				; Loads the tongue body tile.
BCS STORETONGUE				; Branches if the tip of the tongue will be drawn.
LDA #$66				; Loads the tongue tip tile.
STORETONGUE:
STA $0202,y				; Stores the tiles.
JML $81F490				; Jumps back to the original code.
CHANGETONGUE:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $06					;\
CMP #$01				;/ Checks if the tip of the tongue is to be drawn.
LDA #$78				; Loads the tongue body tile.
BCS STORETONGUE				; Branches if the tip of the tongue will be drawn.
LDA #$68				; Loads the tongue tip tile.
BRA STORETONGUE				; Branches to the store tongue tile routine.

VOLCANOLOTUSFIREREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$002F				; | Branches if Mario is in level 2F.
BEQ CHANGEFIRE				;/
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $14					; Loads the animation frame counter.
LSR					; Reduces the animation speed.
EOR $15E9				; Inverts it with the current sprite index.
LSR					;\
LSR					;/ Reduces the animation speed some more.
LDA #$A6				; Loads the first tile.
BCC STOREFIRE				; Branches if bit 2 of the animation frame counter is set for the outer 2 fireballs, and if bit 2 of the animation frame counter is not set for the inner 2 fireballs.
LDA #$B6				; Loads the second tile.
STOREFIRE:
STA $0202,y				; Stores the tile.
JML $829B9C				; Jumps back to the original code.
CHANGEFIRE:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $14					; Loads the animation frame counter.
LSR					; Reduces the animation speed.
EOR $15E9				; Inverts it with the current sprite index.
LSR					;\
LSR					;/ Reduces the animation speed some more.
LDA #$F3				; Loads the first tile.
BCC STOREFIRE				; Branches if bit 2 of the animation frame counter is set for the outer 2 fireballs, and if bit 2 of the animation frame counter is not set for the inner 2 fireballs.
LDA #$F2				; Loads the second tile.
BRA STOREFIRE				; Branches to the store fire tile routine.

CHARGINCHUCKBODYREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$0034				; | Branches if Mario is in level 34.
BEQ CHANGECHUCKBODY			;/
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $C98B,x				;\
STA $0302,y				; | Loads and stores the original tilemap data.
LDA $C9A5,x				; |
STA $0306,y				;/
JML $82CA6E				; Jumps back to the original code.
CHANGECHUCKBODY:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA.L NEWCHUCKBODY1,x			;\
STA $0302,y				; | Loads and stores the new tilemap data.
LDA.L NEWCHUCKBODY2,x			; |
STA $0306,y				;/
JML $82CA6E				; Jumps back to the original code.

NEWCHUCKBODY1:	db $0D,$34,$35,$26,$2D,$28,$40,$42
		db $5D,$2D,$E4,$E4,$E4,$E4,$E7,$28
		db $82,$AD,$23,$20,$0D,$0C,$5D,$BD
		db $BD,$5D

NEWCHUCKBODY2:	db $4E,$0C,$22,$26,$2D,$29,$40,$42
		db $AE,$2D,$E4,$E4,$E4,$E4,$E8,$29
		db $83,$AE,$24,$21,$4E,$A0,$A0,$A2
		db $A4,$AE

VOLCANOLOTUSBOTTOMREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$002F				; | Branches if Mario is in level 2F.
BEQ CHANGEBOTTOM			;/
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA #$CE				;\
STA $0302,y				;/ Sets the tile to draw.
JML $82E016				; Jumps back to the original code.
CHANGEBOTTOM:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA #$EE				;\
STA $0302,y				;/ Sets the tile to draw.
JML $82E016				; Jumps back to the original code.

SWOOPERREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$0034				; | Branches if Mario is in level 34.
BEQ CHANGESWOOPER			;/
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $88A0,x				;\
STA $0302,y				;/ Loads and stores the original tilemap data.
JML $8388B5				; Jumps back to the original code.
CHANGESWOOPER:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA.L NEWSWOOPERTILEMAP,x		;\
STA $0302,y				;/ Loads and stores the new tilemap data.
JML $8388B5				; Jumps back to the original code.

NEWSWOOPERTILEMAP:	db $E2,$E0,$E8

REXREMAP:
REP #$20				; Turns on 16-bit addressing for the Accumulator.
LDA $010B				;\
CMP #$0033				; | Branches if Mario is in level 33.
BEQ CHANGEREX				;/
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA $9670,x				;\
STA $0302,y				;/ Loads and stores the original tilemap data.
JML $8396C9				; Jumps back to the original code.
CHANGEREX:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
LDA.L NEWREXTILEMAP,x			;\
STA $0302,y				;/ Loads and stores the new tilemap data.
JML $8396C9				; Jumps back to the original code.

NEWREXTILEMAP:	db $8A,$EC,$8A,$8E,$8A,$EC,$8C,$8C
		db $EE,$EE,$A2,$B2