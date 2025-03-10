local mod = RepMMod
local pgd = Isaac.GetPersistentGameData()
local game = Game()

local function OnBossDefeat_Frosty(_, rng, spawn)
	if
		not pgd:Unlocked(mod.RepmAchivements.FROSTY.ID)
		and pgd:Unlocked(Achievement.STRANGE_DOOR)
		and game:GetRoom():GetType() == RoomType.ROOM_BOSS
		and game:GetLevel():GetStage() == 1
		and game:GetLevel():GetStageType() <= StageType.STAGETYPE_AFTERBIRTH
		and mod.saveTable.repm_picSpawned ~= true
	then
		local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos())
		Isaac.Spawn(5, 350, mod.RepmTypes.TRINKET_FROZEN_POLAROID, spawnPos, Vector.Zero, nil)
		mod.saveTable.repm_picSpawned = true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, OnBossDefeat_Frosty)



local function onFrostyInit(_, player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY then
		player:AddSoulHearts(-1)
		CustomHealthAPI.Library.AddHealth(player, "HEART_ICE", 6, true)
		if not pgd:Unlocked(mod.RepmAchivements.DEATH_CARD.ID) then
			player:RemovePocketItem(PillCardSlot.PRIMARY)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, onFrostyInit)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod:AnyPlayerDo(function(player)
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
			or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
		then
			local pdata = mod:repmGetPData(player)
			pdata.FrostDamageDebuff = 0
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
			if
				player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
				and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
				and not game:GetRoom():IsClear()
			then
				local position = game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetRandomPosition(3))
				local rift = Isaac.Spawn(1000, mod.RepmTypes.EFFECT_FROSTY_RIFT, 1, position, Vector.Zero, nil)
				rift.SortingLayer = SortingLayer.SORTING_BACKGROUND
				rift:GetSprite():Play("Appear")
			end
		end
	end)
end)

local frameBetweenDebuffs = 150 -- 30 frames per second
local damageDownPerDebuff = 0.40
local lastFrame = 0
local minFrameFreeze = 30 -- 1 second
local maxFrameFreeze = 900 -- 30 seconds

local blueColor = Color(0.67, 1, 1, 1, 0, 0, 0)
blueColor:SetColorize(1, 1, 3, 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local pdata = mod:repmGetPData(player)
	if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY or mod:checkTFrostyConditions(player) == 1 then
		local frame = game:GetFrameCount()
		if frame % 30 == 0 and frame ~= lastFrame then
			lastFrame = frame
			local room = game:GetRoom()
			if frame % frameBetweenDebuffs == 0 and not game:IsGreedMode() then
				if
					not room:IsClear()
					and game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
					and game:GetRoom():GetType() ~= RoomType.ROOM_MINIBOSS
				then
					pdata.FrostDamageDebuff = (pdata.FrostDamageDebuff or 0) + 1
				elseif room:IsClear() then
					pdata.FrostDamageDebuff = 0
				end
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
	if game:IsGreedMode() and mod.saveTable.REPM_GreedWave ~= game:GetLevel().GreedModeWave then
		mod:AnyPlayerDo(function(player)
			if
				player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
				or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
			then
				local pdata = mod:repmGetPData(player)
				pdata.FrostDamageDebuff = (pdata.FrostDamageDebuff or 0) + 1
			end
		end)
		mod.saveTable.REPM_GreedWave = game:GetLevel().GreedModeWave
	end

	local hasIt = PlayerManager.AnyoneIsPlayerType(mod.RepmTypes.CHARACTER_FROSTY)

	mod:AnyPlayerDo(function(player)
		local pdata = mod:repmGetPData(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and pdata.TFrosty_Unlit_Count == 5 then
			hasIt = true
			local framesToFreeze = pdata.TFrosty_FreezePoint - pdata.TFrosty_StartPoint
			local progress = game:GetFrameCount() - pdata.TFrosty_StartPoint
			local progressAmt = progress / framesToFreeze
			local color = Color.Lerp(Color.Default, blueColor, progressAmt)
			player:GetSprite().Color = color
		end
	end)

	if hasIt and game:GetRoom():GetAliveEnemiesCount() >= 1 then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			local entity = entities[i]
			if
				entity:IsVulnerableEnemy()
				and entity:IsActiveEnemy()
				and not entity:IsBoss()
				and (entity:GetEntityFlags() & EntityFlag.FLAG_CHARM ~= EntityFlag.FLAG_CHARM)
				and (entity:GetEntityFlags() & EntityFlag.FLAG_FRIENDLY ~= EntityFlag.FLAG_FRIENDLY)
			then
				local data = mod:GetData(entity)
				if not data.RepM_Frosty_FreezePoint then
					local num = mod.RNG:RandomInt(minFrameFreeze, maxFrameFreeze)
					data.RepM_Frosty_FreezePoint = game:GetFrameCount() + num
					data.RepM_Frosty_StartPoint = game:GetFrameCount()
				end
				local freezepoint = data.RepM_Frosty_FreezePoint
				local startingFrame = data.RepM_Frosty_StartPoint
				if game:GetFrameCount() >= freezepoint then
					entity:AddEntityFlags(EntityFlag.FLAG_ICE)
					entity:TakeDamage(9999, 0, EntityRef(player), 1)
				else
					local framesToFreeze = freezepoint - startingFrame --how long the enemy survives before freezing
					local progress = game:GetFrameCount() - startingFrame
					local progressAmt = progress / framesToFreeze
					local color = Color.Lerp(Color.Default, blueColor, progressAmt)
					entity:AddSlowing(EntityRef(player), 20, 0.8, color)
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheflag)
	local pdata = mod:repmGetPData(player)

	local damageDebuff = (pdata.FrostDamageDebuff or 0)
	if game:IsGreedMode() then
		damageDebuff = damageDebuff / 2
	end
	player.Damage = player.Damage - (damageDebuff * damageDownPerDebuff)
end, CacheFlag.CACHE_DAMAGE)

