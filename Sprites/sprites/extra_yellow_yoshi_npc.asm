;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NPC sprite v3.1, by Dispari Scuro and Alcaro
;;
;; This sprite displays a message when Mario touches it and presses UP.
;; It cannot hurt Mario and cannot be killed.
;; Read below to figure out how to use and fully customize this sprite!
;;
;; When placing the sprite in a level, the sprite uses three different variables
;; to determine which message it displays. Although this system is a little
;; complicated, this is to ensure that users use as few config files as possible.
;; With this system, you can have as many as 32 NPCs per level which all display
;; different messages, all with one config file!
;;
;; Firstly, the "Extra Info" is used to determine which message the sprite
;; displays from its level. With the new system, there's no need to specifically
;; display the "you found Yoshi" message, because it can be done directly.
;; Alternatively, if you set the second extra property byte 02, you can make the NPC
;; display no message at all!
;; Extra Info is set when you create a sprite in Lunar Magic. Normally when you insert
;; a custom sprite, you put Extra Info as 02. This sprite has different behavior if you
;; set it as 03 instead.
;;
;; Extra Info:
;; 02 = Message 1
;; 03 = Message 2
;;
;; After you determine which message the sprite will read from, you need to place it
;; in a good X position on the screen. When placing the sprite, the X position will
;; determine part one of which level the sprite actually reads from. There are 16
;; unique X positions possible per screen, which allows up to 16 unique messages.
;; The number starts over on the next screen. So if your sprite is in the first
;; position but on page 4, it's still considered 0 (position 1). Think of it like
;; the original message box, which changed its message based on its X position.
;; Only instead of only displaying one of two messages, you display one of 16.
;; In combination with the Extra Info, that's one of 32.
;;
;; The reason for the X position is to determine which color on the palette to read
;; from to use. If you set the X position for a sprite to 0, it will use the first
;; color on the palette as a reference. Therefore, you can set color 0 to color 24
;; to make the sprite read messages from level 24. This DOES mean that you can use
;; ExAnimation to palette animate this color and generate "random" messages! Please
;; note the special handling for levels over 24. For any level number over 24,
;; subtract DC from the level number. For example, level 105 would be 29. Note
;; that to properly use the palette, you have to set the color so that its SNES
;; RGB value is the level you want it to be, times 100. So if you want to read
;; from level 20, the SNES RGB value needs to be 2000. The easiest way to do this
;; is to set an ExAnimation palette animation of 2000 and then check the actual
;; palette to see what to paste. 2000 for instance is 0 red, 0 green, 64 blue.
;;
;; Here are some examples of how these three varibles come together. For the
;; sake of this example, we will assume the sprite is still reading from palette E.
;;
;; Example 1:
;; Extra Info is 2. X position is 6 (on screen 1). Palette E6 is 1200. This means the
;; sprite will display message 1 from level 12. X position is 6 so it reads from E6.
;; E6 says to read from level 12.
;;
;; Example 2:
;; Extra Info is 3. X position is 42 (on screen 3). Palette EB is 3200. This means the
;; sprite will display message 2 from level 10E. X position is 11 (11th spot on screen
;; 3). EB (B = 11) says to read from level 10E (32 + DC = 10E).
;;
;; If you're still confused about how to set the messages, check the included demo file
;; to see just how all the NPCs are set.
;;
;; For additional configuration for sprites which you may want to vary on an individual
;; basis and not just an overall behavior (unlike the sound the sprites make when spoken
;; to, which should remain the same across all sprites), use the following variables
;; found in the config file. With this, you can have a couple different NPCs with
;; varying behavior without having to change the ASM file.
;;
;; Extra Byte Property 1:
;; 00 = Sprite is stationary (if stationary, sprite always faces Mario).
;; Anything else = Sprite moves back and forth, and this is how long before it turns
;; around and starts in the other direction. Note that the NPC's turn timer will be
;; reset if he touches an object or a cliff (if set to stay on ledges). This is to
;; prevent the NPCs from "hugging" the wall.
;;
;; Extra Byte Property 2:
;; 00 = Sprite displays one message when spoken to.
;; 01 = Sprite displays two messages when spoken to, one after the other.
;; Note that if sprite is set to display level message two, using this feature will cause
;; it to display level message two and then the "you found Yoshi" message.
;; 02 = Sprite doesn't display any message at all.
;;
;; For all other configurables, see below!
;;
;; Thank yous to:
;; andyk250
;; Heisanevilgenius
;; S.N.N.
;; mikeyk
;;
;; Based on the following sprite(s):
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shy Guy, by mikeyk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SMB2 Birdo, by mikeyk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Palenemy Lakitu, by Glyph Phoenix and Davros.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Configurables for the sprite
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!MessagePalette = $F0		; Which palette to read from for messages. Palette E by default.
				; Change to suit your needs. Please use the palette you
				; want to use, followed by a zero. If you want to use
				; palette D, change this to $D0

!SoundEffect = $22		; Which sound to play. Use in conjunction with the sound bank.
				; Check online to find a list of sound effects.
				; Default is the same sounds message boxes use.

!SoundBank = $1DFC|!Base2	; Which sound bank to read from.
				; Acceptable values: $1DF9, $1DFA, $1DFB, $1DFC

!SpriteStop = $68		; How long a sprite stops before it turns around.
				; Set this to 00 if you don't want NPCs to stop
				; before turning around.

