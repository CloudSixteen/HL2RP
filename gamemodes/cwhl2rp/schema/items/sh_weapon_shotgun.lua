--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "ItemShotgun";
ITEM.cost = 300;
ITEM.model = "models/weapons/w_shotgun.mdl";
ITEM.weight = 4;
ITEM.classes = {CLASS_EOW};
ITEM.uniqueID = "weapon_shotgun";
ITEM.business = true;
ITEM.description = "ItemShotgunDesc";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-4, 4, 4);

ITEM:Register();