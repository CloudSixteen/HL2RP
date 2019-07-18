--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when the Clockwork shared variables are added.
function Schema:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("PermaKilled", true);
	playerVars:Number("Antidepressants", true);
	playerVars:String("CustomClass");
	playerVars:String("CitizenID", true);
	playerVars:Number("Scanner", true);
	playerVars:Number("IsTied");
	globalVars:Number("PermaKillMode");
end;