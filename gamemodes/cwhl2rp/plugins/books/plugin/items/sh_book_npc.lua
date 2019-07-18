--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = Clockwork.item:New("book_base");

ITEM.name = "Nova Prospekt Codes";
ITEM.model = "models/props_lab/binderredlabel.mdl";
ITEM.uniqueID = "book_npc";
ITEM.description = "A red book with 'The Prison' scribbled on to it.";
ITEM.bookInformation = [[
<font color='red' size='4'>Written by Chris Hawkins.</font>

All the codes in this book are pieced together from stories told to me on my travels.

[Old Nova Prospekt]
	* A3 - Highest security cell block. A flooded maintenance room needs to be taken to access cell block A5. Cells have small windows in their ceiling.
	* A5 - Larger but infrequently patrolled cell block. It is followed by a large room with turrets.
	* A7 - After the showers comes this larger very commonly patrolled cell block, with a torture room.
	* B2 - This block cannot be accessed.
	* B4 - Primary prison control cell block (besides New Nova Prospekt/depot cell blocks).
	* B7 - Extremely small cell block, annexed to block B4.

[New Nova Prospekt]
	* C1 - This block does not contain cells but the laundry facilities and the kitchen. After that comes the cafeteria.
	* C2 - This cell block is linked to the cafeteria and cannot be accessed.
	* C3 - This cell block is linked to the cafeteria and is entirely flattened by Combine mobile walls. After that comes the Depot itself and maintenance areas.
	* D7 - More commonly used control cell block, in which Combine cells are installed.
	* D8 - Cell block filled with turrets, Combine cells are also installed. Some kind of teleport is located here.
]];

ITEM:Register();