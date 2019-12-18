--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemLargeSoda";
ITEM.uniqueID = "large_soda";
ITEM.cost = 12;
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.weight = 1.5;
ITEM.access = "w";
ITEM.useText = "Drink";
ITEM.category = "Consumables";
ITEM.business = true;
ITEM.description = "ItemLargeSodaDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:SetHealth(math.Clamp(player:Health() + 10, 0, player:GetMaxHealth()));
	
	player:BoostAttribute(self.name, ATB_AGILITY, 5, 120);
	player:BoostAttribute(self.name, ATB_STAMINA, 5, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item's functions should be edited.
function ITEM:OnEditFunctions(functions)
	if (Schema:PlayerIsCombine(Clockwork.Client, false)) then
		for k, v in pairs(functions) do
			if (v == "Drink") then functions[k] = nil; end;
		end;
	end;
end;

ITEM:Register();