if read1($00FFD5) == $23
	sa1rom
else
	lorom
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario World: Player Tilemap Editing Patch ;;
;;       - Mario/Luigi Special Animations -        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!PoweringUpTop = $70 		; \ Mario/Luigi, Powering Up Animation
!PoweringUpBottom = $E1		; / * these tiles are used to show animation between power-ups

!DyingTop = $1C 		; \ Small Mario/Luigi, Dying Animation
!DyingBottom = $1D		; / * these tiles are flipped to animate Dying

!ThrowFireTop = $93 		; \ Fire Mario/Luigi, Throwing A Fireball
!ThrowFireBottom = $A3		; /

!SpecialUnused1Top = $C5 	; \ Mario/Luigi, Special Unused 1
!SpecialUnused1Bottom = $C5	; / * blank animation frame, unknown use

!SpecialUnused2Top = $C5 	; \ Mario/Luigi, Special Unused 2
!SpecialUnused2Bottom = $C5	; / * blank animation frame, unknown use

!SmallPBalloonTop = $0B 	; \ Small Mario/Luigi, P-Balloon
!SmallPBalloonBottom = $1A	; / * mirrored to create Small P-Balloon Mario/Luigi

!BigPBalloonTop = $85 		; \ Super/Fire/Cape Mario and Super/Fire/Cape Luigi, P-Balloon
!BigPBalloonBottom = $95	; / * mirrored to create Super P-Balloon Mario/Luigi

!SuperSpinBackTop = $90 	; \ Mario/Luigi, Spin-Jump (back)
!SuperSpinBackBottom = $10	; /

!SuperSpinFrontTop = $84 	; \ Mario/Luigi, Spin-Jump (front)
!SuperSpinFrontBottom = $07	; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DO NOT MODIFY ANYTHING BELOW THIS POINT!!! ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00E049
db !PoweringUpTop, !DyingTop, !ThrowFireTop, !SpecialUnused1Top, !SpecialUnused2Top, !SmallPBalloonTop, !BigPBalloonTop, !SuperSpinBackTop, !SuperSpinFrontTop

org $00E109
db !PoweringUpBottom, !DyingBottom, !ThrowFireBottom, !SpecialUnused1Bottom, !SpecialUnused2Bottom, !SmallPBalloonBottom, !BigPBalloonBottom, !SuperSpinBackBottom, !SuperSpinFrontBottom