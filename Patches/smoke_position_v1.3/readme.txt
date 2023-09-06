*** Smoke Sprite High Bytes ***

This is a patch that adds something that should've been present in SMW already;
high bytes for smoke sprite positions. Now, what exactly does this mean? It
means that you will finally be able to know the exact position of smoke
sprites; they will never appear onscreen anymore when they should be offscreen.

It is possible to check if the location is offscreen before spawning the smoke
sprite; however, such a check will do nothing if the location becomes offscreen
while the smoke sprite is still alive. Therefore, this patch is the only true
solution to smoke sprites appearing onscreen.

This patch will require two sets of 4 consecutive bytes of free RAM, but no
freespace (the entire smoke sprite code is optimized and any freespace generated
is used).

Here is some example code:
		LDY #$03
	.loop	LDA $17C0,y
		BEQ .found
		DEY
		BPL .loop
		RTS
	.found	LDA #$01
		STA $17C0,y
		
		LDA $9A
		STA $17C8,y
		LDA $9B
		STA !high_x,y
		LDA $98
		STA $17C4,y
		LDA $99
		STA !high_y,y
		
		LDA #$1B
		STA $17CC,y
		RTS

In case you are using nmstl v1.1 or newer, set the flag !NewNMSTL to 0 in the asm file. If you are using the new nmstl (v1.1+) and you don't set this flag, the patch still works fine, but it will use the old slot check for reznor, instead of using the flag that tells reznor is in the room.

If you are using sa-1 this flag doesn't matter.

If you reapply the sa-1 patch either reapply this patch or make sure sa-1 is not doing a JML at $01AB88 anymore