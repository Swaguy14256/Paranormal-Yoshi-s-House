;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WMS Magician
;;
;; Description: A magician that shoots fireballs. After 13
;; attacks, it jumps and uses lightning, ice, and rocks for 13
;; attacks. If it gets struck by its own lightning, then it falls.
;; When it gets hurt, it drops an item. UberASM is required for
;; this sprite to properly work.
;;
;; Uses The Extra Bit?: Yes
;; When the extra bit is set, the sprite's attacks change. There
;; is also a cutscene before battling it, and another upon
;; defeating it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

!True = 1					; The true and false flags. They determine whether certain hardcoded behaviours should be assembled or not.
!False = 0					; DO NOT CHANGE THESE FLAGS, OR ELSE BAD (TM) THINGS WILL HAPPEN!

!UseBobCutscene = !True				; Used to determine whether Bob's hardcoded cutscene behaviour should be assembled with this sprite.
!LevelForCutscene = $0049			; Level for the cutscene behaviour. Only 16-bit values work. When changing, it must be 4 digits long (in hex).

!WMSMagicianHP = $04				; The health for the WMS Magician.
!BobHP = $04					; The health for Bob. Only Bob's lightning attack changes based on the percentage of health points remaining.

!ExtraSpriteTable1 = $1F49,x			; An extra sprite table used from unused RAM. Make sure that the RAM is free and 12 bytes long. This sprite table keeps track of the number of moves done by the WMS Magician and Bob.
!ExtraSpriteTable2 = $1F55,x			; Another extra sprite table used from unused RAM. Make sure that the RAM is free and 12 bytes long. This sprite table keeps track of the number of fireballs thrown by the WMS Magician and Bob during their rapid fire attack, and the number of snowflakes spawned by the WMS Magician and Bob during their blizzard attack; it is an object counter. It is also the low byte of the target Y position during the WMS Magician and Bob's ascending state.
!ExtraSpriteTable3 = $1F61,x			; A third extra sprite table used from unused RAM. Make sure that the RAM is free and 12 bytes long. This sprite table contains the low byte of Mario's last X Position. It is also the high byte of the target Y position during the WMS Magician and Bob's ascending state. During the WMS Magician and Bob's blizzard and Earth slide attacks, this determines which position table to load for the snowflakes and rocks.
!ExtraSpriteTable4 = $1F6D,x			; A forth extra sprite table used from unused RAM. Make sure that the RAM is free and 12 bytes long. This sprite table contains the high byte of Mario's last X Position.
!ExtraSpriteTable5 = $1F79,x			; A fifth extra sprite table used from unused RAM. Make sure that the RAM is free and 12 bytes long. This sprite table determines which direction of Mario to place the warning signs and lightning bolts on. It is also used to determine if the WMS Magician and Bob have done their lightning attack at least once.

!JumpSFX = $01					; The jump sound. AddmusicK 1.0.8 users or lower must change this to something else unless they fix the original jump sound effect by themselves.
!JumpSFXBank = $1DFA				; The jump sound bank. Once again, AddmusicK 1.0.8 users or lower must change this to something else or else glitches will happen unless the original jump sound effect is properly fixed.

!FireballNumber = $15				; The custom sprite number for the fireballs the WMS Magician and Bob shoot.

!DisableControlsFlag = $79			; The flag used to disable Mario's controls.
!LevelState = $7C				; The state of the current level.
!ThunderTimer = $87				; The thunder HDMA timer.
!RegularStunFlag = $06F9			; A flag used to determine whether stunning Mario should spawn an ice block or not.
!DestroyItemTimer = $06FA			; The timer for destroying power-up items.
!TimerFrameCounterBackup = $06FB		; A backup of the timer frame counter for pausing the time limit.

!BattleMusic = $2B				; The music to play when Bob initiates the battle.
!MuteMusic = $FE				; The music to play when Bob loses all of his health.
!AreaMusic = $2E				; The music to play after Bob dies.

LDA #$04					;\
STA !invisible					;/ Sets the time to delay loading the sprite's graphics.

LDA #$00					;\
STA !FramePointer				; |
STZ !AnPointer					; | Resets the animation pointers and dynamic routine.
STZ !AnFramePointer				; |
STZ !DynamicSwitch				;/
LDA #$01					;\
STA !AnimationTimer				;/ Sets the time to switch between frames.

LDA #$FF					;\
STA !tileRelativePositionNormal,x		;/ Sets the tile relative position to a free slot.

JSL !reserveNormalSlot32			; Jumps to the reserve slot routine.

LDA !tileRelativePositionNormal,x		;\
CMP #$FF					; | Branches if there is a free slot.
BNE FREESLOT					;/

LDY $161A,x					;\
LDA #$00					; |
STA $1938,y					; | Prevents the sprite from loading.
STZ $14C8,x					;/

FREESLOT:
STZ !ExtraSpriteTable1				; Resets the moves counter.
STZ !ExtraSpriteTable2				; Resets the object counter.
STZ !ExtraSpriteTable3				; Resets the low byte of Mario's last X Position.
STZ !ExtraSpriteTable4				; Resets the high byte of Mario's last X Position.
STZ !ExtraSpriteTable5				; Resets the warning sign and lightning direction flag.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ WMSMAGICIANHP				;/
LDA #!BobHP					;\
STA $160E,x					;/ Sets the HP of the sprite.
BRA SPAWNTIME					; Branches to the finish initialization routine.
WMSMAGICIANHP:
LDA #!WMSMagicianHP				;\
STA $160E,x					;/ Sets the HP of the sprite.
SPAWNTIME:	
STZ $1594,x					; Sets the sprite state to 0.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ WMSSPAWNTIME				;/
if !UseBobCutscene == !True
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $010B					;\
CMP #!LevelForCutscene				; | Branches if Mario is not in the level used for Bob's cutscene behaviour.
BNE REGULARSPAWN				;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$FF					;\
STA $1540,x					;/ Sets the spawn timer.
BRA FINISHINIT					; Branches to the finish initialization routine.
REGULARSPAWN:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
endif
LDA #$1E					;\
STA $1540,x					;/ Sets the spawn timer.
BRA FINISHINIT					; Branches to the finish initialization routine.
WMSSPAWNTIME:
LDA #$02					;\
STA $1540,x					;/ Sets the spawn timer.
FINISHINIT:
%SubHorzPos()					;\
TYA						; | Makes the sprite face Mario.
STA $157C,x					;/
SPRITEFLIPPING:
LDA $157C,x					;\
BNE NOFLIP					;/ Branches if the sprite is facing left.
;LDA #$00					;\
;STA !AnimationTimer				;/ Sets the animation timer.
LDA #$01					;\
STA !GlobalFlipper				;/ Flips the sprite.
BRA ENDINIT					; Branches to the return address.
NOFLIP:
;LDA #$00					;\
;STA !AnimationTimer				;/ Sets the animation timer.
STZ !GlobalFlipper				; Flips the sprite.
ENDINIT:
RTL

PRINT "MAIN ",pc

PHB						;\  
PHK						; | Changes the Data Bank to the one the sprite code runs from.
PLB						; | Makes certain sprite tables work properly.
JSR SpriteCode					; | Jumps to the sprite code.
PLB						; | Restores the old Data Bank.
RTL						;/ Ends the code.
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sprite Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Return2:
JSR preDynRoutine				; Gets a dynamic slot to make the DMA routine using Dynamic Z.
RTS						; Ends the code.

Return:
RTS						; Ends the code.

SpriteCode:
LDA !invisible					;\
BEQ VISIBLE					;/ Branches if the sprite is visible.

DEC A						;\
STA !invisible					;/ Decrements the invisible timer.
BRA Return2					; Branches to the predynamic routine.

VISIBLE:
LDA $1540,x					;\
BNE NOGFX					;/ Branches if the spawn timer is more than 0.
APPEAR:
JSR sendSignal					; Jumps to the send signal routine.
JSR Graphics					; Jumps to the graphics routine.

NOGFX:
LDA $14C8,x					;\
CMP #$08					; | Branches if the sprite is dead.
BNE Return					;/
	
JSL !SUB_OFF_SCREEN_X0				; Handles the off screen situation.

LDA $9D						;\ Branches if the sprite is locked.
BNE Return2					;/

LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ NOBIT					;/
if !UseBobCutscene == !True
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $010B					;\
CMP #!LevelForCutscene				; | Branches if Mario is not in the level used for Bob's cutscene behaviour.
BNE REGULARBOB					;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
JMP CUTSCENEBOB					; Jumps to Bob's cutscene sprite code.
REGULARBOB:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
endif
JMP BOB						; Jumps to Bob's sprite code.

NOBIT:
JMP WMSMAGICIAN					; Jumps to the WMS Magician sprite code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WMS Magician
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SPINSTARSPAWN:
PHX						; Preserves the X Register.
LDX #$03					; Loads a loop count of 3.
SPINSTARLOOP:
JSL SPAWNSPINSTAR				; Jumps to the spawn spin star routine that I also stole from Nintendo.
DEX						; Decrements the loop count.
BPL SPINSTARLOOP				; Loops the Spin Jump Star loop until it is -1.
PLX						; Pulls back the X Register.
RTL						; It ends the code.
SPAWNSPINSTAR:
LDY #$07					; Loads another loop count of 7.
FINDEMPTYSLOT:
LDA $170B,Y					;\
BEQ FOUNDEMPTYSLOT				;/ Branches if the sprite slot is 0.
DEY						; Decrements the loop count.
BPL FINDEMPTYSLOT				; Loops the find empty slot loop until it is -1.
RTL						; Ends the stolen code.
FOUNDEMPTYSLOT:
LDA #$10					;\
STA $170B,Y					;/ Sets the sprite to a Spin Jump Star.
PHX						; Preserves the X Register.
LDX $15E9					; Loads the sprite index.
LDA $D8,X					;\
CLC						; |
ADC #$0C					; |
STA $1715,Y					; | Sets and offsets the Spin Jump Star's Y position.
LDA $14D4,X					; |
ADC #$00					; |
STA $1729,Y					;/
LDA $E4,X					;\
CLC						; |
ADC #$04					; |
STA $171F,Y					; | Sets and offsets the Spin Jump Star's X position.
LDA $14E0,X					; |
ADC #$00					; |
STA $1733,Y					;/
PLX						; Pulls back the X Register.
LDA $07FC33,X					;\
STA $1747,Y					;/ Sets the X speed of the Spin Jump Star.
LDA $07FC37,X					;\
STA $173D,Y					;/ Sets the Y speed of the Spin Jump Star.
LDA #$17					;\
STA $176F,Y					;/ Sets the timer to display the Spin Jump Star.
RTL						; Ends the almost duplicate code.

QUEUEANIMATION:
PHA						; Preserves the loaded animation pointer.
;LDA !DynamicSwitch				;\
;BEQ NOQUEUE					;/ Branches if the dynamic routine has not happened yet.
STZ !AnFramePointer				; Resets the animated frame pointer.
PLA						; Pulls back the loaded animation pointer.
STA !AnPointer					; Sets the animation to use x2.
LDA #$00					;\
STA !AnimationTimer				;/ Sets the animation timer.
JSR Graphics					; Jumps to the graphics to prevent a glitch.
RTS						; RTS means to end a routine.
;NOQUEUE:
;PLA						; Pulls back the loaded animation pointer.
;RTS						; Ends the code.

SPAWNITEM:
JSL $82A9DE					; Jumps to the find sprite slot routine.
BMI ITEMSLOTSFULL				; Branches if there are no free sprite slots.
LDA $1FD6,x					; Loads the item to spawn sprite table.
STA $9E,y					; Sets the sprite number.
LDA #$01					;\
STA $14C8,y					;/ Initializes the sprite.
LDA $E4,x					;\
STA $E4,y					; |
LDA $14E0,x					; | Sets the spawned sprite's X position to the one it spawned from.
STA $14E0,y					;/
LDA $D8,x					;\
STA $D8,y					; |
LDA $14D4,x					; | Sets the spawned sprite's Y position to the one it spawned from.
STA $14D4,y					;/
PHX						; Preserves the X Register.
TYX						; Transfers the Y Register to the X Register.
JSL $87F7D2					; Resets the spawned sprite's sprite tables.
%SubHorzPos()					;\
TYA						; | Makes the sprite face Mario.
STA $157C,x					;/
LDA $9E,x					;\
CMP #$77					; | Branches if the spawned sprite is not a Cape Feather.
BEQ NOGRAVITY					;/
LDA #$C0					;\
STA $AA,x					;/ Sets the spawned sprite's Y speed.
LDA #$20					;\
STA $154C,x					;/ Sets the disable interaction timer.
JSL $81802A					; Applies the speed with gravity.
BRA FINISHITEMSPAWN				; Branches to the finish item spawn routine.
NOGRAVITY:
LDA #$D0					;\
STA $AA,x					;/ Sets the spawned sprite's Y speed.
LDA #$2C					;\
STA $154C,x					;/ Sets the disable interaction timer.
JSL $81801A					;\
JSL $818022					;/ Applies the speed without gravity.
FINISHITEMSPAWN:
PLX						; Pulls back the X Register.
LDA #$02					;\
STA $1DFC					;/ Sets the sound to play.
ITEMSLOTSFULL:
RTS						; Ends the code.

RANDOMIZER:
PHX						; Preserves the X Register.
PHP						; Preserves the Processor Flags.
SEP #$30					; Turns on 8-bit addressing for the A, X, and Y Registers.
PHA						; Preserves the Accumulator.
JSL $81ACF9					; Jumps to the random number generation routine.
PLX						; Pulls back the X Register.
CPX #$FF					;\
BNE NORMALRNG					;/ Branches if the X Register value is not 256.
LDA $148D					; Loads the random number generated.
BRA ENDRNG					; Branches to the end of the random number routine.
NORMALRNG:
INX						; Increments the X Register.
LDA $148D					; Loads the random number generated.
STA $4202					;\
STX $4203					;/ Stores the random number and the X Register to the multiplication registers.
NOP						;\
NOP						; | Waits for 8 cycles to pass by.
NOP						; | NOPs are needed to waste time.
NOP						;/
LDA $4217					; Loads the high byte of the product created by the multiplication registers.
ENDRNG:
PLP						; Pulls back the Processor Flags.
PLX						; Pulls back the X Register.
RTL						; Ends the code.

CHECKFORWALL:
LDA $1588,x					; Loads the sprite blocked status table.
AND #$03					; Sets the bits if the sprite is touching a wall.
RTS						; Ends the code.

ALLOWEDCLIPPING: db $02,$0D

WMSMAGICIAN:
JSL $819138					; Makes the sprite interact with objects.
LDA $1594,x					;\
ASL						;/ Loads the phases of the sprite
TAX						; Transfers the Accumulator to the X Register.
JSR.w (PHASES,x)				; Jumps to the indexed phases.
WMSMAGICIAN2:
JSL $819138					; Makes the sprite interact with objects.
JSR CHECKFORWALL				; Jumps to the wall detection routine.
BEQ NOTTOUCHINGWALL				; Branches if the sprite is not touching a wall.
LDA $1588,x					; Loads the sprite blocked status table.
AND #$03					; Keeps the wall contact bits.
LSR						; Divides the wall contact bits by 2.
TAY						; Transfers the Accumulator to the Y Register.
LDA $E4,x					;\
AND #$F0					;/ Loads the sprite's X position and only allows it to be multiples of 16.
ORA ALLOWEDCLIPPING,y				; Offsets the allowed positions.
STA $E4,x					; Stores the new X position, which results in the sprite being pushed out of the wall.
NOTTOUCHINGWALL:
LDA $1588,x					; Loads the sprite blocked status table.
AND #$08					; Sets the bits if the sprite is touching a ceiling.
BEQ NOCEILING					; Branches if the sprite is not touching a ceiling.
STZ $AA,x					; Sets the Y speed to 0.
NOCEILING:
LDA !GlobalFlipper				;\
AND $157C,x					; | Branches if the sprite's flipping matches with its direction.
BEQ KEEPDIRECTON				;/
JSL SPRITEFLIPPING				; Jumps to the sprite flipping routine.
KEEPDIRECTON:
JSR SPRITECONTACT				; Jumps to the sprite interaction routine.
JSR LIGHTNINGCONTACT				; Jumps to the lightning interaction routine.
JSR GraphicManager				; Manages the frames of the sprite and decides what frames to show.
RTS						; Ends the code.

