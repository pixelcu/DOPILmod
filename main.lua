--[[Итак мамкины программисты, кто решил залесть в код мода, то не удивляйтесь его странному оформлению и как он странно написан. 
    Если кто-то шарит за код, то это мой первый опыт]]
--[[So mom’s programmers, who decided to get into the mod’s code, don’t be surprised at its strange design and how strangely it is written.
    If anyone is looking for code, this is my first experience]]

local mod = RegisterMod("RepentanceNegative", 1.0)
RepMMod = mod
local json = require("json")
local game = Game()
local version = ": 1.3" --added by me (pedro), for making updating version number easier
local newRoomFreeze = false

if not REPENTOGON then
	error("REPENTOGON not installed, please download REPENTOGON!")
	return
end
print("Thanks for playing the TBOI REP NEGATIVE [Community Mod] - Currently running version" .. tostring(version))

require("scripts.minimapapi.init")
local MinimapAPI = require("scripts.minimapapi")
if MinimapAPI.BranchVersion == "RepentanceNegative" then
	MinimapAPI.DisableSaving = true
end

include("scripts.globals.saveData")
include("scripts.globals.enums")
include("scripts.globals.helpers")
include("scripts.globals.achievements")
include("scripts.lib.hellfirejuneMSHack")

include("scripts.lib.translation.dsssettings")
include("scripts.lib.customhealthapi.core")
include("scripts.lib.customhealth")
include("scripts.CEAdd")
include("scripts.repentagui")
local DSSInitializerFunction = include("scripts.lib.DSSMenu")
DSSInitializerFunction(mod)

local hiddenItemManager = require("scripts.lib.hidden_item_manager")
hiddenItemManager:Init(mod)
hiddenItemManager:HideCostumes()

include("scripts.characters.sim")
include("scripts.characters.frosty")
include("scripts.characters.t_frosty")
include("scripts.characters.minusaac")

local sfx = SFXManager()
local pgd = Isaac.GetPersistentGameData()



-- shader crash fix by AgentCucco
--[[mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		Isaac.ExecuteCommand("reloadshaders")
	end
end)]]

include("scripts.items.collectibles.advanced_kamikaze")
include("scripts.items.collectibles.sims_axe")

include("scripts.items.collectibles.holy_shell")
include("scripts.items.collectibles.book_of_tales")

include("scripts.items.collectibles.curious_heart")

include("scripts.items.collectibles.strawberry_milk")

include("scripts.items.trinkets.micro_amplifier")

include("scripts.items.collectibles.leaky_bucket")

local config = Isaac.GetItemConfig()

local function GetByQuality(min, max, pool, rnd)
	local Itempool = game:GetItemPool()
	for i = 1, 100 do
		local seed = rnd:RandomInt(1000000) + 1
		local new = Itempool:GetCollectible(pool, true, seed)
		local data = config:GetCollectible(new)
		if data.Quality and data.Quality >= min and data.Quality <= max then
			return new
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local room = game:GetRoom()
	if room:IsFirstVisit() and room:GetType() == RoomType.ROOM_TREASURE and room:GetFrameCount() < 5 then
		local hasTrink = false
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			hasTrink = hasTrink or (player:HasTrinket(mod.RepmTypes.TRINKET_BURNT_CLOVER) and player)
		end
		if hasTrink then
			local destroy
			local items = Isaac.FindByType(5, 100, -1)
			for i = 1, #items do
				local item = items[i] --and items[i].SubType
				if item then
					local data = config:GetCollectible(items[i].SubType)
					if data.Quality and data.Quality ~= 4 then
						local rng = RNG()
						rng:SetSeed(item.DropSeed, 35)
						local result = GetByQuality(4, 4, ItemPoolType.POOL_TREASURE, rng)
						if result then
							item:ToPickup():Morph(5, 100, result, true, true)
							destroy = true
						end
					end
				end
			end
			if destroy then
				local golden
				for i = 0, hasTrink:GetMaxTrinkets() - 1 do
					golden = golden
						or (
							hasTrink:GetTrinket(i)
							== mod.RepmTypes.TRINKET_BURNT_CLOVER + TrinketType.TRINKET_GOLDEN_FLAG
						)
				end
				hasTrink:TryRemoveTrinket(mod.RepmTypes.TRINKET_BURNT_CLOVER)
				if golden then
					hasTrink:AddTrinket(mod.RepmTypes.TRINKET_BURNT_CLOVER)
				end
			end
		end
	end
end)

-- get ids and stats
local Trinket = {
	DAMAGE = 0.5,
}

-- main functionality
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flag, source, countdown)
	for p = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(p)
		local multiplier = player:GetTrinketMultiplier(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)

		if player:HasTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY) then
			if entity:IsEnemy() and entity:IsActiveEnemy(true) and entity:IsVulnerableEnemy() then
				local npc = entity:ToNPC()

				if npc:IsChampion() or (npc:IsBoss() and npc:GetBossColorIdx() >= 0) then
					if (flag & DamageFlag.DAMAGE_CLONES) ~= DamageFlag.DAMAGE_CLONES then
						npc:TakeDamage( -- take the same damage, but reduced by half
							amount * math.min(1, Trinket.DAMAGE * multiplier),
							DamageFlag.DAMAGE_CLONES, -- don't create infinite loop, prevents bugs
							EntityRef(player),
							0
						)
						--[[if destroy then
								local golden
								for i = 0, hasTrink:GetMaxTrinkets() - 1 do
									golden = golden
										or (hasTrink:GetTrinket(i) == mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY + TrinketType.TRINKET_GOLDEN_FLAG)
								end
								hasTrink:TryRemoveTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)
								if golden then
									hasTrink:AddTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)
								end
							end]]
					end
				end
			end
		end
	end
end)

function mod:updateCache_Cig(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_CIGARETTE) then
			player.Damage = player.Damage + 1
		end
	end
end

--mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Cig)

local spawnPos = Vector(500, 140)
function mod:options_Wow_Room()
	local room = game:GetRoom()
	local hasTrink
	local HasSale
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		if player:HasTrinket(mod.RepmTypes.TRINKET_MORE_OPTIONS) then
			hasTrink = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
			HasSale = true
		end
	end

	if hasTrink and room:IsFirstVisit() and room:GetType() == RoomType.ROOM_SHOP then
		local Itempool = game:GetItemPool()
		local pos = Isaac.GetFreeNearPosition(spawnPos, 40)
		local rng = RNG()
		local seed = game:GetLevel():GetCurrentRoomDesc().AwardSeed
		rng:SetSeed(seed, 35)
		local ItemId = GetByQuality(3, 4, Itempool:GetPoolForRoom(RoomType.ROOM_SHOP, seed), rng)
		if ItemId then
			local obj = Isaac.Spawn(5, 100, ItemId, pos, Vector.Zero, nil):ToPickup()
			obj:Update()

			obj.Price = 30
			obj.ShopItemId = -2
			obj.AutoUpdatePrice = false
			obj:Update()
			if HasSale then
				obj.Price = 15
			end
			local poof = Isaac.Spawn(1000, 16, 1, pos, Vector.Zero, nil):ToEffect()
			poof:GetSprite().Scale = Vector(0.6, 0.6)
			poof.Color = Color(0.5, 0.5, 0.5, 1)
			SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 1, 2, false, 1, 0)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.options_Wow_Room)

local YellowColor = Color(1, 1, 1, 1)
YellowColor:SetColorize(0.9, 0.9, 0, 2)

function mod:TearDed_Banana(t)
	if t:GetData().IsBananaMilk then
		local p = Isaac.Spawn(1000, 53, 0, t.Position, Vector.Zero, t)
		local player = t.SpawnerEntity and t.SpawnerEntity:ToPlayer()
			or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player
		if player then
			p:ToEffect().Scale = math.max(0, math.min(3, player.Damage / 0))
			p:Update()
			p:Update()
			p.Color = Color(5.0, 1.0, 5.0, 1.0, 2, 0, 2)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.TearDed_Banana, EntityType.ENTITY_TEAR)

EntityType.ENTITY_DICEGARPER = Isaac.GetEntityTypeByName("Dice Garper")
DiceGarper = {
	SPEED = 0.5,
	RANGE = 200,
}
function mod:onDiceGarper(entity)
	local sprite = entity:GetSprite()
	sprite:PlayOverlay("Head", false)
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then
		data.GridCountdown = 0
	end

	if entity.State == 0 then
		if entity:IsFrame(8 / DiceGarper.SPEED, 0) then
			entity.Pathfinder:MoveRandomly(false)
		end
		if (entity.Position - target.Position):Length() < DiceGarper.RANGE then
			entity.State = 2
		end
	elseif entity.State == 2 then
		if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, DiceGarper.SPEED, 1, false)
			if data.GridCountdown <= 0 then
				data.GridCountdown = 30
			else
				data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Velocity = (target.Position - entity.Position):Normalized() * DiceGarper.SPEED * 6
		end
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.onDiceGarper, EntityType.ENTITY_DICEGARPER)

EntityType.ENTITY_BROKEDICEGARPER = Isaac.GetEntityTypeByName("Broken Dice Garper")
BrokDiceGarper = {
	SPEED = 1.0,
	RANGE = 200,
}
function mod:onBrokDiceGarper(entity)
	local sprite = entity:GetSprite()
	sprite:PlayOverlay("Head", false)
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then
		data.GridCountdown = 0
	end

	if entity.State == 0 then
		if entity:IsFrame(8 / BrokDiceGarper.SPEED, 0) then
			entity.Pathfinder:MoveRandomly(false)
		end
		if (entity.Position - target.Position):Length() < BrokDiceGarper.RANGE then
			entity.State = 2
		end
	elseif entity.State == 2 then
		if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, BrokDiceGarper.SPEED, 1.4, false)
			if data.GridCountdown <= 0 then
				data.GridCountdown = 30
			else
				data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Velocity = (target.Position - entity.Position):Normalized() * BrokDiceGarper.SPEED * 6
		end
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.onBrokDiceGarper, EntityType.ENTITY_BROKEDICEGARPER)

function mod:LazerColor(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
			player.LaserColor = Color(0, 0, 0, 1, 215, 95, 25)
		end
	end
end

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

function mod:tearFire_Diltech(t)
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
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.LazerColor, CacheFlag.CACHE_TEARCOLOR)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.tearFire_Diltech)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for i = 0, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i)
		p:GetData().TBOIREP_Minus_DilliriumTech = p:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
			:RandomInt(2) + 1
	end
end)

local laserTypes = {
	[0] = CollectibleType.COLLECTIBLE_TECH_X,
	[1] = CollectibleType.COLLECTIBLE_BRIMSTONE,
	[2] = CollectibleType.COLLECTIBLE_TECHNOLOGY,
	[3] = CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
	[4] = CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
	[5] = CollectibleType.COLLECTIBLE_TECH_5,
}

function mod:deliriousTechLaserSwitch(player)
	if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) and game:GetFrameCount() % 30 == 0 then
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
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.deliriousTechLaserSwitch)

function mod:checkLaser_DelTech(laser)
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
mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.checkLaser_DelTech)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.checkLaser_DelTech, EffectVariant.BRIMSTONE_BALL)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.checkLaser_DelTech, EffectVariant.BRIMSTONE_SWIRL)

function mod:updateLasersPlayer_DelTech(player)
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
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.updateLasersPlayer_DelTech)

function mod:tearUpdate(tear)
	if tear:GetData().IsVacum and tear:HasTearFlags(TearFlags.TEAR_BOOMERANG) and tear.SpawnerEntity then
		local pow = tear.SpawnerEntity.Position:Distance(tear.Position) / 10
		local newvel = (tear.SpawnerEntity.Position - tear.Position):Resized(pow)
		tear.Velocity = tear.Velocity * 0.9 + newvel * 0.1
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.tearUpdate)

function mod:tearFire(t)
	local d = t:GetData()
	local player = t.SpawnerEntity
		and (t.SpawnerEntity:ToPlayer() or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player)
	--[[if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM) then 
			d.IsVacum = true
		
			   if math.random(1, 5) == 4 then
			   t:AddTearFlags(TearFlags.TEAR_BOOMERANG)
			   t:ChangeVariant(TearVariant.DARK_MATTER)
			end    
		end ]]
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.tearFire)

--[[function mod:updateCache_Vacuum(_player, cacheFlag)
		local player = Isaac.GetPlayer(0) 
		
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM) then 
				player.MaxFireDelay = mod.TearsUp(player.MaxFireDelay, 0.5)
			end
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM) then
				player.TearRange = player.TearRange + 70 * 3;
			end        
		end
	end    
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Vacuum)]]

local DiliriumEyeLastActivateFrame = 0

local player = Isaac.GetPlayer(0)
local PixelatedCubeBabiesList = {}
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	-- babies list for pixelated cube
	local config = Isaac.GetItemConfig()
	if #PixelatedCubeBabiesList == 0 then
		for id = 1, config:GetCollectibles().Size do
			local item = config:GetCollectible(id)
			if item and item:HasTags(ItemConfig.TAG_MONSTER_MANUAL) then
				PixelatedCubeBabiesList[#PixelatedCubeBabiesList + 1] = id
			end
		end
	end
end)

function mod:onUpdate_Rock()
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_BEEG_MINUS) then
			player:Kill()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate_Rock)

