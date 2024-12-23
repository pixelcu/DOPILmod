local chestmod = RepMMod
EEE_CHEST = Isaac.GetEntityVariantByName("EEE Chest")
PersistentGameData = Isaac.GetPersistentGameData()
local game = Game()
local sfx = SFXManager()

RepMMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(a)
	local playerCount = game:GetNumPlayers()
	for playerIndex = 0, playerCount - 1 do
		local player = Isaac.GetPlayer(playerIndex)
		if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Frosty", false) and PersistentGameData:Unlocked(Isaac.GetAchievementIdByName("Frosty")) == false then
			player:ChangePlayerType(0)
		elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("Tainted Frosty", true) and PersistentGameData:Unlocked(Isaac.GetAchievementIdByName("Frosty_B")) == false then
			player:ChangePlayerType(Isaac.GetPlayerTypeByName("Frosty", false))
		elseif player:GetPlayerType() == Isaac.GetPlayerTypeByName("TSim", true) then
			player:ChangePlayerType(Isaac.GetPlayerTypeByName("Sim", false))
		end
	end
end)

local function optionsCheck(pickup)
	if pickup.OptionsPickupIndex and pickup.OptionsPickupIndex > 0 then
		for _, entity in pairs(Isaac.FindByType(5, -1, -1)) do
			if
				entity:ToPickup().OptionsPickupIndex
				and entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex
				and GetPtrHash(entity:ToPickup()) ~= GetPtrHash(pickup)
			then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
				entity:Remove()
			end
		end
	end
end
function chestmod.openEEEChest(pickup, player)
	optionsCheck(pickup)
	pickup.SubType = 1
	pickup:GetData()["IsInRoom"] = true
	pickup:GetSprite():Play("Open")
	SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN, 1, 2, false, 1, 0)
	if math.random(10) <= 1 then
		local pedestal =
			Isaac.Spawn(5, 100, Game():GetItemPool():GetCollectible(24), pickup.Position, Vector.Zero, pickup)
		pedestal:GetSprite():ReplaceSpritesheet(5, "gfx/items/pick ups/EEE_pedestal.png")
		pedestal:GetSprite():LoadGraphics()
		pickup:Remove()
	else
		local rolls = 1
		for i = 1, 2 do
			if math.random(3) > rolls then
				rolls = rolls + 1
			end
		end
		if player:HasTrinket(42) then
			rolls = rolls + 1
		end
		local mod = 1
		if player:HasCollectible(199) then
			mod = mod + 1
		end
		local overpaid = 0
		for i = 1, rolls do
			local payout = math.random(5)
			if payout <= 1 then
				for i = 1, mod do
					Isaac.Spawn(5, 10, 1, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				end
			elseif payout <= 2 then
				for i = 1, mod do
					Isaac.Spawn(5, 10, 2, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				end
			elseif payout <= 3 then
				for i = 1, mod do
					Isaac.Spawn(5, 10, 5, pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				end
			elseif payout <= 4 then
				Isaac.Spawn(5, 300, math.random(56, 77), pickup.Position, Vector.FromAngle(math.random(360)) * 3, nil)
				overpaid = overpaid + 1
			elseif payout <= 5 then
				Isaac.Spawn(
					5,
					300,
					Isaac.GetCardIdByName("MinusShard"),
					pickup.Position,
					Vector.FromAngle(math.random(360)) * 3,
					nil
				)
				overpaid = overpaid + 1
				if i + overpaid >= rolls then
					break
				end
			end
		end
	end
end
function chestmod:chestCollision(pickup, collider, _)
	if not collider:ToPlayer() then
		return
	end
	local player = collider:ToPlayer()
	local sprite = pickup:GetSprite()
	if pickup.Variant == EEE_CHEST and pickup.SubType == 0 then
		if sprite:IsPlaying("Appear") then
			return false
		end
		if pickup.Variant == EEE_CHEST then
			chestmod.openEEEChest(pickup, player)
		end
	end
end
chestmod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, chestmod.chestCollision)
function chestmod:chestInit(pickup)
	if pickup.Variant == EEE_CHEST and pickup.SubType == 1 and not pickup:GetData()["IsInRoom"] then
		pickup:Remove()
	end
end
chestmod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, chestmod.chestInit)
function chestmod:chestUpdate(pickup)
	if Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("SimDelirium")) then
		if
			(pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast"))
			and pickup:GetSprite():GetFrame() == 1
			and Game():GetRoom():GetType() ~= 11
			and Game():GetLevel():GetStage() ~= 11
			and not pickup:GetData().nomorph
		then
			if pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and math.random(100) <= 1 then
				pickup:Morph(5, EEE_CHEST, 0, true, true, false)
				SFXManager():Play(21, 1, 2, false, 1, 0)
			elseif pickup.Variant == PickupVariant.PICKUP_REDCHEST and math.random(100) <= 25 then
				pickup:Morph(5, EEE_CHEST, 0, true, true, false)
				SFXManager():Play(21, 1, 2, false, 1, 0)
			end
		end
	end
end
chestmod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, chestmod.chestUpdate)

