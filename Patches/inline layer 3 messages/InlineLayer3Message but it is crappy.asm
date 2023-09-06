lorom

if read1($00FFD5) == $23
	; SA-1 base addresses
	sa1rom
	!sa1 = 1
	!dp = $3000
	!addr = $6000
	!BaseLong1 = $003000
	!BaseLong2 = $400000
	!bank = $000000
else
	; Non SA-1 base addresses
	!sa1 = 0
	!dp = $0000
	!addr = $0000
	!BaseLong1 = $7E0000
	!BaseLong2 = $7E0000
	!bank = $800000
endif

; RAM defines

; These are just vanilla defines but if you know what you're doing, you can change them as well.
!MessageNumber	= $1426|!addr	; The message number
!MessageState	= $1B88|!addr	; Which state the game is currently in.
!MessageTimer	= $1B89|!addr	; Same as in the vanilla game: Controls the box's size and when to change the state but also which side to write

; These can stay in WRAM because code is handled by SNES
!MessageBuff = $7FC700			; 18 * 8 = 144 bytes

; Other defines

!TextProp = $39					; The text's properties.
!EmptyTile = $1F				; The tile to draw for the border and reminder of the text.
!EnableSwitchPalace = 1			; If set to 1: Display dotted and exclamation mark blocks on switch palace messages.
!HijackNmi = 1					; If set to 1: Handle NMI code with this patch (requires UberASM if disabled).
!AutomaticIntro = 0				; If set to 1: Don't wait for player input in the intro.

; Don't edit them unless necessary

YoshisHouseLevel = $03BB9B|!bank
YellowSwitchPalace = $03BBA2|!bank
BlueSwitchPalace = $03BBA7|!bank
RedSwitchPalace = $03BBAC|!bank
GreenSwitchPalace = $03BBB1|!bank
MessageIndex = $03BE80|!bank
MessageTable = $03BC0B|!bank

ExclamationMarkTiles = $05B29B|!bank
ExclamationMarkOffsets = $05B2DB|!bank

!Layer3Tilemap = $5000

!WindowingChannel = read1($05B295)	; Starting from v1.35, SA-1 Pack moving Windowing to HDMA channel 1 instead of 7.

assert read4($05B1A3) == $83BB9022, "Please edit the messages at least once before you apply this patch."

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

;org $00A1DF
;JSL $05B10C

org $05B10C
autoclean JML NewMessageSystem

; Make the table relative offsets only
org ExclamationMarkOffsets
db $00,$00,$08,$00,$00,$08,$08,$08
db $40,$00,$48,$00,$40,$08,$48,$08

freecode

NewMessageSystem:
	PHB
	PHK
	PLB
	LDX !MessageState
	TXA
	JSR (MessageBoxActions,x)
	PLB
RTL

MessageBoxActions:
dw .Grow
dw .WaitForNMI
dw .GenerateMessage
dw .WaitForPlayer
dw .WaitForNMI
dw .Shrink

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.Grow:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Disable every layer and colour maths in the window.
	LDA #$22
	STA $41
	STA $42
	STA $44
	LDX $13D2|!addr
	BEQ +
	LDA #$20			; Don't mask out sprites if a switch message.
+	STA $43
	
	JSR GenerateWindow
	LDA !MessageTimer
	CMP #$50
	BEQ ..NextState
	CLC : ADC #$04
	STA !MessageTimer
RTS

..NextState:
	LDA !MessageState
	INC #2
	STA !MessageState
	STZ !MessageTimer
RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.GenerateMessage:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDA #$00
	XBA
	LDX $1426|!addr
	CPX #$03
	BEQ ..YoshiMessage
	LDA $13BF|!addr
	CMP YoshisHouseLevel
	BEQ ..YoshisHouse
	CPX #$02
BRA ..NormalMessage

..YoshiMessage:
	LDA #$00			; Level 0
	SEC					; Message 2
	BRA ..NormalMessage

..YoshisHouse:
	CLC					; Message 1
	LDY $187A|!addr		;
	BEQ ..NormalMessage	; If on Yoshi...
	SEC					; Message 2
..NormalMessage:
	; In the end:
	; A: Translevel number
	; C: CLC for message 1, SEC for message 2
	REP #$30
	ROL
	ASL
	TAX
	PEA.w (!MessageBuff>>16)|(NewMessageSystem>>16<<8)
	PLB
	LDA.l !MessageTimer
	AND #$0001
	BNE ..Shared
	LDY #$0000
	LDA MessageTable+1
	STA $01				; Fixed bank.
	LDA MessageIndex,x
	CLC : ADC MessageTable
	STA $00
	SEP #$20
