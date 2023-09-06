			Better Powerdown,
			by MarioFanGamer
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

What does this patch do?
----------------------------------------------------------
This one changes the powerdown. In SMW, when ever you got
hit, Mario will always be small similar to the original
SMB. In return there is the reserve power up which will
drop itself if you get hurt. This patch changes this
system. Now, Mario stays big if he has got a secondary
power up (i.e. flower or cape) when he get hurt, become
small if he is just super and dies if small. In addition,
you can use a different reserve power up drop. The item
will now either not dropped at all or only dropped if
Mario is only super similar to NSMB (the former) and SMA2
(the latter).
In addition, I now added pointers to LX5's power up patch.
Keep in mind that you have to edit the pointers if you use
different power up stats (mostly likely through a
different patch).

Must I convert it for SA-1?
----------------------------------------------------------
Nope, you needn't. Look at this code:
if read1($00FFD5) == $23	; Check, if the ROM uses SA-1
	sa1rom
	!SA1Address = #$6000
else
	lorom
	!SA1Address = #$0000
endif
This 'code' checks, if the game uses SA-1 (a special chip
which kills almost every slowdown but also allows some
special effects like character conversion). If yes, then
the patch will use SA-1 addresses instead.

tl;dr The patch uses automatically SA-1 addressing.

Do I must give you credits?
----------------------------------------------------------
I made it in less then two hours so no, you needn't.

Do you have done everything by yourself?
----------------------------------------------------------
Yes, everything is made in my hands.

Why did you make this patch?
----------------------------------------------------------
There is already a powerdown patch (there are, in fact,
many versions made by various people) but I don't really
like the chosen animations for getting hurt.
The most basic version only makes Mario small if he is
only super but that's all. The shrinking animation appears
everytime when Mario get hurt. Alcaro's verions is more
the SMA2 styled i.e. the reserve power up only drops if
Mario becomes small but the animations stay the same.
1524's version makes at least a different animation for
secondary power ups but I don't like that too because it's
always a puff cloud which is okay for the cape but not for
the fire flower.
By the way, I had the idea more then one and a half years
before but I didn't know ASM that much that time. :P

I've got a question!
----------------------------------------------------------
Post it to the forums. In the worst case, you can PM me.

Is that really all?
----------------------------------------------------------
It's recommend to patch romi's Feather Autoscroll Freze
Fix (http://www.smwcentral.net/?p=section&a=details&id=5780)
because the animation for losing the cape is the same one
as getting a cape.
Aside from that, if you add power ups then you need to add
pointers to the hurt routine. Follow the instruction of
"Better Powerdown - More Powerups.txt", how to do this.