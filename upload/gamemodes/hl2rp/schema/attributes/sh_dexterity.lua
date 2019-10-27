--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Dexterity";
ATTRIBUTE.image = "hl2rp2/attributes/dexterity";
ATTRIBUTE.maximum = 75;
ATTRIBUTE.uniqueID = "dex";
ATTRIBUTE.description = "DexterityDesc";
ATTRIBUTE.isOnCharScreen = true;

ATB_DEXTERITY = Clockwork.attribute:Register(ATTRIBUTE);