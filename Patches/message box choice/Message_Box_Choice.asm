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
	!BaseLong3 = $000000	; The base address in SA-1 ROMS.
else
	lorom
	!Base1 = $0000
	!Base2 = $0000
	!BaseLong1 = $7E0000
	!BaseLong2 = $7E0000
	!BaseLong3 = $800000	; The base address in LoROM ROMS.
endif

;x=horizontal, start by 0
;y=vertical, start by 0
macro xy(x, y)
	;20 bytes per line (y), each line starts at +$07
	;first line is at $50C0
;	dw <y>*$20+<x>+$50C7
	dw <y>*$20+<x>+$50E7
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
	!Tile 	= $2E		; currently #-symbol in GFX2A

;all position tables need to have a .start first thing under them and a .end last.
;put however many positions in there as you want (no more than 127 or less than 1 but that shouldn't be a problem)
;use the macro %xy($x,$y) to define a cursor position.
PAGE1:
	.start
		%xy($0,$2)
		%xy($0,$4)
	.end
PAGE2:
	.start
		%xy($0,$2)
		%xy($0,$5)
	.end
PAGE3:
	.start
		%xy($0,$2)
		%xy($0,$2)
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
	%messages(PAGE1, $0111, $2, !BaseLong1+$87, $00, PLAYMUSIC1)
	%messages(PAGE2, $0112, $1, !BaseLong1+$87, $00, PLAYMUSIC2)
	%messages(PAGE2, $0112, $2, !BaseLong1+$87, $00, PLAYMUSIC3)
	%messages(PAGE3, $0113, $1, !BaseLong1+$87, $00, PLAYMUSIC4)
	%messages(PAGE1, $0113, $2, !BaseLong1+$87, $00, PLAYMUSIC5)
	%messages(PAGE3, $0115, $1, !BaseLong1+$87, $00, PLAYMUSIC6)
	%messages(PAGE3, $0115, $2, !BaseLong1+$87, $00, PLAYMUSIC7)
	%messages(PAGE2, $0116, $1, !BaseLong1+$87, $00, PLAYMUSIC8)
	%messages(PAGE2, $0116, $2, !BaseLong1+$87, $00, PLAYMUSIC9)
	%messages(PAGE2, $0119, $1, !BaseLong1+$87, $00, PLAYMUSIC10)
	%messages(PAGE2, $011B, $2, !BaseLong1+$87, $00, PLAYMUSIC11)
	%messages(PAGE2, $0120, $2, !BaseLong1+$87, $00, PLAYMUSIC12)
.end

;Example: If cursor is 1, make Mario small, if 2, make Mario big, and so on...
PLAYMUSIC1:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE MUSIC		;/
	LDA $7FB000		;\
	CMP #$0A		; | Branches if the music to play is a global track.
	BCC GLOBALMUTE		;/
	LDA #$00		;\
	STA $7FB000		;/ Sets the music to play.
GLOBALMUTE:
	LDA #$0A		;\
	STA $1DFA		;/ Mutes the music.
	RTL			; Ends the code.
MUSIC:
	LDA #$1E		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC2:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION	;/
	LDA #$15		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION:
	LDA #$13		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC3:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION2	;/
	LDA #$18		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION2:
	LDA #$0B		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC4:
	LDA #$29		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC5:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION3	;/
	LDA #$01		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION3:
	LDA #$02		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC6:
	LDA #$06		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC7:
	LDA #$2A		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC8:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION4	;/
	LDA #$2C		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION4:
	LDA #$2D		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC9:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION5	;/
	LDA #$12		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION5:
	LDA #$2B		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC10:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION6	;/
	LDA #$2E		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION6:
	LDA #$2F		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC11:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION7	;/
	LDA #$03		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION7:
	LDA #$26		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
PLAYMUSIC12:
	LDA $87			;\
	CMP #$01		; | Branches if the cursor is not at option 1.
	BNE BOTTOMSELECTION8	;/
	LDA #$27		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
BOTTOMSELECTION8:
	LDA #$28		; Loads the music to play.
	JSL SETMUSIC		; Jumps to the set music routine.
	RTL			; Ends the code.
SPEEDUPTOGGLE:
	LDA #$0B		;\
	STA $1DFA		;/ Toggles the music speed up.
	RTL			; Ends the code.
SETMUSIC:
	STA $1DFB		; Sets the music to play.
	CMP #$0A		;\
	BCC GLOBALMUSIC		;/ Branches if a global music track is playing
	LDA #$00		;\
	STA $7FB000		;/ Sets the current track to 0.
GLOBALMUSIC:
	RTL			; Ends the code.
;======================================================================================================================
;#   You'd want to STOP editing stuff here
;======================================================================================================================



CheckClosed:		
	;CMP #$01					; $1B88=1, $1B89=0 (1B89 can only be multiple of 4, so this is save)
	CMP #$00		;\
	BNE Return		;/ Branches if the message box is not closed.
	INY						; indicator for later, Y=1 -> message box closed
	BRA Hijack_start		; jump back into the handling routine.
Return:
	;$90CF0E 
	SEP #$30
	PLB
	RTL
Hijack:
	JSL $05B10C|!BaseLong3				; original message box routine. (restore code)	
	PHB : PHK : PLB		; setup bank for tables
	LDY #$00					; indicator for later, Y=0 -> message box open
	;LDA $1B89+!Base2		; message box expansion timer
	;ORA $1B88+!Base2		; message box expanding or shrinking
	;$90CF23
	;CMP #$50					; message box has to be full size and expanding
	LDA $1B88+!Base2	;\
	CMP #$06		;/ Checks if the message box is waiting for player input.
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

	LDA $16			;\
	AND #$40		; | Branches if the Y or X buttons are not pressed.
	BEQ .KEEPTEMPO		;/
	JSL SPEEDUPTOGGLE	; Jumps to the speed up music routine.
.KEEPTEMPO
	LDA $18			;\
	AND #$40		; | Branches if the X button is not pressed.
	BEQ .KEEPTEMPO2		;/
	JSL SPEEDUPTOGGLE	; Jumps to the speed up music routine.
.KEEPTEMPO2
	LDA $18			;\
	AND #$30		; | Branches if the L and R buttons are not pressed.
	CMP #$30		; |
	BEQ .HANDLECHOICE	;/
	LDA $18			;\
	AND #$10		; | Branches if the R button is not pressed.
	BEQ .SAMEPAGE		;/
	LDA $06FD		;\
	CMP #$0B		; | Branches if the page number is 12.
	BEQ .PAGE12		;/
	INC $06FD		; Increases the page number.
	JSL .UPDATEPAGE		; Jumps to the update page routine.
	BRA .SAMEPAGE		; Branches to the same page sublabel.
.PAGE12
	STZ $06FD		; Sets the page number to 1.
	JSL .UPDATEPAGE		; Jumps to the update page routine.
.SAMEPAGE
	LDA $18			;\
	AND #$20		; | Branches if the L button is not pressed.
	BEQ .HANDLECHOICE	;/
	LDA $06FD		;\
	BEQ .PAGE1		;/ Branches if the page number is 1.
	DEC $06FD		; Decreases the page number.
	JSL .UPDATEPAGE		; Jumps to the update page routine.
	BRA .HANDLECHOICE	; Branches to the handle choice sublabel.
.PAGE1
	LDA #$0B		;\
	STA $06FD		;/ Sets the page number to 12.
	JSL .UPDATEPAGE		; Jumps to the update page routine.
.HANDLECHOICE
	LDA $16
	AND #$80
	BEQ ++
	LDA #$01
	STA $79
++
	LDA $18
	AND #$80
	BEQ +++
	LDA #$01
	STA $79
+++
	INX						;point at next element in table (positions table)
	LDA $79
	BEQ .noplay
	LDY MessageBoxData+$7,x		; \
	STY $00							; | get end routine address in $00-$02
	LDA MessageBoxData+$9,x		; |
	STA $02							; /
	STZ $79
	
	SEP #$10
	PLB					; because we pushed it in the beginning.
	JMP [!Base1]			; jump to the end routine
.noplay
	TYA
	BEQ +						; if y is not 0, call routine at the end of message box.

	SEP #$10
	PLB					; because we pushed it in the beginning.
	RTL

.LEVELNUMBER db $35,$36,$36,$37,$37,$39,$39,$3A,$3A,$3D,$3F,$44

.PAGEMESSAGE db $02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$02

.UPDATEPAGE
	PHX			;\
	PHY			;/ Preserves the X and Y Registers.
	SEP #$10		;  Turns on 8-bit addressing for the X and Y Registers.
	LDX $06FD		;\
	LDA .LEVELNUMBER,x	; | Sets the translevel number for the page.
	STA $13BF		; |
	STA $06FF		;/
	LDA .PAGEMESSAGE,x	;\
	STA $1426		; | Sets the message number for the page.
	STA $0700		;/
	LDA #$23		;\
	STA $1DFC+!Base2	;/ Sets the sound to play.
	LDA #$04		;\
	STA $1B88		;/ Sets the message box state to generate message.
	JSL $85B10C		; Jumps to the message box routine.
	REP #$10		; Turns on 16-bit addressing for the X and Y Registers.
	PLX			;\
	PLY			;/ Pulls back the X and Y Registers.
	RTL			; Ends the code.

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
	
	REP #$20
	LDA #$391F
	STA $2118			;tile (empty/space)
	SEP #$20	
	LDA #$39 
	STA $2119			;tile properties
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
	
	REP #$20
;	LDA #$392E			; \
	LDA #$292E			; \
	STA $2118			; / tile (arrow) to VRAM
	SEP #$20			; Turns on 8-bit addressing for the Accumulator.
;	LDA #$38|!T			; \
	LDA #$28|!T			; \
	STA $2119			; / tile properties to VRAM
.return2:
	SEP #$30
	PLB	
ReturnLong:
	RTL

;table of how much to add when pressing down/up
add:
	db $00,$01,$FF,$00