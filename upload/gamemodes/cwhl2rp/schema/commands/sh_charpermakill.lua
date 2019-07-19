--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CharPermaKill");

COMMAND.tip = "Permanently kill a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if (!target:GetCharacterData("PermaKilled")) then
			Schema:PermaKillPlayer(target, target:GetRagdollEntity());
		else
			Clockwork.player:Notify(player, {"PlayerAlreadyPermaKilled"});
			
			return;
		end;
		
		Clockwork.player:NotifyAll({"PlayerPermaKilledOther", player:Name(), target:Name()});
	else
		Clockwork.player:Notify(player, {"NotValidCharacter", arguments[1]});
	end;
end;

COMMAND:Register();