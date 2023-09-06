Message Box choice selection patch by JackTheSpades
http://www.smwcentral.net/?p=profile&id=7869

This patch allows you to have cursor in the message box to select between multiple options.
The message box opens and closes like usual and can be edited in Lunar Magic.
Note: The selection only stores a value to a RAM address, if you actually want the selection
      to do something, you'll have to code that yourself (meaning, ASM knowledge is required)


How to use this patch?

Q: How many cursor/options can I have per message box
A: You can have inbetween 1 and 127 cursor positions per message box. That should
   be more than enough.
	
Q: Now, how to define those positions?
A: You need to know their X and Y position.
   If you look at the image Grid.png, you can see the message box as it is displayed in Lunar Magic
   with a grid put ontop of it. X is the horizontal and Y the vertical, both starting at $0.
   So the 'W' in 'Welcome' would be X/Y = $0/$0, the 'L' in 'Dinosaur Land' would be at $9/$1 and
   the 'B' in 'Bowser' would be $C/$6.
	
Q: What do I do with those X/Y positions?
A: In the patch, search for the line that reads:
   ;#   You'd want to START editing stuff here
	And somewhere after that, create a table and name it however you want. After the label for the table
	add a .start and .end sublabel. They are case sensitive!
	In between the .start and .end simply call the macro %xy() and pass it the X/Y position as arguments.
	Going with the examples of before:
	
	exampletable:
		.start
			%xy($0,$0)
			%xy($9,$1)
			%xy($C,$6)
		.end

	The cursor is controlled by pressing up/down on the controller and it will go through the positions in
	the same order as you put them in the table.
	
Q: What else do I need to do?
A: The position table alone is not enough, you need to go to the label MessageBoxData and actually add
   the message box there. This time, the order doesn't matter.
	
Q: How do I add it?
A: You use the %messages() macro. It takes a couple of arguments so let's go over them real quick.
   The first argument is the positions tablename you came up with earlier ("exampletable" in our case).
	-Next is the Lunar Magic level number (not the $13BF level number), for example $0105.
	
	-After that is either $1 or $2 to indicate which message box of <level> you want to use.
	
	-Now you need to specifie a RAM address you want to use for the cursor. The RAM address has to be specified
	using 6 hex digits (as a long address), for example: $7E0019 (the power up state).
	
	-Next is the left-right jump length. Sound confusing but what it means is simple. Usually, you switch between
	options with the up/down controlls, which will go through the positions table one step at a time. This value
	defines how far the curor jumps forward if you press left or backwards if you press right.
	For example, if you have a message box that looks like this:
	
	|-----------------|
	| Your favourite  |
	| number?         |
	|                 |
	|   > 1      4    |
	|     2      5    |
	|     3      6    |
	|-----------------|
	
	You'd want to set it to $3, so that by pressing left it jumps from 1 to 4, from 2 to 5 and from 3 to 6.
	(This is under the assumption they were placed in that order in the positions table.)
	
	-Last but not least, a label to the routine that will be called when the message box is closed. The routine
	has to end with an RTL. If you don't want anything to happen when the box closes, just pass "ReturnLong".
	
	All in all, it could look like this:
	Note that the .end sublabel has to be after the last %messages call.
	
	MessageBoxData:
		%messages(exampletable, $0105, $1, $7E0019+!Base1, $00, ReturnLong)
		;use the table defined before, on level 105, message box 1
		;store value to RAM address $19 (+SA1), don't use left/right buttons
		;don't do anything when message box closes.
	.end
	
	
Q: Anything else?
A: A developer tipp. The RAM address you use should be initialized as 0 or something inbetween 1 and the number
   of possible positions. It is important to note, that the positions are not null indexed.
	That is to say, if the first option is selected, it will store 1 to the RAM address, if the 6th option is
	selected, it will store 6. This was done, so that you can check for a non-zero value as indicator that the
	message has been opened once.
	There is also no real limit to messages you can use. There is easily enough space to use this on every message
	box of every level.
	Also, in Lunar Magic, the positions where the cursor will be at, should be left blank in the message box.