SPRITECONTACT:
LDA $1540,x					;\
BNE NOCONTACT					;/ Branches if the spawn timer is not 0.
JSL $81A7DC					; Jumps to the sprite interaction with Mario.
BCC NOCONTACT					; Branches if there is no contact.
LDA $154C,x					;\
BNE NOCONTACT					;/ Branches if the invincibility timer is not 0.
LDA $160E,x					;\
BEQ NOCONTACT					;/ Branches if the sprite has 0 Health Points.
LDA $1594,x					;\
CMP #$0D					; | Branches if the sprite is stunned.
BEQ DIFFERENTCONTACT				;/
%SubVertPos()					; Checks Mario and the sprite's vertical position.
LDA $0E						;\
CMP #$E6					;/ Checks if Mario is hitting the sprite from the top side.
BPL SPRITEWINS					; Branches if he is touching from any side but the top.
LDA $7D						;\
BMI NOCONTACT					;/ Branches if Mario is ascending.
JMP KILLIT					; Jumps to the hurt sprite routine.
DIFFERENTCONTACT:
%SubVertPos()					; Checks Mario and the sprite's vertical position.
LDA $0E						;\
CMP #$F6					;/ Checks if Mario is hitting the sprite from the top side.
BPL NOCONTACT					; Branches if he is touching from any side but the top.
LDA $7D						;\
BMI NOCONTACT					;/ Branches if Mario is ascending.
JMP KILLIT					; Jumps to the hurt sprite routine.
SPRITEWINS:
LDA $1594,x					;\
CMP #$0C					; | Branches if the sprite is struck.
BEQ NOCONTACT					;/
LDA $1490					;\
BNE NOCONTACT					;/ Branches if Mario is invincible.
JSL $80F5B7					; Hurts Mario.
NOCONTACT:
RTS						; Ends the code.

KILLIT:
JSL $81AB99					; Displays the star smash graphic.
JSL $81AA33					;\
LDA #$A0					; | Sets Mario's Y speed.
STA $7D						;/
LDA $1594,x					;\
CMP #$0D					; | Branches if the sprite state is not stunned, damaged, or dying.
BCC USEDEFAULTINTERACTION			;/
LDA !AnPointer					;\
CMP #$14					; | Branches if the hurt animation is queued.
BEQ HURTING					;/
LDA #$14					;\
JSR QUEUEANIMATION				;/ Queues the hurt animation.
HURTING:
LDA #$40					;\
STA $154C,x					;/ Sets the invincibility timer.
LDA #$13					;\
STA $1DF9					; |
LDA #$28					; | Sets the sounds to play.
STA $1DFC					;/
DEC $160E,x					; Decrements the sprite's HP.
LDA $160E,x					;\
BEQ DIENOW					;/ Branches if the sprite has 0 Health Points.
LDA #$0E					;\
STA $1594,x					;/ Sets the sprite state to damaged.
RTS						; Ends the code.

USEDEFAULTINTERACTION:
LDA #$02					;\
STA $1DF9					;/ Sets the sound to play.
LDA #$02					;\
STA $154C,x					;/ Sets the invincibility timer.
LDA $1594,x					;\
CMP #$01					; | Branches if the sprite is not walking.
BCC NOFLICKING					;/
CMP #$05					;\
BCS NOFLICKING					;/ Branches if the sprite is flicking fireballs or is not doing other fireball related moves.
LDA $140D					;\
BNE SPINJUMPING					;/ Branches if Mario is spin jumping
LDA $1490					;\
BNE SPINJUMPING					;/ Branches if Mario is invincible.
JSL $80F5B7					; Hurts Mario.
SPINJUMPING:
LDA #$05					;\
STA $1594,x					;/ Sets the sprite state to flicking fireballs.
STZ $187B,x					; Resets the sub-phases.
STZ $1564,x					;\
STZ $15AC,x					;/ Resets the rapidly shooting fireballs timers.
STZ !ExtraSpriteTable2				; Resets the fireball count.
NOFLICKING:
;LDA $1697					;\
;CLC						; | Increases the number of consecutive enemies stomped.
;ADC $1626,x					; |
;INC $1697					;/
;LDA $1697					;\
;CMP #$08					; | Branches if the number of consecutive enemies stomped is less than 8.
;BCC FEWERTHANEIGHT2				;/
;LDA #$08					;\ Keeps the number killed at 8.
;STA $1697					;/
;FEWERTHANEIGHT2:
;JSL $82ACE5					; Gives Mario points.
RTS						; Ends the code

DIENOW:
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ NOMUTE					;/
LDA #!MuteMusic					;\
STA $1DFB					;/ Mutes the music.
NOMUTE:
LDA #$0F					;\
STA $1594,x					;/ Sets the sprite state to dying.
RTS						; Ends the code.

LIGHTNINGCONTACT:
LDA $1594,x					;\
CMP #$0A					; | Branches if the sprite is not casting lightning.
BNE NOLIGHTNINGCONCTACT2			;/
PHX						; Preserves the X Register.
LDX #07						; Loads a loop count of 7.
LIGHTNINGCONTACTLOOP:
LDA $7FBA70,x					;\
BEQ NOLIGHTNINGCONCTACT				;/ Branches if there are no active lightning sprites.
LDY $15E9					; Reloads the sprite index.
LDA $E4,y					;\
SEC						; | Subtracts the sprite's X position from the lightning's X position.
SBC $7FBA78,x					;/
CLC						;\
ADC #$0C					; | Sets the width of the lightning sprite's hitbox.
CMP #$18					;/
BCS NOLIGHTNINGCONCTACT				; Branches if there is no contact.
LDA $D8,y					;\
SEC						; |
SBC $7FBA88,x					; |
STA $00						; | Subtracts the sprite's Y position from the lightning's Y position.
LDA $14D4,y					; |
SBC #$00					; |
STA $01						;/
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $00						;\
CLC						; | Sets the top height of the lightning sprite's hitbox.
ADC #$0180					; |
CMP #$0160					;/
BCC NOLIGHTNINGCONCTACT				; Branches if there is no contact.
CMP #$0240					; Sets the bottom height of the lightning sprite's hitbox.
BCS NOLIGHTNINGCONCTACT				; Branches if there is no contact.
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
PLX						;
LDA !AnPointer					;\
CMP #$14					; | Branches if the hurt animation is queued.
BEQ SHOCKING					;/
LDA #$14					;\
JSR QUEUEANIMATION				;/ Queues the hurt animation.
SHOCKING:
LDA #$13					;\
STA $1DF9					;/ Sets the sound to play.
LDA #$D0					;\
STA $AA,x					;/ Sets the sprite's Y speed.
LDA #$0C					;\
STA $1594,x					;/ Sets the sprite state to struck by lightning.
STZ $187B,x					; Resets the sub-state.
RTS						; Ends the code.
NOLIGHTNINGCONCTACT:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
DEX						; Decrements the loop count.
BPL LIGHTNINGCONTACTLOOP			; Loops the lightning loop until it is -1.
PLX						; Pulls back the X Register.
NOLIGHTNINGCONCTACT2:
RTS						; Ends the code

PHASES:
dw NOINTRO
dw WALKING
dw SHOOTFIRE
dw JUMPSHOT
dw RAPIDSHOT
dw FLICKSHOT
dw ASCENDING
dw FLYING
dw BLIZZARD
dw EARTHSLIDE
dw LIGHTNING
dw DESCEND
dw STRUCK
dw STUNNED
dw DAMAGED
dw DEATH

CALCULATENEXTMOVE:
LDA $E4,x					; Loads the sprite's X position.
REP #$20					; Turns on 16-bit addressing for the Accumulator.
CLC						;\
ADC $94						;/ Adds Mario's X position to the Accumulator.
ADC $13						; Adds the current frame counter to the Accumulator.
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
ADC $140D					; Adds the spin jumping flag to the Accumulator.
REP #$20					; Turns on 16-bit addressing for the Accumulator.
SEC						;\
SBC $96						;/ Subtracts Mario's Y position from the Accumulator.
STA $4204					; Stores the result to the dividend registers.
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$02					;\
STA $4206					;/ Divides the result by two.
NOP						;\
NOP						; |
NOP						; |
NOP						; | Waits for 16 cycles to pass by.
NOP						; | NOPs are needed to waste time.
NOP						; |
NOP						; |
NOP						;/
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $4216					;\
BEQ EVEN					;/ Branches if the remainder of the division operation is 0.
LDA $4214					;\
AND #$0002					; | Branches if ANDing with 2 is 0.
BEQ BITNOTSET					;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
STZ $1FD6,x					; Sets the next move index to 0.
RTS						; Ends the code.
BITNOTSET:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$03					;\
STA $1FD6,x					;/ Sets the next move index to 3.
RTS						; Ends the code.
EVEN:
LDA $4214					;\
AND #$0002					; | Branches if ANDing with 2 is 0.
BEQ BITNOTSET2					;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$01					;\
STA $1FD6,x					;/ Sets the next move index to 1.
RTS						; Ends the code.
BITNOTSET2:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$02					;\
STA $1FD6,x					;/ Sets the next move index to 2.
RTS						; Ends the code.

GLITTERSPAWN:
LDY #$03					; Loads a loop count of 3.
GLITTERLOOP:
LDA $17C0,Y					;\
BEQ SPAWNGLITTER				;/ Branches if the sprite slot is 0.
DEY						; Decrements the loop count.
BPL GLITTERLOOP					; Loops the Coin Glitter loop until it is -1.
RTL						; It ends the code.
SPAWNGLITTER:
LDA #$05					;\
STA $17C0,Y					;/ Sets the sprite to a Coin Glitter.
LDA $E4,X					;\
STA $17C8,Y					; |
LDA $14E0,X					; | Sets the Coin Glitter's X position.
STA $18C9,Y					;/
LDA $D8,X					;\
SEC						; |
SBC #$0D					; |
STA $17C4,Y					; |
LDA $14D4,X					; | Sets the Coin Glitter's Y position.
CLC						; |
ADC #$00					; |
STA $18C5,Y					;/
LDA #$10					;\
STA $17CC,Y					;/ Sets the Coin Glitter timer.
RTL						; Ends the code. I actually stole part of this code from Nintendo.

NOINTRO:
LDX $15E9					; Reloads the sprite index.
LDA $1540,x					;\
BNE HIDE					;/ Branches if the spawn timer is not 0.
STZ $00						; Sets the X offsets of the smoke.
LDA #$08					;\
STA $01						;/ Sets the Y offsets of the smoke.
LDA #$1B					;\
STA $02						;/ Sets the timer for the smoke sprite.
LDA #$01					;\
%SpawnSmoke()					;/ Spawns the smoke sprite.
LDA #$10					;\
STA $1DF9					;/ Sets the sound to play.
INC $1594,x					; Increments the sprite state so it gets out of this state.
LDA #$60					;\
STA $1558,x					;/ Sets the state timer.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
HIDE:
RTS						; Obviously ends the code.

WALKINGXSPEED: db $10,$F0

POSSIBLESTATES: db $01,$02,$03,$04
POSSIBLESTATETIMERSFROMWALK: db $30,$10,$01,$20

WALKING:
LDX $15E9					; Reloads the sprite index.
LDA !AnPointer					;\
BEQ MOVING					;/ Branches if the walking animation is queued.
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
MOVING:
LDA $1558,x					;\
BNE KEEPWALKING					;/ Branches if the walk timer is not 0.
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE				;/
STZ !ExtraSpriteTable2				; Sets the fireball counter to 0.
LDA #$06					;\
STA $1594,x					;/ Sets the sprite state to ascending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the ascent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code, of course.
REGULARMOVECHANGE:
%SubHorzPos()					; Gets the X position of Mario relative to the sprite.
TYA						; Transfers the Y Register to the Accumulator.
CMP $157C,x					;\
BNE KEEPMOVE					;/ Branches if the sprite is facing Mario.
LDA $1FD6,x					;\
BNE KEEPMOVE					;/ Branches if the next move index is not walking.
INC $1FD6,x					; Sets the next move index to shoot fire.
KEEPMOVE:
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLESTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMWALK,y		;\
STA $1558,x					;/ Sets the state timer from the walking state.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER				; Branches to the store fireball delay time routine.
MORERAPID:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER:
STA $1564,x					; Stores the fireball delay time.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Finishes the code.
KEEPWALKING:
LDY $157C,x					;\
LDA WALKINGXSPEED,y				; | Loads and stores the sprite's X speed.
STA $B6,x					;/
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ NOSPEED					;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
NOSPEED:
JSL $81802A					; Applies the speed with gravity.
RTS						; Ends the code.

FIRBALLXOFFSETS: db $0D,$F3
FIREBALLYSPEEDS: db $00,$E0
POSSIBLESTATETIMERSFROMSHOOTING: db $40,$08,$10,$20

SHOOTFIRE:
LDX $15E9					; Reloads the sprite index.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ SHOOTFALLING				;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
SHOOTFALLING:
STZ $B6,x					; Sets the sprite's X speed to 0.
JSL $81802A					; Applies the speed with gravity.
LDA $187B,x					;\
BNE CHARGE					;/ Branches if the sprite sub-state is not standing.
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
LDA $1558,x					;\
BNE STAND					;/ Branches if the stand timer is not 0.
LDA #$01					;\
STA $187B,x					;/ Sets the sprite sub-state to charging.
LDA #$19					;\
STA $1558,x					;/ Sets the charge timer.
STAND:
RTS						; It ends the code.
CHARGE:
LDA $187B,x					;\
CMP #$02					; | Branches if the sprite sub-phase is shooting.
BCS SHOOT					;/
LDA !AnPointer					;\
CMP #$08					; | Branches if the charging animation is queued.
BEQ CHARGING					;/
LDA #$08					;\
JSR QUEUEANIMATION				;/ Queues the charging animation.
CHARGING:
LDA $1558,x					;\
BNE KEEPCHARGING				;/ Branches if the charge timer is not 0.
LDA #$02					;\
STA $187B,x					;/ Sets the sprite sub-state to shooting.
LDA #$10					;\
STA $1558,x					;/ Sets the shoot timer.
KEEPCHARGING:
RTS						; RTS means ReTurn from Subroutine. In other words, it ends the code.
SHOOT:
LDA !AnPointer					;\
CMP #$0C					; | Branches if the shooting animation is queued.
BEQ SHOOTING					;/
LDA #$0C					;\
JSR QUEUEANIMATION				;/ Queues the shooting animation.
SHOOTING:
LDA $187B,x					;\
CMP #$03					; | Branches if the sprite sub-phase is end shooting.
BEQ ENDSHOOTING					;/
LDA $7FAB10,x					;\
AND #$04					; | Branches if extra bit is not set.
BEQ ONEFIREBALL					;/
LDA #$01					; Loads the number of fireballs to spawn.
BRA SPAWNLOOP					; Branches to the spawn fireball routine.
ONEFIREBALL:
LDA #$00					; Loads the number of fireballs to spawn.
SPAWNLOOP:
PHA						; Preserves the Accumulator.
PHX						; Preserves the X Register.
TAX						; Transfers the Accumulator to the X Register.
LDA FIREBALLYSPEEDS,x				;\
STA $03						;/ Loads and stores the Y speed of the fireballs.
PLX						; Pulls back the X Register.
LDY $157C,x					;\
LDA FIRBALLXOFFSETS,y				; | Sets the X offsets of each fireball based of the sprite's direction.
STA $00						;/
LDA #$08					;\
STA $01						;/ Sets the Y offset of each fireball.
LDA #!FireballNumber				;\
SEC						; | Spawns the fireball.
%SpawnSprite()					;/
LDA #$01					;\
STA $C2,y					;/ Prevents the fireball from facing Mario.
LDA $157C,x					;\
STA $157C,y					;/ Sets the sprite's direction to the fireball's direction.
LDA #$00					;\
STA $1510,y					;/ Sets the fireball curve angle flag to 0.
PHX						; Preserves the X Register.
TYX						; Transfers the Y Register to the X Register.
LDA $7FAB10,x					;\
ORA #$04					; | Sets the extra bit of the fireball.
STA $7FAB10,x					;/
TXY						; Transfers the X Register to the Y Register.
PLX						; Pulls back the X Register.
PLA						; Pulls back the Accumulator.
DEC						; Decreases the fireball counter.
BPL SPAWNLOOP					; Loops the fireball spawning routine until it is -1.
LDA #$03					;\
STA $187B,x					;/ Sets the sprite sub-state to end shooting.
LDA #$19					;\
STA $1558,x					;/ Sets the end shooting timer.
ENDSHOOTING:
LDA $1558,x					;\
BNE TIMEDSHOT					;/ Branches if the end shooting timer is not 0.
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE2				;/
STZ !ExtraSpriteTable2				; Resets the fireball counter.
LDA #$06					;\
STA $1594,x					;/ Sets the sprite state to ascending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the ascent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
REGULARMOVECHANGE2:
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLESTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMSHOOTING,y		;\
STA $1558,x					;/ Sets the state timer from the shoot fire state.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID2					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER2				; Branches to the store fireball delay time routine.
MORERAPID2:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER2:
STA $1564,x					; Stores the fireball delay time.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
JSL FINISHINIT					; Jumps to the face Mario routine.
TIMEDSHOT:
RTS						; It ends the code. What did you think it did?

