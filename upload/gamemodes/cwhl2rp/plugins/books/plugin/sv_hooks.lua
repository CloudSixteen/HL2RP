--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "cw_book" and arguments == "cw_bookTake" or arguments == "cw_bookView") then
		if (arguments == "cw_bookView") then
			Clockwork.datastream:Start(player, "ViewBook", entity);
		else
			local success, fault = player:GiveItem(Clockwork.item:CreateInstance(entity.book.uniqueID));
			
			if (!success) then
				Clockwork.player:Notify(player, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadBooks();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveBooks();
end;