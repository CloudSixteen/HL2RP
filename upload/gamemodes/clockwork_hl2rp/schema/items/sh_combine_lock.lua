--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemCombineLock";
ITEM.uniqueID = "combine_lock";
ITEM.cost = 40;
ITEM.model = "models/props_combine/combine_lock01.mdl";
ITEM.weight = 4;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.useText = "Place";
ITEM.business = true;
ITEM.description = "ItemCombineLockDesc";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance(player:GetPos()) <= 192) then
			if (!IsValid(entity.combineLock)) then
				if (!Clockwork.entity:IsDoorFalse(entity)) then
					local angles = trace.HitNormal:Angle() + Angle(0, 270, 0);
					local position;
					
					if (string.lower(entity:GetClass()) == "prop_door_rotating") then
						position = trace;
					else
						position = trace.HitPos + (trace.HitNormal * 4);
					end;
					
					if (!IsValid(Schema:ApplyCombineLock(entity, position, angles))) then
						return false;
					elseif (IsValid(entity.breach)) then
						entity.breach:CreateDummyBreach();
						entity.breach:Explode();
						entity.breach:Remove();
					end;
				else
					Clockwork.player:Notify(player, {"CannotHaveCombineLock"});
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, {"AlreadyHasCombineLock"});
				
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