!DirAtStart = $FF		; How does the sprite start off? The classic NPC would
				; always start off walking to the right no matter what.
				; The new version is configurable. By default (FF) it will
				; walk toward Mario at the start. If you don't like this
				; behavior, you can set 00 so it always walks right and
				; 01 so it always walks left. The default walking toward
				; Mario is so the sprite doesn't walk off screen and
				; disappear.

!StayOnLedges = 1		; Does the NPC stay on ledges? 1 for yes, 0 for no.

!ButtonToPush = $08		; This controls what you must push to open a messagebox.
				; Edit this to suit your button-pushing needs:
				; 01 = Right
				; 02 = Left
				; 04 = Down
				; 08 = Up
				; 10 = Start
				; 20 = Select
				; 00 = R and L
				; 40 = Y and X
				; 80 = B and A

!DisplayMessage = 1		; Do the NPC display a message? 1 for yes, 0 for no.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Basic mikey stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!UpdateSpritePos = $01802A|!BankB
!MarioSprInteract = $01A7DC|!BankB
!GetSpriteClippingA = $03B69F|!BankB
!FinishOAMWrite = $01B7B3|!BankB

!ExtraProperty1 = !7FAB28
!ExtraProperty2 = !7FAB34
!RAM_SpriteDir = !157C
!RAM_SprTurnTimer = !15AC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dispari's stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!ExtraInfo = !7FAB10
!X_Position = !1594
!Message1_Timer = !1558			; The RAM used for the 1st message timer.
!Message2_Timer = !163E
!RAM_Backup_SprTurnTimer = $1F49,x	; The backup RAM used to store the current walking time.
!RAM_Backup_Dir = $1F55,x		; The backup RAM used to store the current sprite direction.
!RAM_SprStopTimer = !1564

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite init JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINT "INIT ",pc
incsrc header.asm

!FramePointer = $C2,x

;Point to the current frame on the animation.
!AnFramePointer = $1504,x

;Point to the current animation.
!AnPointer = $1510,x

!invisible = $151C,x

!DynamicSwitch = $1528,x

;Time for the next frame change.
!AnimationTimer = $1602,x

!extraBit = $7FAB10,x

!GlobalFlipper = $1534,x

!LocalFlipper = $1570,x

LDA #$04				;\
STA !invisible				;/ Sets the time to delay loading the sprite's graphics.

LDA #$00				;\
STA !FramePointer			; |
STZ !AnPointer				; | Resets the animation pointers and dynamic routine.
STZ !AnFramePointer			; |
STZ !DynamicSwitch			;/
LDA #$01				;\
STA !AnimationTimer			;/ Sets the time to switch between frames.

LDA #$FF				;\
STA !tileRelativePositionNormal,x	;/ Sets the tile relative position to a free slot.

JSL !reserveNormalSlot32		; Jumps to the reserve slot routine.

LDA !tileRelativePositionNormal,x	;\
CMP #$FF				; | Branches if there is a free slot.
BNE FREESLOT				;/

LDY $161A,x				;\
LDA #$00				; |
STA $1938,y				; | Prevents the sprite from loading.
STZ $14C8,x				;/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original NPC Init.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FREESLOT:
LDA #!DirAtStart
CMP #$FF
BNE SetDir

%SubHorzPos()
TYA
STA !157C,x
BRA DoneWithDir	

SetDir:
LDA #!DirAtStart
STA !157C,x

DoneWithDir:
EOR #$01				;\
STA !LocalFlipper			;/ Flips the sprite graphics.
LDA !167A,x
STA $187B,x

LDA #$01
STA $160E,x

LDA !E4,x				;\ Grab X position.
LSR A					; |
LSR A					; |
LSR A					; |
LSR A					; |
STA !X_Position,x			;/ Save for later.

LDA !ExtraProperty1,x			; \ Load walking duration into RAM address as a timer.
STA !RAM_SprTurnTimer,x			; /

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End Of The Original NPC Init.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

STZ !RAM_Backup_SprTurnTimer		; Resets the backup walking timer.
STZ !RAM_Backup_Dir			; Resets the backup sprite direction.
SPRITEFLIPPING:
LDA $157C,x				;\
BNE NOFLIP				;/ Branches if the sprite is facing left.
;LDA #$00				;\
;STA !AnimationTimer			;/ Sets the animation timer.
LDA #$01				;\
STA !GlobalFlipper			;/ Flips the sprite.
BRA ENDINIT				; Branches to the return address.
NOFLIP:
;LDA #$00				;\
;STA !AnimationTimer			;/ Sets the animation timer.
STZ !GlobalFlipper			; Flips the sprite.
ENDINIT:
RTL					; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite code JSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINT "MAIN ",pc

PHB					;\  
PHK					; | Changes the Data Bank to the one the sprite code runs from.
PLB					; | Makes certain sprite tables work properly.
JSR SpriteCode				; | Jumps to the sprite code.
PLB					; | Restores the old Data Bank.
RTL					;/ Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpeedX: db $08,$F8

Return2:
JSR preDynRoutine			; Gets a dynamic slot to make the DMA routine using Dynamic Z.
RTS					; Ends the code.

Return:
RTS					; Ends the code.

SpriteCode:
LDA !invisible				;\
BEQ VISIBLE				;/ Branches if the sprite is visible.

DEC A					;\
STA !invisible				;/ Decrements the invisible timer.
BRA Return2				; Branches to the predynamic routine.

