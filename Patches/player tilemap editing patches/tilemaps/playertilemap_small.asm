if read1($00FFD5) == $23
	sa1rom
else
	lorom
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario World: Player Tilemap Editing Patch ;;
;;             - Small Mario/Luigi -               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Walking/Running Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallWalk1Top = $50			; \ Small Mario/Luigi, Walking 1
!SmallWalk1Bottom = $71			; /

!SmallWalk2Top = $50			; \ Small Mario/Luigi, Walking 2
!SmallWalk2Bottom = $60			; /

!SmallWalk3Top = $50			; \ Small Mario/Luigi, Walking 3
!SmallWalk3Bottom = $60			; / * identical to Walking 2 in unhacked ROMs

!SmallRun1Top = $50			; \ Small Mario/Luigi, Running 1
!SmallRun1Bottom = $94			; /

!SmallRun2Top = $50			; \ Small Mario/Luigi, Running 2
!SmallRun2Bottom = $96			; /

!SmallRun3Top = $50			; \ Small Mario/Luigi, Running 3
!SmallRun3Bottom = $96			; / * identical to Running 2 in unhacked ROMs

!SmallRunDiagonalTop = $2E		; \ Small Mario/Luigi, Beginning To Run Up A Wall
!SmallRunDiagonalBottom = $2F		; /

!SmallRunUpWall1Top = $C4		; \ Small Mario/Luigi, Running Up A Wall 1
!SmallRunUpWall1Bottom = $D3		; /

!SmallRunUpWall2Top = $C4		; \ Small Mario/Luigi, Running Up A Wall 2
!SmallRunUpWall2Bottom = $C3		; /

!SmallRunUpWall3Top = $C4		; \ Small Mario/Luigi, Running Up A Wall 3
!SmallRunUpWall3Bottom = $C3		; / * identical to Running Up A Wall 2 in unhacked ROMs

!SmallTurnTop = $2D			; \ Small Mario/Luigi, Turning
!SmallTurnBottom = $3D			; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Jumping/Ducking Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallLookUpTop = $09			; \ Small Mario/Luigi, Looking Up
!SmallLookUpBottom = $19		; /

!SmallJumpTop = $2B			; \ Small Mario/Luigi, Jumping
!SmallJumpBottom = $3B			; /

!SmallFlyTop = $50			; \ Small Mario/Luigi, Flying
!SmallFlyBottom = $B4			; /

!SmallFallTop = $2C			; \ Small Mario/Luigi, Falling
!SmallFallBottom = $3C			; /

!SmallDuckTop = $C5			; \ Small Mario/Luigi, Ducking
!SmallDuckBottom = $4E			; /

!SmallSlideTop = $50			; \ Small Mario/Luigi, Sliding
!SmallSlideBottom = $A6			; /

!SmallFaceForwardTop = $D5		; \ Small Mario/Luigi, Spin-Jumping (Facing The Screen)
!SmallFaceForwardBottom = $E5		; / * also displayed for Using A Pipe/Turning While Holding An Item

!SmallFaceAwayTop = $B6			; \ Small Mario/Luigi, Spin-Jumping (Facing Away From The Screen)
!SmallFaceAwayBottom = $C6		; / * also displayed for Sweeping The Castle Away 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Holding/Kicking Item Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallWalkWithItem1Top = $50		; \ Small Mario/Luigi, Walking With An Item 1
!SmallWalkWithItem1Bottom = $A2		; /

!SmallWalkWithItem2Top = $50		; \ Small Mario/Luigi, Walking With An Item 2
!SmallWalkWithItem2Bottom = $97		; /

!SmallWalkWithItem3Top = $50		; \ Small Mario/Luigi, Walking With An Item 3
!SmallWalkWithItem3Bottom = $97		; / * identical to Walking With An Item 2 in unhacked ROMs

!SmallLookUpWithItemTop = $09		; \ Small Mario/Luigi, Looking Up While Holding An Item
!SmallLookUpWithItemBottom = $18	; /

!SmallDuckWithItemTop = $C5		; \ Small Mario/Luigi, Ducking While Holding An Item/Ducking On Yoshi
!SmallDuckWithItemBottom = $D1		; /

!SmallKickItemTop = $50			; \ Small Mario/Luigi, Kicking An Item
!SmallKickItemBottom = $A7		; /

!SmallSwimWithItem1Top = $50		; \ Small Mario/Luigi, Swimming While Holding An Item 1
!SmallSwimWithItem1Bottom = $81		; /

!SmallSwimWithItem2Top = $50		; \ Small Mario/Luigi, Swimming While Holding An Item 2
!SmallSwimWithItem2Bottom = $86		; /