local function RenderNPCChillStatus(_, npc)
	if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
		return
	end
	local data = mod:GetData(npc)
	if data.RepM_Frosty_FreezePoint ~= nil and data.RepM_Frosty_Sprite then
		local position = Isaac.WorldToScreen(npc.Position + npc:GetNullOffset("OverlayEffect"))
		data.RepM_Frosty_Sprite:Render(position)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, RenderNPCChillStatus)

local function NpcFrostStatusUpdate(_, npc)
	local data = mod:GetData(npc)
	if not data.RepM_Frosty_Sprite and npc:IsVulnerableEnemy() then
		data.RepM_Frosty_Sprite = Sprite("gfx/chill_status.anm2", true)
		data.RepM_Frosty_Sprite:Play("Idle")
	end
	if data.RepM_Frosty_Sprite and data.RepM_Frosty_FreezePoint ~= nil then
		data.RepM_Frosty_Sprite:Update()
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, NpcFrostStatusUpdate)

--function mod:

local function FrostyRiftEffectRender(_, effect, renderoffset)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	elseif sprite:IsFinished("Disappear") then
		effect:Remove()
	else
		if game:GetFrameCount() % 5 == 0 then
			effect:Update()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, FrostyRiftEffectRender, mod.RepmTypes.EFFECT_FROSTY_RIFT)

local function OnRiftCollide(_, effect)
	local entities = Isaac.FindInRadius(effect.Position, effect.Size / 2)
	for i, collider in ipairs(entities) do
		if
			collider.Type == EntityType.ENTITY_PLAYER
			and collider:ToPlayer()
			and collider:ToPlayer():GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY
			and not effect:GetData().Repm_Rift_Delete
		then
			effect:GetSprite():Play("Disappear")
			local poof =
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector(0, 0), nil)
			poof.Color = blueColor
			mod:SetRoomFreeze(true)
			SFXManager():Play(mod.RepmTypes.SFX_WIND)
			local entities = Isaac.GetRoomEntities()
			for i, entity in ipairs(entities) do
				if
					entity:IsVulnerableEnemy()
					and not entity:IsBoss()
					and (entity:GetEntityFlags() & EntityFlag.FLAG_CHARM ~= EntityFlag.FLAG_CHARM)
					and (entity:GetEntityFlags() & EntityFlag.FLAG_FRIENDLY ~= EntityFlag.FLAG_FRIENDLY)
				then
					local data = mod:GetData(entity)
					local freezepoint = data.RepM_Frosty_FreezePoint
					local startingFrame = data.RepM_Frosty_StartPoint
					if freezepoint and game:GetFrameCount() + 60 >= freezepoint then
						data.RepM_Frosty_FreezePoint = game:GetFrameCount() + 1
					elseif freezepoint and freezepoint > game:GetFrameCount() then
						data.RepM_Frosty_FreezePoint =
							math.floor((data.RepM_Frosty_FreezePoint + game:GetFrameCount()) / 2)
					end
				end
			end
			effect:GetData().Repm_Rift_Delete = true
			break
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, OnRiftCollide, mod.RepmTypes.EFFECT_FROSTY_RIFT)