function mod:PixelatedCubeUse(itemID, rng, player)
	-- pixelated cube
	local BabyNumber = PixelatedCubeBabiesList[math.random(1, 30)]
	player:GetEffects():AddCollectibleEffect(BabyNumber, false)
	local BabyNumber = PixelatedCubeBabiesList[math.random(1, 30)]
	player:GetEffects():AddCollectibleEffect(BabyNumber, false)
	local BabyNumber = PixelatedCubeBabiesList[math.random(1, 30)]
	player:GetEffects():AddCollectibleEffect(BabyNumber, false)
	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PixelatedCubeUse, mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE)

function mod:OnRoomClear(rng)
	--110V double charge part
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_110V) then
			local maxCharge = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(0)).MaxCharges
			if player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) ~= maxCharge then
				player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY)
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, mod.OnRoomClear)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, col, rng, player)
	--110V damage on using active part
	if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_110V) then
		local maxCharge = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(0)).MaxCharges
		if maxCharge == 2 or maxCharge == 3 then
			player:TakeDamage(
				1,
				DamageFlag.DAMAGE_NO_PENALTIES
					| DamageFlag.DAMAGE_NOKILL
					| DamageFlag.DAMAGE_INVINCIBLE
					| DamageFlag.DAMAGE_NO_MODIFIERS,
				EntityRef(player),
				0
			)
		end
		if maxCharge == 4 then
			player:TakeDamage(
				2,
				DamageFlag.DAMAGE_NO_PENALTIES
					| DamageFlag.DAMAGE_NOKILL
					| DamageFlag.DAMAGE_INVINCIBLE
					| DamageFlag.DAMAGE_NO_MODIFIERS,
				EntityRef(player),
				0
			)
		end
		if maxCharge == 6 then
			player:TakeDamage(
				3,
				DamageFlag.DAMAGE_NO_PENALTIES
					| DamageFlag.DAMAGE_NOKILL
					| DamageFlag.DAMAGE_INVINCIBLE
					| DamageFlag.DAMAGE_NO_MODIFIERS,
				EntityRef(player),
				0
			)
		end
		if maxCharge == 12 then
			player:TakeDamage(
				5,
				DamageFlag.DAMAGE_NO_PENALTIES
					| DamageFlag.DAMAGE_NOKILL
					| DamageFlag.DAMAGE_INVINCIBLE
					| DamageFlag.DAMAGE_NO_MODIFIERS,
				EntityRef(player),
				0
			)
		end
	end
end)

include("scripts.items.collectibles.deliriums_eye")
include("scripts.items.collectibles.flower_tea")
include("scripts.items.collectibles.holy_otmichka")

include("scripts.items.collectibles.deal_of_the_death")

include("scripts.items.collectibles.sandwich")

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

---@param Player EntityPlayer
---@param RNG RNG
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, RNG, Player)
	local Flags = (1 << 29) + (1 << 8) + (1 << 37) + (1 << 59) + (1 << 19)
	if RNG:RandomInt(2) == 1 then
		for _ = 1, 2 do
			Isaac.Spawn(
				EntityType.ENTITY_BONY,
				0,
				0,
				Player.Position + Vector(0, 5):Rotated(RNG:RandomInt(360)),
				Vector(0, 0),
				Player
			)
				:ToNPC()
				:AddEntityFlags(Flags)
		end
	else
		for _ = 1, 2 do
			Isaac.Spawn(
				EntityType.ENTITY_BOOMFLY,
				4,
				0,
				Player.Position + Vector(0, 5):Rotated(RNG:RandomInt(360)),
				Vector(0, 0),
				Player
			)
				:ToNPC()
				:AddEntityFlags(Flags)
		end
	end
	if RNG:RandomFloat() <= 0.08 then
		Player:AddBoneHearts(1)
	end
	SFXManager():Play(8)
	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end, mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	---@type EntityPlayer Player
	local Player = Isaac.GetPlayer(0)
	---@type Entity Entity
	for _, Entity in pairs(Isaac.GetRoomEntities()) do
		if Entity.Type == EntityType.ENTITY_BONY or Entity.Type == EntityType.ENTITY_BOOMFLY then
			if Entity:HasEntityFlags((1 << 29) + (1 << 8) + (1 << 37) + (1 << 59) + (1 << 19)) then
				Entity.Position = Player.Position
			end
		end
	end
end)

local vhsStrengh = 1
function mod:onShaderParams(shaderName)
	local Amount = 1

	if shaderName == "RandomColors" then
		for _ = 1, PlayerManager.GetNumCollectibles(mod.RepmTypes.COLLECTIBLE_VHS) do
			Amount = Amount * 0.7
		end
	end
	vhsStrengh = mod.Lerp(vhsStrengh, Amount, 0.01)

	return {
		Amount = vhsStrengh,
	}
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.onShaderParams)

function mod:updateCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_SPEED then
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VHS) then
			player.MoveSpeed = player.MoveSpeed + 0.4
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
	if tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() then
		if tear.SpawnerEntity:ToPlayer():HasCollectible(mod.RepmTypes.COLLECTIBLE_VHS) then
			tear.CollisionDamage = tear.CollisionDamage + tear:GetDropRNG():RandomInt(4)
		end
	end
end)

local music = MusicManager()

Music.MUSIC_MAESTRO = Isaac.GetMusicIdByName("BFG")

function mod:onCache(player, flag)
	if flag == CacheFlag.CACHE_TEARFLAG and player:HasTrinket(mod.RepmTypes.TRINKET_HAMMER) then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_ACID
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)

local Thumper = {}
Thumper.type = Isaac.GetEntityTypeByName("Thumper")
Thumper.variant = Isaac.GetEntityVariantByName("Thumper")
Thumper.regularProjectileVelocity = 9
Thumper.regularProjectileSpread = 15
Thumper.shotSpread = 45
Thumper.shotSpeed = 1 --6.5
Thumper.shotDistance = -10

function Thumper.OnShooting(_, shot)
	if shot.SpawnerType == Thumper.type and shot.SpawnerVariant == Thumper.variant then
		shot.ProjectileFlags = ProjectileFlags.SMART
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, Thumper.OnShooting)

include("scripts.items.collectibles.rot")

include("scripts.items.pick ups.cards.minus_shard")

--------------------------------------------------------------
--Frozen Flies
--------------------------------------------------------------

local tsunFlyVar = Isaac.GetEntityVariantByName("Tsun_Fly")
local tsunOrbitDistance = Vector(30.0, 30.0)
local tsunOrbitLayer = 127
local tsunOrbitSpeed = 0.02
local tsunCenterOffset = Vector(0.0, 0.0)
local whiteColor = Color(1, 1, 1, 1, 0, 0, 0)
whiteColor:SetColorize(1, 1, 1, 1)
whiteColor:SetTint(20, 20, 20, 2)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cache_flag)
	if cache_flag == CacheFlag.CACHE_FAMILIARS then
		local familiar_count = player:GetCollectibleNum(mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY) * 2
		player:CheckFamiliar(
			tsunFlyVar,
			familiar_count,
			player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY)
		)
	end
end)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, orbital)
	orbital.OrbitDistance = tsunOrbitDistance
	orbital.OrbitSpeed = tsunOrbitSpeed
	orbital:AddToOrbit(tsunOrbitLayer)
end, tsunFlyVar)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, familiar, collider, low)
	if collider:IsVulnerableEnemy() then
		local player = familiar.Player
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			collider:TakeDamage(2, 0, EntityRef(familiar), 1)
		else
			collider:TakeDamage(1, 0, EntityRef(familiar), 1)
		end
	elseif collider:ToProjectile() ~= nil then
		local loopInt = 1
		local player = familiar.Player
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			loopInt = 2
		end
		for i = 1, loopInt, 1 do
			local tear = familiar:FireProjectile(collider.Velocity * Vector(-1, -1))
			tear.Velocity = collider.Velocity * Vector(-1, -1)
			tear.Position = collider.Position
			tear.CollisionDamage = collider.CollisionDamage
			--tear:AddTearFlags(TearFlags.TEAR_ICE)
			tear:AddTearFlags(TearFlags.TEAR_HOMING)
			tear:GetData().RepMinusWillFreeze = true
			collider:Remove()
		end
	end
end, tsunFlyVar)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, orbital)
	orbital.OrbitDistance = tsunOrbitDistance
	orbital.OrbitSpeed = tsunOrbitSpeed
	local center_pos = (orbital.Player.Position + orbital.Player.Velocity) + tsunCenterOffset
	local orbit_pos = orbital:GetOrbitPosition(center_pos)
	orbital.Velocity = orbit_pos - orbital.Position
end, tsunFlyVar)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider, low)
	if tear:GetData().RepMinusWillFreeze == true and collider:IsVulnerableEnemy() and not collider:IsBoss() then
		collider:AddEntityFlags(EntityFlag.FLAG_ICE)
		tear.CollisionDamage = 9999
	elseif tear:GetData().RepMinusWillFreeze == true and collider:IsVulnerableEnemy() and collider:IsBoss() then
		collider:AddSlowing(EntityRef(tear), 30, 0.5, collider.Color)
	end
end)

----------------------------------------------------
--SAVE MANAGER
----------------------------------------------------

function mod:AnyPlayerDo(foo)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		foo(player)
	end
end

--------------------------------------------------------------
--FROSTY
--------------------------------------------------------------

function mod:checkTFrostyConditions(player)
	local fires = Isaac.FindByType(33, 2, 0)
	if player:GetPlayerType() ~= mod.RepmTypes.CHARACTER_FROSTY_B then
		return 0
	elseif #fires > 0 then
		return -1
	else
		return 1
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod:AnyPlayerDo(function(player)
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
			or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
		then
			local pdata = mod:repmGetPData(player)
			pdata.FrostDamageDebuff = 0
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
			if
				player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
				and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
				and not game:GetRoom():IsClear()
			then
				local position = game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetRandomPosition(3))
				local rift = Isaac.Spawn(1000, mod.RepmTypes.EFFECT_FROSTY_RIFT, 1, position, Vector.Zero, nil)
				rift.SortingLayer = SortingLayer.SORTING_BACKGROUND
				rift:GetSprite():Play("Appear")
			end
		end
	end)
	mod.saveTable.BlizzFade = nil
end)

local percentFreezePerSecond = 42 --chance to freeze every second
local frostRNG = RNG()
local frameBetweenDebuffs = 150 -- 30 frames per second
local damageDownPerDebuff = 0.40
local speedDownPerDebuff = 0.10
local lastFrame = 0
local minFrameFreeze = 30 -- 1 second
local maxFrameFreeze = 900 -- 30 seconds

local blueColor = Color(0.67, 1, 1, 1, 0, 0, 0)
blueColor:SetColorize(1, 1, 3, 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local pdata = mod:repmGetPData(player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY or mod:checkTFrostyConditions(player) == 1 then
		local frame = game:GetFrameCount()
		if frame % 30 == 0 and frame ~= lastFrame then
			lastFrame = frame
			local room = game:GetRoom()
			if frame % frameBetweenDebuffs == 0 and not game:IsGreedMode() then
				if
					not room:IsClear()
					and game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
					and game:GetRoom():GetType() ~= RoomType.ROOM_MINIBOSS
				then
					pdata.FrostDamageDebuff = (pdata.FrostDamageDebuff or 0) + 1
				elseif room:IsClear() then
					pdata.FrostDamageDebuff = 0
				end
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
			end
		end
	end
	if pdata.HoldingFrozenPolaroid ~= player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
		if player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
			hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS)
			hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_STEAM_SALE)
			local optionsConfig = config:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
			local steamConfig = config:GetCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
			player:RemoveCostume(optionsConfig)
			player:RemoveCostume(steamConfig)
		elseif
			pdata.HoldingFrozenPolaroid == nil and player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) == false
		then
			pdata.HoldingFrozenPolaroid = false -- redundant, i know
		else
			hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS, hiddenItemManager.kDefaultGroup)
			hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_STEAM_SALE, hiddenItemManager.kDefaultGroup)
		end
		pdata.HoldingFrozenPolaroid = player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
	local hasIt = false
	local frame = game:GetFrameCount()

	if not startingFrame then
		startingFrame = game:GetFrameCount()
	end

	mod:AnyPlayerDo(function(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY or mod.saveTable.Repm_Iced then
			hasIt = true
		end

		local pdata = mod:repmGetPData(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and pdata.TFrosty_Unlit_Count == 5 then
			hasIt = true
			local framesToFreeze = pdata.TFrosty_FreezePoint - pdata.TFrosty_StartPoint
			local progress = game:GetFrameCount() - pdata.TFrosty_StartPoint
			local progressAmt = progress / framesToFreeze
			local color = Color.Lerp(Color.Default, blueColor, progressAmt)
			player:GetSprite().Color = color
		end
	end)
	if hasIt and game:GetRoom():GetAliveEnemiesCount() >= 1 then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			local entity = entities[i]
			if
				entity:IsVulnerableEnemy()
				and entity:IsActiveEnemy()
				and not entity:IsBoss()
				and (entity:GetEntityFlags() & EntityFlag.FLAG_CHARM ~= EntityFlag.FLAG_CHARM)
				and (entity:GetEntityFlags() & EntityFlag.FLAG_FRIENDLY ~= EntityFlag.FLAG_FRIENDLY)
			then
				if not entity:GetData().RepM_Frosty_FreezePoint then
					local num = frostRNG:RandomInt(maxFrameFreeze - minFrameFreeze)
					num = num + minFrameFreeze
					entity:GetData().RepM_Frosty_FreezePoint = game:GetFrameCount() + num
					entity:GetData().RepM_Frosty_StartPoint = game:GetFrameCount()
				end
				local freezepoint = entity:GetData().RepM_Frosty_FreezePoint
				local startingFrame = entity:GetData().RepM_Frosty_StartPoint
				if game:GetFrameCount() >= freezepoint then
					entity:AddEntityFlags(EntityFlag.FLAG_ICE)
					entity:TakeDamage(9999, 0, EntityRef(player), 1)
				else
					local framesToFreeze = freezepoint - startingFrame --how long the enemy survives before freezing
					local progress = game:GetFrameCount() - startingFrame
					local progressAmt = progress / framesToFreeze
					local color = Color.Lerp(Color.Default, blueColor, progressAmt)
					entity:AddSlowing(EntityRef(player), 20, 0.8, color)
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheflag)
	local pdata = mod:repmGetPData(player)
	if cacheflag == CacheFlag.CACHE_DAMAGE then
		local damageDebuff = (pdata.FrostDamageDebuff or 0)
		if game:IsGreedMode() then
			damageDebuff = damageDebuff / 2
		end
		player.Damage = player.Damage - (damageDebuff * damageDownPerDebuff)
	end
	if cacheflag == CacheFlag.CACHE_SPEED then
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
			local speedDebuff = (pdata.FrostDamageDebuff or 0)
			if game:IsGreedMode() then
				speedDebuff = speedDebuff / 2
			end
			player.MoveSpeed = player.MoveSpeed - (speedDebuff * speedDownPerDebuff)
		end
	end
end)

