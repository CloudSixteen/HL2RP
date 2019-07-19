--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = Clockwork.item:New();

ITEM.name = "Paper";
ITEM.cost = 2;
ITEM.model = "models/props_c17/paper01.mdl";
ITEM.weight = 0.1;
ITEM.access = "1v";
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.business = true;
ITEM.description = "A scrap piece of paper, it's tattered and dirty.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	
	if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
		local entity = ents.Create("cw_paper");
		
		Clockwork.player:GiveProperty(player, entity);
		
		entity:SetPos(trace.HitPos);
		entity:Spawn();
		
		if (IsValid(itemEntity)) then
			local physicsObject = itemEntity:GetPhysicsObject();
			
			entity:SetPos(itemEntity:GetPos());
			entity:SetAngles(itemEntity:GetAngles());
			
			if (IsValid(physicsObject)) then
				if (!physicsObject:IsMoveable()) then
					physicsObject = entity:GetPhysicsObject();
					
					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;
		else
			Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
		end;
	else
		Clockwork.player:Notify(player, {"CannotDropItemFar"});
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();