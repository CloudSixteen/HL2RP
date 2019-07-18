--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_lab/citizenradio.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(25);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to get the entity's item table.
function ENT:GetItemTable()
	return self.cwItemTable;
end;

-- A function to set the entity's item table.
function ENT:SetItemTable(itemTable)
	self.cwItemTable = itemTable;
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);
	
	util.Effect("GlassImpact", effectData, true, true);
	
	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:SetHealth(math.max(self:Health() - damageInfo:GetDamage(), 0));
	
	if (self:Health() <= 0) then
		self:Explode(); self:Remove();
	end;
end;

-- A function to set the frequency.
function ENT:SetFrequency(frequency)
	self:SetNetworkedString("Frequency", frequency);
end;

-- A function to set whether the entity is off.
function ENT:SetOff(off)
	self:SetDTBool(0, off);
end;

-- A function to toggle whether the entity is off.
function ENT:Toggle()
	if (self:IsOff()) then
		self:SetOff(false);
	else
		self:SetOff(true);
	end;
end;