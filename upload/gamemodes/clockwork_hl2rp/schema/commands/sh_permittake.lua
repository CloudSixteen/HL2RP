--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PermitTake");

COMMAND.tip = "Take a character's permit(s) away.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		local rankName, rankTable = player:GetFactionRank();

		if (rankName != "RCT") then
			local target = player:GetEyeTraceNoCursor().Entity;
			
			if (target and target:IsPlayer()) then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					if (target:GetFaction() == FACTION_CITIZEN) then
						for k, v in pairs(Schema.customPermits) do
							Clockwork.player:TakeFlags(target, v);
						end;
						
						Clockwork.player:Notify(player, "You have taken this character's permit(s)!");
					else
						Clockwork.player:Notify(player, "This character is not a citizen!");
					end;
				else
					Clockwork.player:Notify(player, {"TargetIsTooFarAway"});
				end;
			else
				Clockwork.player:Notify(player, {"MustLookAtValidTarget"});
			end;
		else
			Clockwork.player:Notify(player, "You are not ranked high enough for this!");
		end;
	else
		Clockwork.player:Notify(player, {"YouAreNotCombine"});
	end;
end;

COMMAND:Register();
