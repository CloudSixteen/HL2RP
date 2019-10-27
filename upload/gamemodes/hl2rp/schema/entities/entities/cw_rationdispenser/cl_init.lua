--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.
function ENT:Draw()
	local r, g, b, a = self:GetColor();
	local rationTime = self:GetDTFloat(0);
	local flashTime = self:GetDTFloat(1);
	local position = self:GetPos();
	local forward = self:GetForward() * 8;
	local curTime = CurTime();
	local right = self:GetRight() * 5;
	local up = self:GetUp() * 13;
	
	if (rationTime > curTime) then
		local glowColor = Color(0, 0, 255, a);
		local timeLeft = rationTime - curTime;
		
		if (!self.nextFlash or curTime >= self.nextFlash or (self.flashUntil and self.flashUntil > curTime)) then
			cam.Start3D(EyePos(), EyeAngles());
				render.SetMaterial(glowMaterial);
				render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
			cam.End3D();
			
			if (!self.flashUntil or curTime >= self.flashUntil) then
				self.nextFlash = curTime + (timeLeft / 4);
				self.flashUntil = curTime + (FrameTime() * 4);
				self:EmitSound("hl1/fvox/boop.wav");
			end;
		end;
	else
		local glowColor = Color(0, 255, 0, a);
		
		if (self:IsLocked()) then
			glowColor = Color(255, 150, 0, a);
		end;
		
		if (flashTime and flashTime >= curTime) then
			glowColor = Color(255, 0, 0, a);
		end;
		
		cam.Start3D(EyePos(), EyeAngles());
			render.SetMaterial(glowMaterial);
			render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
		cam.End3D();
	end;
end;