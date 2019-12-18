--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Administrator");
	CLASS.color = Color(255, 200, 100, 255);
	CLASS.wages = 50;
	CLASS.factions = {FACTION_ADMIN};
	CLASS.isDefault = true;
	CLASS.wagesName = "Allowance";
	CLASS.description = "A human Administrator advised by the Universal Union.";
	CLASS.defaultPhysDesc = "Wearing a clean brown suit";
CLASS_ADMIN = CLASS:Register();