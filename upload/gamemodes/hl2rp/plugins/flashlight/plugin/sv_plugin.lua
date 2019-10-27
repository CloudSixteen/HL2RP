--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

Clockwork.hint:AddHumanHint("Flashlight", "HintFlashlight");

-- A function to get whether a player has a flashlight.
function PLUGIN:PlayerHasFlashlight(player)
	if (Schema:PlayerIsCombine(player)) then
		return true;
	end;
	
	local weapon = player:GetActiveWeapon();
	
	if (IsValid(weapon)) then
		local itemTable = Clockwork.item:GetByWeapon(weapon);
		
		if (weapon:GetClass() == "cw_flashlight" or (itemTable and itemTable("hasFlashlight"))) then
			return true;
		end;
	end;
end;