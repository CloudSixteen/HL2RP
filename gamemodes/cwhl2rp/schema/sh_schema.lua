--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("cl_schema.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_theme.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_schema.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

Schema.customPermits = {};

for k, v in pairs(_file.Find("models/humans/group17/*.mdl", "GAME")) do
	Clockwork.animation:AddMaleHumanModel("models/humans/group17/"..v);
end;

Clockwork.animation:AddCivilProtectionModel("models/police/eliteghostcp.mdl");
Clockwork.animation:AddCivilProtectionModel("models/police/eliteshockcp.mdl");
Clockwork.animation:AddCivilProtectionModel("models/police/leet_police2.mdl");
Clockwork.animation:AddCivilProtectionModel("models/police/sect_police2.mdl");
Clockwork.animation:AddCivilProtectionModel("models/police/policetrench.mdl");

Clockwork.option:SetKey("default_date", {month = 1, year = 2016, day = 1});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl");
Clockwork.option:SetKey("intro_image", "hl2rp2/hl2rp2019");
Clockwork.option:SetKey("schema_logo", "hl2rp2/hl2rp2019");
Clockwork.option:SetKey("menu_music", "music/hl2_song19.mp3");
Clockwork.option:SetKey("model_cash", "models/props_lab/box01a.mdl");
Clockwork.option:SetKey("gradient", "hl2rp2/gradient");

Clockwork.config:ShareKey("intro_text_small");
Clockwork.config:ShareKey("intro_text_big");
Clockwork.config:ShareKey("business_cost");
Clockwork.config:ShareKey("permits");

Clockwork.quiz:SetEnabled(true);
Clockwork.quiz:AddQuestion("QuizOption1", 1, "QuizAnswerYes", "QuizAnswerNo");
Clockwork.quiz:AddQuestion("QuizOption2", 2, "QuizAnswerBadGrammar", "QuizAnswerGoodGrammar");
Clockwork.quiz:AddQuestion("QuizOption3", 1, "QuizAnswerYes", "QuizAnswerNo");
Clockwork.quiz:AddQuestion("QuizOption4", 1, "QuizAnswerYes", "QuizAnswerNo");
Clockwork.quiz:AddQuestion("QuizOption5", 2, "QuizAnswerCollectingItems", "QuizAnswerDevelopingChar");
Clockwork.quiz:AddQuestion("QuizOption6", 2, "QuizAnswerRealLife", "QuizAnswerHalfLife2");

Clockwork.flag:Add("v", "Light Blackmarket", "Access to light blackmarket goods.");
Clockwork.flag:Add("V", "Heavy Blackmarket", "Access to heavy blackmarket goods.");
Clockwork.flag:Add("m", "Resistance Manager", "Access to the resistance manager's goods.");

Clockwork.command:AddAlias("StorageGiveCash", "StorageGiveTokens");
Clockwork.command:AddAlias("StorageTakeTokens", "StorageTakeTokens");
Clockwork.command:AddAlias("GiveCash", "GiveTokens");
Clockwork.command:AddAlias("DropCash", "DropTokens");
Clockwork.command:AddAlias("SetCash", "SetTokens");

-- A function to add a custom permit.
function Schema:AddCustomPermit(name, flag, model)
	local formattedName = string.gsub(name, "[%s%p]", "");
	local lowerName = string.lower(name);
	
	self.customPermits[ string.lower(formattedName) ] = {
		model = model,
		name = name,
		flag = flag,
		key = Clockwork.kernel:SetCamelCase(formattedName, true)
	};
end;

-- A function to get if a faction is Combine.
function Schema:IsCombineFaction(faction)
	local factionTable = Clockwork.faction:FindByID(faction);

	return factionTable and factionTable.isCombineFaction or false;
end;