function mod:RenderChillStatus()
	if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
		return
	end
	local entities = Isaac.GetRoomEntities()
	for i, npc in ipairs(entities) do
		if npc:GetData().RepM_Frosty_FreezePoint ~= nil and npc:IsVulnerableEnemy() and not game:IsPaused() then
			if not npc:GetData().RepM_Frosty_Sprite then
				npc:GetData().RepM_Frosty_Sprite = Sprite()
				npc:GetData().RepM_Frosty_Sprite:Load("gfx/chill_status.anm2", true)
				npc:GetData().RepM_Frosty_Sprite:Play("Idle")
			end
			local position = Isaac.WorldToScreen(npc.Position + npc:GetNullOffset("OverlayEffect"))
			npc:GetData().RepM_Frosty_Sprite:Render(position)
			npc:GetData().RepM_Frosty_Sprite:Update()
		end
		if npc:ToPlayer() and npc:ToPlayer():GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
			local pdata = mod:repmGetPData(npc:ToPlayer())
			--if not game:IsPaused() then
			if not npc:GetData().RepM_Frosty_Sprite then
				npc:GetData().RepM_Frosty_Sprite = Sprite()
				npc:GetData().RepM_Frosty_Sprite:Load("gfx/chill_status.anm2", true)
				npc:GetData().RepM_Frosty_Sprite:Play("Idle")
			end
			local position = Isaac.WorldToScreen(npc.Position + Vector(0, -50))
			npc:GetData().RepM_Frosty_Sprite:Render(position)
			local TFValue = RepMMod:repmGetPData(npc:ToPlayer()).TFrosty_FreezeTimer
			if TFValue == nil then
				npc:GetData().RepM_Frosty_Sprite.Color = Color(1, 1, 1, 0)
			elseif TFValue <= 500 then
				npc:GetData().RepM_Frosty_Sprite.Color = Color(1, TFValue / 500, TFValue / 500, 1)
			elseif TFValue >= 2000 then
				npc:GetData().RepM_Frosty_Sprite.Color = Color(1, 1, 1, 0)
			else
				npc:GetData().RepM_Frosty_Sprite.Color =
					Color(1, 1, 1, math.min(1, 1 / 1500 * (1500 - (TFValue - 500))))
			end
			npc:GetData().RepM_Frosty_Sprite:Update()
			--end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderChillStatus)

--function mod:

function mod:FrostyRiftEffectRender(effect, renderoffset)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	elseif sprite:IsFinished("Disappear") then
		effect:Remove()
	else
		if game:GetFrameCount() % 5 == 0 then
			effect:Update()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.FrostyRiftEffectRender, mod.RepmTypes.EFFECT_FROSTY_RIFT)

function mod:FreezyShader(name)
	if name == "BlueFade" then
		local blueQty = 1
		if mod.saveTable.BlizzFade and mod.saveTable.BlizzFade > game:GetFrameCount() then
			blueQty = math.sin(0.05 * ((mod.saveTable.BlizzFade - game:GetFrameCount()) - 31.4159)) + 2
		end
		local params = {
			BlueScale = blueQty,
		}
		return params
	end
end
--mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.FreezyShader)

function mod:OnRiftCollide(effect)
	local entities = Isaac.FindInRadius(effect.Position, effect.Size / 2)
	for i, collider in ipairs(entities) do
		if
			collider.Type == EntityType.ENTITY_PLAYER
			and collider:ToPlayer()
			and collider:ToPlayer():GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
			and not effect:GetData().Repm_Rift_Delete
		then
			effect:GetSprite():Play("Disappear")
			local poof =
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector(0, 0), nil)
			poof.Color = blueColor
			--mod.saveTable.BlizzFade = game:GetFrameCount() + 125
			newRoomFreeze = true
			sfx:Play(mod.RepmTypes.SFX_WIND)
			local entities = Isaac.GetRoomEntities()
			for i, entity in ipairs(entities) do
				if
					entity:IsVulnerableEnemy()
					and not entity:IsBoss()
					and (entity:GetEntityFlags() & EntityFlag.FLAG_CHARM ~= EntityFlag.FLAG_CHARM)
					and (entity:GetEntityFlags() & EntityFlag.FLAG_FRIENDLY ~= EntityFlag.FLAG_FRIENDLY)
				then
					local freezepoint = entity:GetData().RepM_Frosty_FreezePoint
					local startingFrame = entity:GetData().RepM_Frosty_StartPoint
					if freezepoint and game:GetFrameCount() + 60 >= freezepoint then
						entity:GetData().RepM_Frosty_FreezePoint = game:GetFrameCount() + 1
					elseif freezepoint and freezepoint > game:GetFrameCount() then
						entity:GetData().RepM_Frosty_FreezePoint =
							math.floor((entity:GetData().RepM_Frosty_FreezePoint + game:GetFrameCount()) / 2)
					end
				end
			end
			effect:GetData().Repm_Rift_Delete = true
			break
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnRiftCollide, mod.RepmTypes.EFFECT_FROSTY_RIFT)

--pgd:TryUnlock(mod.RepmAchivements.FROSTY.ID)

function mod:Anm(player)
	if game:GetFrameCount() == 1 and mod.saveTable.MenuData and mod.saveTable.MenuData.StartThumbsUp ~= 2 then
		player:AnimateHappy()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.Anm)

--------------------------------------------------------------------------
--FROZEN POLAROID
--------------------------------------------------------------------------

function mod:stickyTrinket(pickup, collider, low)
	if not collider:ToPlayer() or not collider:ToPlayer():HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
		return nil
	end
	local player = collider:ToPlayer()
	if
		player:GetTrinket(0) ~= mod.RepmTypes.TRINKET_FROZEN_POLAROID
		and player:GetTrinket(1) ~= mod.RepmTypes.TRINKET_FROZEN_POLAROID
	then
		return nil
	end

	if player:GetMaxTrinkets() > 1 then
		if player:GetTrinket(0) == mod.RepmTypes.TRINKET_FROZEN_POLAROID and player:GetTrinket(1) ~= 0 then
			local trinketDrop = player:GetTrinket(1)
			player:TryRemoveTrinket(trinketDrop)
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_TRINKET,
				trinketDrop,
				player.Position,
				Vector(0, 0),
				nil
			)
			return nil
		elseif player:GetTrinket(1) == mod.RepmTypes.TRINKET_FROZEN_POLAROID and player:GetTrinket(0) ~= 0 then
			local trinketDrop = player:GetTrinket(0)
			player:TryRemoveTrinket(trinketDrop)
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_TRINKET,
				trinketDrop,
				player.Position,
				Vector(0, 0),
				nil
			)
			return nil
		else
			return nil
		end
	else
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.stickyTrinket, PickupVariant.PICKUP_TRINKET)

function mod:tryOpenDoor_Fro_Polaroid(player)
	--and player:CollidesWithGrid()
	if
		(
			game:GetLevel():GetStage() == 6
			or (game:GetLevel():GetStage() == 5 and Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0)
		)
		and game:GetLevel():GetStageType() <= 2
		and player.Position.Y < 151
		and player.Position:Distance(Vector(320, 150)) <= 26
		and game:GetLevel():GetCurrentRoomIndex() == 84
		and player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
	then
		local door = game:GetRoom():GetDoor(1)
		if not door:IsOpen() then
			door:TryUnlock(player, true)
			player:TryRemoveTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
			mod.saveTable.repM_FrostyUnlock = true
		end
	end
	if
		player:GetLastActionTriggers() & ActionTriggers.ACTIONTRIGGER_ITEMSDROPPED
		== ActionTriggers.ACTIONTRIGGER_ITEMSDROPPED
	then
		local trinkets = Isaac.FindByType(5, 350, mod.RepmTypes.TRINKET_FROZEN_POLAROID)
		local respawnPolaroid = false
		for i, trinket in ipairs(trinkets) do
			if trinket.FrameCount == 0 then
				trinket:Remove()
				respawnPolaroid = true
				break
			end
		end -- not a great solution but let's see
		if respawnPolaroid then
			player:AddTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.tryOpenDoor_Fro_Polaroid)
--5 350 195
function mod:DebugText()
	local player = Isaac.GetPlayer(0) --this one is OK
	local coords = (player.Position):Distance(Vector(320, 150))
	--local coords = player.Position
	local debug_str = tostring(player.Position)
	--26
	Isaac.RenderText(debug_str, 100, 60, 1, 1, 1, 255)
end
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.DebugText)

local BasegameSegmentedEnemies = {
	[35 .. " " .. 0] = true, -- Mr. Maw (body)
	[35 .. " " .. 1] = true, -- Mr. Maw (head)
	[35 .. " " .. 2] = true, -- Mr. Red Maw (body)
	[35 .. " " .. 3] = true, -- Mr. Red Maw (head)
	[89] = true, -- Buttlicker
	[216 .. " " .. 0] = true, -- Swinger (body)
	[216 .. " " .. 1] = true, -- Swinger (head)
	[239] = true, -- Grub
	[244 .. " " .. 2] = true, -- Tainted Round Worm

	[19 .. " " .. 0] = true, -- Larry Jr.
	[19 .. " " .. 1] = true, -- The Hollow
	[19 .. " " .. 2] = true, -- Tuff Twins
	[19 .. " " .. 3] = true, -- The Shell
	[28 .. " " .. 0] = true, -- Chub
	[28 .. " " .. 1] = true, -- C.H.A.D.
	[28 .. " " .. 2] = true, -- The Carrion Queen
	[62 .. " " .. 0] = true, -- Pin
	[62 .. " " .. 1] = true, -- Scolex
	[62 .. " " .. 2] = true, -- The Frail
	[62 .. " " .. 3] = true, -- Wormwood
	[79 .. " " .. 0] = true, -- Gemini
	[79 .. " " .. 1] = true, -- Steven
	[79 .. " " .. 10] = true, -- Gemini (baby)
	[79 .. " " .. 11] = true, -- Steven (baby)
	[92 .. " " .. 0] = true, -- Heart
	[92 .. " " .. 1] = true, -- 1/2 Heart
	[93 .. " " .. 0] = true, -- Mask
	[93 .. " " .. 1] = true, -- Mask II
	[97] = true, -- Mask of Infamy
	[98] = true, -- Heart of Infamy
	[266] = true, -- Mama Gurdy
	[912 .. " " .. 0 .. " " .. 0] = true, -- Mother (phase one)
	[912 .. " " .. 0 .. " " .. 2] = true, -- Mother (left arm)
	[912 .. " " .. 0 .. " " .. 3] = true, -- Mother (right arm)
	[918 .. " " .. 0] = true, -- Turdlet
}

function mod:isBasegameSegmented(entity)
	return BasegameSegmentedEnemies[entity.Type]
		or BasegameSegmentedEnemies[entity.Type .. " " .. entity.Variant]
		or BasegameSegmentedEnemies[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

local function checkEntityForChampionizing(entity)
	return not entity:IsChampion()
		and not entity:IsBoss()
		and mod.RNG:RandomInt(8) == 1
		and not mod:isBasegameSegmented(entity)
		and entity.Type ~= EntityType.ENTITY_FIREPLACE
end

function mod:OnEntitySpawn_Polar(npc)
	local chosenPlayer
	mod:AnyPlayerDo(function(player)
		if player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
			chosenPlayer = player
		end
	end)
	if chosenPlayer ~= nil then
		if checkEntityForChampionizing(npc) == true then
			npc:MakeChampion(mod.RNG:GetSeed())
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.OnEntitySpawn_Polar)

