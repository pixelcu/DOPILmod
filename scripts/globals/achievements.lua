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
	[CompletionType.MOTHER] = mod.RepmAchivements.ROT.ID,
	[CompletionType.BEAST] = nil,
	[CompletionType.HUSH] = nil,
}

local FrostyMarks = {
	[CompletionType.MOMS_HEART] = nil,
	[CompletionType.ISAAC] = nil,
	[CompletionType.SATAN] = mod.RepmAchivements.DEATH_CARD.ID,
	[CompletionType.BOSS_RUSH] = nil,
	[CompletionType.BLUE_BABY] = mod.RepmAchivements.NUMB_HEART.ID,
	[CompletionType.LAMB] = nil,
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

	if
		#mod.Filter(PlayerManager.GetPlayers(), function(player)
			return player:GetPlayerType() == RepMMod.RepmTypes.CHARACTER_FROSTY and not player.Parent
		end) > 0
	then
		if FrostyMarks[mark] then
			pgd:TryUnlock(FrostyMarks[mark])
		end
	end
	
	if Isaac.GetCompletionMark(mod.RepmTypes.CHARACTER_SIM, CompletionType.MOMS_HEART) > 0
	and Isaac.GetCompletionMark(mod.RepmTypes.CHARACTER_FROSTY, CompletionType.MOMS_HEART) > 0 then
		pgd:TryUnlock(mod.RepmAchivements.IMPROVED_CARDS.ID)
	end
	
end)

local function OnEnterSecretExit()
	local room = Game():GetRoom()
	local level = Game():GetLevel()
	if
		room:GetType() == RoomType.ROOM_SECRET_EXIT
		and (level:GetStage() == LevelStage.STAGE3_2 or level:GetStage() == LevelStage.STAGE3_1 and level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0)
		and level:GetStageType() <= StageType.STAGETYPE_AFTERBIRTH
		and mod.saveTable.repM_FrostyUnlock
	then
		for i = 1, room:GetGridSize() do
			local ge = room:GetGridEntity(i)
			if ge and ge.Desc.Type ~= GridEntityType.GRID_DOOR then
				room:RemoveGridEntity(i, 0)
			end
		end
		if room:IsFirstVisit() then
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			for i, item in ipairs(items) do
				item:Remove()
			end
			Isaac.Spawn(
				EntityType.ENTITY_SLOT,
				SlotVariant.HOME_CLOSET_PLAYER,
				0,
				room:GetCenterPos(),
				Vector.Zero,
				nil
			)
		end

		local frosties = Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER)
		for i, dude in ipairs(frosties) do
			dude:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_frosty.png", true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnEnterSecretExit)

local function OnRoomEntryTFrosty()
	local level = Game():GetLevel()
	local room = Game():GetRoom()
	if PlayerManager.AnyoneIsPlayerType(mod.RepmTypes.CHARACTER_FROSTY) and level:GetStage() == LevelStage.STAGE8 then
		local roomdesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
		if
			roomdesc
			and roomdesc.Flags
			and (roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM)
			and not pgd:Unlocked(mod.RepmAchivements.FROSTY_B.ID)
		then
			if room:IsFirstVisit() then
				local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
				for i, item in ipairs(items) do
					item:Remove()
				end
				Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER, 0, room:GetCenterPos(), Vector.Zero, nil)
			end

			local frosties = Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER)
			for i, dude in ipairs(frosties) do
				dude:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_frosty_b.png")
				dude:GetSprite():LoadGraphics()
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnRoomEntryTFrosty)

---@param slot EntitySlot
local function onSecretUnlock(_, slot)
	local sprite = slot:GetSprite()
	if sprite:IsFinished("PayPrize") then
		if sprite:GetLayer(0):GetSpritesheetPath() == "gfx/characters/costumes/character_frosty.png" then
			pgd:TryUnlock(mod.RepmAchivements.FROSTY.ID)
			pgd:TryUnlock(mod.RepmAchivements.FROZEN_HEARTS.ID)
		end
		if sprite:GetLayer(0):GetSpritesheetPath() == "gfx/characters/costumes/character_frosty_b.png" then
			pgd:TryUnlock(mod.RepmAchivements.FROSTY_B.ID)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, onSecretUnlock, SlotVariant.HOME_CLOSET_PLAYER)