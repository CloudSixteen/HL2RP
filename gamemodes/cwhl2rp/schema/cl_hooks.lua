--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when the local player's business is rebuilt.
function Schema:PlayerBusinessRebuilt(panel, categories)
	if (!self.businessPanel) then
		self.businessPanel = panel;
	end;
	
	if (Clockwork.config:Get("permits"):Get() and Clockwork.Client:GetFaction() == FACTION_CITIZEN) then
		local permits = {};
		
		for k, v in pairs(Clockwork.item:GetAll()) do
			if (v("cost") and v("access") and !Clockwork.kernel:HasObjectAccess(Clockwork.Client, v)) then
				if (string.find(v("access"), "1")) then
					permits.generalGoods = (permits.generalGoods or 0) + (v.cost * v.batch);
				else
					for k2, v2 in pairs(Schema.customPermits) do
						if (string.find(v("access"), v2.flag)) then
							permits[v2.key] = (permits[v2.key] or 0) + (v.cost * v.batch);
							
							break;
						end;
					end;
				end;
			end;
		end;
		
		if (table.Count(permits) > 0) then
			local panelList = vgui.Create("DPanelList", panel);
			
			panel.permitsForm = vgui.Create("cwBasicForm");
			panel.permitsForm:SetText(L("PermitsTitle"));
			panel.permitsForm:SetPadding(8);
			panel.permitsForm:SetAutoSize(true);
			
			panelList:SetAutoSize(true);
			panelList:SetPadding(4);
			panelList:SetSpacing(4);
			
			if (Clockwork.player:HasFlags(Clockwork.Client, "x")) then
				for k, v in pairs(permits) do
					panel.customData = {information = v};
					
					if (k == "generalGoods") then
						panel.customData.description = L("PurchasePermitGeneralGoodsHelp");
						panel.customData.Callback = function()
							Clockwork.kernel:RunCommand("PermitBuy", "generalgoods");
						end;
						panel.customData.model = "models/props_junk/cardboard_box004a.mdl";
						panel.customData.name = "General Goods";
					else
						for k2, v2 in pairs(Schema.customPermits) do
							if (v2.key == k) then
								panel.customData.description = L("PurchasePermitCustomHelp", string.utf8lower(v2.name));
								panel.customData.Callback = function()
									Clockwork.kernel:RunCommand("PermitBuy", k2);
								end;
								panel.customData.model = v2.model;
								panel.customData.name = v2.name;
								
								break;
							end;
						end;
					end;
					
					panelList:AddItem(vgui.Create("cwBusinessCustom", panel));
				end;
			else
				panel.customData = {
					description = L("BusinessCreateHelpText"),
					information = Clockwork.config:Get("business_cost"):Get(),
					Callback = function()
						Clockwork.kernel:RunCommand("PermitBuy", "business");
					end,
					model = "models/props_c17/briefcase001a.mdl",
					name = L("CreateBusiness")
				};
				
				panelList:AddItem(vgui.Create("cwBusinessCustom", panel));
			end;
			
			panel.permitsForm:AddItem(panelList);
			panel.panelList:AddItem(panel.permitsForm);
		end;
	end;
end;

-- Called when the target player's fade distance is needed.
function Schema:GetTargetPlayerFadeDistance(player)
	if (IsValid(self:GetScannerEntity(Clockwork.Client))) then
		return 512;
	end;
end;

-- Called when an entity's menu options are needed.
function Schema:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "prop_ragdoll") then
		local player = Clockwork.entity:GetPlayer(entity);
		
		if (!player or !player:Alive()) then
			options["Loot"] = "cw_corpseLoot";
		end;
	elseif (entity:GetClass() == "cw_belongings") then
		options["Open"] = "cw_belongingsOpen";
	elseif (entity:GetClass() == "cw_breach") then
		options["Charge"] = "cw_breachCharge";
	elseif (entity:GetClass() == "cw_radio") then
		if (!entity:IsOff()) then
			options["TurnOff"] = "cw_radioToggle";
		else
			options["TurnOn"] = "cw_radioToggle";
		end;
		
		options["SetFrequency"] = function()
			Derma_StringRequest(L("SetFrequencyTitle"), L("SetFrequencyHelp"), frequency, function(text)
				if (IsValid(entity)) then
					Clockwork.entity:ForceMenuOption(entity, "SetFrequency", text);
				end;
			end);
		end;
		
		options["Take"] = "cw_radioTake";
	end;
