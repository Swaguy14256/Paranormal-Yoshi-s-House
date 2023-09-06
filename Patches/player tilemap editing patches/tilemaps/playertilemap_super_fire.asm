if read1($00FFD5) == $23
	sa1rom
else
	lorom
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario World: Player Tilemap Editing Patch ;;
;;    - Super/Fire Mario and Super/Fire Luigi -    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Walking/Running Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SuperWalk1Top = $70			; \ Super Mario/Luigi, Walking 1
!SuperWalk1Bottom = $02			; /

!SuperWalk2Top = $70			; \ Super Mario/Luigi, Walking 2
!SuperWalk2Bottom = $01			; /

!SuperWalk3Top = $70			; \ Super Mario/Luigi, Walking 3
!SuperWalk3Bottom = $00			; /

!SuperRun1Top = $70			; \ Super Mario/Luigi, Running 1
!SuperRun1Bottom = $14			; /

!SuperRun2Top = $70			; \ Super Mario/Luigi, Running 2
!SuperRun2Bottom = $13			; /

!SuperRun3Top = $70			; \ Super Mario/Luigi, Running 3
!SuperRun3Bottom = $12			; /

!SuperRunDiagonalTop = $17		; \ Super Mario/Luigi, Beginning To Run Up A Wall
!SuperRunDiagonalBottom = $E7		; /

!SuperRunUpWall1Top = $A4		; \ Super Mario/Luigi, Running Up A Wall 1
!SuperRunUpWall1Bottom = $25		; /

!SuperRunUpWall2Top = $A4		; \ Super Mario/Luigi, Running Up A Wall 2
!SuperRunUpWall2Bottom = $24		; /

!SuperRunUpWall3Top = $A4		; \ Super Mario/Luigi, Running Up A Wall 3
!SuperRunUpWall3Bottom = $23		; /

!SuperTurnTop = $80			; \ Super Mario/Luigi, Turning
!SuperTurnBottom = $04			; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Jumping/Ducking Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SuperLookUpTop = $A0			; \ Super Mario/Luigi, Looking Up
!SuperLookUpBottom = $02		; /

!SuperJumpTop = $74			; \ Super Mario/Luigi, Jumping
!SuperJumpBottom = $03			; /

!SuperFlyTop = $70			; \ Super Mario/Luigi, Flying
!SuperFlyBottom = $15			; /

!SuperFallTop = $C7			; \ Super Mario/Luigi, Falling
!SuperFallBottom = $D2			; /

!SuperDuckTop = $C5			; \ Super Mario/Luigi, Ducking
!SuperDuckBottom = $06			; /

!SuperSlideTop = $70			; \ Super Mario/Luigi, Sliding
!SuperSlideBottom = $32			; /

!SuperFaceForwardTop = $84		; \ Super Mario/Luigi, Facing The Screen
!SuperFaceForwardBottom = $07		; / * displayed for Using A Pipe/Turning While Holding An Item

!SuperFaceAwayTop = $90			; \ Super Mario/Luigi, Facing Away From The Screen
!SuperFaceAwayBottom = $10		; / * displayed for Sweeping The Castle Away 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Holding/Kicking Item Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SuperWalkWithItem1Top = $70		; \ Super Mario/Luigi, Walking With An Item 1
!SuperWalkWithItem1Bottom = $30		; /

!SuperWalkWithItem2Top = $70		; \ Super Mario/Luigi, Walking With An Item 2
!SuperWalkWithItem2Bottom = $27		; /

!SuperWalkWithItem3Top = $70		; \ Super Mario/Luigi, Walking With An Item 3
!SuperWalkWithItem3Bottom = $26		; /

!SuperLookUpWithItemTop = $A0		; \ Super Mario/Luigi, Looking Up While Holding An Item
!SuperLookUpWithItemBottom = $30	; /

!SuperDuckWithItemTop = $E2		; \ Super Mario/Luigi, Ducking While Holding An Item/Ducking On Yoshi
!SuperDuckWithItemBottom = $F2		; /

!SuperKickItemTop = $70			; \ Super Mario/Luigi, Kicking An Item
!SuperKickItemBottom = $31		; /

!SuperSwimWithItem1Top = $4F		; \ Super Mario/Luigi, Swimming While Holding An Item 1
!SuperSwimWithItem1Bottom = $91		; /

!SuperSwimWithItem2Top = $4F		; \ Super Mario/Luigi, Swimming While Holding An Item 2
!SuperSwimWithItem2Bottom = $92		; /

!SuperSwimWithItem3Top = $4F		; \ Super Mario/Luigi, Swimming While Holding An Item 3
!SuperSwimWithItem3Bottom = $A1		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Swimming Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SuperSwim1Top = $70			; \ Super Mario/Luigi, Swimming 1
!SuperSwim1Bottom = $33			; /

!SuperSwim2Top = $70			; \ Super Mario/Luigi, Swimming 2
!SuperSwim2Bottom = $34			; /

