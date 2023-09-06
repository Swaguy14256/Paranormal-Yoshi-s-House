Separate Luigi Graphics 2.2
Asar Edition

Patch by Smallhacker, credit Smallhacker NOT me.
Update by DiscoMan, ported to Asar by Snowshoe (thanks to Lui37 for various help).

README:
THIS PATCH NEEDS UNUSED RAM: Make sure the patches you are using do not conflict with eachother.

If your ROM hasn't been edited in Lunar Magic before, extract GFX (red mushroom), insert GFX (green mushroom), and save a level.

Insert "luigi.asm" like any other patch. Make sure "Mario.bin" and "Luigi.bin" are in the same location as the patch.
Also make sure "Mario.bin" and "Luigi.bin" are the same size as GFX32.bin, which is ~24 KB. You don't want to waste freespace!
You can change the Mario & Luigi files with any tile editor such as YY-CHR, or by downloading a GFX32.bin replacement and renaming it.

MULTIPLE PLAYER GRAPHICS:
If you want to add more than two player graphics, you need to find freespace at the beginning of a bank.
With Asar, you can do this automatically with "freecode align" without quotes.

You can use Luigi as an example on how to use multiple player graphics. Copy and paste this section of code:

Luigi:
	LDA.b #LuigiGfx
	STA $4322
	LDA.b #LuigiGfx>>8
	STA $4323
	LDA.b #LuigiGfx>>16
	STA $4324
	LDA #$01
	RTS

After you pasted it below Luigi, rename accordingly:

Toad:
	LDA.b #ToadGfx		; Change to the label you are using to incbin your graphics, seen below
	STA $4322
	LDA.b #ToadGfx>>8	; Change the label just as before
	STA $4323
	LDA.b #ToadGfx>>16	; Same here again
	STA $4324
	LDA #$02		; Change to 02 if using three characters, 03 if using four characters, and so on
	RTS

Include your graphics like Luigi at the very bottom of the patch:

freecode align			; REQUIRED, you must find a bank with freespace at the beginning
ToadGfx:
	incbin Toad.bin		; You will need another GFX32.bin with the graphics you want to use, and rename that to "Toad.bin", or whatever you want

Near the top of the patch you will see a label named Change, you will need to add your extra characters like so:

Change:
	LDA $0DB3
	CMP #$00
	BEQ Mario

	LDA $0DB3
	CMP #$01
	BEQ Luigi

	LDA $0DB3	;\ Add your extra characters below like this.
	CMP #$02	;| Change this value to the number this character is. Since Toad is the third character, it is 02. Just like before.
	BEQ Toad	;/ Change to the name of the label you renamed earlier. We renamed Luigi to Toad, so we use Toad here.

	RTS		; Always keep a single RTS at the end.

Almost done, but there is one final thing. Look at the very top of the patch, and under "freecode" you will see this:

prot MarioGfx,LuigiGfx

Add the label you used to incbin your graphics to this line. The labels are separated by commas. Here is an example:

prot MarioGfx,LuigiGfx,ToadGfx

How do you use your new graphics? Make a patch or some LevelASM to change RAM value $0DB3 to your character's value:

	LDA #$02	; 02 is the value we used for Toad, so it uses Toad GFX now. 01 for Luigi, 00 for Mario, etc.
	STA $0DB3	; RAM address for which character is in play.
	RTS		; Return