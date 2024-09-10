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
		Isaac.SetCurrentFloorMusic(id2)
	end
end
