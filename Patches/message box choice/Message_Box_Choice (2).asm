;======================================================================================================================
; Message Box choice selection patch by JackTheSpades (credit would be nice)
; http://www.smwcentral.net/?p=profile&id=7869
;
; This patch allows you to have cursor in the message box to select between multiple options.
; The message box opens and closes like usual and can be edited in Lunar Magic.
; Note: The selection only stores a value to a RAM address, if you actually want the selection
;       to do something, you'll have to code that yourself (meaning, ASM knowledge is required)
; The part where you want to edit the code is a bit below, shouldn't be hard to find.
; For further information, see the readme.
;
;======================================================================================================================

; > $0000-$00FF -> $3000-$30FF
; > $0100-$0FFF -> $6100-$6FFF 
; > $1000-$1FFF -> $7000-$7FFF
if read1($00FFD5) == $23
	sa1rom
	!Base1 = $3000
	!Base2 = $6000
	!BaseLong1 = $003000
	!BaseLong2 = $400000
else
	lorom
	!Base1 = $0000
	!Base2 = $0000
	!BaseLong1 = $7E0000
	!BaseLong2 = $7E0000
endif

;x=horizontal, start by 0
;y=vertical, start by 0
macro xy(x, y)
	;20 bytes per line (y), each line starts at +$07
	;first line is at $50C0
	dw <y>*$20+<x>+$50C7
endmacro

;format: 	1 byte level, 3 byte ram, 2 byte table address, 1 byte table size,
;				1 byte right/left, 3 byte end routine
;total size:
!msgsize = $0B
macro messages(table, level, msg, ram, rl, end)
	if <level> <= $24
		db <level>|((<msg><<6)&$80)
	else
		db (<level>-$DC)|((<msg><<6)&$80)
	endif
	dl <ram>
	dw <table>
	db (<table>_end-<table>_start)/$2
	db <rl>
	dl <end>
endmacro


org $00A1DF
	autoclean JSL Hijack
	
freecode

;======================================================================================================================
;#   You'd want to START editing stuff here
;======================================================================================================================

;T=0 -> tile 00-7F GFX28, tile 80-FF GFX29
;T=1 -> tile 00-7F GFX2A, tile 80-FF GFX2B
;cursor properties
;note, tile will always use layer 3 palette 6, no x/y flip
	!T 		= $1		;
	!Tile 	= $5A		; currently #-symbol in GFX2A