JUMPXSPEED: db $02,$FE
AIRFIREBALLYSPEEDS: db $3A,$10
AIRFIREBALLXSPEEDS: db $E8,$D8
AIRFIREBALLXSPEEDS2: db $18,$28
ANGLEFLAGS: db $01,$00
POSSIBLESTATETIMERSFROMAIRSHOOTING: db $20,$04,$20,$20

JUMPSHOT:
LDX $15E9					; Reloads the sprite index.
LDA $187B,x					;\
BNE NOJUMP					;/ Branches if the sprite sub-phase is not standing.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ NOJUMPING					;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
LDA $1558,x					;\
BEQ MOVE					;/ Branches if the stand timer is 0.
NOJUMPING:
STZ $B6,x					; Sets the sprite's X speed to 0.
JSL $81802A					; Applies the speed with gravity.
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
RTS						; Ends the code.
MOVE:
LDY $157C,x					;\
LDA JUMPXSPEED,y				; | Loads and stores the sprite's X speed.
STA $B6,x					;/
LDA #$A0					;\
STA $AA,x					;/ Sets the sprite's Y speed.
JSL $81802A					; Applies the speed with gravity.
LDA !AnPointer					;\
CMP #$02					; | Branches if the jumping animation is queued.
BEQ JUMPING					;/
LDA #$02					;\
JSR QUEUEANIMATION				;/ Queues the jumping animation.
JUMPING:
LDA #!JumpSFX					;\
STA !JumpSFXBank				;/ Sets the sound to play.
STA $187B,x					; Sets the sprite sub-phase to jumping and charging.
LDA #$07					;\
STA $1558,x					;/ Sets the jump timer.
NOJUMP:
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ NOJUMPSPEED					;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
JSL $81802A					; Applies the speed with gravity.
NOJUMPSPEED:
LDA $187B,x					;\
CMP #$02					; | Branches if the sprite sub-phase is air shooting.
BCS FALLSHOOT					;/
LDA $1558,x					;\
BNE FALLCHARGE					;/ Branches if the jump timer is not 0.
LDA !AnPointer					;\
CMP #$0A					; | Branches if the flying and charging animation is queued.
BEQ FALLCHARGE					;/
LDA #$0A					;\
JSR QUEUEANIMATION				;/ Queues the flying and charging animation.
FALLCHARGE:
LDA $AA,x					;\
BPL AIRSHOOT					;/ Branches if the sprite's Y speed is positive.
JMP APPLYJUMP					; Jumps to the apply jump speed routine.
AIRSHOOT:
LDA !AnPointer					;\
CMP #$10					; | Branches if the flying and shooting animation is queued.
BEQ MAXFALL					;/
LDA #$10					;\
JSR QUEUEANIMATION				;/ Queues the flying and shooting animation.
MAXFALL:
LDA #$02					;\
STA $187B,x					;/ Sets the sprite sub-phase to falling and shooting.
BRA APPLYJUMP					; Branches to the apply jump speed routine.
FALLSHOOT:
LDA $187B,x					;\
CMP #$03					; | Branches if the sprite sub-phase is end air shooting.
BCS AIRSHOOTEND					;/
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ ONEAIRFIREBALL				;/
LDA #$01					; Loads the number of fireballs to spawn.
BRA SPAWNLOOP2					; Branches to the spawn fireball routine.
ONEAIRFIREBALL:
LDA #$00					; Loads the number of fireballs to spawn.
SPAWNLOOP2:
PHA						; Preserves the Accumulator twice.
PHA						; One is for the spawn loop; one is for indexing the X speed.
PHX						; Preserves the X Register.
TAX						; Transfers the Accumulator to the X Register.
LDA AIRFIREBALLYSPEEDS,x			;\
STA $03						;/ Loads and stores the Y speed of each fireball.
LDA ANGLEFLAGS,x				;\
STA $04						;/ Loads and stores the fireball curve angle flag for each fireball into scratch RAM.
PLX						; Pulls back the X Register.
LDY $157C,x					;\
BEQ RIGHTAIR					;/ Branches if the sprite's direction is right.
PLA						; Pulls back the Accumulator.
PHX						; Preserves the X Register.
TAX						; Transfers the Accumulator to the X Register.
LDA AIRFIREBALLXSPEEDS,x			;\
STA $02						;/ Loads and stores the X speed of each fireball.
BRA STOREAIROFFSETS				; Branches to the store air fireball offsets routine.
RIGHTAIR:
PLA						; Pulls back the Accumulator.
PHX						; Preserves the X Register.
TAX						; Transfers the Accumulator to the X Register.
LDA AIRFIREBALLXSPEEDS2,x			;\
STA $02						;/ Loads and stores the X speed of each fireball.
STOREAIROFFSETS:
PLX						; Pulls back the X Register.
LDA FIRBALLXOFFSETS,y				;\
STA $00						;/ Stores the X offsets of the fireballs based on the sprite's direction.
LDA #$08					;\
STA $01						;/ Stores the Y offsets of the fireballs.
LDA #!FireballNumber				;\
SEC						; | Spawns the fireball.
%SpawnSprite()					;/
LDA #$01					;\
STA $C2,y					;/ Prevents the fireball from facing Mario.
STA $1504,y					; Sets the custom X speed flag.
LDA $157C,x					;\
STA $157C,y					;/ Sets the sprite's direction to the fireball's direction.
LDA $04						;\
STA $1510,y					;/ Sets the fireball curve angle flag for each fireball.
PHX						; Preserves the X Register.
TYX						; Transfers the Y Register to the X Register.
LDA $7FAB10,x					;\
ORA #$04					; | Sets the extra bit of the fireball.
STA $7FAB10,x					;/
TXY						; Transfers the X Register to the Y Register.
PLX						; Pulls back the X Register.
PLA						; Pulls back the Accumulator.
DEC						; Decreases the fireball counter.
BPL SPAWNLOOP2					; Loops the fireball spawning routine until it is -1.
LDA #$03					;\
STA $187B,x					;/ Sets the sprite sub-state to end air shooting.
APPLYJUMP:
JSL $81802A					; Applies the speed with gravity.
RTS						; Ends the code.
AIRSHOOTEND:
LDA $187B,x					;\
CMP #$04					; | Branches if the sprite sub-state is air shooting cooldown.
BCS COOLDOWN					;/
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ APPLYJUMP					;/
LDA #$19					;\
STA $1558,x					;/ Sets the cooldown timer.
LDA #$04					;\
STA $187B,x					;/ Sets the sprite sub-state to air shooting cooldown.
COOLDOWN:
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ AIRSHOTFALLING				;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
AIRSHOTFALLING:
STZ $B6,x					; Sets the sprite's X speed to 0.
JSL $81802A					; Applies the speed with gravity.
LDA $1558,x					;\
BNE TIMEDAIRSHOT				;/ Branches if the cooldown timer is not 0.
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE3				;/
STZ !ExtraSpriteTable2				; Resets the fireball counter.
LDA #$06					;\
STA $1594,x					;/ Sets the sprite state to ascending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the ascent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
REGULARMOVECHANGE3:
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLESTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMAIRSHOOTING,y	;\
STA $1558,x					;/ Sets the state timer from the jump shot state.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID3					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER3				; Branches to the store fireball delay time routine.
MORERAPID3:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER3:
STA $1564,x					; Stores the fireball delay time.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
JSL FINISHINIT					; Jumps to the face Mario routine.
TIMEDAIRSHOT:
RTS						; Ends the code for obvious reasons.

RAPIDXSPEED: db $08,$F8
RAPIDFIRBALLYSPEEDS: db $00,$E0,$F0,$E0,$00,$F0,$00,$E0,$F0,$E0,$00,$F0
POSSIBLESTATETIMERSFROMRAPIDSHOOTING: db $10,$08,$10,$20

RAPIDSHOT:
LDX $15E9					; Reloads the sprite index.
LDA $187B,x					;\
BNE MAINRAPIDFIRE				;/ Branches if the sprite sub-phase is not initialize movement.
LDY $157C,x					;\
LDA RAPIDXSPEED,y				; | Sets the initial X speed based on the sprite's direction.
STA $B6,x					;/
LDA !ExtraSpriteTable2				;\
BNE MAINRAPIDFIRE				;/ Branches if the fireball counter is not 0.
LDA !AnPointer					;\
CMP #$08					; | Branches if the charging animation is queued.
BEQ MAINRAPIDFIRE				;/
LDA #$08					;\
JSR QUEUEANIMATION				;/ Queues the charging animation.
MAINRAPIDFIRE:
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ RAPIDFALLING				;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
RAPIDFALLING:
JSL $81802A					; Applies the speed with gravity.
LDA $187B,x					;\
CMP #$06					; | Branches if the turn counter is less than 6.
BCC STARTRAPIDSHOOTING				;/
STZ $B6,x					; Resets the sprite's speed.
LDA $15AC,x					;\
BEQ ENDRAPIDSHOOTING				;/ Branches if the rapid shot cooldown timer is 0.
RTS						; Ends the code.
ENDRAPIDSHOOTING:
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE4				;/
STZ !ExtraSpriteTable2				; Resets the fireball counter.
LDA #$06					;\
STA $1594,x					;/ Sets the sprite state to ascending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the ascent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
REGULARMOVECHANGE4:
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLESTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMRAPIDSHOOTING,y	;\
STA $1558,x					;/ Sets the state timer from the rapid shot state.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID6					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER5				; Branches to the store fireball delay time routine.
MORERAPID6:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER5:
STA $1564,x					; Stores the fireball delay time.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
STZ !ExtraSpriteTable2				; Resets the fireball counter.
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
STARTRAPIDSHOOTING:
LDA $1558,x					;\
BNE APPLYRAPIDSPEED				;/ Branches if the move timer is not 0.
LDA $B6,x					;\
EOR #$FF					; |
INC A						; | Inverts the sprite's X speed.
STA $B6,x					;/
INC $187B,x					; Increments the turn counter.
LDA #$20					;\
STA $1558,x					;/ Sets the move timer.
APPLYRAPIDSPEED:
LDA $1564,x					;\
BNE NORAPID					;/ Branches if the fireball delay time is not 0.
LDA !AnPointer					;\
CMP #$0C					; | Branches if the shooting animation is queued.
BEQ RAPIDSHOOTING				;/
LDA #$0C					;\
JSR QUEUEANIMATION				;/ Queues the shooting animation.
RAPIDSHOOTING:
LDY !ExtraSpriteTable2				; Loads the fireball counter index.
LDA RAPIDFIRBALLYSPEEDS,y			;\
STA $03						;/ Stores the Y speed of each fireball.
LDY $157C,x					;\
LDA FIRBALLXOFFSETS,y				; | Stores the X offsets of the fireballs based on the sprite's direction.
STA $00						;/
LDA #$08					;\
STA $01						;/ Stores the Y offsets of the fireballs.
LDA #!FireballNumber				;\
SEC						; | Spawns the fireball.
%SpawnSprite()					;/
LDA #$01					;\
STA $C2,y					;/ Prevents the fireball from facing Mario.
LDA $157C,x					;\
STA $157C,y					;/ Sets the sprite's direction to the fireball's direction.
LDA #$00					;\
STA $1510,y					;/ Sets the fireball curve angle flag to 0.
PHX						; Preserves the X Register.
TYX						; Transfers the Y Register to the X Register.
LDA $7FAB10,x					;\
ORA #$04					; | Sets the extra bit of the fireball.
STA $7FAB10,x					;/
TXY						; Transfers the X Register to the Y Register.
PLX						; Pulls back the X Register.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID4					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER4				; Branches to the store fireball delay time routine.
MORERAPID4:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER4:
STA $1564,x					; Stores the fireball delay time.
LDA #$20					;\
STA $15AC,x					;/ Sets the rapid shot cooldown timer. 
INC !ExtraSpriteTable2				; Increments the fireball counter.
NORAPID2:
RTS						; Ends the code.
NORAPID:
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID5					;/
LDA $1564,x					;\
CMP #$11					; | Branches if the fireball delay time is 17 or more.
BCS NORAPID2					;/
RAPIDCHARGE:
LDA !AnPointer					;\
CMP #$08					; | Branches if the charging animation is queued.
BEQ NORAPIDCHARGE				;/
LDA #$08					;\
JSR QUEUEANIMATION				;/ Queues the charging animation.
NORAPIDCHARGE:
RTS						; Ends the code.
MORERAPID5:
LDA $1564,x					;\
CMP #$09					; | Branches if the fireball delay time is 9 or more.
BCS NORAPIDCHARGE				;/
BRA RAPIDCHARGE					; Branches to the change to charge animation routine.

FLICKDIRECTION: db $00,$01
FLICKXSPEED: db $10,$F0
POSSIBLESTATETIMERSFROMFLICKING: db $40,$10,$08,$20

FLICKSHOT:
LDX $15E9					; Reloads the sprite index.
LDA !AnPointer					;\
CMP #$0E					; | Branches if the flicking animation is queued.
BEQ FLICKING					;/
LDA #$0E					;\
JSR QUEUEANIMATION				;/ Queues the flicking animation.
FLICKING:
STZ $B6,x					; Resets the sprite's speed.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ FLICKFALLING				;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
FLICKFALLING:
JSL $81802A					; Applies the speed with gravity.
LDA $187B,x					;\
BNE FLICKINGCOOLDOWN				;/ Branches if the sprite sub-phase is not flicking fireballs.
LDA #$01					; Loads the number of fireballs to spawn.
FLICKLOOP:
PHA						; Preserves the Accumulator.
TAY						; Transfers the Accumulator to the Y Register.
LDA FLICKDIRECTION,y				;\
STA $04						;/ Sets the direction of each fireball through scratch RAM.
LDA FLICKXSPEED,y				;\
STA $02						;/ Sets the X speed of each fireball.
STZ $00						;\
STZ $01						;/ Resets the X and Y offsets of each fireball.
LDA #$D0					;\
STA $03						;/ Sets the Y speed of each fireball.
LDA #!FireballNumber				;\
SEC						; | Spawns the fireball.
%SpawnSprite()					;/
LDA #$01					;\
STA $C2,y					;/ Prevents the fireball from facing Mario.
STA $1504,y					; Sets the custom X speed flag.
LDA $04						;\
STA $157C,y					;/ Sets the direction of each fireball.
LDA #$00					;\
STA $1510,y					;/ Sets the fireball curve angle flag to 0.
LDA #$01					;\
STA $151C,y					;/ Sets the gravity flag to 0.
PHX						; Preserves the X Register.
TYX						; Transfers the Y Register to the X Register.
LDA $7FAB10,x					;\
ORA #$04					; | Sets the extra bit of the fireball.
STA $7FAB10,x					;/
TXY						; Transfers the X Register to the Y Register.
PLX						; Pulls back the X Register.
PLA						; Pulls back the Accumulator.
DEC						; Decreases the fireball counter.
BPL FLICKLOOP					; Loops the fireball spawning routine until it is -1.
LDA #$01					;\
STA $187B,x					;/ Sets the sprite sub-phase to flicking cooldown.
LDA #$30					;\
STA $1558,x					;/ Sets the flicking cooldown timer.
RTS						; Ends the code.
FLICKINGCOOLDOWN:
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ PROLONGCOOLDOWN				;/
LDA $1558,x					;\
BNE TIMEDFLICKING				;/ Branches if the cooldown timer is not 0.
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLESTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMFLICKING,y		;\
STA $1558,x					;/ Sets the state timer from the flick shot state.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID7					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER6				; Branches to the store fireball delay time routine.
MORERAPID7:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER6:
STA $1564,x					; Stores the fireball delay time.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
PROLONGCOOLDOWN:
LDA #$30					;\
STA $1558,x					;/ Sets the flicking cooldown timer infinitely.
TIMEDFLICKING:
RTS						; If you guessed that RTS ends the code, then congratulations! Here is your Star Piece!

POSSIBLEAIRSTATES: db $07,$08,$09,$0A
POSSIBLESTATETIMERSFROMASCENDING: db $30,$10,$08,$10

