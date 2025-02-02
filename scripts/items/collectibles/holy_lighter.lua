local mod = RepMMod
local sfx = SFXManager()

local function useHolyLighter(_, collectibletype, rng, player, useflags, slot, vardata)
	local pdata = mod:repmGetPData(player)
	sfx:Play(mod.RepmTypes.SFX_LIGHTER)
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
	local Effect =
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 0, player.Position, Vector(0, 0), player)
			:ToEffect()
	Effect:SetDamageSource(EntityType.ENTITY_PLAYER)
	Effect:SetTimeout(300)
	local wisps = mod.Filter(
		Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER),
		function(_, wisp)
			return GetPtrHash(wisp:ToFamiliar().Player) == GetPtrHash(player)
		end
	)
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
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useHolyLighter, mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER)
