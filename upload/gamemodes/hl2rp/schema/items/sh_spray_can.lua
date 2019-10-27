--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemSprayCan";
ITEM.uniqueID = "spray_can";
ITEM.cost = 15;
ITEM.model = "models/sprayca2.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Reusables";
ITEM.business = true;
ITEM.description = "ItemSprayCanDesc";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();