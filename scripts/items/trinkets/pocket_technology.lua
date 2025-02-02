local mod = RepMMod

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flag, source, countdown)	
    if PlayerManager.AnyoneHasTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY) then
        if entity:IsEnemy() and entity:IsActiveEnemy(true) and entity:IsVulnerableEnemy() then
            local npc = entity:ToNPC()

            if npc:IsChampion() or (npc:IsBoss() and npc:GetBossColorIdx() >= 0) then
                local mul = PlayerManager.GetTotalTrinketMultiplier(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)
                return {Damage = amount * math.max(1, mul), DamageFlags = flag, DamageCountdown = countdown}
            end
        end
    end
end)