--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
end;

if (CLIENT) then
	SWEP.Slot = 4;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Smoke";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Primary Fire: Throw.";
SWEP.Purpose = "Disorientating characters with a heavy cloud of smoke.";
SWEP.Contact = "";
SWEP.Author	= "kurozael";

SWEP.WorldModel = "models/weapons/w_grenade.mdl";
SWEP.ViewModel = "models/weapons/v_grenade.mdl";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 0;
SWEP.Primary.Delay = 1;
SWEP.Primary.Ammo = "grenade";

SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

-- Called each frame.
function SWEP:Think()
	local curTime = CurTime();
	
	if (self.PulledBack and !self.Owner:KeyDown(IN_ATTACK)) then
		if (curTime >= self.PulledBack) then
			self.PulledBack = nil;
			self.Attacking = curTime + (self.Primary.Delay / 2);
			self.Raised = curTime + self.Primary.Delay + 2;
			
			if (!self.AttackTime) then
				self.AttackTime = curTime;
			end;
			
			self:CreateGrenade(math.Clamp(curTime - self.AttackTime, 0, 10) * 40);
			self:EmitSound("WeaponFrag.Throw");
			
			self:SendWeaponAnim(ACT_VM_THROW);
			self:SetNextPrimaryFire(curTime + self.Primary.Delay);
			
			self.Owner:SetAnimation(PLAYER_ATTACK1);
		end;
	elseif (type(self.Attacking) == "number") then
		if (curTime >= self.Attacking) then
			self.Attacking = nil;
			
			self:SendWeaponAnim(ACT_VM_DRAW);
			
			if (SERVER) then
				self.Owner:RemoveAmmo(1, "grenade");
				
				if (self.Owner:GetAmmoCount("grenade") == 0) then
					self.Owner:StripWeapon(self:GetClass());
				end;
			end;
		end;
	end;
end;

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	if (SERVER) then
		self:SetWeaponHoldType("grenade");
	end;
	
	self:SendWeaponAnim(ACT_VM_DRAW);
	
	self.PulledBack = nil;
	self.Attacking = nil;
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	
	self.PulledBack = nil;
	self.Attacking = nil;
	
	return true;
end;

-- Called to get whether the SWEP is raised.
function SWEP:GetRaised()
	local curTime = CurTime();
	
	if (self.Attacking or (self.Raised and self.Raised > curTime)) then
		return true;
	end;
end;

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType("grenade");
	end;
end;

-- A function to create the SWEP's grenade.
function SWEP:CreateGrenade(power)
	if (SERVER) then
		local position = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 64);
		local entity = ents.Create("prop_physics");
		local trace = self.Owner:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(self.Owner:GetShootPos()) <= 80) then
			position = trace.HitPos - (self.Owner:GetAimVector() * 16);
		end;
		
		entity:SetModel("models/items/grenadeammo.mdl");
		entity:SetPos(position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			if (IsValid(entity:GetPhysicsObject())) then
				entity:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * (800 + power));
				entity:GetPhysicsObject():AddAngleVelocity(Vector(600, math.random(-1200, 1200), 0));
			end;
			
			local trail = util.SpriteTrail(entity, entity:LookupAttachment("fuse"), Color(0, 255, 0), true, 8, 1, 1, (1 / 9) * 0.5, "sprites/bluelaser1.vmt");
			
			if (IsValid(trail)) then
				entity:DeleteOnRemove(trail);
			end;
			
			timer.Simple(4, function()
				if (IsValid(entity)) then
					local effectData = EffectData();
					
					effectData:SetStart(entity:GetPos());
					effectData:SetOrigin(entity:GetPos());
					effectData:SetScale(16);
					
					util.Effect("Explosion", effectData, true, true);
					
					local effectData = EffectData();
					
					effectData:SetOrigin(entity:GetPos());
					effectData:SetScale(1);
					
					util.Effect("cw_effect_smoke", effectData, true, true);
					
					entity:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
					entity:Remove();
				end;
			end);
		end;
	end;
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	local curTime = CurTime();
	
	if (!self.Attacking) then
		self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH);
		
		self.PulledBack = curTime + 0.157;
		self.AttackTime = curTime;
		self.Attacking = true;
	end;
	
	return false;
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack() end;