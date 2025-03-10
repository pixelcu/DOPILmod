local mod = RepMMod

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod:AnyPlayerDo(function(player)
		---@type {GasesCountDown: number}
		local data = mod:GetData(player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_ROT) then
			data.GasesCountDown = 240
		end
	end)
end)

---@param Player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, Player)
	---@type {GasesCountDown: number}
	local Data = mod:GetData(Player)
	if Data.GasesCountDown ~= nil and Data.GasesCountDown > 0 and not Game():GetLevel():GetCurrentRoom():IsClear() then
		if Data.GasesCountDown % 10 == 0 then
			---@type EntityEffect
			local Effect = Isaac.Spawn(
				EntityType.ENTITY_EFFECT,
				EffectVariant.SMOKE_CLOUD,
				0,
				Player.Position,
				Vector(0, 0),
				Player
			):ToEffect()
			Effect:SetDamageSource(EntityType.ENTITY_PLAYER)
			Effect:SetTimeout(100)
		end
		Data.GasesCountDown = Data.GasesCountDown - 1
	end
end)