--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("Dispatch");
COMMAND.tip = "Dispatch a message to all characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		local faction = player:GetFaction();
		local rankName, rankTable = player:GetFactionRank();

		if (faction == FACTION_SCANNER or faction == FACTION_OTA or faction == FACTION_MPF and (rankName == "DvL" or rankName == "SeC")) then
			local text = table.concat(arguments, " ");
			
			if (text == "") then
				Clockwork.player:Notify(player, {"NotEnoughText"});
				
				return;
			end;
			
			Schema:SayDispatch(player, text);
		else
			Clockwork.player:Notify(player, "You are not ranked high enough to use this command!");
		end;
	else
		Clockwork.player:Notify(player, {"YouAreNotCombine"});
	end;
end;

COMMAND:Register();
