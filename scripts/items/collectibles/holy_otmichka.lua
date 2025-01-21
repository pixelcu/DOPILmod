local mod = RepMMod
local game = Game()

local function onUpdate_Otmichka()
	local spawnpos = game:GetRoom():FindFreeTilePosition(game:GetRoom():GetCenterPos(), 400)

	if PlayerManager.AnyoneHasCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_OTMICHKA) then
		if math.random(1, 7) == 5 then
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_ETERNALCHEST,
				0,
				spawnpos, --Vector(320, 320),
				Vector(0, 0),
				nil
			)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, onUpdate_Otmichka)