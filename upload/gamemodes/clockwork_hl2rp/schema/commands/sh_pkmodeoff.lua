--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PKModeOff");

COMMAND.tip = "Turn PK mode off and cancel the timer.";
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.kernel:SetSharedVar("PermaKillMode", 0);
	Clockwork.kernel:DestroyTimer("PermaKillMode");
	
	Clockwork.player:NotifyAll({"PermaKillModeTurnedOff", player:Name()});
end;

COMMAND:Register();