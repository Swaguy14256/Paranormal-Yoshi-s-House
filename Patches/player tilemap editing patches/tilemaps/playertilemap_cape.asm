if read1($00FFD5) == $23
	sa1rom
else
	lorom
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario World: Player Tilemap Editing Patch ;;
;;             - Cape Mario/Luigi -                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Walking/Running Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeWalk1Top = $70			; \ Cape Mario/Luigi, Walking 1
!CapeWalk1Bottom = $02			; /

!CapeWalk2Top = $70			; \ Cape Mario/Luigi, Walking 2
!CapeWalk2Bottom = $01			; /

!CapeWalk3Top = $70			; \ Cape Mario/Luigi, Walking 3
!CapeWalk3Bottom = $00			; /

!CapeRun1Top = $70			; \ Cape Mario/Luigi, Running 1
!CapeRun1Bottom = $14			; /

!CapeRun2Top = $70			; \ Cape Mario/Luigi, Running 2
!CapeRun2Bottom = $13			; /

!CapeRun3Top = $70			; \ Cape Mario/Luigi, Running 3
!CapeRun3Bottom = $12			; /

!CapeRunDiagonalTop = $17		; \ Cape Mario/Luigi, Beginning To Run Up A Wall
!CapeRunDiagonalBottom = $E7		; / (the sideways diagonal pose)

!CapeRunUpWall1Top = $A4		; \ Cape Mario/Luigi, Running Up A Wall 1
!CapeRunUpWall1Bottom = $25		; /

!CapeRunUpWall2Top = $A4		; \ Cape Mario/Luigi, Running Up A Wall 2
!CapeRunUpWall2Bottom = $24		; /

!CapeRunUpWall3Top = $A4		; \ Cape Mario/Luigi, Running Up A Wall 3
!CapeRunUpWall3Bottom = $23		; /

!CapeTurnTop = $80			; \ Cape Mario/Luigi, Turning
!CapeTurnBottom = $04			; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Jumping/Ducking Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeLookUpTop = $A0			; \ Cape Mario/Luigi, Looking Up
!CapeLookUpBottom = $02			; /

!CapeJumpTop = $74			; \ Cape Mario/Luigi, Jumping
!CapeJumpBottom = $03			; /

!CapeFlyTop = $70			; \ Cape Mario/Luigi, Flying
!CapeFlyBottom = $15			; /

!CapeFallTop = $C7			; \ Cape Mario/Luigi, Falling
!CapeFallBottom = $D2			; /

!CapeDuckTop = $C5			; \ Cape Mario/Luigi, Ducking
!CapeDuckBottom = $06			; /

!CapeSlideTop = $70			; \ Cape Mario/Luigi, Sliding
!CapeSlideBottom = $32			; /

!CapeFaceForwardTop = $84		; \ Cape Mario/Luigi, Facing The Screen
!CapeFaceForwardBottom = $07		; / * displayed for Using A Pipe/Turning While Holding An Item

!CapeFaceAwayTop = $90			; \ Cape Mario/Luigi, Facing Away From The Screen
!CapeFaceAwayBottom = $10		; / * displayed for Sweeping The Castle Away 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Holding/Kicking Item Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeWalkWithItem1Top = $70		; \ Cape Mario/Luigi, Walking With An Item 1
!CapeWalkWithItem1Bottom = $30		; /

!CapeWalkWithItem2Top = $70		; \ Cape Mario/Luigi, Walking With An Item 2
!CapeWalkWithItem2Bottom = $27		; /

!CapeWalkWithItem3Top = $70		; \ Cape Mario/Luigi, Walking With An Item 3
!CapeWalkWithItem3Bottom = $26		; /

!CapeLookUpWithItemTop = $A0		; \ Cape Mario/Luigi, Looking Up While Holding An Item
!CapeLookUpWithItemBottom = $30		; /

!CapeDuckWithItemTop = $E2		; \ Cape Mario/Luigi, Ducking While Holding An Item/Ducking On Yoshi
!CapeDuckWithItemBottom = $F2		; /

!CapeKickItemTop = $70			; \ Cape Mario/Luigi, Kicking An Item
!CapeKickItemBottom = $31		; /

!CapeSwimWithItem1Top = $4F		; \ Cape Mario/Luigi, Swimming While Holding An Item 1
!CapeSwimWithItem1Bottom = $91		; /

!CapeSwimWithItem2Top = $4F		; \ Cape Mario/Luigi, Swimming While Holding An Item 2
!CapeSwimWithItem2Bottom = $92		; /

!CapeSwimWithItem3Top = $4F		; \ Cape Mario/Luigi, Swimming While Holding An Item 3
!CapeSwimWithItem3Bottom = $A1		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Swimming Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeSwim1Top = $70			; \ Cape Mario/Luigi, Swimming 1
!CapeSwim1Bottom = $33			; /

