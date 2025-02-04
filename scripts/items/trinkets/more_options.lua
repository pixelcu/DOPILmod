local mod = RepMMod
local spawnPos = Vector(500, 140)

local function options_Wow_Room()
	local room = Game():GetRoom()

	if PlayerManager.AnyoneHasTrinket(mod.RepmTypes.TRINKET_MORE_OPTIONS) and room:IsFirstVisit() and room:GetType() == RoomType.ROOM_SHOP then
		local Itempool = Game():GetItemPool()
		local pos = Isaac.GetFreeNearPosition(spawnPos, 40)
		local rng = RNG(Game():GetLevel():GetCurrentRoomDesc().SpawnSeed)
		local seed = Game():GetLevel():GetCurrentRoomDesc().AwardSeed
		--rng:SetSeed(seed, 35)
		local ItemId = mod.GetByQuality(3, 4, Itempool:GetPoolForRoom(RoomType.ROOM_SHOP, seed), rng)
		if ItemId then
			local obj = Isaac.Spawn(5, 100, ItemId, pos, Vector.Zero, nil):ToPickup()
			obj:Update()

			obj.Price = 30
			obj.ShopItemId = -1
			obj.AutoUpdatePrice = false
			obj:Update()
			if PlayerManager.AnyoneHasTrinket(CollectibleType.COLLECTIBLE_STEAM_SALE) then
				obj.Price = 15
			end
			local poof = Isaac.Spawn(1000, 16, 1, pos, Vector.Zero, nil):ToEffect()
			poof:GetSprite().Scale = Vector(0.6, 0.6)
			poof.Color = Color(0.5, 0.5, 0.5, 1)
			SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 1, 2, false, 1, 0)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, options_Wow_Room)