ASCENDING:
LDX $15E9					; Reloads the sprite index.
STZ !ExtraSpriteTable1				; Resets the moves counter.
LDA $187B,x					;\
BNE STARTASCENDING				;/ Branches if the sprite sub-state is not prepare ascent.
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
STZ $B6,x					; Resets the sprite's X speed.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ ASCENDFALLING				;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
ASCENDFALLING:
JSL $81802A					; Applies the speed with gravity.
LDA $1558,x					;\
BNE PREPAREASCENT				;/ Branches if the prepare ascent timer is not 0.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air
BEQ STARTASCENT					;/
INC $187B,x					; Sets the sprite sub-state to start ascending.
STARTASCENT:
RTS						; Ends the code.
PREPAREASCENT:
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air
BEQ DELAYASCENT					;/
LDA $D8,x					;\
SEC						; |
SBC #$74					; |
STA !ExtraSpriteTable2				; | Offsets the sprite's Y position and stores it as the Y destination.
LDA $14D4,x					; |
SBC #$00					; |
STA !ExtraSpriteTable3				;/
DELAYASCENT:
RTS						; Ends the code. It should be dead obvious now.
STARTASCENDING:
CMP #$02					;\
BCS LOCKPOSITION				;/ Branches if the sprite sub-state is not lock position.
LDA !AnPointer					;\
CMP #$02					; | Branches if the jumping animation is queued.
BEQ ASCENDJUMPING				;/
LDA #$02					;\
JSR QUEUEANIMATION				;/ Queues the jumping animation.
LDA #!JumpSFX					;\
STA !JumpSFXBank				;/ Sets the sound to play.
LDA #$96					;\
STA $AA,x					;/ Sets the sprite's Y speed.
ASCENDJUMPING:
LDA $1588,x					;\
AND #$08					; | Branches if the sprite is touching a ceiling.
BNE LOCKPOSITION				;/
LDA !ExtraSpriteTable2				;\
STA $07						; |
LDA !ExtraSpriteTable3				; | Copies the Y destination into scratch RAM.
STA $08						;/
LDA $14D4,x					; Loads the high byte of the sprite's Y position.
XBA						; Swaps the high byte with the low byte.
LDA $D8,x					; Loads the low byte of the sprite's Y position.
REP #$20					; Turns on 16-bit addressing for the Accumulator.
CMP $07 					; Checks if the sprite's Y position is the same as its Y destination.
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
BEQ LOCKPOSITION				; Branches if the sprite's Y position is not the same as its Y destination.
JSL $81802A					; Applies the speed with gravity.
UNLOCKPOSITION:
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air
BEQ WAITFORGROUND				;/
LDA $D8,x					;\
SEC						; |
SBC #$74					; |
STA !ExtraSpriteTable2				; | Offsets the sprite's Y position and stores it as the Y destination.
LDA $14D4,x					; |
SBC #$00					; |
STA !ExtraSpriteTable3				;/
LDA #!JumpSFX					;\
STA !JumpSFXBank				;/ Sets the sound to play.
LDA #$96					;\
STA $AA,x					;/ Sets the sprite's Y speed.
WAITFORGROUND:
RTS						; Ends the code.
LOCKPOSITION:
LDA !AnPointer					;\
CMP #$06					; | Branches if the flying animation is queued.
BEQ FLY						;/
LDA #$06					;\
JSR QUEUEANIMATION				;/ Queues the flying animation.
LDA #$09					;\
STA $1DF9					;/ Sets the sound to play.
LDA #$02					;\
STA $187B,x					;/ Sets the sprite sub-state to lock position.
LDA #$30					;\
STA $1558,x					;/ Sets the ascent cooldown timer.
FLY:
STZ $AA,x					; Resets the sprite's Y speed.
JSL $81801A					;\
JSL $818022					;/ Applies the speed without gravity.
LDA $1558,x					;\
BNE KEEPASCENDING				;/ Branches if the ascending cooldown timer is not 0.
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLEAIRSTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMASCENDING,y		;\
STA $1558,x					;/ Sets the state timer from the ascending state.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
STZ !ExtraSpriteTable2				; Clears the Y destination.
JSL FINISHINIT					; Jumps to the face Mario routine.
KEEPASCENDING:
RTS						; Ends the code.

POSSIBLESTATETIMERSFROMFLYING: db $20,$14,$0C,$12

FLYING:
LDX $15E9					; Reloads the sprite index.
LDA $1558,x					;\
BNE KEEPFLYING					;/ Branches if the flying timer is not 0.
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE5				;/
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
LDA #$0B					;\
STA $1594,x					;/ Sets the sprite state to descending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the descent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; What this does is that it ends the code.
REGULARMOVECHANGE5:
%SubHorzPos()					; Gets the X position of Mario relative to the sprite.
TYA						; Transfers the Y Register to the Accumulator.
CMP $157C,x					;\
BNE KEEPMOVE2					;/ Branches if the sprite is facing Mario.
LDA $1FD6,x					;\
BNE KEEPMOVE2					;/ Branches if the next move index is not flying.
LDA #$03					;\
STA $1FD6,x					;/ Sets the next move index to cast lightning.
KEEPMOVE2:
JSL FORCELIGHTNING				; Jumps to the force lightning routine.
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLEAIRSTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMFLYING,y		;\
STA $1558,x					;/ Sets the state timer from the flying state.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Finishes the code.
KEEPFLYING:
LDY $157C,x					;\
LDA WALKINGXSPEED,y				; | Loads and stores the sprite's X speed.
STA $B6,x					;/
JSL $81801A					;\
JSL $818022					;/ Applies the speed without gravity.
RTS						; Ends the code.

SNOWFLAKEXPOSITIONS: db $FF,$FF,$2F,$8F,$FF,$BF,$FF,$FF,$4F,$9F,$FF,$DF,$FF,$FF,$CF,$7F,$FF,$AF,$FF,$FF,$EF,$8F,$FF,$BF
SNOWFLAKEYPOSITIONS: db $30,$10,$F0,$F0,$20,$F0,$98,$48,$F0,$F0,$10,$F0,$60,$30,$F0,$F0,$20,$F0,$08,$90,$F0,$F0,$40,$F0
SNOWFLAKEYPOSITIONS2: db $00,$00,$FF,$FF,$00,$FF,$00,$00,$FF,$FF,$00,$FF,$00,$00,$FF,$FF,$00,$FF,$00,$00,$FF,$FF,$00,$FF
SNOWFLAKEXPOSITIONS2: db $FF,$FF,$AF,$CF,$FF,$6F,$FF,$FF,$CF,$EF,$FF,$2F,$FF,$FF,$7F,$9F,$FF,$5F,$FF,$FF,$3F,$4F,$FF,$8F
SNOWFLAKEYPOSITIONS3: db $50,$40,$F0,$F0,$10,$F0,$58,$78,$F0,$F0,$20,$F0,$20,$40,$F0,$F0,$30,$F0,$A8,$10,$F0,$F0,$20,$F0
POSSIBLESTATETIMERSFROMBLIZZARD: db $40,$08,$26,$0C

BLIZZARD:
LDX $15E9					; Reloads the sprite index.
STZ !RegularStunFlag				; Resets the regular stun flag.
STZ $B6,x					; Resets the sprite's X speed.
JSL $81801A					;\
JSL $818022					;/ Applies the speed without gravity.
LDA $187B,x					;\
BNE CASTBLIZZARD				;/ Branches if the sprite sub-state is not prepare blizzard.
LDA $1558,x					;\
BNE PREPAREBLIZZARD				;/ Branches if the prepare blizzard timer is not 0.
INC $187B,x					; Sets the sprite sub-state to cast blizzard.
LDA #$19					;\
STA $1558,x					;/ Sets the casting timer.
LDA #$01					; Loads the range -1.
JSL RANDOMIZER					; Jumps to the random number routine.
STA !ExtraSpriteTable3				; Stores the use table 1 or 2 flag.
PREPAREBLIZZARD:
RTS						; Ends the code. I would ask for hot chocolate, but I am not a fan of hot chocolate.
CASTBLIZZARD:
LDA $187B,x					;\
CMP #$02					; | Branches if the sprite sub-state is start blizzard.
BCS STARTBLIZZARD				;/
LDA !AnPointer					;\
CMP #$12					; | Branches if the casting animation is queued.
BEQ CAST					;/
LDA #$12					;\
JSR QUEUEANIMATION				;/ Queues the casting animation.
LDA #$15					;\
STA $1DFC					;/ Sets the sound to play.
JSL GLITTERSPAWN				; Jumps to the glitter spawning routine.
CAST:
LDA $1558,x					;\
BNE KEEPICECASTING				;/ Branches if the casting timer is not 0.
LDA #$02					;\
STA $187B,x					;/ Sets the sprite sub-state to start blizzard.
LDA #$10					;\
STA $1558,x					;/ Sets the blizzard delay time.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ MORESNOWFLAKEDELAY				;/
LDA #$10					; Loads the snowflake delay time.
BRA STORESNOWFLAKEDELAY				; Branches to the store snowflake delay routine.
MORESNOWFLAKEDELAY:
LDA #$20					; Loads the snowflake delay time.
STORESNOWFLAKEDELAY:
STA $1564,x					; Stores the snowflake delay time.
KEEPICECASTING:
RTS						; Ends the code.
STARTBLIZZARD:
LDA $1558,x					;\
BNE NOSNOWEFFECT				;/ Branches if the blizzard delay time is not 0.
LDA !AnPointer					;\
CMP #$06					; | Branches if the flying animation is queued.
BEQ ICEFLYING					;/
LDA #$06					;\
JSR QUEUEANIMATION				;/ Queues the flying animation.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ ICEFLYING					;/
LDA #$10					;\
STA $1DF9					;/ Sets the sound to play.
ICEFLYING:
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ NOSNOWEFFECT				;/
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $7FC0FC					;\
ORA #$0001					; | Turns on the Custom 0 ExAnimation.
STA $7FC0FC					;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$7F					;\
STA $86						;/ Sets the slippery level flag to half slippery.
NOSNOWEFFECT:
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ LESSSNOWFLAKES				;/
LDA !ExtraSpriteTable2				;\
CMP #$18					; | Branches if the snowflake counter is 24 or more.
BCS ENDBLIZZARD					;/
BRA SPAWNSNOWFLAKE				; Branches to the spawn snowflake routine.
LESSSNOWFLAKES:
LDA !ExtraSpriteTable2				;\
CMP #$0C					; | Branches if the snowflake counter is 12 or more.
BCS ENDBLIZZARD					;/
SPAWNSNOWFLAKE:
LDA $1564,x					;\
BNE NOSNOWFLAKES				;/ Branches if the snowflake delay time is not 0.
LDA #$E0					;\
STA $02						;/ Sets the X speed of the snowflake.
LDA #$20					;\
STA $03						;/ Sets the Y speed of the snowflake.
LDA #$00+$13					;\
%SpawnExtendedAllTime()				;/ Spawns the snowflake.
LDA !ExtraSpriteTable3				;\
STA $07						;/ Stores the use table 1 or 2 flag into scratch RAM.
PHX						; Preserves the X Register.
LDA !ExtraSpriteTable2				; Loads the snowflake counter.
TAX						; Transfers the Accumulator to the X Register.
LDA $1A						; Loads the low byte of the current Layer 1 X position.
PHA						; Preserves the Accumulator.
CLC						; Clears the carry flag.
LDA $07						;\
BNE OTHERSNOWFLAKEXPOSITIONS			;/ Branches if table 2 is going to be loaded.
PLA						; Pulls back the Accumulator.
ADC SNOWFLAKEXPOSITIONS,x			; Offsets the low byte of the snowflake's X position by the low byte of the current Layer 1 X position indexed by the snowflake counter.
BRA SETSNOWFLAKEXPOSITION			; Branches to the set snowflake X position routine.
OTHERSNOWFLAKEXPOSITIONS:
PLA						; Pulls back the Accumulator.
ADC SNOWFLAKEXPOSITIONS2,x			; Offsets the low byte of the snowflake's X position by the low byte of the current Layer 1 X position indexed by the snowflake counter.
SETSNOWFLAKEXPOSITION:
STA $171F,y					; Stores the X position of the snowflake.
LDA $1B						;\
ADC #$00					; | Offsets the high byte of the snowflake's X position by the high byte of the current Layer 1 X position.
STA $1733,y					;/
LDA $1C						; Loads the low byte of the current Layer 1 Y position.
PHA						; Preserves the Accumulator.
LDA $07						;\
BNE OTHERSNOWFLAKEYPOSITIONS			;/ Branches if table 2 is going to be loaded.
PLA						; Pulls back the Accumulator.
ADC SNOWFLAKEYPOSITIONS,x			; Offsets the low byte of the snowflake's Y position by the low byte of the current Layer 1 Y position indexed by the snowflake counter.
BRA SETSNOWFLAKEYPOSITION			; Branches to the set snowflake X position routine.
OTHERSNOWFLAKEYPOSITIONS:
PLA						; Pulls back the Accumulator.
ADC SNOWFLAKEYPOSITIONS3,x			; Offsets the low byte of the snowflake's Y position by the low byte of the current Layer 1 Y position indexed by the snowflake counter.
SETSNOWFLAKEYPOSITION:
STA $1715,y					; Stores the Y position of the snowflake.
LDA $1D						;\
ADC SNOWFLAKEYPOSITIONS2,x			; | Offsets the high byte of the snowflake's Y position by the high byte of the current Layer 1 Y position indexed by the snowflake counter.
STA $1729,y					;/
PLX						; Pulls back the X Register
INC !ExtraSpriteTable2				; Increases the snowflake counter.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ MORESNOWFLAKEDELAY2				;/
LDA #$10					; Loads the snowflake delay time.
BRA STORESNOWFLAKEDELAY2			; Branches to the store snowflake delay routine.
MORESNOWFLAKEDELAY2:
LDA #$20					; Loads the snowflake delay time.
STORESNOWFLAKEDELAY2:
STA $1564,x					; Stores the snowflake delay time.
LDA #$40					;\
STA $15AC,x					;/ Sets the blizzard cooldown timer.
NOSNOWFLAKES:
RTS						; Ends the code.
ENDBLIZZARD:
LDA $15AC,x					;\
BNE BLIZZARDCOOLDOWN				;/ Branches if the blizzard cooldown timer is not 0.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ NOEFFECTREMOVAL				;/
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $7FC0FC					;\
AND #$FFFE					; | Turns off the Custom 0 ExAnimation.
STA $7FC0FC					;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
STZ $86						; Sets the slippery level flag to not slippery.
LDA #$15					;\
STA $1DFC					;/ Sets the sound to play.
NOEFFECTREMOVAL:
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE6				;/
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
LDA #$0B					;\
STA $1594,x					;/ Sets the sprite state to descending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the descent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code, and now I want some milk.
REGULARMOVECHANGE6:
JSL FORCELIGHTNING				; Jumps to the force lightning routine.
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLEAIRSTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMBLIZZARD,y		;\
STA $1558,x					;/ Sets the state timer from the blizzard state.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
JSL FINISHINIT					; Jumps to the face Mario routine.
BLIZZARDCOOLDOWN:
RTS						; Ends the code.

ROCKXPOSITIONS: db $10,$30,$40,$60,$80,$90,$C0,$E0
ROCKXPOSITIONS2: db $20,$30,$60,$70,$80,$A0,$B0,$E0
ROCKXPOSITIONS3: db $10,$40,$50,$70,$80,$C0,$D0,$E0
POSSIBLESTATETIMERSFROMEARTHSLIDE: db $28,$12,$04,$1D

