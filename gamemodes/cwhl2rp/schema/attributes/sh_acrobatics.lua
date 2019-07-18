--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Acrobatics";
ATTRIBUTE.image = "hl2rp2/attributes/acrobatics";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "acr";
ATTRIBUTE.description = "AcrobaticsDesc";
ATTRIBUTE.isOnCharScreen = true;

ATB_ACROBATICS = Clockwork.attribute:Register(ATTRIBUTE);