local SimMarks = {
	[CompletionType.MOMS_HEART] = nil,
	[CompletionType.ISAAC] = nil,
	[CompletionType.SATAN] = nil,
	[CompletionType.BOSS_RUSH] = nil,
	[CompletionType.BLUE_BABY] = nil,
	[CompletionType.LAMB] = Isaac.GetAchievementIdByName("RubyChest"),
	[CompletionType.MEGA_SATAN] = nil,
	[CompletionType.ULTRA_GREED] = nil,
	[CompletionType.ULTRA_GREEDIER] = nil,
	[CompletionType.DELIRIUM] = Isaac.GetAchievementIdByName("SimDelirium"),
	[CompletionType.MOTHER] = nil,
	[CompletionType.BEAST] = nil,
	[CompletionType.HUSH] = nil,
}

RepMMod:AddCallback(ModCallbacks.MC_PRE_COMPLETION_EVENT, function(_, mark)
	local playerCount = game:GetNumPlayers()

	for playerIndex = 0, playerCount - 1 do
		local player = Isaac.GetPlayer(playerIndex)
		if player:GetPlayerType() == Isaac.GetPlayerTypeByName("Sim", false) and not player.Parent then
			if SimMarks[mark] then
				PersistentGameData:TryUnlock(SimMarks[mark])
			end
		end
	end
end)

RepMMod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player, flags)
	local CRI = game:GetLevel():GetCurrentRoomIndex()
	local Dirt = player:GetMovementDirection()
	local NewDirt
	if Dirt == 0 then
		NewDirt = CRI - 2
		if game:GetLevel():GetRoomByIdx(NewDirt, -1).Data == nil then
			NewDirt = CRI - 1
		end
	elseif Dirt == 1 then
		NewDirt = CRI - 26
		if game:GetLevel():GetRoomByIdx(NewDirt, -1).Data == nil then
			NewDirt = CRI - 13
		end
	elseif Dirt == 2 then
		NewDirt = CRI + 2
		if game:GetLevel():GetRoomByIdx(NewDirt, -1).Data == nil then
			NewDirt = CRI + 1
		end
	elseif Dirt == 3 then
		NewDirt = CRI + 26
		if game:GetLevel():GetRoomByIdx(NewDirt, -1).Data == nil then
			NewDirt = CRI + 13
		end
	end
	if Dirt == -1 then
		player:AddCard(Isaac.GetCardIdByName("HammerCard"))
	else
		print(Dirt)
		if game:GetLevel():GetRoomByIdx(NewDirt, -1).Data ~= nil then
			game:StartRoomTransition(NewDirt, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, player, -1)
			if player:HasCollectible(451) then
				if math.random(1, 10) <= 2 then
					player:AddCard(Isaac.GetCardIdByName("HammerCard"))
				end
			else
				if math.random(1, 10) == 1 then
					player:AddCard(Isaac.GetCardIdByName("HammerCard"))
				end
			end
		else
			player:AddCard(Isaac.GetCardIdByName("HammerCard"))
		end
	end
end, Isaac.GetCardIdByName("HammerCard"))

local Immune = false
RepMMod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, _, player, flags)
	Immune = true
	if player:HasFullHearts() then
		Isaac.Spawn(5, 10, 1, player.Position, Vector.FromAngle(math.random(360)) * 3, nil)
		Isaac.Spawn(5, 10, 1, player.Position, Vector.FromAngle(math.random(360)) * 3, nil)
		Isaac.Spawn(5, 10, 1, player.Position, Vector.FromAngle(math.random(360)) * 3, nil)
	end
	Isaac.CreateTimer(function()
		Immune = false
	end, 600, 1, true)
	player:AddHearts(3)
	player:AnimateHappy()
