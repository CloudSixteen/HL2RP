--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "ItemCrossbow";
ITEM.cost = 400;
ITEM.model = "models/weapons/w_crossbow.mdl";
ITEM.weight = 5;
ITEM.access = "V";
ITEM.uniqueID = "weapon_crossbow";
ITEM.business = false;
ITEM.description = "ItemCrossbowDesc";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentOffsetAngles = Angle(270, 0, 0);
ITEM.attachmentOffsetVector = Vector(3, 7, -3);

ITEM:Register();