VISIBLE:	
JSR sendSignal				; Jumps to the send signal routine.
JSR Graphics				; Jumps to the graphics routine.

LDA $14C8,x				;\
CMP #$08				; | Branches if the sprite is dead.
BNE Return				;/

JSL !SUB_OFF_SCREEN_X1			;\ Handles the off screen situation.
INC $1FD6,x				;/

LDA $9D					;\ Branches if the sprite is locked.
BNE Return2				;/

LDA !B6,x				;\
BEQ CONTINUE				;/ Branches if the sprite is not moving.
LDA !AnPointer				;\
BEQ CONTINUE				;/ Branches if the sprite changed its animation.
;LDA !DynamicSwitch			;\
;BEQ CONTINUE				;/ Branches if the dynamic routine has not happened yet.
STZ !AnFramePointer			;\
;LDA #$00				; | Resets the frame pointers.
;STA !FramePointer			;/
LDA #$00				;\
STA !AnimationTimer			;/ Sets the animation timer.
LDA #$00				;\
STA !AnPointer				;/ Sets the animation to use x2.
JSR Graphics				; Jumps to the graphics to prevent a glitch.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Original NPC Main.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CONTINUE:
LDA !ExtraProperty1,x			;\
BNE NormalCode				; | If NPC is stationary...
%SubHorzPos()           		; | ...always face Mario.
TYA                     		; | 
STA !157C,x             		;/
JSL SPRITEFLIPPING			; Jumps to the sprite flipping routine.

NormalCode:
LDA !ExtraProperty1,x			;\ If NPC is stationary...
BNE HandleTurnaround			; |
STZ !B6,x				;/ ...set speed as 0.
JSR IDLE				; Queues the idle animation.
BRA DoneWithSpeed

HandleTurnaround:
LDA !RAM_SprStopTimer,x			;\ If sprite has stopped long enough...
CMP #$01				; |
BEQ RestartSpriteMove			;/ ...restart its movement

LDA !RAM_SprTurnTimer,x			;\ If turn timer is zero...
BNE SetSpeed				; |
LDA #!SpriteStop			; | ...and sprite doesn't stop...
BEQ RestartSpriteMove			;/ ...just turn around.

LDA !RAM_SprStopTimer,x			;\ If sprite isn't already stopped...
BNE SetSpeed				; |
LDA #!SpriteStop			; | ...start the stop timer.
STA !RAM_SprStopTimer,x			;/
BRA SetSpeed

RestartSpriteMove:
STZ !RAM_SprStopTimer,x
JSR SpriteTurning			;\ Turn the NPC around...
LDA !ExtraProperty1,x			; |
STA !RAM_SprTurnTimer,x			;/ ...and reset turn timer.

SetSpeed:
LDY !157C,x				; Set X speed based on direction.
LDA SpeedX,y
STA !B6,x

LDA !RAM_SprStopTimer,x			;\
CMP #$02				; | Reset speed to zero...
BCC DoneWithSpeed			; | ...if Stop Timer is going.
STZ !B6,x				;/
JSR IDLE				; Queues the idle animation.

DoneWithSpeed:
JSL !UpdateSpritePos			; Update position based on speed values.

LDA !1588,x				; If sprite is in contact with an object...
AND #$03
BEQ NoObjContact
JSR SpriteTurning			; ...change direction.
LDA !ExtraProperty1,x			;\ Load walking duration into RAM address as a timer.
STA !RAM_SprTurnTimer,x			;/
NoObjContact:
if !StayOnLedges
JSR MaybeStayOnLedges
endif
LDA !1588,x				; If on the ground, reset the turn counter.
AND #$04
BEQ NotOnGround
LDA #$10
STA !AA,x
STZ $160E,x				; Reset turning flag (used if sprite stays on ledges).
BRA SPRITECONTACT			; Branches to the interaction routine.
NotOnGround:
LDA !AnPointer				;\
CMP #$04				; | Branches if the sprite changed its animation.
BEQ SPRITECONTACT			;/
;LDA !DynamicSwitch			;\
;BEQ SPRITECONTACT			;/ Branches if the dynamic routine has not happened yet.
STZ !AnFramePointer			;\
;LDA #$00				; | Resets the frame pointers.
;STA !FramePointer			;/
LDA #$00				;\
STA !AnimationTimer			;/ Sets the animation timer.
LDA #$04				;\
STA !AnPointer				;/ Sets the animation to use x2.
JSR Graphics				; Jumps to the graphics to prevent a glitch.
SPRITECONTACT:
LDA $187B,x
STA !167A,x
LDA !ExtraProperty2,x
AND #$02
BNE ReturnZ

JSL !MarioSprInteract			;\ Check for sprite contact.
BCC ReturnZ				;/

LDA !Message1_Timer,x			;\
CMP #$01				; | Branches if the 1st message timer is 1.
BEQ Message1				;/

LDA !Message2_Timer,x			;\ Handle second message if needed.
BNE Message2				;/

LDA $72					;\
BNE ReturnZ				;/ Branches if Mario is in the air.
LDA $16					;\ Check if Mario is pressing UP...
AND #!ButtonToPush			; | or whatever button you defined.
BEQ ReturnZ				;/
STZ $7B					; Sets Mario's speed to 0.
LDA #!SoundEffect			;\ Play a sound.
STA !SoundBank				;/
LDA #$02				;\ Sets the message timer.
STA !Message1_Timer,x			;/
LDA !157C,x				;\
STA !RAM_Backup_Dir			;/ Backs up the sprite direction.
JSR TALK				; Jumps to the facing routine.
LDA !RAM_SprTurnTimer,x			;\
STA !RAM_Backup_SprTurnTimer		;/ Backs up the walking time.
STZ !RAM_SprTurnTimer,x			; Stops the sprite.
BRA ReturnZ				; Branches to the Return address.

