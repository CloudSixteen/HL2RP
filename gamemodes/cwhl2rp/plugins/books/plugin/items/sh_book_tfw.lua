--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = Clockwork.item:New("book_base");

ITEM.cost = 3;
ITEM.name = "The F. Word";
ITEM.model = "models/props_lab/bindergraylabel01b.mdl";
ITEM.uniqueID = "book_tfw";
ITEM.business = true;
ITEM.description = "A book about fuck all.";
ITEM.bookInformation = [[
<font color='red' size='4'>Written by M. Stanley Bubien.</font>

<font size = '+2'>M</font>ommy!' my son cried out as he ran into the room, 'Cherish just said
the f-word!' I set my book down, took his hand and asked, 'What is the f-word?'

He looked around the room. 'It's okay to tell me, honey.'
Meeting my gaze, he shrugged, 'It's 'stupid.'

I squeezed his hand and called to his sister's bedroom, 'Cherish,
come in here. Right now.'
]];

ITEM:Register();