!DisableDropping	= !False	; If true then the reserve item will NOT drop if you get hurt
!DroppingIfOnlyBig	= !True		; If the above is false, this one is unused.

;From now on, please do not change
!True			= 1
!False			= 0

lorom

; Do not edit there
if read1($00FFD5) == $23
	!SA1 = 1
	sa1rom
else
	!SA1 = 0
endif

; There too
if !SA1
	; SA-1 base addresses
	!Base1 = $3000
	!Base2 = $6000
	!FastMirror = $000000
else
	; Non SA-1 base addresses
	!Base1 = $0000
	!Base2 = $0000
	!FastMirror = $800000
endif

org $00F5F3|!FastMirror
autoclean JSL PowerDown
RTL

freecode
print "Patch location: $",pc
PowerDown:
PHX
if !DisableDropping|!DroppingIfOnlyBig == !False
	JSL $028008|!FastMirror
endif
LDA $19
DEC
ASL : TAX
JSR (Actions,x)
PLX
RTL

; Feel free to add more actions if you use more power ups
; (e.g. through LX5's custom power up patch).
Actions:
dw .Mushroom	; .Shrink
dw .Cape	; .Smoke
dw .FireFlower	; .Palette

; Shrinking
.Shrink
.Mushroom
if !DisableDropping == !False
	if !DroppingIfOnlyBig == !True
		JSL $028008|!FastMirror
	endif
endif
LDA #$04
STA $1DF9|!Base2
LDA #$2F
STA $1496|!Base2
STA $9D
LDA #$01
STA $71
STZ $19
RTS

; Transforming to a smoke
.Smoke
.Cape
LDA #$0C
STA $1DF9|!Base2
JSL $01C5AE
INC $9D
LDA #$7F		;\
STA $1497|!Base2	;/ Sets the invulnerability timer.
LDA #$01
STA $19
RTS

; Cycling through the palette
.Palette
.FireFlower
LDA #$20
STA $149B|!Base2
STA $9D
LDA #$04
STA $71
LDA #$04
STA $1DF9|!Base2
STZ $1407|!Base2
LDA #$7F
STA $1497|!Base2
LDA #$01
STA $19
RTS

print "Freespace used: ",freespaceuse," bytes."