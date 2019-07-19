--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Metropolice Force");

FACTION.isCombineFaction = true;
FACTION.whitelist = true;
FACTION.material = "hl2rp2/factions/mpf";
FACTION.maxArmor = 100;
FACTION.startChatNoise = "npc/overwatch/radiovoice/on1.wav";
FACTION.endChatNoise = "npc/overwatch/radiovoice/off4.wav";
FACTION.models = {
	female = {"models/police.mdl"},
	male = {"models/police.mdl"}
};
FACTION.weapons = {
	"cw_stunstick"
};
FACTION.startingInv = {
	["handheld_radio"] = 1,
	["weapon_pistol"] = 1,
	["ammo_pistol"] = 2
};
FACTION.respawnInv = {
	["ammo_pistol"] = 2
};
FACTION.entRelationship = {
	["npc_combine_s"] = "Like",
	["npc_helicopter"] = "Like",
	["npc_metropolice"] = "Like",
	["npc_manhack"] = "Like",
	["npc_combinedropship"] = "Like",
	["npc_rollermine"] = "Like",
	["npc_stalker"] = "Like",
	["npc_turret_floor"] = "Like",
	["npc_combinegunship"] = "Like",
	["npc_cscanner"] = "Like",
	["npc_clawscanner"] = "Like",
	["npc_strider"] = "Like",
	["npc_turret_ceiling"] = "Like",
	["npc_turret_ground"] = "Like",
	["npc_combine_camera"] = "Like"
};
FACTION.ranks = {
	["RCT"] = {
		position = 5,
		class = "Metropolice Recruit"
	},
	["EpU"] = {
		position = 4,
		class = "Elite Metropolice",
		model = "models/police/leet_police2.mdl"
	},
	["OfC"] = {
		position = 3,
		class = "Elite Metropolice",
		model = "models/police/policetrench.mdl"
	},
	["DvL"] = {
		position = 2,
		class = "Elite Metropolice",
		model = "models/police/eliteshockcp.mdl",
		canPromote = 4,
		canDemote = 3
	},
	["SeC"] = {
		position = 1,
		class = "Elite Metropolice",
		model = "models/police/sect_police2.mdl",
		canPromote = 3,
		canDemote = 2
	}
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "MPF."..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5);
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
	if (character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_OTA or faction.name == FACTION_SCANNER) then
		if (name) then
			Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d%d%d)", "MPF.%1"), true);
		else
			return false, "You need to specify a name as the third argument!";
		end;
	else
		Clockwork.player:SetName(player, self:GetName(player, player:GetCharacter()));
	end;
	
	if (player:QueryCharacter("gender") == GENDER_MALE) then
		player:SetCharacterData("model", self.models.male[1], true);
	else
		player:SetCharacterData("model", self.models.female[1], true);
	end;
end;

FACTION_MPF = FACTION:Register();