EARTHSLIDE:
LDX $15E9					; Reloads the sprite index.
STZ $B6,x					; Resets the sprite's X speed.
JSL $81801A					;\
JSL $818022					;/ Applies the speed without gravity.
LDA $187B,x					;\
BNE CASTEARTHSLIDE				;/ Branches if the sprite sub-state is not prepare Earth slide.
LDA $1558,x					;\
BNE PREPAREEARTHSLIDE				;/ Branches if the prepare Earth slide timer is not 0.
INC $187B,x					; Sets the sprite sub-state to cast Earth slide.
LDA #$19					;\
STA $1558,x					;/ Sets the casting timer.
LDA #$02					; Loads the range -1.
JSL RANDOMIZER					; Jumps to the random number routine.
STA !ExtraSpriteTable3				; Stores the use table 1, 2, or 3 flag.
PREPAREEARTHSLIDE:
RTS						; Ends the code like how a rock can be thrown.
CASTEARTHSLIDE:
LDA $187B,x					;\
CMP #$02					; | Branches if the sprite sub-state is start Earth slide.
BCS STARTEARTHSLIDE				;/
LDA !AnPointer					;\
CMP #$12					; | Branches if the casting animation is queued.
BEQ CASTING					;/
LDA #$12					;\
JSR QUEUEANIMATION				;/ Queues the casting animation.
LDA #$15					;\
STA $1DFC					;/ Sets the sound to play.
JSL GLITTERSPAWN				; Jumps to the glitter spawning routine.
LDY #$0D					; Loads a loop count of 13.
EARTHWARNINGLOOP:
JSL EARTHWARNING				; Jumps to the Earth warning sign routine.
DEY						; Decreases the Y Register.
BPL EARTHWARNINGLOOP				; Loops the Earth warning sign loop until it is -1.
CASTING:
LDA $1558,x					;\
BNE KEEPCASTINGEARTHSLIDE			;/ Branches if the casting timer is not 0.
LDA #$02					;\
STA $187B,x					;/ Sets the sprite sub-state to start Earth slide.
LDA #$10					;\
STA $1558,x					;/ Sets the Earth slide delay time.
KEEPCASTINGEARTHSLIDE:
RTS						; Ends the code.
STARTEARTHSLIDE:
CMP #$03					;\
BCS CONTINUEEARTHSLIDE				;/ Branches if the sprite sub-state is continue Earth slide.
LDA $1558,x					;\
BNE NOEARTHSLIDING				;/ Branches if the Earth slide delay time is not 0.
LDA !AnPointer					;\
CMP #$06					; | Branches if the flying animation is queued.
BEQ EARTHFLYING					;/
LDA #$06					;\
JSR QUEUEANIMATION				;/ Queues the flying animation.
LDA #$10					;\
STA $1887					;/ Sets the Layer 1 shake timer.
LDA #$18					;\
STA $1DFC					;/ Sets the sound to play.
LDA $72						;\
BNE EARTHFLYING					;/ Branches if Mario is in the air.
LDA #$40					;\
STA $18BD					;/ Sets the stun timer.
LDA #$01					;\
STA !RegularStunFlag				;/ Sets the regular stun flag.
EARTHFLYING:
LDA #$03					;\
STA $187B,x					;/ Sets the sprite sub-state to continue Earth slide.
NOEARTHSLIDING:
RTS						; Ends the code.
CONTINUEEARTHSLIDE:
LDA !ExtraSpriteTable2				;\
CMP #$08					; | Branches if the rock counter is 8 or more.
BCS ENDEARTHSLIDE				;/
LDA $1558,x					;\
BNE NOEARTHSLIDING				;/ Branches if the rock delay time is not 0.
STZ $02						;\
STZ $03						;/ Resets the X and Y speed of the rock.
LDA #$01+$13					;\
%SpawnExtendedAllTime()				;/ Spawns the rock.
LDA !ExtraSpriteTable3				;\
STA $07						;/ Stores the use table 1, 2, or 3 flag into scratch RAM.
PHX						; Preserves the X Register.
LDA !ExtraSpriteTable2				; Loads the rock counter.
TAX						; Transfers the Accumulator to the X Register.
LDA $1A						; Loads the low byte of the current Layer 1 X position.
PHA						; Preserves the Accumulator.
CLC						; Clears the carry flag.
LDA $07						;\
BNE OTHERROCKPOSITIONS				;/ Branches if table 1 is not going to be loaded.
PLA						; Pulls back the Accumulator.
ADC ROCKXPOSITIONS,x				; Offsets the low byte of the rock's X position by the low byte of the current Layer 1 X position indexed by the rock counter.
BRA SETROCKXPOSITION				; Branches to the set rock X position routine.
OTHERROCKPOSITIONS:
CMP #$02					;\
BCS ANOTHERROCKXPOSITION			;/ Branches if table 3 is going to be loaded.
PLA						; Pulls back the Accumulator.
ADC ROCKXPOSITIONS2,x				; Offsets the low byte of the rock's X position by the low byte of the current Layer 1 X position indexed by the rock counter.
BRA SETROCKXPOSITION				; Branches to the set rock X position routine.
ANOTHERROCKXPOSITION:
PLA						; Pulls back the Accumulator.
ADC ROCKXPOSITIONS3,x				; Offsets the low byte of the rock's X position by the low byte of the current Layer 1 X position indexed by the rock counter.
SETROCKXPOSITION:
STA $171F,y					; Stores the X position of the rock.
LDA $1B						;\
ADC #$00					; | Offsets the high byte of the rock's X position by the high byte of the current Layer 1 X position.
STA $1733,y					;/
LDA $1C						;\
ADC #$F0					; | Offsets the low byte of the rock's Y position by the low byte of the current Layer 1 Y position.
STA $1715,y					;/
LDA $1D						;\
ADC #$FF					; | Offsets the high byte of the rock's Y position by the high byte of the current Layer 1 Y position.
STA $1729,y					;/
PLX						; Pulls back the X Register.
INC !ExtraSpriteTable2				; Increases the rock counter.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ MOREEARTHSLIDEDELAY				;/
LDA #$10					; Loads the Earth slide delay time.
BRA STOREROCKDELAY				; Branches to the store rock delay routine.
MOREEARTHSLIDEDELAY:
LDA #$20					; Loads the Earth slide delay time.
STOREROCKDELAY:
STA $1558,x					; Stores the rock delay time.
LDA #$60					;\
STA $15AC,x					;/ Sets the Earth slide cooldown timer.
RTS						; Ends the code.
ENDEARTHSLIDE:
LDA $15AC,x					;\
BNE EARTHSLIDECOOLDOWN				;/ Branches if the Earth slide cooldown timer is not 0.
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE7				;/
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
LDA #$0B					;\
STA $1594,x					;/ Sets the sprite state to descending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the descent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
REGULARMOVECHANGE7:
JSL FORCELIGHTNING				; Jumps to the force lightning routine.
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLEAIRSTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMEARTHSLIDE,y		;\
STA $1558,x					;/ Sets the state timer from the Earth slide state.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
JSL FINISHINIT					; Jumps to the face Mario routine.
EARTHSLIDECOOLDOWN:
RTS						; Ends the code.

EARTHWARNINGXPOSITIONS: db $10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0

EARTHWARNING:
PHX						; Preserves the X Register.
LDX #$2F					; Loads a loop count of 47.
EARTHWARNINGSIGNLOOP:
LDA $7FB920,x					;\
BNE EXISTINGEARTHWARNINGSIGN			;/ Branches if a warning sign is present.
LDA #$16					;\
STA $7FB920,x					;/ Sets the warning sign timer.
LDA $1A						;\
CLC						; | Offsets the low byte of the warning sign's X position.
ADC EARTHWARNINGXPOSITIONS,y			; |
STA $7FB950,x					;/
LDA $1B						;\
ADC #$00					;/ Offsets the high byte of the warning sign's X position.
STA $7FB980,x					; Stores the high byte of the warning sign's X position.
LDA $1C						;\
STA $7FB9B0,x					; | Offsets the warning sign's Y position by the current Layer 1 Y position.
LDA $1D						; |
STA $7FB9E0,x					;/
LDA #$00					;\
STA $7FBA10,x					;/ Sets the warning sign frame timer.
PLX						; Pulls back the X Register.
RTL						; Ends the code.
EXISTINGEARTHWARNINGSIGN:
DEX						; Decreases the X Register.
BPL EARTHWARNINGSIGNLOOP			; Loops the warning sign loop until it is -1.
PLX						; Pulls back the X Register.
RTL						; Ends the code.

FORCELIGHTNING:
LDA !ExtraSpriteTable1				;\
CMP #$0C					; | Branches if the moves counter is less than 12.
BCC ALREADYDONELIGHTNING			;/
LDA !ExtraSpriteTable5				;\
AND #$02					; | Branches if the sprite has casted lightning at least once.
BNE ALREADYDONELIGHTNING			;/
LDA #$03					;\
STA $1FD6,x					;/ Sets the next move index to cast lightning.
ALREADYDONELIGHTNING:
RTL						; Ends the code.

WARNINGAMOUNT: db $09,$12,$1B,$24
WARNINGXPOSITIONS: db $00,$10,$20,$30
WARNINGYPOSITIONS: db $B0,$98,$80,$68,$50,$38,$20,$08
POSSIBLESTATETIMERSFROMLIGHTNING: db $1C,$27,$17,$05

LIGHTNING:
LDX $15E9					; Reloads the sprite index.
STZ $B6,x					; Resets the sprite's X speed.
JSL $81801A					;\
JSL $818022					;/ Applies the speed without gravity.
LDA $187B,x					;\
BNE CASTLIGHTNING				;/ Branches if the sprite sub-state is not prepare lightning.
LDA $1558,x					;\
BNE PREPARELIGHTNING				;/ Branches if the prepare lightning timer is not 0.
INC $187B,x					; Sets the sprite sub-state to show warning signs.
PREPARELIGHTNING:
LDA !ExtraSpriteTable5				;\
AND #$FD					; | Clears the casted lightning bit.
STA !ExtraSpriteTable5				;/
RTS						; Ends the code. It is not shocking at all.
CASTLIGHTNING:
CMP #$01					;\
BEQ DONOTSTARTLIGHTNING				; |
CMP #$03					; | Branches if the sprite sub-states are show warning signs part 1, 2, and 3.
BEQ DONOTSTARTLIGHTNING				; |
CMP #$05					; |
BEQ DONOTSTARTLIGHTNING				;/
LDA #$01					;\
STA !RegularStunFlag				;/ Sets the regular stun flag.
STZ $18BD					; Clears the stun timer.
JMP STARTLIGHTNING				; Jumps to the start lightning routine.
DONOTSTARTLIGHTNING:
LDA #$01					;\
STA !RegularStunFlag				;/ Sets the regular stun flag.
STZ $18BD					; Clears the stun timer.
LDA !AnPointer					;\
CMP #$12					; | Branches if the casting animation is queued.
BEQ CASTED					;/
LDA #$12					;\
JSR QUEUEANIMATION				;/ Queues the casting animation.
LDA $D1						;\
STA !ExtraSpriteTable3				; | Stores Mario's last X position.
LDA $D2						; |
STA !ExtraSpriteTable4				;/
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $D1						;\
CMP #$0041					; | Branches if Mario's X position is less than 65.
BCC RIGHTSHIFT					;/
CMP #$00B0					;\
BCC CASTED					;/ Branches if Mario's X position is less than 176.
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
LDA #$01					;\
STA !ExtraSpriteTable5				;/ Makes the warning signs and lightning strikes trail to the left.
BRA CASTED					; Branches to the cast warning sign routine.
RIGHTSHIFT:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
STZ !ExtraSpriteTable5				; Makes the warning signs and lightning strikes trail to the right.
CASTED:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
JSR CALCULATEAMOUNT				; Jumps to the calculate amount routine.
LDA !ExtraSpriteTable2				;\
CMP $0A						; | Branches if the warning counter is the amount calculated.
BCC KEEPCASTINGLIGHTNING			;/
PHX						; Preserves the X Register.
LDX #$2F					; Loads a loop count of 47.
WARNINGCHECKLOOP:
LDA $7FB920,x					;\
BNE KEEPWARNING					;/ Branches if a warning sign is present.
DEX						; Decreases the X Register.
BPL WARNINGCHECKLOOP				; Loops the warning sign check loop until it is -1.
PLX						; Pulls back the X Register.
INC $187B,x					; Sets the sprite sub-state to cast lightning.
LDA #$18					;\
STA $1558,x					;/ Sets the lightning delay time.
STZ !ExtraSpriteTable2				; Clears the object counter.
RTS						; Ends the code.
KEEPWARNING:
PLX						; Pulls back the X Register.
RTS						; Ends the code.
KEEPCASTINGLIGHTNING:
LDA $1558,x					;\
BNE PREPAREWARNING				;/ Branches if the warning sign delay time is not 0.
LDA !ExtraSpriteTable3				;\
STA $07						; | Sets the X position of the warning sign.
LDA !ExtraSpriteTable4				; |
STA $08						;/
LDA !ExtraSpriteTable5				;\
STA $0D						;/ Sets the direction of the warning sign trail.
LDA #$07					; Loads a loop count of 7.
WARNINGSIGNSPAWNLOOP:
PHA						; Preserves the Accumulator.
STA $09						; Stores the current loop count as an index to the warning sign Y positions.
LDA !ExtraSpriteTable2				; Loads the warning counter.
TAY						; Transfers the Accumulator to the Y Register.
JSR GENERATEWARNING				; Jumps to the generate warning sign routine.
PLA						; Pulls back the Accumulator.
DEC						; Decreases the Accumulator.
BPL WARNINGSIGNSPAWNLOOP			; Loops the warning sign spawn loop until it is -1.
INC !ExtraSpriteTable2				; Increases the warning sign counter.
LDA #$05					;\
STA $1558,x					;/ Sets the warning sign delay time.
PREPAREWARNING:
RTS						; Ends the code.
STARTLIGHTNING:
LDA $1558,x					;\
BNE PREPAREWARNING				;/ Branches if the lightning delay time is not 0.
LDA !AnPointer					;\
CMP #$06					; | Branches if the flying animation is queued.
BEQ BOLTFLYING					;/
LDA #$06					;\
JSR QUEUEANIMATION				;/ Queues the flying animation.
BOLTFLYING:
JSR CALCULATEAMOUNT				; Jumps to the calculate amount routine.
LDA !ExtraSpriteTable2				;\
CMP $0A						; | Branches if the lightning counter is the amount calculated.
BCC KEEPCASTINGLIGHTNING2			;/
PHX						; Preserves the X Register.
LDX #$07					; Loads a loop count of 7.
LIGHTNINGCHECKLOOP:
LDA $7FBA70,x					;\
BNE KEEPLIGHTNING				;/ Branches if a lightning strike is present.
DEX						; Decreases the X Register.
BPL LIGHTNINGCHECKLOOP				; Loops the lightning check loop until it is -1.
PLX						; Pulls back the X Register.
LDA $1564,x					;\
BNE SHAKINGGROUND				;/ Branches if the lightning cooldown time is not 0.
LDA $187B,x					;\
CMP #$06					; | Branches if the sprite sub-state is end lightning.
BCS ENDLIGHTNING				;/
INC $187B,x					; Sets the sprite state to end lightning.
STZ !ExtraSpriteTable2				; Clears the object counter.
SHAKINGGROUND:
RTS						; Ends the code.
KEEPLIGHTNING:
PLX						; Pulls back the X Register.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is not set.
BEQ MORELIGHTNINGCOOLDOWN			;/
LDA #$18					;\
STA $1564,x					;/ Sets the lightning cooldown time.
RTS						; Ends the code.
MORELIGHTNINGCOOLDOWN:
LDA #$28					;\
STA $1564,x					;/ Sets the lightning cooldown time.
RTS						; Ends the code and my life- I mean, what?
KEEPCASTINGLIGHTNING2:
LDA !ExtraSpriteTable3				;\
STA $07						; | Sets the X position of the lightning strike.
LDA !ExtraSpriteTable4				; |
STA $08						;/
LDA !ExtraSpriteTable5				;\
STA $0E						;/ Sets the direction of the lightning trail.
LDA !ExtraSpriteTable2				; Loads the lightning counter.
TAY						; Transfers the Accumulator to the Y Register.
JSR GENERATELIGHTNING				; Jumps to the generate lightning routine.
INC !ExtraSpriteTable2				; Increases the lightning counter.
LDA #$05					;\
STA $1558,x					;/ Sets the lightning delay time.
RTS						; Ends the code.
ENDLIGHTNING:
LDA !ExtraSpriteTable5				;\
ORA #$02					; | Sets the casted lightning bit.
STA !ExtraSpriteTable5				;/
LDA !ExtraSpriteTable1				;\
CMP #$0D					; | Branches if the moves counter is less than 13.
BCC REGULARMOVECHANGE8				;/
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
LDA #$0B					;\
STA $1594,x					;/ Sets the sprite state to descending.
STZ $187B,x					; Resets the sub-state.
LDA #$20					;\
STA $1558,x					;/ Sets the descent prepare time
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
REGULARMOVECHANGE8:
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLEAIRSTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMLIGHTNING,y		;\
STA $1558,x					;/ Sets the state timer from the lightning state.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
INC !ExtraSpriteTable1				; Increments the moves counter.
STZ !ExtraSpriteTable2				; Sets the object counter to 0.
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.

CALCULATEAMOUNT:
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORELIGHTNING				;/
LDA #$01					;\
STA $0A						;/ Sets the amount calculated to 1.
RTS						; Ends the code. The end.
MORELIGHTNING:
LDA #!BobHP					; Loads Bob's max health.
LDY #$0C					; Loads 0.75 as the multiplier.
JSR CALCAULATEPERECNTOFHP			; Jumps to the calculate percent of HP routine.
INC $0C						; Increases the fractional product by 1.
LDA $160E,x					;\
CMP $0C						; | Branches if Bob's health is at 75% or less.
BCC HPIS75PERCENT				;/
LDA #$01					;\
STA $0A						;/ Sets the amount calculated to 1.
RTS						; Ends the code.
HPIS75PERCENT:
LDA #!BobHP					; Loads Bob's max health.
LDY #$08					; Loads 0.5 as the multiplier.
JSR CALCAULATEPERECNTOFHP			; Jumps to the calculate percent of HP routine.
INC $0C						; Increases the fractional product by 1.
LDA $160E,x					;\
CMP $0C						; | Branches if Bob's health is at 50% or less.
BCC HPIS50PERCENT				;/
LDA #$02					;\
STA $0A						;/ Sets the amount calculated to 2.
RTS						; Ends the code.
HPIS50PERCENT:
LDA #!BobHP					; Loads Bob's max health.
LDY #$04					; Loads 0.25 as the multiplier.
JSR CALCAULATEPERECNTOFHP			; Jumps to the calculate percent of HP routine.
INC $0C						; Increases the fractional product by 1.
LDA $160E,x					;\
CMP $0C						; | Branches if Bob's health is at 25% or less.
BCC HPIS25PERCENT				;/
LDA #$03					;\
STA $0A						;/ Sets the amount calculated to 3.
RTS						; Ends the code.
HPIS25PERCENT:
LDA #$04					;\
STA $0A						;/ Sets the amount calculated to 4.
RTS						; Ends the code.

