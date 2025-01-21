local mod = RepMMod

local function onFrostyInit(_, player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY then
		player:AddSoulHearts(-1)
		CustomHealthAPI.Library.AddHealth(player, "HEART_ICE", 6, true)
		if not Isaac.GetPersistentGameData():Unlocked(mod.RepmAchivements.DEATH_CARD.ID) then
			player:RemovePocketItem(PillCardSlot.PRIMARY)
		end
	end
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
		player:AddSoulHearts(-1)
		CustomHealthAPI.Library.AddHealth(player, "HEART_ICE", 8, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, onFrostyInit)

local function PostNewRoom()
	-- just in case it gets interrupted
   RepMMod:AnyPlayerDo(function(player)
	   if
		   player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C
		   and not player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
	   then
		   player:GetEffects():AddNullEffect(NullItemID.ID_LOST_CURSE, false, 1)
	   end
   end)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)