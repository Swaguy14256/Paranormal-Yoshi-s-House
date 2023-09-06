lorom 
header 

!FreeRAM	= $7E0DC6 ;$7EC120
!FreeRAM_SA1	= $61FF	

; SA-1/FastROM defines, do not edit.
!bank		= $800000
!addr		= $0000

if read1($00ffd5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
	!FreeRAM = !FreeRAM_SA1
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



org $05DA24
			autoclean JML CodeStart

org $05DAAC
			autoclean JML CodeStart2

org $00A692
			autoclean JML CodeStart3;okay, so the code starts at four places...?


org $00C870
			autoclean JML CodeStart4

; ==============================
; Levelnum.ips disassembly
; ==============================

ORG $05D8B9
		JSR Levelnummain

ORG $05DC46
Levelnummain:	LDA $0E  		;Load level number
		STA $010B|!addr		;Store it in free stack RAM
		ASL A    		;Multiply level number by 2
		RTS      		;Return from subroutine and return the level value... or something
			

freedata ; this one doesn't change the data bank register, so it uses the RAM mirrors from another bank, so I might as well toss it into banks 40+

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CodeStart:		;

		REP #$30
			LDA $0E
			AND #$01FF
			TAX
		SEP #$20
			LDA #$00
			STA !FreeRAM
			LDA.l E_DATA,x
		SEP #$10
			BNE .Skip_00
			
			LDA #$01
			STA $1B9B|!addr
			
.Return			JML $05DAD7|!bank		;0...yoshi禁止無効

.Return1		JML $05DAD0|!bank

.Skip_00
			CMP #$01
			BNE .Custom
				
			LDX #$04
			LDY #$04
			JML $05DA28|!bank		;1..通常の振る舞い

.Custom			LDY #$03
			LDX #$04
			LDA $141A|!addr		;2..カスタム
			BNE .Return
			LDA $141D|!addr
			BNE .Return
			LDA $141F|!addr 
			BNE .Return
			LDA $13CF|!addr 
			BNE .Return1
			LDA #$AB
			STA !FreeRAM
			;JML $05DA65|!bank
			LDA #$60
			STA $96
			LDA #$01
			STA $97
			LDA #$30
			STA $94
			STZ $95
			LDA #$C0
			STA $1C
			STA $20
			STZ $192A|!addr
			JML $05DA8A|!bank







CodeStart2:		LDA !FreeRAM
			CMP #$AB
			BEQ .Custom2
			
			
			TXA			;通常の振る舞い
			ASL
			CLC
			ADC $00
			JML $05DAB1|!bank


.Custom2	REP #$30
			LDA $0E
			AND #$01FF
			TAX
			LDA.l E_DATA,x
			AND #$00FF
			STA $00
			ASL
			CLC
			ADC $00
			TAX
			SEP #$20
			LDA $05E000|!bank,x			;levelPtr1
			STA $65
			LDA $05E001|!bank,x
			STA $66
			LDA $05E002|!bank,x
			STA $67
			LDA $05E600|!bank,x			;levelPtr2
			STA $68
			LDA $05E601|!bank,x
			STA $69
			LDA $05E602|!bank,x
			STA $6A
		REP #$20
			LDA $00
			ASL
			TAX
		SEP #$20
			LDA $05EC00|!bank,x			;levelPtrS
			STA $CE
			LDA $05EC01|!bank,x
			STA $CF
			LDX $00
			LDA $0EF100|!bank,x
			STA $D0
		SEP #$10
			LDY #$04
			LDA [$65],y
			AND #$0F
			STA $1931|!addr

			LDA $05F200|!bank,x
			AND #$C0
			CLC
			ASL
			ROL
			ROL
			STA $1BE3|!addr
			STZ $141D|!addr
			STZ $141A|!addr
			STZ $141F|!addr
			STZ $13CF|!addr
			LDX #$05
			JML $05DAD7|!bank			;$00A6C5あたりを気をつける



CodeStart3:		LDY #$01
			LDX $1931|!addr
			LDA !FreeRAM
			CMP #$AB
			BEQ .Custom3
			JML $00A697|!bank

.Custom3		STZ $1497|!addr
			JML $00A6B6|!bank


CodeStart4:		STZ $13E2|!addr		;A=7;
			LDX $1931|!addr
			LDA !FreeRAM
			CMP #$AB
			BEQ .Custom4
			LDA #$07
			JML $00C876|!bank

.Custom4		JML $00C88D|!bank
			
			
			

E_DATA:			incsrc Data.asm


; $141D,$141A,$141F,$13CFが全て０でなければならない
; Tileset$1931から得られるデータが02以上でなければならない
;
;
;＄９６Ｆ４があやしい
;LoadLevelにはL1,L2のロードしか含まれない　02A751がスプライト？
;その中でも特に01808C
;
;EnterCastleAniがあやしい
;
;Sprite dataはコースに読み出す必要が無い！？
;$CEから直接読んでいる
;よって無効化されているのはそっち
