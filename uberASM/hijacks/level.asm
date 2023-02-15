
!level	= $010B+!Base2		;Patches rely on this, changing this is bad. Don't.

ORG $05D8B7
BRA +
NOP #3;the levelnum patch goes here in many ROMs, just skip over it
+
REP #$30
	LDA $0E		
	STA !level
	ASL		
	CLC		
	ADC $0E		
	TAY		
	LDA.w $E000,Y
	STA $65		
	LDA.w $E001,Y
	STA $66		
	LDA.w $E600,Y
	STA $68		
	LDA.w $E601,Y
	STA $69		
	BRA +
ORG $05D8E0
	+

ORG $00A242
	%clean("JML main")
	NOP
	
ORG $00A295
	NOP #4

ORG $00A5EE
        %clean("JML init")

%origin(!level_freespace)

main:
	LDA $13D4+!Base2
	BNE +
		JSL $7F8000
	+
	PHB				
	PHK				
	PLB				
	REP #$30			
	LDA !level
	ASL A				
	TAX				
	LDA level_asm_table,x		
	JSR run_code		
	PLB				
	LDA $13D4+!Base2
	BEQ +
	JML $00A25B
+	
	JML $00A28A

init:
	PHB
	PHK
	PLB
        LDA !level
        ASL A
        TAX
        LDA level_init_table,x
	JSR run_code
	PLB
        PHK
        PEA.w .return-1
        PEA $84CE
        JML $00919B
.return
	JML $00A5F3

run_code:
        STA $00
        SEP #$30
        LDX #$00
        JSR (!Base1,x)
        RTS

