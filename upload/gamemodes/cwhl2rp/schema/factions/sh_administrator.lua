--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Administrator");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.material = "hl2rp2/factions/admin";
FACTION.maxArmor = 100;
FACTION.models = {
	female = {
		"models/humans/group17/female_01.mdl",
		"models/humans/group17/female_02.mdl",
		"models/humans/group17/female_03.mdl",
		"models/humans/group17/female_04.mdl",
		"models/humans/group17/female_06.mdl",
		"models/humans/group17/female_07.mdl"
	},
	male = {
		"models/humans/group17/male_01.mdl",
		"models/humans/group17/male_02.mdl",
		"models/humans/group17/male_03.mdl",
		"models/humans/group17/male_04.mdl",
		"models/humans/group17/male_05.mdl",
		"models/humans/group17/male_06.mdl",
		"models/humans/group17/male_07.mdl",
		"models/humans/group17/male_08.mdl",
		"models/humans/group17/male_09.mdl"
	};
};
FACTION.startingInv = {
	["handheld_radio"] = 1
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

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name != FACTION_CITIZEN) then
		return false;
	end;
end;

FACTION_ADMIN = FACTION:Register();