CALCAULATEPERECNTOFHP:
STA $4202					;\
STY $4203					;/ Stores Bob's max health and the decimal number to the multiplication registers.
NOP						;\
NOP						; | Waits for 8 cycles to pass by.
NOP						; | NOPs are needed to waste time.
NOP						;/
LDA $4216					;\
AND #$08					; | Branches if the number has a decimal value of 0.5 or more.
BEQ NODECIMALS					;/
LDA #$01					;\
STA $0C						;/ Stores 1 to the fractional product.
BRA SETRESULT					; Branches to the set result routine.
NODECIMALS:
STZ $0C						; Clears the fractional product.
SETRESULT:
REP #$20					; Turns on 16-bit addressing for the Accumulator.
LDA $4216					; Loads the product.
ASL						;\
ASL						; | Shifts the bits to the left 4 times.
ASL						; |
ASL						;/
AND #$FF00					; Keeps the first 8 bits.
LSR						;\
LSR						; |
LSR						; |
LSR						; | Shifts the bits to the right 8 times.
LSR						; |
LSR						; |
LSR						; |
LSR						;/
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
STA $0B						; Stores the number to the fractional product offset.
LDA $0C						;\
CLC						; | Adds the fractional product offset to the fractional product.
ADC $0B						; |
STA $0C						;/						
RTS						; Ends the code.

GENERATEWARNING:
PHX						; Preserves the X Register.
LDX #$2F					; Loads a loop count of 47.
WARNINGSIGNLOOP:
LDA $7FB920,x					;\
BNE EXISTINGWARNINGSIGN				;/ Branches if a warning sign is present.
LDA #$16					;\
STA $7FB920,x					;/ Sets the warning sign timer.
LDA $0D						;\
BNE LEFTSHIFT					;/ Branches if the direction of the warning sign trail is to the left.
LDA $07						;\
CLC						; | Offsets the low byte of the warning sign's X position indexed by the warning sign counter.
ADC WARNINGXPOSITIONS,y				; |
STA $7FB950,x					;/
LDA $08						;\
ADC #$00					;/ Offsets the high byte of the warning sign's X position.
BRA STOREWARNINGXPOSITION			; Branches to the store warning sign X position routine.
LEFTSHIFT:
LDA $07						;\
SEC						; | Offsets the low byte of the warning sign's X position indexed by the warning sign counter.
SBC WARNINGXPOSITIONS,y				; |
STA $7FB950,x					;/
LDA $08						;\
SBC #$00					;/ Offsets the high byte of the warning sign's X position.
STOREWARNINGXPOSITION:
STA $7FB980,x					; Stores the high byte of the warning sign's X position.
LDY $09						; Loads the warning sign loop count.
LDA $1C						;\
CLC						; | Offsets the low byte of the warning sign's Y position by the low byte of the current Layer 1 Y position indexed by the warning sign loop count.
ADC WARNINGYPOSITIONS,y				; |
STA $7FB9B0,x					;/
LDA $1D						;\
ADC #$00					; | Offsets the high byte of the warning sign's Y position by the high byte of the current Layer 1 Y position
STA $7FB9E0,x					;/
LDA #$00					;\
STA $7FBA10,x					;/ Sets the warning sign frame timer.
LDA #$15					;\
STA $1DFC					;/ Sets the sound to play
PLX						; Pulls back the X Register.
RTS						; Ends the code.
EXISTINGWARNINGSIGN:
DEX						; Decreases the X Register.
BPL WARNINGSIGNLOOP				; Loops the warning sign loop until it is -1.
PLX						; Pulls back the X Register.
RTS						; Ends the code.

GENERATELIGHTNING:
PHX						; Preserves the X Register.
LDX #$2F					; Loads 48 into the X Register
LDA $7FB9B0,x					;\
SEC						; | Stores the low byte of the top warning sign's Y position and shifts it up by 8.
SBC #$08					; |
STA $09						;/
LDA $7FB9E0,x					;\
SBC #$00					; | Stores the high byte of the top warning sign's Y position.
STA $0D						;/
LDX #$07					; Loads a loop count of 7.
LIGHTNINGLOOP:
LDA $7FBA70,x					;\
BNE EXISTINGLIGHTNINGSTRIKE			;/ Branches if a lightning strike is present.
LDA #$09					;\
STA $7FBA70,x					;/ Sets the lightning strike timer.
LDA $0E						;\
BNE LEFTSHIFT2					;/ Branches if the direction of the lightning trail is to the left.
LDA $07						;\
CLC						; | Offsets the low byte of the lightning strike's X position indexed by the lightning counter.
ADC WARNINGXPOSITIONS,y				; |
STA $7FBA78,x					;/
LDA $08						;\
ADC #$00					;/ Offsets the high byte of the lightning strike's X position.
BRA STORELIGHTNINGXPOSITION			; Branches to the store lightning strike X position routine.
LEFTSHIFT2:
LDA $07						;\
SEC						; | Offsets the low byte of the lightning strike's X position indexed by the lightning counter.
SBC WARNINGXPOSITIONS,y				; |
STA $7FBA78,x					;/
LDA $08						;\
SBC #$00					;/ Offsets the high byte of the lightning strike's X position.
STORELIGHTNINGXPOSITION:
STA $7FBA80,x					; Stores the high byte of the lightning strike's X position.
LDA $09						;\
STA $7FBA88,x					;/ Stores the low byte of the lightning strike's Y position.
LDA $0D						;\
STA $7FBA90,x					;/ Stores the high byte of the lightning strike's Y position.
LDA #$10					;\
STA $1887					;/ Sets the Layer 1 shake timer.
LDA #$18					;\
STA $1DFC					;/ Sets the sound to play.
PLX						; Pulls back the X Register.
RTS						; Ends the code.
EXISTINGLIGHTNINGSTRIKE:
DEX						; Decreases the X Register.
BPL LIGHTNINGLOOP				; Loops the lightning loop until it is -1.
PLX						; Pulls back the X Register.
RTS						; Ends the code.

POSSIBLESTATETIMERSFROMDESCENDING: db $27,$04,$19,$20

DESCEND:
LDX $15E9					; Reloads the sprite index.
LDA !AnPointer					;\
CMP #$04					; | Branches if the falling animation is queued.
BEQ FALLING					;/
LDA #$04					;\
JSR QUEUEANIMATION				;/ Queues the falling animation.
FALLING:
STZ $B6,x					; Resets the sprite's X speed.
JSL $81802A					; Applies the speed with gravity.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is on the ground.
BNE GROUNDED					;/
LDA #$40					;\
STA $1558,x					;/ Sets the descent delay time.
RTS						; Ends the code, and now you have fallen.
GROUNDED:
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
LDA $1558,x					;\
BNE PREPAREGROUNDMOVES				;/ Branches if the descent delay time is not 0.
LDY $1FD6,x					; Loads the next move index.
LDA POSSIBLESTATES,y				;\
STA $1594,x					;/ Sets the sprite state to what is indexed.
LDA POSSIBLESTATETIMERSFROMDESCENDING,y		;\
STA $1558,x					;/ Sets the state timer from the descending state.
LDA $7FAB10,x					;\
AND #$04					; | Branches if the extra bit is set.
BNE MORERAPID8					;/
LDA #$20					; Loads the fireball delay time.
BRA STORERAPIDTIMER7				; Branches to the store fireball delay time routine.
MORERAPID8:
LDA #$10					; Loads the fireball delay time.
STORERAPIDTIMER7:
STA $1564,x					; Stores the fireball delay time.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sub-state.
STZ !ExtraSpriteTable1				; Resets the moves counter.
STZ !ExtraSpriteTable2				; Clears the object counter.
LDA !ExtraSpriteTable5				;\
AND #$FD					; | Clears the casted lightning bit.
STA !ExtraSpriteTable5				;/
JSL FINISHINIT					; Jumps to the face Mario routine.
PREPAREGROUNDMOVES:
RTS						; Ends the code.

STRUCK:
LDX $15E9					; Reloads the sprite index.
STZ $B6,x					; Resets the sprite's X speed.
JSL $81802A					; Applies the speed with gravity.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is on the ground.
BNE GROUNDED2					;/
RTS						; When this ends the code, you will be struck by lightning.
GROUNDED2:
LDA #$0D					;\
STA $1594,x					;/ Sets the sprite state to stunned.
STZ !ExtraSpriteTable2				; Clears the object counter.
LDA !ExtraSpriteTable5				;\
AND #$FD					; | Clears the casted lightning bit.
STA !ExtraSpriteTable5				;/
RTS						; Ends the code.

STUNNED:
LDX $15E9					; Reloads the sprite index.
LDA !AnPointer					;\
CMP #$16					; | Branches if the lying animation is queued.
BEQ LYING					;/
LDA #$16					;\
JSR QUEUEANIMATION				;/ Queues the lying animation.
LDA #$01					;\
STA $1DF9					;/ Sets the sound to play.
LYING:
LDA #$3D					;\
STA $1662,x					;/ Updates the sprite clipping.
LDA #$00					;\
STA $7FABAA,x					;/ Sets the X offset of the clipping.
LDA #$10					;\
STA $7FABB6,x					;/ Sets the Y offset of the clipping.
LDA #$10					;\
STA $7FABC2,x					;/ Sets the length of the clipping.
LDA #$10					;\
STA $7FABCE,x					;/ Sets the height of the clipping.
LDA #$85					;\
STA $1656,x					;/ Updates the object clipping.
STZ $B6,x					; Resets the sprite's X speed.
LDA $1588,x					;\
AND #$04					; | Branches if the sprite is in the air.
BEQ STUNNEDFALLING				;/
LDA #$10					;\
STA $AA,x					;/ Sets the sprite's Y speed.
STUNNEDFALLING:
JSL $81802A					; Applies the speed with gravity.
RTS						; Ends the code.

ITEMS: db $75,$77

DAMAGED:
LDX $15E9					; Reloads the sprite index.
LDA $154C,x					;\
BNE HURT					;/ Branches if the invincibility timer is not 0.
LDA #$01					;\
STA $1594,x					;/ Sets the sprite state to walking.
LDA #$01					;\
STA $1662,x					;/ Updates the sprite clipping.
LDA #$81					;\
STA $1656,x					;/ Updates the object clipping.
LDA #$60					;\
STA $1558,x					;/ Sets low byte of the state timer.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ !ExtraSpriteTable1				; Resets the moves counter.
JSL FINISHINIT					; Jumps to the face Mario routine.
RTS						; Ends the code.
HURT:
LDA $154C,x					;\
CMP #$01					; | Branches if the invincibility timer is not 1.
BNE NOITEMS					;/
LDA $19						;\
BNE SPAWNRANDOMITEM				;/ Branches if Mario is not small.
LDA #$74					;\
STA $1FD6,x					;/ Stores the sprite number to the sprite to spawn sprite table.
ENDITEMGENERATION:
JSR SPAWNITEM					; Jumps to the spawn item sprite routine.
RTS						; Ends the code.
SPAWNRANDOMITEM:
LDA #$01					; Loads the range -1.
JSL RANDOMIZER					; Jumps to the random number routine.
TAY						; Transfers the Accumulator to the Y Register.
LDA ITEMS,y					; Loads the sprite numbers indexed by the random number generated.
STA $1FD6,x					; Stores the sprite number to the sprite to spawn sprite table.
BRA ENDITEMGENERATION				; Branches to the end item generation routine.
NOITEMS:
RTS						; Ends the code.

DEATH:
LDX $15E9					; Reloads the sprite index.
LDA $154C,x					;\
BNE WAITFORDEATH				;/ Branches if the invincibility timer is not 0.
JSL SPINSTARSPAWN				; Jumps to the spawn Spin Jump Star routine.
STZ $00						; Sets the X offsets of the smoke.
LDA #$08					;\
STA $01						;/ Sets the Y offsets of the smoke.
LDA #$1B					;\
STA $02						;/ Sets the timer for the smoke sprite.
LDA #$01					;\
%SpawnSmoke()					;/ Spawns the smoke sprite.
LDA #$08					;\
STA $1DF9					;/ Sets the sound to play.
LDA $1697					;\
CLC						; | Increases the number of consecutive enemies stomped.
ADC $1626,x					; |
INC $1697					;/
LDA $1697					;\
CMP #$08					; | Branches if the number of consecutive enemies stomped is less than 8.
BCC FEWERTHANEIGHT				;/
LDA #$08					;\ Keeps the amount killed at 8.
STA $1697					;/
FEWERTHANEIGHT:
JSL $82ACE5					; Gives Mario points.
STZ $14C8,x					; Kills the sprite.
WAITFORDEATH:
RTS						; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bob
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BOB:
JSL $819138					; Makes the sprite interact with objects.
LDA $1594,x					;\
ASL						;/ Loads the phases of the sprite
TAX						; Transfers the Accumulator to the X Register.
JSR.w (BOBPHASES,x)				; Jumps to the indexed phases.
JMP WMSMAGICIAN2				; Jumps to the rest of the sprite code.

BOBPHASES:
dw INTRO
dw WALKING
dw SHOOTFIRE
dw JUMPSHOT
dw RAPIDSHOT
dw FLICKSHOT
dw ASCENDING
dw FLYING
dw BLIZZARD
dw EARTHSLIDE
dw LIGHTNING
dw DESCEND
dw STRUCK
dw STUNNED
dw DAMAGED
dw DEATH2

INTRO:
LDX $15E9					; Reloads the sprite index.
LDA $1540,x					;\
BNE HIDE2					;/ Branches if the spawn timer is not 0.
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
LDA $187B,x					;\
BNE NOSMOKE					;/ Branches if the sprite sub-state is not spawn.
STZ $00						; Sets the X offsets of the smoke.
LDA #$08					;\
STA $01						;/ Sets the Y offsets of the smoke.
LDA #$1B					;\
STA $02						;/ Sets the timer for the smoke sprite.
LDA #$01					;\
%SpawnSmoke()					;/ Spawns the smoke sprite.
LDA #$10					;\
STA $1DF9					;/ Sets the sound to play.
INC $187B,x					; Sets the sprite sub-state to speak.
RTS						; Ends the code.
NOSMOKE:
LDA $187B,x					;\
CMP #$02					; | Branches if the sprite sub-state is not start battle.
BNE MESSAGE					;/
LDA #!BattleMusic				;\
STA $1DFB					;/ Sets the music to play.
INC $1594,x					; Increments the sprite state so it gets out of this state.
LDA #$60					;\
STA $1558,x					;/ Sets the state timer.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
STZ $187B,x					; Resets the sprite sub-state.
STZ !DisableControlsFlag			; Clears the disable controls flag.
STZ $13D3					; Enables pausing.
RTS						; Ends this routine.
HIDE2:
LDA #$01					;\
STA !DisableControlsFlag			;/ Sets the disable controls flag.
LDA #$20					;\
STA $1558,x					;/ Sets the message delay time.
RTS						; Ends the code.
MESSAGE:
LDA $1558,x					;\
BNE NOMESSAGE					;/ Branches if the message delay time is not 0.
LDA #$2C					;\
STA $13BF					;/ Sets the translevel number.
LDA #$02					;\
STA $1426					;/ Displays the message.
INC $187B,x					; Sets the sprite sub-state to start battle.
NOMESSAGE:
RTS						; Ends the code.

LEVELMESSAGES: db $33,$33,$35,$35,$35
DEATHMESSAGES: db $01,$02,$01,$01,$01