Message1:
STZ $7B					; Sets Mario's speed to 0.
JSR TALK				; Jumps to the facing routine.
LDA #!MessagePalette			;\
CLC					; | Figure out which palette to use for level.
ADC !X_Position,x			;/
PHX
REP #$30
AND.w #$00FF
ASL A
TAX
LDA $0704|!Base2,x
SEP #$30
PLX
; STA $2121				;
; LDA $213B				;\ Palette to read data.
; LDA $213B				;/
STA $08					; Store so we know which level to read from.

LDA !ExtraInfo,x			;\ Get Extra Info.
AND #$04				;/
BNE Scratch_1				;\
LDA #$01				; | Extra Info is kinda wacky.
BRA Scratch_2				;/

Scratch_1:
LDA #$02

Scratch_2:
STA $09					; Scratch RAM is a go.

LDA $08					;\ This allows you to read from any level
STA $13BF|!Base2			; | you want by tricking the game into thinking
					; | the level's number is something other than
					;/ what it actually is.


LDA $09
STA $1426|!Base2			; Display message specified.
LDA #$02				;\ Set double message.
STA !Message2_Timer,x			;/
ReturnZ:
JSR GraphicManager 			; Manages the frames of the sprite and decides what frames to show.
RTS

Message2:				; NOTE: Repeat code is fail, but the alternative
					; is spaghetti code.


LDA !ExtraProperty2,x			; \ If not set to display two messages...
AND #$01				;  |
BEQ RESUMEMOVEMENT			; / ...return.
BRA ContinueZ				; Branches to the 2nd message routine.

RESUMEMOVEMENT:
LDA !RAM_Backup_SprTurnTimer		;\
STA !RAM_SprTurnTimer,x			;/ Restores the walking time.
LDA !RAM_SprTurnTimer,x			;\
BEQ MOVEMENT				;/ Branches if the sprite is not moving.
STZ !RAM_SprStopTimer,x			; Moves the sprite.
MOVEMENT:
LDA !RAM_Backup_Dir			;\
STA !157C,x             		;/ Restores the sprite direction.
JSL SPRITEFLIPPING			; Jumps to the sprite flipping routine.
BRA ReturnZ				; Branches to the Return address.

ContinueZ:
STZ $7B					; Sets Mario's speed to 0.
JSR TALK				; Jumps to the facing routine.
LDA #!MessagePalette			; \
CLC					;  | Figure out which palette to use for level.
ADC !X_Position,x			; /
PHX
REP #$30
AND.w #$00FF
ASL A
TAX
LDA $0704|!Base2,x
SEP #$30
PLX
; STA $2121				;
; LDA $213B				;\ Palette to read data.
; LDA $213B				;/
STA $08					; Store so we know which level to read from.

LDA !ExtraInfo,x			;\ Get Extra Info.
AND #$04				;/
BNE Scratch_3				;\
LDA #$01				; | Extra Info is kinda wacky.
BRA Scratch_4				;/

Scratch_3:
LDA #$02

Scratch_4:
CLC
ADC #$01
STA $09					; Scratch RAM is a go.

LDA $08					;\ This allows you to read from any level
STA $13BF|!Base2			; | you want by tricking the game into thinking
					; | the level's number is something other than
					;/ what it actually is.

LDA $09
STA $1426|!Base2			; Display second message.
STZ !Message2_Timer,x
BRA RESUMEMOVEMENT			; Branches to the resume movement routine.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Some mikey Routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpriteTurning:
LDA !157C,x				;\ If sprite is going right...
BNE GoLeft				;/ ...go left.
LDA #$01				;\ Otherwise go right.
STA !157C,x				;/
STZ !GlobalFlipper			; Flips the sprite.
RTS

GoLeft:
LDA #$00
STA !157C,x
LDA #$01				;\
STA !GlobalFlipper			;/ Flips the sprite.
RTS

IDLE:
LDA !AnPointer				;\
CMP #$02				; | Branches if the sprite changed its animation.
BEQ STATIONARY				;/
;LDA !DynamicSwitch			;\
;BEQ STATIONARY				;/ Branches if the dynamic routine has not happened yet.
STZ !AnFramePointer			;\
;LDA #$00				; | Resets the frame pointers.
;STA !FramePointer			;/
LDA #$00				;\
STA !AnimationTimer			;/ Sets the animation timer.
LDA #$02				;\
STA !AnPointer				;/ Sets the animation to use x2.
JSR Graphics				; Jumps to the graphics to prevent a glitch.
STATIONARY:
RTS					; Ends the code.

