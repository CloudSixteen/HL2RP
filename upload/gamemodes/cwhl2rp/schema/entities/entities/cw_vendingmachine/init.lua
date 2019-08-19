--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetStock(0, true);
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to create the entity's water.
function ENT:CreateWater(activator)
	self:GiveStock(-1);
	self:EmitSound("buttons/button4.wav");
	self:SetFlashDuration(3, true);

	local forward = self:GetForward() * 18;
	local chance = math.random(1, 20);
	local right = self:GetRight() * 3;
	local up = self:GetUp() * -24;

	local class
	if (chance == 20) then
		class = "special_breen_s_water"
	elseif (chance >= 10) then
		class = "smooth_breen_s_water"
	else
		class = "breen_s_water"
	end;
	
	Clockwork.entity:CreateItem(activator, Clockwork.item:CreateInstance(class), self:GetPos() + forward + right + up, self:GetAngles());
end;

-- A function to get the entity's default stock.
function ENT:GetDefaultStock()
	return self.defaultStock or 0;
end;

-- A function to give stock to the entity.
function ENT:GiveStock(amount)
	self:SetStock(math.Clamp(self:GetStock() + amount, 0, self:GetDefaultStock()));
end;

-- A function to set the entity's stock.
function ENT:SetStock(amount, default)
	self:SetDTInt(0, amount);
	
	if (default) then
		if (type(default) == "number") then
			self.defaultStock = default;
		else
			self.defaultStock = amount;
		end;
	end;
end;

-- A function to restock the entity.
function ENT:Restock()
	self:SetFlashDuration(3, true);
	self:EmitSound("buttons/button5.wav");
	self:SetStock(self:GetDefaultStock());
end;

-- A function to set the entity's flash duration.
function ENT:SetFlashDuration(duration, action)
	self:SetDTFloat(0, CurTime() + duration);
	
	if (action) then
		self:SetDTBool(0, true);
	else
		self:EmitSound("buttons/button2.wav");
		self:SetDTBool(0, false);
	end;
end;

-- Called when the entity's physics should be updated.
function ENT:PhysicsUpdate(physicsObject)
	if (!self:IsPlayerHolding() and !self:IsConstrained()) then
		physicsObject:SetVelocity(Vector(0, 0, 0));
		physicsObject:Sleep();
	end;
end;

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		local curTime = CurTime();
		
		if (!self.nextUse or curTime >= self.nextUse) then
			if (curTime > self:GetDTFloat(0)) then
				self.nextUse = curTime + 3;
				
				if (!Schema:PlayerIsCombine(activator)) then
					if (self:GetStock() == 0 or !Clockwork.player:CanAfford(activator, 8)) then
						self:SetFlashDuration(3);
					elseif (!activator.nextVendingMachine or curTime >= activator.nextVendingMachine) then
						self:CreateWater(activator);
						
						activator.nextVendingMachine = curTime + 600;
						
						Clockwork.player:GiveCash(activator, -8, {"CashVendingMachine"});
					else
						self:SetFlashDuration(3);
					end;
				elseif (self:GetStock() == 0) then
					self:Restock();
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;
