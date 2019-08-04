--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when Clockwork has loaded all of the entities.
function Schema:ClockworkInitPostEntity()
	self:LoadRationDispensers();
	self:LoadVendingMachines();
	self:LoadCombineLocks();
	self:LoadObjectives();
	self:LoadRadios();
	self:LoadNPCs();
end;

-- Called when data should be saved.
function Schema:SaveData() end;

-- Called just after data should be saved.
function Schema:PostSaveData()
	self:SaveRationDispensers();
	self:SaveVendingMachines();
	self:SaveCombineLocks();
	self:SaveRadios();
	self:SaveNPCs();
end;

-- Called when an entity's menu option should be handled.
function Schema:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "prop_ragdoll" and arguments == "cw_corpseLoot") then
		if (!entity.cwInventory) then entity.cwInventory = {}; end;
		if (!entity.cash) then entity.cash = 0; end;
		
		local entityPlayer = Clockwork.entity:GetPlayer(entity);
		
		if (!entityPlayer or !entityPlayer:Alive()) then
			player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
			
			Clockwork.storage:Open(player, {
				name = "Corpse",
				weight = 8,
				entity = entity,
				distance = 192,
				cash = entity.cash,
				inventory = entity.cwInventory,
				OnGiveCash = function(player, storageTable, cash)
					entity.cash = storageTable.cash;
				end,
				OnTakeCash = function(player, storageTable, cash)
					entity.cash = storageTable.cash;
				end
			});
		end;
	elseif (entity:GetClass() == "cw_belongings" and arguments == "cw_belongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		Clockwork.storage:Open(player, {
			name = "Belongings",
			weight = 100,
			entity = entity,
			distance = 192,
			cash = entity.cash,
			inventory = entity.cwInventory,
			OnGiveCash = function(player, storageTable, cash)
				entity.cash = storageTable.cash;
			end,
			OnTakeCash = function(player, storageTable, cash)
				entity.cash = storageTable.cash;
			end,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity)) then
					if ((!entity.cwInventory and !entity.cash) or (table.Count(entity.cwInventory) == 0 and entity.cash == 0)) then
						entity:Explode(entity:BoundingRadius() * 2);
						entity:Remove();
					end;
				end;
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false;
			end
		});
	elseif (entity:GetClass() == "cw_breach") then
		entity:CreateDummyBreach();
		entity:BreachEntity(player);
	elseif (entity:GetClass() == "cw_radio") then
		if (option == "SetFrequency" and type(arguments) == "string") then
			if (string.find(arguments, "^%d%d%d%.%d$")) then
				local start, finish, decimal = string.match(arguments, "(%d)%d(%d)%.(%d)");
				
				start = tonumber(start);
				finish = tonumber(finish);
				decimal = tonumber(decimal);
				
				if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
					entity:SetFrequency(arguments);
					
					Clockwork.player:Notify(player, {"YouSetRadioFrequencyTo", arguments});
				else
					Clockwork.player:Notify(player, {"RadioArgumentsMustBeBetween"});
				end;
			else
				Clockwork.player:Notify(player, {"RadioArgumentsMustBeLike"});
			end;
		elseif (arguments == "cw_radioToggle") then
			entity:Toggle();
		elseif (arguments == "cw_radioTake") then
			local bSuccess, fault = player:GiveItem(Clockwork.item:CreateInstance("stationary_radio"));
			
			if (!bSuccess) then
				Clockwork.player:Notify(player, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when an NPC has been killed.
function Schema:OnNPCKilled(npc, attacker, inflictor)
	for k, v in pairs(self.scanners) do
		local scanner = v[1];
		local player = k;
		
		if (IsValid(player) and IsValid(scanner) and scanner == npc) then
			Clockwork.kernel:CalculateSpawnTime(player, inflictor, attacker);
			
			npc:EmitSound("npc/scanner/scanner_explode_crash2.wav");
			
			self:PlayerDeath(player, inflictor, attacker, true);
			self:ResetPlayerScanner(player);
		end;
	end;
end;

-- Called when a player's visibility should be set up.
function Schema:SetupPlayerVisibility(player)
	if (self.scanners[player]) then
		local scanner = self.scanners[player][1];
		
		if (IsValid(scanner)) then
			AddOriginToPVS(scanner:GetPos());
		end;
	end;
end;

-- Called when a player's drop weapon info should be adjusted.
function Schema:PlayerAdjustDropWeaponInfo(player, info)
	if (Clockwork.player:GetWeaponClass(player) == info.itemTable.weaponClass) then
		info.position = player:GetShootPos();
		info.angles = player:GetAimVector():Angle();
	else
		local gearTable = {
			Clockwork.player:GetGear(player, "Throwable"),
			Clockwork.player:GetGear(player, "Secondary"),
			Clockwork.player:GetGear(player, "Primary"),
			Clockwork.player:GetGear(player, "Melee")
		};
		
		for k, v in pairs(gearTable) do
			if (IsValid(v)) then
				local gearItemTable = v:GetItemTable();
				
				if (gearItemTable and gearItemTable.weaponClass == info.itemTable.weaponClass) then
					local position, angles = v:GetRealPosition();
					
					if (position and angles) then
						info.position = position;
						info.angles = angles;
						
						break;
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player uses a door.
function Schema:PlayerUseDoor(player, door)
	if (string.lower(game.GetMap()) == "rp_c18_v1") then
		local name = string.lower(door:GetName());
		
		if (name == "nxs_brnroom" or name == "nxs_brnroom2" or name == "Clockwork_al_door1"
		or name == "Clockwork_al_door2" or name == "nxs_brnbcroom") then
			local curTime = CurTime();
			
			if (!door.nextAutoClose or curTime >= door.nextAutoClose) then
				door:Fire("Close", "", 10);
				door.nextAutoClose = curTime + 10;
			end;
		end;
	end;
end;

-- Called when a player has an unknown inventory item.
function Schema:PlayerHasUnknownInventoryItem(player, inventory, item, amount)
	if (item == "radio") then
		inventory["handheld_radio"] = amount;
	end;
end;

-- Called when a player stuns an entity.
function Schema:PlayerStunEntity(player, entity)
	local target = Clockwork.entity:GetPlayer(entity);
	local strength = Clockwork.attributes:Fraction(player, ATB_STRENGTH, 12, 6);
	
	player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	
	if (target and target:Alive()) then
		local curTime = CurTime();
		
		if (target.nextStunInfo and curTime <= target.nextStunInfo[2]) then
			target.nextStunInfo[1] = target.nextStunInfo[1] + 1;
			target.nextStunInfo[2] = curTime + 2;
			
			if (target.nextStunInfo[1] == 3) then
				Clockwork.player:SetRagdollState(target, RAGDOLL_KNOCKEDOUT, Clockwork.config:Get("knockout_time"):Get());
			end;
		else
			target.nextStunInfo = {0, curTime + 2};
		end;
		
		target:ViewPunch(Angle(12 + strength, 0, 0));
		
		Clockwork.datastream:Start(target, "Stunned", 0.5);
	end;
end;

-- Called when a player switches their flashlight on or off.
function Schema:PlayerSwitchFlashlight(player, on)
	if (on and (self.scanners[player] or player:GetSharedVar("IsTied") != 0)) then
		return false;
	end;
end;

-- Called when a player's storage should close.
function Schema:PlayerStorageShouldClose(player, storage)
	local entity = player:GetStorageEntity();
	
	if (player.cwSearching and entity:IsPlayer() and entity:GetSharedVar("IsTied") == 0) then
		return true;
	end;
end;

-- Called when a player attempts to spray their tag.
function Schema:PlayerSpray(player)
	if (!player:HasItemByID("spray_can") or player:GetSharedVar("IsTied") != 0) then
		return true;
	end;
end;

-- Called when a player presses F3.
function Schema:ShowSpare1(player)
	local itemTable = player:FindItemByID("zip_tie");
	
	if (!itemTable) then
		Clockwork.player:Notify(player, {"YouDoNotOwnAZipTie"});
		
		return;
	end;

	Clockwork.player:RunClockworkCommand(player, "InvAction", "use", itemTable("uniqueID"), tostring(itemTable("itemID")));
end;

-- Called when a player presses F4.
function Schema:ShowSpare2(player)
	Clockwork.player:RunClockworkCommand(player, "CharSearch");
end;

-- Called when a player's footstep sound should be played.
function Schema:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	local clothesItem = player:GetClothesItem();
	local running = nil;
	local model = string.lower(player:GetModel());
	
	if (clothesItem) then
		if (player:IsRunning() or player:IsJogging()) then
			if (clothesItem.runSound) then
				if (type(clothesItem.runSound) == "table") then
					sound = clothesItem.runSound[math.random(1, #clothesItem.runSound)];
				else
					sound = clothesItem.runSound;
				end;
			end;
		elseif (clothesItem.walkSound) then
			if (type(clothesItem.walkSound) == "table") then
				sound = clothesItem.walkSound[math.random(1, #clothesItem.walkSound)];
			else
				sound = clothesItem.walkSound;
			end;
		end;
	end;
	
	if (player:IsRunning() or player:IsJogging()) then
		running = true;
	end;
	
	if (running) then
		if (string.find(model, "metrocop") or string.find(model, "shockcp") or string.find(model, "ghostcp") or string.find(model, "police")) then
			if (foot == 0) then
				local randomSounds = {1, 3, 5};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/metropolice/gear"..randomSounds[randomNumber]..".wav";
			else
				local randomSounds = {2, 4, 6};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/metropolice/gear"..randomSounds[randomNumber]..".wav";
			end;
		elseif (string.find(model, "combine")) then
			if (foot == 0) then
				local randomSounds = {1, 3, 5};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/combine_soldier/gear"..randomSounds[randomNumber]..".wav";
			else
				local randomSounds = {2, 4, 6};
				local randomNumber = math.random(1, 3);
				
				sound = "npc/combine_soldier/gear"..randomSounds[randomNumber]..".wav";
			end;
		end;
	end;
	
	player:EmitSound(sound);
	
	return true;
end;

-- Called when a player attempts to spawn a prop.
function Schema:PlayerSpawnProp(player, model)
	if (!player:IsAdmin() and Clockwork.config:Get("cwu_props"):Get()) then
		if (player:GetFaction() == FACTION_CITIZEN) then
			
			if (player:GetCharacterData("CustomClass") != "Civil Worker's Union") then
				model = string.Replace(model, "\\", "/");
				model = string.Replace(model, "//", "/");
				model = string.lower(model);
				
				if (string.find(model, "bed")) then
					Clockwork.player:Notify(player, {"NotInCWU"});
					
					return false;
				end;
				
				for k, v in pairs(self.cwuProps) do
					if (string.lower(v) == model) then
						Clockwork.player:Notify(player, {"NotInCWU"});
						
						return false;
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player spawns an object.
function Schema:PlayerSpawnObject(player)
	if (player:GetSharedVar("IsTied") != 0 or self.scanners[player]) then
		Clockwork.player:Notify(player, {"YouCannotDoThatRightNow"});
		
		return false;
	end;
end;

-- Called when a player's character data should be restored.
function Schema:PlayerRestoreCharacterData(player, data)
	--[[ Backwards Compatability... --]]
	local compatability = {
		["permakilled"] = "PermaKilled",
		["combinedata"] = "CombineData",
		["nextration"] = "NextRation",
		["customclass"] = "CustomClass",
		["frequency"] = "Frequency",
		["citizenid"] = "CitizenID",
		["icon"] = "Icon"
	};
	
	for k, v in pairs(compatability) do
		if (data[k]) then
			data[v] = data[k];
			data[k] = nil;
		end;
	end;

	if (!self:PlayerIsCombine(player) and player:GetFaction() != FACTION_ADMIN) then
		if (!data["CitizenID"] or string.len(tostring(data["CitizenID"])) == 4) then
			data["CitizenID"] = Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5);
		end;
	end;
end;

-- Called when a player attempts to breach an entity.
function Schema:PlayerCanBreachEntity(player, entity)
	if (string.lower(entity:GetClass()) == "func_door_rotating") then
		return false;
	end;
	
	if (Clockwork.entity:IsDoor(entity)) then
		if (!Clockwork.entity:IsDoorFalse(entity)) then
			return true;
		end;
	end;
end;

-- Called when a player attempts to restore a recognised name.
function Schema:PlayerCanRestoreRecognisedName(player, target)
	if (self:PlayerIsCombine(target)) then
		return false;
	end;
end;

-- Called when a player attempts to save a recognised name.
function Schema:PlayerCanSaveRecognisedName(player, target)
	if (self:PlayerIsCombine(target)) then
		return false;
	end;
end;

-- Called when a player attempts to use the radio.
function Schema:PlayerCanRadio(player, text, listeners, eavesdroppers)
	if (player:HasItemByID("handheld_radio") or self.scanners[player]) then
		if (!player:GetCharacterData("Frequency")) then
			Clockwork.player:Notify(player, {"NeedToSetFrequencyFirst"});
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, {"YouDoNotOwnARadio"});
		
		return false;
	end;
end;

-- Called when a player's character has initialized.
function Schema:PlayerCharacterInitialized(player)
	local faction = player:GetFaction();
	
	if (faction == FACTION_CITIZEN) then
		self:AddCombineDisplayLine("RebuildCitizenManifest", Color(255, 100, 255, 255));
	end;
end;

-- Called when a player attempts to use an entity in a vehicle.
function Schema:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if (entity:IsPlayer() or Clockwork.entity:IsPlayerRagdoll(entity)) then
		return true;
	end;
end;

-- Called when a player presses a key.
function Schema:KeyPress(player, key)
	if (key == IN_USE) then
		if (!self.scanners[player]) then
			local untieTime = Schema:GetDexterityTime(player);
			local target = player:GetEyeTraceNoCursor().Entity;
			local entity = target;
			
			if (IsValid(target)) then
				target = Clockwork.entity:GetPlayer(target);
				
				if (target and player:GetSharedVar("IsTied") == 0) then
					if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
						if (target:GetSharedVar("IsTied") != 0) then
							Clockwork.player:SetAction(player, "untie", untieTime);
							
							Clockwork.player:EntityConditionTimer(player, target, entity, untieTime, 192, function()
								return player:Alive() and !player:IsRagdolled() and player:GetSharedVar("IsTied") == 0;
							end, function(success)
								if (success) then
									self:TiePlayer(target, false);
									
									player:ProgressAttribute(ATB_DEXTERITY, 15, true);
								end;
								
								Clockwork.player:SetAction(player, "untie", false);
							end);
						end;
					end;
				end;
			end;
		end;
	elseif (key == IN_ATTACK or key == IN_ATTACK2) then
		if (self.scanners[player]) then
			local scanner = self.scanners[player][1];
			
			if (IsValid(scanner)) then
				player.nextScannerSound = CurTime() + math.random(8, 48);
				
				scanner:EmitSound(self.scannerSounds[ math.random(1, #self.scannerSounds) ]);
			end;
		end;
	elseif (key == IN_RELOAD) then
		if (self.scanners[player]) then
			local scanner = self.scanners[player][1];
			local curTime = CurTime();
			local marker = self.scanners[player][2];
			
			if (IsValid(scanner)) then
				local position = scanner:GetPos();
				
				for k, v in ipairs(ents.FindInSphere(position, 384)) do
					if (v:IsPlayer() and v:HasInitialized() and !self:PlayerIsCombine(v)) then
						local playerPosition = v:GetPos();
						local scannerDot = scanner:GetAimVector():Dot((playerPosition - position):GetNormal());
						local playerDot = v:GetAimVector():Dot((position - playerPosition):GetNormal());
						local threshold = 0.2 + math.Clamp((0.6 / 384) * playerPosition:Distance(position), 0, 0.6);
						
						if (Clockwork.player:CanSeeEntity(v, scanner, 0.9, {marker}) and playerDot >= threshold and scannerDot >= threshold) then
							if (player != v) then
								if (v:GetFaction() == FACTION_CITIZEN) then
									if (!v:GetForcedAnimation()) then
										v:SetForcedAnimation("photo_react_blind", 2, function(player)
											player:Freeze(true);
										end, function(player)
											player:Freeze(false);
										end);
									end;
								end;
								
								Clockwork.datastream:Start(v, "Stunned", 3);
							end;
						end;
					end;
				end;
				
				scanner:EmitSound("npc/scanner/scanner_photo1.wav");
			end;
		end;
	elseif (key == IN_WALK) then
		if (self.scanners[player]) then
			Clockwork.player:RunClockworkCommand(player, "CharFollow");
		end;
	end;
end;

-- Called each tick.
function Schema:Tick()
	for k, v in pairs(self.scanners) do
		local scanner = v[1];
		local marker = v[2];
		
		if (IsValid(k)) then
			if (IsValid(scanner) and IsValid(marker)) then
				if (k:KeyDown(IN_FORWARD)) then
					local position = scanner:GetPos() + (scanner:GetForward() * 25) + (scanner:GetUp() * -64);
					
					if (k:KeyDown(IN_SPEED)) then
						marker:SetPos(position + (k:GetAimVector() * 64));
					else
						marker:SetPos(position + (k:GetAimVector() * 128));
					end;
					
					scanner.followTarget = nil;
				end;
				
				if (IsValid(scanner.followTarget)) then
					scanner:Input("SetFollowTarget", scanner.followTarget, scanner.followTarget, "!activator");
				else
					scanner:Fire("SetFollowTarget", "marker_"..k:UniqueID(), 0);
				end;
				
				local rankName = k:GetFactionRank();

				if (scannerClass == "npc_cscanner" and rankName == "SYNTH") then
					self:MakePlayerScanner(k, true);
				elseif (scannerClass == "npc_clawscanner" and rankName != "SYNTH") then
					self:MakePlayerScanner(k, true);
				end;
			else
				self:ResetPlayerScanner(k);
			end;
		else
			if (IsValid(scanner)) then
				scanner:Remove();
			end;
			
			if (IsValid(marker)) then
				marker:Remove();
			end;
			
			self.scanners[k] = nil;
		end;
	end;
end;

-- Called when a player's health is set.
function Schema:PlayerHealthSet(player, newHealth, oldHealth)
	if (self.scanners[player]) then
		if (IsValid(self.scanners[player][1])) then
			self.scanners[player][1]:SetHealth(newHealth);
		end;
	end;
end;

-- Called when a player attempts to be given a weapon.
function Schema:PlayerCanBeGivenWeapon(player, class, uniqueID, forceReturn)
	if (self.scanners[player]) then
		return false;
	end;
end;

-- Called each frame that a player is dead.
function Schema:PlayerDeathThink(player)
	if (player:GetCharacterData("PermaKilled")) then
		return true;
	end;
end;

-- Called when a player attempts to switch to a character.
function Schema:PlayerCanSwitchCharacter(player, character)
	if (player:GetCharacterData("PermaKilled")) then
		return true;
	end;
	
	if (player:GetSharedVar("IsTied") != 0) then
		return false, "You cannot switch to this character while tied!";
	end;
end;

-- Called when a player's death info should be adjusted.
function Schema:PlayerAdjustDeathInfo(player, info)
	if (player:GetCharacterData("PermaKilled")) then
		info.spawnTime = 0;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function Schema:PlayerAdjustCharacterScreenInfo(player, character, info)
	if (character.data["PermaKilled"]) then
		info.details = "This character is permanently killed.";
	end;
	
	if (character.data["CustomClass"]) then
		info.customClass = character.data["CustomClass"];
	end;
end;

-- Called when a chat box message has been added.
function Schema:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		local eavesdroppers = {};
		local talkRadius = Clockwork.config:Get("talk_radius"):Get();
		local listeners = {};
		local players = _player.GetAll();
		local radios = ents.FindByClass("cw_radio");
		local data = {};
		
		for k, v in ipairs(radios) do
			if (!v:IsOff() and info.speaker:GetPos():Distance(v:GetPos()) <= 80) then
				local frequency = v:GetFrequency();
				
				if (frequency != 0) then
					info.shouldSend = false;
					info.listeners = {};
					data.frequency = frequency;
					data.position = v:GetPos();
					data.entity = v;
					
					break;
				end;
			end;
		end;
		
		if (IsValid(data.entity) and data.frequency != "") then
			for k, v in ipairs(players) do
				if (v:HasInitialized() and v:Alive() and !v:IsRagdolled(RAGDOLL_FALLENOVER)) then
					if ((v:GetCharacterData("Frequency") == data.frequency and v:GetSharedVar("IsTied") == 0
					and v:HasItemByID("handheld_radio")) or info.speaker == v) then
						listeners[v] = v;
					elseif (v:GetPos():Distance(data.position) <= talkRadius) then
						eavesdroppers[v] = v;
					end;
				end;
			end;
			
			for k, v in ipairs(radios) do
				local radioPosition = v:GetPos();
				local radioFrequency = v:GetFrequency();
				
				if (!v:IsOff() and radioFrequency == data.frequency) then
					for k2, v2 in ipairs(players) do
						if (v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2]) then
							if (v2:GetPos():Distance(radioPosition) <= (talkRadius * 2)) then
								eavesdroppers[v2] = v2;
							end;
						end;
						
						break;
					end;
				end;
			end;
			
			if (table.Count(listeners) > 0) then
				Clockwork.chatBox:Add(listeners, info.speaker, "radio", info.text);
			end;
			
			if (table.Count(eavesdroppers) > 0) then
				Clockwork.chatBox:Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
			end;
			
			table.Merge(info.listeners, listeners);
			table.Merge(info.listeners, eavesdroppers);
		end;
	end;
end;

-- Called when a player has used their radio.
function Schema:PlayerRadioUsed(player, text, listeners, eavesdroppers)
	local newEavesdroppers = {};
	local talkRadius = Clockwork.config:Get("talk_radius"):Get() * 2;
	local frequency = player:GetCharacterData("Frequency");
	
	for k, v in ipairs(ents.FindByClass("cw_radio")) do
		local radioPosition = v:GetPos();
		local radioFrequency = v:GetFrequency();
		
		if (!v:IsOff() and radioFrequency == frequency) then
			for k2, v2 in ipairs(_player.GetAll()) do
				if (v2:HasInitialized() and !listeners[v2] and !eavesdroppers[v2]) then
					if (v2:GetPos():Distance(radioPosition) <= talkRadius) then
						newEavesdroppers[v2] = v2;
					end;
				end;
				
				break;
			end;
		end;
	end;
	
	if (table.Count(newEavesdroppers) > 0) then
		Clockwork.chatBox:Add(newEavesdroppers, player, "radio_eavesdrop", text);
	end;
end;

-- Called when a player's radio info should be adjusted.
function Schema:PlayerAdjustRadioInfo(player, info)
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized() and v:HasItemByID("handheld_radio")) then
			if (v:GetCharacterData("Frequency") == player:GetCharacterData("Frequency")) then
				if (v:GetSharedVar("IsTied") == 0) then
					info.listeners[v] = v;
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to use a tool.
function Schema:CanTool(player, trace, tool)
	if (!Clockwork.player:HasFlags(player, "w")) then
		if (string.sub(tool, 1, 5) == "wire_" or string.sub(tool, 1, 6) == "wire2_") then
			player:RunCommand("gmod_toolmode \"\"");
			
			return false;
		end;
	end;
end;

-- Called when a player has been healed.
function Schema:PlayerHealed(player, healer, itemTable)
	if (itemTable.uniqueID == "health_vial") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 2, 120);
		healer:ProgressAttribute(ATB_MEDICAL, 15, true);
	elseif (itemTable.uniqueID == "health_kit") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 3, 120);
		healer:ProgressAttribute(ATB_MEDICAL, 25, true);
	elseif (itemTable.uniqueID == "bandage") then
		healer:BoostAttribute(itemTable.name, ATB_DEXTERITY, 1, 120);
		healer:ProgressAttribute(ATB_MEDICAL, 5, true);
	end;
end;

-- Called when a player's shared variables should be set.
function Schema:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("CustomClass", player:GetCharacterData("CustomClass", ""));
	player:SetSharedVar("CitizenID", player:GetCharacterData("CitizenID", ""));
	player:SetSharedVar("Icon", player:GetCharacterData("Icon", ""));
	
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		local inventoryWeight = player:GetInventoryWeight();
		
		if (inventoryWeight >= player:GetMaxWeight() / 4) then
			player:ProgressAttribute(ATB_STRENGTH, inventoryWeight / 400, true);
		end;
	end;
end;

-- Called at an interval while a player is connected.
function Schema:PlayerThink(player, curTime, infoTable)
	if (player:Alive() and !player:IsRagdolled()) then
		if (!player:InVehicle() and player:GetMoveType() == MOVETYPE_WALK) then
			if (player:IsInWorld()) then
				if (!player:IsOnGround()) then
					player:ProgressAttribute(ATB_ACROBATICS, 0.25, true);
				elseif (infoTable.isRunning) then
					player:ProgressAttribute(ATB_AGILITY, 0.125, true);
				elseif (infoTable.isJogging) then
					player:ProgressAttribute(ATB_AGILITY, 0.0625, true);
				end;
			end;
		end;
	end;
	
	if (Clockwork.player:HasAnyFlags(player, "vV")) then
		if (infoTable.wages == 0) then
			infoTable.wages = 20;
		end;
	end;
	
	if (self.scanners[player]) then
		self:CalculateScannerThink(player, curTime);
	end;
	
	local acrobatics = Clockwork.attributes:Fraction(player, ATB_ACROBATICS, 100, 50);
	local strength = Clockwork.attributes:Fraction(player, ATB_STRENGTH, 8, 4);
	local agility = Clockwork.attributes:Fraction(player, ATB_AGILITY, 50, 25);
	
	if (self:PlayerIsCombine(player)) then
		infoTable.inventoryWeight = infoTable.inventoryWeight + 8;
	end;
	
	if (clothes != "") then
		local itemTable = Clockwork.item:FindByID(clothes);
		
		if (itemTable and itemTable.pocketSpace) then
			infoTable.inventoryWeight = infoTable.inventoryWeight + itemTable.pocketSpace;
		end;
	end;
	
	infoTable.inventoryWeight = infoTable.inventoryWeight + strength;
	infoTable.jumpPower = infoTable.jumpPower + acrobatics;
	infoTable.runSpeed = infoTable.runSpeed + agility;
end;

-- Called when an entity is removed.
function Schema:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll") then
		if (entity.areBelongings and entity.cwInventory and entity.cash) then
			if (table.Count(entity.inventory) > 0 or entity.cash > 0) then
				local belongings = ents.Create("cw_belongings");
				
				belongings:SetAngles(Angle(0, 0, -90));
				belongings:SetData(entity.cwInventory, entity.cash);
				belongings:SetPos(entity:GetPos() + Vector(0, 0, 32));
				belongings:Spawn();
				
				entity.cwInventory = nil;
				entity.cash = nil;
			end;
		end;
	end;
end;

-- Called when the player attempts to be ragdolled.
function Schema:PlayerCanRagdoll(player, state, delay, decay, ragdoll)
	if (self.scanners[player]) then
		return false;
	end;
end;

-- Called when a player attempts to NoClip.
function Schema:PlayerNoClip(player)
	if (self.scanners[player]) then
		return false;
	end;
end;

-- Called when a player's data should be saved.
function Schema:PlayerSaveData(player, data)
	if (data["ServerWhitelist"] and table.Count(data["ServerWhitelist"]) == 0) then
		data["ServerWhitelist"] = nil;
	end;
end;

-- Called when a player's data should be restored.
function Schema:PlayerRestoreData(player, data)
	if (!data["ServerWhitelist"]) then
		data["ServerWhitelist"] = {};
	end;
	
	local serverWhitelistIdentity = Clockwork.config:Get("server_whitelist_identity"):Get();
	
	if (serverWhitelistIdentity != "") then
		if (!data["ServerWhitelist"][serverWhitelistIdentity]) then
			player:Kick("You aren't whitelisted");
		end;
	end;
end;

-- Called to check if a player does have an flag.
function Schema:PlayerDoesHaveFlag(player, flag)
	if (!Clockwork.config:Get("permits"):Get()) then
		if (flag == "x" or flag == "1") then
			return false;
		end;
		
		for k, v in pairs(self.customPermits) do
			if (v.flag == flag) then
				return false;
			end;
		end;
	end;
end;

-- Called when a player's attribute has been updated.
function Schema:PlayerAttributeUpdated(player, attributeTable, amount)
	if (self:PlayerIsCombine(player) and amount and amount > 0) then
		self:AddCombineDisplayLine({"UpdateExternalAttributes", Clockwork.option:Translate("name_attributes", true)}, Color(255, 125, 0, 255), player);
	end;
end;

-- Called to check if a player does recognise another player.
function Schema:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	if (self:PlayerIsCombine(target) or target:GetFaction() == FACTION_ADMIN) then
		return true;
	end;
end;

-- Called when a player attempts to delete a character.
function Schema:PlayerCanDeleteCharacter(player, character)
	if (character.data["PermaKilled"]) then
		return true;
	end;
end;

-- Called when a player attempts to use a character.
function Schema:PlayerCanUseCharacter(player, character)
	if (character.data["PermaKilled"]) then
		return character.name.." is permanently killed and cannot be used!";
	end;
end;

-- Called when attempts to use a command.
function Schema:PlayerCanUseCommand(player, commandTable, arguments)
	if (player:GetSharedVar("IsTied") != 0) then
		local blacklisted = {
			"OrderShipment",
			"Broadcast",
			"Dispatch",
			"Request",
			"Radio"
		};
		
		if (table.HasValue(blacklisted, commandTable.name)) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenTied"});
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to use a door.
function Schema:PlayerCanUseDoor(player, door)
	if (player:GetSharedVar("IsTied") != 0 or (!self:PlayerIsCombine(player) and player:GetFaction() != FACTION_ADMIN)) then
		return false;
	end;
end;

-- Called when a player attempts to lock an entity.
function Schema:PlayerCanLockEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity) and IsValid(entity.combineLock)) then
		if (Clockwork.config:Get("combine_lock_overrides"):Get() or entity.combineLock:IsLocked()) then
			return false;
		end;
	end;