!CapeSwim2Top = $70			; \ Cape Mario/Luigi, Swimming 2
!CapeSwim2Bottom = $34			; /

!CapeSwim3Top = $70			; \ Cape Mario/Luigi, Swimming 3
!CapeSwim3Bottom = $35			; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Climbing/Riding Yoshi Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeClimbTop = $B0			; \ Cape Mario/Luigi, Climbing
!CapeClimbBottom = $36			; / * these tiles are flipped to animate Climbing

!CapeClimbBehindTop = $63		; \ Cape Mario/Luigi, Climbing Behind A Net
!CapeClimbBehindBottom = $C2		; /

!CapePunchNetTop = $72			; \ Cape Mario/Luigi, Punching A Net
!CapePunchNetBottom = $73		; /

!CapePunchBehindTop = $82		; \ Cape Mario/Luigi, Punching A Net From Behind
!CapePunchBehindBottom = $83		; /

!CapeNetTurnTop = $0F			; \ Cape Mario/Luigi, Turning On A Net 1
!CapeNetTurnBottom = $1F		; /

!CapeRideYoshiTop = $61			; \ Cape Mario/Luigi, Riding Yoshi/Turning On A Net 2
!CapeRideYoshiBottom = $C0		; /

!CapeTurnYoshiTop = $70			; \ Cape Mario/Luigi, Turning Yoshi/Turning On A Net 3
!CapeTurnYoshiBottom = $C1		; /

!CapeYoshiEat1Top = $D4			; \ Cape Mario/Luigi, Making Yoshi Eat 1
!CapeYoshiEat1Bottom = $E4		; /

!CapeYoshiEat2Top = $A5			; \ Cape Mario/Luigi, Making Yoshi Eat 2
!CapeYoshiEat2Bottom = $B5		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Level End/Castle Destruction Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeLevelEndTop = $B3			; \ Cape Mario/Luigi, Level End Pose
!CapeLevelEndBottom = $B7		; /

!CapeLevelEndYoshiTop = $B3		; \ Cape Mario/Luigi, Level End Pose While Riding Yoshi
!CapeLevelEndYoshiBottom = $62		; /

!CapeCarryHammerTop = $5D		; \ Cape Mario/Luigi, Carrying A Hammer
!CapeCarryHammerBottom = $6D		; /

!CapeSwingHammer1Top = $5E		; \ Cape Mario/Luigi, Swinging A Hammer 1
!CapeSwingHammer1Bottom = $6E		; /

!CapeSwingHammer2Top = $5F		; \ Cape Mario/Luigi, Swinging A Hammer 2
!CapeSwingHammer2Bottom = $6F		; /

!CapeWatchCastleTop = $48		; \ Cape Mario/Luigi, Watching The Castle Explode
!CapeWatchCastleBottom = $58		; /

!CapeWatchFlyingCastle1Top = $4B	; \ Cape Mario/Luigi, Watching The Exploding Castle Fly Away 1
!CapeWatchFlyingCastle1Bottom = $02	; /

!CapeWatchFlyingCastle2Top = $4C	; \ Cape Mario/Luigi, Watching The Exploding Castle Fly Away 2
!CapeWatchFlyingCastle2Bottom = $02	; /

!CapeExploded1Top = $49			; \ Cape Mario/Luigi, Blown-Up By An Explosion 1
!CapeExploded1Bottom = $59		; /

!CapeExploded2Top = $4A			; \ Cape Mario/Luigi, Blown-Up By An Explosion 2
!CapeExploded2Bottom = $59		; /

!CapeSweep2Top  = $90			; \ Cape Mario/Luigi, Sweeping The Castle Away 2
!CapeSweep2Bottom = $68			; /

!CapeSweep3Top = $E3			; \ Cape Mario/Luigi, Sweeping The Castle Away 3
!CapeSweep3Bottom = $F3			; /

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Gliding Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!CapeGlide1Top = $08			; \ Cape Mario/Luigi, Gliding 1
!CapeGlide1Bottom = $0A			; /

!CapeGlide2Top = $64			; \ Cape Mario/Luigi, Gliding 2
!CapeGlide2Bottom = $55			; /

!CapeGlide3Top = $0C			; \ Cape Mario/Luigi, Gliding 3
!CapeGlide3Bottom = $0D			; /

!CapeGlide4Top = $0E			; \ Cape Mario/Luigi, Gliding 4
!CapeGlide4Bottom = $75			; /

!CapeGlide5Top = $1B			; \ Cape Mario/Luigi, Gliding 5
!CapeGlide5Bottom = $77			; /

!CapeGlide6Top = $51			; \ Cape Mario/Luigi, Gliding 6
!CapeGlide6Bottom = $1E			; /

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cape Mario/Luigi, Unused Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The following frames are unused in unhacked ROMs and so can be used for custom animations

