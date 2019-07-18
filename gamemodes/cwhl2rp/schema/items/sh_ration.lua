--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemRation";
ITEM.uniqueID = "ration";
ITEM.model = "models/weapons/w_package.mdl";
ITEM.weight = 2;
ITEM.useText = "Open";
ITEM.description = "ItemRationDesc";

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	if (quickUse) then
		if (!player:CanHoldWeight(self.weight)) then
			Clockwork.player:Notify(player, {"YourInventoryFull"});
			
			return false;
		end;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (Schema:PlayerIsCombine(player)) then
		Clockwork.player:Notify(player, {"YouCannotOpenRation"});
		
		return false;
	elseif (player:GetFaction() == FACTION_ADMIN) then
		Clockwork.player:Notify(player, {"YouCannotOpenRation"});
		
		return false;
	else
		Clockwork.player:GiveCash(player, 60, {"CashRationPacket"});
		
		player:GiveItem(Clockwork.item:CreateInstance("citizen_supplements"), true);
		
		Clockwork.plugin:Call("PlayerUseRation", player);
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();