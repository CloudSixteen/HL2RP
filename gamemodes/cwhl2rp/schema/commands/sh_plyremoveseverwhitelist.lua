--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PlyRemoveSeverWhitelist");

COMMAND.tip = "Remove a player from a server whitelist.";
COMMAND.text = "<string Name> <string ID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	local identity = string.lower(arguments[2]);
	
	if (target) then
		if (target:GetData("ServerWhitelist")) then
			if (!target:GetData("ServerWhitelist")[identity]) then
				Clockwork.player:Notify(player, {"NotOnServerWhitelist"});
				
				return;
			else
				target:GetData("ServerWhitelist")[identity] = nil;
			end;
		end;
		
		Clockwork.player:SaveCharacter(target);
		
		Clockwork.player:NotifyAll({"RemovedFromServerWhitelist", player:Name(), target:Name(), identity});
	else
		Clockwork.player:Notify(player, {"NotValidCharacter", arguments[1]});
	end;
end;

COMMAND:Register();