!CapeUnused1Top = $C0			; \ Cape Mario/Luigi, Unused 1
!CapeUnused1Bottom = $61		; / * inversion of Riding Yoshi/Turning On A Net 2

!CapeUnused2Top = $5F			; \ Cape Mario/Luigi, Unused 2
!CapeUnused2Bottom = $6F		; / * identical to Swinging A Hammer 2 in unhacked ROMs

!CapeUnused3Top = $5F			; \ Cape Mario/Luigi, Unused 3
!CapeUnused3Bottom = $6F		; / * identical to Swinging A Hammer 2 in unhacked ROMs


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DO NOT MODIFY ANYTHING BELOW THIS POINT!!! ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00E08F
db !CapeWalk1Top, !CapeWalk2Top, !CapeWalk3Top, !CapeLookUpTop, !CapeRun1Top, !CapeRun2Top, !CapeRun3Top, !CapeWalkWithItem1Top, !CapeWalkWithItem2Top, !CapeWalkWithItem3Top, !CapeLookUpWithItemTop, !CapeJumpTop, !CapeFlyTop, !CapeTurnTop, !CapeKickItemTop, !CapeFaceForwardTop, !CapeRunDiagonalTop, !CapeRunUpWall1Top, !CapeRunUpWall2Top, !CapeRunUpWall3Top, !CapeLevelEndYoshiTop, !CapeClimbTop, !CapeSwim1Top, !CapeSwimWithItem1Top, !CapeSwim2Top, !CapeSwimWithItem2Top, !CapeSwim3Top, !CapeSwimWithItem3Top, !CapeSlideTop, !CapeDuckWithItemTop, !CapePunchNetTop, !CapeNetTurnTop, !CapeRideYoshiTop, !CapeTurnYoshiTop, !CapeClimbBehindTop, !CapePunchBehindTop, !CapeFallTop, !CapeFaceAwayTop, !CapeLevelEndTop, !CapeYoshiEat1Top, !CapeYoshiEat2Top, !CapeUnused1Top, !CapeGlide1Top, !CapeGlide2Top, !CapeGlide3Top, !CapeGlide4Top, !CapeGlide5Top, !CapeGlide6Top, !CapeExploded1Top, !CapeExploded2Top, !CapeWatchCastleTop, !CapeWatchFlyingCastle1Top, !CapeWatchFlyingCastle2Top, !CapeCarryHammerTop, !CapeSwingHammer1Top, !CapeSwingHammer2Top, !CapeSweep3Top, !CapeSweep2Top, !CapeUnused2Top, !CapeUnused3Top, !CapeDuckTop

org $00E14F
db !CapeWalk1Bottom, !CapeWalk2Bottom, !CapeWalk3Bottom, !CapeLookUpBottom, !CapeRun1Bottom, !CapeRun2Bottom, !CapeRun3Bottom, !CapeWalkWithItem1Bottom, !CapeWalkWithItem2Bottom, !CapeWalkWithItem3Bottom, !CapeLookUpWithItemBottom, !CapeJumpBottom, !CapeFlyBottom, !CapeTurnBottom, !CapeKickItemBottom, !CapeFaceForwardBottom, !CapeRunDiagonalBottom, !CapeRunUpWall1Bottom, !CapeRunUpWall2Bottom, !CapeRunUpWall3Bottom, !CapeLevelEndYoshiBottom, !CapeClimbBottom, !CapeSwim1Bottom, !CapeSwimWithItem1Bottom, !CapeSwim2Bottom, !CapeSwimWithItem2Bottom, !CapeSwim3Bottom, !CapeSwimWithItem3Bottom, !CapeSlideBottom, !CapeDuckWithItemBottom, !CapePunchNetBottom, !CapeNetTurnBottom, !CapeRideYoshiBottom, !CapeTurnYoshiBottom, !CapeClimbBehindBottom, !CapePunchBehindBottom, !CapeFallBottom, !CapeFaceAwayBottom, !CapeLevelEndBottom, !CapeYoshiEat1Bottom, !CapeYoshiEat2Bottom, !CapeUnused1Bottom, !CapeGlide1Bottom, !CapeGlide2Bottom, !CapeGlide3Bottom, !CapeGlide4Bottom, !CapeGlide5Bottom, !CapeGlide6Bottom, !CapeExploded1Bottom, !CapeExploded2Bottom, !CapeWatchCastleBottom, !CapeWatchFlyingCastle1Bottom, !CapeWatchFlyingCastle2Bottom, !CapeCarryHammerBottom, !CapeSwingHammer1Bottom, !CapeSwingHammer2Bottom, !CapeSweep3Bottom, !CapeSweep2Bottom, !CapeUnused2Bottom, !CapeUnused3Bottom, !CapeDuckBottom