TALK:
%SubHorzPos()           		;\
TYA                     		; | Makes the sprite face Mario.
STA !157C,x             		;/
STA $76					; Makes Mario face the sprite.
JSL SPRITEFLIPPING			; Jumps to the sprite flipping routine.
RTS					; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ledges
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MaybeStayOnLedges:
LDA !1588,x				; If the sprite is in the air...
ORA $160E,x				; ...and not already turning...
BNE NoFlipDirection
JSR SpriteTurning 			; ...flip direction.
LDA #$01				; Set turning flag.
STA $160E,x
LDA !ExtraProperty1,x			;\ Load walking duration into RAM address as a timer.
STA !RAM_SprTurnTimer,x			;/
NoFlipDirection:
RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphic Manager
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;		     $00,$08,$20,$28,$40,$48,$60,$68
spriteAorBMode50: db $00,$00,$01,$01,$01,$01,$01,$01
;		     $80,$88,$A0,$A8,$C0,$C8,$E0,$E8
		  db $00,$00,$00,$00,$00,$00,$00,$00


;	       $00,$08,$20,$28,$40,$48,$60,$68
spriteAorB: db $00,$00,$00,$00,$01,$01,$01,$01

GraphicManager:
LDA !tileRelativePositionNormal,x	; Loads the tile relative position.
TAY					; Transfers the Accumulator to the Y Register.

LDA !mode50				;\
BEQ MODE0				;/ Branches if the 50% more sprites mode is not enabled.
LDA spriteAorBMode50,y			;\
STA $00					;/ Loads and stores the sprite A or B flags.
BRA DYNAMICTIMER			; Branches to the dynamic timer routine.
MODE0:
LDA spriteAorB,y			;\
STA $00					;/ Loads and stores the sprite A or B flags.

DYNAMICTIMER:
LDA !AnPointer				; Loads the animation pointer x2.
REP #$30				; Turns on 16-bit addressing for the A, X, and Y registers.
AND #$00FF				; Keeps the last 8 bits.
TAY					; Transfers the Accumulator to the Y Register.
SEP #$30				; Turns on 8-bit addressing for the A, X, and Y registers.

LDA !AnFramePointer			;\
CLC					; | Adds the starting frame to the animation pointers.
ADC EndPositionAnim,y			;/
TAY					; Transfers the Accumulator to the Y Register.
SEP #$30				; Turns on 8-bit addressing for the A, X, and Y registers.

LDA !GlobalFlipper			;\
EOR AnimationsFlips,y			; | Sets the flipping for each frame.
STA !LocalFlipper			;/

LDA !DTimer				; Loads the dynamic timer.
AND #$01				;\
CMP $00					; | Branches if the timer is not 1.
BNE SETDYNAMICROUTINE			;/

LDA !AnimationTimer			;\
BEQ ChangeFrame				;/ Branches if the animation timer is 0.
DEC !AnimationTimer			; Decrements the animation timer.
RTS					; Ends the code.

SETDYNAMICROUTINE:
LDA !DynamicSwitch			;\
BEQ DYNAMICSWITCHOFF			;/ Branches if the dynamic switch is 0.
JSR DynamicRoutine 			; Gets a dynamic slot to make the DMA routine using Dynamic Z.
DYNAMICSWITCHOFF:
RTS					; Ends the code.

ChangeFrame:
LDA !AnPointer				; Loads the animation pointer x2.
REP #$30				; Turns on 16-bit addressing for the A, X, and Y registers.
AND #$00FF				; Keeps the last 8 bits.
TAY					; Transfers the Accumulator to the Y Register.

LDA !AnFramePointer			;\
CLC					; | Adds the starting frame to the animation pointers.
ADC EndPositionAnim,y			;/
TAY					; Transfers the Accumulator to the Y Register.
SEP #$30				; Turns on 8-bit addressing for the A, X, and Y registers.

LDA AnimationsFrames,y			;\
STA !FramePointer			;/ Loads the frames for the new animation.

LDA AnimationsNFr,y			;\
STA !AnFramePointer			;/ Loads the order of the frames.

LDA AnimationsTFr,y			;\
STA !AnimationTimer			;/ Loads the timer for each frame.

LDA !GlobalFlipper			;\
EOR AnimationsFlips,y			; | Sets the flipping for each frame.
STA !LocalFlipper			;/

LDA #$01				;\
STA !DynamicSwitch			;/ Enables the dynamic switch.
RTS					; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Animation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; See the Tutorial to know how to fill these tables.

EndPositionAnim:
	dw $0000,$0008,$000E

AnimationsFrames:
WalkFrames:
	db $00,$01,$02,$01,$00,$03,$04,$03
IdleFrames:
	db $00,$05,$06,$07,$06,$05
FallingFrames:
	db $04
AnimationsNFr:
WalkNFr:
	db $01,$02,$03,$04,$05,$06,$07,$00
IdleNFr:
	db $01,$02,$03,$04,$05,$00
FallingNFr:
	db $00
AnimationsTFr:
WalkTFr:
	db $02,$02,$02,$02,$02,$02,$02,$02
IdleTFr:
	db $03,$03,$03,$03,$03,$03
FallingTFr:
	db $00
AnimationsFlips:
WalkFlips:
	db $00,$00,$00,$00,$00,$00,$00,$00
IdleFlips:
	db $00,$00,$00,$00,$00,$00
FallingFlips:
	db $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphic Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FlipAdder: db $00,$08
tileRel: db $00,$BA,$FE,$1A,$22,$7A,$9A,$C2,$80,$88,$A0,$A8,$C0,$C8,$E0,$E8
propRel: db $00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

Graphics:
REP #$10				; Turns on 16-bit addressing for the X and Y registers.
LDY #$0000				; Loads 0 into the Y Register, this time in 16-bit.
SEP #$10				; Turns on 8-bit addressing for the X and Y registers.

