local mod = RepMMod

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, _, player, flags)
	mod:repmGetPData(player).GroovyImmune = true
	if player:HasFullHearts() then
		Isaac.Spawn(5, 10, 1, player.Position, Vector.FromAngle(math.random(360)) * 3, nil)
		Isaac.Spawn(5, 10, 1, player.Position, Vector.FromAngle(math.random(360)) * 3, nil)
		Isaac.Spawn(5, 10, 1, player.Position, Vector.FromAngle(math.random(360)) * 3, nil)
	end
	Isaac.CreateTimer(function()
		mod:repmGetPData(player).GroovyImmune = false
	end, 600, 1, true)
	player:AddHearts(3)
	player:AnimateHappy()
end, mod.RepmTypes.PILL_EFFECT_GROOVY)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, amount, DamageFlag)
	if player and player:ToPlayer() then
        if mod:repmGetPData(player:ToPlayer()).GroovyImmune == true then
            return false
        end
    end
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod:AnyPlayerDo(function(player)
		mod:repmGetPData(player).GroovyImmune = false
	end)
end)