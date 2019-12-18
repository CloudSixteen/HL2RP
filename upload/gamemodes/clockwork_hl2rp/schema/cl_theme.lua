--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local THEME = Clockwork.theme:Begin(true);

local FONT_USED = "Mailart Rubberstamp"; -- "Accidental Presidency"

-- Called when fonts should be created.
function THEME:CreateFonts()
	surface.CreateFont("hl2rp2_Large3D2D", {
		size = Clockwork.kernel:FontScreenScale(2048),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_IntroTextSmall", {
		size = Clockwork.kernel:FontScreenScale(12),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_IntroTextTiny", {
		size = Clockwork.kernel:FontScreenScale(10),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_CinematicText", {
		size = Clockwork.kernel:FontScreenScale(24),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_IntroTextBig", {
		size = Clockwork.kernel:FontScreenScale(28),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_TargetIDText", {
		size = Clockwork.kernel:FontScreenScale(10),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_SmallBarText", {
		size = Clockwork.kernel:FontScreenScale(10),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_MenuTextHuge", {
		size = Clockwork.kernel:FontScreenScale(32),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_MenuTextBig", {
		size = Clockwork.kernel:FontScreenScale(22),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_PlayerInfoText", {
		size = Clockwork.kernel:FontScreenScale(10),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});

	surface.CreateFont("hl2rp2_MainText", {
		size = Clockwork.kernel:FontScreenScale(10),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});
	
	surface.CreateFont("hl2rp2_BarText", {
		size = Clockwork.kernel:FontScreenScale(9),
		weight = 600, 
		antialias = true,
		font = FONT_USED
	});
	
	surface.CreateFont("hl2rp2_BarTextAuto", {
		size = Clockwork.kernel:FontScreenScale(7),
		weight = 600, 
		antialias = true,
		font = "Arial"
	});
end;

