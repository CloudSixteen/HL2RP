--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("clothes_base");

ITEM.name = "ItemResistanceUniform";
ITEM.uniqueID = "resistance_uniform";
ITEM.group = "group03";
ITEM.weight = 3;
ITEM.access = "m";
ITEM.business = true;
ITEM.protection = 0.1;
ITEM.description = "ItemResistanceUniformDesc";

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	if (string.lower(player:GetModel()) == "models/humans/group01/jasona.mdl") then
		return "models/humans/group03/male_02.mdl";
	end;
end;

ITEM:Register();