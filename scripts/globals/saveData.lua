local mod = RepMMod
local json = require("json")
local game = Game()

mod.saveTable = mod.saveTable or {}
mod.saveTable.Minimap = {}
mod.saveTable.MenuData = RepMMod.saveTable.MenuData or {}
mod.saveTable.MenuData.StartThumbsUp = RepMMod.saveTable.MenuData.StartThumbsUp or 1
mod.saveTable.PlayerData = mod.saveTable.PlayerData or {}
mod.saveTable.MusicData = mod.saveTable.MusicData or {}
mod.saveTable.MusicData.Music = mod.saveTable.MusicData.Music or {}
mod.saveTable.MusicData.Jingle = mod.saveTable.MusicData.Jingle or {}
mod.saveTable.GlobalSeed = mod.saveTable.GlobalSeed or Random()
mod.saveTable.PortalD6 = mod.saveTable.PortalD6 or {}
mod.saveTable.PortalD6Use = mod.saveTable.PortalD6Use or 0
mod.RNG = RNG()

local function saveData(_, isSaving)
	if isSaving then
		mod.saveTable.Repm_CHAPIData = CustomHealthAPI.Library.GetHealthBackup()
        mod.saveTable.GlobalSeed = mod.RNG:GetSeed()
	end
	if MinimapAPI.BranchVersion == "RepentanceNegative" then
		mod.saveTable.Minimap = MinimapAPI:GetSaveTable(isSaving)
	end
	local jsonString = json.encode(mod.saveTable)
	mod:SaveData(jsonString)
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, saveData)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	saveData(_, true)
end)

local function loadData(_, isLoad)
	mod:AnyPlayerDo(function(player)
        mod:GetData(player).DiliriumEyeLastActivateFrame = 0
    end)
	if mod:HasData() then
		local perData = json.decode(mod:LoadData())
		if perData.MenuData then
			mod.saveTable.MenuData = perData.MenuData
		end
		if perData.MusicData then
			mod.saveTable.MusicData = perData.MusicData
		end
	end
	if mod:HasData() and isLoad then
		mod.saveTable = json.decode(mod:LoadData())
		CustomHealthAPI.Library.LoadHealthFromBackup(mod.saveTable.Repm_CHAPIData)
		if MinimapAPI.BranchVersion == "RepentanceNegative" and mod.saveTable.Minimap.Config then
			MinimapAPI:LoadSaveTable(mod.saveTable.Minimap, isLoad)
		end
	else
        mod.saveTable.GlobalSeed = game:GetSeeds():GetStartSeed()
		mod.saveTable.Minimap = {}
		mod.saveTable.PlayerData = {}
		mod.saveTable.PortalD6 = {}
		mod.saveTable.PortalD6Use = 0
		mod.saveTable.saveTimer = nil
		mod.saveTable.RedLightSign = "GreenLight"
		mod:AnyPlayerDo(function(player)
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end)
		mod.saveTable.SimAxesCollected = 1
	end
	Isaac.RunCallback("REPM_RESET_LOCAL_VALUES", isLoad)
    mod.RNG:SetSeed(mod.saveTable.GlobalSeed, 35)
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, loadData)

mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function()
	if mod:HasData() then
		local perData = json.decode(mod:LoadData())
		if perData.MenuData then
			mod.saveTable.MenuData = perData.MenuData
		end
		if perData.MusicData then
			mod.saveTable.MusicData = perData.MusicData
		end
	end
end)