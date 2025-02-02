local mod = RepMMod

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

local function PixelatedCubeUse(_, itemID, rng, player)
	-- pixelated cube
	local BabyNumber = PixelatedCubeBabiesList[rng:RanomdInt(1, 30)]
	player:GetEffects():AddCollectibleEffect(BabyNumber, false)
	local BabyNumber = PixelatedCubeBabiesList[rng:RanomdInt(1, 30)]
	player:GetEffects():AddCollectibleEffect(BabyNumber, false)
	local BabyNumber = PixelatedCubeBabiesList[rng:RanomdInt(1, 30)]
	player:GetEffects():AddCollectibleEffect(BabyNumber, false)
	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, PixelatedCubeUse, mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE)