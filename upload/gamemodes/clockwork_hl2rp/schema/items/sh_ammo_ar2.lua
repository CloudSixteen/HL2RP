--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");

ITEM.name = "ItemPulseRifleEnergy";
ITEM.cost = 30;
ITEM.classes = {CLASS_EOW};
ITEM.model = "models/items/combine_rifle_cartridge01.mdl";
ITEM.plural = "Pulse-Rifle Energy";
ITEM.weight = 1;
ITEM.uniqueID = "ammo_ar2";
ITEM.business = true;
ITEM.ammoClass = "ar2";
ITEM.ammoAmount = 30;
ITEM.description = "ItemPulseRifleEnergyDesc";

ITEM:Register();