--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("ViewObjectives");

COMMAND.tip = "View the Civil Protection objectives.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		Clockwork.datastream:Start(player, "EditObjectives", Schema.combineObjectives);
		
		player.editObjectivesAuthorised = true;
	else
		Clockwork.player:Notify(player, {"YouAreNotCombine"});
	end;
end;

COMMAND:Register();