function mod:OnTakeHit_Polar(entity, amount, damageflags, source, countdownframes)
	local player = entity:ToPlayer()
	if player == nil then
		return
	end
	local data = mod:repmGetPData(player)
	if amount == 1 and player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) and not data.inPolaroidDamage then
		data.inPolaroidDamage = true
		return { Damage = amount + 1, DamageFlags = damageflags, DamageCountdown = countdownframes }
	end
	data.inPolaroidDamage = nil
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakeHit_Polar, EntityType.ENTITY_PLAYER)
-----------------------------------------------------------------
--frosty unlock
------------------------------------------------------------------
local iceCard = Isaac.GetCardIdByName("Icicle")

function mod:OnBossDefeat_Frosty(rng, spawn)
	if
		not pgd:Unlocked(mod.RepmAchivements.FROSTY.ID)
		and pgd:Unlocked(635)
		and game:GetRoom():GetType() == RoomType.ROOM_BOSS
		and game:GetLevel():GetStage() == 1
		and game:GetLevel():GetStageType() <= 2
		and mod.saveTable.repm_picSpawned ~= true
	then
		local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos())
		Isaac.Spawn(5, 350, mod.RepmTypes.TRINKET_FROZEN_POLAROID, spawnPos, Vector.Zero, nil)
		mod.saveTable.repm_picSpawned = true
	end
	mod.saveTable.Repm_Iced = false
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnBossDefeat_Frosty)

function mod:OnEnterSecretExit()
	mod.saveTable.Repm_Iced = false
	local room = game:GetRoom()
	if
		room:GetType() == RoomType.ROOM_SECRET_EXIT
		and game:GetLevel():GetStage() == 6
		and game:GetLevel():GetStageType() <= 2
		and REPENTOGON
		and mod.saveTable.repM_FrostyUnlock
	then
		--room:SetBackdropType(BackdropType.BLUE_WOMB_PASS, 3)
		for i = 1, room:GetGridSize() do
			local ge = room:GetGridEntity(i)
			if ge and ge.Desc.Type ~= 16 then
				room:RemoveGridEntity(i, 0)
			end
		end
		if room:IsFirstVisit() then
			local items = Isaac.FindByType(5, 100)
			for i, item in ipairs(items) do
				item:Remove()
			end
			Isaac.Spawn(6, 14, 0, room:GetCenterPos(), Vector.Zero, nil)
		end

		local frosties = Isaac.FindByType(6, 14)
		for i, dude in ipairs(frosties) do
			dude:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_frosty.png")
			dude:GetSprite():LoadGraphics()
		end
		--elseif game:GetRoom():GetType() == RoomType.ROOM_BOSS and game:GetLevel():GetStage() == 6 and mod.saveTable.repM_FrostyUnlock then
		--room:TrySpawnBossRushDoor()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnEnterSecretExit)

function mod:UseIcicle(card, player, useflags)
	if
		game:GetRoom():GetType() == RoomType.ROOM_BOSS
		and game:GetLevel():GetStage() == 6
		and REPENTOGON
		and not room:IsClear()
	then
		mod.saveTable.repM_FrostyUnlock = true
		local entities = Isaac.GetRoomEntities()
		for i, npc in ipairs(entities) do
			if npc:IsVulnerableEnemy() and npc:IsBoss() then
				npc:TakeDamage(9999, 0, EntityRef(player), 1)
			elseif npc:IsVulnerableEnemy() then
				npc:AddEntityFlags(EntityFlag.FLAG_ICE)
				npc:TakeDamage(9999, 0, EntityRef(player), 1)
			end
		end
		game:GetRoom():TrySpawnBossRushDoor()
	elseif not room:IsClear() then
		mod.saveTable.Repm_Iced = true
	end
end
--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.UseIcicle, iceCard)

--MC_PRE_PLAYER_COLLISION

function mod:onCollisionSecret(player, collider, low)
	if collider.Type == 6 and collider.Variant == 14 and game:GetRoom():GetType() == RoomType.ROOM_SECRET_EXIT then
		pgd:TryUnlock(mod.RepmAchivements.FROSTY.ID)
		pgd:TryUnlock(mod.RepmAchivements.FROZEN_HEARTS.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.onCollisionSecret)

----------------------------------------------------------
function mod:whenSpawningCreep_IceHeart(player)
	local pdata = mod:repmGetPData(player)
	if pdata.isIceheartCrept and game:GetFrameCount() % 3 == 0 then
		local creep = Isaac.Spawn(1000, 54, 0, player.Position, Vector.Zero, player):ToEffect()
		creep.Scale = 0.65
		--creep:SetTimeout(15)
		creep:Update()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.whenSpawningCreep_IceHeart)

function mod:disableCreepRoom()
	mod:AnyPlayerDo(function(player)
		local pdata = mod:repmGetPData(player)
		pdata.isIceheartCrept = nil
		pdata.EnhSpeedBonus = 0
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:EvaluateItems()
	end)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.disableCreepRoom)

----------------------------------------------------------

function mod:onGreedUpdate_RepM()
	if game:IsGreedMode() and mod.saveTable.REPM_GreedWave ~= game:GetLevel().GreedModeWave then
		mod:AnyPlayerDo(function(player)
			if
				player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
				or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
			then
				local pdata = repmGetPData(player)
				pdata.FrostDamageDebuff = (pdata.FrostDamageDebuff or 0) + 1
			end
		end)
		mod.saveTable.REPM_GreedWave = game:GetLevel().GreedModeWave
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onGreedUpdate_RepM)

----------------------------------------------------------
--FOUNTAIN
----------------------------------------------------------
local fountainType = Isaac.GetEntityVariantByName("Fountain of Confession")
local fountainSound = Isaac.GetSoundIdByName("fountain")

local function playerToNum(player)
	for num = 0, game:GetNumPlayers() - 1 do
		if GetPtrHash(player) == GetPtrHash(Isaac.GetPlayer(num)) then
			return num
		end
	end
end

local function killFount(fount)
	fount:GetSprite():Play("Death")
end

function mod:numToPlayer(num)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		if GetPtrHash(player) == GetPtrHash(Isaac.GetPlayer(num)) then
			return player
		end
	end
end

local isFountPlaying = false

function mod:fountUpdate()
	local founts = Isaac.FindByType(EntityType.ENTITY_SLOT, fountainType)
	local anyInRadius = false
	for _, fount in pairs(founts) do
		if fount:GetSprite():IsFinished("Initiate") then
			fount:GetSprite():Play("Wiggle")
		end
		if fount:GetSprite():IsFinished("Wiggle") then
			fount:GetSprite():Play("Prize")
		end
		if fount:GetSprite():IsFinished("Death") then
			fount:GetSprite():Play("Broken")
			fount:Die()
		end
		if fount:GetSprite():IsFinished("Prize") then
			local dropRNG = fount:GetDropRNG()
			local breakOutcome = dropRNG:RandomInt(100)
			if breakOutcome <= 15 then
				fount:GetSprite():Play("Death")
			else
				fount:GetSprite():Play("Idle")
			end
			fount:GetData()["Playing Player"] = nil
		end

		if fount:GetSprite():IsEventTriggered("Explosion") then
			local exp = Isaac.Spawn(1000, 1, 0, fount.Position, Vector.Zero, fount)
			exp:GetData().FountCaused_REPM = true
		end

		if fount:GetSprite():IsEventTriggered("Prize") then
			local outcome = fount:GetData().Slot_Outcome or 99
			if outcome <= 5 then
				sfx:Play(SoundEffect.SOUND_LUCKYPICKUP, 1.0, 0, false, 1.0)
				Isaac.Spawn(5, 300, 20, fount.Position, Vector(0, 1), fount)
			elseif outcome <= 15 then
				local player = mod:numToPlayer(fount:GetData()["Playing Player"])
				--player:AddSoulHearts(2)
				--SfxManager:Play(SoundEffect.SOUND_THUMBSUP, 2)
				--player:AnimateHappy()
				local pdata = mod:repmGetPData(player)
				pdata.repMBonusDamage = (pdata.repMBonusDamage or 0) + 0.5
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:EvaluateItems()
				player:AnimateHappy()
				sfx:Play(SoundEffect.SOUND_THUMBSUP, 2)
			else
				local player = mod:numToPlayer(fount:GetData()["Playing Player"])
				local pdata = mod:repmGetPData(player)
				pdata.repMBonusLuck = (pdata.repMBonusLuck or 0) + 0.5
				player:AddCacheFlags(CacheFlag.CACHE_LUCK)
				player:EvaluateItems()
				player:AnimateHappy()
				sfx:Play(SoundEffect.SOUND_THUMBSUP, 2)
			end
		end
		if fount:GetSprite():IsEventTriggered("Disappear") then
			fount.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end

		local players = Isaac.FindInRadius(fount.Position, 100)
		for i, player in ipairs(players) do
			if player:ToPlayer() ~= nil and fount:GetSprite():GetAnimation() ~= "Broken" then
				anyInRadius = true
				if not isFountPlaying then
					isFountPlaying = true
					sfx:Play(fountainSound, 1, 30, true)
				end
			end
		end
	end
	if anyInRadius == false and isFountPlaying then
		isFountPlaying = false
		sfx:Stop(fountainSound)
	end
	local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
	for _, plosion in pairs(explosions) do
		local frame = plosion:GetSprite():GetFrame()
		if frame < 3 then -- I'm afraid of 60 vs 30 breaking an exact check
			local size = plosion.SpriteScale.X -- default is 1, can be increased
			local nearby = Isaac.FindInRadius(plosion.Position, 75 * size)
			for _, v in pairs(nearby) do
				if
					v.Type == EntityType.ENTITY_SLOT
					and v.Variant == fountainType
					and v:GetSprite():GetAnimation() ~= "Broken"
					and v:GetSprite():GetAnimation() ~= "Death"
					and plosion:GetData().FountCaused_REPM ~= true
				then
					killFount(v)
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.fountUpdate)

function mod:donationFount(player, fount, low)
	if fount.Type == EntityType.ENTITY_SLOT and fount.Variant == fountainType then
		if
			fount:GetSprite():IsPlaying("Idle")
			and player:GetNumCoins() > 4
			and (not REPENTOGON or fount:ToSlot():GetState() ~= -1)
		then
			player:AddCoins(-5)
			SFXManager():Play(SoundEffect.SOUND_SCAMPER, 1.0, 0, false, 1.0)
			fount:GetSprite():Play("Initiate")
			fount:GetData()["Playing Player"] = playerToNum(player)
			if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
				fount:GetData()["Playing Player"] = playerToNum(player:GetMainTwin())
			end
			local droprng = fount:GetDropRNG()
			fount:GetData().Slot_Outcome = droprng:RandomInt(100)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.donationFount)

function mod:updateCache_Fountain(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		local pdata = mod:repmGetPData(player)
		player.Damage = player.Damage + (pdata.repMBonusDamage or 0)
	elseif cacheFlag == CacheFlag.CACHE_LUCK then
		local pdata = mod:repmGetPData(player)
		player.Luck = player.Luck + (pdata.repMBonusLuck or 0)
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Fountain)

function mod:spawnFountBehavior()
	local room = game:GetRoom()
	if room:IsFirstVisit() then
		local confessionals = Isaac.FindByType(EntityType.ENTITY_SLOT, 17)
		for i, confess in ipairs(confessionals) do
			local rng = confess:GetDropRNG()
			if rng:RandomInt(100) + 1 <= 50 then
				local pos = confess.Position
				confess:Remove()
				Isaac.Spawn(6, fountainType, 0, pos, Vector.Zero, nil)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.spawnFountBehavior)

----------------------------------------------------------
--RED LIGHT GREEN LIGHT
----------------------------------------------------------
local redLightChallenge = Isaac.GetChallengeIdByName("Traffic Light")

function mod:trafficRender()
	if Isaac.GetChallenge() == redLightChallenge then
		if not mod.saveTable.RedLightSprite then
			mod.saveTable.RedLightSprite = Sprite()
			mod.saveTable.RedLightSprite:Load("gfx/trafficlight.anm2", true)
			mod.saveTable.RedLightSprite:LoadGraphics()
		end
		if not mod.saveTable.RedLightSign then
			return
		end
		if mod.saveTable.RedLightSprite:GetAnimation() ~= mod.RedLightSign then
			mod.saveTable.RedLightSprite:Play(mod.saveTable.RedLightSign)
		end
		local horiz, vert
		if REPENTOGON then -- probably a useless split but maybe we'll make this work with the map size later
			horiz = 115
			vert = 45
		else
			horiz = 115
			vert = 45
		end

		mod.saveTable.RedLightSprite:Render(Vector(horiz, vert))
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.trafficRender)

--local saveTimer

local function IsMoving(player)
	local index = player.ControllerIndex
	return Input.IsActionPressed(ButtonAction.ACTION_LEFT, index)
		or Input.IsActionPressed(ButtonAction.ACTION_RIGHT, index)
		or Input.IsActionPressed(ButtonAction.ACTION_UP, index)
		or Input.IsActionPressed(ButtonAction.ACTION_DOWN, index)
end

