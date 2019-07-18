--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemMilkCarton";
ITEM.uniqueID = "milk_carton";
ITEM.cost = 6;
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.useText = "Drink";
ITEM.category = "Consumables";
ITEM.business = true;
ITEM.description = "ItemMilkCartonDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 5, 0, 100));
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 1, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, 1, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();