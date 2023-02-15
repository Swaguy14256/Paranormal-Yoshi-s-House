org $009322
	%clean("JML gamemode_main")

%origin(!gamemode_freespace)
	gamemode_main:
		LDA $0100+!Base2
		CMP #$2A		
		BCS new_mode	
		PHK
		PEA.w return-1
		BRA do_game_mode
				
	new_mode:  
		LDA #$00
		PHA  
		PEA $9311	; Point correctly to return
				
	do_game_mode: 
		LDA gamemode_init_table,x
		PHB			
		PHK			
		PLB
		LDA #$00
		XBA
		LDA $0100+!Base2
		CMP !previous_mode
		STA !previous_mode
		REP #$30
		PHP
		ASL
		TAX
		PLP
		BNE +
			LDA gamemode_main_table,x
		BRA ++
	+
			LDA gamemode_init_table,x
	++
		STA $00
		SEP #$30
		LDX #$00	
		JSR (!Base1,x)
		PLB
	RTL
		
	return:
		LDA $0100+!Base2				
		ASL			
		TAX			
		LDA $9329,x		
		STA $00			
		LDA $932A,x		
		STA $01			
		STZ $02						
		JML [!Base1]	
			
gamemode_main_table:
	dw gamemode_0
	dw gamemode_1
	dw gamemode_2
	dw gamemode_3
	dw gamemode_4
	dw gamemode_5
	dw gamemode_6
	dw gamemode_7
	dw gamemode_8
	dw gamemode_9
	dw gamemode_A
	dw gamemode_B
	dw gamemode_C
	dw gamemode_D
	dw gamemode_E
	dw gamemode_F
	dw gamemode_10
	dw gamemode_11
	dw gamemode_12
	dw gamemode_13
	dw gamemode_14
	dw gamemode_15
	dw gamemode_16
	dw gamemode_17
	dw gamemode_18
	dw gamemode_19
	dw gamemode_1A
	dw gamemode_1B
	dw gamemode_1C
	dw gamemode_1D
	dw gamemode_1E
	dw gamemode_1F
	dw gamemode_20
	dw gamemode_21
	dw gamemode_22
	dw gamemode_23
	dw gamemode_24
	dw gamemode_25
	dw gamemode_26
	dw gamemode_27
	dw gamemode_28
	dw gamemode_29
	dw gamemode_2A
	dw gamemode_2B
	dw gamemode_2C
	dw gamemode_2D
	dw gamemode_2E
	dw gamemode_2F
	dw gamemode_30
	dw gamemode_31
	dw gamemode_32
	dw gamemode_33
	dw gamemode_34
	dw gamemode_35
	dw gamemode_36
	dw gamemode_37
	dw gamemode_38
	dw gamemode_39
	dw gamemode_3A
	dw gamemode_3B
	dw gamemode_3C
	dw gamemode_3D
	dw gamemode_3E
	dw gamemode_3F
	dw gamemode_40
	dw gamemode_41
	dw gamemode_42
	dw gamemode_43
	dw gamemode_44
	dw gamemode_45
	dw gamemode_46
	dw gamemode_47
	dw gamemode_48
	dw gamemode_49
	dw gamemode_4A
	dw gamemode_4B
	dw gamemode_4C
	dw gamemode_4D
	dw gamemode_4E
	dw gamemode_4F
	dw gamemode_50
	dw gamemode_51
	dw gamemode_52
	dw gamemode_53
	dw gamemode_54
	dw gamemode_55
	dw gamemode_56
	dw gamemode_57
	dw gamemode_58
	dw gamemode_59
	dw gamemode_5A
	dw gamemode_5B
	dw gamemode_5C
	dw gamemode_5D
	dw gamemode_5E
	dw gamemode_5F
	dw gamemode_60
	dw gamemode_61
	dw gamemode_62
	dw gamemode_63
	dw gamemode_64
	dw gamemode_65
	dw gamemode_66
	dw gamemode_67
	dw gamemode_68
	dw gamemode_69
	dw gamemode_6A
	dw gamemode_6B
	dw gamemode_6C
	dw gamemode_6D
	dw gamemode_6E
	dw gamemode_6F
	dw gamemode_70
	dw gamemode_71
	dw gamemode_72
	dw gamemode_73
	dw gamemode_74
	dw gamemode_75
	dw gamemode_76
	dw gamemode_77
	dw gamemode_78
	dw gamemode_79
	dw gamemode_7A
	dw gamemode_7B
	dw gamemode_7C
	dw gamemode_7D
	dw gamemode_7E
	dw gamemode_7F
	dw gamemode_80
	dw gamemode_81
	dw gamemode_82
	dw gamemode_83
	dw gamemode_84
	dw gamemode_85
	dw gamemode_86
	dw gamemode_87
	dw gamemode_88
	dw gamemode_89
	dw gamemode_8A
	dw gamemode_8B
	dw gamemode_8C
	dw gamemode_8D
	dw gamemode_8E
	dw gamemode_8F
	dw gamemode_90
	dw gamemode_91
	dw gamemode_92
	dw gamemode_93
	dw gamemode_94
	dw gamemode_95
	dw gamemode_96
	dw gamemode_97
	dw gamemode_98
	dw gamemode_99
	dw gamemode_9A
	dw gamemode_9B
	dw gamemode_9C
	dw gamemode_9D
	dw gamemode_9E
	dw gamemode_9F
	dw gamemode_A0
	dw gamemode_A1
	dw gamemode_A2
	dw gamemode_A3
	dw gamemode_A4
	dw gamemode_A5
	dw gamemode_A6
	dw gamemode_A7
	dw gamemode_A8
	dw gamemode_A9
	dw gamemode_AA
	dw gamemode_AB
	dw gamemode_AC
	dw gamemode_AD
	dw gamemode_AE
	dw gamemode_AF
	dw gamemode_B0
	dw gamemode_B1
	dw gamemode_B2
	dw gamemode_B3
	dw gamemode_B4
	dw gamemode_B5
	dw gamemode_B6
	dw gamemode_B7
	dw gamemode_B8
	dw gamemode_B9
	dw gamemode_BA
	dw gamemode_BB
	dw gamemode_BC
	dw gamemode_BD
	dw gamemode_BE
	dw gamemode_BF
	dw gamemode_C0
	dw gamemode_C1
	dw gamemode_C2
	dw gamemode_C3
	dw gamemode_C4
	dw gamemode_C5
	dw gamemode_C6
	dw gamemode_C7
	dw gamemode_C8
	dw gamemode_C9
	dw gamemode_CA
	dw gamemode_CB
	dw gamemode_CC
	dw gamemode_CD
	dw gamemode_CE
	dw gamemode_CF
	dw gamemode_D0
	dw gamemode_D1
	dw gamemode_D2
	dw gamemode_D3
	dw gamemode_D4
	dw gamemode_D5
	dw gamemode_D6
	dw gamemode_D7
	dw gamemode_D8
	dw gamemode_D9
	dw gamemode_DA
	dw gamemode_DB
	dw gamemode_DC
	dw gamemode_DD
	dw gamemode_DE
	dw gamemode_DF
	dw gamemode_E0
	dw gamemode_E1
	dw gamemode_E2
	dw gamemode_E3
	dw gamemode_E4
	dw gamemode_E5
	dw gamemode_E6
	dw gamemode_E7
	dw gamemode_E8
	dw gamemode_E9
	dw gamemode_EA
	dw gamemode_EB
	dw gamemode_EC
	dw gamemode_ED
	dw gamemode_EE
	dw gamemode_EF
	dw gamemode_F0
	dw gamemode_F1
	dw gamemode_F2
	dw gamemode_F3
	dw gamemode_F4
	dw gamemode_F5
	dw gamemode_F6
	dw gamemode_F7
	dw gamemode_F8
	dw gamemode_F9
	dw gamemode_FA
	dw gamemode_FB
	dw gamemode_FC
	dw gamemode_FD
	dw gamemode_FE
	dw gamemode_FF

