;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Music Block
;;
;; Description: A music block that displays a soundtrack select
;; menu when Mario hits it from below. The soundtrack select menu
;; is not within the sprite code, but it is within a separate
;; patch. To use the soundtrack select menu, the directional pad
;; selects the track to play, the L and R buttons switch pages,
;; the A and B buttons play and repeat the track selected, the X
;; and Y buttons toggle the tempo increase, and the Start and
;; Select buttons close the window. In addition, the left and
;; right buttons on the directional pad select the sound effect to
;; play when the "Sound Effects" track is selected. The sprite
;; only appears when a specified level is complete (Level 104 by
;; default). The music select menu also uses a specified RAM
;; address for the translevel numbers ($06FD by default). The
;; message numbers also use a RAM address ($06FF by default).
;;
;; Uses the Extra Bit?: No
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Level = $1ECA			; The level that needs to be completed in order for this sprite to spawn.
!MessageNumber = $06FF		; The RAM address that contains the translevel numbers.
!DisplayMessageNumber = $0700	; The RAM address that contains the message numbers.
!MessageType = $01		; The message type.
!MessageTypeAddr = $0DC5	; The RAM address that contains the message type.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
RTL				; Ends the code.

PRINT "MAIN ",pc
PHB				;\  
PHK				; | Changes the Data Bank to the one the sprite code runs from.
PLB				; | Makes certain sprite tables work properly.
JSR SPRITECODE			; | Jumps to the sprite code.
PLB				; | Restores the old Data Bank.
RTL				;/ Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;

RETURN:
RTS				; Ends the routine.

SPRITECODE:
LDA !Level			;\
AND #$80			; | Branches if the specified level is incomplete.
BEQ RETURN			;/

JSL $81B44F			; Jumps to the solid sprite block routine.
LDA #$03			;\
%SubOffScreen()			;/ Jumps to the off screen handler.
LDA $1558,x			;\
CMP #$01			; | Branches if the sprite is not hit from below.
BNE NOCONTACT			;/
LDA #$22			;\
STA $1DFC			;/ Sound to play.
STZ $1558,x			; Sets the sprite hit from below flag to 0.
STZ $C2,x			; Sets the sprite state to 0.
LDA !MessageNumber		;\
STA $13BF			;/ Changes the current translevel number to the one specified.
LDA !DisplayMessageNumber	;\
STA $1426			;/ Displays the message number specified.
LDA #!MessageType		;\
STA !MessageTypeAddr 		;/ Sets the message type.
NOCONTACT:
JSR GRAPHICS			; Jumps to the graphics routine.
RTS				; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; GRAPHICS Routine 
;;;;;;;;;;;;;;;;;;;;;;

YDISP: db $00,$04,$07,$08,$08,$07,$04,$00,$00
TILEMAP: db $86,$8A,$86,$A0

GRAPHICS:
LDA $1558,x			; Loads the sprite hit from below flag.
LSR				; Reduces the speed of the hit from below animation.
TAY				; Transfers the Accumulator into the Y Register.
LDA $1C				; Loads the low byte of the Layer 1 Y position.
PHA				; Preserves the Y position.
CLC				;\
ADC YDISP,y			; | Draws the Y position of the sprite. 
STA $1C				;/
LDA $1D				; Loads the high byte of the Layer 1 Y position.
PHA				; Preserves the Y position.
ADC #$00			;\
STA $1D				;/ Adds and stores the new Y position.
JSL $8190B2			; Jumps to the generic graphics drawing routine.

LDY $15EA,x			; Loads the sprite OAM index into the Y register.
LDA $14				; Loads the frame counter.
LSR				;\
LSR				;/ Reduces the animation speed.
ADC $15E9			; Adds the sprite index.
LSR				; Reduces the animation speed.
AND #$03			; Sets the number of frames the sprite uses -1.
TAX				; Transfers the Accumulator into the X Register.
LDA TILEMAP,x			;\
STA $0302,y			;/ Loads the tilemap table and draws the tiles in the table.
LDX $15E9			; Loads the sprite index.

LDA #$07			;\
ORA $64				;/ Loads the property byte.
STA $0303,y			; Stores the property byte.
PLA				; Pulls the low byte of the Layer 1 Y position.
STA $1D				; Restores the original Y position.
PLA				; Pulls the high byte of the Layer 1 Y position.
STA $1C				; Restores the original Y position.
RTS				; Ends the code.