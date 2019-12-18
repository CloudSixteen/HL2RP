--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Endurance";
ATTRIBUTE.image = "hl2rp2/attributes/endurance";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "end";
ATTRIBUTE.description = "EnduranceDesc";
ATTRIBUTE.isOnCharScreen = true;

ATB_ENDURANCE = Clockwork.attribute:Register(ATTRIBUTE);