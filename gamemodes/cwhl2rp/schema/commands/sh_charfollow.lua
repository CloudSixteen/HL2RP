--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CharFollow");

COMMAND.tip = "Follow the closest character to you (as a Scanner).";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema.scanners[player]) then
		local scanner = Schema.scanners[player][1];
		
		if (IsValid(scanner)) then
			local closest;
			
			for k, v in ipairs(_player.GetAll()) do
				if (v:HasInitialized() and !Schema.scanners[v]) then
					if (Clockwork.player:CanSeeEntity(player, v, 0.9, true)) then
						local distance = v:GetPos():Distance(scanner:GetPos());
						
						if (!closest or distance < closest[2]) then
							closest = {v, distance};
						end;
					end;
				end;
			end;
			
			if (closest) then
				scanner.followTarget = closest[1];
				
				scanner:Input("SetFollowTarget", closest[1], closest[1], "!activator");
				
				Clockwork.player:Notify(player, {"YouAreFollowing", closest[1]:Name()});
			else
				Clockwork.player:Notify(player, {"NoCharactersNearYou"});
			end;
		end;
	else
		Clockwork.player:Notify(player, {"YouAreNotAScanner"});
	end;
end;

COMMAND:Register();