local mod = RepMMod

local function updateCache_AllStats(_, player, cacheFlag)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetPlayerType() == mod.RepmTypes.CHARACTER_MINUSAAC then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 0.7
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + 1
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.2
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = mod.TearsUp(player.MaxFireDelay, 1)
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + 40 * 0.5
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, updateCache_AllStats)

local Minusaac = { -- Change Minusaac everywhere to match your character. No spaces!
	DAMAGE = 0.7, -- These are all relative to Isaac's base stats.
	SPEED = 0.2,
	SHOTSPEED = -2.90,
	TEARHEIGHT = -1,
	TEARFALLINGSPEED = 3,
	LUCK = 1,
	FLYING = false,
	TEARFLAG = 0, -- 0 is default
	TEARCOLOR = Color(1.0, 0.2, 0.2, 1.0, 1, 0, -0.5), -- Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0) is default
}

function mod:onCache_Minus(player, cacheFlag) -- I do mean everywhere!
	if player:GetName() == "Minusaac" then -- Especially here!
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + Minusaac.DAMAGE
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + Minusaac.SHOTSPEED
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearHeight = player.TearHeight - Minusaac.TEARHEIGHT
			player.TearFallingSpeed = player.TearFallingSpeed + Minusaac.TEARFALLINGSPEED
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + Minusaac.SPEED
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + Minusaac.LUCK
		end
		if cacheFlag == CacheFlag.CACHE_FLYING and Minusaac.FLYING then
			player.CanFly = true
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | Minusaac.TEARFLAG
		end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache_Minus)

function mod:AlterTearColor(tear)
	local player = mod:GetPlayerFromTear(tear)
	if player and player:GetName() == "Minusaac" and tear.FrameCount == 0 then
		tear:GetSprite().Color:SetColorize(1, 0, 0, 1)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.AlterTearColor)

function AddFlag(...)
	local ToReturn = 0
	for _, a in pairs({ ... }) do
		ToReturn = ToReturn + (1 << a)
	end
	return ToReturn
end

local Minusaac = Isaac.GetPlayerTypeByName("Minusaac")
---@param Player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, Player)
	if Player:GetPlayerType() ~= Minusaac then
		return
	end
	local pdata = mod:repmGetPData(Player)
end)

--if player:GetName() == "Minusaac" then
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
	if player:GetName() == "Minusaac" then
		player:AddCollectible(mod.RepmTypes.COLLECTIBLE_BLOODY_NEGATIVE)
	end
end)

---@param Player EntityPlayer
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, Player)
	if Player:GetPlayerType() ~= Minusaac then
		return
	end
	if Player:GetEffectiveMaxHearts() > 2 or (Player:GetEffectiveMaxHearts() > 0 and Player:GetSoulHearts() > 0) then
		Player:AddMaxHearts(-2)
	elseif Player:GetSoulHearts() > 4 or (Player:GetEffectiveMaxHearts() > 0 and Player:GetSoulHearts() >= 4) then
		Player:AddSoulHearts(-4)
	elseif Player:GetBlackHearts() > 4 or (Player:GetEffectiveMaxHearts() > 0 and Player:GetBlackHearts() >= 4) then
		Player:AddBlackHearts(-4)
	else
		return
	end
	for i = 1, 8 do
		Isaac.Spawn(
			EntityType.ENTITY_EFFECT,
			EffectVariant.BLOOD_PARTICLE,
			0,
			Player.Position,
			Vector(0, math.random(0, 5)):Rotated(math.random(360)),
			nil
		)
		Player:SetMinDamageCooldown(90)
	end
	local Data = mod:repmGetPData(Player)
	local birthNum = Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	Data.Bloody_MoveSpeed = (Data.Bloody_MoveSpeed or 0) + 0.15 + (0.3 * birthNum)
	Data.Bloody_Damage = (Data.Bloody_Damage or 0) + 0.2 + (0.3 * birthNum)
	Data.Bloody_MaxFireDelay = math.min((Data.Bloody_MaxFireDelay or 0) + 0.75 + (0.3 * birthNum), 5)
	Data.Bloody_TearRange = (Data.Bloody_TearRange or 0) + 8 + (24 * birthNum)
	Player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	return true
end, mod.RepmTypes.COLLECTIBLE_BLOODY_NEGATIVE)

---@param Player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, Player, Cache)
	if Player:GetPlayerType() ~= Minusaac then
		return
	end
	local Data = mod:repmGetPData(Player)
	if Cache == CacheFlag.CACHE_SPEED then
		Player.MoveSpeed = Player.MoveSpeed + (Data.Bloody_MoveSpeed or 0)
	end
	if Cache == CacheFlag.CACHE_DAMAGE then
		Player.Damage = Player.Damage + (Data.Bloody_Damage or 0)
	end
	if Cache == CacheFlag.CACHE_FIREDELAY then
		Player.MaxFireDelay = mod.TearsUp(player.MaxFireDelay, (Data.Bloody_MaxFireDelay or 0))
	end
	if Cache == CacheFlag.CACHE_RANGE then
		Player.TearRange = Player.TearRange + (Data.Bloody_TearRange or 0)
	end
end)

---@type ModReference
---@param Entity Entity
---@param DamageFlags DamageFlag
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, Entity, _, DamageFlags)
	---@type EntityPlayer
	local Player = Entity:ToPlayer()
	if
		DamageFlags == AddFlag(7, 28)
		or DamageFlags == AddFlag(16, 28)
		or DamageFlags == AddFlag(5, 13)
		or DamageFlags == AddFlag(5, 21)
		or DamageFlags == AddFlag(5, 13, 18)
		or DamageFlags == AddFlag(2, 28, 30)
		or DamageFlags == AddFlag(2, 28, 30)
		or DamageFlags == AddFlag(5)
		or Player:GetPlayerType() ~= Minusaac
		or Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	then
		return
	end
	local Data = mod:repmGetPData(Player)
	Data.Bloody_MoveSpeed = (Data.Bloody_MoveSpeed or 0) - 0.1
	Data.Bloody_Damage = (Data.Bloody_Damage or 0) - 0.15
	Data.Bloody_MaxFireDelay = (Data.Bloody_MaxFireDelay or 0) - 0.65
	Data.Bloody_TearRange = (Data.Bloody_TearRange or 0) - 6
	Player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
end, EntityType.ENTITY_PLAYER)