-- Called when to initialize the theme.
function THEME:Initialize()
	Clockwork.option:SetFont("bar_text", "hl2rp2_BarText");
	Clockwork.option:SetFont("auto_bar_text", "hl2rp2_BarTextAuto");
	Clockwork.option:SetFont("main_text", "hl2rp2_MainText");
	Clockwork.option:SetFont("hints_text", "hl2rp2_IntroTextTiny");
	Clockwork.option:SetFont("large_3d_2d", "hl2rp2_Large3D2D");
	Clockwork.option:SetFont("scoreboard_name", "hl2rp2_TargetIDText");
	Clockwork.option:SetFont("scoreboard_class", "hl2rp2_IntroTextTiny");
	Clockwork.option:SetFont("target_id_text", "hl2rp2_TargetIDText");
	Clockwork.option:SetFont("cinematic_text", "hl2rp2_CinematicText");
	Clockwork.option:SetFont("date_time_text", "hl2rp2_IntroTextSmall");
	Clockwork.option:SetFont("menu_text_big", "hl2rp2_MenuTextBig");
	Clockwork.option:SetFont("menu_text_huge", "hl2rp2_MenuTextHuge");
	Clockwork.option:SetFont("menu_text_tiny", "hl2rp2_IntroTextTiny");
	Clockwork.option:SetFont("intro_text_big", "hl2rp2_IntroTextBig");
	Clockwork.option:SetFont("menu_text_small", "hl2rp2_IntroTextSmall");
	Clockwork.option:SetFont("intro_text_tiny", "hl2rp2_IntroTextTiny");
	Clockwork.option:SetFont("intro_text_small", "hl2rp2_IntroTextSmall");
	Clockwork.option:SetFont("player_info_text", "hl2rp2_PlayerInfoText");
	
	Clockwork.option:SetColor("columnsheet_shadow_normal", Color(0, 0, 0, 0));
	Clockwork.option:SetColor("columnsheet_text_normal", Color(255, 255, 255, 255));
	Clockwork.option:SetColor("columnsheet_shadow_active", Color(0, 0, 0, 0));
	Clockwork.option:SetColor("columnsheet_text_active", Color(255, 210, 64, 255));
	
	Clockwork.option:SetColor("attribute_base_color", Color(50, 50, 50, 255));
	Clockwork.option:SetColor("attribute_progress_color", Color(247, 240, 195, 255));
	Clockwork.option:SetColor("attribute_boost_color", Color(50, 255, 50, 255));
	Clockwork.option:SetColor("attribute_hinder_color", Color(255, 50, 50, 255));
	Clockwork.option:SetColor("attribute_main_color", Color(255, 210, 64, 255));
	
	Clockwork.option:SetColor("basic_form_highlight", Color(255, 215, 56, 255));
	Clockwork.option:SetColor("basic_form_color_help", Color(255, 255, 255, 255));
	Clockwork.option:SetColor("basic_form_color", Color(245, 224, 91, 255));

	Clockwork.option:SetColor("scoreboard_item_background", Color(255, 255, 255, 100));
	
	Clockwork.option:SetKey("info_text_icon_size", 24);
	Clockwork.option:SetKey("info_text_red_icon", "hl2rp2/infotext/red.png");
	Clockwork.option:SetKey("info_text_green_icon", "hl2rp2/infotext/green.png");
	Clockwork.option:SetKey("info_text_orange_icon", "hl2rp2/infotext/orange.png");
	Clockwork.option:SetKey("info_text_blue_icon", "hl2rp2/infotext/blue.png");
	
	Clockwork.option:SetKey("top_bar_width_scale", 0.2);
	
	Clockwork.option:SetKey("icon_data_classes", {path = "hl2rp2/menuitems/classes.png", size = 48});
	Clockwork.option:SetKey("icon_data_settings", {path = "hl2rp2/menuitems/settings.png", size = 48});
	Clockwork.option:SetKey("icon_data_system", {path = "hl2rp2/menuitems/system.png", size = 48});
	Clockwork.option:SetKey("icon_data_scoreboard", {path = "hl2rp2/menuitems/scoreboard.png", size = 48});
	Clockwork.option:SetKey("icon_data_inventory", {path = "hl2rp2/menuitems/inventory.png", size = 48});
	Clockwork.option:SetKey("icon_data_directory", {path = "hl2rp2/menuitems/directory.png", size = 48});
	Clockwork.option:SetKey("icon_data_attributes", {path = "hl2rp2/menuitems/attributes.png", size = 48});
	Clockwork.option:SetKey("icon_data_business", {path = "hl2rp2/menuitems/business.png", size = 48});
	Clockwork.option:SetKey("icon_data_crafting", {path = "hl2rp2/menuitems/crafting.png", size = 48});
	Clockwork.option:SetKey("icon_data_plugin_center", {path = "hl2rp2/menuitems/plugincenter.png", size = 48});
	Clockwork.option:SetKey("icon_data_community", {path = "hl2rp2/menuitems/community.png", size = 48});
	
	--[[
	Clockwork.option:SetColor("information", Color(26, 169, 192, 255));
	Clockwork.option:SetColor("foreground", Color(50, 50, 50, 125));
	Clockwork.option:SetColor("target_id", Color(63, 184, 203, 255));
	--]]
	
	Clockwork.option:SetColor("information", Color(255, 228, 54, 255));
	--Clockwork.option:SetColor("background", Color(0, 0, 0, 255));
	Clockwork.option:SetColor("foreground", Color(255, 255, 255, 125));
	Clockwork.option:SetColor("target_id", Color(241, 208, 94, 255));
	
	SMALL_BAR_BG = Clockwork.render:AddSlice9("Small", "hl2rp2/themes/grunge/transparent", 6);
	SMALL_BAR_FG = Clockwork.render:AddSlice9("Small", "hl2rp2/themes/grunge/small", 6);
	SCOREBOARD_ITEM_SLICED = Clockwork.render:AddSlice9("Large", "hl2rp2/themes/grunge/fade", 8);
	INFOTEXT_SLICED = Clockwork.render:AddSlice9("Large", "hl2rp2/themes/grunge/small", 6);
	MENU_ITEM_SLICED = Clockwork.render:AddSlice9("Small", "hl2rp2/themes/grunge/small", 6);
	SLICED_SMALL_TINT = Clockwork.render:AddSlice9("Small", "hl2rp2/themes/grunge/small", 6);
	SLICED_INFO_MENU_INSIDE = Clockwork.render:AddSlice9("Small", "hl2rp2/themes/grunge/small", 6);
	SLICED_COLUMNSHEET_BUTTON = Clockwork.render:AddSlice9("Transparent", "hl2rp2/themes/grunge/transparent", 20);
	PANEL_LIST_SLICED = Clockwork.render:AddSlice9("Transparent", "hl2rp2/themes/grunge/transparent", 20);
	DERMA_SLICED_BG = Clockwork.render:AddSlice9("Transparent", "hl2rp2/themes/grunge/transparent", 20);
	SLICED_LARGE_DEFAULT = Clockwork.render:AddSlice9("Large", "hl2rp2/themes/grunge/large", 28);
	SLICED_PROGRESS_BAR = Clockwork.render:AddSlice9("Large", "hl2rp2/themes/grunge/large", 28);
	SLICED_PLAYER_INFO = Clockwork.render:AddSlice9("Large", "hl2rp2/themes/grunge/large", 28);
	CUSTOM_BUSINESS_ITEM_BG = Clockwork.render:AddSlice9("SmallDark", "hl2rp2/themes/grunge/small_dark", 6);
	SLICED_INFO_MENU_BG = Clockwork.render:AddSlice9("Transparent", "hl2rp2/themes/grunge/transparent", 20);
	
	Clockwork.bars.height = 14;
	Clockwork.bars.padding = 28;
