--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "ItemSuitcase";
ITEM.cost = 12;
ITEM.model = "models/weapons/w_suitcase_passenger.mdl";
ITEM.weight = 2;
ITEM.access = "1";
ITEM.business = true;
ITEM.category = "Reusables";
ITEM.uniqueID = "cw_suitcase";
--ITEM.isFakeWeapon = true;
ITEM.isMeleeWeapon = true;
ITEM.description = "ItemSuitcaseDesc";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_R_Hand";
ITEM.attachmentOffsetAngles = Angle(0, 90, -10);

ITEM.attachmentOffsetVector = Vector(0, 0, 4);

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	return (Clockwork.player:GetWeaponClass(player) == self("weaponClass"));
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();