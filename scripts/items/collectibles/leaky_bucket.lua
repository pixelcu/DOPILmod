local mod = RepMMod

--[[ Checks whether or not you have the item and deals w/ initialization
local function UpdateFaucet(player)
	HasLeakyFaucet = player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET)
end

function mod:onPlayerInit(player)
	UpdateFaucet(player)
end

--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,  mod.onPlayerInit)
]]

-- Gives the Tears buff
local function cacheUpdate(_, player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET) then
			if player.MaxFireDelay >= 7 then
				player.MaxFireDelay = mod.TearsUp(player.MaxFireDelay, 2)
			elseif player.MaxFireDelay >= 5 then
				player.MaxFireDelay = 5
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, cacheUpdate)

-- Randomly spawns Holy Water creep
local function onUpdate_LeakyFaucet(_, player)
	local pos = player.Position
	-- Beginning of run initialization
	-- if game:GetFrameCount() == 1 then
	-- Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetItemIdByName("Leaky Faucet"), Vector(320,300), Vector(0,0), nil)
	-- That super long line is how to spawn the item in the starting room. Comment it if you don't want it.
	-- end
	if not HasLeakyFaucet and player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET) then
		HasLeakyFaucet = true
	end
	if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET) and math.random(100) == 1 then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER, 0, pos, Vector(0, 0), player)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onUpdate_LeakyFaucet)