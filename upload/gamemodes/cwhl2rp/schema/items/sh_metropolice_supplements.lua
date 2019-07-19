--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemMetropoliceSupplements";
ITEM.uniqueID = "metropolice_supplements";
ITEM.cost = 10;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.6;
ITEM.useText = "Eat";
ITEM.factions = {FACTION_MPF};
ITEM.category = "Consumables";
ITEM.business = true;
ITEM.description = "ItemMetropoliceSupplementsDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 5, 0, player:GetMaxHealth()));
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();