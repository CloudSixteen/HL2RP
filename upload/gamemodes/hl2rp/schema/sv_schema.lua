--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Schema.scannerSounds = {
	"npc/scanner/cbot_servochatter.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/scanner_blip1.wav",
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav"
};
Schema.scanners = {};
Schema.cwuProps = {
	"models/props_c17/furniturewashingmachine001a.mdl",
	"models/props_interiors/furniture_vanity01a.mdl",
	"models/props_interiors/furniture_couch02a.mdl",
	"models/props_interiors/furniture_shelf01a.mdl",
	"models/props_interiors/furniture_chair01a.mdl",
	"models/props_interiors/furniture_desk01a.mdl",
	"models/props_interiors/furniture_lamp01a.mdl",
	"models/props_c17/furniturecupboard001a.mdl",
	"models/props_c17/furnituredresser001a.mdl",
	"props/props_c17/furniturefridge001a.mdl",
	"models/props_c17/furniturestove001a.mdl",
	"models/props_interiors/radiator01a.mdl",
	"props/props_c17/furniturecouch001a.mdl",
	"models/props_combine/breenclock.mdl",
	"props/props_combine/breenchair.mdl",
	"models/props_c17/shelfunit01a.mdl",
	"props/props_combine/breendesk.mdl",
	"models/props_lab/monitor01b.mdl",
	"models/props_lab/monitor01a.mdl",
	"models/props_lab/monitor02.mdl",
	"models/props_c17/frame002a.mdl",
	"models/props_c17/bench01a.mdl"
};

Clockwork.kernel:AddFile("resource/fonts/vacersansregularpersonal.ttf");
Clockwork.kernel:AddFile("resource/fonts/mailartrubberstamp.ttf");
Clockwork.kernel:AddFile("resource/fonts/goldenageregular.ttf");
Clockwork.kernel:AddFile("resource/fonts/monofonto.ttf");

Clockwork.kernel:AddDirectory("materials/models/humans/female/group01/cityadm_sheet.*");
Clockwork.kernel:AddDirectory("materials/models/humans/male/group01/cityadm_sheet.*");
Clockwork.kernel:AddDirectory("models/humans/group17/*.mdl");
Clockwork.kernel:AddDirectory("models/police/*.mdl");
Clockwork.kernel:AddDirectory("materials/models/humans/female/group01/cityadm_sheet.*");
Clockwork.kernel:AddDirectory("materials/models/deadbodies/");
Clockwork.kernel:AddDirectory("materials/models/spraycan3.*");
Clockwork.kernel:AddDirectory("materials/models/police/*.*");
Clockwork.kernel:AddDirectory("materials/models/lagmite/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/themes/grunge/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/themes/plain/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/icons/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/factions/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/infotext/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/menuitems/");
Clockwork.kernel:AddDirectory("materials/hl2rp2/");
Clockwork.kernel:AddDirectory("models/lagmite/");
Clockwork.kernel:AddDirectory("models/deadbodies/");

Clockwork.config:Add("server_whitelist_identity", "");
Clockwork.config:Add("combine_lock_overrides", false);
Clockwork.config:Add("intro_text_small", "It is safer here.", true);
Clockwork.config:Add("intro_text_big", "CITY EIGHTEEN, 2016.", true);
Clockwork.config:Add("knockout_time", 60);
Clockwork.config:Add("business_cost", 160, true);
Clockwork.config:Add("cwu_props", true);
Clockwork.config:Add("permits", true, true);
Clockwork.config:Add("dull_vision", true, true);

Clockwork.config:Get("enable_gravgun_punt"):Set(false);
Clockwork.config:Get("default_inv_weight"):Set(6);
Clockwork.config:Get("enable_crosshair"):Set(false);
Clockwork.config:Get("disable_sprays"):Set(false);
Clockwork.config:Get("prop_cost"):Set(false);
Clockwork.config:Get("door_cost"):Set(0);

-- A function to add a human hint.
function Clockwork.hint:AddHumanHint(name, text, combine)
	Clockwork.hint:Add(name, text, function(player)
		if (player) then
			return !Schema:PlayerIsCombine(player, combine);
		end;
	end);
end;

