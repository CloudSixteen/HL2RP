--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	local index = self:GetDTInt(0);
	
	if (index != 0) then
		local itemTable = Clockwork.item:FindByID(index);
		
		if (itemTable) then
			y = Clockwork.kernel:DrawInfo(itemTable.name, x, y, itemTable.color or colorTargetID, alpha);
			
			if (itemTable("weightText")) then
				y = Clockwork.kernel:DrawInfo(itemTable("weightText"), x, y, colorWhite, alpha);
			else
				y = Clockwork.kernel:DrawInfo(itemTable("weight").."kg", x, y, colorWhite, alpha);
			end;
		end;
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;