end;

-- Called when a player attempts to unlock an entity.
function Schema:PlayerCanUnlockEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity) and IsValid(entity.combineLock)) then
		if (Clockwork.config:Get("combine_lock_overrides"):Get() or entity.combineLock:IsLocked()) then
			return false;
		end;
	end;
end;

-- Called when a player's character has unloaded.
function Schema:PlayerCharacterUnloaded(player)
	self:ResetPlayerScanner(player);
end;

-- Called when a player attempts to change class.
function Schema:PlayerCanChangeClass(player, class)
	if (player:GetSharedVar("IsTied") != 0) then
		Clockwork.player:Notify(player, {"CannotDoThisWhenTied"});
		
		return false;
	elseif (self:PlayerIsCombine(player)) then
		return false;
	end;
end;

-- Called when a player attempts to use an entity.
function Schema:PlayerUse(player, entity)
	local curTime = CurTime();
	local faction = player:GetFaction();
	
	if (self.scanners[player]) then
		return false;
	end;
	
	if (entity.bustedDown) then
		return false;
	end;
	
	if (player:KeyDown(IN_SPEED) and Clockwork.entity:IsDoor(entity)) then
		if ((self:PlayerIsCombine(player) or player:GetFaction() == FACTION_ADMIN) and IsValid(entity.combineLock)) then
			if (!player.nextCombineLock or curTime >= player.nextCombineLock) then
				entity.combineLock:ToggleWithChecks(player);
				
				player.nextCombineLock = curTime + 3;
			end;
			
			return false;
		end;
	end;
	
	if (player:GetSharedVar("IsTied") != 0) then
		if (entity:IsVehicle()) then
			if (Clockwork.entity:IsChairEntity(entity) or Clockwork.entity:IsPodEntity(entity)) then
				return;
			end;
		end;
		
		if (!player.nextTieNotify or player.nextTieNotify < CurTime()) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenTied"});
			
			player.nextTieNotify = CurTime() + 2;
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to destroy an item.
function Schema:PlayerCanDestroyItem(player, itemTable, noMessage)
	if (self.scanners[player]) then
		if (!noMessage) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenScanner"});
		end;
		
		return false;
	elseif (player:GetSharedVar("IsTied") != 0) then
		if (!noMessage) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenTied"});
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function Schema:PlayerCanDropItem(player, itemTable, noMessage)
	if (self.scanners[player]) then
		if (!noMessage) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenScanner"});
		end;
		
		return false;
	elseif (player:GetSharedVar("IsTied") != 0) then
		if (!noMessage) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenTied"});
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function Schema:PlayerCanUseItem(player, itemTable, noMessage)
	if (self.scanners[player]) then
		if (!noMessage) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenScanner"});
		end;
		
		return false;
	elseif (player:GetSharedVar("IsTied") != 0) then
		if (!noMessage) then
			Clockwork.player:Notify(player, {"CannotDoThisWhenTied"});
		end;
		
		return false;
	end;
	
	if (Clockwork.item:IsWeapon(itemTable) and !itemTable:IsFakeWeapon()) then
		local secondaryWeapon;
		local primaryWeapon;
		local sideWeapon;
		local fault;
		
		for k, v in ipairs(player:GetWeapons()) do
			local weaponTable = Clockwork.item:GetByWeapon(v);
			
			if (weaponTable and !weaponTable:IsFakeWeapon()) then
				if (weaponTable("weight") >= 1) then
					if (weaponTable("weight") <= 2) then
						secondaryWeapon = true;
					else
						primaryWeapon = true;
					end;
				else
					sideWeapon = true;
				end;
			end;
		end;
		
		if (itemTable("weight") >= 1) then
			if (itemTable("weight") <= 2) then
				if (secondaryWeapon) then
					fault = {"CannotUseAnotherSecondary"};
				end;
			elseif (primaryWeapon) then
				fault = {"CannotUseAnotherPrimary"};
			end;
		elseif (sideWeapon) then
			fault = {"CannotUseAnotherMelee"};
		end;
		
		if (fault) then
			if (!noMessage) then
				Clockwork.player:Notify(player, fault);
			end;
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to earn generator cash.
function Schema:PlayerCanEarnGeneratorCash(player, info, cash)
	if (self:PlayerIsCombine(player)) then
		return false;
	end;
