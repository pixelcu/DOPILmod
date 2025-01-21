local ig = ImGui
local prefix = "Repentance Negative "
local json = require("json")

local MusicTable = {
	[Music.MUSIC_CELLAR] = prefix .. "Cellar",
	[Music.MUSIC_BURNING_BASEMENT] = prefix .. "Burning Basement",
	[Music.MUSIC_CAVES] = prefix .. "Caves",
	[Music.MUSIC_DEPTHS] = prefix .. "Depths",
	[Music.MUSIC_CATHEDRAL] = prefix .. "Cathedral",
	[Music.MUSIC_WOMB_UTERO] = prefix .. "Womb/Utero",
	[Music.MUSIC_BOSS] = prefix .. "Boss",
	[Music.MUSIC_BOSS2] = prefix .. "Boss (alternate)",
	[Music.MUSIC_BOSS_OVER] = prefix .. "Boss Room (empty)",
	[Music.MUSIC_SHOP_ROOM] = prefix .. "Shop Room",
	[Music.MUSIC_ARCADE_ROOM] = prefix .. "Arcade Room",
	[Music.MUSIC_DOWNPOUR] = prefix .. "Downpour",
	[Music.MUSIC_BOSS3] = prefix .. "Boss (alternate alternate)",
	[Music.MUSIC_DOWNPOUR_REVERSE] = prefix .. "Downpour (reversed)",
	[Music.MUSIC_TITLE_REPENTANCE] = prefix .. "Main Menu",
}

local JingleTable = {
	[Music.MUSIC_JINGLE_BOSS_OVER] = prefix .. "Boss Death (jingle)",
	[Music.MUSIC_JINGLE_SECRETROOM_FIND] = prefix .. "Secret Room Find (jingle)",
	[Music.MUSIC_JINGLE_TREASUREROOM_ENTRY_1] = prefix .. "Treasure Room Entry (jingle) 2",
	[Music.MUSIC_JINGLE_BOSS_OVER2] = prefix .. "Boss Death Alternate (jingle)",
	[Music.MUSIC_JINGLE_BOSS_OVER3] = prefix .. "Boss Death Alternate Alternate (jingle)",
}

local music, jingle = MusicTable, JingleTable

if RepMMod:HasData() then
	local save = json.decode(RepMMod:LoadData())
	if save.MusicData then
		RepMMod.saveTable.MusicData = save.MusicData
	end
end

function RepMMod.GetModdedMusicTable()
	return MusicTable, JingleTable
end

function RepMMod.ChangeFloorMusicTo(id, id2, change)
	if StageAPI and StageAPI.InOverriddenStage() then
		return
	end
	if not change then
		id, id2 = id2, id
	end
	if id == MusicManager():GetCurrentMusicID() then
		MusicManager():Play(id2, Options.MusicVolume)
		Isaac.SetCurrentFloorMusic(id2)
	end
end

local function IsNumber(t)
	return t and type(t) == "number"
end

local function IsFunction(t)
	return t and type(t) == "function"
end

local function IsBoolean(t)
	return t and type(t) == "boolean"
end

local function IsString(t)
	return t and type(t) == "string"
end

local function IsTable(t)
	return t and type(t) == "table"
end

---@param elemType ImGuiElement | integer
---@return boolean
local function IsMenu(elemType)
	return elemType == ImGuiElement.Menu or elemType == ImGuiElement.MenuItem
end

---@param elemType ImGuiElement | integer
---@return boolean
local function IsWindow(elemType)
	return elemType == ImGuiElement.Window
end

---@param ... string
---@return string
local function MakeElementName(...)
	local finalName = nil
	for _, str in ipairs({ ... }) do
		if IsString(finalName) then
			finalName = finalName .. "_" .. str
		else
			finalName = str
		end
	end
	return finalName or ""
end

local function RemoveElement(id, type)
	if IsString(id) then
		local resetFunc = {
			[ImGuiElement.Menu] = ig.RemoveMenu,
			[ImGuiElement.MenuItem] = ig.RemoveMenu,
			[ImGuiElement.Window] = ig.RemoveWindow,
			Default = ig.RemoveElement,
		}
		local func = (IsNumber(type) and resetFunc[type]) and resetFunc[type] or resetFunc.Default
		if ig.ElementExists(id) then
			func(id)
		end
	end
end

---@param parentId string
---@param id string
---@param elems function | string | table
local function AddElements(parentId, id, elems)
	local parentElement = MakeElementName(parentId, id)
	local tabBarID = MakeElementName(parentElement, "TabBar")
	RemoveElement(tabBarID)
	for name, elem in pairs(elems) do
		if IsFunction(elem) then
			elem(parentElement, name)
		elseif IsString(elem) then
			ig.AddText(parentElement, elem, true, MakeElementName(parentElement, name))
		elseif IsTable(elem) then
			if not ig.ElementExists(tabBarID) then
				ig.AddTabBar(parentElement, tabBarID)
			end
			local tabID = MakeElementName(tabBarID, name)
			ig.AddTab(tabBarID, tabID, name)
			AddElements(tabBarID, name, elem)
		end
	end
