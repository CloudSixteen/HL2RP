--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");

ITEM.name = "ItemWhiskey";
ITEM.uniqueID = "whiskey";
ITEM.cost = 13;
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.weight = 1.2;
ITEM.access = "w";
ITEM.business = true;
ITEM.attributes = {Stamina = 2};
ITEM.description = "ItemWhiskeyDesc";

ITEM:Register();