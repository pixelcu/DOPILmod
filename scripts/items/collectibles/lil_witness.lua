local BLUE_FLY_ROOM_CLEAR_AMOUNT = 3
local BLUE_SPIDER_ROOM_CLEAR_AMOUNT = 4
local FRIENDLY_LARVAE_BOSS_KILL_COUNT = 5
local BLUE_SPIDER_THROW_OFFSET_MIN = 30
local BLUE_SPIDER_THROW_OFFSET_MAX = 80
local SPRITE_SCALE = 0.7
local SWIRL_OFFSET = Vector(0, -2)
local FRIENDLY_LARVAE_SPEED = 2
local FRIENDLY_LARVAE_HEIGHT_MIN = -15
local FRIENDLY_LARVAE_HEIGHT_MAX = -10

local lil_witness_variant = Isaac.GetEntityVariantByName("Lil Witness")
local lil_witness_item = Isaac.GetItemIdByName("Lil Witness")
---@enum LilWitnessState
local LilWitnessState = {
	IDLE = 0,
	SPAWN = 1,
}

---@enum LilWitnessRewardType
local LilWitnessRewardType = {
	SPIDER_AND_FLIES = 0,
	MAGGOTS = 1,
}

---@class LilWitnessData
---@field state LilWitnessState
---@field rewards LilWitnessRewardType[]

---@param lil_witness EntityFamiliar
local function get_lil_witness_data(lil_witness)
	---@type LilWitnessData
	local data = lil_witness:GetData().LilWitnessData

	if not data then
		data = {
			state = LilWitnessState.IDLE,
			rewards = {},
		}
		lil_witness:GetData().LilWitnessData = data
	end

	return data
end

---@param lil_witness EntityFamiliar
local function state_idle(lil_witness)
	local sprite = lil_witness:GetSprite()
	sprite:Play("Idle", false)
end

---@param lil_witness EntityFamiliar
local function state_spawn(lil_witness)
	local sprite = lil_witness:GetSprite()
	sprite:Play("Spawn", false)

	local data = get_lil_witness_data(lil_witness)

	if sprite:IsEventTriggered("Spawn") then
		local reward = data.rewards[1]

		if reward == LilWitnessRewardType.SPIDER_AND_FLIES then
			local familiar_multiplier = lil_witness:GetMultiplier()
			local player = lil_witness.Player
			local rng = RNG(Random())

			local flies_to_add = BLUE_FLY_ROOM_CLEAR_AMOUNT * familiar_multiplier - player:GetNumBlueFlies()
			local spiders_to_add = BLUE_SPIDER_ROOM_CLEAR_AMOUNT * familiar_multiplier - player:GetNumBlueSpiders()

			player:AddBlueFlies(flies_to_add, lil_witness.Position, nil)

			for i = 1, spiders_to_add do
				local spawn_offset = rng:RandomInt(BLUE_SPIDER_THROW_OFFSET_MIN, BLUE_SPIDER_THROW_OFFSET_MAX)
					* RandomVector()
				local spawn_position = Isaac.GetFreeNearPosition(lil_witness.Position + spawn_offset, 5)
				player:ThrowBlueSpider(lil_witness.Position, spawn_position)
			end
		elseif reward == LilWitnessRewardType.MAGGOTS then
			local height = RepMMod.RNG:RandomInt(FRIENDLY_LARVAE_HEIGHT_MIN, FRIENDLY_LARVAE_HEIGHT_MAX)

			for i = 1, FRIENDLY_LARVAE_BOSS_KILL_COUNT do
				local velocity = RandomVector() * FRIENDLY_LARVAE_SPEED
				---@diagnostic disable-next-line: undefined-field TODO: Remove this once typedef is fixed
				local maggot = EntityNPC.ThrowMaggot(lil_witness.Position, velocity, height)
				maggot:AddCharmed(EntityRef(lil_witness.Player), -1)
			end
		end

		SFXManager():Play(SoundEffect.SOUND_WHEEZY_COUGH, 1, 0, false, 0.9)

		local swirl = Isaac.Spawn(
			EntityType.ENTITY_EFFECT,
			EffectVariant.BLOOD_EXPLOSION,
			5,
			lil_witness.Position,
			Vector.Zero,
			lil_witness
		):ToEffect()

		if swirl then
			swirl:FollowParent(lil_witness)
			swirl.DepthOffset = lil_witness.DepthOffset + 1
			swirl.Color = Color.ProjectileCorpseGreen
			swirl.SpriteOffset = SWIRL_OFFSET
		end

		table.remove(data.rewards, 1)
	end

	if sprite:IsFinished() then
		if #data.rewards > 0 then
			sprite:Play("Spawn", true)
		else
			data.state = LilWitnessState.IDLE
		end
	end
end

---@param player EntityPlayer
local function evaluate_cache_familiars(_, player)
	local collectible_num = player:GetCollectibleNum(lil_witness_item)
	local rng = player:GetCollectibleRNG(lil_witness_item)
	local item_config = Isaac.GetItemConfig():GetCollectible(lil_witness_item)

	player:CheckFamiliarEx(lil_witness_variant, collectible_num, rng, item_config, 0)
end

---@param lil_witness EntityFamiliar
local function familiar_init_lil_witness(_, lil_witness)
	lil_witness:AddToFollowers()
end

---@param lil_witness EntityFamiliar
local function familiar_update_lil_witness(_, lil_witness)
	lil_witness.SpriteScale = Vector.One * SPRITE_SCALE
	lil_witness:FollowParent()

	local data = get_lil_witness_data(lil_witness)

	if data.state == LilWitnessState.IDLE then
		state_idle(lil_witness)
	elseif data.state == LilWitnessState.SPAWN then
		state_spawn(lil_witness)
	end
end

local function pre_spawn_clean_award()
	for _, v in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, lil_witness_variant, 0)) do
		local familiar = v:ToFamiliar()

		if not familiar then
			break
		end

		local data = get_lil_witness_data(familiar)
		data.state = LilWitnessState.SPAWN
		table.insert(data.rewards, LilWitnessRewardType.SPIDER_AND_FLIES)
	end
end

---@param npc EntityNPC
local function post_npc_death(_, npc)
	if npc:IsBoss() then
		for _, v in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, lil_witness_variant, 0)) do
			local familiar = v:ToFamiliar()

			if not familiar then
				break
			end

			local data = get_lil_witness_data(familiar)
			data.state = LilWitnessState.SPAWN
			table.insert(data.rewards, LilWitnessRewardType.MAGGOTS)
		end
	end
end

RepMMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, evaluate_cache_familiars, CacheFlag.CACHE_FAMILIARS)
RepMMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, post_npc_death)
RepMMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiar_init_lil_witness, lil_witness_variant)
RepMMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiar_update_lil_witness, lil_witness_variant)
RepMMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, familiar_update_lil_witness, lil_witness_variant)
RepMMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, pre_spawn_clean_award)
