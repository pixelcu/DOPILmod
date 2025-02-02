local mod = RepMMod
local hiddenItemManager = require("scripts.lib.hidden_item_manager")

local function LazerColor(_, player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
			player.LaserColor = Color(0, 0, 0, 1, 215, 95, 25)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LazerColor, CacheFlag.CACHE_TEARCOLOR)

local tech1Flags = {
	TearFlags.TEAR_SLOW,
	TearFlags.TEAR_HOMING,
	TearFlags.TEAR_POISON,
	TearFlags.TEAR_SPLIT,
	TearFlags.TEAR_FREEZE,
	TearFlags.TEAR_GROW,
	TearFlags.TEAR_BOOMERANG,
	TearFlags.TEAR_PERSISTENT,
	TearFlags.TEAR_WIGGLE,
	TearFlags.TEAR_MULLIGAN,
	TearFlags.TEAR_EXPLOSIVE,
	TearFlags.TEAR_CONFUSION,
	TearFlags.TEAR_CHARM,
	TearFlags.TEAR_ORBIT,
	TearFlags.TEAR_WAIT,
	TearFlags.TEAR_QUADSPLIT,
	TearFlags.TEAR_BOUNCE,
	TearFlags.TEAR_FEAR,
	TearFlags.TEAR_SHRINK,
	TearFlags.TEAR_BURN,
	TearFlags.TEAR_KNOCKBACK,
	TearFlags.TEAR_SPIRAL,
	TearFlags.TEAR_SQUARE,
	TearFlags.TEAR_GLOW,
	TearFlags.TEAR_GISH,
	TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
	TearFlags.TEAR_STICKY,
	TearFlags.TEAR_CONTINUUM,
	TearFlags.TEAR_LIGHT_FROM_HEAVEN,
	TearFlags.TEAR_TRACTOR_BEAM,
	TearFlags.TEAR_BIG_SPIRAL,
	TearFlags.TEAR_BOOGER,
	TearFlags.TEAR_ACID,
	TearFlags.TEAR_BONE,
	TearFlags.TEAR_JACOBS,
	TearFlags.TEAR_LASER,
	TearFlags.TEAR_POP,
	TearFlags.TEAR_ABSORB,
	TearFlags.TEAR_HYDROBOUNCE,
	TearFlags.TEAR_BURSTSPLIT,
	TearFlags.TEAR_PUNCH,
	TearFlags.TEAR_ORBIT_ADVANCED,
	TearFlags.TEAR_TURN_HORIZONTAL,
	TearFlags.TEAR_ECOLI,
	TearFlags.TEAR_RIFT,
	TearFlags.TEAR_TELEPORT,
}

local function tearFire_Diltech(_, t)
	local d = t:GetData()
	local player = t.SpawnerEntity
		and (t.SpawnerEntity:ToPlayer() or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player)
	if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
		local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
		local chance = rng:RandomInt(50)
		if chance >= 25 then
			local lazer = player:FireTechLaser(t.Position, 0, t.Velocity, false, true, player)
		else
			local lazer = player:FireTechXLaser(t.Position, t.Velocity, 50, player)
		end

		t:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, tearFire_Diltech)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod:AnyPlayerDo(function(p)
		mod:GetData(p).TBOIREP_Minus_DilliriumTech = p:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
			:RandomInt(2) + 1
	end)
end)

local laserTypes = {
	[0] = CollectibleType.COLLECTIBLE_TECH_X,
	[1] = CollectibleType.COLLECTIBLE_BRIMSTONE,
	[2] = CollectibleType.COLLECTIBLE_TECHNOLOGY,
	[3] = CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
	[4] = CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
	[5] = CollectibleType.COLLECTIBLE_TECH_5,
}

local function deliriousTechLaserSwitch(_, player)
	if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) and Game():GetFrameCount() % 30 == 0 then
		local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
		local data = mod:repmGetPData(player)
		if rng:RandomInt(100) > 94 or data.DelirousTechState == nil then
			if data.DelirousTechState ~= nil then
				hiddenItemManager:Remove(player, data.DelirousTechState, hiddenItemManager.kDefaultGroup)
			end
			local num = rng:RandomInt(6)
			local selectedNum = laserTypes[num]
			data.DelirousTechState = selectedNum
			hiddenItemManager:Add(player, selectedNum)
			if not player:HasCollectible(selectedNum, true) then
				local costConfig = config:GetCollectible(selectedNum)
				player:RemoveCostume(costConfig)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, deliriousTechLaserSwitch)

local function checkLaser_DelTech(_, laser)
	local player = mod:getPlayerFromKnifeLaser(laser)
	local pdata = player and mod:repmGetPData(player)
	local data = laser:GetData()
	local var = laser.Variant
	local subt = laser.SubType
	local ignoreLaserVar = ((var == 1 and subt == 3) or var == 5 or var == 12)
	if laser.Type == EntityType.ENTITY_EFFECT then
		ignoreLaserVar = false
	end

	if player and not ignoreLaserVar then
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
			--local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
			--if laser.Type == EntityType.ENTITY_EFFECT and laser.Variant == EffectVariant.BRIMSTONE_SWIRL then
			--end
			data.RandomizeDelLaserEffect = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, checkLaser_DelTech)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, checkLaser_DelTech, EffectVariant.BRIMSTONE_BALL)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, checkLaser_DelTech, EffectVariant.BRIMSTONE_SWIRL)

local function updateLasersPlayer_DelTech(_, player)
	local lasers = Isaac.FindByType(EntityType.ENTITY_LASER)
	local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
	for i = 1, #lasers do
		local laser = lasers[i]
		if laser:GetData().RandomizeDelLaserEffect == true then
			laser:GetData().RandomizeDelLaserEffect = false
			laser:ToLaser():AddTearFlags(tech1Flags[rng:RandomInt(#tech1Flags) + 1])
		end
	end

	--local brimballs = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_BALL)
	--for i=1, #brimballs do
	--local brimball = brimballs[i]
	--if brimball:GetData().RandomizeDelLaserEffect == true then
	--brimball:GetData().RandomizeDelLaserEffect = false
	--brimball:AddTearFlags(tech1Flags[rng:RandomInt(#tech1Flags)+1])
	--end
	--end

	--local brimswirls = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL)
	--for i=1, #brimswirls do
	--local brimswirl = brimswirls[i]
	--if brimswirl:GetData().RandomizeDelLaserEffect == true then
	--brimswirl:GetData().RandomizeDelLaserEffect = false
	--brimswirl:AddTearFlags(tech1Flags[rng:RandomInt(#tech1Flags)+1])
	--end
	--end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, updateLasersPlayer_DelTech)