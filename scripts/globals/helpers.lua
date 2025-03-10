local mod = RepMMod
local json = require("json")

function mod.Filter(toFilter, predicate)
	local filtered = {}

	for index, value in pairs(toFilter) do
		if predicate(index, value) then
			filtered[#filtered + 1] = value
		end
	end

	return filtered
end

function mod.Lerp(a, b, t)
	t = t or 0.2
	return a + (b - a) * t
end

function mod.GetPlayers(...)
	local players = {}
	local playertypes = { ... }
	if #playertypes == 0 then
		return PlayerManager.GetPlayers()
	end
	for _, playertype in ipairs(playertypes) do
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:GetPlayerType() == playertype then
				table.insert(players, player)
			end
		end
	end
	return players
end

function mod.GetPlayersWithout(...)
	local players = {}
	local playertypes = { ... }
	if #playertypes > 0 then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			local add = true
			for _, playertype in ipairs(playertypes) do
				if player:GetPlayerType() ~= playertype then
					add = false
					break
				end
			end
			if add then
				table.insert(players, player)
			end
		end
	end
	return players
end

function mod.GetMenuSaveData()
	if not mod.saveTable.MenuData then
		if mod:HasData() then
			mod.saveTable.MenuData = json.decode(mod:LoadData()).MenuData or {}
		else
			mod.saveTable.MenuData = {}
		end
	end
	return mod.saveTable.MenuData
end

function mod.StoreSaveData()
	if Isaac.IsInGame() then
		local jsonString = json.encode(mod.saveTable)
		mod:SaveData(jsonString)
	else
		local saveTable = json.decode(mod:LoadData())
		saveTable.MenuData = mod.saveTable.MenuData
		saveTable.MusicData = mod.saveTable.MusicData
		mod:SaveData(json.encode(saveTable))
	end
end

function mod.TearsUp(firedelay, val, limit) --Скорострельность вычисляется через эту формулу
	limit = type(limit) == "number" and math.max(-0.75, limit) or -0.75
	return mod.TearsToFireDelay(math.max(limit, mod.FireDelayToTears(firedelay) + val))
end

function mod.FireDelayToTears(firedelay)
	return 30 / (firedelay + 1)
end

function mod.TearsToFireDelay(tears)
	return (30 / tears) - 1
end

function mod.GetTrueRange(player)
	return player.Range / 40.0
end

function mod.RangeUp(range, val)
	local currentRange = range / 40.0
	local newRange = currentRange + val
	return math.max(1.0, newRange) * 40.0
end

function mod.IsBaby(variant)
	return variant == FamiliarVariant.INCUBUS
		or variant == FamiliarVariant.TWISTED_BABY
		or variant == FamiliarVariant.BLOOD_BABY
		or variant == FamiliarVariant.CAINS_OTHER_EYE
		or variant == FamiliarVariant.UMBILICAL_BABY
		or variant == FamiliarVariant.SPRINKLER
end

function mod:GetPlayerFromTear(tear)
	for i = 1, 2 do
		local check = nil
		if i == 1 then
			check = tear.Parent
		elseif i == 2 then
			check = tear.SpawnerEntity
		end
		if check then
			if check.Type == EntityType.ENTITY_PLAYER then
				return check:ToPlayer(), nil
			elseif check.Type == EntityType.ENTITY_FAMILIAR and mod.IsBaby(check.Variant) then
				local data = tear:GetData()
				data.IsIncubusTear = true
				return check:ToFamiliar().Player:ToPlayer(), check:ToFamiliar()
			end
		end
	end
	return nil, nil
end

function mod:getPlayerFromKnifeLaser(entity)
	if entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() then
		return entity.SpawnerEntity:ToPlayer()
	elseif entity.SpawnerEntity and entity.SpawnerEntity:ToFamiliar() and entity.SpawnerEntity:ToFamiliar().Player then
		local familiar = entity.SpawnerEntity:ToFamiliar()

		if mod.IsBaby(familiar.Variant) then
			return familiar.Player
		else
			return nil
		end
	else
		return nil
	end
end

function mod:GetData(entity)
	local data = entity:GetData()
	data.RepMinus = data.RepMinus or {}
	return data.RepMinus
end

function mod:repmGetPData(player)
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
		player = player:GetOtherTwin()
	end
	if not player then
		return nil
	end
	local cIdx = player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B and 2 or 1
	local index = tostring(player:GetCollectibleRNG(cIdx):GetSeed())
	if not mod.saveTable.PlayerData[index] then
		mod.saveTable.PlayerData[index] = {}
	end
	return mod.saveTable.PlayerData[index]
end

function mod.GetByQuality(min, max, pool, rnd, descrease)
	local Itempool = Game():GetItemPool()
	descrease = type(descrease) ~= "nil" and descrease or true
    while min >= 0 do
        local rng = type(rnd) == "number" and RNG(rnd) or rnd
        rng:Next()
        for i = 1, 100 do
            local new = Itempool:GetCollectible(pool, false, rng:GetSeed())
            local data = Isaac.GetItemConfig():GetCollectible(new)
            if data.Quality and data.Quality >= min and data.Quality <= max then
				if descrease then
					Itempool:RemoveCollectible(new)
				end
                return new
            end
            rng:Next()
        end
        min = min - 1
    end
end

local function doRunInitFirstCallback()
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	local roomDesc = level:GetCurrentRoomDesc()

	local roomFrameCount = room:GetFrameCount()
	local visitedCount = roomDesc.VisitedCount

	return roomFrameCount > 0 or visitedCount == 0
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, CallbackPriority.LATE, function(_, pickup)
	if doRunInitFirstCallback() then
		Isaac.RunCallbackWithParam("REPM_PICKUP_INIT_FIRST", pickup.Variant, pickup)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_SLOT_INIT, CallbackPriority.LATE, function(_, slot)
	if doRunInitFirstCallback() then
		Isaac.RunCallbackWithParam("REPM_SLOT_INIT_FIRST", slot.Variant, slot)
	end
end)