--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

Clockwork.hint:Add("Books", "HintBook");

Clockwork.datastream:Hook("TakeBook", function(player, data)
	if (IsValid(data)) then
		if (data:GetClass() == "cw_book") then
			if (player:GetPos():Distance(data:GetPos()) <= 192 and player:GetEyeTraceNoCursor().Entity == data) then
				local success, fault = player:GiveItem(Clockwork.item:CreateInstance(data.book.uniqueID));
				
				if (!success) then
					Clockwork.player:Notify(player, fault);
				else
					data:Remove();
				end;
			end;
		end;
	end;
end);

-- A function to load the books.
function PLUGIN:LoadBooks()
	local books = Clockwork.kernel:RestoreSchemaData("plugins/books/"..game.GetMap());
	
	for k, v in pairs(books) do
		if (Clockwork.item:GetAll()[v.book]) then
			local entity = ents.Create("cw_book");
			
			Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
			
			entity:SetAngles(v.angles);
			entity:SetBook(v.book);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if (!v.moveable) then
				local physicsObject = entity:GetPhysicsObject();
				
				if (IsValid(physicsObject)) then
					physicsObject:EnableMotion(false);
				end;
			end;
		end;
	end;
end;

-- A function to save the books.
function PLUGIN:SaveBooks()
	local books = {};
	
	for k, v in pairs(ents.FindByClass("cw_book")) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physicsObject)) then
			moveable = physicsObject:IsMoveable();
		end;
		
		books[#books + 1] = {
			key = Clockwork.entity:QueryProperty(v, "key"),
			book = v.book.uniqueID,
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/books/"..game.GetMap(), books);
end;