end

local imguiFuncs = {
	AddText = function(txt, wraped)
		return function(parentId, id)
			ig.AddText(parentId, txt, wraped or false, MakeElementName(parentId, id))
		end
	end,
	AddInputText = function(txt, default, description, callback)
		return function(parentId, id)
			ig.AddInputText(parentId, MakeElementName(parentId, id), txt, callback, description or "", default)
		end
	end,
	AddCombobox = function(label, func, options, selIndex, isSlider)
		return function(parentId, id)
			ig.AddCombobox(parentId, MakeElementName(parentId, id), label, func, options, selIndex, isSlider)
		end
	end,
	AddCheckbox = function(...)
		local d = ...
		return function(parentId, id)
			ig.AddCheckbox(parentId, MakeElementName(parentId, id), d)
		end
	end,
	AddInputInteger = function(...)
		local d = ...
		return function(parentId, id)
			ig.AddInputInteger(parentId, MakeElementName(parentId, id), d)
		end
	end,
	SetTextColor = function(r, g, b, a, idx)
		return function(parentId, id)
			if idx == nil then
				idx = tonumber(id - 1)
			end
			ig.SetTextColor(MakeElementName(parentId, id), r, g, b, a)
		end
	end,
	SetHelpMarker = function(txt, idx)
		return function(parentId, id)
			if idx == nil then
				idx = tonumber(id - 1)
			end
			ig.SetHelpmarker(MakeElementName(parentId, idx), txt)
		end
	end,
	SetTooltip = function(txt, idx)
		return function(parentId, id)
			if idx == nil then
				idx = tonumber(id - 1)
			end
			ig.SetTooltip(MakeElementName(parentId, idx), txt)
		end
	end,
	AddButton = function(label, isSmall, callback)
		return function(parentId, id)
			ig.AddButton(parentId, MakeElementName(parentId, id), label or "Button", callback, isSmall or false)
		end
	end,
	AddCallback = function(type, func, idx)
		return function(parentId, id)
			if idx == nil then
				idx = tonumber(id - 1)
			end
			ig.AddCallback(MakeElementName(parentId, idx), type, func)
		end
	end,
}

local function InitAchievementMenu()
	local tab = {}
	table.insert(
		tab,
		imguiFuncs.AddButton(RepMMod.GetDSSStr("unlock"), false, function(clickCount)
			for _, ach in pairs(RepMMod.RepmAchivements) do
				Isaac.GetPersistentGameData():TryUnlock(ach.ID, true)
			end
		end)
	)
	table.insert(
		tab,
		imguiFuncs.AddButton(RepMMod.GetDSSStr("lock"), false, function(clickCount)
			for _, ach in pairs(RepMMod.RepmAchivements) do
				Isaac.ExecuteCommand("lockachievement " .. ach.ID)
			end
		end)
	)
	table.insert(tab, function(parentID, id)
		for name, ach in pairs(RepMMod.RepmAchivements) do
			ig.AddCheckbox(parentID, MakeElementName(parentID, id, ach.Name), ach.Name, function(newVal)
				if newVal then
					Isaac.GetPersistentGameData():TryUnlock(ach.ID, false)
				else
					Isaac.ExecuteCommand("lockachievement " .. ach.ID)
				end
			end, false)
			ig.AddCallback(MakeElementName(parentID, id, ach.Name), ImGuiCallback.Render, function()
				ig.UpdateData(
					MakeElementName(parentID, id, ach.Name),
					ImGuiData.Value,
					Isaac.GetPersistentGameData():Unlocked(ach.ID)
				)
			end)
		end
	end)
	return tab
end

