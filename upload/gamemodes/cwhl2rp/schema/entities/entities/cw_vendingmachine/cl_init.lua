--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
	
	local r, g, b, a = self:GetColor();
	local flashTime = self:GetDTFloat(0);
	local glowColor = Color(0, 255, 0, a);
	local position = self:GetPos();
	local forward = self:GetForward() * 18;
	local curTime = CurTime();
	local right = self:GetRight() * -24;
	local up = self:GetUp() * 6;
	
	if (self:GetStock() == 0) then
		glowColor = Color(255, 150, 0, a);
	end;
	
	if (flashTime and flashTime >= curTime) then
		if (self:GetDTBool(0)) then
			glowColor = Color(0, 0, 255, a);
		else
			glowColor = Color(255, 0, 0, a);
		end;
	end;
	
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
	cam.End3D();
end;