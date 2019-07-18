--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "kurozael";
ENT.PrintName = "Radio";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "off");
end;

-- A function to get the frequency.
function ENT:GetFrequency()
	return self:GetNetworkedString("Frequency");
end;

-- A function to get whether the entity is off.
function ENT:IsOff()
	return self:GetDTBool(0);
end;