Clockwork.hint:AddHumanHint("HintLife", "HintLifeDesc", false);
Clockwork.hint:AddHumanHint("HintSleep", "HintSleepDesc", false);
Clockwork.hint:AddHumanHint("HintEating", "HintEatingDesc", false);
Clockwork.hint:AddHumanHint("HintFriends", "HintFriendsDesc", false);

Clockwork.hint:AddHumanHint("HintCurfew", "HintCurfewDesc");
Clockwork.hint:AddHumanHint("HintPrison", "HintPrisonDesc");
Clockwork.hint:AddHumanHint("HintRebels", "HintRebelsDesc");
Clockwork.hint:AddHumanHint("HintTalking", "HintTalkingDesc");
Clockwork.hint:AddHumanHint("HintRations", "HintRationsDesc");
Clockwork.hint:AddHumanHint("HintCombine", "HintCombineDesc");
Clockwork.hint:AddHumanHint("HintJumping", "HintJumpingDesc");
Clockwork.hint:AddHumanHint("HintPunching", "HintPunchingDesc");
Clockwork.hint:AddHumanHint("HintCompliance", "HintComplianceDesc");
Clockwork.hint:AddHumanHint("HintCombineRaids", "HintCombineRaidsDesc");
Clockwork.hint:AddHumanHint("HintRequestDevice", "HintRequestDeviceDesc");
Clockwork.hint:AddHumanHint("HintCivilProtection", "HintCivilProtectionDesc");

Clockwork.hint:Add("HintAdmins", "HintAdminsDesc");
Clockwork.hint:Add("HintAction", "HintActionDesc");
Clockwork.hint:Add("HintGrammar", "HintGrammarDesc");
Clockwork.hint:Add("HintRunning", "HintRunningDesc");
Clockwork.hint:Add("HintHealing", "HintHealingDesc");
Clockwork.hint:Add("HintF3Hotkey", "HintF3HotkeyDesc");
Clockwork.hint:Add("HintF4Hotkey", "HintF4HotkeyDesc");
Clockwork.hint:Add("HintAttributes", "HintAttributesDesc");
Clockwork.hint:Add("HintFirefights", "HintFirefightsDesc");
Clockwork.hint:Add("HintMetagaming", "HintMetagamingDesc");
Clockwork.hint:Add("HintPassiveRP", "HintPassiveRPDesc");
Clockwork.hint:Add("HintDevelopment", "HintDevelopmentDesc");
Clockwork.hint:Add("HintPowergaming", "HintPowergamingDesc");

Clockwork.datastream:Hook("EditObjectives", function(player, data)
	if (player.editObjectivesAuthorised and type(data) == "string") then
		if (Schema.combineObjectives != data) then
			Schema:AddCombineDisplayLine("DownloadRecentObjectives", Color(255, 100, 255, 255));
			Schema.combineObjectives = string.sub(data, 0, 500);
			
			Clockwork.kernel:SaveSchemaData("objectives", {
				text = Schema.combineObjectives
			});
		end;
		
		player.editObjectivesAuthorised = nil;
	end;
end);

Clockwork.datastream:Hook("ObjectPhysDesc", function(player, data)
	if (type(data) == "table" and type(data[1]) == "string") then
		if (player.objectPhysDesc == data[2]) then
			local physDesc = data[1];
			
			if (string.len(physDesc) > 80) then
				physDesc = string.sub(physDesc, 1, 80).."...";
			end;
			
			data[2]:SetNetworkedString("physDesc", physDesc);
		end;
	end;
end);

Clockwork.datastream:Hook("EditData", function(player, data)
	if (player.editDataAuthorised == data[1] and type(data[2]) == "string") then
		data[1]:SetCharacterData("CombineData", string.sub(data[2], 0, 500));
		
		player.editDataAuthorised = nil;
	end;
end);

