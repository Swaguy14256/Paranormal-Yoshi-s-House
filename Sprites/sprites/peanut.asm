;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Peanut
;;
;; Description: Literally a falling peanut. It is invincible to 
;; everything.
;;
;; Uses the Extra Bit?: No
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Init
;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
RTL			; Ends the code.

PRINT "MAIN ",pc
PHB			;\  
PHK			; | Changes the Data Bank to the one the sprite code runs from.
PLB			; | Makes certain sprite tables work properly.
JSR SPRITECODE		; | Jumps to the sprite code.
PLB			; | Restores the old Data Bank.
RTL			;/ Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;

RETURN:
RTS			; Ends the routine.

SPRITECODE:
JSR GRAPHICS		; Jumps to the graphics routine.

LDA $14C8,x		; Loads the sprite status table.
CMP #$08		; Checks if the sprite is alive.
BNE RETURN		; Branches if the sprite is dead.
LDA $9D			; Loads the lock animation and sprites flag.
BNE RETURN		; Branches if the sprite is locked.

LDA #$00		;\
%SubOffScreen()		;/ Jumps to the off screen handler.

JSL $81802A		; Applies the speed with gravity.
RTS			; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;
; Graphics Routine 
;;;;;;;;;;;;;;;;;;;;;;

GRAPHICS:
%GetDrawInfo()		; Jumps to the OAM handler.

LDA $00			;\
STA $0300,y		;/ Draws the X position of the sprite.

LDA $01			;\
STA $0301,y		;/ Draws the Y position of the sprite.

LDA #$8A		;\
STA $0302,y		;/ Loads the tile to draw.

LDA #$01		;\
ORA $64			;/ Loads the property byte.
STA $0303,y		; Stores the property byte.

LDY #$02		; Loads the sprite tile size.
LDA #$00		; Loads the number of tiles drawn -1.

JSL $81B7B3		; Calls the routine that draws the sprite.
RTS			; Ends the code.