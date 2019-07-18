--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("ViewData");

COMMAND.tip = "View data about a given character.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if (player != target) then
				Clockwork.datastream:Start(player, "EditData", { target, target:GetCharacterData("CombineData") });
				
				player.editDataAuthorised = target;
			else
				Clockwork.player:Notify(player, {"CannotViewEditOwnData"});
			end;
		else
			Clockwork.player:Notify(player, {"NotValidCharacter", arguments[1]});
		end;
	else
		Clockwork.player:Notify(player, {"YouAreNotCombine"});
	end;
end;

COMMAND:Register();