--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	Clockwork.kernel:AddFile("materials/models/weapons/v_stunstick/v_stunstick_diffuse.vmt");
	Clockwork.kernel:AddFile("materials/models/weapons/v_stunstick/v_stunstick_diffuse.vtf");
	Clockwork.kernel:AddFile("materials/models/weapons/v_stunstick/v_stunstick_normal.vtf");
	
	Clockwork.kernel:AddFile("models/weapons/v_stunstick.dx80.vtx");
	Clockwork.kernel:AddFile("models/weapons/v_stunstick.dx90.vtx");
	Clockwork.kernel:AddFile("models/weapons/v_stunstick.sw.vtx");
	Clockwork.kernel:AddFile("models/weapons/v_stunstick.mdl");
	Clockwork.kernel:AddFile("models/weapons/v_stunstick.phy");
	Clockwork.kernel:AddFile("models/weapons/v_stunstick.vvd");
end;

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Stunstick";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Primary Fire: Stun.\nSecondary Fire: Push/Knock.";
SWEP.Purpose = "Stunning disobedient characters, pushing them away and knocking on doors.";
SWEP.Contact = "";
SWEP.Author	= "kurozael";

SWEP.WorldModel = "models/weapons/w_stunbaton.mdl";
SWEP.ViewModel = "models/weapons/v_stunstick.mdl";
SWEP.HoldType = "melee";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 10;
SWEP.Primary.Delay = 1;
SWEP.Primary.Ammo = "";

SWEP.Secondary.NeverRaised = true;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);

if (CLIENT) then
	SWEP.FirstPersonGlowSprite = Material("sprites/light_glow02_add_noz");
	SWEP.ThirdPersonGlowSprite = Material("sprites/light_glow02_add");
end;

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	
	return true;
end;

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType);
end;

-- A function to play the knock sound.
function SWEP:PlayKnockSound()
	if (SERVER) then
		self:CallOnClient("PlayKnockSound", "");
	end;
	
	self:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
end;

-- A function to play the push sound.
function SWEP:PlayPushSound()
	if (SERVER) then
		self:CallOnClient("PlayPushSound", "");
	end;
	
	self:EmitSound("weapons/crossbow/hitbod2.wav");
end;

-- A function to do the SWEP's hit effects.
function SWEP:DoHitEffects()
	local trace = self.Owner:GetEyeTraceNoCursor();
	
	if (((trace.Hit or trace.HitWorld) and self.Owner:GetPos():Distance(trace.HitPos) <= 96)) then
		self:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav");
		
		if (IsValid(trace.Entity) and (trace.Entity:IsPlayer() or trace.Entity:IsNPC())) then
			self:SendWeaponAnim(ACT_VM_MISSCENTER);
			self:EmitSound("weapons/stunstick/stunstick_fleshhit"..math.random(1, 2)..".wav");
		elseif (IsValid(trace.Entity) and Clockwork.entity:GetPlayer(trace.Entity)) then
			self:SendWeaponAnim(ACT_VM_MISSCENTER);
			self:EmitSound("weapons/stunstick/stunstick_fleshhit"..math.random(1, 2)..".wav");
		else
			self:SendWeaponAnim(ACT_VM_MISSCENTER);
			self:EmitSound("weapons/stunstick/stunstick_impact"..math.random(1, 2)..".wav");
		end;
		
		local effectData = EffectData();
		
		effectData:SetStart(trace.HitPos);
		effectData:SetOrigin(trace.HitPos);
		effectData:SetNormal(trace.HitNormal);
		
		if (IsValid(trace.Entity)) then
			effectData:SetEntity(trace.Entity);
		end;
		
		util.Effect("StunstickImpact", effectData, true, true);
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("weapons/stunstick/stunstick_swing"..math.random(1, 2)..".wav");
	end;
end;

-- Called when the weapon is lowered.
function SWEP:OnLowered()
	self:EmitSound("weapons/stunstick/spark"..math.random(1, 3)..".wav");
	
	if (SERVER) then
		self:CallOnClient("OnLowered", "");
		
		if (Clockwork.animation:GetModelClass(self.Owner:GetModel()) == "civilProtection") then
			self.Owner:SetForcedAnimation("deactivatebaton", 1);
		end;
	end;
end;

-- Called when the weapon is raised.
function SWEP:OnRaised()
	self:EmitSound("weapons/stunstick/spark"..math.random(1, 3)..".wav");
	
	if (SERVER) then
		self:CallOnClient("OnRaised", "");
		
		if (Clockwork.animation:GetModelClass(self.Owner:GetModel()) == "civilProtection") then
			self.Owner:SetForcedAnimation("activatebaton", 1);
		end;
	end;
end;

-- Called when the world model is drawn.
function SWEP:DrawWorldModel()
	self:DrawModel();
	
	if (Clockwork.player:GetWeaponRaised(self.Owner)) then
		local attachment = self:GetAttachment(1);
		local curTime = CurTime();
		local scale = math.abs(math.sin(curTime) * 4);
		local alpha = math.abs(math.sin(curTime) / 4);
		
		self.ThirdPersonGlowSprite:SetFloat("$alpha", 0.7 + alpha);
		
		if (attachment and attachment.Pos) then
			cam.Start3D(EyePos(), EyeAngles());
				render.SetMaterial(self.ThirdPersonGlowSprite);
				render.DrawSprite(attachment.Pos, 8 + scale, 8 + scale, Color(255, 255, 255, 255));
			cam.End3D();
		end;
	end;
end;

