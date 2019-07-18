--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemSteroids";
ITEM.uniqueID = "steroids";
ITEM.cost = 12;
ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
ITEM.weight = 0.2;
ITEM.access = "w";
ITEM.useText = "Swallow";
ITEM.category = "Medical";
ITEM.business = true;
ITEM.description = "ItemSteroidsDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:BoostAttribute(self.name, ATB_STRENGTH, 3, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();