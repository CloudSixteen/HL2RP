--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemBreach";
ITEM.uniqueID = "breach";
ITEM.cost = 10;
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
ITEM.plural = "Breaches";
ITEM.weight = 0.5;
ITEM.access = "V";
ITEM.useText = "Place";
ITEM.business = true;
ITEM.blacklist = {CLASS_MPR};
ITEM.description = "ItemBreachDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance(player:GetShootPos()) <= 192) then
			if (!IsValid(entity.breach)) then
				if (Clockwork.plugin:Call("PlayerCanBreachEntity", player, entity)) then
					local breach = ents.Create("cw_breach"); breach:Spawn();
					
					breach:SetBreachEntity(entity, trace);
				else
					Clockwork.player:Notify(player, {"CannotBeBreached"});
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, {"AlreadyHasBreach"});
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, {"TargetIsTooFarAway"});
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, {"MustLookAtValidTarget"});
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();