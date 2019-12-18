--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");

ITEM.name = "Item9mmPistolBullets";
ITEM.cost = 20;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.model = "models/items/boxsrounds.mdl";
ITEM.weight = 1;
ITEM.access = "V";
ITEM.uniqueID = "ammo_pistol";
ITEM.business = true;
ITEM.ammoClass = "pistol";
ITEM.ammoAmount = 20;
ITEM.description = "Item9mmPistolBulletsDesc";

ITEM:Register();