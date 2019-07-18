--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("SetFreq");

COMMAND.tip = "Set your radio frequency, or a stationary radio's frequency.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local radio;
	
	if (IsValid(trace.Entity) and trace.Entity:GetClass() == "cw_radio") then
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			radio = trace.Entity;
		else
			Clockwork.player:Notify(player, {"TargetIsTooFarAway"});
			
			return;
		end;
	end;
	
	local frequency = arguments[1];
	
	if (string.find(frequency, "^%d%d%d%.%d$")) then
		local start, finish, decimal = string.match(frequency, "(%d)%d(%d)%.(%d)");
		
		start = tonumber(start);
		finish = tonumber(finish);
		decimal = tonumber(decimal);
		
		if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
			if (radio) then
				trace.Entity:SetFrequency(frequency);
				
				Clockwork.player:Notify(player, {"YouSetRadioFrequencyTo", frequency});
			else
				player:SetCharacterData("Frequency", frequency);
				
				Clockwork.player:Notify(player, {"YouSetYourRadioFrequencyTo", frequency});
			end;
		else
			Clockwork.player:Notify(player, {"RadioArgumentsMustBeBetween"});
		end;
	else
		Clockwork.player:Notify(player, {"RadioArgumentsMustBeLike"});
	end;
end;

COMMAND:Register();