end;

-- Called when a player's typing display position is needed.
function Schema:GetPlayerTypingDisplayPosition(player)
	local scannerEntity = self:GetScannerEntity(player);
	
	if (IsValid(scannerEntity)) then
		local position = nil;
		local physBone = scannerEntity:LookupBone("Scanner.Body");
		local curTime = CurTime();
		
		if (physBone) then
			position = scannerEntity:GetBonePosition(physBone);
		end;
		
		if (!position) then
			return scannerEntity:GetPos() + Vector(0, 0, 8);
		else
			return position;
		end;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function Schema:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (entity:GetClass() == "prop_physics") then
		local physDesc = entity:GetNetworkedString("physDesc");
		
		if (physDesc != "") then
			info.y = Clockwork.kernel:DrawInfo(physDesc, info.x, info.y, colorWhite, info.alpha);
		end;
	elseif (entity:IsNPC()) then
		local name = entity:GetNetworkedString("cw_Name");
		local title = entity:GetNetworkedString("cw_Title");
		
		if (name != "" and title != "") then
			info.y = Clockwork.kernel:DrawInfo(name, info.x, info.y, Color(255, 255, 100, 255), info.alpha);
			info.y = Clockwork.kernel:DrawInfo(title, info.x, info.y, Color(255, 255, 255, 255), info.alpha);
		end;
	end;
end;

-- Called when a text entry has gotten focus.
function Schema:OnTextEntryGetFocus(panel)
	self.textEntryFocused = panel;
end;

-- Called when a text entry has lost focus.
function Schema:OnTextEntryLoseFocus(panel)
	self.textEntryFocused = nil;
end;

-- Called when screen space effects should be rendered.
function Schema:RenderScreenspaceEffects()
	if (!Clockwork.kernel:IsScreenFadedBlack()) then
		local curTime = CurTime();
		
		if (self.flashEffect) then
			local timeLeft = math.Clamp(self.flashEffect[1] - curTime, 0, self.flashEffect[2]);
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				modify = {};
				
				modify["$pp_colour_brightness"] = 0;
				modify["$pp_colour_contrast"] = 1 + (timeLeft * incrementer);
				modify["$pp_colour_colour"] = 1 - (incrementer * timeLeft);
				modify["$pp_colour_addr"] = incrementer * timeLeft;
				modify["$pp_colour_addg"] = 0;
				modify["$pp_colour_addb"] = 0;
				modify["$pp_colour_mulr"] = 1;
				modify["$pp_colour_mulg"] = 0;
				modify["$pp_colour_mulb"] = 0;
				
				DrawColorModify(modify);
				
				if (!self.flashEffect[3]) then
					DrawMotionBlur(1 - (incrementer * timeLeft), incrementer * timeLeft, self.flashEffect[2]);
				end;
			end;
		end;
		
		if (self:PlayerIsCombine(Clockwork.Client)) then
			render.UpdateScreenEffectTexture();
			
			self.combineOverlay:SetFloat("$refractamount", 0.3);
			self.combineOverlay:SetFloat("$envmaptint", 0);
			self.combineOverlay:SetFloat("$envmap", 0);
			self.combineOverlay:SetFloat("$alpha", 0.5);
			self.combineOverlay:SetInt("$ignorez", 1);
			
			render.SetMaterial(self.combineOverlay);
			render.DrawScreenQuad();
		end;
	end;
end;

-- Called when the local player's motion blurs should be adjusted.
function Schema:PlayerAdjustMotionBlurs(motionBlurs)
	if (!Clockwork.kernel:IsScreenFadedBlack()) then
		local curTime = CurTime();
		
		if (self.flashEffect and self.flashEffect[3]) then
			local timeLeft = math.Clamp(self.flashEffect[1] - curTime, 0, self.flashEffect[2]);
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				motionBlurs.blurTable["flash"] = 1 - (incrementer * timeLeft);
			end;
		end;
	end;
end;