gamemode_init_table:
	dw gamemode_init_0
	dw gamemode_init_1
	dw gamemode_init_2
	dw gamemode_init_3
	dw gamemode_init_4
	dw gamemode_init_5
	dw gamemode_init_6
	dw gamemode_init_7
	dw gamemode_init_8
	dw gamemode_init_9
	dw gamemode_init_A
	dw gamemode_init_B
	dw gamemode_init_C
	dw gamemode_init_D
	dw gamemode_init_E
	dw gamemode_init_F
	dw gamemode_init_10
	dw gamemode_init_11
	dw gamemode_init_12
	dw gamemode_init_13
	dw gamemode_init_14
	dw gamemode_init_15
	dw gamemode_init_16
	dw gamemode_init_17
	dw gamemode_init_18
	dw gamemode_init_19
	dw gamemode_init_1A
	dw gamemode_init_1B
	dw gamemode_init_1C
	dw gamemode_init_1D
	dw gamemode_init_1E
	dw gamemode_init_1F
	dw gamemode_init_20
	dw gamemode_init_21
	dw gamemode_init_22
	dw gamemode_init_23
	dw gamemode_init_24
	dw gamemode_init_25
	dw gamemode_init_26
	dw gamemode_init_27
	dw gamemode_init_28
	dw gamemode_init_29
	dw gamemode_init_2A
	dw gamemode_init_2B
	dw gamemode_init_2C
	dw gamemode_init_2D
	dw gamemode_init_2E
	dw gamemode_init_2F
	dw gamemode_init_30
	dw gamemode_init_31
	dw gamemode_init_32
	dw gamemode_init_33
	dw gamemode_init_34
	dw gamemode_init_35
	dw gamemode_init_36
	dw gamemode_init_37
	dw gamemode_init_38
	dw gamemode_init_39
	dw gamemode_init_3A
	dw gamemode_init_3B
	dw gamemode_init_3C
	dw gamemode_init_3D
	dw gamemode_init_3E
	dw gamemode_init_3F
	dw gamemode_init_40
	dw gamemode_init_41
	dw gamemode_init_42
	dw gamemode_init_43
	dw gamemode_init_44
	dw gamemode_init_45
	dw gamemode_init_46
	dw gamemode_init_47
	dw gamemode_init_48
	dw gamemode_init_49
	dw gamemode_init_4A
	dw gamemode_init_4B
	dw gamemode_init_4C
	dw gamemode_init_4D
	dw gamemode_init_4E
	dw gamemode_init_4F
	dw gamemode_init_50
	dw gamemode_init_51
	dw gamemode_init_52
	dw gamemode_init_53
	dw gamemode_init_54
	dw gamemode_init_55
	dw gamemode_init_56
	dw gamemode_init_57
	dw gamemode_init_58
	dw gamemode_init_59
	dw gamemode_init_5A
	dw gamemode_init_5B
	dw gamemode_init_5C
	dw gamemode_init_5D
	dw gamemode_init_5E
	dw gamemode_init_5F
	dw gamemode_init_60
	dw gamemode_init_61
	dw gamemode_init_62
	dw gamemode_init_63
	dw gamemode_init_64
	dw gamemode_init_65
	dw gamemode_init_66
	dw gamemode_init_67
	dw gamemode_init_68
	dw gamemode_init_69
	dw gamemode_init_6A
	dw gamemode_init_6B
	dw gamemode_init_6C
	dw gamemode_init_6D
	dw gamemode_init_6E
	dw gamemode_init_6F
	dw gamemode_init_70
	dw gamemode_init_71
	dw gamemode_init_72
	dw gamemode_init_73
	dw gamemode_init_74
	dw gamemode_init_75
	dw gamemode_init_76
	dw gamemode_init_77
	dw gamemode_init_78
	dw gamemode_init_79
	dw gamemode_init_7A
	dw gamemode_init_7B
	dw gamemode_init_7C
	dw gamemode_init_7D
	dw gamemode_init_7E
	dw gamemode_init_7F
	dw gamemode_init_80
	dw gamemode_init_81
	dw gamemode_init_82
	dw gamemode_init_83
	dw gamemode_init_84
	dw gamemode_init_85
	dw gamemode_init_86
	dw gamemode_init_87
	dw gamemode_init_88
	dw gamemode_init_89
	dw gamemode_init_8A
	dw gamemode_init_8B
	dw gamemode_init_8C
	dw gamemode_init_8D
	dw gamemode_init_8E
	dw gamemode_init_8F
	dw gamemode_init_90
	dw gamemode_init_91
	dw gamemode_init_92
	dw gamemode_init_93
	dw gamemode_init_94
	dw gamemode_init_95
	dw gamemode_init_96
	dw gamemode_init_97
	dw gamemode_init_98
	dw gamemode_init_99
	dw gamemode_init_9A
	dw gamemode_init_9B
	dw gamemode_init_9C
	dw gamemode_init_9D
	dw gamemode_init_9E
	dw gamemode_init_9F
	dw gamemode_init_A0
	dw gamemode_init_A1
	dw gamemode_init_A2
	dw gamemode_init_A3
	dw gamemode_init_A4
	dw gamemode_init_A5
	dw gamemode_init_A6
	dw gamemode_init_A7
	dw gamemode_init_A8
	dw gamemode_init_A9
	dw gamemode_init_AA
	dw gamemode_init_AB
	dw gamemode_init_AC
	dw gamemode_init_AD
	dw gamemode_init_AE
	dw gamemode_init_AF
	dw gamemode_init_B0
	dw gamemode_init_B1
	dw gamemode_init_B2
	dw gamemode_init_B3
	dw gamemode_init_B4
	dw gamemode_init_B5
	dw gamemode_init_B6
	dw gamemode_init_B7
	dw gamemode_init_B8
	dw gamemode_init_B9
	dw gamemode_init_BA
	dw gamemode_init_BB
	dw gamemode_init_BC
	dw gamemode_init_BD
	dw gamemode_init_BE
	dw gamemode_init_BF
	dw gamemode_init_C0
	dw gamemode_init_C1
	dw gamemode_init_C2
	dw gamemode_init_C3
	dw gamemode_init_C4
	dw gamemode_init_C5
	dw gamemode_init_C6
	dw gamemode_init_C7
	dw gamemode_init_C8
	dw gamemode_init_C9
	dw gamemode_init_CA
	dw gamemode_init_CB
	dw gamemode_init_CC
	dw gamemode_init_CD
	dw gamemode_init_CE
	dw gamemode_init_CF
	dw gamemode_init_D0
	dw gamemode_init_D1
	dw gamemode_init_D2
	dw gamemode_init_D3
	dw gamemode_init_D4
	dw gamemode_init_D5
	dw gamemode_init_D6
	dw gamemode_init_D7
	dw gamemode_init_D8
	dw gamemode_init_D9
	dw gamemode_init_DA
	dw gamemode_init_DB
	dw gamemode_init_DC
	dw gamemode_init_DD
	dw gamemode_init_DE
	dw gamemode_init_DF
	dw gamemode_init_E0
	dw gamemode_init_E1
	dw gamemode_init_E2
	dw gamemode_init_E3
	dw gamemode_init_E4
	dw gamemode_init_E5
	dw gamemode_init_E6
	dw gamemode_init_E7
	dw gamemode_init_E8
	dw gamemode_init_E9
	dw gamemode_init_EA
	dw gamemode_init_EB
	dw gamemode_init_EC
	dw gamemode_init_ED
	dw gamemode_init_EE
	dw gamemode_init_EF
	dw gamemode_init_F0
	dw gamemode_init_F1
	dw gamemode_init_F2
	dw gamemode_init_F3
	dw gamemode_init_F4
	dw gamemode_init_F5
	dw gamemode_init_F6
	dw gamemode_init_F7
	dw gamemode_init_F8
	dw gamemode_init_F9
	dw gamemode_init_FA
	dw gamemode_init_FB
	dw gamemode_init_FC
	dw gamemode_init_FD
	dw gamemode_init_FE
	dw gamemode_init_FF
