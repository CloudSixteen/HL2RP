--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemRequestDevice";
ITEM.uniqueID = "request_device";
ITEM.cost = 15;
ITEM.model = "models/gibs/shield_scanner_gib1.mdl";
ITEM.weight = 0.8;
ITEM.access = "1";
ITEM.category = "Communication";
ITEM.factions = {FACTION_MPF};
ITEM.business = true;
ITEM.description = "ItemRequestDeviceDesc";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();