-- Called when the cinematic intro info is needed.
function Schema:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self:GetAuthor()..".",
		title = Clockwork.config:Get("intro_text_big"):Get(),
		text = Clockwork.config:Get("intro_text_small"):Get()
	};
end;

-- Called when the scoreboard's class players should be sorted.
function Schema:ScoreboardSortClassPlayers(class, a, b)
	local rankNameA, rankA = Clockwork.player:GetFactionRank(a);
	local rankNameB, rankB = Clockwork.player:GetFactionRank(b);
	local positionA = rankA and rankA.position;
	local positionB = rankB and rankB.position;
	
	if (positionA and positionB) then
		return positionA < positionB;
	elseif (positionB and !positionA) then
		return false
	else
		return a:Name() < b:Name();
	end;
end;

-- Called when a player's scoreboard class is needed.
function Schema:GetPlayerScoreboardClass(player)
	local customClass = player:GetSharedVar("CustomClass");
	local faction = player:GetFaction();
	
	if (customClass != "") then
		return customClass;
	end;
	
	if (faction == FACTION_MPF) then
		return "Civil Protection";
	elseif (faction == FACTION_OTA) then
		return "Overwatch Transhuman Arm";
	end;
end;

-- Called when the local player's character screen faction is needed.
function Schema:GetPlayerCharacterScreenFaction(character)
	if (character.customClass and character.customClass != "") then
		return character.customClass;
	end;
end;

-- Called when the local player attempts to zoom.
function Schema:PlayerCanZoom()
	if (!self:PlayerIsCombine(Clockwork.Client)) then
		return false;
	end;
end;

-- Called when a player's scoreboard options are needed.
function Schema:GetPlayerScoreboardOptions(player, options, menu)
	if (Clockwork.command:FindByID("PlyAddServerWhitelist")
	or Clockwork.command:FindByID("PlyRemoveServerWhitelist")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("PlyAddServerWhitelist").access)) then
			options["OptionServerWhitelist"] = {};
			
			if (Clockwork.command:FindByID("PlyAddServerWhitelist")) then
				options["OptionServerWhitelist"]["OptionServerWhitelistAdd"] = function()
					Derma_StringRequest(player:Name(), L("OptionServerWhitelistAddHelp"), "", function(text)
						Clockwork.kernel:RunCommand("PlyAddServerWhitelist", player:Name(), text);
					end);
				end;
			end;
			
			if (Clockwork.command:FindByID("PlyRemoveServerWhitelist")) then
				options["OptionServerWhitelist"]["OptionServerWhitelistRemove"] = function()
					Derma_StringRequest(player:Name(), L("OptionServerWhitelistRemoveHelp"), "", function(text)
						Clockwork.kernel:RunCommand("PlyRemoveServerWhitelist", player:Name(), text);
					end);
				end;
			end;
		end;
	end;
	
	if (Clockwork.command:FindByID("CharSetCustomClass")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("CharSetCustomClass").access)) then
			options["OptionCustomClass"] = {};
			options["OptionCustomClass"]["OptionCustomClassSet"] = function()
				Derma_StringRequest(player:Name(), L("OptionCustomClassHelp"), player:GetSharedVar("CustomClass"), function(text)
					Clockwork.kernel:RunCommand("CharSetCustomClass", player:Name(), text);
				end);
			end;
			
			if (player:GetSharedVar("CustomClass") != "") then
				options["OptionCustomClass"]["OptionCustomClassTake"] = function()
					Clockwork.kernel:RunCommand("CharTakeCustomClass", player:Name());
				end;
			end;
		end;
	end;
	
	if (Clockwork.command:FindByID("CharPermaKill")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("CharPermaKill").access)) then
			options["OptionPermaKill"] = function()
				Clockwork.kernel:RunCommand("CharPermaKill", player:name());
			end;
		end;
	end;
end;

-- Called when the local player's default colorify should be set.
function Schema:PlayerSetDefaultColorModify(colorModify)
	if (Clockwork.config:Get("dull_vision"):Get()) then
		colorModify["$pp_colour_brightness"] = -0.02;
		colorModify["$pp_colour_contrast"] = 1.2;
		colorModify["$pp_colour_colour"] = 0.5;
	end;
end;