-- A function to calculate a player's scanner think.
function Schema:CalculateScannerThink(player, curTime)
	if (!self.scanners[player]) then return; end;
	
	local scanner = self.scanners[player][1];
	local marker = self.scanners[player][2];
	
	if (IsValid(scanner) and IsValid(marker)) then
		scanner:SetMaxHealth(player:GetMaxHealth());
		
		player:SetMoveType(MOVETYPE_OBSERVER);
		player:SetHealth(math.max(scanner:Health(), 0));
		
		if (!player.nextScannerSound or curTime >= player.nextScannerSound) then
			player.nextScannerSound = curTime + math.random(8, 48);
			
			scanner:EmitSound(self.scannerSounds[ math.random(1, #self.scannerSounds) ]);
		end;
	end;
end;

-- A function to reset a player's scanner.
function Schema:ResetPlayerScanner(player, noMessage)
	if (self.scanners[player]) then
		local scanner = self.scanners[player][1];
		local marker = self.scanners[player][2];
		
		if (IsValid(scanner)) then
			scanner:Remove();
		end;
		
		if (IsValid(marker)) then
			marker:Remove();
		end;
		
		self.scanners[player] = nil;
		
		if (!noMessage) then
			player:SetMoveType(MOVETYPE_WALK);
			player:UnSpectate();
			player:KillSilent();
		end;
	end;
end;

-- A function to make a player a scanner.
function Schema:MakePlayerScanner(player, noMessage, lightSpawn)
	self:ResetPlayerScanner(player, noMessage);
	
	local scannerClass = "npc_cscanner";
	local rankName, rankTable = player:GetFactionRank();

	if (rankName == "SYNTH") then
		scannerClass = "npc_clawscanner";
	end;
	
	local position = player:GetShootPos();
	local uniqueID = player:UniqueID();
	local scanner = ents.Create(scannerClass);
	local marker = ents.Create("path_corner");
	
	Clockwork.entity:SetPlayer(scanner, player);
	
	scanner:SetPos(position + Vector(0, 0, 16));
	scanner:SetAngles(player:GetAimVector():Angle());
	scanner:SetKeyValue("targetname", "scanner_"..uniqueID);
	scanner:SetKeyValue("spawnflags", 8592);
	scanner:SetKeyValue("renderfx", 0);
	scanner:Spawn(); scanner:Activate();
	
	marker:SetKeyValue("targetname", "marker_"..uniqueID);
	marker:SetPos(position);
	marker:Spawn(); marker:Activate();
	
	if (!lightSpawn) then
		player:Flashlight(false);
		player:RunCommand("-duck");
		
		if (scannerClass == "npc_clawscanner") then
			player:SetHealth(200);
		end;
	end;
	
	player:SetArmor(0);
	player:Spectate(OBS_MODE_CHASE);
	player:StripWeapons();
	player:SetSharedVar("Scanner", scanner:EntIndex());
	player:SetMoveType(MOVETYPE_OBSERVER);
	player:SpectateEntity(scanner);
	
	scanner:SetMaxHealth(player:GetMaxHealth());
	scanner:SetHealth(player:Health());
	scanner:Fire("SetDistanceOverride", 64, 0);
	scanner:Fire("SetFollowTarget", "marker_"..uniqueID, 0);
	
	self.scanners[player] = {scanner, marker};
	
	Clockwork.kernel:CreateTimer("scanner_sound_"..uniqueID, 0.01, 1, function()
		if (IsValid(scanner)) then
			scanner.flyLoop = CreateSound(scanner, "npc/scanner/cbot_fly_loop.wav");
			scanner.flyLoop:Play();
		end;
	end);
	
	scanner:CallOnRemove("Scanner Sound", function(scanner)
		if (scanner.flyLoop) then
			scanner.flyLoop:Stop();
		end;
	end);
end;

-- A function to add a Combine display line.
function Schema:AddCombineDisplayLine(text, color, player, exclude)
	if (player) then
		Clockwork.datastream:Start(player, "CombineDisplayLine", {text, color});
	else
		local players = {};
		
		for k, v in ipairs(_player.GetAll()) do
			if (self:PlayerIsCombine(v) and v != exclude) then
				players[#players + 1] = v;
			end;
		end;
		
		Clockwork.datastream:Start(players, "CombineDisplayLine", {text, color});
	end;
end;

-- A function to load the objectives.
function Schema:LoadObjectives()
	local combineObjectives = Clockwork.kernel:RestoreSchemaData("objectives");
	
	if (combineObjectives and combineObjectives.text) then
		self.combineObjectives = combineObjectives.text;
	else
		self.combineObjectives = "";
	end;
end;

-- A function to load the NPCs.
function Schema:LoadNPCs()
	local npcs = Clockwork.kernel:RestoreSchemaData("plugins/npcs/"..game.GetMap());
	
	for k, v in pairs(npcs) do
		local entity = ents.Create(v.class);
		
		if (IsValid(entity)) then
			entity:SetKeyValue("spawnflags", v.spawnFlags or 0);
			entity:SetKeyValue("additionalequipment", v.equipment or "");
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if (IsValid(entity)) then
				entity:Activate();
				
				entity:SetNetworkedString("cw_Name", v.name);
				entity:SetNetworkedString("cw_Title", v.title);
			end;
		end;
	end;
end;

-- A function to save the NPCs.
function Schema:SaveNPCs()
	local npcs = {};
	
	for k, v in pairs(ents.FindByClass("npc_*")) do
		local name = v:GetNetworkedString("cw_Name");
		local title = v:GetNetworkedString("cw_Title");
		
		if (name != "" and title != "") then
			local keyValues = table.LowerKeyNames(v:GetKeyValues());
			
			npcs[#npcs + 1] = {
				spawnFlags = keyValues["spawnflags"],
				equipment = keyValues["additionequipment"],
				position = v:GetPos(),
				angles = v:GetAngles(),
				model = v:GetModel(),
				title = title,
				class = v:GetClass(),
				name = name
			};
		end;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/npcs/"..game.GetMap(), npcs);
end;

-- A function to load the Combine locks.
function Schema:LoadCombineLocks()
	local combineLocks = Clockwork.kernel:RestoreSchemaData("plugins/locks/"..game.GetMap());
	
	for k, v in pairs(combineLocks) do
		local entity = ents.GetMapCreatedEntity(v.mapCreationID);
		
		if (IsValid(entity)) then
			local combineLock = self:ApplyCombineLock(entity);
			
			if (combineLock) then
				Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
				
				combineLock:SetLocalAngles(v.angles);
				combineLock:SetLocalPos(v.position);
				
				if (!v.locked) then
					combineLock:Unlock();
				else
					combineLock:Lock();
				end;
			end;
		end;
	end;
end;

-- A function to save the Combine locks.
function Schema:SaveCombineLocks()
	local combineLocks = {};
	
	for k, v in pairs(ents.FindByClass("cw_combinelock")) do
		if (IsValid(v.entity)) then
			combineLocks[#combineLocks + 1] = {
				key = Clockwork.entity:QueryProperty(v, "key"),
				locked = v:IsLocked(),
				angles = v:GetLocalAngles(),
				position = v:GetLocalPos(),
				uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
				mapCreationID = v.entity:MapCreationID()
			};
		end;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/locks/"..game.GetMap(), combineLocks);
end;

-- A function to load the radios.
function Schema:LoadRadios()
	local radios = Clockwork.kernel:RestoreSchemaData("plugins/radios/"..game.GetMap());
	
	for k, v in pairs(radios) do
		local entity = ents.Create("cw_radio");
		
		Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetFrequency(v.frequency);
			entity:SetOff(v.off);
		end;
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to load the ration dispensers.
function Schema:LoadRationDispensers()
	local dispensers = Clockwork.kernel:RestoreSchemaData("plugins/dispensers/"..game.GetMap());
	
	for k, v in pairs(dispensers) do
		local entity = ents.Create("cw_rationdispenser");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetAngles(v.angles);
			
			if (!v.locked) then
				entity:Unlock();
			else
				entity:Lock();
			end;
		end;
	end;
end;

-- A function to save the ration dispensers.
function Schema:SaveRationDispensers()
	local dispensers = {};
	
	for k, v in pairs(ents.FindByClass("cw_rationdispenser")) do
		dispensers[#dispensers + 1] = {
			locked = v:IsLocked(),
			angles = v:GetAngles(),
			position = v:GetPos()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/dispensers/"..game.GetMap(), dispensers);
end;

-- A function to load the ration machines.
function Schema:LoadVendingMachines()
	local machines = Clockwork.kernel:RestoreSchemaData("plugins/machines/"..game.GetMap());
	
	for k, v in pairs(machines) do
		local entity = ents.Create("cw_vendingmachine");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetAngles(v.angles);
			entity:SetStock(v.stock, v.defaultStock);
		end;
	end;
end;

-- A function to save the ration machines.
function Schema:SaveVendingMachines()
	local machines = {};
	
	for k, v in pairs(ents.FindByClass("cw_vendingmachine")) do
		machines[#machines + 1] = {
			stock = v:GetStock(),
			angles = v:GetAngles(),
			position = v:GetPos(),
			defaultStock = v:GetDefaultStock()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/machines/"..game.GetMap(), machines);
end;

-- A function to save the radios.
function Schema:SaveRadios()
	local radios = {};
	
	for k, v in pairs(ents.FindByClass("cw_radio")) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physicsObject)) then
			moveable = physicsObject:IsMoveable();
		end;
		
		radios[#radios + 1] = {
			off = v:IsOff(),
			key = Clockwork.entity:QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			frequency = v:GetFrequency()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/radios/"..game.GetMap(), radios);
end;

-- A function to say a message as a request.
function Schema:SayRequest(player, text)
	local isCitizen = (player:GetFaction() == FACTION_CITIZEN);
	local listeners = { request = {}, eavesdrop = {} };
	
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (v:GetFaction() == FACTION_CITIZEN and isCitizen and player != v) then
				if (v:GetShootPos():Distance(player:GetShootPos()) <= Clockwork.config:Get("talk_radius"):Get()) then
					listeners.eavesdrop[v] = v;
				end;
			else
				local isCityAdmin = (v:GetFaction() == FACTION_ADMIN);
				local isCombine = self:PlayerIsCombine(v);
				
				if (v:HasItemByID("request_device") or isCombine or isCityAdmin) then
					listeners.request[v] = v;
				end;
			end;
		end;
	end;

	self:AddCombineDisplayLine("DownloadRequestPacket");
	
	local info = Clockwork.chatBox:Add(listeners.request, player, "request", text);
	
	if (info and IsValid(info.speaker)) then
		Clockwork.chatBox:Add(listeners.eavesdrop, info.speaker, "request_eavesdrop", info.text);
	end;
end;

-- A function to get a player's location.
function Schema:PlayerGetLocation(player)
	local closest;
	
	if (cwAreaDisplays) then
		for k, v in pairs(cwAreaDisplays.areaNames) do
			if (Clockwork.entity:IsInBox(player, v.minimum, v.maximum)) then
				if (string.sub(string.lower(v.name), 1, 4) == "the ") then
					return string.sub(v.name, 5);
				else
					return v.name;
				end;
			else
				local distance = player:GetShootPos():Distance(v.minimum);
				
				if (!closest or distance < closest[1]) then
					closest = {distance, v.name};
				end;
			end;
		end;
		
		if (!completed) then
			if (closest) then
				if (string.sub(string.lower(closest[2]), 1, 4) == "the ") then
					return string.sub(closest[2], 5);
				else
					return closest[2];
				end;
			end;
		end;
	end;
	
	return "unknown location";
end;

-- A function to say a message as a broadcast.
function Schema:SayBroadcast(player, text)
	Clockwork.chatBox:Add(nil, player, "broadcast", text);
end;

-- A function to say a message as a dispatch.
function Schema:SayDispatch(player, text)
	Clockwork.chatBox:Add(nil, player, "dispatch", text);
end;

-- A function to check if a player is Combine.
function Schema:PlayerIsCombine(player, bHuman)
	if (IsValid(player) and player:GetCharacter()) then
		local faction = player:GetFaction();
		
		if (self:IsCombineFaction(faction)) then
			if (bHuman) then
				if (faction == FACTION_MPF) then
					return true;
				end;
			elseif (bHuman == false) then
				if (faction == FACTION_MPF) then
					return false;
				else
					return true;
				end;
			else
				return true;
			end;
		end;
	end;
end;

-- A function to apply a Combine lock.
function Schema:ApplyCombineLock(entity, position, angles)
	local combineLock = ents.Create("cw_combinelock");
	
	combineLock:SetParent(entity);
	combineLock:SetDoor(entity);
	
	if (position) then
		if (type(position) == "table") then
			combineLock:SetLocalPos(Vector(-1.0313, 43.7188, -1.2258));
			combineLock:SetPos(combineLock:GetPos() + (position.HitNormal * 4));
		else
			combineLock:SetPos(position);
		end;
	end;
	
	if (angles) then
		combineLock:SetAngles(angles);
	end;
	
	combineLock:Spawn();
	
	if (IsValid(combineLock)) then
		return combineLock;
	end;
end;

-- A function to get a player's heal amount.
function Schema:GetHealAmount(player, scale)
	local medical = Clockwork.attributes:Fraction(player, ATB_MEDICAL, 35);
	local healAmount = (15 + medical) * (scale or 1);
	
	return healAmount;
end;

-- A function to get a player's dexterity time.
function Schema:GetDexterityTime(player)
	return 7 - Clockwork.attributes:Fraction(player, ATB_DEXTERITY, 5, 5);
end;

-- A function to bust down a door.
function Schema:BustDownDoor(player, door, force)
	door.bustedDown = true;
	
	door:SetNotSolid(true);
	door:DrawShadow(false);
	door:SetNoDraw(true);
	door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
	door:Fire("Unlock", "", 0);
	
	if (IsValid(door.combineLock)) then
		door.combineLock:Explode();
		door.combineLock:Remove();
	end;
	
	if (IsValid(door.breach)) then
		door.breach:BreachEntity();
	end;
	
	local fakeDoor = ents.Create("prop_physics");
	
	fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD);
	fakeDoor:SetAngles(door:GetAngles());
	fakeDoor:SetModel(door:GetModel());
	fakeDoor:SetSkin(door:GetSkin());
	fakeDoor:SetPos(door:GetPos());
	fakeDoor:Spawn();
	
	local physicsObject = fakeDoor:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		if (!force) then
			if (IsValid(player)) then
				physicsObject:ApplyForceCenter((door:GetPos() - player:GetPos()):GetNormal() * 10000);
			end;
		else
			physicsObject:ApplyForceCenter(force);
		end;
	end;
	
	Clockwork.entity:Decay(fakeDoor, 300);
	
	Clockwork.kernel:CreateTimer("reset_door_"..door:EntIndex(), 300, 1, function()
		if (IsValid(door)) then
			door.bustedDown = nil;
			door:SetNotSolid(false);
			door:DrawShadow(true);
			door:SetNoDraw(false);
		end;
	end);
end;

-- A function to permanently kill a player.
function Schema:PermaKillPlayer(player, ragdoll)
	if (player:Alive()) then
		player:Kill(); ragdoll = player:GetRagdollEntity();
	end;
	
	local inventory = player:GetInventory();
	local cash = player:GetCash();
	local info = {};
	
	if (!player:GetCharacterData("PermaKilled")) then
		info.inventory = inventory;
		info.cash = cash;
		
		if (!IsValid(ragdoll)) then
			info.entity = ents.Create("cw_belongings");
		end;
		
		Clockwork.plugin:Call("PlayerAdjustPermaKillInfo", player, info);
		
		for k, v in pairs(info.inventory) do
			local itemTable = Clockwork.item:FindByID(k);
			
			if (itemTable and itemTable.allowStorage == false) then
				info.inventory[k] = nil;
			end;
		end;
		
		player:SetCharacterData("PermaKilled", true);
		player:SetCharacterData("inventory", {}, true);
		player:SetCharacterData("cash", 0, true);
		
		player:SetSharedVar("PermaKilled", true);
		
		if (!IsValid(ragdoll)) then
			if (table.Count(info.inventory) > 0 or info.cash > 0) then
				info.entity:SetData(info.inventory, info.cash);
				info.entity:SetPos(player:GetPos() + Vector(0, 0, 48));
				info.entity:Spawn();
			else
				info.entity:Remove();
			end;
		else
			ragdoll.areBelongings = true;
			ragdoll.inventory = info.inventory;
			ragdoll.cash = info.cash;
		end;
		
		Clockwork.player:SaveCharacter(player);
	end;
end;

-- A function to tie or untie a player.
function Schema:TiePlayer(player, isTied, reset, combine)
	if (isTied) then
		if (combine) then
			player:SetSharedVar("IsTied", 2);
		else
			player:SetSharedVar("IsTied", 1);
		end;
	else
		player:SetSharedVar("IsTied", 0);
	end;
	
	if (isTied) then
		Clockwork.player:DropWeapons(player);
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has been tied.");
		
		player:Flashlight(false);
		player:StripWeapons();
	elseif (!reset) then
		if (player:Alive() and !player:IsRagdolled()) then 
			Clockwork.player:LightSpawn(player, true, true);
		end;
		
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has been untied.");
	end;
end;
