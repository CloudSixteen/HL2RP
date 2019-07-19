--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CharSetCustomClass");

COMMAND.tip = "Set a character's custom class.";
COMMAND.text = "<string Name> <string Class>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		target:SetCharacterData("CustomClass", arguments[2]);
		
		Clockwork.player:NotifyAll({"PlayerSetCustomClass", player:Name(), target:Name(), arguments[2]});
	else
		Clockwork.player:Notify(player, {"NotValidCharacter", arguments[1]});
	end;
end;

COMMAND:Register();