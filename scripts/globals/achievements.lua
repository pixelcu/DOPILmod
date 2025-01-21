local mod = RepMMod
local pgd = Isaac.GetPersistentGameData()

local SimMarks = {
	[CompletionType.MOMS_HEART] = nil,
	[CompletionType.ISAAC] = nil,
	[CompletionType.SATAN] = nil,
	[CompletionType.BOSS_RUSH] = nil,
	[CompletionType.BLUE_BABY] = nil,
	[CompletionType.LAMB] = mod.RepmAchivements.SIM_LAMB.ID,
	[CompletionType.MEGA_SATAN] = nil,
	[CompletionType.ULTRA_GREED] = nil,
	[CompletionType.ULTRA_GREEDIER] = nil,
	[CompletionType.DELIRIUM] = mod.RepmAchivements.SIM_DELIRIUM.ID,
	[CompletionType.MOTHER] = nil,
	[CompletionType.BEAST] = nil,
	[CompletionType.HUSH] = nil,
}

local FrostyMarks = {
	[CompletionType.MOMS_HEART] = nil,
	[CompletionType.ISAAC] = nil,
	[CompletionType.SATAN] = mod.RepmAchivements.DEATH_CARD.ID,
	[CompletionType.BOSS_RUSH] = nil,
	[CompletionType.BLUE_BABY] = nil,
	[CompletionType.LAMB] = mod.RepmAchivements.SIM_LAMB.ID,
	[CompletionType.MEGA_SATAN] = nil,
	[CompletionType.ULTRA_GREED] = nil,
	[CompletionType.ULTRA_GREEDIER] = nil,
	[CompletionType.DELIRIUM] = mod.RepmAchivements.SIM_DELIRIUM.ID,
	[CompletionType.MOTHER] = nil,
	[CompletionType.BEAST] = nil,
	[CompletionType.HUSH] = nil,
}

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	if
		player:GetPlayerType() == RepMMod.RepmTypes.CHARACTER_FROSTY
		and pgd:Unlocked(RepMMod.RepmAchivements.FROSTY.ID) == false
	then
		player:ChangePlayerType(0)
	elseif
		(
			player:GetPlayerType() == RepMMod.RepmTypes.CHARACTER_FROSTY_B
			or player:GetPlayerType() == RepMMod.RepmTypes.CHARACTER_FROSTY_C
		) and pgd:Unlocked(RepMMod.RepmAchivements.FROSTY_B.ID) == false
	then
		player:ChangePlayerType(RepMMod.RepmTypes.CHARACTER_FROSTY)
	elseif player:GetPlayerType() == RepMMod.RepmTypes.CHARACTER_SIM_B then
		player:ChangePlayerType(RepMMod.RepmTypes.CHARACTER_SIM)
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_COMPLETION_EVENT, function(_, mark)
	if
		#mod.Filter(PlayerManager.GetPlayers(), function(player)
			return player:GetPlayerType() == RepMMod.RepmTypes.CHARACTER_SIM and not player.Parent
		end) > 0
	then
		if SimMarks[mark] then
			pgd:TryUnlock(SimMarks[mark])
		end
	end
end)