end, Isaac.GetPillEffectByName("Groovy"))
RepMMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, amount, DamageFlag)
	player = player:ToPlayer()
	if Immune == true then
		return false
	end
	if
		player:GetHearts()
				+ player:ToPlayer():GetBlackHearts()
				+ player:GetBoneHearts()
				+ player:GetSoulHearts()
				+ player:GetRottenHearts()
			<= amount
		and player:HasCollectible(Isaac.GetItemIdByName("Strong Spirit"), true)
	then
	local Data = RepMMod:repmGetPData(player)
	if
		Data == nil
		or (Data ~= nil and Data.StrongSpiritSS == nil)
		or (Data ~= nil and Data.StrongSpiritSS ~= nil and Data.StrongSpiritSS.Damage == true)
	then
		return
	end
	Data.StrongSpiritSS.Damage = true
	Data.StrongSpiritSS.Sprite:Play("Damaged", true)
		game:ShakeScreen(50)
		player:UseActiveItem(58, false, false, true, false, -1, 0)
		game:GetPlayer(0):AddHearts(4)
		game:GetPlayer(0):AddSoulHearts(2)
		player:GetData().RepSSDamageBoost = 600
		print(player:GetData().RepSSDamageBoost)
		return false
	end
end, EntityType.ENTITY_PLAYER)

RepMMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function()
	for i = 1, game:GetNumPlayers() do
		local Player = Isaac.GetPlayer(i - 1)
		local Data = RepMMod:repmGetPData(Player)
		if Data ~= nil and (Data ~= nil and Data.StrongSpiritSS ~= nil) and Data.StrongSpiritSS.Sprite ~= nil then
			Data.StrongSpiritSS.Sprite:Render(Isaac.WorldToScreen(Player.Position))
			Data.StrongSpiritSS.Sprite:Update()
			if Data.StrongSpiritSS.Sprite:IsFinished("Fade") then
				Data.StrongSpiritSS.Sprite = nil
			end
			if Data.StrongSpiritSS.Sprite ~= nil then
				if Data.StrongSpiritSS.Sprite:IsFinished("Damaged") then
					Data.StrongSpiritSS.Sprite:Play("Idle", true)
				end
				if not Data.StrongSpiritSS.Sprite:IsPlaying("Fade") and Data.StrongSpiritSS.Damage == true then
					Data.StrongSpiritSS.Sprite:Play("Fade", true)
				end
			end
		end
	end
end)
RepMMod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_,_, _, _, _, _, Player)
	local Data = RepMMod:repmGetPData(Player)
	if Data.StrongSpiritSS == nil then
		Data.StrongSpiritSS = {
			Damage = false,
			Sprite = Sprite(),
		}
	end
	Data.StrongSpiritSS.Sprite = Sprite()
	Data.StrongSpiritSS.Sprite:Load("gfx/SSStatus.anm2", true)
	Data.StrongSpiritSS.Sprite:Play("Idle", true)
end, Isaac.GetItemIdByName("Strong Spirit"))


RepMMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	Immune = false
end)
RepMMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for i = 1, game:GetNumPlayers() do
		local Player = Isaac.GetPlayer(i - 1)
		local Data = RepMMod:repmGetPData(Player)
		if Data ~= nil and Data.StrongSpiritSS ~= nil and Data.StrongSpiritSS.Damage == true and Player:HasCollectible(Isaac.GetItemIdByName("Strong Spirit"), true) then
		Data.StrongSpiritSS.Damage = false
		Data.StrongSpiritSS.Sprite = Sprite()
		Data.StrongSpiritSS.Sprite:Load("gfx/SSStatus.anm2", true)
		Data.StrongSpiritSS.Sprite:Play("Idle", true)
	end
	end
end)

