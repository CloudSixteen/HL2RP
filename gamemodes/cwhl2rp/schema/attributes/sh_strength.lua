--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Strength";
ATTRIBUTE.image = "hl2rp2/attributes/strength";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "str";
ATTRIBUTE.description = "StrengthDesc";
ATTRIBUTE.isOnCharScreen = true;

ATB_STRENGTH = Clockwork.attribute:Register(ATTRIBUTE);