local menus = {
	["Music"] = {
		[RepMMod.GetDSSStr("music_manager")] = {
			imguiFuncs.AddButton(RepMMod.GetDSSStr("enable"), false, function(clickCount)
				for musicId, name in pairs(music) do
					RepMMod.saveTable.MusicData.Music[name] = 1
					RepMMod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), true)
				end
				for jingleId, name in pairs(jingle) do
					RepMMod.saveTable.MusicData.Jingle[name] = 1
				end
				RepMMod.StoreSaveData()
			end),
			imguiFuncs.SetHelpMarker(RepMMod.GetDSSStr("music_button_enable")),
			imguiFuncs.AddButton(RepMMod.GetDSSStr("disable"), false, function(clickCount)
				for musicId, name in pairs(music) do
					RepMMod.saveTable.MusicData.Music[name] = 2
					RepMMod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), false)
				end
				for jingleId, name in pairs(jingle) do
					RepMMod.saveTable.MusicData.Jingle[name] = 2
				end
				RepMMod.StoreSaveData()
			end),
			imguiFuncs.SetHelpMarker(RepMMod.GetDSSStr("music_button_disable")),
			[RepMMod.GetDSSStr("music_settings")] = {
				function(parentId, idx)
					for musicId, name in pairs(music) do
						if not RepMMod.saveTable.MusicData.Music[name] then
							RepMMod.saveTable.MusicData.Music[name] = 1
						end
						ig.AddCheckbox(
							parentId,
							MakeElementName(parentId, idx, name:sub(21)),
							name:sub(21),
							function(newVal)
								local id, id2 = musicId, Isaac.GetMusicIdByName(name)
								RepMMod.saveTable.MusicData.Music[name] = newVal and 1 or 2
								if not newVal then
									id, id2 = Isaac.GetMusicIdByName(name), musicId
								end
								if id == MusicManager():GetCurrentMusicID() then
									MusicManager():Play(id2, Options.MusicVolume)
									Isaac.SetCurrentFloorMusic(id2)
								end
								RepMMod.StoreSaveData()
							end,
							false
						)
						ig.AddCallback(MakeElementName(parentId, idx, name:sub(21)), ImGuiCallback.Render, function()
							ig.UpdateData(
								MakeElementName(parentId, idx, name:sub(21)),
								ImGuiData.Value,
								RepMMod.saveTable.MusicData.Music[name] == 1
							)
						end)
					end
				end,
			},
			[RepMMod.GetDSSStr("jingle_settings")] = {
				function(parentId, idx)
					for jingleId, name in pairs(jingle) do
						if not RepMMod.saveTable.MusicData.Jingle[name] then
							RepMMod.saveTable.MusicData.Jingle[name] = 1
						end
						ig.AddCheckbox(
							parentId,
							MakeElementName(parentId, idx, name:sub(21)),
							name:sub(21),
							function(newVal)
								RepMMod.saveTable.MusicData.Jingle[name] = newVal and 1 or 2
								RepMMod.StoreSaveData()
							end,
							true
						)

						ig.AddCallback(MakeElementName(parentId, idx, name:sub(21)), ImGuiCallback.Render, function()
							ig.UpdateData(
								MakeElementName(parentId, idx, name:sub(21)),
								ImGuiData.Value,
								RepMMod.saveTable.MusicData.Jingle[name] == 1
							)
						end)
					end
				end,
			},
		},
	},
	["Settings"] = {
		[RepMMod.GetDSSStr("other_settings")] = {
			function(parentId, id)
				ig.AddCheckbox(
					parentId,
					MakeElementName(parentId, id, RepMMod.GetDSSStr("happy_start")),
					RepMMod.GetDSSStr("happy_start"),
					function(newVal)
						RepMMod.saveTable.MenuData.StartThumbsUp = newVal and 1 or 2
						RepMMod.StoreSaveData()
					end,
					true
				)
				ig.AddCallback(MakeElementName(parentId, id, RepMMod.GetDSSStr("happy_start")), ImGuiCallback.Render, function()
					ig.UpdateData(MakeElementName(parentId, id, RepMMod.GetDSSStr("happy_start")), ImGuiData.Value, RepMMod.saveTable.MenuData.StartThumbsUp == 1)
				end)
			end,
		},
	},
	["Achievements"] = InitAchievementMenu(),
	["Debug"] = {
		
	},
}

local menuNames = {
	["Settings"] = "\u{f1de} " .. RepMMod.GetDSSStr("settings"),
	["Music"] = "Music Settings",
	["Debug"] = "\u{f085} Debug",
	["Achievements"] = RepMMod.GetDSSStr("unlock_manager"),
}

local function CheckSoundtrackMenu()
	if SoundtrackSongList then
		AddSoundtrackToMenu("Repentance Negative")
	else
		local function MusicSwitcher(_, id, volumeFade, isFade)
			local newId = id
			if
				MusicTable[id]
				and Isaac.GetMusicIdByName(MusicTable[id]) ~= -1
				and RepMMod.saveTable.MusicData.Music[MusicTable[id]] == 1
			then
				newId = Isaac.GetMusicIdByName(MusicTable[id])
			end
			return newId
		end
		RepMMod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, MusicSwitcher)

		local function JingleSwitcher(_, id)
			local newId = id
			if
				JingleTable[id]
				and Isaac.GetMusicIdByName(JingleTable[id]) ~= -1
				and RepMMod.saveTable.MusicData.Jingle[JingleTable[id]] == 1
			then
				newId = Isaac.GetMusicIdByName(JingleTable[id])
			end
			return newId
		end
		RepMMod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY_JINGLE, JingleSwitcher)
	end
end
RepMMod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, CheckSoundtrackMenu)

local root = "RepMMod"

RemoveElement(root, ImGuiElement.Menu)
ig.CreateMenu(root, "Repnetance-")

for menuName, menu in pairs(menus) do
	RemoveElement(MakeElementName(root, menuName), ImGuiElement.Menu)
	ig.AddElement(root, MakeElementName(root, menuName), ImGuiElement.MenuItem, menuNames[menuName])
	RemoveElement(MakeElementName(root, menuName, "Window"), ImGuiElement.Window)
	ig.CreateWindow(MakeElementName(root, menuName, "Window"), menuName)
	ig.LinkWindowToElement(MakeElementName(root, menuName, "Window"), MakeElementName(root, menuName))
	AddElements(root, MakeElementName(menuName, "Window"), menu)
end
