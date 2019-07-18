--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "Item9mmPistol";
ITEM.cost = 100;
ITEM.model = "models/weapons/w_pistol.mdl";
ITEM.weight = 1;
ITEM.access = "V";
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.uniqueID = "weapon_pistol";
ITEM.business = true;
ITEM.description = "Item9mmPistolDesc";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
ITEM.attachmentOffsetAngles = Angle(0, 0, 90);
ITEM.attachmentOffsetVector = Vector(0, 4, -8);

ITEM:Register();