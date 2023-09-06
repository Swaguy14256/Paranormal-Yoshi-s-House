header
lorom

!Event = $00


org $0094A3
autoclean JSL Main

freecode

Main:
LDA.b #1<<(!Event&7^7)
TSB.w !Event/8+$1F02;Those two lines are to set the correct event flag btw.
;TSB.w !Event/8+$1FA9;This is so the flag gets saved.
;LDX #$8C
LDX #$15		; Loads a loop count of 21.
-
;LDA $1EA2,x
;STA $1F49,x;bad lardboy, dont eat my patches for no reason.
LDA $1F11,x		;\
STA $1F85,x		;/ Stores the submap, overworld animation, and X and Y positions of Mario and Luigi into backup RAM.
DEX
BPL -

REP #$30		; Turns on 16-bit addressing for the A, X, and Y Registers.
LDX $0DD6		; Loads the current player.
TXA			; Transfers the X Register to the Accumulator.
EOR #$0004		; Swaps the current player.
TAY			; Transfers the Accumulator to the Y Register.
LDA $1FBE-$33,x		;\
STA $1FBE-$33,y		; |
LDA $1FC0-$33,x		; |
STA $1FC0-$33,y		; | Sets the X and Y positions of both players to the current player's X and Y positions.
LDA $1FC6-$33,x		; |
STA $1FC6-$33,y		; |
LDA $1FC8-$33,x		; |
STA $1FC8-$33,y		;/
TXA			; Transfers the X Register to the Accumulator.
LSR			; Divides the current player by 2.
TAX			; Transfers the Accumulator to the X Register.
EOR #$0002		; Swaps the current player.
TAY			; Transfers the Accumulator to the Y Register.
LDA $1FBA-$33,x		;\
STA $1FBA-$33,y		;/ Sets the overworld animation for both players to the current player's overworld animation.
TXA			; Transfers the X Register to the Accumulator.
SEP #$30		; Turns on 8-bit addressing for the A, X, and Y Registers.
LSR			; Divides the current player by 2.
TAX			; Transfers the Accumulator to the X Register.
EOR #$01		; Swaps the current player.
TAY			; Transfers the Accumulator to the Y Register.
LDA $1FB8-$33,x		;\
STA $1FB8-$33,y		;/ Sets the submap for both players to the current player's submap.

LDX $13BF		; Loads the current translevel number.
LDA $1EA2,x		;\
AND #$80		; | Branches if the current level is completed.
BNE LEVELCOMPLETED	;/
INC $1F2E		; Increases the number of events triggered.
LEVELCOMPLETED:
LDA $1EA2,x		;\
ORA #$80		; | Sets the level to be completed and clears the midway point flag.
AND #$BF		; |
STA $1EA2,x		;/
REP #$20		; Turns on 16-bit addressing for the Accumulator.
LDA $7FB4D9,x		;\
AND #$FF00		; | Clears the extra midway points for the current level.
STA $7FB4D9,x		;/
STZ $0DC3		; Clears the coin backup for both Mario and Luigi.
SEP #$20		; Turns on 8-bit addressing for the Accumulator.

LDX $0DB3		; Loads the current player.
LDA $0DBE		;\
STA $0DB4,x		;/ Sets the life counter for the current player.
LDA $0DBF		;\
STA $0DB6,x		;/ Sets the coins for the current player.
LDA $19			;\
STA $0DB8,x		;/ Sets the power-up status for the current player.
LDA $13C7		;\
STA $0DBA,x		;/ Sets the Yoshi color for the current player.
LDA $0DC2		;\
STA $0DBC,x		;/ Sets the reserve item for the current player.

LDA $1F34		;\
AND #$80		; | Branches if the player has not collected all Dragon Coins in Yoshi's House.
BEQ NODRAGONCOINS	;/
LDA #$01		;\
STA $0F3A		;/ Sets the all Dragon Coins completion flag.
NODRAGONCOINS:
LDA $1F41		;\
AND #$80		; | Branches if the player has not found the hidden 1-Up Mushroom in Yoshi's House.
BEQ NOMUSHROOM		;/
LDA #$01		;\
STA $0F3B		;/ Sets the all hidden 1-Up Mushrooms completion flag.
NOMUSHROOM:
LDA $1FF3		;\
AND #$80		; | Branches if the player has not found the 3-Up Moon in Yoshi's House.
BEQ NOMOON		;/
LDA #$01		;\
STA $0F3C		;/ Sets the all 3-Up Moons completion flag.
NOMOON:
LDX #$01		; Loads a loop count of 1.
MAXLIVESLOOP:
LDA $0DB4,x		;\
CMP #$62		; | Branches if one of the players has 99 lives.
BCS MAXLIVES		;/
DEX			; Decreases the X Register.
BPL MAXLIVESLOOP	; Loops the max lives loop until it is -1.
STZ $0F3D		; Clears the max lives completion flag.
BRA FINISHSAVE		; Branches to the finish save routine.
MAXLIVES:
LDA #$01		;\
STA $0F3D		;/ Sets the max lives completion flag.
FINISHSAVE:
LDX #$03		; Loads a loop count of 3.
LDA #$00		; Loads 0.
CLC			; Clears the carry flag.
COMPLETIONLOOP:
ADC $0F3A,x		;\
STA $0DDC		;/ Adds each completion flag to the total number of completions.
DEX			; Decreases the X Register.
BPL COMPLETIONLOOP	; Loops the completion loop until it is negative.
LDA #$01		;\
STA $0F45		;/ Sets the force continue screen flag.
JSL $809BC9;Save
JML $8C93DD;Hijacked code