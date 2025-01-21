local mod = RepMMod

local function onBookOfTales(_, col, rng, player) -- сбив сделки при получении урона
	local room = Game():GetRoom()

	for i = 1, 8 do
		local door = room:GetDoor(i)
		if door and (door.TargetRoomType == RoomType.ROOM_DEVIL or door.TargetRoomType == RoomType.ROOM_ANGEL) then
			room:RemoveDoor(i)
		end
	end

	Game():GetLevel():SetRedHeartDamage()
	room:SetRedHeartDamage()
	local gridIndex = room:GetGridIndex(player.Position)
	room:SpawnGridEntity(gridIndex, GridEntityType.GRID_STAIRS, 0, 0, 0)
	SFXManager():Play(8)
	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, onBookOfTales, mod.RepmTypes.COLLECTIBLE_BOOK_OF_TALES)

local function onRoom() -- спавн ретро-сокровещницы
	if PlayerManager.AnyoneHasCollectible(mod.RepmTypes.COLLECTIBLE_BOOK_OF_TALES) then
		local room = game:GetRoom()
		if room:GetType() == RoomType.ROOM_DUNGEON then
			for i = 1, room:GetGridSize() do
				local gridEntity = room:GetGridEntity(i)
				if
					gridEntity
					and gridEntity.Desc.Type == GridEntityType.GRID_WALL
					and (i == 58 or i == 59 or i == 73 or i == 74)
				then
					gridEntity:SetType(GridEntityType.GRID_GRAVITY)
				end
			end
			if room:IsFirstVisit() then
				local level = game:GetLevel()
				level:ChangeRoom(level:GetCurrentRoomIndex())
			end
		elseif room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_ANGEL then
			mod:AnyPlayerDo(function(player)
                ---@cast player EntityPlayer
                for i = 0, 2 do
                    if player:GetActiveItem(i) == mod.RepmTypes.COLLECTIBLE_BOOK_OF_TALES then
				        player:DischargeActiveItem(i)
                    end
                end
			end)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onRoom)