;all position tables need to have a .start first thing under them and a .end last.
;put however many positions in there as you want (no more than 127 or less than 1 but that shouldn't be a problem)
;use the macro %xy($x,$y) to define a cursor position.
sometablename:
	.start
		%xy($3,$3)
		%xy($3,$4)
		%xy($3,$5)
		%xy($3,$6)
	.end
	
;All messages have to be inbetween the label and the .end
;there has to be at least one message in there.

;format/how to use
;%messages(table, level, messagebox, ram, leftrigh, routine)
;table				-	the label to the positions table above
;level				-	the Lunar Magic level number you enter on the OW (not $13BF format)
;messagebox			-	which message box to use ($1 or $2)
;ram				-   where to store the cursor position (some empty RAM would be best)
;						has to be a long address (eg. $7E0079 instead of just $79)
;leftright			-	how much the cursor should jump if left/right is pressed
;routine			-	a routine to call when the message box has fully closed,
;						put ReturnLong there if you don't want it to do anything.
;						the routine has to end with RTL
MessageBoxData:
	;example: use sometablename defined above, for level 105, message box 1
	;store result to $79 (+SA1), don't use left/right buttons and don't do anything
	;when message box closes.
	;Also, take note that if you want to access I-RAM area, make sure to use
	;!BaseLong1 or if you want to access BW-RAM, use !BaseLong2
	;If ROM isn't SA-1, then it will default to the WRAM area ($7E-7F)
	;Just remember to ADD the RAM value, eg. !BaseLong2+$0660
	;$40:0660 or $6660. Bear that in mind!
	%messages(sometablename, $0105, $1, !BaseLong1+$79, $00, TEST)
.end

;Example: If cursor is 1, make Mario small, if 2, make Mario big, and so on...
TEST:
	LDA $79
	CMP #$01
	BEQ Small
	CMP #$02
	BEQ Big
	CMP #$03
	BEQ Cape

	LDA #$03
	STA $19
	RTL
Small:
	STZ $19
	RTL

Big:
	LDA #$01
	STA $19
	RTL

Cape:
	LDA #$02
	STA $19
	RTL

;======================================================================================================================
;#   You'd want to STOP editing stuff here
;======================================================================================================================



CheckClosed:		
	CMP #$01					; $1B88=1, $1B89=0 (1B89 can only be multiple of 4, so this is save)
	BNE Return
	INY						; indicator for later, Y=1 -> message box closed
	BRA Hijack_start		; jump back into the handling routine.
Return:
	;$90CF0E 
	SEP #$30
	PLB
	RTL
Hijack:
	JSL $05B10C				; original message box routine. (restore code)
	
	PHB : PHK : PLB		; setup bank for tables
	LDY #$00					; indicator for later, Y=0 -> message box open
	LDA $1B89+!Base2		; message box expansion timer
	ORA $1B88+!Base2		; message box expanding or shrinking
	;$90CF23
	CMP #$50					; message box has to be full size and expanding
	BNE CheckClosed		; if not return.
	
.start
	LDA $13BF+!Base2		; current level (for message box)
	STA $00
	REP #$10					; need for 16bit index because $60 levels with 2 message boxex = C0 possible entries
								; each entry has 8 byte
		
	;initiat X with size-$08
	;so it points to the last entry
	LDX #MessageBoxData_end-MessageBoxData-!msgsize
.loop
	LDA #$01
	STA $02					; use message box 1
	LDA MessageBoxData,x	; \
	BPL +						; | get level
	INC $02					; | if MSB is set, we want message box 2 (also clear MSB)
	AND #$7F					; /
+
	CMP $00					; compare with current level
	BEQ .cont				; if equal, continue
-
	REP #$20					; \
	TXA						; |
	SEC						; |
	SBC.w #!msgsize		; | subtract table entry size from x
	TAX						; | 
	SEP #$20					; | A has to be 16 bit too.
	BPL .loop				; /
	BRA Return
		
.cont
	LDA $1426+!Base2		; check if it's the right message box too
	CMP $02					;
	BNE -						; if not, back to the loop	
	
	;all conditions cleared. YAY	
	
	INX						;point at next element in table (positions table)
	TYA
	BEQ +						; if y is not 0, call routine at the end of message box.
	
	LDY MessageBoxData+$7,x		; \
	STY $00							; | get end routine address in $00-$02
	LDA MessageBoxData+$9,x		; |
	STA $02							; /
	
	SEP #$10
	PLB						; because we pushed it in the beginning.
	JMP [!Base1]			; jump to the end routine
+
	
	;now put the remaining 7 bytes in $00 onwards, so we can use x/y freely again
	LDY #$0000
-
	LDA MessageBoxData,x
	STA !Base1,y
	INX :	INY
	CPY #$0007				;table has !msgsize entries, but we only care about the remaining 7.
	BNE -
	
	LDX $03					; \
	DEX : DEX				; | table address -2
	STX $03					; /
	
	SEP #$10	
	
	;traget RAM in $00-$02
	;positions table-2 in $03-$04 (minus 2 because we skip 0 as possible index)
	;pos table size in $05
	;press right/left value in $06
	!lr = $06
	
	;A still holds $06
	;setup table in $06-$09 similiar to the "add" table below
	;db $00, rl, -rl, $00
	STA !lr+$1
	EOR #$FF
	INC
	STA !lr+$2
	STZ !lr
	STZ !lr+$3
	
	
	LDA [$00]			; target RAM address
	BNE +
	INC					; indicator that the message has been run.
	STA [$00]
+
	ASL
	TAY					; keep old ram*2 because table has word values
	
	LDA $16				; \
	AND #$03				; | get left/right add value
	TAX					; | use the table created before
	LDA !lr,x			; /
	STA !lr				; table is now unneeded and free again.
	
	LDA $16				; \ 
	LSR #2				; | get up/down add value
	AND #$03				; | from static table
	TAX					; |
	LDA add,x			; /
	CLC : ADC !lr		; add to left/right value
	
	BEQ .dma				; don't bother if nothing is added
	
	CLC : ADC [$00]	; otherwise, add to ram
		
	DEC					; ram currently in range from 1 to size, so we set it back to 0 to size-1
	
	BPL +					; \ if A is negative, add size ($05)
-	CLC : ADC $05		; | the following modula doesn't work correctly on negative numbers. 
+	BMI -					; / keep adding until we're positive	
	
.rangeloop				; \
	CMP $05				; | loop until ram is smaller than the size ($05)
	BCC .rangeset		; | basically we're doing modulo size	
	SBC $05				; | SEC unnecessary because BCC didn't branch.
	BRA .rangeloop		; /	
.rangeset
	INC					; and reset ram so it's again in range 1 to size
	STA [$00]
	LDA #$23				; \ SFX when moving.
	STA $1DFC+!Base2	; /
	
	;size is no longer needed, so put bank in $05
	;now $03-$05 has long address of positions table.
	PHB : PLA : STA $05	
	
	;we're gonna clear the old curso now by overwriting it with an empty tile
	REP #$20				; \
	LDA [$03],y			; | VRAM address
	STA $2116			; |
	SEP #$20				; /
	LDX #$80
	STX $2115			;VRAM address moce
	
	LDA #$39 
	STA $2118			;tile properties
	LDA #$1F
	STA $2118			;tile (empty/space)
		
.dma
	PHB : PLA : STA $05	;gotta do it again, in case it gets skipped.
	LDA [$00]			; \
	ASL					; | x times two because table has word values
	TAY					; /	
	REP #$20				; \
	LDA [$03],y			; | VRAM address
	STA $2116			; |
	SEP #$20				; /
	LDX #$80
	STX $2115			;VRAM address moce
	
	LDA #$38|!T			; \
	STA $2118			; / tile properties to VRAM
	LDA #!Tile			; \
	STA $2118			; / tile (arrow) to VRAM
	
.return2:
	SEP #$30
	PLB	
ReturnLong:
	RTL

;table of how much to add when pressing down/up
add:
	db $00,$01,$FF,$00