-	LDA [$00],y
	CMP #$FE			; If tile is $FE: Reached the end of message
	BEQ ..Empty
	STA.w !MessageBuff,y
	INY
	CPY #$0090
	BNE -
	BRA ..Shared

..Empty:
	LDA #!EmptyTile
-	STA.w !MessageBuff,y
	INY
	CPY #$0090
	BNE -
	
..Shared:
	REP #$30
	
	; Get VRAM Address
	LDY #$0000
	LDA $22
	CLC : ADC #$0034	; 6 tiles to the right
	BIT #$0100			; Is on right half?
	BEQ +
	INY
+	LSR #3
	AND #$001F
	STA $00
	LDA $24
	CLC : ADC #$0034	; 5 tiles to the bottom
	BIT #$0100			; Is on bottom half?
	BEQ +
	INY #2
+	ASL #2
	AND #$03E0
	ORA $00
	STA $00
	TYA
	XBA
	ASL #2				; Y << 10
	ORA $00
	ORA #$5000
	STA $00

	; Get left side's width.
	AND #$001F
	EOR #$001F
	INC
	CMP #$0014
	BCC ..Split
	LDA #$0014			; Maximally 0x14
..Split:
	STA $02

	; Write the message
	LDA $7F837B
	TAX

	LDA.l !MessageTimer
	AND #$0001
	STA $06
	BNE ..RightSide
	LDA.w #!MessageBuff
	STA $04
	JSR PlaceTiles
	LDA #$FFFF
	STA $7F837D,x
	TXA
	STA $7F837B
	PLB
	SEP #$30
	INC !MessageTimer
RTS

; The process goes the following:
; - Set the X position to the left side of the other half.
; - Increment the text buffer by the current box with - 1 (because of the border)
; - Decrement the full width by the current width
..RightSide:
	LDA.w #!MessageBuff
	CLC : ADC $02
	DEC
	STA $04
	LDA #$0014
	SEC : SBC $02
	BEQ ..SingleSide
	STA $02
	LDA $00
	AND #~$001F
	EOR #$0400
	STA $00

	JSR PlaceTiles
	LDA #$FFFF
	STA $7F837D,x
	TXA
	STA $7F837B
..SingleSide:
	PLB

; Initialise next state
	SEP #$30
	INC !MessageState
	INC !MessageState
	STZ !MessageTimer
	LDA #$20			; Display layer 3
	STA $42				;
	LDY #$82			; Disables mainscreen inside the mask...
	LDA $0D9D|!addr		; ... but only if layer 3 is on subscreen
	AND #$04			;
	BEQ +				;
	LDY #$22			; Disable subscreen instead. 
+	STY $44				; Handles both colour maths and subscreen layer 3.
if !EnableSwitchPalace
	LDX #$00			;
	LDA $13BF|!addr		; Check for switch palace levels.
	CMP YellowSwitchPalace
	BEQ ..SwitchMessage
	INX
	CMP BlueSwitchPalace
	BEQ ..SwitchMessage
	INX
	CMP RedSwitchPalace
	BEQ ..SwitchMessage
	INX
	CMP GreenSwitchPalace
	BNE .WaitForNMI
..SwitchMessage
	INX
	STX $13D2|!addr		; Mark message as Switch Palace message
	LDA #$20			; Don't mask out sprites.
	STA $43
	JMP DrawExclamationBlocks
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.WaitForNMI:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.WaitForPlayer:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDA $0DC5
	BEQ ..nochoice
	JSL CHOICE
..nochoice
	LDA $0109|!addr
	ORA $13D2|!addr
	BEQ ..NotSpecial	
	LDA $1DF5|!addr
	BEQ ..NotSpecial
	LDA $13
	AND #$03
	BNE ..Return
	DEC $1DF5|!addr
	BNE ..Return
	LDA $13D2|!addr
	BEQ ..NotSpecial
	INC $1DE9|!addr
	LDA #$01
	STA $13CE|!addr

..ToOverworld:
	STA $0DD5|!addr
	LDA #$0B
	STA $0100|!addr
RTS
	
..NotSpecial:
if !AutomaticIntro
	LDA $0109|!addr
	BNE ..IntroMessage
	LDA $18
	AND #$C0
	ORA $16
	AND #$F0
	BEQ ..Return
	BRA ..CloseMessage