function RepMMod:PortalUse(item, RNG, EntityPlayer, Flags, ActiveSlot)
	if RepMMod.saveTable.PortalD6Use == nil or RepMMod.saveTable.PortalD6Use == false then
		RepMMod.saveTable.PortalD6Use = true
		RepMMod.saveTable.PortalD6 = {}
		local roomsList = Game():GetLevel():GetRooms()
		local roomEntities = Isaac.GetRoomEntities()
		for _, entity in ipairs(roomEntities) do
			if entity.Type == 5 then
				print(entity.Variant .. "/" .. entity.SubType)
				if entity.Variant == 100 then
					if entity.SubType == 0 then
					else
						table.insert(
							RepMMod.saveTable.PortalD6,
							{
								Variant = entity.Variant,
								SubType = entity.SubType,
								Position = entity.Position,
								price = entity:ToPickup().Price,
								roomType = roomsList:Get(math.random(0, roomsList.Size - 1)).Data.Type,
							}
						)
						Isaac.Spawn(1000, 15, 0, entity.Position, Vector.Zero, entity)
						entity:Remove()
					end
				elseif
					entity.Variant == 50
					or entity.Variant == 52
					or entity.Variant == 51
					or entity.Variant == 53
					or entity.Variant == 54
					or entity.Variant == 55
					or entity.Variant == 56
					or entity.Variant == 57
					or entity.Variant == 58
					or entity.Variant == 60
					or entity.Variant == 390
					or entity.Variant == 360
				then
					if entity.SubType == 0 then
					else
						table.insert(
							RepMMod.saveTable.PortalD6,
							{
								Variant = entity.Variant,
								SubType = entity.SubType,
								Position = entity.Position,
								price = entity:ToPickup().Price,
								roomType = roomsList:Get(math.random(0, roomsList.Size - 1)).Data.Type,
							}
						)
						Isaac.Spawn(1000, 15, 0, entity.Position, Vector.Zero, entity)
						entity:Remove()
					end
				elseif
					entity.Variant == 370
					or entity.Variant == 380
					or entity.Variant == 340
					or entity.Variant == 150
					or entity.Variant == 110
					or entity.Variant == 41
				then
				else
					table.insert(
						RepMMod.saveTable.PortalD6,
						{
							Variant = entity.Variant,
							SubType = entity.SubType,
							Position = entity.Position,
							price = entity:ToPickup().Price,
						}
					)
					Isaac.Spawn(1000, 15, 0, entity.Position, Vector.Zero, entity)
					entity:Remove()
				end
			end
		end
		Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Portal D6")).MaxCharges = 3
		return true
	else
		RepMMod.saveTable.PortalD6Use = false
		if RepMMod.saveTable.PortalD6 == {} or RepMMod.saveTable.PortalD6 == nil then
			Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Portal D6")).MaxCharges = 6
			return true
		end
		for _, table in ipairs(RepMMod.saveTable.PortalD6) do
			local item
			if table.Variant == 100 then
				local newid
				if EntityPlayer:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) or table.roomType == 3 then
					newid = Game():GetItemPool():GetCollectible(math.random(1, 30), true, Random(), 25)
				elseif table.roomType == 2 then
					newid = Game():GetItemPool():GetCollectible(1, true, Random(), 25)
				elseif table.roomType == 24 then
					newid = Game():GetItemPool():GetCollectible(26, true, Random(), 25)
				elseif table.roomType == 5 then
					newid = Game():GetItemPool():GetCollectible(2, true, Random(), 25)
				elseif table.roomType == 7 or table.roomType == 8 then
					newid = Game():GetItemPool():GetCollectible(5, true, Random(), 25)
				elseif table.roomType == 9 then
					newid = Game():GetItemPool():GetCollectible(10, true, Random(), 25)
				elseif table.roomType == 10 then
					newid = Game():GetItemPool():GetCollectible(12, true, Random(), 25)
				elseif table.roomType == 12 then
					newid = Game():GetItemPool():GetCollectible(6, true, Random(), 25)
				elseif table.roomType == 14 then
					newid = Game():GetItemPool():GetCollectible(3, true, Random(), 25)
				elseif table.roomType == 15 then
					newid = Game():GetItemPool():GetCollectible(4, true, Random(), 25)
				elseif table.roomType == 29 then
					newid = Game():GetItemPool():GetCollectible(24, true, Random(), 25)
				else
					newid = Game():GetItemPool():GetCollectible(0, true, Random(), 25)
				end
				item = Isaac.Spawn(
					5,
					table.Variant,
					newid,
					table.Position or game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
					Vector(
						math.cos(2.0 * math.pi * math.random(1, 24) / math.random(1, 24)),
						math.sin(2.0 * math.pi * math.random(1, 24) / math.random(1, 24))
					),
					nil
				)
			else
				item = Isaac.Spawn(
					5,
					table.Variant,
					table.SubType,
					table.Position or game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
					Vector(
						math.cos(2.0 * math.pi * math.random(1, 24) / math.random(1, 24)),
						math.sin(2.0 * math.pi * math.random(1, 24) / math.random(1, 24))
					),
					nil
				)
			end
			Isaac.Spawn(
				1000,
				15,
				0,
				table.Position or game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
				Vector.Zero,
				EntityPlayer
			)
			item:ToPickup().Price = table.price
		end
		EntityPlayer:UseActiveItem(166, false, false, true, false, -1, 0)
		Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Portal D6")).MaxCharges = 10
		return true
	end
