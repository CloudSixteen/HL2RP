--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemSmallBag";
ITEM.uniqueID = "small_bag";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 1;
ITEM.category = "Storage";
ITEM.isRareItem = false;
ITEM.description = "ItemSmallBagDesc";
ITEM.addInvSpace = 4;

-- Called when the item's drop entity should be created.
function ITEM:OnCreateDropEntity(player, position)
	return Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("boxed_bag"), position);
end;

-- Called when a player attempts to take the item from storage.
function ITEM:CanTakeStorage(player, storageTable)
	local target = Clockwork.entity:GetPlayer(storageTable.entity);
	
	if (target) then
		local inventoryWeight = Clockwork.inventory:CalculateWeight(
			target:GetInventory()
		);
	
		if (inventoryWeight > (target:GetMaxWeight() - self("addInvSpace"))) then
			return false;
		end;
	end;
	
	if (player:HasItemByID(self.uniqueID) and table.Count(player:GetItemsByID(self.uniqueID)) >= 2) then
		return false;
	end;
end;

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	return "boxed_backpack";
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetInventoryWeight() > (player:GetMaxWeight() - self("addInvSpace"))) then
		Clockwork.player:Notify(player, {"CannotDropWhileCarrying"});
		
		return false;
	end;
end;

ITEM:Register();