;Editing below this point breaks things. don't.
level_asm_table:
dw level0	
dw level1	
dw level2	
dw level3	
dw level4
dw level5
dw level6
dw level7
dw level8
dw level9
dw levelA
dw levelB
dw levelC
dw levelD
dw levelE
dw levelF
dw level10
dw level11
dw level12
dw level13
dw level14
dw level15
dw level16
dw level17
dw level18
dw level19
dw level1A
dw level1B
dw level1C
dw level1D
dw level1E
dw level1F
dw level20
dw level21
dw level22
dw level23
dw level24
dw level25
dw level26
dw level27
dw level28
dw level29
dw level2A
dw level2B
dw level2C
dw level2D
dw level2E
dw level2F
dw level30
dw level31
dw level32
dw level33
dw level34
dw level35
dw level36
dw level37
dw level38
dw level39
dw level3A
dw level3B
dw level3C
dw level3D
dw level3E
dw level3F
dw level40
dw level41
dw level42
dw level43
dw level44
dw level45
dw level46
dw level47
dw level48
dw level49
dw level4A
dw level4B
dw level4C
dw level4D
dw level4E
dw level4F
dw level50
dw level51
dw level52
dw level53
dw level54
dw level55
dw level56
dw level57
dw level58
dw level59
dw level5A
dw level5B
dw level5C
dw level5D
dw level5E
dw level5F
dw level60
dw level61
dw level62
dw level63
dw level64
dw level65
dw level66
dw level67
dw level68
dw level69
dw level6A
dw level6B
dw level6C
dw level6D
dw level6E
dw level6F
dw level70
dw level71
dw level72
dw level73
dw level74
dw level75
dw level76
dw level77
dw level78
dw level79
dw level7A
dw level7B
dw level7C
dw level7D
dw level7E
dw level7F
dw level80
dw level81
dw level82
dw level83
dw level84
dw level85
dw level86
dw level87
dw level88
dw level89
dw level8A
dw level8B
dw level8C
dw level8D
dw level8E
dw level8F
dw level90
dw level91
dw level92
dw level93
dw level94
dw level95
dw level96
dw level97
dw level98
dw level99
dw level9A
dw level9B
dw level9C
dw level9D
dw level9E
dw level9F
dw levelA0
dw levelA1
dw levelA2
dw levelA3
dw levelA4
dw levelA5
dw levelA6
dw levelA7
dw levelA8
dw levelA9
dw levelAA
dw levelAB
dw levelAC
dw levelAD
dw levelAE
dw levelAF
dw levelB0
dw levelB1
dw levelB2
dw levelB3
dw levelB4
dw levelB5
dw levelB6
dw levelB7
dw levelB8
dw levelB9
dw levelBA
dw levelBB
dw levelBC
dw levelBD
dw levelBE
dw levelBF
dw levelC0
dw levelC1
dw levelC2
dw levelC3
dw levelC4
dw levelC5
dw levelC6
dw levelC7
dw levelC8
dw levelC9
dw levelCA
dw levelCB
dw levelCC
dw levelCD
dw levelCE
dw levelCF
dw levelD0
dw levelD1
dw levelD2
dw levelD3
dw levelD4
dw levelD5
dw levelD6
dw levelD7
dw levelD8
dw levelD9
dw levelDA
dw levelDB
dw levelDC
dw levelDD
dw levelDE
dw levelDF
dw levelE0
dw levelE1
dw levelE2
dw levelE3
dw levelE4
dw levelE5
dw levelE6
dw levelE7
dw levelE8
dw levelE9
dw levelEA
dw levelEB
dw levelEC
dw levelED
dw levelEE
dw levelEF
dw levelF0
dw levelF1
dw levelF2
dw levelF3
dw levelF4
dw levelF5
dw levelF6
dw levelF7
dw levelF8
dw levelF9
dw levelFA
dw levelFB
dw levelFC
dw levelFD
dw levelFE
dw levelFF
dw level100
dw level101
dw level102
dw level103
dw level104
dw level105
dw level106
dw level107
dw level108
dw level109
dw level10A
dw level10B
dw level10C
dw level10D
dw level10E
dw level10F
dw level110
dw level111
dw level112
dw level113
dw level114
dw level115
dw level116
dw level117
dw level118
dw level119
dw level11A
dw level11B
dw level11C
dw level11D
dw level11E
dw level11F
dw level120
dw level121
dw level122
dw level123
dw level124
dw level125
dw level126
dw level127
dw level128
dw level129
dw level12A
dw level12B
dw level12C
dw level12D
dw level12E
dw level12F
dw level130
dw level131
dw level132
dw level133
dw level134
dw level135
dw level136
dw level137
dw level138
dw level139
dw level13A
dw level13B
dw level13C
dw level13D
dw level13E
dw level13F
dw level140
dw level141
dw level142
dw level143
dw level144
dw level145
dw level146
dw level147
dw level148
dw level149
dw level14A
dw level14B
dw level14C
dw level14D
dw level14E
dw level14F
dw level150
dw level151
dw level152
dw level153
dw level154
dw level155
dw level156
dw level157
dw level158
dw level159
dw level15A
dw level15B
dw level15C
dw level15D
dw level15E
dw level15F
dw level160
dw level161
dw level162
dw level163
dw level164
dw level165
dw level166
dw level167
dw level168
dw level169
dw level16A
dw level16B
dw level16C
dw level16D
dw level16E
dw level16F
dw level170
dw level171
dw level172
dw level173
dw level174
dw level175
dw level176
dw level177
dw level178
dw level179
dw level17A
dw level17B
dw level17C
dw level17D
dw level17E
dw level17F
dw level180
dw level181
dw level182
dw level183
dw level184
dw level185
dw level186
dw level187
dw level188
dw level189
dw level18A
dw level18B
dw level18C
dw level18D
dw level18E
dw level18F
dw level190
dw level191
dw level192
dw level193
dw level194
dw level195
dw level196
dw level197
dw level198
dw level199
dw level19A
dw level19B
dw level19C
dw level19D
dw level19E
dw level19F
dw level1A0
dw level1A1
dw level1A2
dw level1A3
dw level1A4
dw level1A5
dw level1A6
dw level1A7
dw level1A8
dw level1A9
dw level1AA
dw level1AB
dw level1AC
dw level1AD
dw level1AE
dw level1AF
dw level1B0
dw level1B1
dw level1B2
dw level1B3
dw level1B4
dw level1B5
dw level1B6
dw level1B7
dw level1B8
dw level1B9
dw level1BA
dw level1BB
dw level1BC
dw level1BD
dw level1BE
dw level1BF
dw level1C0
dw level1C1
dw level1C2
dw level1C3
dw level1C4
dw level1C5
dw level1C6
dw level1C7
dw level1C8
dw level1C9
dw level1CA
dw level1CB
dw level1CC
dw level1CD
dw level1CE
dw level1CF
dw level1D0
dw level1D1
dw level1D2
dw level1D3
dw level1D4
dw level1D5
dw level1D6
dw level1D7
dw level1D8
dw level1D9
dw level1DA
dw level1DB
dw level1DC
dw level1DD
dw level1DE
dw level1DF
dw level1E0
dw level1E1
dw level1E2
dw level1E3
dw level1E4
dw level1E5
dw level1E6
dw level1E7
dw level1E8
dw level1E9
dw level1EA
dw level1EB
dw level1EC
dw level1ED
dw level1EE
dw level1EF
dw level1F0
dw level1F1
dw level1F2
dw level1F3
dw level1F4
dw level1F5
dw level1F6
dw level1F7
dw level1F8
dw level1F9
dw level1FA
dw level1FB
dw level1FC
dw level1FD
dw level1FE
dw level1FF

