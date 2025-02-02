local mod = RepMMod

local function onCache(_, player, flag)
	if player:HasTrinket(mod.RepmTypes.TRINKET_HAMMER) then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_ACID
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, onCache, CacheFlag.CACHE_TEARFLAG)