-- Called when the local player's colorify should be adjusted.
function Schema:PlayerAdjustColorModify(colorModify)
	local antiDepressants = Clockwork.Client:GetSharedVar("Antidepressants");
	local frameTime = FrameTime();
	local interval = FrameTime() / 10;
	local curTime = CurTime();
	
	if (!self.colorModify) then
		self.colorModify = {
			brightness = colorModify["$pp_colour_brightness"],
			contrast = colorModify["$pp_colour_contrast"],
			color = colorModify["$pp_colour_colour"]
		};
	end;
	
	if (antiDepressants > curTime) then
		self.colorModify.brightness = math.Approach(self.colorModify.brightness, 0,interval);
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, 1, interval);
		self.colorModify.color = math.Approach(self.colorModify.color, 1, interval);
	else
		self.colorModify.brightness = math.Approach(self.colorModify.brightness, colorModify["$pp_colour_brightness"], interval);
		self.colorModify.contrast = math.Approach(self.colorModify.contrast, colorModify["$pp_colour_contrast"], interval);
		self.colorModify.color = math.Approach(self.colorModify.color, colorModify["$pp_colour_colour"], interval);
	end;
	
	colorModify["$pp_colour_brightness"] = self.colorModify.brightness;
	colorModify["$pp_colour_contrast"] = self.colorModify.contrast;
	colorModify["$pp_colour_colour"] = self.colorModify.color;
end;

-- Called when a player's footstep sound should be played.
function Schema:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	return true;
end;

-- Called when the target's status should be drawn.
function Schema:DrawTargetPlayerStatus(target, alpha, x, y)
	local informationColor = Clockwork.option:GetColor("information");
	local mainStatus;
	local untieText;
	local action = Clockwork.player:GetAction(target);

	if (target:Alive()) then
		if (action == "die") then
			mainStatus = "StatusCriticalCondition";
		end;
		
		if (target:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
			mainStatus = "StatusUnconscious";
		end;
		
		if (target:GetSharedVar("IsTied") != 0) then
			if (Clockwork.player:GetAction(Clockwork.Client) == "untie") then
				mainStatus = "StatusBeingUntied";
			else
				local untieText;
				
				if (target:GetShootPos():Distance(Clockwork.Client:GetShootPos()) <= 192) then
					if (Clockwork.Client:GetSharedVar("IsTied") == 0) then
						mainStatus = "PressUseToUntie";
						
						untieText = true;
					end;
				end;
				
				if (!untieText) then
					mainStatus = "StatusBeenTiedUp";
				end;
			end;
		elseif (Clockwork.player:GetAction(Clockwork.Client) == "tie") then
			mainStatus = "StatusBeingTiedUp";
		end;
		
		if (mainStatus) then
			y = Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(L(mainStatus)), x, y, informationColor, alpha);
		end;
		
		return y;
	end;
end;

-- Called when the player info text is needed.
function Schema:GetPlayerInfoText(playerInfoText)
	local citizenID = Clockwork.Client:GetSharedVar("CitizenID");
	
	if (citizenID) then
		if (Clockwork.Client:GetFaction() == FACTION_CITIZEN) then
			playerInfoText:Add("CITIZEN_ID", L("InfoCitizenID", citizenID));
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

-- Called to check if a player does recognise another player.
function Schema:PlayerDoesRecognisePlayer(player, status, isAccurate, realValue)
	if (self:PlayerIsCombine(player) or player:GetFaction() == FACTION_ADMIN) then
		return true;
	end;
end;