function mod:changeLights()
	local frame = game:GetFrameCount()
	if Isaac.GetChallenge() == redLightChallenge then
		if not mod.saveTable.saveTimer then
			mod.saveTable.saveTimer = 0
			if not mod.saveTable.RedLightSign or mod.saveTable.RedLightSign == "GreenLight" then
				mod.saveTable.RedLightSign = "RedLight"
			elseif mod.saveTable.RedLightSign == "YellowLight" then
				mod.saveTable.RedLightSign = "GreenLight"
			else
				mod.saveTable.RedLightSign = "YellowLight"
			end
		end
		if frame > mod.saveTable.saveTimer then
			if mod.saveTable.RedLightSign == "RedLight" then
				mod.saveTable.saveTimer = frame + mod.RNG:RandomInt(1350) + 300
				mod.saveTable.RedLightSign = "GreenLight"
			elseif mod.saveTable.RedLightSign == "YellowLight" then
				mod.saveTable.saveTimer = frame + mod.RNG:RandomInt(300) + 30
				mod.saveTable.RedLightSign = "RedLight"
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 2)
			else
				mod.saveTable.saveTimer = frame + 30
				mod.saveTable.RedLightSign = "YellowLight" --SOUND_TOOTH_AND_NAIL_TICK
				sfx:Play(469, 2)
			end
		end
		mod:AnyPlayerDo(function(player)
			if mod.saveTable.RedLightSign == "RedLight" and IsMoving(player) then
				local pdata = mod:repmGetPData(player)
				if not pdata.redLightFrame or pdata.redLightFrame < frame then
					pdata.redLightFrame = frame + 30
					player:TakeDamage(1, 0, EntityRef(player), 2)
				end
			end
			if frame == 0 then
				pdata.redLightFrame = nil
			end
		end)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.changeLights)

----------------------------------------------------------
--FRIENDLY ROCKS
----------------------------------------------------------
function mod:onRockBreak(rockSubtype, position) --probably could make a callback but nah
	local hasIt = false
	local rockRNG = nil
	mod:AnyPlayerDo(function(player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS) then
			hasIt = true
			rockRNG = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS)
		end
	end)
	if hasIt and rockRNG:RandomInt(10) ~= 1 then
		Isaac.Spawn(3, 201, 12, position, Vector.Zero, nil)
	end
end

local function rockIsBroken(position)
	local room = game:GetRoom()
	local rock = room:GetGridEntity(position)
	if not rock then
		return true
	elseif rock:ToRock() and rock.State == 2 then
		return true
		--elseif rock:ToPoop() and rock.State == 1000 then
		--return true
	else
		return false
	end
end

function mod:CheckRocksBreak()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local newRoom = false
	if mod.saveTable.scanRockRoom ~= level:GetCurrentRoomIndex() then
		newRoom = true
		mod.saveTable.scanRockRoom = level:GetCurrentRoomIndex()
	end
	if not mod.saveTable.scanRockMap then
		mod.saveTable.scanRockMap = {}
	end

	for i = 1, room:GetGridSize(), 1 do
		local rock = room:GetGridEntity(i)
		if newRoom then
			if rock and not rockIsBroken(i) then
				mod.saveTable.scanRockMap[i] = rock:GetType()
			else
				mod.saveTable.scanRockMap[i] = nil
			end
		else
			if rock and mod.saveTable.scanRockMap[i] ~= nil and rockIsBroken(i) then
				mod:onRockBreak(mod.saveTable.scanRockMap[i], rock.Position)
				mod.saveTable.scanRockMap[i] = nil
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.CheckRocksBreak)

----------------------------------------------------------
--LIKE (Item)
----------------------------------------------------------
local likeFrame = -5

function mod:onPlayerUpdate_Like(player)
	if
		player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LIKE)
		and player:GetSprite():GetAnimation() == "Happy"
		and player:GetSprite():GetFrame() == 6
	then
		local pdata = mod:repmGetPData(player)
		pdata.Like_AllBonus = (pdata.Like_AllBonus or 0) + 0.5
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate_Like)

function mod:likeCache(player, cacheFlag)
	local pdata = mod:repmGetPData(player)
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		player.Damage = player.Damage
			+ (0.4 * (pdata.Like_AllBonus or 0))
			+ player:GetCollectibleNum(mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD)
	elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
		local tearstoadd = (0.4 * (pdata.Like_AllBonus or 0))
		player.MaxFireDelay = mod.TearsUp(player.MaxFireDelay, tearstoadd)
	elseif cacheFlag == CacheFlag.CACHE_LUCK then
		player.Luck = player.Luck + (0.4 * (pdata.Like_AllBonus or 0))
	elseif cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + (0.4 * (pdata.Like_AllBonus or 0))
		player.MoveSpeed = player.MoveSpeed + (pdata.EnhSpeedBonus or 0) * 0.2
	elseif cacheFlag == CacheFlag.CACHE_RANGE then
		player.TearRange = player.TearRange + (40 * (pdata.Like_AllBonus or 0))
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.likeCache)

----------------------------------------------------------
--LOCUST KING
----------------------------------------------------------

function mod:collideItemPedestalAbs(pickup, collider, low)
	local player = collider:ToPlayer()
	if
		player
		and Isaac.GetChallenge() == mod.RepmTypes.CHALLENGE_LOCUST_KING
		and pickup.SubType ~= 0
		and not Isaac.GetItemConfig():GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST)
		and pickup.SubType ~= CollectibleType.COLLECTIBLE_MORE_OPTIONS
	then
		sfx:Play(SoundEffect.SOUND_FART, 2)
		local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
		local pickupindex = pickup:ToPickup().OptionsPickupIndex
		for i, item in ipairs(items) do
			if item:ToPickup().OptionsPickupIndex == pickupindex and pickupindex ~= 0 then
				item:Remove()
			end
		end
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector(0, 0), nil)
		pickup:Remove()
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.collideItemPedestalAbs, PickupVariant.PICKUP_COLLECTIBLE)

local function doesAnyoneHave(trinket)
	local hasIt = false
	mod:AnyPlayerDo(function(player)
		if player:HasTrinket(trinket) then
			hasIt = true
		end
	end)
	return hasIt
end

function mod:onLevelStart_Locust()
	Isaac.GetItemConfig():GetCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE).MaxCharges = 1
	local hasIt = false
	--mod:AnyPlayerDo(function(player)
	--if player:HasCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS) then
	--hasIt = true
	--end
	--end)
	if Isaac.GetChallenge() == mod.RepmTypes.CHALLENGE_LOCUST_KING then
		--if not hasIt then
		local itemHere = Isaac.Spawn(5, 10, 11, Vector(160, 225), Vector.Zero, nil)
		itemHere:ToPickup().ShopItemId = -1
		itemHere:ToPickup().AutoUpdatePrice = false
		itemHere:ToPickup().Price = 4
		--end

		if not doesAnyoneHave(186) then
			Isaac.Spawn(5, 350, 186, Vector(480, 225), Vector.Zero, nil)
		elseif not doesAnyoneHave(115) then
			Isaac.Spawn(5, 350, 115, Vector(480, 225), Vector.Zero, nil)
		elseif not doesAnyoneHave(114) then
			Isaac.Spawn(5, 350, 114, Vector(480, 225), Vector.Zero, nil)
		elseif not doesAnyoneHave(113) then
			Isaac.Spawn(5, 350, 113, Vector(480, 225), Vector.Zero, nil)
		elseif not doesAnyoneHave(116) then
			Isaac.Spawn(5, 350, 116, Vector(480, 225), Vector.Zero, nil)
		elseif not doesAnyoneHave(117) then
			Isaac.Spawn(5, 350, 117, Vector(480, 225), Vector.Zero, nil)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onLevelStart_Locust)

function mod:ChallengeMarblesInit(player)
	if player and Isaac.GetChallenge() == mod.RepmTypes.CHALLENGE_LOCUST_KING then
		player:AddCollectible(CollectibleType.COLLECTIBLE_MARBLES, 0, false)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.ChallengeMarblesInit)