end;

-- Called when a player's death sound should be played.
function Schema:PlayerPlayDeathSound(player, gender)
	if (self:PlayerIsCombine(player)) then
		local sound = "npc/metropolice/die"..math.random(1, 4)..".wav";
		
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized()) then
				if (self:PlayerIsCombine(v)) then
					v:EmitSound(sound);
				end;
			end;
		end;
		
		return sound;
	end;
end;

-- Called when a player's pain sound should be played.
function Schema:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if (self:PlayerIsCombine(player)) then
		return "npc/metropolice/pain"..math.random(1, 4)..".wav";
	end;
end;

-- Called when chat box info should be adjusted.
function Schema:ChatBoxAdjustInfo(info)
	if (IsValid(info.speaker) and info.speaker:HasInitialized()) then
		if (table.HasValue(Clockwork.voices.chatClasses, info.class)) then
			if (info.class == "request" or info.class == "radio" or info.class == "dispatch") then
				info.voice = info.voice or {};
				info.voice.global = true;
			end;
			
			if (info.class == "dispatch") then
				for k, v in pairs(Clockwork.voices:GetVoices("Dispatch")) do
					if (string.lower(info.text) == string.lower(v.command)) then
						Clockwork.player:PlaySound(nil, v.sound);
						
						info.text = v.phrase;
					end;
				end;
			end;
			
			local playerIsCombine = self:PlayerIsCombine(info.speaker);
	
			if (playerIsCombine) then
				info.textTransformer = function(text)
					local finalText = text;
	
					if (string.sub(info.text, 1, 4) != "<:: ") then
						finalText = "<:: " .. finalText;
					end;
	
					if (string.sub(info.text, -4) != " ::>") then
						finalText = finalText .. " ::>";
					end;
	
					return finalText;
				end;
			end;
		end;
	end;