LDA !tileRelativePositionNormal,x	; Loads the tile relative position.
TAY					; Transfers the Accumulator to the Y Register.
LDA tileRel,y				;\
STA $0F					;/ Loads and stores the relative position of the tiles to $0F.

LDA !tileRelativePositionNormal,x	; Loads the tile relative position.
TAY					; Transfers the Accumulator to the Y Register.
LDA propRel,y				;\
STA $0C					;/ Loads and stores the relative tile properties to $0C.

JSL !GET_DRAW_INFO			; Jumps to the OAM handler.
LDA $06					;\
BEQ DRAW 				;/ Branches if the sprite is off-screen.
RTS					; Ends the code.

DRAW:
PHX					; Preserves the X Register.
LDA !LocalFlipper			;\
PHA					;/ Loads and preserves the sprite flipping.
LDA !FramePointer			; Loads the frame pointer.
PLX					; Pulls back the X Register.
CLC					;\
ADC FlipAdder,x				;/ Adds the starting frames based on the sprite's flipping.
REP #$30				; Turns on 16-bit addressing for the A, X, and Y registers.

AND #$00FF				; Keeps the last 8 bits.
ASL					; Multiplies the frame pointer by 2.
TAX					; Transfers the Accumulator to the X Register.

LDA EndPositionFrames,x			;\ Loads the values to end the tile drawing loop.
STA $0D					;/ 

LDA StartPositionFrames,x		; Loads the starting value for the drawing loop.
TAX					; Transfers the Accumulator to the X Register.
SEP #$20				; Turns on 8-bit addressing for the Accumulator.

LOOP:
LDA FramesXDisp,x			;\
CLC					; | Loads the X Positions of each tile in each frame.
ADC $00					; |
STA $0300,y				;/

LDA FramesYDisp,x			;\
CLC					; |
ADC $01					; | Loads the Y Positions of each tile in each frame.
STA $0301,y				;/

LDA FramesProperty,x			;\
ORA $0C					; | Loads the Properties of each tile in each frame and adds the relative properties.
ORA $64					; |
STA $0303,y				;/
LDA FramesTile,x			; Loads the tiles in each frame.
BMI TILERELATIVE			; Branches if another dynamic sprite is using these tiles.
STA $0302,y				; Stores the tiles.
BRA TILESIZE				; Branches to the tile size routine.
TILERELATIVE:
CLC					;\
ADC $0F					;/ Adds the relative positions of the tiles on the VRAM map.
STA $0302,y				; Stores the tiles.

TILESIZE:
TYA					; Transfers the Y Register to the Accumulator.
LSR					;\
LSR					;/ Shifts the bits to the right twice.
PHY					; Preserves the Y Register.
TAY					; Transfers the Accumulator to the Y Register.
LDA FramesSize,x			;\ Loads the size of each tile in each frame.
STA $0460,y				;/
PLY					; Pulls back the Y register.

INY					;\
INY					; | Increments the OAM to prevent the tiles from overwriting each other.
INY					; |
INY					;/

DEX					; Decreases the X Register.
BMI FINISHDRAWING			; Branches if the X Register is a negative value.
CPX $0D					;\
BCS LOOP				;/ Branches if the X Register matches the value used to end the tile drawing loop is equal or higher.
FINISHDRAWING:
SEP #$10				; Turns on 8-bit addressing for the X and Y registers.
PLX					; Pulls back the X register.

LDA !FramePointer			; Loads the frame pointer.
TAY					; Transfers the Accumulator to the Y Register.
LDA FramesTotalTiles,y			; Loads the number of tiles drawn -1.
LDY #$FF				; Loads the sprite tile size.
JSL $81B7B3				; Calls the routine that draws the sprite.
RTS					; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Frames
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; See the Tutorial to know how to fill these tables.

FramesTotalTiles:
	db $0A,$09,$0B,$08,$0A,$0A,$0A,$0A,$0A,$09,$0B,$08,$0A,$0A,$0A,$0A
StartPositionFrames:
	dw $000A,$0014,$0020,$0029,$0034,$003F,$004A,$0055,$0060,$006A,$0076,$007F,$008A,$0095,$00A0,$00AB
EndPositionFrames:
	dw $0000,$000B,$0015,$0021,$002A,$0035,$0040,$004B,$0056,$0061,$006B,$0077,$0080,$008B,$0096,$00A1

FramesXDisp:
Walk1XDisp:
	db $01,$F9,$01,$F9,$09,$09,$09,$05,$01,$01,$09
Walk2XDisp:
	db $00,$F8,$00,$F8,$08,$09,$09,$01,$00,$08
Walk3XDisp:
	db $FC,$00,$07,$07,$00,$F8,$00,$09,$04,$F8,$01,$F9
Walk4XDisp:
	db $00,$F8,$00,$F8,$08,$09,$09,$01,$00
Walk5XDisp:
	db $08,$08,$00,$00,$F8,$00,$F8,$F8,$FA,$09,$01
Idle1XDisp:
	db $01,$F9,$01,$F9,$09,$09,$09,$05,$01,$01,$09
Idle2XDisp:
	db $01,$F9,$01,$F9,$09,$09,$09,$05,$01,$01,$09
Idle3XDisp:
	db $01,$F9,$01,$F9,$09,$09,$09,$05,$01,$01,$09
Walk1FlipXXDisp:
	db $FF,$07,$FF,$0F,$FF,$FF,$FF,$03,$07,$07,$FF
