--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Vortigaunt");
	CLASS.color = Color(255, 200, 100, 255);
	CLASS.factions = {FACTION_VORTIGAUNT};
	CLASS.isDefault = true;
	CLASS.wagesName = "Supplies";
	CLASS.description = "An alien race from the planet Xen.";
	CLASS.defaultPhysDesc = "A strange, alien creature with a large eye, surrounded by three smaller eyes.";
CLASS_VORTIGAUNT = CLASS:Register();
