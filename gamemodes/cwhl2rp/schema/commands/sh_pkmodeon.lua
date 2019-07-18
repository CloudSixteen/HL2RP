--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PKModeOn");

COMMAND.tip = "Turn PK mode on for the given amount of minutes.";
COMMAND.text = "<number Minutes>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local minutes = tonumber(arguments[1]);
	
	if (minutes and minutes > 0) then
		Clockwork.kernel:SetSharedVar("PermaKillMode", 1);
		Clockwork.kernel:CreateTimer("PermaKillMode", minutes * 60, 1, function()
			Clockwork.kernel:SetSharedVar("PermaKillMode", 0);
			
			Clockwork.player:NotifyAll({"PermaKillModeDisabled"});
		end);
		
		Clockwork.player:NotifyAll({"PermaKillModeEnabled", player:Name(), minutes});
	else
		Clockwork.player:Notify(player, {"InvalidAmountOfMinutes"});
	end;
end;

COMMAND:Register();