!SmallSwimWithItem3Top = $50		; \ Small Mario/Luigi, Swimming While Holding An Item 3
!SmallSwimWithItem3Bottom = $87		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Swimming Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallSwim1Top = $50			; \ Small Mario/Luigi, Swimming 1
!SmallSwim1Bottom = $B1			; /

!SmallSwim2Top = $50			; \ Small Mario/Luigi, Swimming 2
!SmallSwim2Bottom = $B2			; /

!SmallSwim3Top = $50			; \ Small Mario/Luigi, Swimming 3
!SmallSwim3Bottom = $B4			; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Climbing/Riding Yoshi Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallClimbTop = $B6			; \ Small Mario/Luigi, Climbing
!SmallClimbBottom = $D0			; / * these tiles are flipped to animate Climbing

!SmallClimbBehindTop = $D5		; \ Small Mario/Luigi, Climbing Behind A Net
!SmallClimbBehindBottom = $F5		; /

!SmallPunchNetTop = $D7			; \ Small Mario/Luigi, Punching A Net
!SmallPunchNetBottom = $F7		; /

!SmallPunchBehindTop = $29		; \ Small Mario/Luigi, Punching A Net From Behind
!SmallPunchBehindBottom = $39		; /

!SmallNetTurnTop = $2A			; \ Small Mario/Luigi, Turning On A Net 1
!SmallNetTurnBottom = $3A		; /

!SmallRideYoshiTop = $E0		; \ Small Mario/Luigi, Riding Yoshi/Turning On A Net 2
!SmallRideYoshiBottom = $F0		; /

!SmallTurnYoshiTop = $50		; \ Small Mario/Luigi, Turning Yoshi/Turning On A Net 3
!SmallTurnYoshiBottom = $F4		; /

!SmallYoshiEat1Top = $28		; \ Small Mario/Luigi, Making Yoshi Eat 1
!SmallYoshiEat1Bottom = $38		; /

!SmallYoshiEat2Top = $E0		; \ Small Mario/Luigi, Making Yoshi Eat 2
!SmallYoshiEat2Bottom = $F1		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Level End/Castle Destruction Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallLevelEndTop = $D6			; \ Small Mario/Luigi, Level End Pose
!SmallLevelEndBottom = $E6		; /

!SmallLevelEndYoshiTop = $D6		; \ Small Mario/Luigi, Level End Pose While Riding Yoshi
!SmallLevelEndYoshiBottom = $F6		; /

!SmallCarryHammerTop = $50		; \ Small Mario/Luigi, Carrying A Hammer
!SmallCarryHammerBottom = $60		; /

!SmallSwingHammer1Top = $28		; \ Small Mario/Luigi, Swinging A Hammer 1
!SmallSwingHammer1Bottom = $38		; /

!SmallSwingHammer2Top = $28		; \ Small Mario/Luigi, Swinging A Hammer 2
!SmallSwingHammer2Bottom = $F1		; /

!SmallWatchCastleTop = $50		; \ Small Mario/Luigi, Watching The Castle Explode
!SmallWatchCastleBottom = $71		; /

!SmallWatchFlyingCastle1Top = $5A	; \ Small Mario/Luigi, Watching The Exploding Castle Fly Away 1
!SmallWatchFlyingCastle1Bottom = $6A	; /

!SmallWatchFlyingCastle2Top = $B6	; \ Small Mario/Luigi, Watching The Exploding Castle Fly Away 2
!SmallWatchFlyingCastle2Bottom = $6B	; /

!SmallExploded1Top = $5C		; \ Small Mario/Luigi, Blown-Up By An Explosion 1
!SmallExploded1Bottom = $6C		; /

!SmallExploded2Top = $5C		; \ Small Mario/Luigi, Blown-Up By An Explosion 2
!SmallExploded2Bottom = $4D		; /

!SmallSweep2Top  = $D7			; \ Small Mario/Luigi, Sweeping The Castle Away 2
!SmallSweep2Bottom = $69		; /

!SmallSweep3Top = $C5			; \ Small Mario/Luigi, Sweeping The Castle Away 3
!SmallSweep3Bottom = $5B		; /

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Gliding Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!SmallGlide1Top = $C5			; \
!SmallGlide1Bottom = $C5		;  |
!SmallGlide2Top = $C5			;  |
!SmallGlide2Bottom = $C5		;  |
!SmallGlide3Top = $C5			;  |
!SmallGlide3Bottom = $C5		;   \ Small Mario/Luigi, Gliding 1-6
!SmallGlide4Top = $C5			;   / * unused frames in unhacked ROMs
!SmallGlide4Bottom = $C5		;  |
!SmallGlide5Top = $C5			;  |
!SmallGlide5Bottom = $C5		;  |
!SmallGlide6Top = $C5			;  |
!SmallGlide6Bottom = $C5		; /


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario/Luigi, Unused Frames ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The following frames are unused in unhacked ROMs and so can be used for custom animations