-- Called when the view model is drawn.
function SWEP:ViewModelDrawn()
	if (Clockwork.player:GetWeaponRaised(self.Owner)) then
		if (self:IsCarriedByLocalPlayer()) then
			local viewModel = Clockwork.Client:GetViewModel();
			
			if (IsValid(viewModel)) then
				local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("sparkrear"));
				local curTime = CurTime();
				local scale = math.abs(math.sin(curTime) * 4);
				local alpha = math.abs(math.sin(curTime) / 4);
				-- local i;
				
				self.FirstPersonGlowSprite:SetFloat("$alpha", 0.7 + alpha);
				self.ThirdPersonGlowSprite:SetFloat("$alpha", 0.5 + alpha);
				
				if (attachment and attachment.Pos) then
					cam.Start3D(EyePos(), EyeAngles());
						render.SetMaterial(self.ThirdPersonGlowSprite);
						render.DrawSprite(attachment.Pos, 8 + scale, 8 + scale, Color(255, 255, 255, 255));
						
						self.FirstPersonGlowSprite:SetFloat("$alpha", 0.5 + alpha);
						
						for i = 1, 9 do
							local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."a"));
							
							if (attachment.Pos) then
								if (i == 1 or i == 2 or i == 9) then
									render.SetMaterial(self.ThirdPersonGlowSprite);
								else
									render.SetMaterial(self.FirstPersonGlowSprite);
								end;
								
								render.DrawSprite(attachment.Pos, 1, 1, Color(255, 255, 255, 255));
							end;
						end;
						
						for i = 1, 9 do
							local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."b"));
							
							if (attachment.Pos) then
								if (i == 1 or i == 2 or i == 9) then
									render.SetMaterial(self.ThirdPersonGlowSprite);
								else
									render.SetMaterial(self.FirstPersonGlowSprite);
								end;
								
								render.DrawSprite(attachment.Pos, 1, 1, Color(255, 255, 255, 255));
							end;
						end;
					cam.End3D();
				end;
			end;
		end;
	end;
end;

-- A function to do the SWEP's animations.
function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay);
	
	self:DoAnimations(); self:DoHitEffects();
	
	if (SERVER) then
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true);
		end;
		
		local trace = self.Owner:GetEyeTraceNoCursor();
		local bounds = Vector(0, 0, 0);
		local startPosition = self.Owner:GetShootPos();
		local finishPosition = startPosition + (self.Owner:GetAimVector() * 96);
		
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 96) then
			if (IsValid(trace.Entity)) then
				local player = Clockwork.entity:GetPlayer(trace.Entity);
				local strength = Clockwork.attributes:Fraction(self.Owner, ATB_STRENGTH, 3, 1.5);
				
				if (trace.Entity:IsPlayer()) then
					local normal = (trace.Entity:GetPos() - self.Owner:GetPos()):GetNormal();
					local push = 128 * normal;
					
					trace.Entity:SetVelocity(push);
					
					if (trace.Entity:Health() > 10) then
						trace.Entity:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo(1 + strength, self, self.Owner, trace.HitPos, DMG_CLUB, 2));
					end;
					
					Clockwork.plugin:Call("PlayerStunEntity", self.Owner, trace.Entity);
				elseif (IsValid(trace.Entity:GetPhysicsObject())) then
					trace.Entity:GetPhysicsObject():ApplyForceOffset(self.Owner:GetAimVector() * 256, trace.HitPos);
					
					if (!player or player:Health() > 10) then
						if (!player) then
							trace.Entity:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo(5 + (strength * 2), self, self.Owner, trace.HitPos, DMG_CLUB, 2));
						else
							trace.Entity:TakeDamageInfo(Clockwork.kernel:FakeDamageInfo(1 + strength, self, self.Owner, trace.HitPos, DMG_CLUB, 2));
						end;
					end;
					
					Clockwork.plugin:Call("PlayerStunEntity", self.Owner, trace.Entity);
				end;
			end;
		end;
		
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false);
		end;
	end;
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	if (SERVER) then
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true);
		end;
		
		local trace = self.Owner:GetEyeTraceNoCursor();
		
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 96) then
			if (IsValid(trace.Entity)) then
				if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 64 and Clockwork.entity:IsDoor(trace.Entity)) then
					self:SetNextPrimaryFire(CurTime() + 0.25);
					self:SetNextSecondaryFire(CurTime() + 0.25);
					
					if (Clockwork.plugin:Call("PlayerCanKnockOnDoor", self.Owner, trace.Entity)) then
						self:PlayKnockSound();
						
						Clockwork.plugin:Call("PlayerKnockOnDoor", self.Owner, trace.Entity);
					end;
				else
					self:PlayPushSound();
					
					self:SetNextPrimaryFire(CurTime() + 0.5);
					self:SetNextSecondaryFire(CurTime() + 0.5);
					
					if (Clockwork.animation:GetModelClass(self.Owner:GetModel()) == "civilProtection") then
						self.Owner:SetForcedAnimation("pushplayer", 1);
					end;
					
					if (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
						if (self.Owner:GetPos():Distance(trace.HitPos) <= 96) then
							local normal = (trace.Entity:GetPos() - self.Owner:GetPos()):GetNormal();
							local push = 256 * normal;
							
							trace.Entity:SetVelocity(push);
						end;
					elseif (IsValid(trace.Entity:GetPhysicsObject())) then
						trace.Entity:GetPhysicsObject():ApplyForceOffset(self.Owner:GetAimVector() * 256, trace.HitPos);
					end;
				end;
			end;
		end;
		
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false);
		end;
	end;
end;