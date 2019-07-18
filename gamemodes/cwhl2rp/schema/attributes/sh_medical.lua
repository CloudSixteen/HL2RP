--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Medical";
ATTRIBUTE.image = "hl2rp2/attributes/medical";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "med";
ATTRIBUTE.description = "MedicalDesc";
ATTRIBUTE.isOnCharScreen = true;

ATB_MEDICAL = Clockwork.attribute:Register(ATTRIBUTE);