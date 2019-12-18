--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemHealthVial";
ITEM.uniqueID = "health_vial";
ITEM.cost = 15;
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.useText = "Drink";
ITEM.factions = {FACTION_MPF, FACTION_OTA};
ITEM.category = "Medical"
ITEM.business = true;
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "ItemHealthVialDesc";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + Schema:GetHealAmount(player, 1.5), 0, player:GetMaxHealth()));
	
	Clockwork.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			Clockwork.player:RunClockworkCommand(player, "CharHeal", "health_vial");
		end;
	end;
end;

ITEM:Register();