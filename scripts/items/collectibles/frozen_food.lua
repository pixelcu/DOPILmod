local mod = RepMMod

local function OnGainFrozenFood(_, collectible, charge, first, slot, vardata, player)
	if first then
		CustomHealthAPI.Library.AddHealth(player, "HEART_ICE", 2, true)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, OnGainFrozenFood, mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD)