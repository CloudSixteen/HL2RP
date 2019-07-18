--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("Request");

COMMAND.tip = "Request assistance from Civil Protection.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local isCityAdmin = (player:GetFaction() == FACTION_ADMIN);
	local isCombine = Schema:PlayerIsCombine(player);
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, {"NotEnoughText"});
		
		return;
	end;
	
	if (player:HasItemByID("request_device") or isCombine or isCityAdmin) then
		local curTime = CurTime();
		
		if (!player.nextRequestTime or isCityAdmin or isCombine or curTime >= player.nextRequestTime) then
			Schema:SayRequest(player, text);
			
			if (!isCityAdmin and !isCombine) then
				player.nextRequestTime = curTime + 30;
			end;
		else
			Clockwork.player:Notify(player, {"CannotSendRequestUntil", math.ceil(player.nextRequestTime - curTime)});
		end;
	else
		Clockwork.player:Notify(player, {"YouDoNotOwnRequestDevice"});
	end;
end;

COMMAND:Register();