DEATH2:
LDX $15E9					; Reloads the sprite index.
LDA $154C,x					;\
BNE WAITFORDEATH2				;/ Branches if the invincibility timer is not 0.
LDA #$01					;\
STA !DisableControlsFlag			;/ Sets the disable controls flag.
LDA $72						;\
BNE WAITFORDEATH2				;/ Branches if Mario is in the air.
LDA $7B						;\
BNE WAITFORDEATH2				;/ Branches if Mario is moving.
LDA !TimerFrameCounterBackup			;\
STA $0F30					;/ Forces the time limit to pause.
%SubHorzPos()					;\
TYA						; | Makes Mario face the sprite.
STA $76						;/
LDA $187B,x					;\
CMP #$04					; | Branches if the sprite sub-state is not kill sprite.
BCC DEATHTHROES					;/
LDA $1564,x					;\
BNE DEATHDELAY					;/ Branches if the death delay time is not 0.
INC !LevelState					; Sets the level state to destroy items.
LDA #$58					;\ 
TRB $0D9F					;/ Disables HDMA channels 3, 4, and 6.
LDA #$12					;\
STA !DestroyItemTimer				;/ Sets the destroy item time.
JSL SPINSTARSPAWN				; Jumps to the spawn Spin Jump Star routine.
STZ $00						; Sets the X offsets of the smoke.
LDA #$08					;\
STA $01						;/ Sets the Y offsets of the smoke.
LDA #$1B					;\
STA $02						;/ Sets the timer for the smoke sprite.
LDA #$01					;\
%SpawnSmoke()					;/ Spawns the smoke sprite.
LDA #$08					;\
STA $1DF9					;/ Sets the sound to play.
LDA $1697					;\
CLC						; | Increases the number of consecutive enemies stomped.
ADC $1626,x					; |
INC $1697					;/
LDA $1697					;\
CMP #$08					; | Branches if the number of consecutive enemies stomped is less than 8.
BCC FEWERTHANEIGHT3				;/
LDA #$08					;\ Keeps the amount killed at 8.
STA $1697					;/
FEWERTHANEIGHT3:
JSL $82ACE5					; Gives Mario points.
LDA #!AreaMusic					;\
STA $1DFB					;/ Sets the music to play.
STZ $14C8,x					; Kills the sprite.
STZ $13D3					; Enables pausing.
DEATHDELAY:
RTS						; Ends the code.
WAITFORDEATH2:
LDA #$05					;\
STA $1558,x					;/ Sets the message delay time.
STZ $74						; Disables climbing.
LDA $0F30					;\
BEQ DEATHDELAY					;/ Branches if the time limit frame counter is 0.
STA !TimerFrameCounterBackup			; Stores the time limit frame counter into a buffer for it to pause.
STZ !ExtraSpriteTable1				; Resets the thunder counter.
RTS						; Ends the code.
DEATHTHROES:
LDA $187B,x					;\
CMP #$03					; | Branches if the sprite sub-state is show death effects.
BCS DEATHEFFECTS				;/
TAY						; Transfers the Accumulator to the Y Register.
LDA $1558,x					;\
BNE NOMESSAGES					;/ Branches if the message delay time is not 0.
LDA LEVELMESSAGES,y				;\
STA $13BF					;/ Sets the translevel number indexed by the sprite sub-state.
LDA DEATHMESSAGES,y				;\
STA $1426					;/ Displays the message indexed by the sprite sub-state.
INC $187B,x					; Sets the sprite sub-states to show message 2 and 3.
LDA #$02					;\
STA $1564,x					;/ Sets the thunder delay time.
LDA #$01					;\
STA $1558,x					;/ Sets the message delay time.
NOMESSAGES:
RTS						; Ends the code.
DEATHEFFECTS:
LDA #$50					;\ 
TSB $0D9F					;/ Enables HDMA channels 4 and 6.
LDA #$01					;\
STA !LevelState					;/ Sets the level state to show thunder.
LDA $1564,x					;\
BNE NOTHUNDER					;/ Branches if the thunder delay time is not 0.
LDA !ExtraSpriteTable1				;\
CMP #$04					; | Branches if the thunder counter is less than 4.
BCC THUNDER					;/
LDA #$04					;\
STA $187B,x					;/ Sets the sprite sub-state to kill sprite.
LDA #$4C					;\
STA $1564,x					;/ Sets the death delay time.
RTS						; End the code.
THUNDER:
LDA #$18					;\
STA $1DFC					;/ Sets the sound to play.
INC !ExtraSpriteTable1				; Increases the thunder counter.
LDA #$3C					;\
STA $1564,x					;/ Sets the thunder delay time.
STA !ThunderTimer				; Sets the thunder timer.
NOTHUNDER:
LDA #$08					;\
TSB $0D9F					;/ Enables HDMA channel 3.
RTS						; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bob's Cutscene Behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CUTSCENEBOB:
JSL $819138					; Makes the sprite interact with objects.
LDA $1594,x					;\
ASL						;/ Loads the phases of the sprite
TAX						; Transfers the Accumulator to the X Register.
JSR.w (CUTSCENEPHASES,x)			; Jumps to the indexed phases.
JMP WMSMAGICIAN2				; Jumps to the rest of the sprite code.

CUTSCENEPHASES:
dw CUTSCENEINTRO
dw CAUSETROUBLE

CUTSCENEINTRO:
LDX $15E9					; Reloads the sprite index.
LDA $1540,x					;\
BNE HIDE3					;/ Branches if the spawn timer is not 0.
STZ $00						; Sets the X offsets of the smoke.
LDA #$08					;\
STA $01						;/ Sets the Y offsets of the smoke.
LDA #$1B					;\
STA $02						;/ Sets the timer for the smoke sprite.
LDA #$01					;\
%SpawnSmoke()					;/ Spawns the smoke sprite.
LDA #$10					;\
STA $1DF9					;/ Sets the sound to play.
INC $1594,x					; Increments the sprite state so it gets out of this state.
LDA #$68					;\
STA $1558,x					;/ Sets the state timer.
JSR CALCULATENEXTMOVE				; Jumps to the move calculation routine.
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
HIDE3:
RTS						; Ends the code.

CAUSETROUBLE:
LDX $15E9					; Reloads the sprite index.
LDA $1558,x					;\
BNE PREPARETROUBLE				;/ Branches if the prepare trouble timer is not 0.
LDA !AnPointer					;\
CMP #$12					; | Branches if the casting animation is queued.
BEQ SUMMONED					;/
LDA #$12					;\
JSR QUEUEANIMATION				;/ Queues the casting animation.
DEC $D8,x					; Moves the sprite up a single pixel.
SUMMONED:
LDA $1564,x					;\
BNE SHAKEDELAY					;/ Branches if the shake delay time is not 0.
LDA #$10					;\
STA $1887					;/ Sets the Layer 1 shake timer.
LDA #$18					;\
STA $1DFC					;/ Sets the sound to play.
LDA #$04					;\
STA $1564,x					;/ Sets the shake delay time.
SHAKEDELAY:
RTS						; Ends the code.
PREPARETROUBLE:
LDA #$00					;\
JSR QUEUEANIMATION				;/ Queues the walking animation.
RTS						; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphic Manager
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;		     $00,$08,$20,$28,$40,$48,$60,$68
spriteAorBMode50: db $00,$00,$01,$01,$01,$01,$01,$01
;		     $80,$88,$A0,$A8,$C0,$C8,$E0,$E8
		  db $00,$00,$00,$00,$00,$00,$00,$00


;	       $00,$08,$20,$28,$40,$48,$60,$68
spriteAorB: db $00,$00,$00,$00,$01,$01,$01,$01

GraphicManager:
LDA !tileRelativePositionNormal,x		; Loads the tile relative position.
TAY						; Transfers the Accumulator to the Y Register.

LDA !mode50					;\
BEQ MODE0					;/ Branches if 50% more sprites is not enabled.
LDA spriteAorBMode50,y				;\
STA $00						;/ Loads and stores the sprite A or B flags.
BRA DYNAMICTIMER				; Branches to the dynamic timer routine.
MODE0:
LDA spriteAorB,y				;\
STA $00						;/ Loads and stores the sprite A or B flags.

DYNAMICTIMER:
LDA !AnPointer					; Loads the animation pointer x2.
REP #$30					; Turns on 16-bit addressing for the A, X, and Y Registers.
AND #$00FF					; Keeps the last 8 bits.
TAY						; Transfers the Accumulator to the Y Register.

LDA !AnFramePointer				;\
CLC						; | Adds the starting frame to the animation pointers.
ADC EndPositionAnim,y				;/
TAY						; Transfers the Accumulator to the Y Register.
SEP #$30					; Turns on 8-bit addressing for the A, X, and Y Registers.

LDA !GlobalFlipper				;\
EOR AnimationsFlips,y				; | Sets the flipping for each frame.
STA !LocalFlipper				;/

LDA !DTimer					; Loads the dynamic timer.
AND #$01					;\
CMP $00						; | Branches if the timer is not 1.
BNE SETDYNAMICROUTINE				;/

LDA !AnimationTimer				;\
BEQ ChangeFrame					;/ Branches if the animation timer is 0.
DEC !AnimationTimer				; Decrements the animation timer.
RTS						; Ends the code.

SETDYNAMICROUTINE:
LDA !DynamicSwitch				;\
BEQ DYNAMICSWITCHOFF				;/ Branches if the dynamic switch is 0.
JSR DynamicRoutine 				; Gets a dynamic slot to make the DMA routine using Dynamic Z.
DYNAMICSWITCHOFF:
RTS						; Ends the code.

ChangeFrame:
LDA !AnPointer					; Loads the animation pointer x2.
REP #$30					; Turns on 16-bit addressing for the A, X, and Y Registers.
AND #$00FF					; Keeps the last 8 bits.
TAY						; Transfers the Accumulator to the Y Register.

LDA !AnFramePointer				;\
CLC						; | Adds the starting frame to the animation pointers.
ADC EndPositionAnim,y				;/
TAY						; Transfers the Accumulator to the Y Register.
SEP #$30					; Turns on 8-bit addressing for the A, X, and Y Registers.

LDA AnimationsFrames,y				;\
STA !FramePointer				;/ Loads the frames for the new animation.

LDA AnimationsNFr,y				;\
STA !AnFramePointer				;/ Loads the order of the frames.

LDA AnimationsTFr,y				;\
STA !AnimationTimer				;/ Loads the timer for each frame.

LDA !GlobalFlipper				;\
EOR AnimationsFlips,y				; | Sets the flipping for each frame.
STA !LocalFlipper				;/

LDA #$01					;\
STA !DynamicSwitch				;/ Enables the dynamic switch.
RTS						; Ends the code.
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Animation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; See the Tutorial to know how to fill these tables.

EndPositionAnim:
	dw $0000,$0004,$0005,$0009,$000D,$000E,$0012,$0013,$0014,$0018,$001C,$001D

AnimationsFrames:
WalkFrames:
	db $00,$01,$00,$02
JumpingFrames:
	db $03
FallingFrames:
	db $04,$05,$04,$06
FlyingFrames:
	db $07,$08,$07,$09
ChargingFrames:
	db $0A
FlyingAndChargingFrames:
	db $0B,$0C,$0B,$0D
ShootingFrames:
	db $0E
FlickingFrames:
	db $0F
FlyingAndShootingFrames:
	db $10,$11,$10,$12
CastingFrames:
	db $13,$14,$13,$15
HurtFrames:
	db $16
LyingFrames:
	db $17
AnimationsNFr:
WalkNFr:
	db $01,$02,$03,$00
JumpingNFr:
	db $00
FallingNFr:
	db $01,$02,$03,$00
FlyingNFr:
	db $01,$02,$03,$00
ChargingNFr:
	db $00
FlyingAndChargingNFr:
	db $01,$02,$03,$00
ShootingNFr:
	db $00
FlickingNFr:
	db $00
FlyingAndShootingNFr:
	db $01,$02,$03,$00
CastingNFr:
	db $01,$02,$03,$00
HurtNFr:
	db $00
LyingNFr:
	db $00
AnimationsTFr:
WalkTFr:
	db $04,$04,$04,$04
JumpingTFr:
	db $00
FallingTFr:
	db $00,$00,$00,$00
FlyingTFr:
	db $02,$02,$02,$02
ChargingTFr:
	db $00
FlyingAndChargingTFr:
	db $02,$02,$02,$02
ShootingTFr:
	db $00
FlickingTFr:
	db $00
FlyingAndShootingTFr:
	db $02,$02,$02,$02
CastingTFr:
	db $02,$02,$02,$02
HurtTFr:
	db $00
LyingTFr:
	db $00
AnimationsFlips:
WalkFlips:
	db $00,$00,$00,$00
JumpingFlips:
	db $00
FallingFlips:
	db $00,$00,$00,$00
FlyingFlips:
	db $00,$00,$00,$00
ChargingFlips:
	db $00
FlyingAndChargingFlips:
	db $00,$00,$00,$00
ShootingFlips:
	db $00
FlickingFlips:
	db $00
FlyingAndShootingFlips:
	db $00,$00,$00,$00
CastingFlips:
	db $00,$00,$00,$00
HurtFlips:
	db $00
LyingFlips:
	db $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphic Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FlipAdder: db $00,$18
tileRel: db $00,$BA,$FE,$1A,$22,$7A,$9A,$C2,$80,$88,$A0,$A8,$C0,$C8,$E0,$E8
propRel: db $00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

Graphics:
REP #$10					; Turns on 16-bit addressing for the X and Y Registers.
LDY #$0000					; Loads 0 into the Y Register, this time in 16-bit.
SEP #$10					; Turns on 8-bit addressing for the X and Y Registers.

LDA !tileRelativePositionNormal,x		; Loads the tile relative position.
TAY						; Transfers the Accumulator to the Y Register.
LDA tileRel,y					;\
STA $0F						;/ Loads and stores the relative position of the tiles to $0F.

LDA !tileRelativePositionNormal,x		; Loads the tile relative position.
TAY						; Transfers the Accumulator to the Y Register.
LDA propRel,y					;\
STA $0C						;/ Loads and stores the relative tile properties to $0C.

JSL !GET_DRAW_INFO				; Jumps to the OAM handler.
LDA $06						;\
BEQ DRAW 					;/ Branches if the sprite is off-screen.
RTS						; Ends the code.

DRAW:
PHX						; Preserves the X Register.
LDA !LocalFlipper				;\
PHA						;/ Loads and preserves the sprite flipping.
LDA !FramePointer				; Loads the frame pointer.
PLX						; Pulls back the X Register.
CLC						;\
ADC FlipAdder,x					;/ Adds the starting frames based on the sprite's flipping.
REP #$30					; Turns on 16-bit addressing for the A, X, and Y Registers.

AND #$00FF					; Keeps the last 8 bits.
ASL						; Multiplies the frame pointer by 2.
TAX						; Transfers the Accumulator to the X Register.

LDA EndPositionFrames,x				;\ Loads the values to end the tile drawing loop.
STA $0D						;/ 

LDA StartPositionFrames,x			; Loads the starting value for the drawing loop.
TAX						; Transfers the Accumulator to the X Register.
SEP #$20					; Turns on 8-bit addressing for the Accumulator.

LOOP:
LDA FramesXDisp,x				;\
CLC						; | Loads the X Positions of each tile in each frame.
ADC $00						; |
STA $0300,y					;/

LDA FramesYDisp,x				;\
CLC						; |
ADC $01						; | Loads the Y Positions of each tile in each frame.
STA $0301,y					;/

LDA FramesProperty,x				;\
ORA $0C						; | Loads the Properties of each tile in each frame and adds the relative properties.
ORA $64						; |
STA $0303,y					;/
LDA FramesTile,x				; Loads the tiles in each frame.
BMI TILERELATIVE				; Branches if another dynamic sprite is using these tiles.
STA $0302,y					; Stores the tiles.
BRA TILESIZE					; Branches to the tile size routine.
TILERELATIVE:
CLC						;\
ADC $0F						;/ Adds the relative positions of the tiles on the VRAM map.
STA $0302,y					; Stores the tiles.

TILESIZE:
INY						;\
INY						; | Increments the OAM to prevent the tiles from overwriting each other.
INY						; |
INY						;/

DEX						; Decreases the X Register.
BMI FINISHDRAWING				; Branches if the X Register is a negative value.
CPX $0D						;\
BCS LOOP					;/ Branches if the X Register matches the value used to end the tile drawing loop is equal or higher.
FINISHDRAWING:
SEP #$10					; Turns on 8-bit addressing for the X and Y Registers.
PLX						; Pulls back the X register.

LDA !FramePointer				; Loads the frame pointer.
TAY						; Transfers the Accumulator to the Y Register.
LDA FramesTotalTiles,y				; Loads the number of tiles drawn -1.
LDY #$02					; Loads the sprite tile size.
JSL $81B7B3					; Calls the routine that draws the sprite.
RTS						; Ends the code.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Frames
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; See the Tutorial to know how to fill these tables.

FramesTotalTiles:
	db $01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$01,$03,$03,$03,$01,$03,$02,$02,$02,$03,$03,$03,$03,$02,$01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$01,$03,$03,$03,$01,$03,$02,$02,$02,$03,$03,$03,$03,$02
StartPositionFrames:
	dw $0001,$0003,$0005,$0008,$000B,$000E,$0011,$0015,$0019,$001D,$001F,$0023,$0027,$002B,$002D,$0031,$0034,$0037,$003A,$003E,$0042,$0046,$004A,$004D,$004F,$0051,$0053,$0056,$0059,$005C,$005F,$0063,$0067,$006B,$006D,$0071,$0075,$0079,$007B,$007F,$0082,$0085,$0088,$008C,$0090,$0094,$0098,$009B
