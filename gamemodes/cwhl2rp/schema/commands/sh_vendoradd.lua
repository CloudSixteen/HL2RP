--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("VendorAdd");

COMMAND.tip = "Add a vending machine at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_vendingmachine");
	
	entity:SetPos(trace.HitPos + Vector(0, 0, 48));
	entity:Spawn();
	
	if (IsValid(entity)) then
		entity:SetStock(math.random(10, 20), true);
		entity:SetAngles(Angle(0, player:EyeAngles().yaw + 180, 0));
		
		Clockwork.player:Notify(player, {"YouAddedVendingMachine"});
	end;
end;

COMMAND:Register();