-- Called each tick.
function Schema:Tick()
	if (IsValid(Clockwork.Client)) then
		if (self:PlayerIsCombine(Clockwork.Client)) then
			local curTime = CurTime();
			local health = Clockwork.Client:Health();
			local armor = Clockwork.Client:Armor();

			if (!self.nextHealthWarning or curTime >= self.nextHealthWarning) then
				if (self.lastHealth) then
					if (health < self.lastHealth) then
						if (health == 0) then
							self:AddCombineDisplayLine("ErrorShuttingDown", Color(255, 0, 0, 255));
						else
							self:AddCombineDisplayLine("PhysicalTraumaDetected", Color(255, 0, 0, 255));
						end;
						
						self.nextHealthWarning = curTime + 2;
					elseif (health > self.lastHealth) then
						if (health == 100) then
							self:AddCombineDisplayLine("PhysicalSystemsRestored", Color(0, 255, 0, 255));
						else
							self:AddCombineDisplayLine("PhysicalSystemsRegenerate", Color(0, 0, 255, 255));
						end;
						
						self.nextHealthWarning = curTime + 2;
					end;
				end;
				
				if (self.lastArmor) then
					if (armor < self.lastArmor) then
						if (armor == 0) then
							self:AddCombineDisplayLine("ExternalProtectionExhausted", Color(255, 0, 0, 255));
						else
							self:AddCombineDisplayLine("ExternalProtectionDamaged", Color(255, 0, 0, 255));
						end;
						
						self.nextHealthWarning = curTime + 2;
					elseif (armor > self.lastArmor) then
						if (armor == 100) then
							self:AddCombineDisplayLine("ExternalProtectionRestored", Color(0, 255, 0, 255));
						else
							self:AddCombineDisplayLine("ExternalProtectionRegenerate", Color(0, 0, 255, 255));
						end;
						
						self.nextHealthWarning = curTime + 2;
					end;
				end;
			end;
			
			if (!self.nextRandomLine or curTime >= self.nextRandomLine) then
				local text = self.randomDisplayLines[ math.random(1, #self.randomDisplayLines) ];
				
				if (text and self.lastRandomDisplayLine != text) then
					self:AddCombineDisplayLine(text);
					
					self.lastRandomDisplayLine = text;
				end;
				
				self.nextRandomLine = curTime + 3;
			end;
			
			self.lastHealth = health;
			self.lastArmor = armor;
		end;
	end;
end;

-- Called when the foreground HUD should be painted.
function Schema:HUDPaintForeground()
	local curTime = CurTime();
	
	if (Clockwork.Client:Alive()) then
		if (self.stunEffects) then
			for k, v in pairs(self.stunEffects) do
				local alpha = math.Clamp((255 / v[2]) * (v[1] - curTime), 0, 255);
				
				if (alpha != 0) then
					draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, alpha));
				else
					table.remove(self.stunEffects, k);
				end;
			end;
		end;
	end;
end;

-- Called when the top screen HUD should be painted.
function Schema:HUDPaintTopScreen(info)
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	local colorWhite = Clockwork.option:GetColor("white");
	local curTime = CurTime();
	
	if (self:PlayerIsCombine(Clockwork.Client) and self.combineDisplayLines) then
		local height = draw.GetFontHeight("BudgetLabel");
		
		for k, v in ipairs(self.combineDisplayLines) do
			if (curTime >= v[2]) then
				table.remove(self.combineDisplayLines, k);
			else
				local color = v[4] or colorWhite;
				local textColor = Color(color.r, color.g, color.b, 255 - blackFadeAlpha);
				
				draw.SimpleText(string.sub(v[1], 1, v[3]), "BudgetLabel", info.x, info.y, textColor);
				
				if (v[3] < string.len(v[1])) then
					v[3] = v[3] + 1;
				end;
				
				info.y = info.y + height;
			end;
		end;
	end;
end;

-- Called to get the screen text info.
function Schema:GetScreenTextInfo()
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	
	if (Clockwork.Client:GetSharedVar("PermaKilled")) then
		return {
			alpha = blackFadeAlpha,
			title = L("CharacterPermanentlyKilled"),
			text = L("GoToCharScreenToMakeNew")
		};
	elseif (Clockwork.Client:GetSharedVar("BeingTied")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = L("YouAreBeingTiedUpCenter")
		};
	elseif (Clockwork.Client:GetSharedVar("IsTied") != 0) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = L("YouHaveBeenTiedUpCenter")
		};
	end;
end;

-- Called when the chat box info should be adjusted.
function Schema:ChatBoxAdjustInfo(info)
	if (IsValid(info.speaker)) then
		if (info.data.anon) then
			info.name = "Somebody";
		end;
		
		if (self:PlayerIsCombine(info.speaker)) then
			local faction = info.speaker:GetFaction();

			if (faction == FACTION_SCANNER) then
				if (info.class == "radio" or info.class == "radio_eavesdrop") then
					info.name = "Dispatch";
				end;
			end;
		end;
	end;
end;
