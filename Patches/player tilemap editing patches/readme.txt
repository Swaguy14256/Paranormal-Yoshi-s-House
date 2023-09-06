;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Mario World: Player Tilemap Editing Patches ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

This set of asm patches allows the user to edit the player tilemaps in Super Mario World without the use of an external tool, such as a hex editor or the unfortunately buggy SMW Player Tilemap Editor.

To use these patches, place the file "tilemaps.bat" and the folder "tilemaps" into your xkas folder, along with a copy of your Super Mario World ROM (renamed "smw.smc"). Simply double-click tilemaps.bat and the patches will be applied.

In all, four patches are applied to the hack:
- playertilemap_small.asm
- playertilemap_super_fire.asm
- playertilemap_cape.asm
- playertilemap_special.asm

The first three of the above patches contain the tilemap data for:
- Small Mario/Luigi
- Super/Fire Mario and Super/Fire Luigi
- Cape Mario/Luigi

The last patch contains tilemap data for several of the special player animations used in the game.

Use tilemapguide.png to help you figure out how Super Mario World's player tiles are ordered and numbered.

Always keep a backup of your hack handy when running any patch, including this one.

