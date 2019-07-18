--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");

ITEM.name = "Flashlight";
ITEM.cost = 15;
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.category = "Reusables";
ITEM.uniqueID = "cw_flashlight";
ITEM.business = true;
ITEM.isFakeWeapon = true;
ITEM.isMeleeWeapon = true;
ITEM.description = "A ceiling light, a button has been wired on to it.";

ITEM:Register();