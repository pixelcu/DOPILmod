local mod = RepMMod
local game = Game()
local prefix = "Repentance Negative "
local json = require("json")

local MusicTable = {
	[Music.MUSIC_CELLAR] = prefix .. "Cellar",
	[Music.MUSIC_BURNING_BASEMENT] = prefix .. "Burning Basement",
	[Music.MUSIC_CAVES] = prefix .. "Caves",
	[Music.MUSIC_DEPTHS] = prefix .. "Depths",
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

if mod:HasData() then
	local save = json.decode(mod:LoadData())
	if save.MusicData then
		mod.saveTable.MusicData = save.MusicData
	end
end

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
		mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, MusicSwitcher)

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
		mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY_JINGLE, JingleSwitcher)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, CheckSoundtrackMenu)

function mod.GetModdedMusicTable()
	return MusicTable, JingleTable
end

function mod.ChangeFloorMusicTo(id, id2, change)
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

local ig = ImGui

local music, jingle = MusicTable, JingleTable

if not ig.ElementExists("RepMMod") then
	ig.CreateMenu("RepMMod", "Repentance-")
end

if not ig.ElementExists("RepMModSettings") then
	ig.AddElement("RepMMod", "RepMModSettings", ImGuiElement.MenuItem, RepMMod.GetDSSStr("settings"))
end

if not ig.ElementExists("RepMModSettingsWindow") then
	ig.CreateWindow("RepMModSettingsWindow", "Repentance- "..RepMMod.GetDSSStr("settings"))
end

ig.LinkWindowToElement("RepMModSettingsWindow", "RepMModSettings")

if ig.ElementExists("RepMModSettingsTabBar") then
	ig.RemoveElement("RepMModSettingsTabBar")
end

ig.AddElement("RepMModSettingsWindow", "RepMModSettingsTabBar", ImGuiElement.TabBar)
ig.AddElement("RepMModSettingsTabBar", "RepMModSettingsTabMusic", ImGuiElement.Tab, RepMMod.GetDSSStr("music_manager"))
ig.AddButton(
	"RepMModSettingsTabMusic",
	"RepMModSettingsTabMusicButtonEnable",
	RepMMod.GetDSSStr("enable"),
	function(clickCount)
		for musicId, name in pairs(music) do
			RepMMod.saveTable.MusicData.Music[name] = 1
			mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), true)
		end
		for jingleId, name in pairs(jingle) do
			RepMMod.saveTable.MusicData.Jingle[name] = 1
		end
		mod.StoreSaveData()
	end
)
ig.SetTooltip("RepMModSettingsTabMusicButtonEnable", RepMMod.GetDSSStr("music_button_enable"))
ig.AddButton(
	"RepMModSettingsTabMusic",
	"RepMModSettingsTabMusicButtonDisable",
	RepMMod.GetDSSStr("disable"),
	function(clickCount)
		for musicId, name in pairs(music) do
			RepMMod.saveTable.MusicData.Music[name] = 2
			mod.ChangeFloorMusicTo(musicId, Isaac.GetMusicIdByName(name), false)
		end
		for jingleId, name in pairs(jingle) do
			RepMMod.saveTable.MusicData.Jingle[name] = 2
		end
		mod.StoreSaveData()
	end
)
ig.SetTooltip("RepMModSettingsTabMusicButtonDisable", RepMMod.GetDSSStr("music_button_disable"))
ig.AddElement("RepMModSettingsTabMusic", "RepMModSettingsTabBarMusicManager", ImGuiElement.TabBar)

ig.AddElement(
	"RepMModSettingsTabBarMusicManager",
	"RepMModSettingsTabBarMusicTab",
	ImGuiElement.Tab,
	RepMMod.GetDSSStr("music_settings")
)
ig.AddElement(
	"RepMModSettingsTabBarMusicManager",
	"RepMModSettingsTabBarJingleTab",
	ImGuiElement.Tab,
	RepMMod.GetDSSStr("jingle_settings")
)

for musicId, name in pairs(music) do
	if not RepMMod.saveTable.MusicData.Music[name] then
		RepMMod.saveTable.MusicData.Music[name] = 1
	end
	ig.AddCheckbox(
		"RepMModSettingsTabBarMusicTab",
		"RepMModSettingsTabBarMusicTab" .. name:sub(21),
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
			mod.StoreSaveData()
		end,
		false
	)
	ig.AddCallback("RepMModSettingsTabBarMusicTab" .. name:sub(21), ImGuiCallback.Render, function()
		ig.UpdateData(
			"RepMModSettingsTabBarMusicTab" .. name:sub(21),
			ImGuiData.Value,
			RepMMod.saveTable.MusicData.Music[name] == 1
		)
	end)
end

for jingleId, name in pairs(jingle) do
	if not RepMMod.saveTable.MusicData.Jingle[name] then
		RepMMod.saveTable.MusicData.Jingle[name] = 1
	end
	ig.AddCheckbox(
		"RepMModSettingsTabBarJingleTab",
		"RepMModSettingsTabBarJingleTab" .. name:sub(21),
		name:sub(21),
		function(newVal)
			RepMMod.saveTable.MusicData.Jingle[name] = newVal and 1 or 2
			mod.StoreSaveData()
		end,
		true
	)

	ig.AddCallback("RepMModSettingsTabBarJingleTab" .. name:sub(21), ImGuiCallback.Render, function()
		ig.UpdateData(
			"RepMModSettingsTabBarJingleTab" .. name:sub(21),
			ImGuiData.Value,
			RepMMod.saveTable.MusicData.Jingle[name] == 1
		)
	end)
end

ig.AddElement("RepMModSettingsTabBar", "RepMModSettingsTabMisc", ImGuiElement.Tab, RepMMod.GetDSSStr("other_settings"))

ig.AddCheckbox(
	"RepMModSettingsTabMisc",
	"RepMModSettingsTabMiscHappyStart",
	RepMMod.GetDSSStr("happy_start"),
	function(newVal)
		RepMMod.saveTable.MenuData.StartThumbsUp = newVal and 1 or 2
		mod.StoreSaveData()
	end,
	true
)

ig.AddCallback("RepMModSettingsTabMiscHappyStart", ImGuiCallback.Render, function()
	ig.UpdateData("RepMModSettingsTabMiscHappyStart", ImGuiData.Value, RepMMod.saveTable.MenuData.StartThumbsUp == 1)
end)