..IntroMessage
else
	LDA $0DC5
	BNE ..newcontrols
	LDA $18
	AND #$C0
	ORA $16
	AND #$F0
	BEQ ..Return
..resume
	LDA $0109|!addr
	BEQ ..CloseMessage
endif
	LDA #$8E
	STA $1F19|!addr
	LDA #$00
	STA $0109|!addr
BRA ..ToOverworld

..CloseMessage
	LDA #$22			; Disable layer 3 and subscreen again
	STA $42
	STA $44
	LDA !MessageState
	INC #2
	STA !MessageState
..Return:
RTS

..newcontrols
	LDA $16
	AND #$30
	BEQ ..Return
	BRA ..resume

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.Shrink:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDA !MessageTimer
	SEC : SBC #$04
	STA !MessageTimer
	BNE GenerateWindow
	STZ !MessageNumber	;
	STZ !MessageState
	LDA.b #!WindowingChannel
	TRB $0D9F|!addr
	STZ $0DC5
RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GenerateWindow:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDA $22
	AND #$07
	CMP #$04
	BCS +
	ORA #$08
+	EOR #$FF
	INC
	CLC : ADC #$88		; 0x80 + 8
	STA $00
	REP #$20
	LDA $24				; Get offset
	AND #$0007
	CMP #$0004
	BCS +
	ORA #$0008
+	EOR #$FFFF
	INC
	CLC : ADC #$005F	; 0x58 + 8 - 1

	ASL					; Windowing table is made of words.
	TAX					; Top half, goes from bottom to top.
	DEX					; Fix offset
	DEX
	CLC : ADC #$04A0|!addr
	STA $01				; Indirect because Y is also the loop count.

	SEP #$20
	LDA $00				; Get edges
	DEC
	CLC : ADC !MessageTimer
	XBA
	LDA $00
	SEC : SBC !MessageTimer
	REP #$20

	LDY #$00
.Loop:
	CPY $1B89|!addr		;
	BCC .NoWindow		; If outside the box...
	LDA #$00FF			; Disable window.
.NoWindow:
	STA $04A0|!addr,x
	STA ($01),y
	DEX
	DEX
	INY
	INY
	CPY #$50
	BNE .Loop
	SEP #$20

	LDA.b #!WindowingChannel
	TSB $0D9F|!addr
RTS

if !EnableSwitchPalace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawExclamationBlocks:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Places the exclamation mark blocks on the message.
	WDM
	TXA
	ASL #4
	TAX
	STZ $00
	LDA $22
	AND #$07
	CMP #$04
	BCS +
	ORA #$08
+	EOR #$FF
	INC
	CLC : ADC #$59		; 0x80 + 8 + 1
	STA $01
	LDA $24				; Get offset
	AND #$07
	CMP #$04
	BCS +
	ORA #$08
+	EOR #$FF
	INC
	CLC : ADC #$5F	; 0x58 + 8 - 1
	STA $02
	REP #$20
	LDY #$1C
.Loop
	LDA.l ExclamationMarkTiles-16,x
	STA $0202|!addr,y
	PHX
	LDX $00
	LDA.l ExclamationMarkOffsets,x
	CLC : ADC $01
	STA $0200|!addr,y
	PLX
	INX #2
	INC $00
	INC $00
	DEY #4
	BPL .Loop
	STZ $0400|!addr
	SEP #$20
RTS
endif

; Input:
; $00: Leftmost VRAM address
; $02: Total columns to place
; $04: Message pointer (high byte in DB)
; $06: Which side to place.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PlaceTiles:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDA #$0009			; 10 rows
	STA $0A
	LDA $00
	STA $08
.Loop:
	LDA $08
	PHA
	PHA
	XBA
	STA $7F837D,x
	LDA $02				; Columns in total to place
	STA $0C
	ASL
	DEC
	XBA
	STA $7F837F,x
	INX #4
	
	; Check if it's the top or bottom most row.
	LDA $0A
	BEQ .EmptyTiles
	CMP #$0009
	BNE .PlaceText
.EmptyTiles:
	LDA.w #!TextProp<<8|!EmptyTile
	STA $7F837D,x
	INX #2
	DEC $0C
	BNE .EmptyTiles