end;

-- Called when a player destroys generator.
function Schema:PlayerDestroyGenerator(player, entity, generator)
	if (self:PlayerIsCombine(player)) then
		local players = {};
		
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized()) then
				if (self:PlayerIsCombine(v)) then
					players[#players + 1] = v;
				end;
			end;
		end;
		
		for k, v in pairs(players) do
			Clockwork.player:GiveCash(v, generator.cash / 4, {"CashDestroyGenerator", string.lower(generator.name)});
		end;
	else
		Clockwork.player:GiveCash(v, generator.cash / 4, {"CashDestroyGenerator", string.lower(generator.name)});
	end;
end;

-- Called just before a player dies.
function Schema:DoPlayerDeath(player, attacker, damageInfo)
	player:RemoveClothes();
	player.cwBeingSearched = nil;
	player.cwSearching = nil;
	
	self:TiePlayer(player, false, true);
end;

-- Called when a player dies.
function Schema:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (self:PlayerIsCombine(player)) then
		local location = self:PlayerGetLocation(player);
		
		self:AddCombineDisplayLine("DownloadLostBiosignal", Color(255, 255, 255, 255), nil, player);
		self:AddCombineDisplayLine({"BiosignalLost", location}, Color(255, 0, 0, 255), nil, player);
		
		if (self.scanners[player]) then
			if (IsValid(self.scanners[player][1])) then
				if (damageInfo != true) then
					self.scanners[player][1]:TakeDamage(self.scanners[player][1]:Health() + 100);
				end;
			end;
		end;
		
		for k, v in ipairs(_player.GetAll()) do
			if (self:PlayerIsCombine(v)) then
				v:EmitSound("npc/overwatch/radiovoice/on1.wav");
				v:EmitSound("npc/overwatch/radiovoice/lostbiosignalforunit.wav");
			end;
		end;
		
		timer.Simple(1.5, function()
			for k, v in ipairs(_player.GetAll()) do
				if (self:PlayerIsCombine(v)) then
					v:EmitSound("npc/overwatch/radiovoice/off4.wav");
				end;
			end;
		end);
	end;
	
	if (!player:GetCharacterData("PermaKilled")) then
		if ((attacker:IsPlayer() or attacker:IsNPC()) and damageInfo) then
			local miscellaneousDamage = damageInfo:IsBulletDamage() or damageInfo:IsFallDamage() or damageInfo:IsExplosionDamage();
			local meleeDamage = damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
			
			if (miscellaneousDamage or meleeDamage) then
				if (Clockwork.kernel:GetSharedVar("PermaKillMode") == 1) then
					self:PermaKillPlayer(player, player:GetRagdollEntity());
				end;
			end;
		end;
	end;
end;

-- Called when a player's character has loaded.
function Schema:PlayerCharacterLoaded(player)
	player:SetSharedVar("PermaKilled", false);
	player:SetSharedVar("IsTied", 0);
end;

-- Called just after a player spawns.
function Schema:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		player:SetSharedVar("Antidepressants", 0);
		
		Clockwork.datastream:Start(player, "ClearEffects", true);
		
		player.cwBeingSearched = nil;
		player.cwSearching = nil;
	end;
	
	local faction = player:GetFaction();

	if (faction == FACTION_SCANNER) then
		self:MakePlayerScanner(player, true, lightSpawn);
	else
		self:ResetPlayerScanner(player);
	end;
	
	if (player:GetSharedVar("IsTied") != 0) then
		self:TiePlayer(player, true);
	end;
end;

-- Called when a player spawns lightly.
function Schema:PostPlayerLightSpawn(player, weapons, ammo, special)
	
end;

-- Called when a player throws a punch.
function Schema:PlayerPunchThrown(player)
	player:ProgressAttribute(ATB_STRENGTH, 0.25, true);
end;

-- Called when a player punches an entity.
function Schema:PlayerPunchEntity(player, entity)
	if (entity:IsPlayer() or entity:IsNPC()) then
		player:ProgressAttribute(ATB_STRENGTH, 1, true);
	else
		player:ProgressAttribute(ATB_STRENGTH, 0.5, true);
	end;
end;

-- Called when an entity has been breached.
function Schema:EntityBreached(entity, activator)
	if (Clockwork.entity:IsDoor(entity)) then
		if (!IsValid(entity.combineLock)) then
			if (!IsValid(activator) or string.lower(entity:GetClass()) != "prop_door_rotating") then
				Clockwork.entity:OpenDoor(entity, 0, true, true);
			else
				self:BustDownDoor(activator, entity);
			end;
		elseif (IsValid(activator) and activator:IsPlayer() and self:PlayerIsCombine(activator)) then
			if (string.lower(entity:GetClass()) == "prop_door_rotating") then
				entity.combineLock:ActivateSmokeCharge((entity:GetPos() - activator:GetPos()):GetNormal() * 10000);
			else
				entity.combineLock:SetFlashDuration(2);
			end;
		else
			entity.combineLock:SetFlashDuration(2);
		end;
	end;
end;

-- Called when a player takes damage.
function Schema:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	local curTime = CurTime();
	
	if (player:Armor() <= 0) then
		Clockwork.datastream:Start(player, "Stunned", 0.5);
	else
		Clockwork.datastream:Start(player, "Stunned", 1);
	end;
end;

-- Called when a player's limb damage is healed.
function Schema:PlayerLimbDamageHealed(player, hitGroup, amount)
	if (hitGroup == HITGROUP_HEAD) then
		player:BoostAttribute("Limb Damage", ATB_MEDICAL, false);
	elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_STOMACH) then
		player:BoostAttribute("Limb Damage", ATB_ENDURANCE, false);
	elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
		player:BoostAttribute("Limb Damage", ATB_ACROBATICS, false);
		player:BoostAttribute("Limb Damage", ATB_AGILITY, false);
	elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
		player:BoostAttribute("Limb Damage", ATB_DEXTERITY, false);
		player:BoostAttribute("Limb Damage", ATB_STRENGTH, false);
	end;
