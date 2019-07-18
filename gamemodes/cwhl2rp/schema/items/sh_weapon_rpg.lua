--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "ItemRPG";
ITEM.cost = 800;
ITEM.model = "models/weapons/w_rocket_launcher.mdl";
ITEM.weight = 6;
ITEM.access = "V";
ITEM.uniqueID = "weapon_rpg";
ITEM.business = false;
ITEM.description = "ItemRPGDesc";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);

ITEM:Register();