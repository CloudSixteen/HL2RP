--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");

ITEM.name = "ItemCrossbowBolts";
ITEM.cost = 50;
ITEM.model = "models/items/crossbowrounds.mdl";
ITEM.access = "V";
ITEM.weight = 2;
ITEM.uniqueID = "ammo_xbowbolt";
ITEM.business = false;
ITEM.ammoClass = "xbowbolt";
ITEM.ammoAmount = 4;
ITEM.description = "ItemCrossbowBoltsDesc";

ITEM:Register();