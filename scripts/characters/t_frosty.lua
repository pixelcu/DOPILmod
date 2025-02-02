local mod = RepMMod
local sfx = SFXManager()

local function TFrostTimer(_, player)
	local pdata = mod:repmGetPData(player)

	if pdata.TFrosty_FreezeTimer and pdata.TFrosty_FreezeTimer > 0 then
		pdata.TFrosty_FreezeTimer = math.min(3000, pdata.TFrosty_FreezeTimer - 1)
	elseif pdata.TFrosty_FreezeTimer and pdata.TFrosty_FreezeTimer == 0 then
		pdata.TFrosty_FreezeTimer = nil
		player:ChangePlayerType(mod.RepmTypes.CHARACTER_FROSTY_C)
		sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 1, 0)
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

function mod:checkTFrostyConditions(player)
	local fires = Isaac.FindByType(EntityType.ENTITY_FIREPLACE, 2, 0)
	if player:GetPlayerType() ~= mod.RepmTypes.CHARACTER_FROSTY_B then
		return 0
	elseif #fires > 0 then
		return -1
	else
		return 1
	end
end

local function onFrostyInit(_, player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
		player:AddSoulHearts(-1)
		CustomHealthAPI.Library.AddHealth(player, "HEART_ICE", 8, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, onFrostyInit)

local speedDownPerDebuff = 0.10
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and cacheFlag == CacheFlag.CACHE_SPEED then
        local pdata = mod:repmGetPData(player)
        local speedDebuff = (pdata.FrostDamageDebuff or 0)
        if Game():IsGreedMode() then
            speedDebuff = speedDebuff / 2
        end
        player.MoveSpeed = player.MoveSpeed - (speedDebuff * speedDownPerDebuff)
    end

	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C then
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_ICE | TearFlags.TEAR_SPECTRAL
		end
		if cacheFlag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		end
	end
end)

local function onTaintedFrostyStart(_, player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
		mod:repmGetPData(player).TFrosty_FreezeTimer = 3000
		--player:SetPocketActiveItem(mod.RepmTypes.COLLECTIBLE_BATTERED_LIGHTER, ActiveSlot.SLOT_POCKET, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, onTaintedFrostyStart)

local function FrostyStatusUpdate(_, player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
		local data = mod:GetData(player)
		--if not game:IsPaused() then
		if not data.RepM_Frosty_Sprite then
			data.RepM_Frosty_Sprite = Sprite("gfx/chill_status.anm2", true)
			data.RepM_Frosty_Sprite:Play("Idle")
		end
		local TFValue = RepMMod:repmGetPData(player:ToPlayer()).TFrosty_FreezeTimer
		if TFValue == nil then
			data.RepM_Frosty_Sprite.Color = Color(1, 1, 1, 0)
		elseif TFValue <= 500 then
			data.RepM_Frosty_Sprite.Color = Color(1, TFValue / 500, TFValue / 500, 1)
		elseif TFValue >= 2000 then
			data.RepM_Frosty_Sprite.Color = Color(1, 1, 1, 0)
		else
			data.RepM_Frosty_Sprite.Color =	Color(1, 1, 1, math.min(1, 1 / 1500 * (1500 - (TFValue - 500))))
		end
		data.RepM_Frosty_Sprite:Update()
		--end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FrostyStatusUpdate, PlayerVariant.PLAYER)

local function FrostyStatusRender(_, player)
	if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
		return
	end
	local data = mod:GetData(player)
	local position = Isaac.WorldToScreen(player.Position + Vector(0, -50))
	if data.RepM_Frosty_Sprite then
		data.RepM_Frosty_Sprite:Render(position)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, FrostyStatusRender, PlayerVariant.PLAYER)


local function IsDoorNearBy(position)
	local room = Game():GetRoom()
	for _, slot in ipairs(DoorSlot) do
		local door = room:GetDoor(slot)
		if door and (door.Position - position):Length() < 40 then
			return true
		end
		if StageAPI then
			for _, door in ipairs(StageAPI.GetCustomDoorAtSlot(slot)) do
				if door and (door.Position - position):Length() < 40 then
					return true
				end
			end
		end
	end
	return false
end

local function onEnterRoomTFrost()
	local room = Game():GetRoom()
	room:UpdateColorModifier(true, false, 1)
	mod:AnyPlayerDo(function(player)
		
		local pdata = mod:repmGetPData(player)
			
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
			if pdata.TFrosty_FreezeTimer == nil
			then
				pdata.TFrosty_FreezeTimer = 3000
			end
			if not room:IsClear() then
				pdata.TFrosty_Lit = false
				local destPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(10))
				while IsDoorNearBy(destPos) do
					destPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(10))
				end
				local fire = Isaac.Spawn(33, 1, 0, destPos, Vector(0, 0), nil)
				fire:Die()
				SFXManager():Stop(SoundEffect.SOUND_FIREDEATH_HISS)
				mod:SetRoomFreeze(true)
				SFXManager():Play(mod.RepmTypes.SFX_WIND)
			end
		end
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C
			and not player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
		then
			player:GetEffects():AddNullEffect(NullItemID.ID_LOST_CURSE, false, 1)
		end
	end)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onEnterRoomTFrost)

local function tFrostyClearRoom(_, rng, spawnPos)
	mod:AnyPlayerDo(function(player)
		---@cast player EntityPlayer
		local pdata = mod:repmGetPData(player)
		if pdata.TFrosty_Lit == false and player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
			pdata.TFrosty_Unlit_Count = math.min((pdata.TFrosty_Unlit_Count or 0) + 1, 5)
			if pdata.TFrosty_Unlit_Count == 4 then
				pdata.TFrosty_Unlit_Count = 5
				pdata.TFrosty_StartPoint = Game():GetFrameCount()
				pdata.TFrosty_FreezePoint = Game():GetFrameCount() + 7200
				player:AnimateSad()
				player:SetPocketActiveItem(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER, ActiveSlot.SLOT_POCKET, false)
				player:DischargeActiveItem(ActiveSlot.SLOT_POCKET)
			end
		end
		for i = 0, 2 do
			if player:GetActiveItem(i) == mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER then
				if rng:RandomInt(100) < 15 then
					player:AddActiveCharge(1, i, true, false, false)
					--[[player:SetActiveCharge(
						math.min(12, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 1),
						ActiveSlot.SLOT_POCKET
					)]]
					sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
				end
			end
		end
	end)
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, tFrostyClearRoom)

local function tfrosty_OnNewLevel()
	mod:AnyPlayerDo(function(player)
		if player and player:HasCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER) then
			local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_HOLY_LIGHTER)
			player:SetActiveCharge(
				math.min(12, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 4 + rng:RandomInt(3)),
				ActiveSlot.SLOT_POCKET
			)
			sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
		end
	end)
end
--mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, tfrosty_OnNewLevel)

local function OnTearLaunchTFrosty(_, tear)
	local player = mod:GetPlayerFromTear(tear)
	if player then
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and tear.Variant == 0 then
			tear:ChangeVariant(1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, OnTearLaunchTFrosty)