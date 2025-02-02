local mod = RepMMod

---@param rock GridEntityRock
mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, function(_, rock, type, immediate)
	local players = mod.Filter(PlayerManager.GetPlayers(), function(_, player) return player:HasCollectible(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS) end)
	if rock:ToRock() and rock:GetRNG():RandomFloat() <= 0.9 and #players > 0 then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, DipSubType.PETRIFIED, rock.Position, Vector.Zero, players[rock:GetRNG():RandomInt(1, #players)])
	end
end)