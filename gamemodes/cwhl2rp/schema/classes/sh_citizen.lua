--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Citizen");
	CLASS.color = Color(150, 125, 100, 255);
	CLASS.factions = {FACTION_CITIZEN};
	CLASS.isDefault = true;
	CLASS.wagesName = "Supplies";
	CLASS.description = "A regular human citizen enslaved by the Universal Union.";
	CLASS.defaultPhysDesc = "Wearing dirty clothes.";
CLASS_CITIZEN = CLASS:Register();