end;

-- Called when a player's limb damage is reset.
function Schema:PlayerLimbDamageReset(player)
	player:BoostAttribute("Limb Damage", nil, false);
end;

-- Called when a player's limb takes damage.
function Schema:PlayerLimbTakeDamage(player, hitGroup, damage)
	local limbDamage = Clockwork.limb:GetDamage(player, hitGroup);
	
	if (hitGroup == HITGROUP_HEAD) then
		player:BoostAttribute("Limb Damage", ATB_MEDICAL, -limbDamage);
	elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_STOMACH) then
		player:BoostAttribute("Limb Damage", ATB_ENDURANCE, -limbDamage);
	elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
		player:BoostAttribute("Limb Damage", ATB_ACROBATICS, -limbDamage);
		player:BoostAttribute("Limb Damage", ATB_AGILITY, -limbDamage);
	elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
		player:BoostAttribute("Limb Damage", ATB_DEXTERITY, -limbDamage);
		player:BoostAttribute("Limb Damage", ATB_STRENGTH, -limbDamage);
	end;
end;

-- A function to scale damage by hit group.
function Schema:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	local endurance = Clockwork.attributes:Fraction(player, ATB_ENDURANCE, 0.75, 0.75);
	local clothesItem = player:GetClothesItem();
	
	damageInfo:ScaleDamage(1.5 - endurance);
	
	if (damageInfo:IsBulletDamage()) then
		if (clothesItem and clothesItem.protection and damageInfo:IsBulletDamage()) then
			damageInfo:ScaleDamage(1 - clothesItem.protection);
		end;
	end;
