--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("SetNPCName");

COMMAND.tip = "Set the name of a non-playable character.";
COMMAND.text = "<string Name> <string Title>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local target = trace.Entity;
	
	if (target and target:IsNPC()) then
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			target:SetNetworkedString("cw_Name", arguments[1]);
			target:SetNetworkedString("cw_Title", arguments[2]);
		else
			Clockwork.player:Notify(player, {"TargetIsTooFarAway"});
		end;
	else
		Clockwork.player:Notify(player, {"MustLookAtValidTarget"});
	end;
end;

COMMAND:Register();