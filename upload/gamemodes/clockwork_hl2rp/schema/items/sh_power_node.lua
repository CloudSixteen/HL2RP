--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.uniqueID = "power_node";
ITEM.name = "ItemPowerNode";
ITEM.model = "models/dav0r/hoverball.mdl";
ITEM.weight = 3;
ITEM.category = "Medical"
ITEM.business = true;
ITEM.cost = 40;
ITEM.factions = {FACTION_MPF, FACTION_OTA};
ITEM.description = "ItemPowerNodeDesc";

function ITEM:OnDrop() end;

ITEM:Register();