end;

-- Called when an entity takes damage.
function Schema:EntityTakeDamage(entity, damageInfo)
	local player = Clockwork.entity:GetPlayer(entity);
	local attacker = damageInfo:GetAttacker();
	local inflictor = damageInfo:GetInflictor();
	local damage = damageInfo:GetDamage();
	local curTime = CurTime();
	local doDoorDamage = nil;
	
	if (player) then
		if (!player.nextEnduranceTime or CurTime() > player.nextEnduranceTime) then
			player:ProgressAttribute(ATB_ENDURANCE, math.Clamp(damageInfo:GetDamage(), 0, 75) / 10, true);
			player.nextEnduranceTime = CurTime() + 2;
		end;
		
		if (self.scanners[player]) then
			entity:EmitSound("npc/scanner/scanner_pain"..math.random(1, 2)..".wav");
			
			if (entity:Health() > 50 and entity:Health() - damageInfo:GetDamage() <= 50) then
				entity:EmitSound("npc/scanner/scanner_siren1.wav");
			elseif (entity:Health() > 25 and entity:Health() - damageInfo:GetDamage() <= 25) then
				entity:EmitSound("npc/scanner/scanner_siren2.wav");
			end;
		end;
		
		if (attacker:IsPlayer() and self:PlayerIsCombine(player)) then
			if (attacker != player) then
				local location = Schema:PlayerGetLocation(player);
				
				if (!player.nextUnderFire or curTime >= player.nextUnderFire) then
					player.nextUnderFire = curTime + 15;
					
					Schema:AddCombineDisplayLine("DownloadTraumaPacket", Color(255, 255, 255, 255), nil, player);
					Schema:AddCombineDisplayLine({"ProtectionTeamBodilyHarm", location}, Color(255, 0, 0, 255), nil, player);
				end;
			end;
		end;
	end;
	
	if (attacker:IsPlayer()) then
		local strength = Clockwork.attributes:Fraction(attacker, ATB_STRENGTH, 1, 0.5);
		local weapon = Clockwork.player:GetWeaponClass(attacker);
		
		if (damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH)) then
			damageInfo:ScaleDamage(1 + strength);
		end;
		
		if (weapon == "weapon_357") then
			damageInfo:ScaleDamage(0.25);
		elseif (weapon == "weapon_crossbow") then
			damageInfo:ScaleDamage(2);
		elseif (weapon == "weapon_shotgun") then
			damageInfo:ScaleDamage(3);
			
			doDoorDamage = true;
		elseif (weapon == "weapon_crowbar") then
			damageInfo:ScaleDamage(0.25);
		elseif (weapon == "cw_stunstick") then
			if (player) then
				if (player:Health() <= 10) then
					damageInfo:ScaleDamage(0.5);
				end;
			end;
		end;
		
		if (damageInfo:IsBulletDamage() and weapon != "weapon_shotgun") then
			if (!IsValid(entity.combineLock) and !IsValid(entity.breach)) then
				if (string.lower(entity:GetClass()) == "prop_door_rotating") then
					if (!Clockwork.entity:IsDoorFalse(entity)) then
						local damagePosition = damageInfo:GetDamagePosition();
						
						if (entity:WorldToLocal(damagePosition):Distance(Vector(-1.0313, 41.8047, -8.1611)) <= 8) then
							entity.doorHealth = math.min((entity.doorHealth or 50) - damageInfo:GetDamage(), 0);
							
							local effectData = EffectData();
							
							effectData:SetStart(damagePosition);
							effectData:SetOrigin(damagePosition);
							effectData:SetScale(8);
							
							util.Effect("GlassImpact", effectData, true, true);
							
							if (entity.doorHealth <= 0) then
								Clockwork.entity:OpenDoor(entity, 0, true, true, attacker:GetPos());
								
								entity.doorHealth = 50;
							else
								Clockwork.kernel:CreateTimer("reset_door_health_"..entity:EntIndex(), 60, 1, function()
									if (IsValid(entity)) then
										entity.doorHealth = 50;
									end;
								end);
							end;
						end;
					end;
				end;
			end;
		end;
		
		if (damageInfo:IsExplosionDamage()) then
			damageInfo:ScaleDamage(2);
		end;
	elseif (attacker:IsNPC()) then
		damageInfo:ScaleDamage(0.5);
	end;
	
	if (damageInfo:IsExplosionDamage() or doDoorDamage) then
		if (!IsValid(entity.combineLock) and !IsValid(entity.breach)) then
			if (string.lower(entity:GetClass()) == "prop_door_rotating") then
				if (!Clockwork.entity:IsDoorFalse(entity)) then
					if (attacker:GetPos():Distance(entity:GetPos()) <= 96) then
						entity.doorHealth = math.min((entity.doorHealth or 50) - damageInfo:GetDamage(), 0);
						
						local damagePosition = damageInfo:GetDamagePosition();
						local effectData = EffectData();
						
						effectData:SetStart(damagePosition);
						effectData:SetOrigin(damagePosition);
						effectData:SetScale(8);
						
						util.Effect("GlassImpact", effectData, true, true);
						
						if (entity.doorHealth <= 0) then
							self:BustDownDoor(attacker, entity);
							
							entity.doorHealth = 50;
						else
							Clockwork.kernel:CreateTimer("reset_door_health_"..entity:EntIndex(), 60, 1, function()
								if (IsValid(entity)) then
									entity.doorHealth = 50;
								end;
							end);
						end;
					end;
				end;
			end;
		end;
	end;
end;
