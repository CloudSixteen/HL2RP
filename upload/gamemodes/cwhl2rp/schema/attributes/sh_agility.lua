--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Agility";
ATTRIBUTE.image = "hl2rp2/attributes/agility";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "agt";
ATTRIBUTE.description = "AgilityDesc";
ATTRIBUTE.isOnCharScreen = true;

ATB_AGILITY = Clockwork.attribute:Register(ATTRIBUTE);