----------------------------------------------------------
--ACHIEVEMENT
----------------------------------------------------------
function mod:onSatanFrostyKill()
	local isFrosty = false
	if
		game:GetLevel():GetStage() ~= 10
		or game:GetLevel():GetStageType() ~= StageType.STAGETYPE_ORIGINAL
		or game:IsGreedMode()
		or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
		or game:GetRoom():GetBossID() ~= 24
	then
		return
	end
	mod:AnyPlayerDo(function(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY then
			isFrosty = true
		end
	end)
	if isFrosty then
		pgd:TryUnlock(mod.RepmAchivements.DEATH_CARD.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onSatanFrostyKill)

function mod:onBlueBabyFrostyKill(entity)
	local isFrosty = false
	if
		game:GetLevel():GetStage() ~= 11
		or game:GetLevel():GetStageType() ~= StageType.STAGETYPE_WOTL
		or game:IsGreedMode()
		or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
		or game:GetRoom():GetBossID() ~= 40
	then
		return
	end
	mod:AnyPlayerDo(function(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY then
			isFrosty = true
		end
	end)
	if isFrosty then
		pgd:TryUnlock(mod.RepmAchivements.NUMB_HEART.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onBlueBabyFrostyKill)

function mod:onSimDeliriumKill(entity)
	local isSim = false
	if game:GetLevel():GetStage() ~= 12 or game:GetRoom():GetBossID() ~= 70 then
		return
	end
	mod:AnyPlayerDo(function(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_SIM then
			isSim = true
		end
	end)
	if isSim then
		pgd:TryUnlock(mod.RepmAchivements.SIM_DELIRIUM.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onSimDeliriumKill)

function mod:onSimMotherKill(entity)
	local isSim = false
	if game:GetLevel():GetStage() ~= 8 or game:GetRoom():GetBossID() ~= 72 then
		return
	end
	mod:AnyPlayerDo(function(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_SIM then
			isSim = true
		end
	end)
	if isSim then
		pgd:TryUnlock(mod.RepmAchivements.ROT.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onSimMotherKill)

function mod:onMomHeartKill(entity)
	local FrostyDone = false
	local SimDone = false
	--local MinusIsaacDone = false

	if
		game:GetLevel():GetStage() ~= 8
		or game:IsGreedMode()
		or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
		or (game:GetRoom():GetBossID() ~= 8 and game:GetRoom():GetBossID() ~= 25)
	then
		return
	end

	mod:AnyPlayerDo(function(player)
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
			or Isaac.GetCompletionMark(mod.RepmTypes.CHARACTER_FROSTY, 0)
		then
			FrostyDone = true
		end
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_SIM
			or Isaac.GetCompletionMark(mod.RepmTypes.CHARACTER_SIM, 0)
		then
			SimDone = true
		end
		--if player:GetPlayerType() == Minusaac or Isaac.GetCompletionMark(Minusaac, 0) then
		--MinusIsaacDone = true
		--end
	end)
	if FrostyDone and SimDone then
		pgd:TryUnlock(mod.RepmAchivements.IMPROVED_CARDS.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onMomHeartKill)
--mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onMomHeartKill, EntityType.ENTITY_MOMS_HEART)

----------------------------------------------------------
--ENHANCED CARDS
----------------------------------------------------------
function mod:OnEnhancedTwoHearts(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		player:AddBlueFlies(12, player.Position, nil)
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedTwoHearts, Card.CARD_HEARTS_2)

function mod:OnEnhancedHierophant(card, player, useflags)
	local room = game:GetRoom()
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
	then
		--player:AddBlueFlies(12, player.Position, nil)

		Isaac.Spawn(5, 20, 2, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		Isaac.Spawn(5, 20, 2, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		player:AnimateCard(card)
		return true
	end
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		if pgd:Unlocked(293) then
			Isaac.Spawn(5, 300, 51, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			Isaac.Spawn(5, 300, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		else
			player:AddBlueFlies(10, player.Position, nil)
		end
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedHierophant, Card.CARD_HIEROPHANT)

function mod:OnEnhancedLovers(card, player, useflags)
	local room = game:GetRoom()
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
	then
		--player:AddBlueFlies(12, player.Position, nil)

		Isaac.Spawn(5, 20, 1, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		Isaac.Spawn(5, 20, 1, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		player:AnimateCard(card)
		return true
	end
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		if pgd:Unlocked(293) then
			Isaac.Spawn(5, 300, 51, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		else
			player:AddBlueFlies(5, player.Position, nil)
		end
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedLovers, Card.CARD_LOVERS)

function mod:OnEnhancedTemperance(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		local room = game:GetRoom()
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)
		local slot = Isaac.Spawn(6, 3, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, slot.Position, Vector(0, 0), nil)
		player:AnimateCard(card)
		return true
	end
end -- to do, add a poof and spawn sound
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedTemperance, Card.CARD_TEMPERANCE)

function mod:OnEnhancedDagaz(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
	then
		local room = game:GetRoom()
		Isaac.Spawn(5, 20, 2, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
	end
end -- to do, add a poof and spawn sound
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedDagaz, Card.RUNE_DAGAZ)

function mod:OnEnhancedHierophantB(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
	then
		--player:AddBlueFlies(12, player.Position, nil)
		local room = game:GetRoom()
		Isaac.Spawn(5, 20, 3, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		player:AnimateCard(card)
		return true
	end
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		player:AddBlueFlies(8, player.Position, nil)
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedHierophantB, Card.CARD_REVERSE_HIEROPHANT)

function mod:OnEnhancedQueenHearts(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		local amountTotal = mod.RNG:RandomInt(39) + 2
		local amountSpiders = mod.RNG:RandomInt(amountTotal)
		player:AddBlueFlies(amountTotal - amountSpiders, player.Position, nil)
		for i = 1, amountSpiders, 1 do
			player:AddBlueSpider(player.Position)
		end
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedQueenHearts, Card.CARD_QUEEN_OF_HEARTS)

function mod:OnEnhancedEmpressB(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
	then
		local room = game:GetRoom()
		Isaac.Spawn(5, 20, 3, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		Isaac.Spawn(5, 20, 3, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		player:AnimateCard(card)
		return true
	end
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		player:AddBlueFlies(8, player.Position, nil)
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedEmpressB, Card.CARD_REVERSE_EMPRESS)

function mod:OnEnhancedJudgement(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		local entities = Isaac.FindByType(6, 5, -1)
		for i, entity in ipairs(entities) do
			if entity.FrameCount <= 15 then
				local oldPos = entity.Position
				entity:Remove()
				Isaac.Spawn(6, 4, 0, oldPos, Vector.Zero, nil)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnEnhancedJudgement, Card.CARD_JUDGEMENT)

function mod:OnEnhancedStrengthB(card, player, useflags)
	if
		pgd:Unlocked(mod.RepmAchivements.IMPROVED_CARDS.ID)
		and (
			player:GetPlayerType() == PlayerType.PLAYER_THELOST
			or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		)
	then
		local pdata = mod:repmGetPData(player)
		pdata.EnhSpeedBonus = (pdata.EnhSpeedBonus or 0) + 1
		player:AddCacheFlags(CacheFlag.CACHE_SPEED)
		player:EvaluateItems()
		player:AnimateCard(card)
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedStrengthB, Card.CARD_REVERSE_STRENGTH)

include("scripts.items.collectibles.sirens_horns")
----------------------------------------------------------
--HOW TO DIG
----------------------------------------------------------
function mod:useHowToDig(collectibletype, rng, player, useflags, slot, vardata)
	local data = player:GetData()
	if data.REPM_InDigState == nil then
		data.REPM_InDigState = game:GetFrameCount()
		player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
	end
	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useHowToDig, mod.RepmTypes.COLLECTIBLE_HOW_TO_DIG)

local points = {}
local lastRoomIndex

local sinkFrame = nil
local lastParticleFrame = nil
function mod:HowDigUpdate(player)
	if player:GetData().REPM_InDigState ~= nil then
		if game:GetFrameCount() ~= sinkFrame and player:GetData().REPM_InDigState + 20 == game:GetFrameCount() then
			player:GetSprite().Color = Color(1, 1, 1, 0, 1, 1, 1)
			player:GetSprite():LoadGraphics()
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
			hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_LEO)
			sinkFrame = game:GetFrameCount()
			lastParticleFrame = game:GetFrameCount()
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, Options.SFXVolume * 2)
			Isaac.Spawn(1000, 62, 0, player.Position, Vector.Zero, entity)
			for i = 1, 3 do
				Isaac.Spawn(
					1000,
					4,
					0,
					game:GetRoom():GetGridPosition(game:GetRoom():GetGridIndex(player.Position)),
					RandomVector() * math.random() * 5,
					player
				)
			end
		elseif
			player:GetData().REPM_EscapeDig == true or game:GetFrameCount() > player:GetData().REPM_InDigState + 600
		then
			player:GetData().REPM_EscapeDig = nil
			player:GetSprite().Color = Color(1, 1, 1, 1, 0, 0, 0)
			player:GetSprite():LoadGraphics()
			player:GetData().REPM_InDigState = nil

			for i = 1, 3 do
				Isaac.Spawn(
					1000,
					4,
					0,
					game:GetRoom():GetGridPosition(game:GetRoom():GetGridIndex(player.Position)),
					RandomVector() * math.random() * 5,
					player
				)
			end
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, Options.SFXVolume * 2)
			Isaac.Spawn(1000, 62, 0, player.Position, Vector.Zero, entity)
			player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
			hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_LEO, hiddenItemManager.kDefaultGroup)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
				table.insert(points, { point = player, dmg = player.Damage })
			end
		elseif game:GetFrameCount() ~= sinkFrame and player:GetData().REPM_InDigState + 20 <= game:GetFrameCount() then
			player.FireDelay = 1
			if game:GetFrameCount() == lastParticleFrame + 4 then
				lastParticleFrame = lastParticleFrame + 4
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, Options.SFXVolume / 3)
				Isaac.Spawn(1000, 62, 0, player.Position, Vector.Zero, entity)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.HowDigUpdate)

function mod:OnPlayerCollide_Dig(player, collider)
	if player:GetData().REPM_InDigState and player:GetData().REPM_InDigState + 20 <= game:GetFrameCount() then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.OnPlayerCollide_Dig)

function mod:OnPlayerDamage_Dig(entity, amount, damageflags, source, countdownframes)
	local player = entity:ToPlayer()
	if player == nil then
		return
	end

	if player:GetData().REPM_InDigState and player:GetData().REPM_InDigState + 20 <= game:GetFrameCount() then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPlayerDamage_Dig, EntityType.ENTITY_PLAYER)

function mod:DoorUpdateDig(door)
	local entities = Isaac.FindInRadius(door.Position, 30)
	if not door:IsOpen() and door:CanBlowOpen() then
		for i, entity in ipairs(entities) do
			if
				entity
				and entity:ToPlayer() ~= nil
				and entity:ToPlayer():GetData().REPM_InDigState
				and entity:ToPlayer():GetData().REPM_InDigState + 20 <= game:GetFrameCount()
			then
				door:TryBlowOpen(false, entity:ToPlayer())
				sfx:Play(SoundEffect.SOUND_WOOD_PLANK_BREAK)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, mod.DoorUpdateDig)

function mod:HowDigRender(player)
	if
		player:GetData().REPM_InDigState ~= nil
		and player:GetData().REPM_InDigState ~= game:GetFrameCount()
		and not player:GetData().REPM_EscapeDig
		and Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex)
	then
		player:GetData().REPM_EscapeDig = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.HowDigRender)

function mod:digSlowdown(player, cacheFlag)
	local data = player:GetData()
	if data.REPM_InDigState and data.REPM_InDigState + 20 <= game:GetFrameCount() then
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed * 0.5
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.digSlowdown)

local directions = {
	Vector(1, 0),
	Vector(0, 1),
	Vector(-1, 0),
	Vector(0, -1),
}

local function onUpdate(_mod, npc)
	local ply = Isaac.GetPlayer(0)
	local ents = Isaac.GetRoomEntities()
	local level = game:GetLevel()

	if lastRoomIndex ~= level:GetCurrentRoomIndex() then
		lastRoomIndex = level:GetCurrentRoomIndex()
		points = {}
	end

	local room = game:GetRoom()
	local width = room:GetGridWidth()
	local height = room:GetGridHeight()

	local dmgTiles = {}
	for k, v in pairs(points) do
		local point = v.point

		if not v.i then
			v.i = 3
			v.pos = point.Position
		end

		if v.i then
			v.i = v.i + 1
			local i = v.i
			local flag = false
			local index = room:GetGridIndex(v.pos)
			local gridpos = Vector(index % width, math.floor(index / width))

			if i % 4 == 0 then
				for _, dir in pairs(directions) do
					--local index = index + dir.X*i/4 + dir.Y*width*i/4
					local gridpos = gridpos + dir * i / 4
					local index = gridpos.X + gridpos.Y * width
					if gridpos.X > 0 and gridpos.X < width and gridpos.Y > 0 and gridpos.Y < height then
						local pos2 = room:GetGridPosition(index, 1)

						if room:IsPositionInRoom(pos2, 0) then
							local rock = Isaac.Spawn(
								EntityType.ENTITY_EFFECT,
								EffectVariant.ROCK_EXPLOSION,
								0,
								pos2,
								Vector(0, 0),
								point
							)
							room:DestroyGrid(index)
							if not dmgTiles[index] or dmgTiles[index].dmg < v.dmg then
								dmgTiles[index] = v
							end
							flag = true
						end
					end
				end

				if not flag then
					points[k] = nil
				end
			end
		end
	end

	for k, v in pairs(ents) do
		local dat = dmgTiles[room:GetGridIndex(v.Position)]
		if dat and (v:IsVulnerableEnemy()) then
			v:TakeDamage(
				(v.Type == 1 and 0.5 or dat.dmg * 5 + ply.Damage * 2),
				DamageFlag.DAMAGE_EXPLOSION,
				EntityRef(dat.point),
				2
			)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, onUpdate)
-----------------------------------------------------------
--TAINTED FROSTY
-----------------------------------------------------------

function mod:onTaintedFrostyStart(player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
		mod:repmGetPData(player).TFrosty_FreezeTimer = 3000
		--player:SetPocketActiveItem(mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER, ActiveSlot.SLOT_POCKET, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.onTaintedFrostyStart)

function mod:onTaintedFrostyStart2(player)
	RepMMod:AnyPlayerDo(function(player)
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
			and RepMMod:repmGetPData(player).TFrosty_FreezeTimer == nil
		then
			RepMMod:repmGetPData(player).TFrosty_FreezeTimer = 3000
		end
	end)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onTaintedFrostyStart2)

---@param player EntityPlayer
---@param cacheFlag CacheFlag | integer
function mod:baseFrostyCache(player, cacheFlag)
	if
		player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
		or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C
	then
		local pdata = mod:repmGetPData(player)
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck - 3
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + 0.15
		end
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C then
			if cacheFlag == CacheFlag.CACHE_TEARFLAG then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_ICE | TearFlags.TEAR_SPECTRAL
			end
			if cacheFlag == CacheFlag.CACHE_FLYING then
				player.CanFly = true
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.baseFrostyCache)

local newRoom = false

local function IsDoorNearBy(position)
	local room = game:GetRoom()
	for _, slot in ipairs(DoorSlot) do
		local door = room:GetDoor(slot)
		if door and (door.Position - position):Length() < 40 then
			return true
		end
		if StageAPI then
			for _, door in ipairs(StageAPI.GetCustomDoorAtSlot(slot)) do
				if door and (door.Position - position):Length() < 40 then
					return true
				end
			end
		end
	end
	return false
end

function mod:onEnterRoomTFrost()
	local room = game:GetRoom()
	game:GetRoom():UpdateColorModifier(true, false, 1)
	mod:AnyPlayerDo(function(player)
		local pdata = mod:repmGetPData(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and not room:IsClear() then
			pdata.TFrosty_Lit = false
			local destPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(10))
			while IsDoorNearBy(destPos) do
				destPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(10))
			end
			local fire = Isaac.Spawn(33, 1, 0, destPos, Vector(0, 0), nil)
			fire:Die()
			sfx:Stop(SoundEffect.SOUND_FIREDEATH_HISS)
			--mod.saveTable.BlizzFade = game:GetFrameCount() + 125
			newRoomFreeze = true
			sfx:Play(mod.RepmTypes.SFX_WIND)
		end
	end)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onEnterRoomTFrost)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if newRoomFreeze then
		newRoomFreeze = false
		game:SetColorModifier(ColorModifier(0, 0.02, 1, 0.3, 0, 0.8), true, 0.04)
		Isaac.CreateTimer(function()
			game:GetRoom():UpdateColorModifier(true, true, 0.03)
		end, 90, 1, false)
	end
end)

function mod:useBatteredLighter(collectibletype, rng, player, useflags, slot, vardata)
	local fireplaces = Isaac.FindInRadius(player.Position, 150)
	local fireplacesTotal = Isaac.FindByType(33)
	local pdata = mod:repmGetPData(player)
	sfx:Play(mod.RepmTypes.SFX_LIGHTER)
	for i, place in ipairs(fireplacesTotal) do
		if place.Position:Distance(player.Position) < 100 then
			local pos = place.Position
			place:Remove()
			Isaac.Spawn(33, 2, 0, pos, Vector.Zero, nil)
			if pdata.TFrosty_FreezeTimer <= 250 then
				pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 1500
			elseif pdata.TFrosty_FreezeTimer <= 500 then
				pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 1000
			elseif pdata.TFrosty_FreezeTimer <= 1000 then
				pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 500
			else
				pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 250
			end
			sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
			break
		end
	end

	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useBatteredLighter, mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER)

function mod:tFrostyClearRoom()
	mod:AnyPlayerDo(function(player)
		local pdata = mod:repmGetPData(player)
		if pdata.TFrosty_Lit == false and player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
			pdata.TFrosty_Unlit_Count = math.min((pdata.TFrosty_Unlit_Count or 0) + 1, 5)
			if pdata.TFrosty_Unlit_Count == 4 then
				pdata.TFrosty_Unlit_Count = 5
				pdata.TFrosty_StartPoint = game:GetFrameCount()
				pdata.TFrosty_FreezePoint = game:GetFrameCount() + 7200
				player:AnimateSad()
				player:SetPocketActiveItem(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER, ActiveSlot.SLOT_POCKET, false)
				player:DischargeActiveItem(ActiveSlot.SLOT_POCKET)
			end
		end
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER) then
			local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER)
			if rng:RandomInt(100) < 15 then
				player:SetActiveCharge(
					math.min(12, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 1),
					ActiveSlot.SLOT_POCKET
				)
				sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
			end
		end
	end)
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.tFrostyClearRoom)

