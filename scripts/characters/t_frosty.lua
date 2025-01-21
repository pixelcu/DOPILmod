local mod = RepMMod

local function TFrostTimer(_, player)
	local pdata = mod:repmGetPData(player)

	if pdata.TFrosty_FreezeTimer and pdata.TFrosty_FreezeTimer > 0 then
		pdata.TFrosty_FreezeTimer = math.min(3000, pdata.TFrosty_FreezeTimer - 1)
	elseif pdata.TFrosty_FreezeTimer and pdata.TFrosty_FreezeTimer == 0 then
		pdata.TFrosty_FreezeTimer = nil
		player:ChangePlayerType(mod.RepmTypes.CHARACTER_FROSTY_C)
		SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 1, 0)
		player:AnimateSad()
		player:SetPocketActiveItem(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER, ActiveSlot.SLOT_POCKET, false)
		player:DischargeActiveItem(ActiveSlot.SLOT_POCKET)
		if not (Game():GetRoom():IsMirrorWorld() or StageAPI and StageAPI.IsMirrorDimension()) then
			player:GetEffects():AddNullEffect(NullItemID.ID_LOST_CURSE, 1)
		end
		player:EvaluateItems()
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, TFrostTimer, 0)

--[[RepMMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, flag)
	if
		ent:ToPlayer()
		and ent:ToPlayer():GetPlayerType() == (RepMMod.RepmTypes.CHARACTER_FROSTY_C)
		and flag & DamageFlag.DAMAGE_NO_PENALTIES == 0
	then
		ent:Kill()
	end
end, 1)]]

---@param entity Entity
---@param damage any
---@param flags any
---@param source any
---@param cd any
local function WispTGFSpawn(_, entity, damage, flags, source, cd)
	if entity:IsEnemy() and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() 
    and entity:HasMortalDamage() then
        mod:AnyPlayerDo(function(player)
            if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C then
                if player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER):RandomFloat() <= 0.2 then
                    player:AddWisp(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER, entity.Position, true, false)
                end
            end
        end)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, WispTGFSpawn)