; Increment the VRAM address
; Keep in mind to switch the tilemap. As such, increment the Y-position individually
; before you ORA it with the rest of the VRAM address without the Y position.
.Shared:
	PLA
	AND #$0BE0			; Get Y position only
	ORA #$0400			; Carry over on overflow.
	CLC : ADC #$0020
	AND #$0BE0
	STA $08
	PLA
	AND #~$0BE0
	ORA $08
	STA $08
	DEC $0A
	BPL .Loop
RTS

; This is complex:
; I have no trouble to place the text but it makes a difference to also consider the border.
; The solution: If it's the left half, place the border, decrement the column counter
; and then place the text.
; If it's the right half, place the text at first and then overwrite the column with the border tile.
; Do the same with the left half if the full box is drawn
.PlaceText:
	LDY #$0000			; Set the message pointer to 0.
	LDA $06
	BNE ..PlaceTextLoop
	LDA.w #!TextProp<<8|!EmptyTile
	STA $7F837D,x
	INX #2
	DEC $0C
	BEQ ..PlaceTextFinish
	
..PlaceTextLoop:
	LDA ($04),y			; Get text
	AND #$00FF			; (8-bit values only)
	ORA.w #!TextProp<<8	; Add in the properties.
	STA $7F837D,x
	INX #2
	INY
	DEC $0C
	BNE ..PlaceTextLoop
	
..PlaceTextFinish:
	LDA $06				; If it's the right side, always place a border tile
	BNE ..RightSide		;
	LDA $02				; Otherwise only if the full box is drawn.
	CMP #$0014
	BNE ..NotFullBox
..RightSide:
	LDA.w #!TextProp<<8|!EmptyTile
	STA $7F837B,x
..NotFullBox:
	LDA $04				; Load the next row of text.
	CLC : ADC #$0012
	STA $04
JMP .Shared

if !HijackNmi

namespace "InlineMessageNmi"

pushpc

org $00820D
JML HijackNmi

pullpc

HijackNmi:
	JSL nmi
	LDA $143A|!addr
	BEQ +
JML $008212|!bank
+
JML $008217|!bank

incsrc InlineMessageNmi.asm

namespace off

else
	if read3($00820D) != $143AAD
	print " Revert NMI hijack."
	org $00820D
		LDA $143A|!addr
		BEQ $05
	endif
endif

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
		%xy($0,$3)
	.end

PAGE2:
	.start
		%xy($0,$3)
		%xy($0,$6)
	.end
PAGE3:
	.start
		%xy($0,$3)
		%xy($0,$5)
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
	%messages(PAGE3, $0111, $2, !BaseLong1+$87, $00, PLAYMUSIC1)
	%messages(PAGE2, $0112, $1, !BaseLong1+$87, $00, PLAYMUSIC2)
	%messages(PAGE2, $0112, $2, !BaseLong1+$87, $00, PLAYMUSIC3)
	%messages(PAGE1, $0113, $1, !BaseLong1+$87, $00, PLAYMUSIC4)
	%messages(PAGE3, $0113, $2, !BaseLong1+$87, $00, PLAYMUSIC5)
	%messages(PAGE1, $0115, $1, !BaseLong1+$87, $00, PLAYMUSIC6)
	%messages(PAGE1, $0115, $2, !BaseLong1+$87, $00, PLAYMUSIC7)
	%messages(PAGE2, $0116, $1, !BaseLong1+$87, $00, PLAYMUSIC8)
	%messages(PAGE2, $0116, $2, !BaseLong1+$87, $00, PLAYMUSIC9)
	%messages(PAGE2, $0119, $1, !BaseLong1+$87, $00, PLAYMUSIC10)
	%messages(PAGE2, $011B, $2, !BaseLong1+$87, $00, PLAYMUSIC11)
	%messages(PAGE2, $0120, $2, !BaseLong1+$87, $00, PLAYMUSIC12)
.end

;Example: If cursor is 1, make Mario small, if 2, make Mario big, and so on...
PLAYMUSIC1:
	LDA $87
	CMP #$01
	BNE MUSIC
	LDA #$00
	STA $1DFB
	RTL
MUSIC:
	LDA #$1E
	STA $1DFB
	RTL
PLAYMUSIC2:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION
	LDA #$15
	STA $1DFB
	RTL
BOTTOMSELECTION:
	LDA #$13
	STA $1DFB
	RTL
PLAYMUSIC3:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION2
	LDA #$18
	STA $1DFB
	RTL