end;

local HEALTH_ICON = Material("hl2rp2/icons/health.png");
local STAMINA_ICON = Material("hl2rp2/icons/stamina.png");
local ARMOR_ICON = Material("hl2rp2/icons/armor.png");

function THEME:GetBarIconFromClass(class)
	--[[
	if (class == "HEALTH") then
		return HEALTH_ICON;
	elseif (class == "ARMOR") then
		return ARMOR_ICON;
	elseif (class == "STAMINA") then
		return STAMINA_ICON;
	end;
	--]]
end;

-- Called just before a bar is drawn.
function THEME.module:PreDrawBar(barInfo)
	local icon = THEME:GetBarIconFromClass(barInfo.uniqueID);
	local iconSize = barInfo.height * 2.5;
	
	if (icon) then
		barInfo.x = barInfo.x + iconSize;
	end;
	
	DERMA_SLICED_BG:Draw(barInfo.x, barInfo.y, barInfo.width, barInfo.height, 4, Color(255, 255, 255, 100));
	
	barInfo.drawBackground = false;
	barInfo.drawProgress = false;
	
	if (barInfo.text) then
		barInfo.text = string.upper(barInfo.text);
	end;
end;

-- Called just after a bar is drawn.
function THEME.module:PostDrawBar(barInfo)
	local icon = THEME:GetBarIconFromClass(barInfo.uniqueID);
	
	if (icon) then
		local iconSize = barInfo.height * 2.5;
		local halfHeight = barInfo.height * 0.5;
		
		surface.SetDrawColor(255, 255, 255, barInfo.color.a);
			surface.SetMaterial(icon);
		surface.DrawTexturedRect(barInfo.x - (iconSize - 2), (barInfo.y + halfHeight) - (iconSize * 0.5), iconSize, iconSize);
	end;

	local width = barInfo.progressWidth;
	
	if (width >= barInfo.width - 8) then
		width = barInfo.width;
	end;
	
	if (width > 8) then
		SLICED_SMALL_TINT:Draw(barInfo.x + 2, barInfo.y + 2, math.max(width - 4, 0), barInfo.height - 4, 4, Color(barInfo.color.r, barInfo.color.g, barInfo.color.b, barInfo.color.a));
	end;
end;

-- Called when the menu is opened.
function THEME.module:MenuOpened()
	if (Clockwork.Client:HasInitialized()) then
		Clockwork.kernel:RegisterBackgroundBlur("MainMenu", SysTime());
	end;
end;

-- Called when the menu is closed.
function THEME.module:MenuClosed()
	if (Clockwork.Client:HasInitialized()) then
		Clockwork.kernel:RemoveBackgroundBlur("MainMenu");
	end;
end;

-- Called just before the weapon selection info is drawn.
function THEME.module:PreDrawWeaponSelectionInfo(info)
	DERMA_SLICED_BG:Draw(info.x, info.y, info.width, info.height, 4, Color(255, 255, 255, info.alpha));
	
	info.drawBackground = false;
end;

-- Called just before the local player's information is drawn.
function THEME.module:PreDrawPlayerInfo(boxInfo, information, subInformation)
	DERMA_SLICED_BG:Draw(boxInfo.x, boxInfo.y, boxInfo.width, boxInfo.height, 4, Color(255, 255, 255, 200));
	
	boxInfo.drawBackground = false;
end;

-- Called after the character menu has initialized.
function THEME.hooks:PostCharacterMenuInit(panel) end;

-- Called every frame that the character menu is open.
function THEME.hooks:PostCharacterMenuThink(panel) end;

-- Called after the character menu is painted.
function THEME.hooks:PostCharacterMenuPaint(panel) end;

-- Called after a character menu panel is opened.
function THEME.hooks:PostCharacterMenuOpenPanel(panel) end;

-- Called after the main menu has initialized.
function THEME.hooks:PostMainMenuInit(panel) end;

-- Called after the main menu is rebuilt.
function THEME.hooks:PostMainMenuRebuild(panel) end;

-- Called after a main menu panel is opened.
function THEME.hooks:PostMainMenuOpenPanel(panel, panelToOpen) end;

-- Called after the main menu is painted.
function THEME.hooks:PostMainMenuPaint(panel) end;

-- Called every frame that the main menu is open.
function THEME.hooks:PostMainMenuThink(panel) end;

Clockwork.theme:Finish(THEME);