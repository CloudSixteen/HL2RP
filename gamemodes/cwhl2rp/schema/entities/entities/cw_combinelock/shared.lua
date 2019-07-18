--[[ 
    © CloudSixteen.com do not share, re-distribute or modify
    without permission of its author (kurozael@gmail.com).

    Clockwork was created by Conna Wiles (also known as kurozael.)
    http://cloudsixteen.com/license/clockwork.html
--]]

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "kurozael";
ENT.PrintName = "Combine Lock";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.UsableInVehicle = true;
ENT.PhysgunDisabled = true;
ENT.noHandsPickup = true;

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:DTVar("Float", 0, "smokeCharge");
	self:DTVar("Float", 1, "flash");
	self:DTVar("Bool", 0, "locked");
end;

-- A function to get whether the entity is locked.
function ENT:IsLocked()
	return self:GetDTBool(0);
end;