EndPositionFrames:
	dw $0000,$0002,$0004,$0006,$0009,$000C,$000F,$0012,$0016,$001A,$001E,$0020,$0024,$0028,$002C,$002E,$0032,$0035,$0038,$003B,$003F,$0043,$0047,$004B,$004E,$0050,$0052,$0054,$0057,$005A,$005D,$0060,$0064,$0068,$006C,$006E,$0072,$0076,$007A,$007C,$0080,$0083,$0086,$0089,$008D,$0091,$0095,$0099
	
FramesXDisp:
Walk1XDisp:
	db $00,$00
Walk2XDisp:
	db $00,$00
Walk3XDisp:
	db $00,$00
JumpingXDisp:
	db $00,$00,$00
Falling1XDisp:
	db $00,$00,$10
Falling2XDisp:
	db $00,$00,$0E
Falling3XDisp:
	db $00,$00,$10
Flying1XDisp:
	db $00,$00,$10,$00
Flying2XDisp:
	db $00,$00,$10,$00
Flying3XDisp:
	db $00,$00,$10,$00
ChargingXDisp:
	db $00,$00
FlyingAndCharging1XDisp:
	db $00,$00,$10,$00
FlyingAndCharging2XDisp:
	db $00,$00,$10,$00
FlyingAndCharging3XDisp:
	db $00,$00,$10,$00
ShootingXDisp:
	db $00,$00
FlickingXDisp:
	db $FC,$04,$FC,$04
FlyingAndShooting1XDisp:
	db $00,$00,$10
FlyingAndShooting2XDisp:
	db $00,$00,$10
FlyingAndShooting3XDisp:
	db $00,$00,$10
Casting1XDisp:
	db $00,$00,$10,$00
Casting2XDisp:
	db $00,$00,$10,$00
Casting3XDisp:
	db $00,$00,$10,$00
HurtXDisp:
	db $FC,$04,$FC,$04
LyingXDisp:
	db $F9,$09,$00
Walk1FlipXXDisp:
	db $00,$00
Walk2FlipXXDisp:
	db $00,$00
Walk3FlipXXDisp:
	db $00,$00
JumpingFlipXDisp:
	db $0,$00,$00
Falling1FlipXXDisp:
	db $00,$00,$F0
Falling2FlipXXDisp:
	db $00,$00,$F2
Falling3FlipXXDisp:
	db $00,$00,$F0
Flying1FlipXXDisp:
	db $00,$00,$F0,$00
Flying2FlipXXDisp:
	db $00,$00,$F0,$00
Flying3FlipXXDisp:
	db $00,$00,$F0,$00
ChargingFlipXXDisp:
	db $00,$00
FlyingAndCharging1FlipXXDisp:
	db $00,$00,$F0,$00
FlyingAndCharging2FlipXXDisp:
	db $00,$00,$F0,$00
FlyingAndCharging3FlipXXDisp:
	db $00,$00,$F0,$00
ShootingFlipXXDisp:
	db $00,$00
FlickingFlipXXDisp:
	db $04,$FC,$04,$FC
FlyingAndShooting1FlipXXDisp:
	db $00,$00,$F0
FlyingAndShooting2FlipXXDisp:
	db $00,$00,$F0
FlyingAndShooting3FlipXXDisp:
	db $00,$00,$F0
Casting1FlipXXDisp:
	db $00,$00,$F0,$00
Casting2FlipXXDisp:
	db $00,$00,$F0,$00
Casting3FlipXXDisp:
	db $00,$00,$F0,$00
HurtFlipXXDisp:
	db $04,$FC,$04,$FC
LyingFlipXXDisp:
	db $07,$F7,$00
FramesYDisp:
Walk1YDisp:
	db $00,$10
Walk2YDisp:
	db $01,$11
Walk3YDisp:
	db $01,$11
JumpingYDisp:
	db $00,$10,$20
Falling1YDisp:
	db $00,$10,$FB
Falling2YDisp:
	db $00,$10,$FC
Falling3YDisp:
	db $00,$10,$FD
Flying1YDisp:
	db $00,$10,$08,$20
Flying2YDisp:
	db $00,$10,$08,$20
Flying3YDisp:
	db $00,$10,$0A,$20
ChargingYDisp:
	db $00,$10
FlyingAndCharging1YDisp:
	db $00,$10,$08,$20
FlyingAndCharging2YDisp:
	db $00,$10,$08,$20
FlyingAndCharging3YDisp:
	db $00,$10,$0A,$20
ShootingYDisp:
	db $00,$10
FlickingYDisp:
	db $00,$00,$10,$10
FlyingAndShooting1YDisp:
	db $00,$10,$08
FlyingAndShooting2YDisp:
	db $00,$10,$08
FlyingAndShooting3YDisp:
	db $00,$10,$0A
Casting1YDisp:
	db $00,$10,$08,$20
Casting2YDisp:
	db $00,$10,$08,$20
Casting3YDisp:
	db $00,$10,$0A,$20
HurtYDisp:
	db $00,$00,$10,$10
LyingYDisp:
	db $12,$12,$02
Walk1FlipXYDisp:
	db $00,$10
Walk2FlipXYDisp:
	db $01,$11
Walk3FlipXYDisp:
	db $01,$11
JumpingFlipXYDisp:
	db $00,$10,$20
Falling1FlipXYDisp:
	db $00,$10,$FB
Falling2FlipXYDisp:
	db $00,$10,$FC
Falling3FlipXYDisp:
	db $00,$10,$FD
Flying1FlipXYDisp:
	db $00,$10,$08,$20
Flying2FlipXYDisp:
	db $00,$10,$08,$20
Flying3FlipXYDisp:
	db $00,$10,$0A,$20
ChargingFlipXYDisp:
	db $00,$10
FlyingAndCharging1FlipXYDisp:
	db $00,$10,$08,$20
FlyingAndCharging2FlipXYDisp:
	db $00,$10,$08,$20
FlyingAndCharging3FlipXYDisp:
	db $00,$10,$0A,$20
ShootingFlipXYDisp:
	db $00,$10
FlickingFlipXYDisp:
	db $00,$00,$10,$10
FlyingAndShooting1FlipXYDisp:
	db $00,$10,$08
FlyingAndShooting2FlipXYDisp:
	db $00,$10,$08
FlyingAndShooting3FlipXYDisp:
	db $00,$10,$0A
Casting1FlipXYDisp:
	db $00,$10,$08,$20
Casting2FlipXYDisp:
	db $00,$10,$08,$20
Casting3FlipXYDisp:
	db $00,$10,$0A,$20
HurtFlipXYDisp:
	db $00,$00,$10,$10
LyingFlipXYDisp:
	db $12,$12,$02
FramesProperty:
Walk1Properties:
	db $0E,$0E
Walk2Properties:
	db $0E,$0E
Walk3Properties:
	db $0E,$0E
JumpingProperties:
	db $0E,$0E,$0E
Falling1Properties:
	db $0E,$0E,$0E
Falling2Properties:
	db $0E,$0E,$0E
Falling3Properties:
	db $0E,$0E,$0E
Flying1Properties:
	db $0E,$0E,$0E,$0E
Flying2Properties:
	db $0E,$0E,$0E,$0E
Flying3Properties:
	db $0E,$0E,$0E,$0E
ChargingProperties:
	db $0E,$0E
FlyingAndCharging1Properties:
	db $0E,$0E,$0E,$0E
FlyingAndCharging2Properties:
	db $0E,$0E,$0E,$0E
FlyingAndCharging3Properties:
	db $0E,$0E,$0E,$0E
ShootingProperties:
	db $0E,$0E
FlickingProperties:
	db $0E,$0E,$0E,$0E
FlyingAndShooting1Properties:
	db $0E,$0E,$0E
FlyingAndShooting2Properties:
	db $0E,$0E,$0E
FlyingAndShooting3Properties:
	db $0E,$0E,$0E
Casting1Properties:
	db $0E,$0E,$0E,$0E
Casting2Properties:
	db $0E,$0E,$0E,$0E
Casting3Properties:
	db $0E,$0E,$0E,$0E
HurtProperties:
	db $0E,$0E,$0E,$0E
LyingProperties:
	db $0E,$0E,$0E
Walk1FlipXProperties:
	db $4E,$4E
Walk2FlipXProperties:
	db $4E,$4E
Walk3FlipXProperties:
	db $4E,$4E
JumpingFlipXProperties:
	db $4E,$4E,$4E
Falling1FlipXProperties:
	db $4E,$4E,$4E
Falling2FlipXProperties:
	db $4E,$4E,$4E
Falling3FlipXProperties:
	db $4E,$4E,$4E
Flying1FlipXProperties:
	db $4E,$4E,$4E,$4E
Flying2FlipXProperties:
	db $4E,$4E,$4E,$4E
Flying3FlipXProperties:
	db $4E,$4E,$4E,$4E
ChargingFlipXProperties:
	db $4E,$4E
FlyingAndCharging1FlipXProperties:
	db $4E,$4E,$4E,$4E
FlyingAndCharging2FlipXProperties:
	db $4E,$4E,$4E,$4E
FlyingAndCharging3FlipXProperties:
	db $4E,$4E,$4E,$4E
ShootingFlipXProperties:
	db $4E,$4E
FlickingFlipXProperties:
	db $4E,$4E,$4E,$4E
FlyingAndShooting1FlipXProperties:
	db $4E,$4E,$4E
FlyingAndShooting2FlipXProperties:
	db $4E,$4E,$4E
FlyingAndShooting3FlipXProperties:
	db $4E,$4E,$4E
Casting1FlipXProperties:
	db $4E,$4E,$4E,$4E
Casting2FlipXProperties:
	db $4E,$4E,$4E,$4E
Casting3FlipXProperties:
	db $4E,$4E,$4E,$4E
HurtFlipXProperties:
	db $4E,$4E,$4E,$4E
LyingFlipXProperties:
	db $4E,$4E,$4E
FramesTile:
Walk1Tiles:
	db $A6,$A8
Walk2Tiles:
	db $A6,$A8
Walk3Tiles:
	db $A6,$A8
JumpingTiles:
	db $A6,$A8,$AA
Falling1Tiles:
	db $A6,$A8,$AA
Falling2Tiles:
	db $A6,$A8,$AA
Falling3Tiles:
	db $A6,$A8,$AA
Flying1Tiles:
	db $A6,$A8,$AA,$AC
Flying2Tiles:
	db $A6,$A8,$AA,$AC
Flying3Tiles:
	db $A6,$A8,$AA,$AC
ChargingTiles:
	db $A6,$A8
FlyingAndCharging1Tiles:
	db $A6,$A8,$AA,$AC
FlyingAndCharging2Tiles:
	db $A6,$A8,$AA,$AC
FlyingAndCharging3Tiles:
	db $A6,$A8,$AA,$AC
ShootingTiles:
	db $A6,$A8
FlickingTiles:
	db $A6,$A7,$A9,$AA
FlyingAndShooting1Tiles:
	db $A6,$A8,$AA
FlyingAndShooting2Tiles:
	db $A6,$A8,$AA
FlyingAndShooting3Tiles:
	db $A6,$A8,$AA
Casting1Tiles:
	db $A6,$A8,$AA,$AC
Casting2Tiles:
	db $A6,$A8,$AA,$AC
Casting3Tiles:
	db $A6,$A8,$AA,$AC
HurtTiles:
	db $A6,$A7,$A9,$AA
LyingTiles:
	db $A6,$A8,$AA
Walk1FlipXTiles:
	db $A6,$A8
Walk2FlipXTiles:
	db $A6,$A8
Walk3FlipXTiles:
	db $A6,$A8
JumpingFlipXTiles:
	db $A6,$A8,$AA
Falling1FlipXTiles:
	db $A6,$A8,$AA
Falling2FlipXTiles:
	db $A6,$A8,$AA
Falling3FlipXTiles:
	db $A6,$A8,$AA
Flying1FlipXTiles:
	db $A6,$A8,$AA,$AC
Flying2FlipXTiles:
	db $A6,$A8,$AA,$AC
Flying3FlipXTiles:
	db $A6,$A8,$AA,$AC
ChargingFlipTiles:
	db $A6,$A8
FlyingAndCharging1FlipXTiles:
	db $A6,$A8,$AA,$AC
FlyingAndCharging2FlipXTiles:
	db $A6,$A8,$AA,$AC
FlyingAndCharging3FlipXTiles:
	db $A6,$A8,$AA,$AC
ShootingFlipXTiles:
	db $A6,$A8
FlickingFlipXTiles:
	db $A6,$A7,$A9,$AA
FlyingAndShootingFlipX1Tiles:
	db $A6,$A8,$AA
FlyingAndShootingFlipX2Tiles:
	db $A6,$A8,$AA
FlyingAndShootingFlipX3Tiles:
	db $A6,$A8,$AA
Casting1FlipXTiles:
	db $A6,$A8,$AA,$AC
Casting2FlipXTiles:
	db $A6,$A8,$AA,$AC
Casting3FlipXTiles:
	db $A6,$A8,$AA,$AC
HurtFlipXTiles:
	db $A6,$A7,$A9,$AA
LyingFlipXTiles:
	db $A6,$A8,$AA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dynamic Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VramTable:
	dw $0000,$0100,$0400,$0500,$0800,$0900,$0C00,$0D00,$1000,$1100,$1400,$1500,$1800,$1900,$1C00,$1D00,$2000,$2100,$2400,$2500,$2800,$2900,$2C00,$2D00

preDynRoutine:
STZ !DynamicSwitch				; Disables the dynamic switch.

LDA !tileRelativePositionNormal,x		; Loads the tile relative position.
TAY						; Transfers the Accumulator to the Y Register.

LDA !mode50					;\
BEQ NOTMODE50					;/ Branches if 50% more sprites is not enabled.
LDA spriteAorBMode50,y				;\
STA $00						;/ Loads and stores the sprite A or B flags.
BRA DYNAMICTIMERHANDLER				; Branches to the dynamic timer routine.
NOTMODE50:
LDA spriteAorB,y				;\
STA $00						;/ Loads and stores the sprite A or B flags.

DYNAMICTIMERHANDLER:
LDA !DTimer					; Loads the dynamic timer.
AND #$01					;\
CMP $00						; | Branches if the timer is not 1.
BNE startDyn					;/
RTS						; Ends the code.

DynamicRoutine:
STZ !DynamicSwitch				; Disables the dynamic switch.

LDA !tileRelativePositionNormal,x		; Loads the tile relative position.
TAY						; Transfers the Accumulator to the Y Register.

startDyn:
JSL !DynamicRoutine32Start			; Jumps to the 32x32 dyanmic initialization routine.

LDA !FramePointer				; Loads the frame pointer.
ASL						; Multiplies it by 2.
TAY						; Transfers the Accumulator to the Y Register.

PHX						; Preserves the X Register.
LDX $0000					; Loads scratch RAM in 16-bit.

PHB						;\
PLA						;/ Puts the Data Bank into the Accumulator.
STA !dynSpBnk,x					;\
STA !dynSpBnk-$04,x				; |
LDA #$00					; | Sets the bank of the graphics.
STA !dynSpBnk+$01,x				; |
STA !dynSpBnk-$03,x				;/

REP #$20					; Turns on 16-bit addressing for the Accumulator.

LDA VramTable,y					; Loads the VRAM table.
CMP #$FFFF					;\
BEQ NOTDYNAMIC					;/ Branches if the current frame does not use dynamic graphics.
CLC						;\
ADC GFXPointer					; |
STA !dynSpRec,x					; | Gets the graphic pointer for the current frame.
CLC						; |
ADC #$0200					; |
STA !dynSpRec-$04,x				;/

LDA #$0100					;\
STA !dynSpLength,x				; | Sets the horizontal VRAM length to transfer.
STA !dynSpLength-$04,x				;/

SEP #$20					; Turns on 8-bit addressing for the Accumulator.

TXA						; Transfers the X Register to the Accumulator.
SEC						;\
SBC #$04					; |
STA !nextDynSlot,x				; | Sets the next slot of the dynamic transfer.
LDA #$00					; |
STA !nextDynSlot+$01,x				;/
LDA #$FF					;\
STA !nextDynSlot-$04,x				; | Finishes the dynamic transfer.
STA !nextDynSlot-$03,x				;/

SEP #$20					; Turns on 8-bit addressing for the Accumulator.
PLX						; Pulls back the X register.
RTS						; Ends the code.

NOTDYNAMIC:
SEP #$20					; Turns on 8-bit addressing for the Accumulator.
PLX						; Pulls back the X register.
RTS						; Ends the code.

sendSignal:
LDA !tileRelativePositionNormal,x		; Loads the tile relative position.
TAY						; Transfers the Accumulator to the Y Register.

JSL !Ping32					; Jumps to the signal sending routine.

RTS						; Ends the code.


adder: db $00,$40,$C0,$20

GFXPointer:
dw resource

; Fill this with the name of your ExGFX. (Replace "resource.bin" for the name of your graphic.bin.)
resource:
incbin bob.bin ; Replace this for the name of your GFX
