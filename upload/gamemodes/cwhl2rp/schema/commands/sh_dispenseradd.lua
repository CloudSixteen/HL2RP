--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("DispenserAdd");

COMMAND.tip = "Add a ration dispenser at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_rationdispenser");
	
	entity:SetPos(trace.HitPos);
	entity:Spawn();
	
	if (IsValid(entity)) then
		entity:SetAngles(Angle(0, player:EyeAngles().yaw + 180, 0));
		
		Clockwork.player:Notify(player, {"YouAddedRationDispenser"});
	end;
end;

COMMAND:Register();