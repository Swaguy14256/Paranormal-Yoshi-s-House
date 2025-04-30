# Paranormal Yoshi's House
An SMW Hack that has been in development since 2016. I only made this repository now in 2022. It contains all the source code used for the hack.

# Compilation Instructions
1. Extract the source code to a folder somewhere on your computer.
2. Use Floating IPS and apply "base.bps" to an unmodified Super Mario World ROM (US Version). The patched ROM must be in the same directory you extracted the source code to.
3. Open the program in Lunar Magic, (Version 3.33 is recommended), click the "Quick Insert GFX and ExGFX to ROM, reload graphics" button to insert the graphics.
4. Open the 16x16 Tile Map Editor and click on the "Import all FG and BG Map16 for all tilesets from file and save to ROM." button. From there select the "AllMap16.map16" file.
5. Go to "File->Graphics" and select "Insert Old Bypass List to ROM...". From there, select the "Bypass.lst" file.
6. Go to "File->Levels" and select "Import Multiple Levels from Files...". Then, make sure "Clear all existing secondary entrances in ROM before importing" is unchecked. From there, select the "Levels" directory.
7. Go into the "Music" folder and run AddmusicK to insert all the music into the ROM.
8. Go into the "Blocks" folder and run GPS to insert all the blocks into the ROM.
9. Go into the "Patches" folder and run "insert.bat" to insert all the patches into the ROM, and in the correct order.
10. Go into the "uberASM" folder and run "insert.bat" to insert all the uberASM into the ROM.
11. Finally, go into the "Sprites" folder and run PIXI to insert all the sprites into the ROM.
