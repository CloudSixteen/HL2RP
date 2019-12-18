--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Schema.stunEffects = {};
Schema.combineOverlay = Material("effects/combine_binocoverlay");
Schema.randomDisplayLines = {
	"Transmitting physical transition vector...",
	"Modulating external temperature levels...",
	"Parsing view ports and data arrays...",
	"Translating Union practicalities...",
	"Updating biosignal co-ordinates...",
	"Parsing Clockwork protocol messages...",
	"Downloading recent dictionaries...",
	"Pinging connection to network...",
	"Updating mainframe connection...",
	"Synchronizing locational data...",
	"Translating radio messages...",
	"Emptying outgoing pipes...",
	"Sensoring proximity...",
	"Pinging loopback...",
	"Idle connection..."
};

Clockwork.config:AddToSystem("ServerWhitelistIdentity", "server_whitelist_identity", "ServerWhitelistIdentityDesc");
Clockwork.config:AddToSystem("CombineLockOverrides", "combine_lock_overrides", "CombineLockOverridesDesc");
Clockwork.config:AddToSystem("SmallIntroText", "intro_text_small", "SmallIntroTextDesc");
Clockwork.config:AddToSystem("BigIntroText", "intro_text_big", "BigIntroTextDesc");
Clockwork.config:AddToSystem("KnockoutTime", "knockout_time", "KnockoutTimeDesc", 0, 7200);
Clockwork.config:AddToSystem("BusinessCost", "business_cost", "BusinessCostDesc");
Clockwork.config:AddToSystem("CWUPropsEnabled", "cwu_props", "CWUPropsEnabledDesc");
Clockwork.config:AddToSystem("PermitsEnabled", "permits", "PermitsEnabledDesc");
Clockwork.config:AddToSystem("DullVision", "dull_vision", "DullVisionDesc");

Clockwork.datastream:Hook("RebuildBusiness", function(data)
	if (Clockwork.menu:GetOpen() and IsValid(Schema.businessPanel)) then
		if (Clockwork.menu:GetActivePanel() == Schema.businessPanel) then
			Schema.businessPanel:Rebuild();
		end;
	end;
end);

Clockwork.datastream:Hook("ObjectPhysDesc", function(data)
	local entity = data;
	
	if (IsValid(entity)) then
		Derma_StringRequest(L("RequestObjectDescTitle"), L("RequestObjectDescHelp"), nil, function(text)
			Clockwork.datastream:Start("ObjectPhysDesc", {text, entity});
		end);
	end;
end);

Clockwork.datastream:Hook("Frequency", function(data)
	Derma_StringRequest(L("RequestFrequencyTitle"), L("RequestFrequencyHelp"), data, function(text)
		Clockwork.kernel:RunCommand("SetFreq", text);
		
		if (!Clockwork.menu:GetOpen()) then
			gui.EnableScreenClicker(false);
		end;
	end);
	
	if (!Clockwork.menu:GetOpen()) then
		gui.EnableScreenClicker(true);
	end;
end);

Clockwork.datastream:Hook("EditObjectives", function(data)
	if (Schema.objectivesPanel and Schema.objectivesPanel:IsValid()) then
		Schema.objectivesPanel:Close();
		Schema.objectivesPanel:Remove();
	end;
	
	Schema.objectivesPanel = vgui.Create("cwObjectives");
	Schema.objectivesPanel:Populate(data or "");
	Schema.objectivesPanel:MakePopup();
	
	gui.EnableScreenClicker(true);
end);

Clockwork.datastream:Hook("EditData", function(data)
	if (IsValid(data[1])) then
		if (Schema.dataPanel and Schema.dataPanel:IsValid()) then
			Schema.dataPanel:Close();
			Schema.dataPanel:Remove();
		end;
		
		Schema.dataPanel = vgui.Create("cwData");
		Schema.dataPanel:Populate(data[1], data[2] or "");
		Schema.dataPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

Clockwork.datastream:Hook("Stunned", function(data)
	Schema:AddStunEffect(data);
end);

Clockwork.datastream:Hook("Flashed", function(data)
	Schema:AddFlashEffect();
end);

-- A function to add a flash effect.
function Schema:AddFlashEffect()
	local curTime = CurTime();
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + 10, 10};
	self.flashEffect = {curTime + 20, 20};
	
	surface.PlaySound("hl1/fvox/flatline.wav");
end;

-- A function to add a stun effect.
function Schema:AddStunEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + duration, duration};
	self.flashEffect = {curTime + (duration * 2), duration * 2, true};
end;

Clockwork.datastream:Hook("ClearEffects", function(data)
	Schema.stunEffects = {};
	Schema.flashEffect = nil;
end);

Clockwork.datastream:Hook("CombineDisplayLine", function(data)
	Schema:AddCombineDisplayLine(data[1], data[2]);
end);

Clockwork.chatBox:RegisterClass("request_eavesdrop", "ic", function(info)
	if (info.shouldHear) then
		local localized = Clockwork.chatBox:LangToTable("ChatPlayerRequest", Color(255, 255, 150, 255), info.name, info.text);
		
		Clockwork.chatBox:Add(info.filtered, nil, unpack(localized));
	end;
end);

Clockwork.chatBox:RegisterClass("broadcast", "ic", function(info)
	local localized = Clockwork.chatBox:LangToTable("ChatPlayerBroadcast", Color(150, 125, 175, 255), info.name, info.text);
	
	Clockwork.chatBox:Add(info.filtered, nil, unpack(localized));
end);

Clockwork.chatBox:RegisterClass("dispatch", "ic", function(info)
	local localized = Clockwork.chatBox:LangToTable("ChatPlayerDispatch", Color(150, 100, 100, 255), info.text);
	
	Clockwork.chatBox:Add(info.filtered, nil, unpack(localized));
end);

Clockwork.chatBox:RegisterClass("request", "ic", function(info)
	local localized = Clockwork.chatBox:LangToTable("ChatPlayerRequest", Color(175, 125, 100, 255), info.name, info.text);
	
	Clockwork.chatBox:Add(info.filtered, nil, unpack(localized));
end);

-- A function to get a player's scanner entity.
function Schema:GetScannerEntity(player)
	local scannerEntity = Entity(player:GetSharedVar("Scanner"));
	
	if (IsValid(scannerEntity)) then
		return scannerEntity;
	end;
end;

-- A function to get whether a text entry is being used.
function Schema:IsTextEntryBeingUsed()
	if (self.textEntryFocused) then
		if (self.textEntryFocused:IsValid() and self.textEntryFocused:IsVisible()) then
			return true;
		end;
	end;
end;

-- A function to add a Combine display line.
function Schema:AddCombineDisplayLine(text, color)
	if (self:PlayerIsCombine(Clockwork.Client)) then
		if (!self.combineDisplayLines) then
			self.combineDisplayLines = {};
		end;
		
		table.insert(self.combineDisplayLines, {"<:: "..T(text), CurTime() + 8, 5, color});
	end;
end;

-- A function to get whether a player is Combine.
function Schema:PlayerIsCombine(player, bHuman)
	if (!IsValid(player)) then
		return;
	end;

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