end
RepMMod:AddCallback(ModCallbacks.MC_USE_ITEM, RepMMod.PortalUse, Isaac.GetItemIdByName("Portal D6"))

-----------------------------------------------------------
--TAINTED FROSTY
-----------------------------------------------------------

function RepMMod:TFrostTimer()
	RepMMod:AnyPlayerDo(function(player)
		if player:GetData().RepSSDamageBoost ~= nil and player:GetData().RepSSDamageBoost >= 0 then
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
			player.Damage = player.Damage + (5/600 * player:GetData().RepSSDamageBoost)
			player:GetData().RepSSDamageBoost = player:GetData().RepSSDamageBoost - 1
			if player:GetData().RepSSDamageBoost == 0 then
				player:AddCacheFlags(CacheFlag.CACHE_ALL)
        		player:EvaluateItems()
				player:GetData().RepSSDamageBoost = nil
			end
		end
		local pdata = RepMMod:repmGetPData(player)
		if pdata.TFrosty_FreezeTimer and pdata.TFrosty_FreezeTimer > 0 then
			pdata.TFrosty_FreezeTimer = math.min(3000,pdata.TFrosty_FreezeTimer - 1)
		elseif pdata.TFrosty_FreezeTimer and pdata.TFrosty_FreezeTimer == 0 then
			pdata.TFrosty_FreezeTimer = nil
			player:ChangePlayerType(Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false))
			sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 1, 0)
			player:AnimateSad()
			player:SetPocketActiveItem(RepMMod.RepmTypes.Collectible_HOLY_LIGHTER, ActiveSlot.SLOT_POCKET, false)
			player:DischargeActiveItem(ActiveSlot.SLOT_POCKET)
			player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
			player.CanFly = true
			player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
		end
	end)
end

RepMMod:AddCallback(ModCallbacks.MC_POST_UPDATE, RepMMod.TFrostTimer)

function RepMMod:updateTGFrosty(player, cacheFlag)
	if player:GetPlayerType() == (Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false)) then
		player.CanFly = true
	end
	if cacheFlag == CacheFlag.CACHE_TEARFLAG then
		if player:GetPlayerType() == (Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false)) then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
		end
	end
end
RepMMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, RepMMod.updateTGFrosty)
RepMMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, flag)
	if
		ent:ToPlayer()
		and ent:ToPlayer():GetPlayerType() == (Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false))
		and flag & DamageFlag.DAMAGE_NO_PENALTIES == 0
	then
		ent:Kill()
	end
end, 1)

function RepMMod:WispTGFSpawn(entity)
	local ded = false
	local playerWispMain = Isaac.GetPlayer(0)
	RepMMod:AnyPlayerDo(function(player)
		if player:GetPlayerType() == (Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false)) then
			ded = true
			playerWispMain = player
		end
	end)
	if ded and math.random(1, 5) == 1 then
		playerWispMain:AddWisp(RepMMod.RepmTypes.Collectible_HOLY_LIGHTER, entity.Position, true, false)
	end
end
RepMMod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, RepMMod.WispTGFSpawn)

local FrostyAchId = Isaac.GetAchievementIdByName("Frosty")

Console.RegisterCommand("unlockrepnegative", 'Unlock all content in mode "Repentance Negative"', 'Unlock all content in mode "Repentance Negative"', true, 16)
Console.RegisterCommand("lockrepnegative", 'Lock all content in mode "Repentance Negative"', 'Lock all content in mode "Repentance Negative"', true, 16)


function RepMMod.oncmd(_, command, args)
    if command == "unlockrepnegative" then
        for i=1, 9 do
            Isaac.ExecuteCommand("achievement " .. FrostyAchId + i - 1)
        end
    elseif command == "lockrepnegative" then
        for i=1, 9 do
            Isaac.ExecuteCommand("lockachievement " .. FrostyAchId + i - 1)
        end
    end
end
RepMMod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, RepMMod.oncmd)

if ElitiumMod then
end