Walk2FlipXXDisp:
	db $00,$08,$00,$10,$00,$FF,$FF,$07,$08,$00
Walk3FlipXXDisp:
	db $0C,$08,$01,$01,$00,$08,$00,$FF,$04,$10,$07,$0F
Walk4FlipXXDisp:
	db $00,$08,$00,$10,$00,$FF,$FF,$07,$08
Walk5FlipXXDisp:
	db $00,$00,$08,$00,$08,$00,$10,$10,$0E,$FF,$07
Idle1FlipXDisp:
	db $FF,$07,$FF,$0F,$FF,$FF,$FF,$03,$07,$07,$FF
Idle2FlipXDisp:
	db $FF,$07,$FF,$0F,$FF,$FF,$FF,$03,$07,$07,$FF
Idle3FlipXDisp:
	db $FF,$07,$FF,$0F,$FF,$FF,$FF,$03,$07,$07,$FF
FramesYDisp:
Walk1YDisp:
	db $EA,$EA,$FA,$FA,$0A,$F2,$EE,$EC,$F2,$0A,$FA
Walk2YDisp:
	db $EB,$EB,$FB,$FB,$08,$F3,$EF,$F3,$08,$FB
Walk3YDisp:
	db $F5,$F4,$F3,$EF,$EC,$EC,$FC,$08,$FC,$00,$08,$08
Walk4YDisp:
	db $EB,$EB,$FB,$FB,$08,$F3,$EF,$F3,$08
Walk5YDisp:
	db $F0,$F4,$F4,$EC,$EC,$FC,$FC,$04,$07,$07,$08
Idle1YDisp:
	db $EA,$EA,$FA,$FA,$0A,$F2,$EE,$EC,$F2,$0A,$FA
Idle2YDisp:
	db $EB,$EB,$FB,$FB,$0A,$F3,$EF,$ED,$F3,$0A,$FB
Idle3YDisp:
	db $EB,$EB,$FB,$FB,$0A,$F3,$EF,$ED,$F3,$0A,$FB
Walk1FlipXYDisp:
	db $EA,$EA,$FA,$FA,$0A,$F2,$EE,$EC,$F2,$0A,$FA
Walk2FlipXYDisp:
	db $EB,$EB,$FB,$FB,$08,$F3,$EF,$F3,$08,$FB
Walk3FlipXYDisp:
	db $F5,$F4,$F3,$EF,$EC,$EC,$FC,$08,$FC,$00,$08,$08
Walk4FlipXYDisp:
	db $EB,$EB,$FB,$FB,$08,$F3,$EF,$F3,$08
Walk5FlipXYDisp:
	db $F0,$F4,$F4,$EC,$EC,$FC,$FC,$04,$07,$07,$08
Idle1FlipXYDisp:
	db $EA,$EA,$FA,$FA,$0A,$F2,$EE,$EC,$F2,$0A,$FA
Idle2FlipXYDisp:
	db $EB,$EB,$FB,$FB,$0A,$F3,$EF,$ED,$F3,$0A,$FB
Idle3FlipXYDisp:
	db $EB,$EB,$FB,$FB,$0A,$F3,$EF,$ED,$F3,$0A,$FB
FramesProperty:
Walk1Properties:
	db $44,$44,$44,$44,$4E,$4E,$4E,$4E,$4E,$4E,$4E
Walk2Properties:
	db $44,$44,$44,$44,$4E,$4E,$4E,$4E,$4E,$4E
Walk3Properties:
	db $4E,$4E,$4E,$4E,$44,$44,$44,$4E,$4E,$44,$4E,$4E
Walk4Properties:
	db $44,$44,$44,$44,$4E,$4E,$4E,$4E,$4E
Walk5Properties:
	db $4E,$4E,$4E,$44,$44,$44,$44,$44,$4E,$4E,$4E
Idle1Properties:
	db $44,$44,$44,$44,$4E,$4E,$4E,$4E,$4E,$4E,$4E
Idle2Properties:
	db $44,$44,$44,$44,$4E,$4E,$4E,$4E,$4E,$4E,$4E
Idle3Properties:
	db $44,$44,$44,$44,$4E,$4E,$4E,$4E,$4E,$4E,$4E
Walk1FlipXProperties:
	db $04,$04,$04,$04,$0E,$0E,$0E,$0E,$0E,$0E,$0E
Walk2FlipXProperties:
	db $04,$04,$04,$04,$0E,$0E,$0E,$0E,$0E,$0E
Walk3FlipXProperties:
	db $0E,$0E,$0E,$0E,$04,$04,$04,$0E,$0E,$04,$0E,$0E
Walk4FlipXProperties:
	db $04,$04,$04,$04,$0E,$0E,$0E,$0E,$0E
Walk5FlipXProperties:
	db $0E,$0E,$0E,$04,$04,$04,$04,$04,$0E,$0E,$0E
Idle1FlipXProperties:
	db $04,$04,$04,$04,$0E,$0E,$0E,$0E,$0E,$0E,$0E
Idle2FlipXProperties:
	db $04,$04,$04,$04,$0E,$0E,$0E,$0E,$0E,$0E,$0E
Idle3FlipXProperties:
	db $04,$04,$04,$04,$0E,$0E,$0E,$0E,$0E,$0E,$0E