!SuperSwim3Top = $70			; \ Super Mario/Luigi, Swimming 3
!SuperSwim3Bottom = $35			; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Climbing/Riding Yoshi Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SuperClimbTop = $B0			; \ Super Mario/Luigi, Climbing
!SuperClimbBottom = $36			; / * these tiles are flipped to animate Climbing

!SuperClimbBehindTop = $63		; \ Super Mario/Luigi, Climbing Behind A Net
!SuperClimbBehindBottom = $C2		; /

!SuperPunchNetTop = $72			; \ Super Mario/Luigi, Punching A Net
!SuperPunchNetBottom = $73		; /

!SuperPunchBehindTop = $82		; \ Super Mario/Luigi, Punching A Net From Behind
!SuperPunchBehindBottom = $83		; /

!SuperNetTurnTop = $0F			; \ Super Mario/Luigi, Turning On A Net 1
!SuperNetTurnBottom = $1F		; /

!SuperRideYoshiTop = $61		; \ Super Mario/Luigi, Riding Yoshi/Turning On A Net 2
!SuperRideYoshiBottom = $C0		; /

!SuperTurnYoshiTop = $70		; \ Super Mario/Luigi, Turning Yoshi/Turning On A Net 3
!SuperTurnYoshiBottom = $C1		; /

!SuperYoshiEat1Top = $D4		; \ Super Mario/Luigi, Making Yoshi Eat 1
!SuperYoshiEat1Bottom = $E4		; /

!SuperYoshiEat2Top = $A5		; \ Super Mario/Luigi, Making Yoshi Eat 2
!SuperYoshiEat2Bottom = $B5		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Level End/Castle Destruction Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SuperLevelEndTop = $B3			; \ Super Mario/Luigi, Level End Pose
!SuperLevelEndBottom = $B7		; /

!SuperLevelEndYoshiTop = $B3		; \ Super Mario/Luigi, Level End Pose While Riding Yoshi
!SuperLevelEndYoshiBottom = $62		; /

!SuperCarryHammerTop = $5D		; \ Super Mario/Luigi, Carrying A Hammer
!SuperCarryHammerBottom = $6D		; /

!SuperSwingHammer1Top = $5E		; \ Super Mario/Luigi, Swinging A Hammer 1
!SuperSwingHammer1Bottom = $6E		; /

!SuperSwingHammer2Top = $5F		; \ Super Mario/Luigi, Swinging A Hammer 2
!SuperSwingHammer2Bottom = $6F		; /

!SuperWatchCastleTop = $48		; \ Super Mario/Luigi, Watching The Castle Explode
!SuperWatchCastleBottom = $58		; /

!SuperWatchFlyingCastle1Top = $4B	; \ Super Mario/Luigi, Watching The Exploding Castle Fly Away 1
!SuperWatchFlyingCastle1Bottom = $02	; /

!SuperWatchFlyingCastle2Top = $4C	; \ Super Mario/Luigi, Watching The Exploding Castle Fly Away 2
!SuperWatchFlyingCastle2Bottom = $02	; /

!SuperExploded1Top = $49		; \ Super Mario/Luigi, Blown-Up By An Explosion 1
!SuperExploded1Bottom = $59		; /

!SuperExploded2Top = $4A		; \ Super Mario/Luigi, Blown-Up By An Explosion 2
!SuperExploded2Bottom = $59		; /

!SuperSweep2Top  = $90			; \ Super Mario/Luigi, Sweeping The Castle Away 2
!SuperSweep2Bottom = $68		; /

!SuperSweep3Top = $E3			; \ Super Mario/Luigi, Sweeping The Castle Away 3
!SuperSweep3Bottom = $F3		; /

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Gliding Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Changing SuperGlide2Top to $64 will make Super/Fire Mario and Super/Fire Luigi
; have exactly the same tilemap as Cape Mario/Luigi in ROMs with otherwise unhacked player tilemaps.
; This could be useful for players who use other hacks to combine Fire and Cape power.
; SuperGlide2Top is the only tile different between the player tilemaps for the Super/Fire and Cape power-ups.

!SuperGlide1Top = $08			; \ Super Mario/Luigi, Gliding 1
!SuperGlide1Bottom = $0A		; /

!SuperGlide2Top = $54			; \ Super Mario/Luigi, Gliding 2
!SuperGlide2Bottom = $55		; /

!SuperGlide3Top = $0C			; \ Super Mario/Luigi, Gliding 3
!SuperGlide3Bottom = $0D		; /

!SuperGlide4Top = $0E			; \ Super Mario/Luigi, Gliding 4
!SuperGlide4Bottom = $75		; /

!SuperGlide5Top = $1B			; \ Super Mario/Luigi, Gliding 5
!SuperGlide5Bottom = $77		; /

