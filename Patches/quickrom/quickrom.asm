;========================
; QuickROM v1.5
; By Alcaro
; Fixes by Erik557
;========================

; Patch requirements
assert read1($808A4E) != $C2,      "Please, save a level with ExAnimation in Lunar Magic first."
assert read1($8E8000) != $3E,      "Please, run your ROM through AddmusicK first."

; Macros I stole from Alcaro

macro ClearRAMInit()
       LDA #$8008
       STA $4300
       LDA.w #AZero
       STA $4302
       LDY.b #AZero>>16
       STY $4304
       LDY #$7E
       STY $2183
endmacro

macro ClearRAM(start, count)
       LDA.w #<start>
       STA $2181
       LDA.w #<count>
       STA $4305
       LDY #$01
       STY $420B
endmacro

; Actual patch begins here

; Wiggler INIT: Replace pointless repeated LDAs with XBAs (I'd prefer 16bit mode, but that'd use one byte more than I have).
org $82EFF8
       LDY #$00
       LDA $E4,x
       XBA
       LDA $D8,x
-      STA [$D5],y
       XBA
       INY
       BPL -
       padbyte $EA : pad $82F008

; Sprite buoyancy: Replace crappy loop with a lookup table
org $80F04D
       PHX
       TAX
       LDA.l BuoyancyTable-$6E,x   ; this routine only gets called for 6E and higher, no point keeping them around when they're never used
       LSR
       PLX
       RTL

; Level data clearing: Replace slow semi-unrolled STA loop with DMA
org $858074
       JMP ClearLevelData

org $858089
ClearLevelData_Return:

org $8582C8
ClearLevelData:
       ; This is freespace. Originally it's a long, ugly list of STAs, but replacing it with a nice little DMA makes it both smaller and faster.
       ; No, you're not supposed to move it. Don't even try.
       SEP #$10
       REP #$20
       LDY #$7E
.Loop
       LDA #$C800
       STA $2181
       STY $2183
       LDA #$8008
       STA $4300
       TYA
       CLC
       ADC.w #.SourceData-$7E
       STA $4302
       LDX.b #.SourceData>>16
       STX $4304
       LDA #$3800
       STA $4305
       LDX #$01
       STX $420B
       INY
       BPL .Loop
       JMP .Return
.SourceData
       dw $0025      ; This is the tile the entire level is filled with. Do NOT change it to $012F.

BuoyancyTable:       ; The sprite bouyancy boost needs a chunk of freespace, and the above routine frees up a bit, so why not?
AZero:               ; Yay, data reuse. This one is for the RAM clearing routines.
       ;   x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xA  xB  xC  xD  xE  xF
       db                                                         $00,$00    ;6x
       db $00,$01,$01,$00,$00,$00,$01,$01,$00,$00,$00,$01,$01,$00,$00,$00    ;7x
       db $00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$01,$01,$00,$00,$00,$01    ;8x
       db $01,$00,$00,$00,$01,$01,$00,$00,$00,$01,$01,$00,$00,$00,$01,$01    ;9x
       db $00,$00,$00,$01,$01,$00,$00,$00,$01,$01,$00,$00,$00,$01,$01,$00    ;Ax
       db $00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00    ;Bx
       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00    ;Cx
       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00    ;Dx
       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00    ;Ex
       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00    ;Fx

; Various RAM clearing routines: Replace loops with DMA
org $80A1A6
Clear_1A_13D3:
       REP #$20
       autoclean JML QuickClear1A13D3
.Return
       SEP #$20
       RTS

org $80A674
CODE_00A674:
       REP #$20
       autoclean JML QuickClear7013D9
org $80A681
.End
       SEP #$20

org $808A4E
       REP #$20
       %ClearRAMInit()
       autoclean JML QuickClearNonStack

org $82AC48
CODE_02AC48:
       REP #$20
       autoclean JML QuickClear1693
.Return
       STZ $143E
       SEP #$20
       RTS

freedata
QuickClearNonStack:
       %ClearRAM($7E0000, $0100)
       %ClearRAM($7E0200, $1E00)
       LDA #$0000
       STA $7F837B
       STA $7FC0C0          ;\
       STA $7FC0C7          ; |
       STA $7FC0CE          ; |
       STA $7FC0D5          ; | restore LM's hijack
       STA $7FC0DC          ; | (i have no idea what these are, maybe manual ExAnimation triggers?)
       STA $7FC0E3          ; |
       STA $7FC0EA          ; |
       STA $7FC0F1          ;/
       SEP #$20
       DEC
       STA $7F837D
       JML $808A78

QuickClear1A13D3:
       %ClearRAMInit()
       %ClearRAM($7E001A, $00BE)
       %ClearRAM($7E13D3, $07CF)
       JML Clear_1A_13D3_Return

QuickClear7013D9:
       %ClearRAMInit()
       %ClearRAM($7E0070, $0024)
       %ClearRAM($7E13D9, $0038)
       JML CODE_00A674_End

QuickClear1693:
       %ClearRAMInit()
       %ClearRAM($7E1693, $027B)
       JML CODE_02AC48_Return
