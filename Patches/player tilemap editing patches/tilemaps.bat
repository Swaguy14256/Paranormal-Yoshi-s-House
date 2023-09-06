@echo off
set /A count=0
for %%a in (*.sfc *.smc) do (
	set /A count+=1
	set file=%%a
)
if %count% == 0 (
	echo No ROM found in folder.
	goto cancel
) else if %count% == 1 (
	goto patch
) else (
	set /P file=Multiple ROMs found in folder. Which should it be applied to? 
	goto patch
)

:patch
asar tilemaps/playertilemap_small.asm "%file%"
asar tilemaps/playertilemap_super_fire.asm "%file%"
asar tilemaps/playertilemap_cape.asm "%file%"
asar tilemaps/playertilemap_special.asm "%file%"
:cancel
pause