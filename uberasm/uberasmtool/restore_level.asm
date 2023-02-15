!LEVELNUMBER = $28

main:
LDA #!LEVELNUMBER	;\
STA $13BF		;/ Resets the level to the translevel number configured.
RTL			; Ends the code.