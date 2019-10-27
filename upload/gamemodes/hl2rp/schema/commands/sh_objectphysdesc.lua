--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("ObjectPhysDesc");

COMMAND.tip = "Set the physical description of an object.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		if (target:GetPos():Distance(player:GetShootPos()) <= 192) then
			if (Clockwork.entity:IsPhysicsEntity(target)) then
				if (player:QueryCharacter("key") == target:GetOwnerKey()) then
					player.objectPhysDesc = target;
					
					Clockwork.datastream:Start(player, "ObjectPhysDesc", target);
				else
					Clockwork.player:Notify(player, {"YouDoNotOwnThis"});
				end;
			else
				Clockwork.player:Notify(player, {"EntityIsNotPhysics"});
			end;
		else
			Clockwork.player:Notify(player, {"TargetIsTooFarAway"});
		end;
	else
		Clockwork.player:Notify(player, {"MustLookAtValidTarget"});
	end;
end;

COMMAND:Register();