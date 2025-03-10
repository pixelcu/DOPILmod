local mod = RepMMod

local function onPlayerUpdate_Like(_, player)
	if
		player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LIKE)
		and player:GetSprite():GetAnimation() == "Happy"
		and player:GetSprite():GetFrame() == 0
	then
		local pdata = mod:repmGetPData(player)
		pdata.Like_AllBonus = (pdata.Like_AllBonus or 0) + 0.5
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onPlayerUpdate_Like)

local function likeCache(_, player, cacheFlag)
	local pdata = mod:repmGetPData(player)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage + (0.4 * (pdata.Like_AllBonus or 0))
	elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
		local tearstoadd = (0.4 * (pdata.Like_AllBonus or 0))
		player.MaxFireDelay = mod.TearsUp(player.MaxFireDelay, tearstoadd)
	elseif cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + (0.4 * (pdata.Like_AllBonus or 0))
	elseif cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + (0.4 * (pdata.Like_AllBonus or 0))
	elseif cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + (40 * (pdata.Like_AllBonus or 0))
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, likeCache)