level_init_table:
dw levelinit0	
dw levelinit1	
dw levelinit2	
dw levelinit3	
dw levelinit4
dw levelinit5
dw levelinit6
dw levelinit7
dw levelinit8
dw levelinit9
dw levelinitA
dw levelinitB
dw levelinitC
dw levelinitD
dw levelinitE
dw levelinitF
dw levelinit10
dw levelinit11
dw levelinit12
dw levelinit13
dw levelinit14
dw levelinit15
dw levelinit16
dw levelinit17
dw levelinit18
dw levelinit19
dw levelinit1A
dw levelinit1B
dw levelinit1C
dw levelinit1D
dw levelinit1E
dw levelinit1F
dw levelinit20
dw levelinit21
dw levelinit22
dw levelinit23
dw levelinit24
dw levelinit25
dw levelinit26
dw levelinit27
dw levelinit28
dw levelinit29
dw levelinit2A
dw levelinit2B
dw levelinit2C
dw levelinit2D
dw levelinit2E
dw levelinit2F
dw levelinit30
dw levelinit31
dw levelinit32
dw levelinit33
dw levelinit34
dw levelinit35
dw levelinit36
dw levelinit37
dw levelinit38
dw levelinit39
dw levelinit3A
dw levelinit3B
dw levelinit3C
dw levelinit3D
dw levelinit3E
dw levelinit3F
dw levelinit40
dw levelinit41
dw levelinit42
dw levelinit43
dw levelinit44
dw levelinit45
dw levelinit46
dw levelinit47
dw levelinit48
dw levelinit49
dw levelinit4A
dw levelinit4B
dw levelinit4C
dw levelinit4D
dw levelinit4E
dw levelinit4F
dw levelinit50
dw levelinit51
dw levelinit52
dw levelinit53
dw levelinit54
dw levelinit55
dw levelinit56
dw levelinit57
dw levelinit58
dw levelinit59
dw levelinit5A
dw levelinit5B
dw levelinit5C
dw levelinit5D
dw levelinit5E
dw levelinit5F
dw levelinit60
dw levelinit61
dw levelinit62
dw levelinit63
dw levelinit64
dw levelinit65
dw levelinit66
dw levelinit67
dw levelinit68
dw levelinit69
dw levelinit6A
dw levelinit6B
dw levelinit6C
dw levelinit6D
dw levelinit6E
dw levelinit6F
dw levelinit70
dw levelinit71
dw levelinit72
dw levelinit73
dw levelinit74
dw levelinit75
dw levelinit76
dw levelinit77
dw levelinit78
dw levelinit79
dw levelinit7A
dw levelinit7B
dw levelinit7C
dw levelinit7D
dw levelinit7E
dw levelinit7F
dw levelinit80
dw levelinit81
dw levelinit82
dw levelinit83
dw levelinit84
dw levelinit85
dw levelinit86
dw levelinit87
dw levelinit88
dw levelinit89
dw levelinit8A
dw levelinit8B
dw levelinit8C
dw levelinit8D
dw levelinit8E
dw levelinit8F
dw levelinit90
dw levelinit91
dw levelinit92
dw levelinit93
dw levelinit94
dw levelinit95
dw levelinit96
dw levelinit97
dw levelinit98
dw levelinit99
dw levelinit9A
dw levelinit9B
dw levelinit9C
dw levelinit9D
dw levelinit9E
dw levelinit9F
dw levelinitA0
dw levelinitA1
dw levelinitA2
dw levelinitA3
dw levelinitA4
dw levelinitA5
dw levelinitA6
dw levelinitA7
dw levelinitA8
dw levelinitA9
dw levelinitAA
dw levelinitAB
dw levelinitAC
dw levelinitAD
dw levelinitAE
dw levelinitAF
dw levelinitB0
dw levelinitB1
dw levelinitB2
dw levelinitB3
dw levelinitB4
dw levelinitB5
dw levelinitB6
dw levelinitB7
dw levelinitB8
dw levelinitB9
dw levelinitBA
dw levelinitBB
dw levelinitBC
dw levelinitBD
dw levelinitBE
dw levelinitBF
dw levelinitC0
dw levelinitC1
dw levelinitC2
dw levelinitC3
dw levelinitC4
dw levelinitC5
dw levelinitC6
dw levelinitC7
dw levelinitC8
dw levelinitC9
dw levelinitCA
dw levelinitCB
dw levelinitCC
dw levelinitCD
dw levelinitCE
dw levelinitCF
dw levelinitD0
dw levelinitD1
dw levelinitD2
dw levelinitD3
dw levelinitD4
dw levelinitD5
dw levelinitD6
dw levelinitD7
dw levelinitD8
dw levelinitD9
dw levelinitDA
dw levelinitDB
dw levelinitDC
dw levelinitDD
dw levelinitDE
dw levelinitDF
dw levelinitE0
dw levelinitE1
dw levelinitE2
dw levelinitE3
dw levelinitE4
dw levelinitE5
dw levelinitE6
dw levelinitE7
dw levelinitE8
dw levelinitE9
dw levelinitEA
dw levelinitEB
dw levelinitEC
dw levelinitED
dw levelinitEE
dw levelinitEF
dw levelinitF0
dw levelinitF1
dw levelinitF2
dw levelinitF3
dw levelinitF4
dw levelinitF5
dw levelinitF6
dw levelinitF7
dw levelinitF8
dw levelinitF9
dw levelinitFA
dw levelinitFB
dw levelinitFC
dw levelinitFD
dw levelinitFE
dw levelinitFF
dw levelinit100
dw levelinit101
dw levelinit102
dw levelinit103
dw levelinit104
dw levelinit105
dw levelinit106
dw levelinit107
dw levelinit108
dw levelinit109
dw levelinit10A
dw levelinit10B
dw levelinit10C
dw levelinit10D
dw levelinit10E
dw levelinit10F
dw levelinit110
dw levelinit111
dw levelinit112
dw levelinit113
dw levelinit114
dw levelinit115
dw levelinit116
dw levelinit117
dw levelinit118
dw levelinit119
dw levelinit11A
dw levelinit11B
dw levelinit11C
dw levelinit11D
dw levelinit11E
dw levelinit11F
dw levelinit120
dw levelinit121
dw levelinit122
dw levelinit123
dw levelinit124
dw levelinit125
dw levelinit126
dw levelinit127
dw levelinit128
dw levelinit129
dw levelinit12A
dw levelinit12B
dw levelinit12C
dw levelinit12D
dw levelinit12E
dw levelinit12F
dw levelinit130
dw levelinit131
dw levelinit132
dw levelinit133
dw levelinit134
dw levelinit135
dw levelinit136
dw levelinit137
dw levelinit138
dw levelinit139
dw levelinit13A
dw levelinit13B
dw levelinit13C
dw levelinit13D
dw levelinit13E
dw levelinit13F
dw levelinit140
dw levelinit141
dw levelinit142
dw levelinit143
dw levelinit144
dw levelinit145
dw levelinit146
dw levelinit147
dw levelinit148
dw levelinit149
dw levelinit14A
dw levelinit14B
dw levelinit14C
dw levelinit14D
dw levelinit14E
dw levelinit14F
dw levelinit150
dw levelinit151
dw levelinit152
dw levelinit153
dw levelinit154
dw levelinit155
dw levelinit156
dw levelinit157
dw levelinit158
dw levelinit159
dw levelinit15A
dw levelinit15B
dw levelinit15C
dw levelinit15D
dw levelinit15E
dw levelinit15F
dw levelinit160
dw levelinit161
dw levelinit162
dw levelinit163
dw levelinit164
dw levelinit165
dw levelinit166
dw levelinit167
dw levelinit168
dw levelinit169
dw levelinit16A
dw levelinit16B
dw levelinit16C
dw levelinit16D
dw levelinit16E
dw levelinit16F
dw levelinit170
dw levelinit171
dw levelinit172
dw levelinit173
dw levelinit174
dw levelinit175
dw levelinit176
dw levelinit177
dw levelinit178
dw levelinit179
dw levelinit17A
dw levelinit17B
dw levelinit17C
dw levelinit17D
dw levelinit17E
dw levelinit17F
dw levelinit180
dw levelinit181
dw levelinit182
dw levelinit183
dw levelinit184
dw levelinit185
dw levelinit186
dw levelinit187
dw levelinit188
dw levelinit189
dw levelinit18A
dw levelinit18B
dw levelinit18C
dw levelinit18D
dw levelinit18E
dw levelinit18F
dw levelinit190
dw levelinit191
dw levelinit192
dw levelinit193
dw levelinit194
dw levelinit195
dw levelinit196
dw levelinit197
dw levelinit198
dw levelinit199
dw levelinit19A
dw levelinit19B
dw levelinit19C
dw levelinit19D
dw levelinit19E
dw levelinit19F
dw levelinit1A0
dw levelinit1A1
dw levelinit1A2
dw levelinit1A3
dw levelinit1A4
dw levelinit1A5
dw levelinit1A6
dw levelinit1A7
dw levelinit1A8
dw levelinit1A9
dw levelinit1AA
dw levelinit1AB
dw levelinit1AC
dw levelinit1AD
dw levelinit1AE
dw levelinit1AF
dw levelinit1B0
dw levelinit1B1
dw levelinit1B2
dw levelinit1B3
dw levelinit1B4
dw levelinit1B5
dw levelinit1B6
dw levelinit1B7
dw levelinit1B8
dw levelinit1B9
dw levelinit1BA
dw levelinit1BB
dw levelinit1BC
dw levelinit1BD
dw levelinit1BE
dw levelinit1BF
dw levelinit1C0
dw levelinit1C1
dw levelinit1C2
dw levelinit1C3
dw levelinit1C4
dw levelinit1C5
dw levelinit1C6
dw levelinit1C7
dw levelinit1C8
dw levelinit1C9
dw levelinit1CA
dw levelinit1CB
dw levelinit1CC
dw levelinit1CD
dw levelinit1CE
dw levelinit1CF
dw levelinit1D0
dw levelinit1D1
dw levelinit1D2
dw levelinit1D3
dw levelinit1D4
dw levelinit1D5
dw levelinit1D6
dw levelinit1D7
dw levelinit1D8
dw levelinit1D9
dw levelinit1DA
dw levelinit1DB
dw levelinit1DC
dw levelinit1DD
dw levelinit1DE
dw levelinit1DF
dw levelinit1E0
dw levelinit1E1
dw levelinit1E2
dw levelinit1E3
dw levelinit1E4
dw levelinit1E5
dw levelinit1E6
dw levelinit1E7
dw levelinit1E8
dw levelinit1E9
dw levelinit1EA
dw levelinit1EB
dw levelinit1EC
dw levelinit1ED
dw levelinit1EE
dw levelinit1EF
dw levelinit1F0
dw levelinit1F1
dw levelinit1F2
dw levelinit1F3
dw levelinit1F4
dw levelinit1F5
dw levelinit1F6
dw levelinit1F7
dw levelinit1F8
dw levelinit1F9
dw levelinit1FA
dw levelinit1FB
dw levelinit1FC
dw levelinit1FD
dw levelinit1FE
dw levelinit1FF