function mod:tfrosty_OnNewLevel()
	mod:AnyPlayerDo(function(player)
		if player and player:HasCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER) then
			local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER)
			player:SetActiveCharge(
				math.min(12, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 4 + rng:RandomInt(3)),
				ActiveSlot.SLOT_POCKET
			)
			sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
		end
	end)
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.tfrosty_OnNewLevel)

---@param player EntityPlayer
function mod:useHolyLighter(collectibletype, rng, player, useflags, slot, vardata)
	local pdata = mod:repmGetPData(player)
	local wispcount = 0
	sfx:Play(mod.RepmTypes.SFX_LIGHTER)
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
	local Effect =
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 0, player.Position, Vector(0, 0), player)
			:ToEffect()
	Effect:SetDamageSource(EntityType.ENTITY_PLAYER)
	Effect:SetTimeout(300)
	local wisps = {}
	for n, wisp in
		ipairs(
			Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER)
		)
	do
		wisp = wisp:ToFamiliar()
		---@cast wisp EntityFamiliar
		if wisp.Player and GetPtrHash(player) == GetPtrHash(wisp.Player) then
			table.insert(wisps, wisp)
		end
	end
	if #wisps >= 8 then
		for _, wisp in ipairs(wisps) do
			wisp:Remove()
		end
		pdata.TFrosty_FreezeTimer = 3000
		player:ChangePlayerType(mod.RepmTypes.CHARACTER_FROSTY_B)
		player:SetPocketActiveItem(mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER, ActiveSlot.SLOT_POCKET, false)
		if not (game:GetRoom():IsMirrorWorld() or StageAPI and StageAPI.IsMirrorDimension()) then
			player:GetEffects():RemoveNullEffect(NullItemID.ID_LOST_CURSE, -1)
		end
	elseif #wisps <= 3 then
		player:AddWisp(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER, player.Position, true, false)
	end
	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useHolyLighter, mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER)

function mod:OnRoomEntryTFrosty()
	local hasIt = PlayerManager.AnyoneIsPlayerType(mod.RepmTypes.CHARACTER_FROSTY)

	if hasIt and game:GetLevel():GetStage() == 13 then
		local roomdesc = game:GetLevel():GetRoomByIdx(game:GetLevel():GetCurrentRoomIndex())
		if
			roomdesc
			and roomdesc.Flags
			and (roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM)
			and not pgd:Unlocked(mod.RepmAchivements.FROSTY_B.ID)
		then
			if game:GetRoom():IsFirstVisit() then
				local items = Isaac.FindByType(5, 100)
				for i, item in ipairs(items) do
					item:Remove()
				end
				Isaac.Spawn(6, 14, 0, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
			end

			local frosties = Isaac.FindByType(6, 14)
			for i, dude in ipairs(frosties) do
				dude:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_frosty_b.png")
				dude:GetSprite():LoadGraphics()
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnRoomEntryTFrosty)

function mod:onCollisionSecret_Tainted(player, collider, low)
	if collider.Type == 6 and collider.Variant == 14 and game:GetLevel():GetStage() == 13 then
		pgd:TryUnlock(mod.RepmAchivements.FROSTY_B.ID)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.onCollisionSecret_Tainted)

function mod:OnTearLaunchTFrosty(tear)
	local player = mod:GetPlayerFromTear(tear)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and tear.Variant == 0 then
		tear:ChangeVariant(1)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.OnTearLaunchTFrosty)

include("scripts.items.collectibles.saw_shield")

----------------------------------------------------------
--Stalker's Curse
----------------------------------------------------------

local stalkerCurseId = Isaac.GetCurseIdByName("Stalker's Curse!")
local curseSprite = Sprite("gfx/ui/stalker curse.anm2", true)
local stalkerCurseIdBitMask = 1 << (stalkerCurseId - 1)
local function IsStalkerCurseAllowed()
	return game:GetLevel():GetStage() <= LevelStage.STAGE3_2 and not game:IsGreedMode()
		or game:GetLevel():GetStage() <= LevelStage.STAGE3_GREED and game:IsGreedMode()
end
if BetterCurseAPI then
	BetterCurseAPI:registerCurse("Stalker's Curse!", 1, function()
		return false
	end, { curseSprite, "Idle", 0 })
else
	function mod:StalkerCurseInit(curses)
		if curses == 0 and IsStalkerCurseAllowed() then
			local seed = game:GetSeeds():GetStageSeed(game:GetLevel():GetStage())
			local rng = RNG(seed)
			if rng:RandomFloat() <= 0.4 then
				return stalkerCurseIdBitMask
			end
		end
	end
	--mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.StalkerCurseInit)
end

MinimapAPI:AddMapFlag(stalkerCurseId, function()
	return game:GetLevel():GetCurses() & stalkerCurseIdBitMask == stalkerCurseIdBitMask
end, curseSprite, "Idle", 0)
--[[
local annoyingHaunt = Isaac.GetEntityTypeByName("Lil Stalker")

---@param npc EntityNPC
function mod:LilStalkerAI(npc)
	local sprite = npc:GetSprite()
	local data = npc:GetData()
	data.Angle = data.Angle or 0
	data.StateCD = data.StateCD or 150
	data.StateCD = math.max(0, data.StateCD - 1)
	local stopwatchbonus = {
		[1] = 0,
		[2] = -1,
		[3] = 1,
	}
	local attackStateBonus = npc.State == NpcState.STATE_ATTACK and 3 or 0
	data.Angle = (data.Angle + 2 + stopwatchbonus[game:GetRoom():GetBrokenWatchState() + 1] + attackStateBonus) % 360
	if npc.State == NpcState.STATE_INIT then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.Color = Color(1, 1, 1, 0)
		npc.State = NpcState.STATE_IDLE
		sprite:Play("Float", true)
		npc:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
	elseif npc.State == NpcState.STATE_IDLE or npc.State == NpcState.STATE_ATTACK then
		local color = npc.State == NpcState.STATE_ATTACK and Color.Default or Color(1, 1, 1, 0.6)
		if npc:GetPlayerTarget() and npc:GetPlayerTarget():ToPlayer() then
			local player = npc:GetPlayerTarget():ToPlayer()
			local targetPosition = player.Position + Vector.FromAngle(data.Angle):Resized(80)
			npc.Velocity = mod.Lerp(npc.Velocity, (targetPosition - npc.Position))
			local anim = "Float"
			if npc.State == NpcState.STATE_ATTACK then
				anim = anim .. "Chase"
			end
			sprite:Play(anim, false)
		end
		npc.Color = Color.Lerp(npc.Color, color, 0.1)
		if data.StateCD == 0 then
			if npc:GetDropRNG():RandomFloat() < 0.65 then
				if npc.State ~= NpcState.STATE_ATTACK then
					npc.State = NpcState.STATE_ATTACK
				else
					npc.State = NpcState.STATE_IDLE
				end
			end
			data.StateCD = npc:GetDropRNG():RandomInt(90, 240)
		end
	elseif npc.State == NpcState.STATE_DEATH then
		if npc.Color.A == 0 then
			npc:Remove()
		end
	end
	npc.Color = Color.Lerp(npc.Color, Color(1, 1, 1, 0), 0.02)
	if npc.State ~= NpcState.STATE_ATTACK then
		npc:ClearEntityFlags(
			EntityFlag.FLAG_SLOW
				| EntityFlag.FLAG_FRIENDLY
				| EntityFlag.FLAG_CHARM
				| EntityFlag.FLAG_CONFUSION
				| EntityFlag.FLAG_BURN
				| EntityFlag.FLAG_BLEED_OUT
				| EntityFlag.FLAG_POISON
		)
	end
	npc.EntityCollisionClass = npc.State == NpcState.STATE_ATTACK and EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		or EntityCollisionClass.ENTCOLL_NONE
	npc:SetInvincible(npc.State ~= NpcState.STATE_ATTACK)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.LilStalkerAI, annoyingHaunt)

function mod:LilStalkerNewRoom()
	for _, st in ipairs(Isaac.FindByType(annoyingHaunt)) do
		st = st:ToNPC()
		local data = st:GetData()
		if st:GetPlayerTarget() and st:GetPlayerTarget():ToPlayer() then
			local player = st:GetPlayerTarget():ToPlayer()
			st.Position = player.Position + Vector.FromAngle(data.Angle):Resized(80)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.LilStalkerNewRoom)

function mod:LilStalkerCollision(npc)
	if npc.State ~= NpcState.STATE_ATTACK then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.LilStalkerCollision, annoyingHaunt)
]]
include("scripts.items.trinkets.ice_penny")
include("scripts.items.collectibles.frozen_food")
include("scripts.items.collectibles.numb_heart")
include("scripts.items.pick ups.cards.hammer_card")
include("scripts.items.pick ups.pills.groovy")
include("scripts.items.collectibles.strong_spirit")
include("scripts.items.collectibles.portal_d6")
include("scripts.items.pick ups.chests.eee_chest")

mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, function()
	if TitleMenu.GetSprite():GetFilename() ~= "gfx/ui/main menu/titlemenu_repm.anm2" then
		TitleMenu.GetSprite():Load("gfx/ui/main menu/titlemenu_repm.anm2", true)
		TitleMenu.GetSprite():Play("Idle", true)
	end
end)
----------------------------------------------------------
--EID, keep this at the bottom!!
----------------------------------------------------------

