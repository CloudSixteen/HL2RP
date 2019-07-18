--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CharTakeCustomClass");

COMMAND.tip = "Take a character's custom class.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		target:SetCharacterData("CustomClass", nil);
		
		Clockwork.player:NotifyAll({"PlayerTookCustomClass", player:Name(), target:Name()});
	else
		Clockwork.player:Notify(player, {"NotValidCharacter", arguments[1]});
	end;
end;

COMMAND:Register();