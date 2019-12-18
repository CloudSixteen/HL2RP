--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Metropolice Scanner");
	CLASS.color = Color(50, 100, 150, 255);
	CLASS.factions = {FACTION_SCANNER};
	CLASS.description = "A metropolice scanner, it utilises Combine technology.";
	CLASS.defaultPhysDesc = "Making beeping sounds";
CLASS_MPS = CLASS:Register();
