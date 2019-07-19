--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemHandheldRadio";
ITEM.uniqueID = "handheld_radio";
ITEM.cost = 20;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Communication";
ITEM.business = true;
ITEM.description = "ItemHandheldRadioDesc";
ITEM.customFunctions = {"Frequency"};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Frequency") then
			Clockwork.datastream:Start(player, "Frequency", player:GetCharacterData("Frequency", ""));
		end;
	end;
end;

ITEM:Register();