BOTTOMSELECTION2:
	LDA #$0B
	STA $1DFB
	RTL
PLAYMUSIC4:
	LDA #$29
	STA $1DFB
	RTL
PLAYMUSIC5:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION3
	LDA #$01
	STA $1DFB
	RTL
BOTTOMSELECTION3:
	LDA #$02
	STA $1DFB
	RTL
PLAYMUSIC6:
	LDA #$06
	STA $1DFB
	RTL
PLAYMUSIC7:
	LDA #$2A
	STA $1DFB
	RTL
PLAYMUSIC8:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION4
	LDA #$2C
	STA $1DFB
	RTL
BOTTOMSELECTION4:
	LDA #$2D
	STA $1DFB
	RTL
PLAYMUSIC9:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION5
	LDA #$12
	STA $1DFB
	RTL
BOTTOMSELECTION5:
	LDA #$2B
	STA $1DFB
	RTL
PLAYMUSIC10:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION6
	LDA #$2E
	STA $1DFB
	RTL
BOTTOMSELECTION6:
	LDA #$2F
	STA $1DFB
	RTL
PLAYMUSIC11:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION7
	LDA #$03
	STA $1DFB
	RTL
BOTTOMSELECTION7:
	LDA #$26
	STA $1DFB
	RTL
PLAYMUSIC12:
	LDA $87
	CMP #$01
	BNE BOTTOMSELECTION8
	LDA #$27
	STA $1DFB
	RTL
BOTTOMSELECTION8:
	LDA #$28
	STA $1DFB
	RTL
SPEEDUPMUSIC:
	LDA #$09
	STA $1DFA
	RTL
;======================================================================================================================
;#   You'd want to STOP editing stuff here
;======================================================================================================================

Return:
	;$90CF0E 
	SEP #$30
	RTL

CHOICE:
	PHB : PHK : PLB		; setup bank for tables
	LDA $13BF		; current level (for message box)
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
	LDA $1426		; check if it's the right message box too
	CMP $02					;
	BNE -						; if not, back to the loop	
	;all conditions cleared. YAY

	LDA $16
	AND #$40
	BEQ .keeptempo
	JSL SPEEDUPMUSIC
.keeptempo
	LDA $18
	AND #$40
	BEQ .keeptempo2
	JSL SPEEDUPMUSIC
.keeptempo2
	LDA $18
	AND #$30
	CMP #$30
	BEQ .samepage2
	LDA $18
	AND #$10
	BEQ .samepage
	LDA $06FD
	CMP #$0B
	BEQ .page1
	INC $06FD
	JSL .updatepage
	BRA .samepage
.page1
	STZ $06FD
	JSL .updatepage
.samepage
	LDA $18
	AND #$20
	BEQ .samepage2
	LDA $06FD
	BEQ .page13
	DEC $06FD
	JSL .updatepage
	BRA .samepage2
.page13
	LDA #$0B
	STA $06FD
	JSL .updatepage
.samepage2
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
	JMP [!dp]			; jump to the end routine
.noplay
	TYA
	BEQ +						; if y is not 0, call routine at the end of message box.

	SEP #$10
	PLB					; because we pushed it in the beginning.
	RTL

.levelnum db $35,$36,$36,$37,$37,$39,$39,$3A,$3A,$3D,$3F,$44

.pagemessage db $02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$02

.updatepage
	PHX
	PHY

	SEP #$10
	LDX $06FD
	LDA .levelnum,x
	STA $13BF
	STA $06FF
	LDA .pagemessage,x
	STA $1426
	STA $0700
	LDA #$23				; \ SFX when moving.
	STA $1DFC	; /
;	JSL $83BB90
	LDA #$04
	STA $1B88
	JSR MessageBoxActions_GenerateMessage
	REP #$10
	PLX
	PLY
--
	RTL

+
	LDY #$0000
-
	LDA MessageBoxData,x
	STA !dp,y
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
	STA $1DFC	; /
	
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
;	LDA #$39 
;	STA $2119			;tile properties
	LDA #$391F
	STA $2118			;tile (empty/space)
	SEP #$20	
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
;	LDA #$38|!T			; \
;	STA $2119			; / tile properties to VRAM
	LDA #$392E			; \
	STA $2118			; / tile (arrow) to VRAM
	
.return2:
	SEP #$30
	PLB	
ReturnLong:
	RTL


;table of how much to add when pressing down/up
add:
	db $00,$01,$FF,$00