!SmallUnused1Top = $E0			; \ Small Mario/Luigi, Unused 1
!SmallUnused1Bottom = $F0		; / * identical to Riding Yoshi/Turning On A Net 2

!SmallUnused2Top = $28			; \ Small Mario/Luigi, Unused 2
!SmallUnused2Bottom = $F1		; / * identical to Swinging A Hammer 2 in unhacked ROMs

!SmallUnused3Top = $70			; \ Small Mario/Luigi, Unused 3
!SmallUnused3Bottom = $F1		; / * glitched graphics


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DO NOT MODIFY ANYTHING BELOW THIS POINT!!! ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00E00C
db !SmallWalk1Top, !SmallWalk2Top, !SmallWalk3Top, !SmallLookUpTop, !SmallRun1Top, !SmallRun2Top, !SmallRun3Top, !SmallWalkWithItem1Top, !SmallWalkWithItem2Top, !SmallWalkWithItem3Top, !SmallLookUpWithItemTop, !SmallJumpTop, !SmallFlyTop, !SmallTurnTop, !SmallKickItemTop, !SmallFaceForwardTop, !SmallRunDiagonalTop, !SmallRunUpWall1Top, !SmallRunUpWall2Top, !SmallRunUpWall3Top, !SmallLevelEndYoshiTop, !SmallClimbTop, !SmallSwim1Top, !SmallSwimWithItem1Top, !SmallSwim2Top, !SmallSwimWithItem2Top, !SmallSwim3Top, !SmallSwimWithItem3Top, !SmallSlideTop, !SmallDuckWithItemTop, !SmallPunchNetTop, !SmallNetTurnTop, !SmallRideYoshiTop, !SmallTurnYoshiTop, !SmallClimbBehindTop, !SmallPunchBehindTop, !SmallFallTop, !SmallFaceAwayTop, !SmallLevelEndTop, !SmallYoshiEat1Top, !SmallYoshiEat2Top, !SmallUnused1Top, !SmallGlide1Top, !SmallGlide2Top, !SmallGlide3Top, !SmallGlide4Top, !SmallGlide5Top, !SmallGlide6Top, !SmallExploded1Top, !SmallExploded2Top, !SmallWatchCastleTop, !SmallWatchFlyingCastle1Top, !SmallWatchFlyingCastle2Top, !SmallCarryHammerTop, !SmallSwingHammer1Top, !SmallSwingHammer2Top, !SmallSweep3Top, !SmallSweep2Top, !SmallUnused2Top, !SmallUnused3Top, !SmallDuckTop

org $00E0CC
db !SmallWalk1Bottom, !SmallWalk2Bottom, !SmallWalk3Bottom, !SmallLookUpBottom, !SmallRun1Bottom, !SmallRun2Bottom, !SmallRun3Bottom, !SmallWalkWithItem1Bottom, !SmallWalkWithItem2Bottom, !SmallWalkWithItem3Bottom, !SmallLookUpWithItemBottom, !SmallJumpBottom, !SmallFlyBottom, !SmallTurnBottom, !SmallKickItemBottom, !SmallFaceForwardBottom, !SmallRunDiagonalBottom, !SmallRunUpWall1Bottom, !SmallRunUpWall2Bottom, !SmallRunUpWall3Bottom, !SmallLevelEndYoshiBottom, !SmallClimbBottom, !SmallSwim1Bottom, !SmallSwimWithItem1Bottom, !SmallSwim2Bottom, !SmallSwimWithItem2Bottom, !SmallSwim3Bottom, !SmallSwimWithItem3Bottom, !SmallSlideBottom, !SmallDuckWithItemBottom, !SmallPunchNetBottom, !SmallNetTurnBottom, !SmallRideYoshiBottom, !SmallTurnYoshiBottom, !SmallClimbBehindBottom, !SmallPunchBehindBottom, !SmallFallBottom, !SmallFaceAwayBottom, !SmallLevelEndBottom, !SmallYoshiEat1Bottom, !SmallYoshiEat2Bottom, !SmallUnused1Bottom, !SmallGlide1Bottom, !SmallGlide2Bottom, !SmallGlide3Bottom, !SmallGlide4Bottom, !SmallGlide5Bottom, !SmallGlide6Bottom, !SmallExploded1Bottom, !SmallExploded2Bottom, !SmallWatchCastleBottom, !SmallWatchFlyingCastle1Bottom, !SmallWatchFlyingCastle2Bottom, !SmallCarryHammerBottom, !SmallSwingHammer1Bottom, !SmallSwingHammer2Bottom, !SmallSweep3Bottom, !SmallSweep2Bottom, !SmallUnused2Bottom, !SmallUnused3Bottom, !SmallDuckBottom