!SuperGlide6Top = $51			; \ Super Mario/Luigi, Gliding 6
!SuperGlide6Bottom = $1E		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario/Luigi, Unused Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The following frames are unused in unhacked ROMs and so can be used for custom animations

!SuperUnused1Top = $C0			; \ Super Mario/Luigi, Unused 1
!SuperUnused1Bottom = $61		; / * inversion of Riding Yoshi/Turning On A Net 2

!SuperUnused2Top = $5F			; \ Super Mario/Luigi, Unused 2
!SuperUnused2Bottom = $6F		; / * identical to Swinging A Hammer 2 in unhacked ROMs

!SuperUnused3Top = $5F			; \ Super Mario/Luigi, Unused 3
!SuperUnused3Bottom = $6F		; / * identical to Swinging A Hammer 2 in unhacked ROMs


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DO NOT MODIFY ANYTHING BELOW THIS POINT!!! ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00E052
db !SuperWalk1Top, !SuperWalk2Top, !SuperWalk3Top, !SuperLookUpTop, !SuperRun1Top, !SuperRun2Top, !SuperRun3Top, !SuperWalkWithItem1Top, !SuperWalkWithItem2Top, !SuperWalkWithItem3Top, !SuperLookUpWithItemTop, !SuperJumpTop, !SuperFlyTop, !SuperTurnTop, !SuperKickItemTop, !SuperFaceForwardTop, !SuperRunDiagonalTop, !SuperRunUpWall1Top, !SuperRunUpWall2Top, !SuperRunUpWall3Top, !SuperLevelEndYoshiTop, !SuperClimbTop, !SuperSwim1Top, !SuperSwimWithItem1Top, !SuperSwim2Top, !SuperSwimWithItem2Top, !SuperSwim3Top, !SuperSwimWithItem3Top, !SuperSlideTop, !SuperDuckWithItemTop, !SuperPunchNetTop, !SuperNetTurnTop, !SuperRideYoshiTop, !SuperTurnYoshiTop, !SuperClimbBehindTop, !SuperPunchBehindTop, !SuperFallTop, !SuperFaceAwayTop, !SuperLevelEndTop, !SuperYoshiEat1Top, !SuperYoshiEat2Top, !SuperUnused1Top, !SuperGlide1Top, !SuperGlide2Top, !SuperGlide3Top, !SuperGlide4Top, !SuperGlide5Top, !SuperGlide6Top, !SuperExploded1Top, !SuperExploded2Top, !SuperWatchCastleTop, !SuperWatchFlyingCastle1Top, !SuperWatchFlyingCastle2Top, !SuperCarryHammerTop, !SuperSwingHammer1Top, !SuperSwingHammer2Top, !SuperSweep3Top, !SuperSweep2Top, !SuperUnused2Top, !SuperUnused3Top, !SuperDuckTop

org $00E112
db !SuperWalk1Bottom, !SuperWalk2Bottom, !SuperWalk3Bottom, !SuperLookUpBottom, !SuperRun1Bottom, !SuperRun2Bottom, !SuperRun3Bottom, !SuperWalkWithItem1Bottom, !SuperWalkWithItem2Bottom, !SuperWalkWithItem3Bottom, !SuperLookUpWithItemBottom, !SuperJumpBottom, !SuperFlyBottom, !SuperTurnBottom, !SuperKickItemBottom, !SuperFaceForwardBottom, !SuperRunDiagonalBottom, !SuperRunUpWall1Bottom, !SuperRunUpWall2Bottom, !SuperRunUpWall3Bottom, !SuperLevelEndYoshiBottom, !SuperClimbBottom, !SuperSwim1Bottom, !SuperSwimWithItem1Bottom, !SuperSwim2Bottom, !SuperSwimWithItem2Bottom, !SuperSwim3Bottom, !SuperSwimWithItem3Bottom, !SuperSlideBottom, !SuperDuckWithItemBottom, !SuperPunchNetBottom, !SuperNetTurnBottom, !SuperRideYoshiBottom, !SuperTurnYoshiBottom, !SuperClimbBehindBottom, !SuperPunchBehindBottom, !SuperFallBottom, !SuperFaceAwayBottom, !SuperLevelEndBottom, !SuperYoshiEat1Bottom, !SuperYoshiEat2Bottom, !SuperUnused1Bottom, !SuperGlide1Bottom, !SuperGlide2Bottom, !SuperGlide3Bottom, !SuperGlide4Bottom, !SuperGlide5Bottom, !SuperGlide6Bottom, !SuperExploded1Bottom, !SuperExploded2Bottom, !SuperWatchCastleBottom, !SuperWatchFlyingCastle1Bottom, !SuperWatchFlyingCastle2Bottom, !SuperCarryHammerBottom, !SuperSwingHammer1Bottom, !SuperSwingHammer2Bottom, !SuperSweep3Bottom, !SuperSweep2Bottom, !SuperUnused2Bottom, !SuperUnused3Bottom, !SuperDuckBottom