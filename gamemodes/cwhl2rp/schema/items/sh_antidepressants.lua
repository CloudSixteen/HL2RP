--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemAntidepressants";
ITEM.uniqueID = "antidepressants";
ITEM.cost = 10;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.2;
ITEM.access = "w";
ITEM.useText = "Swallow";
ITEM.category = "Medical";
ITEM.business = true;
ITEM.description = "ItemAntidepressantsDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetSharedVar("Antidepressants", CurTime() + 600);
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();