if EID then
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY,
		"Spawns two fly orbitals that deflect projectiles#Deflected shots become homing, and freeze any non-boss enemy they touch",
		"Frozen Flies"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS,
		"Friendly Stone Dips will have a 20% chance to spawn out of rocks when they are broken",
		"Friendly Rocks"
	)
	EID:addCollectible(mod.RepmTypes.COLLECTIBLE_NUMB_HEART, "On use, adds 1 frozen heart", "Numb Heart")
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_LIKE,
		"{{ArrowUp}} Adds stats when Isaac plays 'Thumbs up' animation",
		"Like"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BOOK_OF_TALES,
		"Guaranteed to create a crawlspace `I am error` room #Lowers the chance of the devil and angel deal",
		"Book of Tales"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_ADVANCED_KAMIKAZE,
		"Spews fire, depending on the number of enemies in the room",
		"Advanced Kamikadze"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE,
		"Upon use, you swing around an axe, dealing damage to enemies",
		"Sim's Axe"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART,
		"On use, spawns almost all types of hearts",
		"Curious Heart"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK,
		"Creates puddles when fired #If an enemy steps on a puddle, he will turn into stone#Bosses get the slowness effect",
		"strawberry milk"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOLY_SHELL,
		"When fully charged, Isaac fires 4 holy beams",
		"Holy shell"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET,
		"Sometimes creates a puddle of holy water under Isaac",
		"Leaky Bucket"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH,
		"Changes your tears into random lasers of tech items # The lasers come with a random modifier, and the lasers change sometimes",
		"Delirious tech"
	)
	-- EID:addCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM, "Gives 5,25 range#Have a chance to shoot a boomerang tear that deals damage to enemies.", "vacuum" )
	EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BEEG_MINUS, "Kills player on pick up#Thats litteraly it", "Minus")
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE,
		"On use, spawns 3 random familiers on 1 room",
		"Pixelated cube"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_110V,
		"Gives 2 charges for the active item, instead of 1#Damages the player when using the active item",
		"110V"
	)
	EID:addCollectible(mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE, "Make your tears fragmented", "Delirium eye")
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOLY_OTMICHKA,
		"There is a chance to create a eternal chest after clearing a room.",
		"Holy master key"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_FLOWER_TEA,
		"{{ArrowUp}} {{Blank}} {{Damage}} +0.60 damage#{{ArrowUp}} {{Blank}} {{Range}} +0.50 range#{{ArrowDown}} {{Blank}} {{Shotspeed}} -0.20 shot speed",
		"Flower tea"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_DEAL_OF_THE_DEATH,
		"{{ArrowUp}} {{Blank}} {{Speed}} +0.30 speed#{{ArrowUp}} {{Blank}} {{Damage}} +1 damage#{{ArrowUp}} {{Blank}} {{Tears}} +0.61 tears#{{ArrowUp}} {{Blank}} {{Luck}} +5 luck#{{ArrowDown}} {{Blank}} {{Shotspeed}} -0.10 shot speed#Gives flight and spectral tears#{{DeathMark}} Getting hit kills you",
		"Deal of the death"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_SANDWICH,
		"{{ArrowUp}} {{Blank}} {{Damage}} +0.50 damage#{{ArrowUp}} {{Blank}} {{Tears}} +0.09 tears",
		"Sandwich"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER,
		"On use, spawns any charmed skeleton enemies#8% chance to give user a {{EmptyBoneHeart}} bone heart",
		"Book of necromancer"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_VHS,
		"{{ArrowUp}} {{Blank}} {{Speed}} +0.4 speed#{{ArrowUp}} {{Blank}} {{TearsizeSmall}} Gives from 0 to 4 extra tear damage#Gives the screen a vhs effect for the rest of the run#More copies make effect stronger",
		"VHS cassette"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_ROT,
		"When entering a room, the player leaves a poisonous clouds that follows him#Effect last for 6 seconds",
		"Rot"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BLOODY_NEGATIVE,
		"{{ArrowUp}} On use, removes {{EmptyHeart}} 1 heart container, but in return it gives {{Speed}} +0.15 speed, {{Tears}} +0.20 tears, {{Damage}} +0.20 damage and {{Range}} range#{{ArrowUp}} If you use the active again, the added characteristics are multiplied by 2",
		"Bloddy negative"
	)
	EID:addCollectible(mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD, "+1 Frozen heart", "Frozen Food")
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_SIREN_HORNS,
		"{{Chargeable}} When fully charged, Isaac begins to sing to charm enemies#Сharmed enemies give familiars small buff on death",
		"Siren Horns"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOW_TO_DIG,
		"Isaac burrows underground with the ability to break stones and doors #Monsters cannot attack him",
		"How To Dig"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER,
		"Lights fires if Isaac is near him",
		"Battered Lighter"
	)
	EID:addCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER, "Reverse transformation", "Holy Lighter")

	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_PORTAL_D6,
		"When used, it sucks in all pickups and objects",
		"Portal D6"
	)

	local function PortalD6ModifierCondition(descObj)
		if
			descObj.ObjType == 5
			and descObj.ObjVariant == 100
			and descObj.ObjSubType == mod.RepmTypes.COLLECTIBLE_PORTAL_D6
			and EID:getLanguage() == "en_us"
		then
			return mod.saveTable.PortalD6 and #mod.saveTable.PortalD6 > 0
		end
		return false
	end

	local function PortalD6ModifierCallback(descObj)
		descObj.Description =
			"All items previosly affected Portal D6 will back, but rerolled on another pool of room in this stage"
		return descObj
	end

	EID:addDescriptionModifier("Portal D6 EID Modifier", PortalD6ModifierCondition, PortalD6ModifierCallback)

	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_SAW_SHIELD,
		"{{Throwable}} Creates throwable shield with saws#After being thrown, flies and bownces of the walls and rocks#After "
			.. mod.sawShieldBounces
			.. " bounces shield slows down#After full stop will return automatically to thrower after "
			.. mod.sawShieldReturnCooldown
			.. " seconds if not picked up#{{BleedingOut}} Enemies hit by shield can get bleeding",
		"Saw Shield"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_STRONG_SPIRIT,
		"Taking fatal damage invokes the effects of {{Collectible58}} Book of Shadows, heals {{Heart}} 2 full Red Heart containers, and adds a {{SoulHeart}} Soul Heart#Taking fatal also grants {{ArrowUp}} {{Blank}} {{Damage}} +5 flat damage which fades over the course of 20 seconds#The effect can be triggered once per floor. Its availability is indicated by a white halo high above Isaac's head",
		"Strong Spirit"
	)
	--ru
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY,
		"Создает двух орбитальных мух, которые отражают снаряды.#Отражённые выстрелы становятся самонаводящимися и замораживают любого врага (кроме боссов), которого они касаются",
		"Морозные мухи",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS,
		"Дружелюбные камни-какашки, могут появится из разрушенных камней с вероятностью 20%",
		"Дружелюбные камни",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_NUMB_HEART,
		"При использовании даёт 1 замороженное сердце",
		"Онемевшее сердце",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_LIKE,
		"{{ArrowUp}} Дает прибавку к характеристикам, когда Айзек проигрывает анимацию большого пальца",
		"Лайк",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BOOK_OF_TALES,
		"Гарантировано создаёт подполье с комнатой: «Я ошибка». # Снижает вероятность сделки дьявола и ангела",
		"Книга сказок",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_ADVANCED_KAMIKAZE,
		"Извергает огонь от Айзека в зависимости от количества врагов в комнате",
		"Продвинутый Камикадзе",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE,
		"При использовании вы размахиваете топором",
		"Топор Сима",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART,
		"При использовании создает почти все типы сердец",
		"Любопытное сердце",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK,
		"Создает лужи при выстреле#Если враг наступит на лужу, то он превратится в камень#Боссы получат эффект замедления",
		"Клубничное молоко",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOLY_SHELL,
		"При полной зарядке Айзек выпускает 4 святых луча",
		"Святая оболочка",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET,
		"Иногда создает лужу святой воды под Айзеком",
		"Дырявое ведро",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH,
		"Превращает ваши слезы в случайные лазеры технологий # Лазеры имеют случайный модификатор",
		"Технология сумашествия",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BEEG_MINUS,
		"Убивает игрока при поднятии#Буквально",
		"Минус",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE,
		"При использовании создает 3 случайных фамильяров в 1 комнате",
		"Пиксилизированый куб",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_110V,
		"Заряжает предмет на 2 деления вместо 1#Наносит урон игроку при использовании активного предмета",
		"110 Вольт",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE,
		"При подборе дает 1 треснутое сердце {{BrokenHeart}}, и случайный тип слезы со случайным эффектом #{{Warning}}Всего 3 раза{{Warning}}",
		"Глаз сумашествия",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOLY_OTMICHKA,
		"Есть шанс создать вечный сундук после зачистки комнаты",
		"Святая отмычка",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_FLOWER_TEA,
		"{{ArrowUp}} {{Blank}} {{Damage}} +0.60 урона, {{ArrowUp}} {{Blank}} {{Range}} -0.50 дальность#{{ArrowDown}}#{{ArrowDown}} {{Blank}} {{Shotspeed}} -0.20 скорость слезы",
		"Цветочный чай",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_DEAL_OF_THE_DEATH,
		"{{ArrowUp}} {{Blank}} {{Damage}} +1 к урону#{{ArrowUp}} {{Blank}} {{Luck}} +5 удачи#{{ArrowUp}} {{Blank}} {{Tears}} +0.61 к скорострельности#{{ArrowUp}} {{Blank}} {{Speed}} +0.30 скорости#{{ArrowDown}} {{Blank}} {{Shotspeed}} -0.10 к скорости слезы#Дает полет и призрачные слезы#{{DeathMark}} Убивает при получении любого урона",
		"Сделка со смертью",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_SANDWICH,
		"{{ArrowUp}} {{Blank}} {{Damage}} +0.50 урона# {{ArrowUp}} {{Blank}} {{Tears}} +0.09 к скорострельности",
		"Бутерброд",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER,
		"При использовании создает дружелюбных скелетов#8% шанс дать Айзеку {{EmptyBoneHeart}} костяное сердце",
		"Книга некроманта",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_VHS,
		"{{ArrowUp}} {{Blank}} {{Speed}} +0.4 скорости#{{ArrowUp}} {{Blank}} {{TearsizeSmall}} Дает от 0 до 4 дополнительного урона слезы#Придает экрану эффект Кассеты до конца забега#Чем больше кассет, тем сильнее эффект",
		"ВХС Кассета",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_ROT,
		"При входе в комнату игрок оставляет за собой ядовитые облака #Эффект длится 6 секунд",
		"Гниль",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BLOODY_NEGATIVE,
		"{{ArrowUp}} При использовании убирает {{EmptyHeart}} 1 контейнер сердца, но взамен дает {{Speed}} +0.15 скорости, {{Tears}} +0.20 скорострельность, {{Damage}} +0.20 урона и {{Range}} дальности действия#{{ArrowUp}} При повторном использовании активки добавленные характеристики умножаются на 2",
		"Кровавый минус",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD,
		"+1 Лдеяное сердце",
		"Замороженная еда",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_SIREN_HORNS,
		"{{Chargeable}} При полной зарядке Айзек начинает петь, очаровывая врагов#Очарованные враги при смерти дают небольшой бонус фамильярам",
		"Рога сирены",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOW_TO_DIG,
		"Айзек закапывается под землю с возможностью ломать камни и двери #Монстры не могут на него напасть",
		"Как копать",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER,
		"Зажигает костры, если Айзек рядом с ним",
		"Потрепанная зажигалка",
		"ru"
	)
	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER,
		"Обратная трансформация",
		"Святая зажигалка",
		"ru"
	)
	EID:addCollectible(
		Isaac.GetItemIdByName("Portal D6"),
		"При использовании засасывает все пикапы и предметы",
		"Портальный Д6",
		"ru"
	)

	local function PortalD6ModifierConditionRu(descObj)
		if
			descObj.ObjType == 5
			and descObj.ObjVariant == 100
			and descObj.ObjSubType == mod.RepmTypes.COLLECTIBLE_PORTAL_D6
			and EID:getLanguage() == "ru"
		then
			return mod.saveTable.PortalD6 and #mod.saveTable.PortalD6 > 0
		end
		return false
	end

	local function PortalD6ModifierCallbackRu(descObj)
		descObj.Description =
			"Все ранее всосанные предметы появятся в этой комнате, но будут переролены в другой предмет другого пула одной из комнат на этаже"
		return descObj
	end

	EID:addDescriptionModifier("Portal D6 EID Modifier RU", PortalD6ModifierConditionRu, PortalD6ModifierCallbackRu)

	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_SAW_SHIELD,
		"{{Throwable}} Создает щит с лезвиями, который можно бросать#После броска летает и отскакивает от стен и камней#После "
			.. mod.sawShieldBounces
			.. " отскоков замедляется#После полной остановки возвращается к бросившему игроку после "
			.. mod.sawShieldReturnCooldown
			.. " секунд, если его не подобрать#{{BleedingOut}} Враги могут начать истекать кровью при получении урона",
		"Пилощит",
		"ru"
	)

	EID:addCollectible(
		mod.RepmTypes.COLLECTIBLE_STRONG_SPIRIT,
		"Получение смертельного урона вызывает эффект {{Collectible58}} Книги теней, исцеляет {{Heart}} 2 полных контейнера красного сердца и добавляет {{SoulHeart}} сердце души#Получение смертельного урона также дает {{ArrowUp}} {{Blank}} {{Damage}} +5 урона, который исчезает в течение 20 секунд#Эффект может быть вызван один раз за этаж. На его наличие указывает белый ореол над головой Айзека",
		"Сильный дух",
		"ru"
	)

	--trinkets
	EID:addTrinket(
		mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY,
		"Increases damage taken by champion monsters",
		"Pocket Technology"
	)
	EID:addTrinket(
		mod.RepmTypes.TRINKET_MICRO_AMPLIFIER,
		"Each new floor adds 1 characteristic#Only 1 characteristic changes",
		"Micro Amplifier"
	)
	EID:addTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID, "???", "Frozen Polaroid")
	EID:addTrinket(
		mod.RepmTypes.TRINKET_BURNT_CLOVER,
		"{{Warning}}Disposable{{Warning}}#When entering the treasure room{{TreasureRoom}}, the item is replaced with an item with quality{{Quality4}}",
		"Burnt Clover"
	)
	EID:addTrinket(
		mod.RepmTypes.TRINKET_MORE_OPTIONS,
		"Creates a special item next to goods for 30 cents in the shop{{Shop}}",
		"MORE OPTIONS"
	)
	EID:addTrinket(mod.RepmTypes.TRINKET_HAMMER, "Аllows you to destroy stones using tears", "Hammer")
	EID:addTrinket(
		mod.RepmTypes.TRINKET_ICE_PENNY,
		"Picking up coins has chance to spawn half ice heart. Rarely full one",
		"Ice Penny"
	)
	--ru
	EID:addTrinket(
		mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY,
		"Увеличивает получаемый урон монстрам-чемпионам",
		"Карманная технология",
		"ru"
	)
	EID:addTrinket(
		mod.RepmTypes.TRINKET_MICRO_AMPLIFIER,
		"Каждый новый этаж прибавляет 1 характеристику#Меняется только 1 характеристика",
		"Микро усилитель",
		"ru"
	)
	EID:addTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID, "???", "Замороженный полароид", "ru")
	EID:addTrinket(
		mod.RepmTypes.TRINKET_BURNT_CLOVER,
		"{{Warning}}Одноразовый{{Warning}}#При входе в сокровищницу{{TreasureRoom}} предмет заменяется предметом с качеством{{Quality4}}",
		"Жженый клевер",
		"ru"
	)
	EID:addTrinket(
		mod.RepmTypes.TRINKET_MORE_OPTIONS,
		"Cоздает рядом с товарами особый предмет за 30 центов в магазине{{Shop}}",
		"БОЛЬШЕ ОПЦИЙ",
		"ru"
	)
	EID:addTrinket(
		mod.RepmTypes.TRINKET_HAMMER,
		"Позволяет разрушать камни с помощью слез",
		"Молоточек",
		"ru"
	)
	EID:addTrinket(
		mod.RepmTypes.TRINKET_ICE_PENNY,
		"Шанс заспавнить половинку ледяного серца при подборе монет. Реже - полное ледяное сердце",
		"Ледяной пенни",
		"ru"
	)
	local iceHud = Sprite()
	iceHud:Load("gfx/cards_2_icicle.anm2", true)
	EID:addIcon("Card" .. tostring(iceCard), "HUDSmall", 0, 16, 16, 6, 6, iceHud)
end

local ItemTranslate = include("scripts.lib.translation.ItemTranslation")
ItemTranslate("RepMinus")

local translations = {
	"ru",
}
for i = 1, #translations do
	local module = include("scripts.lib.translation." .. translations[i])
	module(mod)
end

--example:
--EID:addCollectible(id of the item, "description of the item", "item name", "en_us(language)")
