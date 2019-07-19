--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemVegetableOil";
ITEM.uniqueID = "vegetable_oil";
ITEM.cost = 6;
ITEM.model = "models/props_junk/garbage_plasticbottle002a.mdl";
ITEM.weight = 0.6;
ITEM.access = "v";
ITEM.useText = "Drink";
ITEM.business = false;
ITEM.category = "Consumables";
ITEM.description = "ItemVegetableOilDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:TakeDamage(5, player, player);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();