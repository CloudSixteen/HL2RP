--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemBandage";
ITEM.uniqueID = "bandage";
ITEM.cost = 8;
ITEM.model = "models/props_wasteland/prison_toiletchunk01f.mdl";
ITEM.weight = 0.5;
ITEM.access = "1v";
ITEM.useText = "Apply";
ITEM.category = "Medical"
ITEM.business = true;
ITEM.description = "ItemBandageDesc";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + Schema:GetHealAmount(player), 0, player:GetMaxHealth()));
	
	Clockwork.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Give") then
			Clockwork.player:RunClockworkCommand(player, "CharHeal", "bandage");
		end;
	end;
end;

ITEM:Register();