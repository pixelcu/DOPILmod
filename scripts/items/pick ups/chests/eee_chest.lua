local mod = RepMMod

local function optionsCheck(pickup)
	if pickup.OptionsPickupIndex and pickup.OptionsPickupIndex > 0 then
		for _, entity in pairs(Isaac.FindByType(5, -1, -1)) do
			if
				entity:ToPickup().OptionsPickupIndex
				and entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex
				and GetPtrHash(entity:ToPickup()) ~= GetPtrHash(pickup)
			then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
				entity:Remove()
			end
		end
	end
end

---@param pickup EntityPickup
local function onPrePickupGetLootList(_, pickup, shouldAdvance)
	if pickup.Variant == mod.RepmTypes.EEE_CHEST then
		local rng = pickup:GetDropRNG()
		local loot = LootList()
		if rng:RandomFloat() <= 0.1 then
			--local pedestal =
			--Isaac.Spawn(5, 100, game:GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET), pickup.Position, Vector.Zero, pickup)
			--pedestal:GetSprite():ReplaceSpritesheet(5, "gfx/items/pick ups/EEE_pedestal.png")
			--pedestal:GetSprite():LoadGraphics()
			--pickup:Remove()
			loot:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Game():GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET))
		else
			local rolls = 1
			for i = 1, 2 do
				if rng:RandomInt(4) > rolls then
					rolls = rolls + 1
				end
			end
			if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_LUCKY_TOE) then
				rolls = rolls + 1
			end
			local modC = 1
			if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MOMS_KEY) then
				modC = modC + 1
			end

			local overpaid = 0
			for i = 1, rolls do
				local payout = math.random(5)
				if payout <= 1 then
					for i = 1, modC do
						--Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
						loot:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL)
						print("heart full")
					end
				elseif payout <= 2 then
					for i = 1, modC do
						--Isaac.Spawn(5, 10, HeartSubType.HEART_HALF, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
						loot:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF)
						print("heart half")
					end
				elseif payout <= 3 then
					for i = 1, modC do
						--Isaac.Spawn(5, 10, HeartSubType.HEART_DOUBLEPACK, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
						loot:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK)
						print("heart double")
					end
				elseif payout <= 4 then
					--Isaac.Spawn(5, 300, math.random(56, 77), pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
					local card = math.random(56, 77)
					loot:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card)
					overpaid = overpaid + 1
					print(card)
				elseif payout <= 5 then
					loot:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, mod.RepmTypes.CARD_MINUS_SHARD)
					print("shard")
					overpaid = overpaid + 1
					if i + overpaid >= rolls then
						break
					end
				end
			end
		end
		return loot
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_GET_LOOT_LIST, onPrePickupGetLootList)

---@param pickup EntityPickup
---@param player EntityPlayer
function mod.openEEEChest(pickup, player)
	optionsCheck(pickup)
	pickup.SubType = ChestSubType.CHEST_OPENED
	pickup:GetSprite():Play("Open")
	for _, item in pairs(pickup:GetLootList():GetEntries()) do
		--print(item:GetType().." : "..item:GetVariant().." : "..item:GetSubType())
		if item:GetType() == EntityType.ENTITY_PICKUP then
			if item:GetVariant() == PickupVariant.PICKUP_COLLECTIBLE then
			local pedestal = Isaac.Spawn(item:GetType(), item:GetVariant(), item:GetSubType(), pickup.Position, Vector.Zero, pickup)
			pedestal:GetSprite():ReplaceSpritesheet(5, "gfx/items/pick ups/EEE_pedestal.png")
			pedestal:GetSprite():LoadGraphics()
			pickup:Remove()
			else
				Isaac.Spawn(item:GetType(), item:GetVariant(), item:GetSubType(), pickup.Position, EntityPickup.GetRandomPickupVelocity(pickup.Position, item:GetRNG(), 0), nil)
			end
		end
	end
	SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN, 1, 2, false, 1, 0)
end

local function chestCollision(_, pickup, collider, _)
	if not collider:ToPlayer() then
		return
	end
	local player = collider:ToPlayer()
	local sprite = pickup:GetSprite()
	if pickup.Variant == mod.RepmTypes.EEE_CHEST and pickup.SubType == ChestSubType.CHEST_CLOSED then
		if sprite:IsPlaying("Appear") then
			return false
		end
		if pickup.Variant == mod.RepmTypes.EEE_CHEST then
			mod.openEEEChest(pickup, player)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, chestCollision, mod.RepmTypes.EEE_CHEST)

local function chestInit(_, pickup)
	if pickup.Variant == mod.RepmTypes.EEE_CHEST and pickup.SubType == ChestSubType.CHEST_OPENED then
		pickup:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, chestInit)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, function(_, pickup, eType, Variant, SubType)
    if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == mod.RepmTypes.EEE_CHEST and pickup.SubType == ChestSubType.CHEST_OPENED then
        return false
    end
end)

local function chestSpawn(_, pickup)
	if Isaac.GetPersistentGameData():Unlocked(RepMMod.RepmAchivements.SIM_LAMB.ID) then
		if
			Game():GetRoom():GetType() ~= RoomType.ROOM_CHALLENGE
			and Game():GetLevel():GetStage() ~= LevelStage.STAGE6
		then
			local rng = pickup:GetDropRNG()
			if pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and rng:RandomFloat() <= 0.01 or 
            pickup.Variant == PickupVariant.PICKUP_REDCHEST and rng:RandomFloat() <= 0.25 then
				pickup:Morph(5, mod.RepmTypes.EEE_CHEST, 1, true, true, false)
				SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 2, false, 1, 0)
			end
		end
	end
end
mod:AddCallback("REPM_PICKUP_INIT_FIRST", chestSpawn)