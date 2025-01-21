local mod = RepMMod

local function updateCache_AllStats(_, player, cacheFlag)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and mod.RepmTypes.CHARACTER_MINUSAAC then
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