FramesTile:
Walk1Tiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Walk2Tiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AD,$BC,$BD
Walk3Tiles: 
	db $AB,$AB,$AB,$AB,$A6,$A7,$A9,$BB,$AC,$AD,$BC,$BD
Walk4Tiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AD,$BC
Walk5Tiles: 
	db $AC,$AC,$AC,$A6,$A7,$A9,$AB,$BB,$AD,$BC,$BD
Idle1Tiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Idle2Tiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Idle3Tiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Walk1FlipXTiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Walk2FlipXTiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AD,$BC,$BD
Walk3FlipXTiles: 
	db $AB,$AB,$AB,$AB,$A6,$A7,$A9,$BB,$AC,$AD,$BC,$BD
Walk4FlipXTiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AD,$BC
Walk5FlipXTiles: 
	db $AC,$AC,$AC,$A6,$A7,$A9,$AB,$BB,$AD,$BC,$BD
Idle1FlipXTiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Idle2FlipXTiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
Idle3FlipXTiles: 
	db $A6,$A7,$A9,$AB,$BB,$AC,$AC,$AC,$AD,$BC,$BD
FramesSize:
Walk1Size: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Walk2Size: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00
Walk3Size:
	db $00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00
Walk4Size: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00
Walk5Size: 
	db $00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00
Idle1Size: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Idle2Size: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Idle3Size: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Walk1FlipXSize: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Walk2FlipXSize: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00
Walk3FlipXSize: 
	db $00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00
Walk4FlipXSize: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00
Walk5FlipXSize: 
	db $00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00
Idle1FlipXSize: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Idle2FlipXSize: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
Idle3FlipXSize: 
	db $02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dynamic Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VramTable:
	dw $0000,$0100,$0400,$0500,$0800,$0900,$0C00,$0D00

preDynRoutine:
STZ !DynamicSwitch			; Disables the dynamic switch.

LDA !tileRelativePositionNormal,x	; Loads the tile relative position.
TAY					; Transfers the Accumulator to the Y Register.

LDA !mode50				;\
BEQ NOTMODE50				;/ Branches if the 50% more sprites mode is not enabled.
LDA spriteAorBMode50,y			;\
STA $00					;/ Loads and stores the sprite A or B flags.
BRA DYNAMICTIMERHANDLER			; Branches to the dynamic timer routine.
NOTMODE50:
LDA spriteAorB,y			;\
STA $00					;/ Loads and stores the sprite A or B flags.

DYNAMICTIMERHANDLER:
LDA !DTimer				; Loads the dynamic timer.
AND #$01				;\
CMP $00					; | Branches if the timer is not 1.
BNE startDyn				;/
RTS					; Ends the code.

DynamicRoutine:
STZ !DynamicSwitch			; Disables the dynamic switch.

LDA !tileRelativePositionNormal,x	; Loads the tile relative position.
TAY					; Transfers the Accumulator to the Y Register.

startDyn:
JSL !DynamicRoutine32Start		; Jumps to the 32x32 dynamic initialization routine.

LDA !FramePointer			; Loads the frame pointer.
ASL					; Multiplies it by 2.
TAY					; Transfers the Accumulator to the Y Register.

PHX					; Preserves the X Register.
LDX $0000				; Loads scratch RAM in 16-bit.

PHB					;\
PLA					;/ Puts the Data Bank into the Accumulator.
STA !dynSpBnk,x				;\
STA !dynSpBnk-$04,x			; |
LDA #$00				; | Sets the bank of the graphics.
STA !dynSpBnk+$01,x			; |
STA !dynSpBnk-$03,x			;/

REP #$20				; Turns on 16-bit addressing for the Accumulator.

LDA VramTable,y				; Loads the VRAM table.
CMP #$FFFF				;\
BEQ NOTDYNAMIC				;/ Branches if the current frame does not use dynamic graphics.
CLC					;\
ADC GFXPointer				; |
STA !dynSpRec,x				; | Gets the graphic pointer for the current frame.
CLC					; |
ADC #$0200				; |
STA !dynSpRec-$04,x			;/

LDA #$0100				;\
STA !dynSpLength,x			; | Sets the horizontal VRAM length to transfer.
STA !dynSpLength-$04,x			;/

SEP #$20				; Turns on 8-bit addressing for the Accumulator.

TXA					; Transfers the X Register to the Accumulator.
SEC					;\
SBC #$04				; |
STA !nextDynSlot,x			; | Sets the next slot of the dynamic transfer.
LDA #$00				; |
STA !nextDynSlot+$01,x			;/
LDA #$FF				;\
STA !nextDynSlot-$04,x			; | Finishes the dynamic transfer.
STA !nextDynSlot-$03,x			;/

SEP #$20				; Turns on 8-bit addressing for the Accumulator.
PLX					; Pulls back the X register.
RTS					; Ends the code.

NOTDYNAMIC:
SEP #$20				; Turns on 8-bit addressing for the Accumulator.
PLX					; Pulls back the X register.
RTS					; Ends the code.

sendSignal:
LDA !tileRelativePositionNormal,x	; Loads the tile relative position.
TAY					; Transfers the Accumulator to the Y Register.

JSL !Ping32				; Jumps to the signal sending routine.

RTS					; Ends the code.


adder: db $00,$40,$C0,$20

GFXPointer:
dw resource

; Fill this with the name of your ExGFX. (Replace "resource.bin" for the name of your graphic.bin.)
resource:
incbin yoshi_npc.bin ; Replace this for the name of your GFX.
