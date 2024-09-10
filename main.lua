--[[Итак мамкины программисты, кто решил залесть в код мода, то не удивляйтесь его странному оформлению и как он странно написан. 
    Если кто-то шарит за код, то это мой первый опыт]]
--[[So mom’s programmers, who decided to get into the mod’s code, don’t be surprised at its strange design and how strangely it is written.
    If anyone is looking for code, this is my first experience]]

	local mod = RegisterMod("RepentanceNegative", 1.0)
	RepMMod = mod
	local json = require("json")
	local game = Game()
	local version = ": 1.2a" --added by me (pedro), for making updating version number easier
	
	if not REPENTOGON then
		error("REPENTOGON not installed, please download REPENTOGON!")
		return
	end
	print("Thanks for playing the TBOI REP NEGATIVE [Community Mod] - Currently running version" .. tostring(version))
	mod.saveTable = mod.saveTable or {}
	RepMMod.saveTable.MenuData = RepMMod.saveTable.MenuData or {}
	RepMMod.saveTable.MenuData.StartThumbsUp = RepMMod.saveTable.MenuData.StartThumbsUp or 1
	mod.saveTable.PlayerData = mod.saveTable.PlayerData or {}
	mod.saveTable.MusicData = mod.saveTable.MusicData or {}
	mod.saveTable.MusicData.Music = mod.saveTable.MusicData.Music or {}
	mod.saveTable.MusicData.Jingle = mod.saveTable.MusicData.Jingle or {}
	local globalRng = RNG()
	
	include("lua.music")
	include("lua/lib/customhealthapi/core.lua")
	include("lua/lib/customhealth.lua")
	include("lua/CEAdd.lua")
	
	local hiddenItemManager = require("lua.lib.hidden_item_manager")
	hiddenItemManager:Init(mod)
	hiddenItemManager:HideCostumes()
	local familiarRNG = RNG()
	local sfx = SFXManager()
	
	local customShieldFlags = {
		[CollectibleType.COLLECTIBLE_BRIMSTONE] = TearFlags.TEAR_BRIMSTONE_BOMB,
		[CollectibleType.COLLECTIBLE_IPECAC] = TearFlags.TEAR_POISON | TearFlags.TEAR_EXPLOSIVE,
		[CollectibleType.COLLECTIBLE_TOXIC_SHOCK] = TearFlags.TEAR_POISON,
		[CollectibleType.COLLECTIBLE_FIRE_MIND] = TearFlags.TEAR_BURN,
		[CollectibleType.COLLECTIBLE_PYROMANIAC] = TearFlags.TEAR_BURN | TearFlags.TEAR_EXPLOSIVE,
		[CollectibleType.COLLECTIBLE_SPIDER_BITE] = TearFlags.TEAR_SLOW,
		[CollectibleType.COLLECTIBLE_SULFURIC_ACID] = TearFlags.TEAR_ACID,
		[CollectibleType.COLLECTIBLE_BALL_OF_TAR] = TearFlags.TEAR_GISH,
		[CollectibleType.COLLECTIBLE_MOMS_KNIFE] = TearFlags.TEAR_NEEDLE,
		[CollectibleType.COLLECTIBLE_MOMS_RAZOR] = TearFlags.TEAR_NEEDLE,
		[CollectibleType.COLLECTIBLE_RAZOR_BLADE] = TearFlags.TEAR_NEEDLE,
		[CollectibleType.COLLECTIBLE_LODESTONE] = TearFlags.TEAR_MAGNETIZE,
		[CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR] = TearFlags.TEAR_MAGNETIZE,
		[CollectibleType.COLLECTIBLE_EXPLOSIVO] = TearFlags.TEAR_EXPLOSIVE,
		[CollectibleType.COLLECTIBLE_TRINITY_SHIELD] = TearFlags.TEAR_SHIELDED,
		[CollectibleType.COLLECTIBLE_LOST_CONTACT] = TearFlags.TEAR_SHIELDED,
	}
	
	function mod:AddCustomSawShieldFlag(collectible, flag)
		if not customShieldFlags[collectible] then
			customShieldFlags[collectible] = 0
		end
		customShieldFlags[collectible] = customShieldFlags[collectible] | flag
	end
	
	local function lerp(a, b, t)
		t = t or 0.2
		return a + (b - a) * t
	end	

	mod.RepmTypes = {}
	
	mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY = Isaac.GetItemIdByName("Frozen Flies")
	mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS = Isaac.GetItemIdByName("Friendly Rocks")
	mod.RepmTypes.COLLECTIBLE_LIKE = Isaac.GetItemIdByName("Like")
	mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD = Isaac.GetItemIdByName("Frozen Food")
	mod.RepmTypes.COLLECTIBLE_NUMB_HEART = Isaac.GetItemIdByName("Numb Heart")
	mod.RepmTypes.COLLECTIBLE_COKA_COLA = Isaac.GetItemIdByName("Coсa Cola")
	mod.RepmTypes.COLLECTIBLE_BOOK_OF_TAILS = Isaac.GetItemIdByName("Book of Tales")
	--mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER = Isaac.GetItemIdByName("Pro Backstabber")
	mod.RepmTypes.COLLECTIBLE_PRO_KAMIKAZE = Isaac.GetItemIdByName("Pro Kamikaze")
	mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE = Isaac.GetItemIdByName("Sim's Axe")
	mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART = Isaac.GetItemIdByName("Curious Heart")
	mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK = Isaac.GetItemIdByName("Strawberry Milk")
	mod.RepmTypes.COLLECTIBLE_HOLY_SHELL = Isaac.GetItemIdByName("Holy shell")
	mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET = Isaac.GetItemIdByName("Leaky Bucket")
	mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH = Isaac.GetItemIdByName("Delirious Tech")
	--mod.RepmTypes.COLLECTIBLE_VACUUM = Isaac.GetItemIdByName("Vacuum")
	mod.RepmTypes.COLLECTIBLE_BEEG_MINUS = Isaac.GetItemIdByName("Minus")
	mod.RepmTypes.COLLECTIBLE_PINK_STRAW = Isaac.GetItemIdByName("Pink Straw")
	mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE = Isaac.GetItemIdByName("Pixelated Cube")
	mod.RepmTypes.COLLECTIBLE_110V = Isaac.GetItemIdByName("110V")
	mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE = Isaac.GetItemIdByName("Deliriums Eye")
	mod.RepmTypes.Collectible_HOLY_OTMICHKA = Isaac.GetItemIdByName("Holy Master Key")
	mod.RepmTypes.Collectible_FLOWER_TEA = Isaac.GetItemIdByName("Flower Tea")
	mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH = Isaac.GetItemIdByName("Faustian Bargain")
	mod.RepmTypes.Collectible_SANDWICH = Isaac.GetItemIdByName("Sandwich")
	mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER = Isaac.GetItemIdByName("Necronomicon Vol. 3")
	mod.RepmTypes.COLLECTIBLE_VHS = Isaac.GetItemIdByName("VHS Cassette")
	mod.RepmTypes.COLLECTIBLE_ROT = Isaac.GetItemIdByName("Rot")
	mod.RepmTypes.Collectible_BLOODY_NEGATIVE = Isaac.GetItemIdByName("Bloody Negative")
	mod.RepmTypes.Collectible_SIREN_HORNS = Isaac.GetItemIdByName("Siren Horns")
	mod.RepmTypes.Collectible_HOW_TO_DIG = Isaac.GetItemIdByName("How To Dig")
	mod.RepmTypes.Collectible_BATTERED_LIGHTER = Isaac.GetItemIdByName("Battered Lighter")
	mod.RepmTypes.Collectible_HOLY_LIGHTER = Isaac.GetItemIdByName("Holy Lighter")
	mod.RepmTypes.Collectible_SAW_SHIELD = Isaac.GetItemIdByName("Saw Shield")

mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY = Isaac.GetTrinketIdByName("Pocket Technology")
mod.RepmTypes.TRINKET_MICRO_AMPLIFIER = Isaac.GetTrinketIdByName("Micro Amplifier")
mod.RepmTypes.TRINKET_FROZEN_POLAROID = Isaac.GetTrinketIdByName("Frozen Polaroid")
mod.RepmTypes.TRINKET_BURNED_CLOVER = Isaac.GetTrinketIdByName("Burnt Clover")
mod.RepmTypes.TRINKET_MORE_OPTIONS = Isaac.GetTrinketIdByName("MORE OPTIONS")
mod.RepmTypes.TRINKET_HAMMER = Isaac.GetTrinketIdByName("Hammer")

mod.RepmTypes.CHARACTER_FROSTY_B = Isaac.GetPlayerTypeByName("Tainted Frosty", true)
mod.RepmTypes.CHARACTER_FROSTY_C = Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false)
mod.RepmTypes.CHALLENGE_LOCUST_KING = Isaac.GetChallengeIdByName("Locust King")

mod.RepmTypes.EFFECT_FROSTY_RIFT = Isaac.GetEntityVariantByName("Frosty Rift")

mod.RepmTypes.SIREN_COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/tantrum_face.anm2")

mod.RepmTypes.SFX_WIND = Isaac.GetSoundIdByName("blizz_sound")
mod.RepmTypes.SFX_LIGHTNING = Isaac.GetSoundIdByName("Thunder")
mod.RepmTypes.SFX_SIREN = Isaac.GetSoundIdByName("siren_sound")
mod.RepmTypes.SFX_LIGHTER = Isaac.GetSoundIdByName("lighter_sound")
mod.RepmTypes.SFX_PICKUP_SAW_SHIELD = Isaac.GetSoundIdByName("sh_pickup")
mod.RepmTypes.SFX_SAW_SHIELD_BOUNCE = Isaac.GetSoundIdByName("sh_bounce")
mod.RepmTypes.SFX_SAW_SHIELD_CRASH = Isaac.GetSoundIdByName("sh_wall_crash")
mod.RepmTypes.SFX_SAW_SHIELD_DAMAGE = Isaac.GetSoundIdByName("sh_shredding")
	
local sawShieldFamiliar = Isaac.GetEntityVariantByName("Saw Shield")
local sawShieldFamiliarFire = Isaac.GetEntityVariantByName("Saw Shield Fire Effect")
	
local FrostyAchId = Isaac.GetAchievementIdByName("Frosty")
	local DeathCardAchId = Isaac.GetAchievementIdByName("FrostySatan")
	local FrozenHeartsAchId = Isaac.GetAchievementIdByName("FrozenHearts")
	local ImprovedCardsAchId = Isaac.GetAchievementIdByName("improved_cards")
	local NumbHeartAchId = Isaac.GetAchievementIdByName("NumbHeart")
	local RotAchId = Isaac.GetAchievementIdByName("RotAch")
	local SimDeliriumId = Isaac.GetAchievementIdByName("SimDelirium")
	local TFrostyUnlockAch = Isaac.GetAchievementIdByName("Frosty_B")
	
	function mod.GetMenuSaveData()
		if not mod.saveTable.MenuData then
			if mod:HasData() then
				mod.saveTable.MenuData = json.decode(mod:LoadData()).MenuData or {}
			else
				mod.saveTable.MenuData = {}
			end
		end
		return mod.saveTable.MenuData
	end
	
	function mod.StoreSaveData()
		if Isaac.IsInGame() then
			local jsonString = json.encode(mod.saveTable)
			mod:SaveData(jsonString)
		else
			local saveTable = json.decode(mod:LoadData())
			saveTable.MenuData = mod.saveTable.MenuData
			saveTable.MusicData = mod.saveTable.MusicData
			mod:SaveData(json.encode(saveTable))
		end
	end
	
	mod.directionToVector = {
		[Direction.LEFT] = Vector(-1, 0),
		[Direction.UP] = Vector(0, -1),
		[Direction.RIGHT] = Vector(1, 0),
		[Direction.DOWN] = Vector(0, 1),
		[Direction.NO_DIRECTION] = Vector(0, 1),
	}
	
	local function tearsUp(firedelay, val) --Скорострельность вычисляется через эту формулу
		local currentTears = 30 / (firedelay + 1)
		local newTears = currentTears + val
		return (30 / newTears) - 1
	end
	
	local function IsBaby(variant)
		return variant == FamiliarVariant.INCUBUS
			or variant == FamiliarVariant.TWISTED_BABY
			or variant == FamiliarVariant.BLOOD_BABY
			or variant == FamiliarVariant.CAINS_OTHER_EYE
			or variant == FamiliarVariant.UMBILICAL_BABY
			or variant == FamiliarVariant.SPRINKLER
	end
	
	function mod:GetPlayerFromTear(tear)
		for i = 1, 2 do
			local check = nil
			if i == 1 then
				check = tear.Parent
			elseif i == 2 then
				check = tear.SpawnerEntity
			end
			if check then
				if check.Type == EntityType.ENTITY_PLAYER then
					return check:ToPlayer()
				elseif check.Type == EntityType.ENTITY_FAMILIAR and IsBaby(check.Variant) then
					local data = tear:GetData()
					data.IsIncubusTear = true
					return check:ToFamiliar().Player:ToPlayer()
				end
			end
		end
		return nil
	end
	
	function mod:getPlayerFromKnifeLaser(entity)
		if entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer() then
			return entity.SpawnerEntity:ToPlayer()
		elseif entity.SpawnerEntity and entity.SpawnerEntity:ToFamiliar() and entity.SpawnerEntity:ToFamiliar().Player then
			local familiar = entity.SpawnerEntity:ToFamiliar()
	
			if IsBaby(familiar.Variant) then
				return familiar.Player
			else
				return nil
			end
		else
			return nil
		end
	end
	
	function mod:repmGetPData(player)
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
			player = player:GetOtherTwin()
		end
		if not player then
			return nil
		end
		local cIdx = player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B and 2 or 1
		local index = tostring(player:GetCollectibleRNG(cIdx):GetSeed())
		if not mod.saveTable.PlayerData[index] then
			mod.saveTable.PlayerData[index] = {}
		end
		return mod.saveTable.PlayerData[index]
	end
	
	local DSSInitializerFunction = include("lua.lib.DSSMenu")
	DSSInitializerFunction(mod)
	
	local activeItems = {}
	
	mod.LIGHTNING_EFFECT = Isaac.GetEntityTypeByName("Lightning")
	
	mod.LIGHTNING_VARIANT = Isaac.GetEntityVariantByName("2643")
	
	--[[When run begins
	function mod:onGameStart(fromSave)
		if not fromSave then
			if SpawnAtStart == true then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER, Vector(320,280), Vector(0,0), nil
				)
			end
			
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)]]
	
	--When enemy gets hit by a tear
	function mod:entityTakeDMG(tookDamage, damageAmount, damageFlag, damageSource, damageCountdownframes)
		if tookDamage:IsEnemy() and tookDamage:IsActiveEnemy() and tookDamage:IsVulnerableEnemy() then
			local entity = tookDamage
			if damageSource.Entity and damageSource.Entity:ToPlayer() then
				local player = damageSource.Entity:ToPlayer()
				if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER)
					and damageSource.Type == EntityType.ENTITY_TEAR and entity:IsVulnerableEnemy() then
					--Process begins
					local data = entity:GetData()	
					if data.TechLHits == nil then
						data.TechLHits = 0
					else
						data.TechLHits = data.TechLHits + 1
						if data.TechLHits == 5  then --At 5 shots
						--local NearPosition = Isaac.GetFreeNearPosition(entity.Position, 50)
						
							Isaac.Spawn(EntityType.ENTITY_EFFECT, 2643, mod.LIGHTNING_EFFECT,
							entity.Position, Vector(0,0), player) --Lightning spawns
							
							local FireEff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0,
							entity.Position, Vector(0,0), player) --Spawns fire
							FireEff.CollisionDamage = 0.35
							
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0,
							entity.Position, Vector(0,0), player) --Create bomb crater effect
							
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0,
							entity.Position, Vector(0,0), player) --Blue circle effect
							
							sound:Play(mod.RepmTypes.SFX_LIGHTNING, 1, 0, false, 0.6) --Lightning Sound
							--Reset Hits counter
							data.TechLHits = 0
				
							--Deals damage
							entity:TakeDamage(player.Damage * 4, 1, damageSource, 0)
							entity:AddBurn(damageSource, 120, player.Damage / 5)
							
							
						end		
					end
				end
			end	
		end
	end
	
	--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.entityTakeDMG)
	
	function mod:removeLightning(EntityNPC) --Remove the lightning
		local Lightning = EntityNPC
		if Lightning:GetSprite():IsEventTriggered("End") then
			Lightning:GetSprite():Remove()
			Lightning:Remove()
		end
	end
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.removeLightning, EntityType.ENTITY_EFFECT, 2643, mod.LIGHTNING_EFFECT)
	
	--[[function mod:fireNoCollide(EntityEffect)
		local player = Isaac.GetPlayer(0)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER) then
			Isaac.DebugString("BOMBfire")
			--Don't collide fire with tears (probably does nothing)
			EntityEffect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.fireNoCollide, EffectVariant.HOT_BOMB_FIRE)]]
	
	--Add glowing tears
	--[[function mod:glowingTears()
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER) then
			game:GetSeeds():AddSeedEffect(SeedEffect.SEED_GLOWING_TEARS)
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.glowingTears)]]
	
	function mod:RedButtonUse(item, rng, p)
		local roomEntities = Isaac.GetRoomEntities()
		for _, entity in ipairs(roomEntities) do
			if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
				for i = 1, math.random(3, 5) do
					local flame = Isaac.Spawn(
						EntityType.ENTITY_EFFECT,
						EffectVariant.RED_CANDLE_FLAME,
						0,
						p.Position,
						Vector(math.random(-10, 10), math.random(-10, 10)),
						p
					)
					flame.CollisionDamage = 5
				end
			end
		end
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.RedButtonUse, mod.RepmTypes.COLLECTIBLE_PRO_KAMIKAZE)
	
	function mod:updateCache_AllStats(player, cacheFlag)
	
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Minusaac" then
				player.Damage = player.Damage + 0.7
			end
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Minusaac" then
				player.Luck = player.Luck + 1
			end
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Minusaac" then
				player.MoveSpeed = player.MoveSpeed + 0.2
			end
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Minusaac" then
				player.MaxFireDelay = tearsUp(player.MaxFireDelay, 1)
			end
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:GetName() == "Minusaac" then
				player.TearRange = player.TearRange + 40 * 0.5
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_AllStats)
	
	----------------------------------------------------------
	--Sim's Axe
	----------------------------------------------------------
	
	local function TEARFLAG(x)
		return x >= 64 and BitSet128(0, 1 << (x - 64)) or BitSet128(1 << x, 0)
	end
	
	ExtraSpins = 0
	
	function mod:PostNewRoom()
		ExtraSpins = 0 -- just in case it gets interrupted
		RepMMod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == (Isaac.GetPlayerTypeByName("Tainted Ghost Frosty", false)) then
				player:GetEffects():AddNullEffect(NullItemID.ID_LOST_CURSE, false, 1)
			end
		end)
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PostNewRoom)
	
	function mod:onUseAxe(collectibletype, rng, player, useflags, slot, vardata)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
			ExtraSpins = ExtraSpins + 1
		end
		Isaac.GetItemConfig():GetCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE).MaxCharges = Isaac.GetItemConfig():GetCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE).MaxCharges + 25
		mod:SpawnAxeSwing(player)
	end
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseAxe, mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE)
	
	--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PlayerHurt, EntityType.ENTITY_PLAYER)
	
	local axeActiveVariant = Isaac.GetEntityVariantByName("Sim Axe Active")
	function mod:AxeActiveUpdate(axe)
		local player = axe.Parent:ToPlayer()
		local sprite = axe:GetSprite()
		if
			sprite:IsPlaying("SpinLeft")
			or sprite:IsPlaying("SpinUp")
			or sprite:IsPlaying("SpinRight")
			or sprite:IsPlaying("SpinDown")
		then
			axe.Position = player.Position
			SFXManager():Stop(SoundEffect.SOUND_TEARS_FIRE)
		else
			axe:Remove()
			local entities = Isaac.GetRoomEntities()
			for i, entity in ipairs(entities) do
				entity:GetData().RepmFlaggedForCrunch = nil
			end
			local pdata = mod:repmGetPData(player)
			pdata.SimAxeFlag = false
			if ExtraSpins > 0 then
				mod:SpawnAxeSwing(player)
				ExtraSpins = ExtraSpins - 1
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.AxeActiveUpdate, axeActiveVariant)
	
	function mod:MeatySound(entityTear, collider, low)
		if collider:IsActiveEnemy() and collider:IsVulnerableEnemy() and collider:GetData().AxeHitImmunity ~= 1 then
			collider:GetData().AxeHitImmunity = 1
			collider:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
			collider:TakeDamage(entityTear.CollisionDamage, DamageFlag.DAMAGE_TNT, EntityRef(entityTear.Parent), 0)
		else
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.MeatySound, axeActiveVariant)
	
	function mod:BlockAxeRecharge(player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE) then
			return false
		end
	end
	--mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TRIGGER_ROOM_CLEAR, mod.BlockAxeRecharge)
	
	function mod:SpawnAxeSwing(player)
		for i, entity in pairs(Isaac.GetRoomEntities()) do
			entity:GetData().AxeHitImmunity = 0
		end
		local axe = Isaac.Spawn(2, axeActiveVariant, 0, player.Position, Vector.Zero, player):ToTear()
	
		axe.Parent = player
		axe.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		axe.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
			axe.CollisionDamage = (player.Damage * 6) + 5
		else
			axe.CollisionDamage = (player.Damage * 3) + 5
		end
		axe:GetData().SimAxeFlag = true
	
		axe:AddTearFlags(TEARFLAG(1) | TEARFLAG(2) | TEARFLAG(34)) --piercing, spectral, shielding, and hp drop
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
			axe:AddTearFlags(TEARFLAG(4)) -- poison
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_URANUS) then
			axe:AddTearFlags(TEARFLAG(65)) -- ice
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) then
			axe:AddTearFlags(TEARFLAG(39)) -- holy light
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER) then
			axe:AddTearFlags(TEARFLAG(74)) -- coin drop
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BAG) then
			if math.random(1, 7) == 6 then
				axe:AddTearFlags(TEARFLAG(15))
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST) then
			if math.random(1, 8) == 8 then
				axe:AddTearFlags(TEARFLAG(15))
			end
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART) then
			if math.random(1, 4) == 2 then
				axe:AddTearFlags(TEARFLAG(15))
			end
		end
	
		local sprite = axe:GetSprite()
		local headDirection = player:GetHeadDirection()
		if
			player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
			or player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
			or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
		then
			sprite.PlaybackSpeed = 2
		end
	
		if headDirection == Direction.LEFT then
			sprite:Play("SpinLeft", true)
		elseif headDirection == Direction.UP then
			sprite:Play("SpinUp", true)
		elseif headDirection == Direction.RIGHT then
			sprite:Play("SpinRight", true)
		elseif headDirection == Direction.DOWN then
			sprite:Play("SpinDown", true)
		end
	
		SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN)
	end
	
	function mod:ExemptHalfCircle(Entity, DamageAmount, DamageFlags, DamageSource, DamageCountdownFrames)
		if
			DamageSource.Entity
			and DamageSource.Entity:ToTear()
			and DamageSource.Entity:ToTear():GetData().SimAxeFlag == true
		then
			--and DamageSource.Entity:GetData().SimAxeFlag == true
			local playerSource = mod:GetPlayerFromTear(DamageSource.Entity)
			local direction = playerSource:GetHeadDirection()
			if
				(direction == Direction.LEFT and (playerSource.Position.X < Entity.Position.X))
				or (direction == Direction.RIGHT and (playerSource.Position.X > Entity.Position.X))
				or (direction == Direction.UP and (playerSource.Position.Y < Entity.Position.Y))
				or (direction == Direction.DOWN and (playerSource.Position.Y > Entity.Position.Y))
			then
				return false
			else
				SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ExemptHalfCircle)
	
	local SimType = Isaac.GetPlayerTypeByName("Sim", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
	--local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/sim_hair.anm2") -- Exact path, with the "resources" folder as the root
	
	local chargebarFrames = 235
	local AxeHud = Sprite()
	AxeHud:Load("gfx/chargebar_axe.anm2", true)
	--local framesToCharge = 141
	local framesToCharge = 235
	--local framesToCharge = 20
	local axeRenderedPosition = Vector(20, -27)
	
	function mod:renderSimCharge(player)
		local data = player:GetData()
		if player:GetPlayerType() == SimType then
			data.RepM_SimChargeFrames = data.RepM_SimChargeFrames or 0
			local maxThreshold = data.RepM_SimChargeFrames
			local aim = player:GetAimDirection()
			local isAim = aim:Length() > 0.01
	
			if isAim then
				data.RepM_SimChargeFrames = (data.RepM_SimChargeFrames or 0) + 1
			elseif not game:IsPaused() then
				data.RepM_SimChargeFrames = 0
			end
	
			if maxThreshold > framesToCharge and data.RepM_SimChargeFrames == 0 then
				data.repM_fireAxe = true
			end
	
			if data.RepM_SimChargeFrames > 0 and data.RepM_SimChargeFrames <= framesToCharge then
				local frameToSet = math.floor(math.min(data.RepM_SimChargeFrames * (100 / framesToCharge), 100))
				AxeHud:SetFrame("Charging", frameToSet)
				AxeHud:Render(Isaac.WorldToScreen(player.Position) + axeRenderedPosition)
			elseif data.RepM_SimChargeFrames > framesToCharge then
				local frameToSet = math.floor((data.RepM_SimChargeFrames - framesToCharge) / 2) % 6
				AxeHud:SetFrame("Charged", frameToSet)
				AxeHud:Render(Isaac.WorldToScreen(player.Position) + axeRenderedPosition)
			end
		end
		if data.HolyshellFrame and data.HolyshellFrame > 0 and (data.HolyshellFrame / player.MaxFireDelay / 3) < 1 then
			local frameToSet = math.floor(math.min(100, (data.HolyshellFrame / player.MaxFireDelay / 3) * 100))
			AxeHud:SetFrame("Charging", frameToSet)
			AxeHud:Render(Isaac.WorldToScreen(player.Position) + axeRenderedPosition)
		elseif data.HolyshellFrame and (data.HolyshellFrame / player.MaxFireDelay / 3) == 1 then
			local frameToSet = game:GetFrameCount() % 12
			AxeHud:SetFrame("Charged", frameToSet)
			AxeHud:Render(Isaac.WorldToScreen(player.Position) + Vector(20, -27))
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.renderSimCharge)
	
	local axeEntity = Isaac.GetEntityVariantByName("Sim Axe Pickup")
	function mod:onUpdatePickupDrops()
		local axes = Isaac.FindByType(5, axeEntity, 1)
		for i, axe in ipairs(axes) do
			if axe:GetSprite():GetFrame() >= 6 and axe:GetSprite():GetAnimation() == "Collect" then
				axe:Remove()
			elseif axe:GetSprite():IsEventTriggered("DropSound") then
				sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 2)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdatePickupDrops)
	
	function mod:OnCollideAxe(entity, Collider, Low)
		local player = Collider:ToPlayer()
		local data = Collider:GetData()
	
		if player == nil then
			return nil
		end
	
		if
			entity.Type == EntityType.ENTITY_PICKUP
			and entity.Variant == axeEntity
			and entity:GetData().Collected ~= true
			and player:GetPlayerType() == SimType
		then
			entity:GetData().Collected = true
			entity:GetSprite():Play("Collect")
			sfx:Play(SoundEffect.SOUND_SCAMPER)
			mod.saveTable.SimAxesCollected = (mod.saveTable.SimAxesCollected or 0) + 1
		elseif
			entity.Type == EntityType.ENTITY_PICKUP
			and entity.Variant == axeEntity
			and player:GetPlayerType() ~= SimType
		then
			return false
		elseif entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == axeEntity then
			return
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.OnCollideAxe)
	
	function mod:getTearDuplicateAmt(player)
		return 1
			+ player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20)
			+ (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) * 2)
			+ (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) * 3)
	end
	
	function mod:adjustAngle_SIM(velocity, stream, totalstreams)
		local multiplicator = velocity:Length()
		local angleAdjustment = 10 * (stream - 1) - 5 * (totalstreams - 1)
		local correctAngle = velocity:GetAngleDegrees() + angleAdjustment
		return Vector.FromAngle(correctAngle) * multiplicator
	end
	
	function mod:onFireAxe(player)
		if player:GetData().repM_fireAxe == true then
			player:GetData().repM_fireAxe = false
			local direction = mod.directionToVector[player:GetHeadDirection()] * (25 * player.ShotSpeed)
			local multiples = mod:getTearDuplicateAmt(player)
			for y = 1, multiples, 1 do
				local new_dir = mod:adjustAngle_SIM(direction, y, multiples)
				local tear
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
					tear = player:FireTear(player.Position, new_dir, false, true, false, nil, 5)
					if math.random(1,3) == 1 then
						tear:AddTearFlags(TearFlags.TEAR_HP_DROP)
					end
				else
					tear = player:FireTear(player.Position, new_dir, false, true, false, nil, 3)
				end
				SFXManager():Play(SoundEffect.SOUND_BIRD_FLAP)
				tear.Scale = tear.Scale * 0.5
				tear.Variant = TearVariant.SCHYTHE
				tear:AddTearFlags(TearFlags.TEAR_BOOMERANG | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL)
				tear:GetData().repm_IsAxeCharge = true
			end
		end
		if player:GetPlayerType() == SimType and not mod.saveTable.SimAxesCollected then
			mod.saveTable.SimAxesCollected = 1
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onFireAxe)
	
	local PriceTextFontTempesta = Font()
	PriceTextFontTempesta:Load("font/pftempestasevencondensed.fnt")
	
	local LastTimeArrowPress = -30
	local ArrowLastUsed = -1
	
	function mod:IsDoubleTapTriggered(player)
		if
			game:GetFrameCount() - LastTimeArrowPress < 6
			and (
				(
					Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex)
					and ArrowLastUsed == ButtonAction.ACTION_SHOOTLEFT
				)
				or (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) and ArrowLastUsed == ButtonAction.ACTION_SHOOTRIGHT)
				or (Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) and ArrowLastUsed == ButtonAction.ACTION_SHOOTUP)
				or (
					Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)
					and ArrowLastUsed == ButtonAction.ACTION_SHOOTDOWN
				)
			)
		then
			return true
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
			ArrowLastUsed = ButtonAction.ACTION_SHOOTRIGHT
			LastTimeArrowPress = game:GetFrameCount()
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
			ArrowLastUsed = ButtonAction.ACTION_SHOOTUP
			LastTimeArrowPress = game:GetFrameCount()
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
			ArrowLastUsed = ButtonAction.ACTION_SHOOTDOWN
			LastTimeArrowPress = game:GetFrameCount()
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
			ArrowLastUsed = ButtonAction.ACTION_SHOOTLEFT
			LastTimeArrowPress = game:GetFrameCount()
		end
		return false
	end
	
	function mod:simUIAxeRender(player)
		local isSim = false
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == SimType then
				isSim = true
				if mod:IsDoubleTapTriggered(player) and mod.saveTable.SimAxesCollected > 0 and not game:IsPaused() then --
					player:GetData().repM_fireAxe = true
					mod.saveTable.SimAxesCollected = mod.saveTable.SimAxesCollected - 1
				end
			end
		end)
		if isSim then
			if mod.saveTable.uiAxeSprite == nil then
				mod.saveTable.uiAxeSprite = Sprite()
				mod.saveTable.uiAxeSprite:Load("gfx/ui/hudpickupsAXE.anm2", true)
				mod.saveTable.uiAxeSprite:Play("Idle")
				mod.saveTable.uiAxeSprite:SetFrame(0)
			end
	
			--print(mod.saveTable.SimAxesCollected)
			if game:GetHUD():IsVisible() then
				local targetPos = Vector(30, 33) + game.ScreenShakeOffset + (Options.HUDOffset * Vector(20, 12))
				PriceTextFontTempesta:DrawStringScaled(
					string.format("%02d", (mod.saveTable.SimAxesCollected or 0)),
					targetPos.X + 15,
					targetPos.Y,
					1,
					1,
					KColor(1, 1, 1, 1)
				)
				mod.saveTable.uiAxeSprite:Render(targetPos)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.simUIAxeRender)
	
	function mod:OnRoomClear_SimAxes()
		local room = game:GetRoom()
	
		if game:IsGreedMode() then
			if Game():GetLevel():GetCurrentRoomDesc().GridIndex == 84 then
				mod:AnyPlayerDo(function(player)
					if player:GetPlayerType() == SimType then
						local playerRNG = player:GetDropRNG()
						if game.Difficulty == 2 and game:GetLevel().GreedModeWave == 10 then
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(80, 160), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(80, 800), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(800, 300), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(800, 2000), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
						elseif game.Difficulty == 3 and game:GetLevel().GreedModeWave == 11 then
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(80, 160), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(0, 800), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(800, 300), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(Vector(800, 2000), 0, true),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
							Isaac.Spawn(
								5,
								axeEntity,
								1,
								game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
								Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
								nil
							)
						end
					end
				end)
			end
		end
		if room:GetType() == RoomType.ROOM_BOSS then
			mod:AnyPlayerDo(function(player)
				if player:GetPlayerType() == SimType then
					local playerRNG = player:GetDropRNG()
					--mod.saveTable.SimAxesCollected = (mod.saveTable.SimAxesCollected or 0) + playerRNG:RandomInt(2) + randoMax
					--sfx:Play(SoundEffect.SOUND_THUMBSUP)
					--player:AnimateHappy()
					Isaac.Spawn(
						5,
						axeEntity,
						1,
						game:GetRoom():FindFreePickupSpawnPosition(Vector(80, 160), 0, true),
						Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
						nil
					)
					Isaac.Spawn(
						5,
						axeEntity,
						1,
						game:GetRoom():FindFreePickupSpawnPosition(Vector(80, 400), 0, true),
						Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
						nil
					)
					Isaac.Spawn(
						5,
						axeEntity,
						1,
						game:GetRoom():FindFreePickupSpawnPosition(Vector(560, 160), 0, true),
						Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
						nil
					)
					Isaac.Spawn(
						5,
						axeEntity,
						1,
						game:GetRoom():FindFreePickupSpawnPosition(Vector(560, 400), 0, true),
						Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
						nil
					)
					Isaac.Spawn(
						5,
						axeEntity,
						1,
						game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
						Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
						nil
					)
				end
			end)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnRoomClear_SimAxes)
	
	function mod:NewRoomAXE()
		local room = game:GetRoom()
		if
			room:GetType() == RoomType.ROOM_TREASURE
			or room:GetType() == RoomType.ROOM_SHOP
			or room:GetType() == RoomType.ROOM_SECRET
			or room:GetType() == RoomType.ROOM_PLANETARIUM
		then
			mod:AnyPlayerDo(function(player)
				if player:GetPlayerType() == SimType and room:IsFirstVisit() and player:HasCollectible(619) then
					local playerRNG = player:GetDropRNG()
					for i = 1, math.random(1, 3) do
						Isaac.Spawn(
							5,
							axeEntity,
							1,
							game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos()),
							Vector(playerRNG:RandomFloat() - 0.5, playerRNG:RandomFloat() - 0.5) * Vector(2, 2),
							nil
						)
					end
				end
			end)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoomAXE)
	
	local function getTearScale13(tear)
		local sprite = tear:GetSprite()
		local scale = tear.Scale
		local sizeMulti = tear.SizeMulti
		local flags = tear.TearFlags
	
		if scale > 2.55 then
			return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
		elseif
			flags & TearFlags.TEAR_GROW == TearFlags.TEAR_GROW
			or flags & TearFlags.TEAR_LUDOVICO == TearFlags.TEAR_LUDOVICO
		then
			if scale <= 0.3 then
				return Vector((scale * sizeMulti.X) / 0.25, (scale * sizeMulti.Y) / 0.25)
			elseif scale <= 0.55 then
				local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
				return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
			elseif scale <= 1.175 then
				local adjustedBase = math.ceil((scale - 0.175) / 0.125) * 0.125 + 0.175
				return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
			elseif scale <= 2.175 then
				local adjustedBase = math.ceil((scale - 0.175) / 0.25) * 0.25 + 0.175
				return Vector((scale * sizeMulti.X) / adjustedBase, (scale * sizeMulti.Y) / adjustedBase)
			else
				return Vector((scale * sizeMulti.X) / 2.55, (scale * sizeMulti.Y) / 2.55)
			end
		else
			return sizeMulti
		end
	end
	
	function mod:axeTearRender(tear, offset)
		local data = tear:GetData()
		if data.repm_IsAxeCharge == nil then
			return
		end
	
		local sprite = mod.saveTable.AxeDefaultSprite
		if not mod.saveTable.AxeDefaultSprite then
			sprite = Sprite()
			sprite:Load("gfx/axe_tear_.anm2", true)
			sprite:LoadGraphics()
			mod.saveTable.AxeDefaultSprite = sprite
		end
	
		local tearsprite = tear:GetSprite()
		local scale = tear.Scale
		local flags = tear.TearFlags
	
		local anim
		if scale <= 0.3 then
			anim = "Rotate1"
		elseif scale <= 0.8 then
			anim = "Rotate2"
		elseif scale <= 1.175 then
			anim = "Rotate3"
		elseif scale <= 1.925 then
			anim = "Rotate4"
		else
			anim = "Rotate5"
		end
	
		sprite.PlaybackSpeed = tearsprite.PlaybackSpeed
		if not sprite:IsPlaying(anim) then
			local frame = sprite:GetFrame()
			sprite:Play(anim, true)
			sprite:SetFrame(frame)
		elseif
			not game:IsPaused()
			and Isaac.GetFrameCount() % 3 == 0
			and data.REPM_LastRenderFrame ~= Isaac.GetFrameCount()
		then
			sprite:Update()
		end
	
		local spritescale = getTearScale13(tear)
		sprite.Scale = spritescale
		sprite.Color = tearsprite.Color
		tearsprite:ReplaceSpritesheet(0, "gfx/blank.png")
		tearsprite:LoadGraphics()
		--tear.Visible = false
		--tear:GetSprite():LoadGraphics()
	
		---@diagnostic disable-next-line: param-type-mismatch
		--print(tear.Position + tear.PositionOffset)
	
		--print(Isaac.WorldToRenderPosition(tear.Position + tear.PositionOffset) + offset)
		sprite:Render(Isaac.WorldToRenderPosition(tear.Position + tear.PositionOffset) + offset, Vector.Zero, Vector.Zero)
		data.REPM_LastRenderFrame = Isaac.GetFrameCount()
	end
	mod:AddCallback(ModCallbacks.MC_POST_TEAR_RENDER, mod.axeTearRender)
	
	function mod:GiveCostumesOnInit(player)
		if player:GetPlayerType() ~= SimType then
			return
		end
		if Isaac.GetPersistentGameData():Unlocked(SimDeliriumId) then
			player:AddCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE, 3)
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.GiveCostumesOnInit)
	local Sim = { -- Change Sim everywhere to match your character. No spaces!
		DAMAGE = 1, -- These are all relative to Isaac's base stats.
		SPEED = 0.3,
		SHOTSPEED = -1,
		TEARHEIGHT = 2,
		TEARFALLINGSPEED = 0,
		LUCK = 4,
		FLYING = false,
		TEARFLAG = 0, -- 0 is default
		TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0), -- Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0) is default
	}
	
	function Sim:onCache(player, cacheFlag) -- I do mean everywhere!
		if player:GetName() == "Sim" then -- Especially here!
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + Sim.DAMAGE
			end
			if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + Sim.SHOTSPEED
			end
			if cacheFlag == CacheFlag.CACHE_RANGE then
				player.TearHeight = player.TearHeight - Sim.TEARHEIGHT
				player.TearFallingSpeed = player.TearFallingSpeed + Sim.TEARFALLINGSPEED
			end
			if cacheFlag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + Sim.SPEED
			end
			if cacheFlag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck + Sim.LUCK
			end
			if cacheFlag == CacheFlag.CACHE_FLYING and Sim.FLYING then
				player.CanFly = true
			end
			if cacheFlag == CacheFlag.CACHE_TEARFLAG then
				player.TearFlags = player.TearFlags | Sim.TEARFLAG
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Sim.onCache)
	
	function mod:onBookOfTails(_, rng, player) -- сбив сделки при получении урона
		local room = game:GetRoom()
	
		for i = 1, 8 do
			local door = room:GetDoor(i)
			if door and (door.TargetRoomType == RoomType.ROOM_DEVIL or door.TargetRoomType == RoomType.ROOM_ANGEL) then
				room:RemoveDoor(i)
			end
		end
	
		game:GetLevel():SetRedHeartDamage()
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
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onBookOfTails, mod.RepmTypes.COLLECTIBLE_BOOK_OF_TAILS)
	
	function mod:onRoom() -- спавн ретро-сокровещницы
		if PlayerManager.AnyoneHasCollectible(mod.RepmTypes.COLLECTIBLE_BOOK_OF_TAILS) then
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
				for i = 0, game:GetNumPlayers() - 1 do
					local player = Isaac.GetPlayer(i)
					player:DischargeActiveItem()
				end
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onRoom)
	
	function isThereEnemies(room) -- function for checking if lil beast should activate or not, since the logic got so damn complicated
		if room:GetAliveEnemiesCount() ~= 0 or room:IsAmbushActive() then
			if not game:IsGreedMode() or not room:IsClear() then
				return "t"
			end
		elseif room:GetAliveEnemiesCount() == 0 and not room:IsAmbushActive() then
			if not game:IsGreedMode() or room:IsClear() then
				return "f"
			end
		end
		return nil
	end
	
	RNGTest = {}
	
	function RNGTest:onCuriousHeart(_, rng, player)
		--local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART)
		local roll = rng:RandomInt(100)
		local Nearby = Isaac.GetFreeNearPosition(player.Position, 10)
		if roll < 25 then
			player:AnimateSad()
		elseif roll < 45 then
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_HEART,
				HeartSubType.HEART_HALF,
				Nearby,
				Vector(0, 0),
				nil
			)
		elseif roll < 55 then
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_HEART,
				HeartSubType.HEART_FULL,
				Nearby,
				Vector(0, 0),
				nil
			)
		elseif roll < 60 then
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_HEART,
				HeartSubType.HEART_DOUBLEPACK,
				Nearby,
				Vector(0, 0),
				nil
			)
		elseif roll < 75 then
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_HEART,
				HeartSubType.HEART_SOUL,
				Nearby,
				Vector(0, 0),
				nil
			)
		elseif roll < 90 then
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_HEART,
				HeartSubType.HEART_BLACK,
				Nearby,
				Vector(0, 0),
				nil
			)
		else
			Isaac.Spawn(
				EntityType.ENTITY_PICKUP,
				PickupVariant.PICKUP_HEART,
				HeartSubType.HEART_ETERNAL,
				Nearby,
				Vector(0, 0),
				nil
			)
		end
		return true
	end
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, RNGTest.onCuriousHeart, mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART) -- , mod.Anm, Items.ID_Anm
	
	local PinkColor = Color(1, 1, 1, 1)
	PinkColor:SetColorize(5, 0.5, 2, 1)
	local DelColor = Color(1, 1, 1, 1)
	DelColor:SetColorize(3, 3, 3, 1)
	
	function mod:tearFire_StrawMilk(t)
		local d = t:GetData()
		local player = t.SpawnerEntity
			and (t.SpawnerEntity:ToPlayer() or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK) then
			d.IsStrawMilk = true
	
			if math.random(1, 8) == 8 then
				t:AddTearFlags(TearFlags.TEAR_FREEZE)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.tearFire_StrawMilk)
	
	function mod:TearDed_StrawMilk(t)
		if t:GetData().IsStrawMilk then
			local p = Isaac.Spawn(1000, 53, 0, t.Position, Vector.Zero, t)
			local player = t.SpawnerEntity and t.SpawnerEntity:ToPlayer()
				or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player
			if player then
				p:ToEffect().Scale = math.max(0.5, math.min(3, player.Damage / 15))
				p:Update()
				p:Update()
				p.Color = Color(5.0, 1.0, 5.0, 1.0, 2, 0, 2)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.TearDed_StrawMilk, EntityType.ENTITY_TEAR)
	
	function mod:TearColor_StrawMilk(player, cache)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE) then
			player.TearColor = DelColor
		elseif player:HasCollectible(mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK) then
			player.TearColor = PinkColor
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.TearColor_StrawMilk, CacheFlag.CACHE_TEARCOLOR)
	
	Holyshell = {}
	
	LaserType = { LASER_HOLY = 5 }
	LASER_DURATION = 15
	
	function Holyshell:onUpdate(player)
		local PlayerData = player:GetData()
		if PlayerData.HolyshellFrame == nil then
			PlayerData.HolyshellFrame = 0
		end
		if PlayerData.HolyshellCool == nil then
			PlayerData.HolyshellCool = 0
		end
	
		--заряд
		if
			player:HasCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_SHELL)
		then
			--player.FireDelay = player.MaxFireDelay -- стопает стрельбу
			if player:GetFireDirection() > -1 and PlayerData.HolyshellCool == 0 then
				-- заряд
				PlayerData.HolyshellFrame = math.min(player.MaxFireDelay * 3, PlayerData.HolyshellFrame + 1)
				BOff = (PlayerData.HolyshellFrame / player.MaxFireDelay / 6)
				player:SetColor(Color(1, 1, 1, 1, BOff, BOff, BOff), 1, 0, false, false)
			elseif game:GetRoom():GetFrameCount() > 1 then
				--стрельба
				if PlayerData.HolyshellFrame == player.MaxFireDelay * 3 then
						BaseAngle = 0
						--BaseAngle = 45
					for Angle = BaseAngle, BaseAngle + 270, 90 do
						local HolyLaser = EntityLaser.ShootAngle(
							LaserType.LASER_HOLY,
							player.Position,
							Angle,
							LASER_DURATION,
							Vector(0, 0),
							player
						)
						HolyLaser.TearFlags = player.TearFlags
						HolyLaser.CollisionDamage = player.Damage * 0.5
					end
					PlayerData.HolyshellCool = LASER_DURATION * 2
				else
				end
				PlayerData.HolyshellFrame = 0
			end
			PlayerData.HolyshellCool = math.max(0, PlayerData.HolyshellCool - 1)
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Holyshell.onUpdate)
	
	function mod:TrinketNewRoom() --Эта функция вызывается после смены комнаты
		for _, player in ipairs(PlayerManager.GetPlayers()) do --Цикл, в котором проходимся по всем игрокам
			if player:HasTrinket(mod.RepmTypes.TRINKET_MICRO_AMPLIFIER) then
				local data = player:GetData()
				--local TrinkRNG = player:GetTrinketRNG(1)
				local TrinkRNG = RNG() --RNG отвечает за неслучайную случайность
				TrinkRNG:SetSeed(game:GetLevel():GetCurrentRoomDesc().SpawnSeed + player.InitSeed, 35) --Сид, который отвечает за рандом
				data.PeremenuyEto = 1 << TrinkRNG:RandomInt(6)
				player:AddCacheFlags(CacheFlag.CACHE_ALL) --Добавляются флаги, чтобы указать какие статы перевычислятся
				player:EvaluateItems() --Эта функция вызывает перевычисление статов
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.TrinketNewRoom)
	local statUp = 0.6
	function mod:TrinketBonus(player, cache) --Эта функция вызывается при перевычисление статов
		local data = player:GetData()
		if data and data.PeremenuyEto and player:HasTrinket(mod.RepmTypes.TRINKET_MICRO_AMPLIFIER) then
			if cache == data.PeremenuyEto or cache == CacheFlag.CACHE_LUCK then
				local multi = player:GetTrinketMultiplier(mod.RepmTypes.TRINKET_MICRO_AMPLIFIER)
				if cache == CacheFlag.CACHE_SPEED then --SPEED
					player.MoveSpeed = player.MoveSpeed + statUp * multi
				elseif cache == CacheFlag.CACHE_DAMAGE then --DAMAGE
					player.Damage = player.Damage + statUp * multi
				elseif cache == CacheFlag.CACHE_FIREDELAY then --FIREDELAY
					player.MaxFireDelay = tearsUp(player.MaxFireDelay, statUp * multi)
				elseif cache == CacheFlag.CACHE_RANGE then --RANGE
					player.TearRange = player.TearRange + statUp * 40 * multi
				elseif cache == CacheFlag.CACHE_SHOTSPEED then --SHOTSPEED
					player.ShotSpeed = player.ShotSpeed + statUp * multi
				elseif cache == CacheFlag.CACHE_LUCK and data.PeremenuyEto == CacheFlag.CACHE_TEARFLAG then --LUCK
					player.Luck = player.Luck + statUp * multi
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.TrinketBonus)
	
	function mod:CheckTrinketHold(player) --Эта функция вызывается каждый кадр для каждого игрока
		local data = player:GetData()
		if player:HasTrinket(mod.RepmTypes.TRINKET_MICRO_AMPLIFIER) then
			if not data.PeremenuyEto then --Если есть брелок, но нет статов, то есть поднятие брелока
				local TrinkRNG = RNG()
				TrinkRNG:SetSeed(game:GetLevel():GetCurrentRoomDesc().SpawnSeed + player.InitSeed, 35)
				data.PeremenuyEto = 1 << TrinkRNG:RandomInt(6)
				player:AddCacheFlags(data.PeremenuyEto)
				player:EvaluateItems()
			end
		elseif not player:HasTrinket(mod.RepmTypes.TRINKET_MICRO_AMPLIFIER) and data.PeremenuyEto then --Если нету есть брелока, но есть статы, то есть потеря брелока
			player:AddCacheFlags(data.PeremenuyEto)
			data.PeremenuyEto = nil
			player:EvaluateItems()
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckTrinketHold)
	
	-- Checks whether or not you have the item and deals w/ initialization
	local function UpdateFaucet(player)
		HasLeakyFaucet = player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET)
	end
	
	-- Checks whether or not you have the item and deals w/ initialization
	local function UpdateFaucet(player)
		HasLeakyFaucet = player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET)
	end
	
	function mod:onPlayerInit(player)
		UpdateFaucet(player)
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
	--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT,  mod.onPlayerInit)
	
	-- Gives the Tears buff
	function mod:cacheUpdate(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET) then
				if player.MaxFireDelay >= 7 then
					player.MaxFireDelay = tearsUp(player.MaxFireDelay, 2)
				elseif player.MaxFireDelay >= 5 then
					player.MaxFireDelay = 5
				end
			end
		end
	end
	
	-- Randomly spawns Holy Water creep
	function mod:onUpdate_LeakyFaucet(player)
		local pos = player.Position
		-- Beginning of run initialization
		-- if game:GetFrameCount() == 1 then
		-- Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Isaac.GetItemIdByName("Leaky Faucet"), Vector(320,300), Vector(0,0), nil)
		-- That super long line is how to spawn the item in the starting room. Comment it if you don't want it.
		-- end
		if not HasLeakyFaucet and player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET) then
			HasLeakyFaucet = true
		end
		if HasLeakyFaucet and math.random(100) == 1 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER, 0, pos, Vector(0, 0), player)
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.cacheUpdate)
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onUpdate_LeakyFaucet)
	
	local config = Isaac.GetItemConfig()
	
	local function GetByQuality(min, max, pool, rnd)
		local Itempool = game:GetItemPool()
		for i = 1, 100 do
			local seed = rnd:RandomInt(1000000) + 1
			local new = Itempool:GetCollectible(pool, true, seed)
			local data = config:GetCollectible(new)
			if data.Quality and data.Quality >= min and data.Quality <= max then
				return new
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		local room = game:GetRoom()
		if room:IsFirstVisit() and room:GetType() == RoomType.ROOM_TREASURE and room:GetFrameCount() < 5 then
			local hasTrink = false
			for _, player in ipairs(PlayerManager.GetPlayers()) do
				hasTrink = hasTrink or (player:HasTrinket(mod.RepmTypes.TRINKET_BURNED_CLOVER) and player)
			end
			if hasTrink then
				local destroy
				local items = Isaac.FindByType(5, 100, -1)
				for i = 1, #items do
					local item = items[i] --and items[i].SubType
					if item then
						local data = config:GetCollectible(items[i].SubType)
						if data.Quality and data.Quality ~= 4 then
							local rng = RNG()
							rng:SetSeed(item.DropSeed, 35)
							local result = GetByQuality(4, 4, ItemPoolType.POOL_TREASURE, rng)
							if result then
								item:ToPickup():Morph(5, 100, result, true, true)
								destroy = true
							end
						end
					end
				end
				if destroy then
					local golden
					for i = 0, hasTrink:GetMaxTrinkets() - 1 do
						golden = golden
							or (
								hasTrink:GetTrinket(i)
								== mod.RepmTypes.TRINKET_BURNED_CLOVER + TrinketType.TRINKET_GOLDEN_FLAG
							)
					end
					hasTrink:TryRemoveTrinket(mod.RepmTypes.TRINKET_BURNED_CLOVER)
					if golden then
						hasTrink:AddTrinket(mod.RepmTypes.TRINKET_BURNED_CLOVER)
					end
				end
			end
		end
	end)
	
	-- get ids and stats
	local Trinket = {
		DAMAGE = 0.5,
	}
	
	-- main functionality
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flag, source, countdown)
		for p = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(p)
			local multiplier = player:GetTrinketMultiplier(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)
	
			if player:HasTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY) then
				if entity:IsEnemy() and entity:IsActiveEnemy(true) and entity:IsVulnerableEnemy() then
					local npc = entity:ToNPC()
	
					if npc:IsChampion() or (npc:IsBoss() and npc:GetBossColorIdx() >= 0) then
						if (flag & DamageFlag.DAMAGE_CLONES) ~= DamageFlag.DAMAGE_CLONES then
							npc:TakeDamage( -- take the same damage, but reduced by half
								amount * math.min(1, Trinket.DAMAGE * multiplier),
								DamageFlag.DAMAGE_CLONES, -- don't create infinite loop, prevents bugs
								EntityRef(player),
								0
							)
							--[[if destroy then
								local golden
								for i = 0, hasTrink:GetMaxTrinkets() - 1 do
									golden = golden
										or (hasTrink:GetTrinket(i) == mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY + TrinketType.TRINKET_GOLDEN_FLAG)
								end
								hasTrink:TryRemoveTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)
								if golden then
									hasTrink:AddTrinket(mod.RepmTypes.TRINKET_POCKET_TECHNOLOGY)
								end
							end]]
						end
					end
				end
			end
		end
	end)
	
	TearVariant.COKACOLA = Isaac.GetEntityVariantByName("Cokacola")
	local Cokafart = {
		RADIUS = 50,
		SCALE = 1,
		SUBTYPE = 0,
		FARTDELAY = 5,
	}
	
	function mod:TearUpdate(tear)
		local data = tear:GetData()
		if tear.Variant == 6208 then
			tear:GetSprite().Rotation = (tear.Velocity + Vector(0, tear.FallingSpeed)):GetAngleDegrees()
		end
		if data.IsCocaColaTear12 then
			data.IsCocaColaTear12.FartDelay = data.IsCocaColaTear12.FartDelay - 1
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.TearUpdate)
	
	function mod:TearFire(tear)
		local data = tear:GetData()
		local player = tear.SpawnerEntity
			and (tear.SpawnerEntity:ToPlayer() or tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity.Player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_COKA_COLA) then
			tear:ChangeVariant(TearVariant.COKACOLA)
			data.IsCocaColaTear12 = {
				player = player,
				FartDelay = Cokafart.FARTDELAY,
			}
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.TearFire)
	
	function mod:TearCollision(tear)
		local data = tear:GetData()
		if data.IsCocaColaTear12 and data.IsCocaColaTear12.player:Exists() then
			local Gram = Isaac.Spawn(
				EntityType.ENTITY_EFFECT,
				EffectVariant.CREEP_BROWN,
				0,
				tear.Position,
				Vector(0, 0),
				data.IsCocaColaTear12.player
			):ToEffect()
			Gram.CollisionDamage = (data.IsCocaColaTear12.player.Damage or 0.10) / 0.4
			Gram:SetColor(Color(0.5, 0.05, 0, 0, 0, 0, 0), 0, 0, false, false)
			Gram:GetData().Cokacola = true
			Gram:Update()
			Gram:Update()
			Gram.Color = Color(0.5, 0.05, 0, 1, 0, 0, 0)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.TearCollision, 2)
	
	function mod:onDamage(entity, collider)
		local data = entity:GetData()
		if data.IsCocaColaTear12 or entity.Type == EntityType.ENTITY_TEAR and entity.Variant == TearVariant.COKACOLA then
			if data.IsCocaColaTear12.FartDelay <= 0 and math.random(1, 3) == 1 then
				game:Fart(entity.Position, Cokafart.RADIUS, nil, Cokafart.SCALE, Cokafart.SUBTYPE)
				data.IsCocaColaTear12.FartDelay = Cokafart.FARTDELAY
			end
		end
	end
	
	mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, 100, mod.onDamage)
	
	function mod:onCache_Coka(player, flag)
		if flag == CacheFlag.CACHE_RANGE then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_COKA_COLA) then
				player.TearFallingSpeed = player.TearFallingSpeed - 3
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache_Coka)
	
	
	function mod:updateCache_Cig(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_CIGARETTE) then
				player.Damage = player.Damage + 1
			end
		end
	end
	
	--mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Cig)
	
	local spawnPos = Vector(500, 140)
	function mod:options_Wow_Room()
		local room = game:GetRoom()
		local hasTrink
		local HasSale
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			if player:HasTrinket(mod.RepmTypes.TRINKET_MORE_OPTIONS) then
				hasTrink = true
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE) then
				HasSale = true
			end
		end
	
		if hasTrink and room:IsFirstVisit() and room:GetType() == RoomType.ROOM_SHOP then
			local Itempool = game:GetItemPool()
			local pos = Isaac.GetFreeNearPosition(spawnPos, 40)
			local rng = RNG()
			local seed = game:GetLevel():GetCurrentRoomDesc().AwardSeed
			rng:SetSeed(seed, 35)
			local ItemId = GetByQuality(3, 4, Itempool:GetPoolForRoom(RoomType.ROOM_SHOP, seed), rng)
			if ItemId then
				local obj = Isaac.Spawn(5, 100, ItemId, pos, Vector.Zero, nil):ToPickup()
				obj:Update()
	
				obj.Price = 30
				obj.ShopItemId = -2
				obj.AutoUpdatePrice = false
				obj:Update()
				if HasSale then
					obj.Price = 15
				end
				local poof = Isaac.Spawn(1000, 16, 1, pos, Vector.Zero, nil):ToEffect()
				poof:GetSprite().Scale = Vector(0.6, 0.6)
				poof.Color = Color(0.5, 0.5, 0.5, 1)
				SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 1, 2, false, 1, 0)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.options_Wow_Room)
	
	local YellowColor = Color(1, 1, 1, 1)
	YellowColor:SetColorize(0.9, 0.9, 0, 2)
	
	function mod:TearDed_Banana(t)
		if t:GetData().IsBananaMilk then
			local p = Isaac.Spawn(1000, 53, 0, t.Position, Vector.Zero, t)
			local player = t.SpawnerEntity and t.SpawnerEntity:ToPlayer()
				or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player
			if player then
				p:ToEffect().Scale = math.max(0, math.min(3, player.Damage / 0))
				p:Update()
				p:Update()
				p.Color = Color(5.0, 1.0, 5.0, 1.0, 2, 0, 2)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.TearDed_Banana, EntityType.ENTITY_TEAR)
	
	EntityType.ENTITY_DICEGARPER = Isaac.GetEntityTypeByName("Dice Garper")
	DiceGarper = {
		SPEED = 0.5,
		RANGE = 200,
	}
	function mod:onDiceGarper(entity)
		local sprite = entity:GetSprite()
		sprite:PlayOverlay("Head", false)
		entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
		local target = entity:GetPlayerTarget()
		local data = entity:GetData()
		if data.GridCountdown == nil then
			data.GridCountdown = 0
		end
	
		if entity.State == 0 then
			if entity:IsFrame(8 / DiceGarper.SPEED, 0) then
				entity.Pathfinder:MoveRandomly(false)
			end
			if (entity.Position - target.Position):Length() < DiceGarper.RANGE then
				entity.State = 2
			end
		elseif entity.State == 2 then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
				entity.Pathfinder:FindGridPath(target.Position, DiceGarper.SPEED, 1, false)
				if data.GridCountdown <= 0 then
					data.GridCountdown = 30
				else
					data.GridCountdown = data.GridCountdown - 1
				end
			else
				entity.Velocity = (target.Position - entity.Position):Normalized() * DiceGarper.SPEED * 6
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.onDiceGarper, EntityType.ENTITY_DICEGARPER)
	
	EntityType.ENTITY_BROKEDICEGARPER = Isaac.GetEntityTypeByName("Broken Dice Garper")
	BrokDiceGarper = {
		SPEED = 1.0,
		RANGE = 200,
	}
	function mod:onBrokDiceGarper(entity)
		local sprite = entity:GetSprite()
		sprite:PlayOverlay("Head", false)
		entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
		local target = entity:GetPlayerTarget()
		local data = entity:GetData()
		if data.GridCountdown == nil then
			data.GridCountdown = 0
		end
	
		if entity.State == 0 then
			if entity:IsFrame(8 / BrokDiceGarper.SPEED, 0) then
				entity.Pathfinder:MoveRandomly(false)
			end
			if (entity.Position - target.Position):Length() < BrokDiceGarper.RANGE then
				entity.State = 2
			end
		elseif entity.State == 2 then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
				entity.Pathfinder:FindGridPath(target.Position, BrokDiceGarper.SPEED, 1.4, false)
				if data.GridCountdown <= 0 then
					data.GridCountdown = 30
				else
					data.GridCountdown = data.GridCountdown - 1
				end
			else
				entity.Velocity = (target.Position - entity.Position):Normalized() * BrokDiceGarper.SPEED * 6
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.onBrokDiceGarper, EntityType.ENTITY_BROKEDICEGARPER)
	
	function mod:LazerColor(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
				player.LaserColor = Color(0, 0, 0, 1, 215, 95, 25)
			end
		end
	end
	
	local tech1Flags = {
		TearFlags.TEAR_SLOW,
		TearFlags.TEAR_HOMING,
		TearFlags.TEAR_POISON,
		TearFlags.TEAR_SPLIT,
		TearFlags.TEAR_FREEZE,
		TearFlags.TEAR_GROW,
		TearFlags.TEAR_BOOMERANG,
		TearFlags.TEAR_PERSISTENT,
		TearFlags.TEAR_WIGGLE,
		TearFlags.TEAR_MULLIGAN,
		TearFlags.TEAR_EXPLOSIVE,
		TearFlags.TEAR_CONFUSION,
		TearFlags.TEAR_CHARM,
		TearFlags.TEAR_ORBIT,
		TearFlags.TEAR_WAIT,
		TearFlags.TEAR_QUADSPLIT,
		TearFlags.TEAR_BOUNCE,
		TearFlags.TEAR_FEAR,
		TearFlags.TEAR_SHRINK,
		TearFlags.TEAR_BURN,
		TearFlags.TEAR_KNOCKBACK,
		TearFlags.TEAR_SPIRAL,
		TearFlags.TEAR_SQUARE,
		TearFlags.TEAR_GLOW,
		TearFlags.TEAR_GISH,
		TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP,
		TearFlags.TEAR_STICKY,
		TearFlags.TEAR_CONTINUUM,
		TearFlags.TEAR_LIGHT_FROM_HEAVEN,
		TearFlags.TEAR_TRACTOR_BEAM,
		TearFlags.TEAR_BIG_SPIRAL,
		TearFlags.TEAR_BOOGER,
		TearFlags.TEAR_ACID,
		TearFlags.TEAR_BONE,
		TearFlags.TEAR_JACOBS,
		TearFlags.TEAR_LASER,
		TearFlags.TEAR_POP,
		TearFlags.TEAR_ABSORB,
		TearFlags.TEAR_HYDROBOUNCE,
		TearFlags.TEAR_BURSTSPLIT,
		TearFlags.TEAR_PUNCH,
		TearFlags.TEAR_ORBIT_ADVANCED,
		TearFlags.TEAR_TURN_HORIZONTAL,
		TearFlags.TEAR_ECOLI,
		TearFlags.TEAR_RIFT,
		TearFlags.TEAR_TELEPORT,
	}
	
	function mod:tearFire_Diltech(t)
		local d = t:GetData()
		local player = t.SpawnerEntity
			and (t.SpawnerEntity:ToPlayer() or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
			local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
			local chance = rng:RandomInt(50)
			if chance >= 25 then
				local lazer = player:FireTechLaser(t.Position, 0, t.Velocity, false, true, player)
			else
				local lazer = player:FireTechXLaser(t.Position, t.Velocity, 50, player)
			end
	
			t:Remove()
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.LazerColor, CacheFlag.CACHE_TEARCOLOR)
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.tearFire_Diltech)
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		for i = 0, game:GetNumPlayers() do
			local p = Isaac.GetPlayer(i)
			p:GetData().TBOIREP_Minus_DilliriumTech = p:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
				:RandomInt(2) + 1
		end
	end)
	
	local laserTypes = {
		[0] = CollectibleType.COLLECTIBLE_TECH_X,
		[1] = CollectibleType.COLLECTIBLE_BRIMSTONE,
		[2] = CollectibleType.COLLECTIBLE_TECHNOLOGY,
		[3] = CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
		[4] = CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
		[5] = CollectibleType.COLLECTIBLE_TECH_5,
	}
	
	function mod:deliriousTechLaserSwitch(player)
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) and game:GetFrameCount() % 30 == 0 then
			local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
			local data = mod:repmGetPData(player)
			if rng:RandomInt(100) > 94 or data.DelirousTechState == nil then
				if data.DelirousTechState ~= nil then
					hiddenItemManager:Remove(player, data.DelirousTechState, hiddenItemManager.kDefaultGroup)
				end
				local num = rng:RandomInt(6)
				local selectedNum = laserTypes[num]
				data.DelirousTechState = selectedNum
				hiddenItemManager:Add(player, selectedNum)
				if not player:HasCollectible(selectedNum, true) then
					local costConfig = config:GetCollectible(selectedNum)
					player:RemoveCostume(costConfig)
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.deliriousTechLaserSwitch)
	
	function mod:checkLaser_DelTech(laser)
		local player = mod:getPlayerFromKnifeLaser(laser)
		local pdata = player and mod:repmGetPData(player)
		local data = laser:GetData()
		local var = laser.Variant
		local subt = laser.SubType
		local ignoreLaserVar = ((var == 1 and subt == 3) or var == 5 or var == 12)
		if laser.Type == EntityType.ENTITY_EFFECT then
			ignoreLaserVar = false
		end
	
		if player and not ignoreLaserVar then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH) then
				--local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
				--if laser.Type == EntityType.ENTITY_EFFECT and laser.Variant == EffectVariant.BRIMSTONE_SWIRL then
				--end
				data.RandomizeDelLaserEffect = true
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, mod.checkLaser_DelTech)
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.checkLaser_DelTech, EffectVariant.BRIMSTONE_BALL)
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.checkLaser_DelTech, EffectVariant.BRIMSTONE_SWIRL)
	
	function mod:updateLasersPlayer_DelTech(player)
		local lasers = Isaac.FindByType(EntityType.ENTITY_LASER)
		local rng = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH)
		for i = 1, #lasers do
			local laser = lasers[i]
			if laser:GetData().RandomizeDelLaserEffect == true then
				laser:GetData().RandomizeDelLaserEffect = false
				laser:ToLaser():AddTearFlags(tech1Flags[rng:RandomInt(#tech1Flags) + 1])
			end
		end
	
		--local brimballs = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_BALL)
		--for i=1, #brimballs do
		--local brimball = brimballs[i]
		--if brimball:GetData().RandomizeDelLaserEffect == true then
		--brimball:GetData().RandomizeDelLaserEffect = false
		--brimball:AddTearFlags(tech1Flags[rng:RandomInt(#tech1Flags)+1])
		--end
		--end
	
		--local brimswirls = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL)
		--for i=1, #brimswirls do
		--local brimswirl = brimswirls[i]
		--if brimswirl:GetData().RandomizeDelLaserEffect == true then
		--brimswirl:GetData().RandomizeDelLaserEffect = false
		--brimswirl:AddTearFlags(tech1Flags[rng:RandomInt(#tech1Flags)+1])
		--end
		--end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.updateLasersPlayer_DelTech)
	
	function mod:tearUpdate(tear)
		if tear:GetData().IsVacum and tear:HasTearFlags(TearFlags.TEAR_BOOMERANG) and tear.SpawnerEntity then
			local pow = tear.SpawnerEntity.Position:Distance(tear.Position) / 10
			local newvel = (tear.SpawnerEntity.Position - tear.Position):Resized(pow)
			tear.Velocity = tear.Velocity * 0.9 + newvel * 0.1
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.tearUpdate)
	
	function mod:tearFire(t)
		local d = t:GetData()
		local player = t.SpawnerEntity
			and (t.SpawnerEntity:ToPlayer() or t.SpawnerEntity:ToFamiliar() and t.SpawnerEntity.Player)
		--[[if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM) then 
			d.IsVacum = true
		
			   if math.random(1, 5) == 4 then
			   t:AddTearFlags(TearFlags.TEAR_BOOMERANG)
			   t:ChangeVariant(TearVariant.DARK_MATTER)
			end    
		end ]]
	end
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.tearFire)
	
	--[[function mod:updateCache_Vacuum(_player, cacheFlag)
		local player = Isaac.GetPlayer(0) 
		
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM) then 
				player.MaxFireDelay = tearsUp(player.MaxFireDelay, 0.5)
			end
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM) then
				player.TearRange = player.TearRange + 70 * 3;
			end        
		end
	end    
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Vacuum)]]
	
	local DiliriumEyeLastActivateFrame = 0
	
	local player = Isaac.GetPlayer(0)
	local PixelatedCubeBabiesList = {}
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
		-- babies list for pixelated cube
		local config = Isaac.GetItemConfig()
		if #PixelatedCubeBabiesList == 0 then
			for id = 1, config:GetCollectibles().Size do
				local item = config:GetCollectible(id)
				if item and item:HasTags(ItemConfig.TAG_MONSTER_MANUAL) then
					PixelatedCubeBabiesList[#PixelatedCubeBabiesList + 1] = id
				end
			end
		end
	end)
	
	function mod:onUpdate_Rock()
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_BEEG_MINUS) then
				player:Kill()
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate_Rock)
	
	function mod:PurpleStrawUse(itemID, rng, player)
		-- purple straw
		for i, entity in ipairs(Isaac.GetRoomEntities()) do
			local Number = math.random(1, 5)
			if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() and entity:IsEnemy() then
				if Number == 1 then
					entity:AddPoison(EntityRef(player), 60, 3.5)
				end
				if Number == 2 then
					entity:AddConfusion(EntityRef(player), 60, false)
				end
				if Number == 3 then
					entity:AddCharmed(EntityRef(player), 60)
				end
				if Number == 4 then
					entity:AddFear(EntityRef(player), 60, 3.5)
				end
				if Number == 5 then
					entity:AddSlowing(EntityRef(player), 60, 3, Color.Default)
				end
			end
		end
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PurpleStrawUse, mod.RepmTypes.COLLECTIBLE_PINK_STRAW)
	
	function mod:PixelatedCubeUse(itemID, rng, player)
		-- pixelated cube
		local BabyNumber = PixelatedCubeBabiesList[math.random(1, 30)]
		player:GetEffects():AddCollectibleEffect(BabyNumber, false)
		local BabyNumber = PixelatedCubeBabiesList[math.random(1, 30)]
		player:GetEffects():AddCollectibleEffect(BabyNumber, false)
		local BabyNumber = PixelatedCubeBabiesList[math.random(1, 30)]
		player:GetEffects():AddCollectibleEffect(BabyNumber, false)
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PixelatedCubeUse, mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE)
	
	function mod:OnRoomClear(rng)
		--110V double charge part
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_110V) then
				local maxCharge = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(0)).MaxCharges
				if player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) ~= maxCharge then
					player:AddActiveCharge(1, ActiveSlot.SLOT_PRIMARY)
				end
			end
		end
	end
	mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, mod.OnRoomClear)
	
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_,col, rng, player)
		--110V damage on using active part
		if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_110V) then
			local maxCharge = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(0)).MaxCharges
			if maxCharge == 2 or maxCharge == 3 then
				player:TakeDamage(
					1,
					DamageFlag.DAMAGE_NO_PENALTIES
						| DamageFlag.DAMAGE_NOKILL
						| DamageFlag.DAMAGE_INVINCIBLE
						| DamageFlag.DAMAGE_NO_MODIFIERS,
					EntityRef(player),
					0
				)
			end
			if maxCharge == 4 then
				player:TakeDamage(
					2,
					DamageFlag.DAMAGE_NO_PENALTIES
						| DamageFlag.DAMAGE_NOKILL
						| DamageFlag.DAMAGE_INVINCIBLE
						| DamageFlag.DAMAGE_NO_MODIFIERS,
					EntityRef(player),
					0
				)
			end
			if maxCharge == 6 then
				player:TakeDamage(
					3,
					DamageFlag.DAMAGE_NO_PENALTIES
						| DamageFlag.DAMAGE_NOKILL
						| DamageFlag.DAMAGE_INVINCIBLE
						| DamageFlag.DAMAGE_NO_MODIFIERS,
					EntityRef(player),
					0
				)
			end
			if maxCharge == 12 then
				player:TakeDamage(
					5,
					DamageFlag.DAMAGE_NO_PENALTIES
						| DamageFlag.DAMAGE_NOKILL
						| DamageFlag.DAMAGE_INVINCIBLE
						| DamageFlag.DAMAGE_NO_MODIFIERS,
					EntityRef(player),
					0
				)
			end
		end
	end)
	
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
		if game:GetFrameCount() > DiliriumEyeLastActivateFrame + 1 then
			local player, familiarTear = mod:GetPlayerFromTear(tear)
			if not player then return end
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE) and not familiarTear then
				local DelEyeVariant = math.random(1, 5)
				DiliriumEyeLastActivateFrame = game:GetFrameCount()
				if DelEyeVariant == 1 then
					if player:GetFireDirection() == 0 then
						local ShootDirection = Vector(
							-math.cos(0) * player.ShotSpeed * 10,
							-math.sin(0) * player.ShotSpeed * 10
						)
						player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1)
						tear:Remove()
					elseif player:GetFireDirection() == 1 then
						local ShootDirection = Vector(
							math.sin(0) * player.ShotSpeed * 10,
							-math.cos(0) * player.ShotSpeed * 10
						)
						player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1)
						tear:Remove()
					elseif player:GetFireDirection() == 2 then
						local ShootDirection = Vector(
							math.cos(0) * player.ShotSpeed * 10,
							-math.sin(0) * player.ShotSpeed * 10
						)
						player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1)
						tear:Remove()
					elseif player:GetFireDirection() == 3 then
						local ShootDirection = Vector(
							math.sin(0) * player.ShotSpeed * 10,
							math.cos(0) * player.ShotSpeed * 10
						)
						player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1)
						tear:Remove()
					end
				elseif DelEyeVariant == 2 then
					if player:GetFireDirection() == 0 then
						local ShootDirection = Vector(
									-math.cos(math.rad(7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								local ShootDirection = Vector(
									-math.cos(math.rad(-7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(-7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								tear:Remove()
					elseif player:GetFireDirection() == 1 then
						local ShootDirection = Vector(
									math.sin(math.rad(7.5)) * player.ShotSpeed * 10,
									-math.cos(math.rad(7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								local ShootDirection = Vector(
									math.sin(math.rad(-7.5)) * player.ShotSpeed * 10,
									-math.cos(math.rad(-7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								tear:Remove()
					elseif player:GetFireDirection() == 2 then
						local ShootDirection = Vector(
									math.cos(math.rad(7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								local ShootDirection = Vector(
									math.cos(math.rad(-7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(-7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								tear:Remove()
					elseif player:GetFireDirection() == 3 then
						local ShootDirection = Vector(
									math.sin(math.rad(7.5)) * player.ShotSpeed * 10,
									math.cos(math.rad(7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								local ShootDirection = Vector(
									math.sin(math.rad(-7.5)) * player.ShotSpeed * 10,
									math.cos(math.rad(-7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/2)
								tear:Remove()
					end
				elseif DelEyeVariant == 3 then
					if player:GetFireDirection() == 0 then
						for i = -1, 1 do
							if i ~= 0 then
								local ShootDirection = Vector(
									-math.cos(math.rad(15 * i)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
							else
								local ShootDirection = Vector(
									-math.cos(0) * player.ShotSpeed * 10,
									-math.sin(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 1 then
						for i = -1, 1 do
							if i ~= 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i)) * player.ShotSpeed * 10,
									-math.cos(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
							else
								local ShootDirection = Vector(
									math.sin(0) * player.ShotSpeed * 10,
									-math.cos(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 2 then
						for i = -1, 1 do
							if i ~= 0 then
								local ShootDirection = Vector(
									math.cos(math.rad(15 * i)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
							else
								local ShootDirection = Vector(
									math.cos(0) * player.ShotSpeed * 10,
									-math.sin(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 3 then
						for i = -1, 1 do
							if i ~= 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i)) * player.ShotSpeed * 10,
									math.cos(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
							else
								local ShootDirection = Vector(
									math.sin(0) * player.ShotSpeed * 10,
									math.cos(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/3)
								tear:Remove()
							end
						end
					end
				elseif DelEyeVariant == 4 then
					if player:GetFireDirection() == 0 then
						for i = -2, 2 do
							if i < 0 then
								local ShootDirection = Vector(
									-math.cos(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							elseif i > 0 then
								local ShootDirection = Vector(
									-math.cos(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							else
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 1 then
						for i = -2, 2 do
							if i < 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10,
									-math.cos(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							elseif i > 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10,
									-math.cos(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							else
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 2 then
						for i = -2, 2 do
							if i < 0 then
								local ShootDirection = Vector(
									math.cos(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							elseif i > 0 then
								local ShootDirection = Vector(
									math.cos(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							else
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 3 then
						for i = -2, 2 do
							if i < 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10,
									math.cos(math.rad(15 * i + 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							elseif i > 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10,
									math.cos(math.rad(15 * i - 7.5)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/4)
							else
								tear:Remove()
							end
						end
					end
				elseif DelEyeVariant == 5 then
					if player:GetFireDirection() == 0 then
						for i = -2, 2 do
							if i ~= 0 then
								local ShootDirection = Vector(
									-math.cos(math.rad(15 * i)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
							else
								local ShootDirection = Vector(
									-math.cos(0) * player.ShotSpeed * 10,
									-math.sin(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 1 then
						for i = -2, 2 do
							if i ~= 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i)) * player.ShotSpeed * 10,
									-math.cos(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
							else
								local ShootDirection = Vector(
									math.sin(0) * player.ShotSpeed * 10,
									-math.cos(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 2 then
						for i = -2, 2 do
							if i ~= 0 then
								local ShootDirection = Vector(
									math.cos(math.rad(15 * i)) * player.ShotSpeed * 10,
									-math.sin(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
							else
								local ShootDirection = Vector(
									math.cos(0) * player.ShotSpeed * 10,
									-math.sin(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
								tear:Remove()
							end
						end
					elseif player:GetFireDirection() == 3 then
						for i = -2, 2 do
							if i ~= 0 then
								local ShootDirection = Vector(
									math.sin(math.rad(15 * i)) * player.ShotSpeed * 10,
									math.cos(math.rad(15 * i)) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
							else
								local ShootDirection = Vector(
									math.sin(0) * player.ShotSpeed * 10,
									math.cos(0) * player.ShotSpeed * 10
								)
								player:FireTear(player.Position, ShootDirection, true, true, false, player, 1.1/5)
								tear:Remove()
							end
						end
					end
				end
			end
		end
	end)
	
	function mod:updateCache_FlowTea(player, cacheFlag)
		
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(mod.RepmTypes.Collectible_FLOWER_TEA) then
				player.Damage = player.Damage + 0.60
			end
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
			if player:HasCollectible(mod.RepmTypes.Collectible_FLOWER_TEA) then
				player.TearRange = player.TearRange + 40 * 0.5
			end
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			if player:HasCollectible(mod.RepmTypes.Collectible_FLOWER_TEA) then
				player.ShotSpeed = player.ShotSpeed - 0.20
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_FlowTea)
	
	function mod:onUpdate_Otmichka()
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			local spawnpos = game:GetRoom():FindFreeTilePosition(game:GetRoom():GetCenterPos(), 400)
	
			if player:HasCollectible(mod.RepmTypes.Collectible_HOLY_OTMICHKA) then
				if math.random(1, 7) == 5 then
					Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_ETERNALCHEST,
						0,
						spawnpos,--Vector(320, 320),
						Vector(0, 0),
						nil
					)
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onUpdate_Otmichka)
	
	function mod:updateCache_Kozol(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.Damage = player.Damage + 1
			end
		end
		if cacheFlag == CacheFlag.CACHE_FLYING then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.CanFly = true
			end
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.MaxFireDelay = tearsUp(player.MaxFireDelay, 2)
			end
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.ShotSpeed = player.ShotSpeed - 0.1
			end
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.Luck = player.Luck + 5
			end
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.MoveSpeed = player.MoveSpeed + 0.30
			end
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			if player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Kozol)
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, flag)
		if
			ent:ToPlayer()
			and ent:ToPlayer():HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH)
			and flag & DamageFlag.DAMAGE_NO_PENALTIES == 0
		then
			ent:Kill()
		end
	end, 1)
	
	function mod:updateCache_Buter(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			if player:HasCollectible(mod.RepmTypes.Collectible_SANDWICH) then
				player.Damage = player.Damage + 0.5
			end
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player:HasCollectible(mod.RepmTypes.Collectible_SANDWICH) then
				player.MaxFireDelay = tearsUp(player.MaxFireDelay, 0.35)
			end
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			if player:HasCollectible(mod.RepmTypes.Collectible_SANDWICH) then
				if math.random(1, 5) == 4 then
					player.TearFlags = player.TearFlags | TearFlags.TEAR_BAIT
					if math.random(1, 5) == 3 then
						player.TearFlags = player.TearFlags | TearFlags.TEAR_POISON
					end
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Buter)
	
	local Minusaac = { -- Change Minusaac everywhere to match your character. No spaces!
		DAMAGE = 0.7, -- These are all relative to Isaac's base stats.
		SPEED = 0.2,
		SHOTSPEED = -2.90,
		TEARHEIGHT = -1,
		TEARFALLINGSPEED = 3,
		LUCK = 1,
		FLYING = false,
		TEARFLAG = 0, -- 0 is default
		TEARCOLOR = Color(1.0, 0.2, 0.2, 1.0, 1, 0, -0.5), -- Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0) is default
	}
	
	function mod:onCache_Minus(player, cacheFlag) -- I do mean everywhere!
		if player:GetName() == "Minusaac" then -- Especially here!
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + Minusaac.DAMAGE
			end
			if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + Minusaac.SHOTSPEED
			end
			if cacheFlag == CacheFlag.CACHE_RANGE then
				player.TearHeight = player.TearHeight - Minusaac.TEARHEIGHT
				player.TearFallingSpeed = player.TearFallingSpeed + Minusaac.TEARFALLINGSPEED
			end
			if cacheFlag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + Minusaac.SPEED
			end
			if cacheFlag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck + Minusaac.LUCK
			end
			if cacheFlag == CacheFlag.CACHE_FLYING and Minusaac.FLYING then
				player.CanFly = true
			end
			if cacheFlag == CacheFlag.CACHE_TEARFLAG then
				player.TearFlags = player.TearFlags | Minusaac.TEARFLAG
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache_Minus)
	
	function mod:AlterTearColor(tear)
		local player = mod:GetPlayerFromTear(tear)
		if player and player:GetName() == "Minusaac" and tear.FrameCount == 0 then
			tear:GetSprite().Color:SetColorize(1, 0, 0, 1)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.AlterTearColor)
	
	function AddFlag(...)
		local ToReturn = 0
		for _, a in pairs({ ... }) do
			ToReturn = ToReturn + (1 << a)
		end
		return ToReturn
	end
	
	local Minusaac = Isaac.GetPlayerTypeByName("Minusaac")
	---@param Player EntityPlayer
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, Player)
		if Player:GetPlayerType() ~= Minusaac then
			return
		end
		local pdata = mod:repmGetPData(Player)
	end)
	
	--if player:GetName() == "Minusaac" then
	mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
		if player:GetName() == "Minusaac" then
			player:AddCollectible(mod.RepmTypes.Collectible_BLOODY_NEGATIVE)
		end
	end)
	
	---@param Player EntityPlayer
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, Player)
		if Player:GetPlayerType() ~= Minusaac then
			return
		end
		if Player:GetEffectiveMaxHearts() > 2 or (Player:GetEffectiveMaxHearts() > 0 and Player:GetSoulHearts() > 0) then
			Player:AddMaxHearts(-2)
		elseif Player:GetSoulHearts() > 4 or (Player:GetEffectiveMaxHearts() > 0 and Player:GetSoulHearts() >= 4) then
			Player:AddSoulHearts(-4)
		elseif Player:GetBlackHearts() > 4 or (Player:GetEffectiveMaxHearts() > 0 and Player:GetBlackHearts() >= 4) then
			Player:AddBlackHearts(-4)
		else
			return
		end
		for i = 1, 8 do
			Isaac.Spawn(
				EntityType.ENTITY_EFFECT,
				EffectVariant.BLOOD_PARTICLE,
				0,
				Player.Position,
				Vector(0, math.random(0, 5)):Rotated(math.random(360)),
				nil
			)
			Player:SetMinDamageCooldown(90)
		end
		local Data = mod:repmGetPData(Player)
		local birthNum = Player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		Data.Bloody_MoveSpeed = (Data.Bloody_MoveSpeed or 0) + 0.15 + (0.3 * birthNum)
		Data.Bloody_Damage = (Data.Bloody_Damage or 0) + 0.2 + (0.3 * birthNum)
		Data.Bloody_MaxFireDelay = math.min((Data.Bloody_MaxFireDelay or 0) + 0.75 + (0.3 * birthNum), 5)
		Data.Bloody_TearRange = (Data.Bloody_TearRange or 0) + 8 + (24 * birthNum)
		Player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
		return true
	end, mod.RepmTypes.Collectible_BLOODY_NEGATIVE)
	
	---@param Player EntityPlayer
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, Player, Cache)
		if Player:GetPlayerType() ~= Minusaac then
			return
		end
		local Data = mod:repmGetPData(Player)
		if Cache == CacheFlag.CACHE_SPEED then
			Player.MoveSpeed = Player.MoveSpeed + (Data.Bloody_MoveSpeed or 0)
		end
		if Cache == CacheFlag.CACHE_DAMAGE then
			Player.Damage = Player.Damage + (Data.Bloody_Damage or 0)
		end
		if Cache == CacheFlag.CACHE_FIREDELAY then
			Player.MaxFireDelay = tearsUp(player.MaxFireDelay, (Data.Bloody_MaxFireDelay or 0))
		end
		if Cache == CacheFlag.CACHE_RANGE then
			Player.TearRange = Player.TearRange + (Data.Bloody_TearRange or 0)
		end
	end)
	
	---@type ModReference
	---@param Entity Entity
	---@param DamageFlags DamageFlag
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, Entity, _, DamageFlags)
		---@type EntityPlayer
		local Player = Entity:ToPlayer()
		if
			DamageFlags == AddFlag(7, 28)
			or DamageFlags == AddFlag(16, 28)
			or DamageFlags == AddFlag(5, 13)
			or DamageFlags == AddFlag(5, 21)
			or DamageFlags == AddFlag(5, 13, 18)
			or DamageFlags == AddFlag(2, 28, 30)
			or DamageFlags == AddFlag(2, 28, 30)
			or DamageFlags == AddFlag(5)
			or Player:GetPlayerType() ~= Minusaac
			or Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		then
			return
		end
		local Data = mod:repmGetPData(Player)
		Data.Bloody_MoveSpeed = (Data.Bloody_MoveSpeed or 0) - 0.1
		Data.Bloody_Damage = (Data.Bloody_Damage or 0) - 0.15
		Data.Bloody_MaxFireDelay = (Data.Bloody_MaxFireDelay or 0) - 0.65
		Data.Bloody_TearRange = (Data.Bloody_TearRange or 0) - 6
		Player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	end, EntityType.ENTITY_PLAYER)
	
	---@param Player EntityPlayer
	---@param RNG RNG
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, RNG, Player)
		local Flags = (1 << 29) + (1 << 8) + (1 << 37) + (1 << 59) + (1 << 19)
		if RNG:RandomInt(2) == 1 then
			for _ = 1, 2 do
				Isaac.Spawn(
					EntityType.ENTITY_BONY,
					0,
					0,
					Player.Position + Vector(0, 5):Rotated(math.random(360)),
					Vector(0, 0),
					Player
				)
					:ToNPC()
					:AddEntityFlags(Flags)
			end
		else
			for _ = 1, 2 do
				Isaac.Spawn(
					EntityType.ENTITY_BOOMFLY,
					4,
					0,
					Player.Position + Vector(0, 5):Rotated(math.random(360)),
					Vector(0, 0),
					Player
				)
					:ToNPC()
					:AddEntityFlags(Flags)
			end
		end
		SFXManager():Play(8)
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end, mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER)
	
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		---@type EntityPlayer Player
		local Player = Isaac.GetPlayer(0)
		---@type Entity Entity
		for _, Entity in pairs(Isaac.GetRoomEntities()) do
			if Entity.Type == EntityType.ENTITY_BONY or Entity.Type == EntityType.ENTITY_BOOMFLY then
				if Entity:HasEntityFlags((1 << 29) + (1 << 8) + (1 << 37) + (1 << 59) + (1 << 19)) then
					Entity.Position = Player.Position
				end
			end
		end
	end)
	
	local Amount = 0
	function mod:onShaderParams(shaderName)
		if shaderName == "RandomColors" then
			for i = 0, game:GetNumPlayers() - 1 do
				Amount = Amount * 0.9 + (Isaac.GetPlayer(i):HasCollectible(mod.RepmTypes.COLLECTIBLE_VHS) and 0 or 0.1)
			end
			local params = {
				Amount = Amount,
			}
			return params
		end
	end
	
	function mod:updateCache(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_SPEED then
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_VHS) then
				player.MoveSpeed = player.MoveSpeed + 0.4
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.onShaderParams)
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache)
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
		if tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() then
			if tear.SpawnerEntity:ToPlayer():HasCollectible(mod.RepmTypes.COLLECTIBLE_VHS) then
				tear.CollisionDamage = tear.CollisionDamage + tear:GetDropRNG():RandomInt(4)
			end
		end
	end)
	
	local music = MusicManager()
	
	Music.MUSIC_MAESTRO = Isaac.GetMusicIdByName("BFG")
	
	function mod:onCache(player, flag)
		if flag == CacheFlag.CACHE_TEARFLAG and player:HasTrinket(mod.RepmTypes.TRINKET_HAMMER) then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_ACID
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
	
	local Thumper = {}
	Thumper.type = Isaac.GetEntityTypeByName("Thumper")
	Thumper.variant = Isaac.GetEntityVariantByName("Thumper")
	Thumper.regularProjectileVelocity = 9
	Thumper.regularProjectileSpread = 15
	Thumper.shotSpread = 45
	Thumper.shotSpeed = 1 --6.5
	Thumper.shotDistance = -10
	
	function Thumper.OnShooting(_, shot)
		if shot.SpawnerType == Thumper.type and shot.SpawnerVariant == Thumper.variant then
			shot.ProjectileFlags = ProjectileFlags.SMART
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, Thumper.OnShooting)
	
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		for i = 1, game:GetNumPlayers() do
			---@type EntityPlayer
			local Player = Isaac.GetPlayer(i - 1)
			if Player:HasCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH) then
				Player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
			end
			---@type {GasesCountDown: number}
			local Data = Player:GetData()
			if Player:HasCollectible(mod.RepmTypes.COLLECTIBLE_ROT) then
				Data.GasesCountDown = 240
			end
		end
	end)
	---@param Player EntityPlayer
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, Player)
		---@type {GasesCountDown: number}
		local Data = Player:GetData()
		if Data.GasesCountDown ~= nil and Data.GasesCountDown > 0 and not game:GetLevel():GetCurrentRoom():IsClear() then
			if Data.GasesCountDown % 10 == 0 then
				---@type EntityEffect
				local Effect = Isaac.Spawn(
					EntityType.ENTITY_EFFECT,
					EffectVariant.SMOKE_CLOUD,
					0,
					Player.Position,
					Vector(0, 0),
					Player
				):ToEffect()
				Effect:SetDamageSource(EntityType.ENTITY_PLAYER)
				Effect:SetTimeout(100)
			end
			Data.GasesCountDown = Data.GasesCountDown - 1
		end
	end)
	
	function AddFlag(...)
		local ToReturn = 0
		for _, a in pairs({ ... }) do
			ToReturn = ToReturn + (1 << a)
		end
		return ToReturn
	end
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, Player, Cache)
		local Data = mod:repmGetPData(Player)
		if Data == nil or Data.MinusShard == nil then
			return
		end
		Data = Data.MinusShard
		if Cache == CacheFlag.CACHE_SPEED then
			Player.MoveSpeed = Player.MoveSpeed + Data.MoveSpeed
		end
		if Cache == CacheFlag.CACHE_DAMAGE then
			Player.Damage = Player.Damage + Data.Damage
		end
		if Cache == CacheFlag.CACHE_FIREDELAY then
			local currentTears = 30 / (Player.MaxFireDelay + 1)
			local newTears = math.max(math.min(0.1, currentTears), currentTears + Data.MaxFireDelay)
			Player.MaxFireDelay = (30 / newTears) - 1
		end
		if Cache == CacheFlag.CACHE_RANGE then
			Player.TearRange = Player.TearRange + Data.TearRange
		end
	end)
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, Entity, _, DamageFlags)
		if
			DamageFlags & DamageFlag.DAMAGE_NO_PENALTIES == DamageFlag.DAMAGE_NO_PENALTIES
			or DamageFlags & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE
			or DamageFlags & DamageFlag.DAMAGE_RED_HEARTS == DamageFlag.DAMAGE_RED_HEARTS
		then
			return
		end
		local Player = Entity:ToPlayer()
		local Data = mod:repmGetPData(Player)
		if
			Data == nil
			or (Data ~= nil and Data.MinusShard == nil)
			or (Data ~= nil and Data.MinusShard ~= nil and Data.MinusShard.Rooms <= 0)
		then
			return
		end
		Player:SetColor(Color(1, 1, 1, 1, 1, 0, 0), 15, 0, true, true)
		Data.MinusShard.Sprite:Play("Damaged", true)
		Data.MinusShard.Rooms = Data.MinusShard.Rooms - 1
		local Effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 97, 0, Player.Position, Vector(0, 0), Player)
		Effect.Color = Color(0.75, 0, 0, 1)
		Effect.SpriteScale = Vector(2, 2)
		SFXManager():Play(175, 1.25, 0, false, math.random(155, 175) / 100)
	end, EntityType.ENTITY_PLAYER)
	
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
		for i = 1, game:GetNumPlayers() do
			local Player = Isaac.GetPlayer(i - 1)
			local Data = mod:repmGetPData(Player)
			if Data ~= nil and Data.MinusShard ~= nil and Data.MinusShard.Rooms > 0 then
				SFXManager():Play(268, 1, 0, false, 1.5)
				Player:SetColor(Color(1, 1, 1, 1, 0, 1, 0), 15, 0, true, true)
				Data = Data.MinusShard
				Data.Rooms = Data.Rooms - 1
				Data.MoveSpeed = Data.MoveSpeed + 0.1
				Data.Damage = Data.Damage + 0.85
				Data.MaxFireDelay = math.min(Data.MaxFireDelay + 1.1, 4)
				Data.TearRange = Data.TearRange + 25
				Player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
			end
		end
	end)
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function()
		for i = 1, game:GetNumPlayers() do
			local Player = Isaac.GetPlayer(i - 1)
			local Data = mod:repmGetPData(Player)
			if Data ~= nil and (Data ~= nil and Data.MinusShard ~= nil) and Data.MinusShard.Sprite ~= nil then
				Data.MinusShard.Sprite:Render(Isaac.WorldToScreen(Player.Position))
				Data.MinusShard.Sprite:Update()
				if Data.MinusShard.Sprite:IsFinished("Fade") then
					Data.MinusShard.Sprite = nil
				end
				if Data.MinusShard.Sprite ~= nil then
					if Data.MinusShard.Sprite:IsFinished("Damaged") then
						Data.MinusShard.Sprite:Play("Idle", true)
					end
					if not Data.MinusShard.Sprite:IsPlaying("Fade") and Data.MinusShard.Rooms <= 0 then
						Data.MinusShard.Sprite:Play("Fade", true)
					end
				end
			end
		end
	end)
	---@param Player EntityPlayer
	mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, Player)
		local Data = mod:repmGetPData(Player)
		if Data.MinusShard == nil then
			Data.MinusShard = {
				Rooms = 0,
				Damage = 0,
				MoveSpeed = 0,
				MaxFireDelay = 0,
				TearRange = 0,
				Sprite = Sprite(),
			}
		end
		Data.MinusShard.Sprite = Sprite()
		Data.MinusShard.Sprite:Load("gfx/MinusStatus.anm2", true)
		Data.MinusShard.Sprite:Play("Idle", true)
	
		Data.MinusShard.Rooms = Data.MinusShard.Rooms + 2
		local Effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, 16, 1, Player.Position, Vector(0, 0), Player)
		Effect.Color = Color(0.75, 0, 0, 0.5)
		for _ = 1, 12 do
			local Effect = Isaac.Spawn(
				EntityType.ENTITY_EFFECT,
				35,
				1,
				Player.Position,
				Vector(0, math.random(3, 9)):Rotated(math.random(360)),
				Player
			)
			Effect.Color = Color(0.75, 0, 0, 1)
			Effect.SpriteScale = Vector(0.75, 0.75)
		end
		Player:SetColor(Color(1, 1, 1, 1, 1, 0, 0), 60, 0, true, true)
		SFXManager():Play(33, 1, 0, false, 1.5)
	
		Data.MinusShard.MoveSpeed = Data.MinusShard.MoveSpeed - 0.1
		Data.MinusShard.Damage = Data.MinusShard.Damage - 0.75
		Data.MinusShard.MaxFireDelay = Data.MinusShard.MaxFireDelay - 1
		Data.MinusShard.TearRange = Data.MinusShard.TearRange - 25
		Player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
	end, Isaac.GetCardIdByName("MinusShard"))
	
	--------------------------------------------------------------
	--Frozen Flies
	--------------------------------------------------------------
	
	local tsunFlyVar = Isaac.GetEntityVariantByName("Tsun_Fly")
	local tsunOrbitDistance = Vector(30.0, 30.0)
	local tsunOrbitLayer = 127
	local tsunOrbitSpeed = 0.02
	local tsunCenterOffset = Vector(0.0, 0.0)
	local whiteColor = Color(1, 1, 1, 1, 0, 0, 0)
	whiteColor:SetColorize(1, 1, 1, 1)
	whiteColor:SetTint(20, 20, 20, 2)
	
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cache_flag)
		if cache_flag == CacheFlag.CACHE_FAMILIARS then
			local familiar_count = player:GetCollectibleNum(mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY) * 2
			player:CheckFamiliar(
				tsunFlyVar,
				familiar_count,
				player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY)
			)
		end
	end)
	
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, orbital)
		orbital.OrbitDistance = tsunOrbitDistance
		orbital.OrbitSpeed = tsunOrbitSpeed
		orbital:AddToOrbit(tsunOrbitLayer)
	end, tsunFlyVar)
	
	mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, familiar, collider, low)
		if collider:IsVulnerableEnemy() then
			local player = familiar.Player
			if player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				collider:TakeDamage(2, 0, EntityRef(familiar), 1)
			else
				collider:TakeDamage(1, 0, EntityRef(familiar), 1)
			end
		elseif collider:ToProjectile() ~= nil then
			local loopInt = 1
			local player = familiar.Player
			if player and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				loopInt = 2
			end
			for i = 1, loopInt, 1 do
				local tear = familiar:FireProjectile(collider.Velocity * Vector(-1, -1))
				tear.Velocity = collider.Velocity * Vector(-1, -1)
				tear.Position = collider.Position
				tear.CollisionDamage = collider.CollisionDamage
				--tear:AddTearFlags(TearFlags.TEAR_ICE)
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				tear:GetData().RepMinusWillFreeze = true
				collider:Remove()
			end
		end
	end, tsunFlyVar)
	
	mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, orbital)
		orbital.OrbitDistance = tsunOrbitDistance
		orbital.OrbitSpeed = tsunOrbitSpeed
		local center_pos = (orbital.Player.Position + orbital.Player.Velocity) + tsunCenterOffset
		local orbit_pos = orbital:GetOrbitPosition(center_pos)
		orbital.Velocity = orbit_pos - orbital.Position
	end, tsunFlyVar)
	
	mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider, low)
		if tear:GetData().RepMinusWillFreeze == true and collider:IsVulnerableEnemy() and not collider:IsBoss() then
			collider:AddEntityFlags(EntityFlag.FLAG_ICE)
			tear.CollisionDamage = 9999
		elseif tear:GetData().RepMinusWillFreeze == true and collider:IsVulnerableEnemy() and collider:IsBoss() then
			collider:AddSlowing(EntityRef(tear), 30, 0.5, collider.Color)
		end
	end)
	
	----------------------------------------------------
	--SAVE MANAGER
	----------------------------------------------------
	
	function mod:AnyPlayerDo(foo)
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			foo(player)
		end
	end
	
	function mod:saveData(isSaving)
		if isSaving then
			mod.saveTable.Repm_CHAPIData = CustomHealthAPI.Library.GetHealthBackup()
		end
		local jsonString = json.encode(mod.saveTable)
		mod:SaveData(jsonString)
	end
	mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveData)
	mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
		mod:saveData(true)
	end)
	
	function mod:loadData(isLoad)
		DiliriumEyeLastActivateFrame = 0
		if mod:HasData() then
			local perData = json.decode(mod:LoadData())
			if perData.MenuData then
				mod.saveTable.MenuData = perData.MenuData
			end
			if perData.MusicData then
				mod.saveTable.MusicData = perData.MusicData
			end
		end
		if mod:HasData() and isLoad then
			mod.saveTable = json.decode(mod:LoadData())
			CustomHealthAPI.Library.LoadHealthFromBackup(mod.saveTable.Repm_CHAPIData)
		else
			mod.saveTable.PlayerData = {}
			mod:AnyPlayerDo(function(player)
				player:AddCacheFlags(CacheFlag.CACHE_ALL)
				player:EvaluateItems()
			end)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadData)
	mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function()
		if mod:HasData() then
			local perData = json.decode(mod:LoadData())
			if perData.MenuData then
				mod.saveTable.MenuData = perData.MenuData
			end
			if perData.MusicData then
				mod.saveTable.MusicData = perData.MusicData
			end
		end
	end)
	
	--------------------------------------------------------------
	--FROSTY
	--------------------------------------------------------------
	
	local frostType = Isaac.GetPlayerTypeByName("Frosty", false)
	
	function mod:checkTFrostyConditions(player)
		local fires = Isaac.FindByType(33, 2, 0)
		if player:GetPlayerType() ~= mod.RepmTypes.CHARACTER_FROSTY_B then
			return 0
		elseif #fires > 0 then
			return -1
		else
			return 1
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == frostType or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
				local pdata = mod:repmGetPData(player)
				pdata.FrostDamageDebuff = 0
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
				if
					player:GetPlayerType() == frostType
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
		mod.saveTable.BlizzFade = nil
	end)
	
	local percentFreezePerSecond = 42 --chance to freeze every second
	local frostRNG = RNG()
	local frameBetweenDebuffs = 150 -- 30 frames per second
	local damageDownPerDebuff = 0.40
	local speedDownPerDebuff = 0.10
	local lastFrame = 0
	local minFrameFreeze = 30 -- 1 second
	local maxFrameFreeze = 900 -- 30 seconds
	
	local blueColor = Color(0.67, 1, 1, 1, 0, 0, 0)
	blueColor:SetColorize(1, 1, 3, 1)
	
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
		local pdata = mod:repmGetPData(player)
		if player:GetPlayerType() == frostType or mod:checkTFrostyConditions(player) == 1 then
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
		if pdata.HoldingFrozenPolaroid ~= player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
			if player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
				hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS)
				hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_STEAM_SALE)
				local optionsConfig = config:GetCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS)
				local steamConfig = config:GetCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
				player:RemoveCostume(optionsConfig)
				player:RemoveCostume(steamConfig)
			elseif
				pdata.HoldingFrozenPolaroid == nil and player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) == false
			then
				pdata.HoldingFrozenPolaroid = false -- redundant, i know
			else
				hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_MORE_OPTIONS, hiddenItemManager.kDefaultGroup)
				hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_STEAM_SALE, hiddenItemManager.kDefaultGroup)
			end
			pdata.HoldingFrozenPolaroid = player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
		end
	end)
	
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
		local hasIt = false
		local frame = game:GetFrameCount()
	
		if not startingFrame then
			startingFrame = game:GetFrameCount()
		end
	
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == frostType or mod.saveTable.Repm_Iced then
				hasIt = true
			end
	
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
					and not entity:IsBoss()
					and (entity:GetEntityFlags() & EntityFlag.FLAG_CHARM ~= EntityFlag.FLAG_CHARM)
					and (entity:GetEntityFlags() & EntityFlag.FLAG_FRIENDLY ~= EntityFlag.FLAG_FRIENDLY)
				then
					if not entity:GetData().RepM_Frosty_FreezePoint then
						local num = frostRNG:RandomInt(maxFrameFreeze - minFrameFreeze)
						num = num + minFrameFreeze
						entity:GetData().RepM_Frosty_FreezePoint = game:GetFrameCount() + num
						entity:GetData().RepM_Frosty_StartPoint = game:GetFrameCount()
					end
					local freezepoint = entity:GetData().RepM_Frosty_FreezePoint
					local startingFrame = entity:GetData().RepM_Frosty_StartPoint
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
		if cacheflag == CacheFlag.CACHE_DAMAGE then
			local damageDebuff = (pdata.FrostDamageDebuff or 0)
			if game:IsGreedMode() then
				damageDebuff = damageDebuff / 2
			end
			player.Damage = player.Damage - (damageDebuff * damageDownPerDebuff)
		end
		if cacheflag == CacheFlag.CACHE_SPEED then
			if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
				local speedDebuff = (pdata.FrostDamageDebuff or 0)
				if game:IsGreedMode() then
					speedDebuff = speedDebuff / 2
				end
				player.MoveSpeed = player.MoveSpeed - (speedDebuff * speedDownPerDebuff)
			end
		end
	end)
	
	mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName)
		if REPENTOGON and shaderName == "REPMEmptyShader" then
			local entities = Isaac.GetRoomEntities()
			for i, npc in ipairs(entities) do
				if npc:GetData().RepM_Frosty_FreezePoint ~= nil and npc:IsVulnerableEnemy() and not game:IsPaused() then
					if not npc:GetData().RepM_Frosty_Sprite then
						npc:GetData().RepM_Frosty_Sprite = Sprite()
						npc:GetData().RepM_Frosty_Sprite:Load("gfx/chill_status.anm2", true)
						npc:GetData().RepM_Frosty_Sprite:Play("Idle")
					end
					local position = Isaac.WorldToScreen(npc.Position + npc:GetNullOffset("OverlayEffect"))
					npc:GetData().RepM_Frosty_Sprite:Render(position)
					npc:GetData().RepM_Frosty_Sprite:Update()
				end
				if npc:ToPlayer() and npc:ToPlayer():GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
					local pdata = mod:repmGetPData(npc:ToPlayer())
					--if not game:IsPaused() then
						if not npc:GetData().RepM_Frosty_Sprite then
							npc:GetData().RepM_Frosty_Sprite = Sprite()
							npc:GetData().RepM_Frosty_Sprite:Load("gfx/chill_status.anm2", true)
							npc:GetData().RepM_Frosty_Sprite:Play("Idle")
						end
						local position = Isaac.WorldToScreen(npc.Position + Vector(0, -50))
						npc:GetData().RepM_Frosty_Sprite:Render(position)
						local TFValue = RepMMod:repmGetPData(npc:ToPlayer()).TFrosty_FreezeTimer
						if TFValue == nil then npc:GetData().RepM_Frosty_Sprite.Color = Color(1,1,1,0)
						elseif TFValue <= 500 then
							npc:GetData().RepM_Frosty_Sprite.Color = Color(1,TFValue/500,TFValue/500,1)
						elseif TFValue >= 2000 then
							npc:GetData().RepM_Frosty_Sprite.Color = Color(1,1,1,0)
						else
							npc:GetData().RepM_Frosty_Sprite.Color = Color(1,1,1,math.min(1,1/1500*(1500-(TFValue-500))))
						end
						npc:GetData().RepM_Frosty_Sprite:Update()
					--end
				end
			end
		end
	end)
	
	--function mod:
	
	function mod:FrostyRiftEffectRender(effect, renderoffset)
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
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.FrostyRiftEffectRender, mod.RepmTypes.EFFECT_FROSTY_RIFT)
	
	function mod:FreezyShader(name)
		if name == "BlueFade" then
			local blueQty = 1
			if mod.saveTable.BlizzFade and mod.saveTable.BlizzFade > game:GetFrameCount() then
				blueQty = math.sin(0.05 * ((mod.saveTable.BlizzFade - game:GetFrameCount()) - 31.4159)) + 2
			end
			local params = {
				BlueScale = blueQty,
			}
			return params
		end
	end
	mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.FreezyShader)
	
	function mod:OnRiftCollide(effect)
		local entities = Isaac.FindInRadius(effect.Position, effect.Size / 2)
		for i, collider in ipairs(entities) do
			if
				collider.Type == EntityType.ENTITY_PLAYER
				and collider:ToPlayer()
				and collider:ToPlayer():GetPlayerType() == frostType
				and not effect:GetData().Repm_Rift_Delete
			then
				effect:GetSprite():Play("Disappear")
				local poof =
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector(0, 0), nil)
				poof.Color = blueColor
				mod.saveTable.BlizzFade = game:GetFrameCount() + 125
				sfx:Play(mod.RepmTypes.SFX_WIND)
				local entities = Isaac.GetRoomEntities()
				for i, entity in ipairs(entities) do
					if
						entity:IsVulnerableEnemy()
						and not entity:IsBoss()
						and (entity:GetEntityFlags() & EntityFlag.FLAG_CHARM ~= EntityFlag.FLAG_CHARM)
						and (entity:GetEntityFlags() & EntityFlag.FLAG_FRIENDLY ~= EntityFlag.FLAG_FRIENDLY)
					then
						local freezepoint = entity:GetData().RepM_Frosty_FreezePoint
						local startingFrame = entity:GetData().RepM_Frosty_StartPoint
						if freezepoint and game:GetFrameCount() + 60 >= freezepoint then
							entity:GetData().RepM_Frosty_FreezePoint = game:GetFrameCount() + 1
						elseif freezepoint and freezepoint > game:GetFrameCount() then
							entity:GetData().RepM_Frosty_FreezePoint =
								math.floor((entity:GetData().RepM_Frosty_FreezePoint + game:GetFrameCount()) / 2)
						end
					end
				end
				effect:GetData().Repm_Rift_Delete = true
				break
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.OnRiftCollide, mod.RepmTypes.EFFECT_FROSTY_RIFT)
	
	--Isaac.GetPersistentGameData():TryUnlock(FrostyAchId)
	
	function mod:Anm(player)
		if game:GetFrameCount() == 1 and mod.saveTable.MenuData and mod.saveTable.MenuData.StartThumbsUp ~= 2 then
			player:AnimateHappy()
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.Anm)
	
	--------------------------------------------------------------------------
	--FROZEN POLAROID
	--------------------------------------------------------------------------
	
	function mod:stickyTrinket(pickup, collider, low)
		if not collider:ToPlayer() or not collider:ToPlayer():HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
			return nil
		end
		local player = collider:ToPlayer()
		if
			player:GetTrinket(0) ~= mod.RepmTypes.TRINKET_FROZEN_POLAROID
			and player:GetTrinket(1) ~= mod.RepmTypes.TRINKET_FROZEN_POLAROID
		then
			return nil
		end
	
		if player:GetMaxTrinkets() > 1 then
			if player:GetTrinket(0) == mod.RepmTypes.TRINKET_FROZEN_POLAROID and player:GetTrinket(1) ~= 0 then
				local trinketDrop = player:GetTrinket(1)
				player:TryRemoveTrinket(trinketDrop)
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_TRINKET,
					trinketDrop,
					player.Position,
					Vector(0, 0),
					nil
				)
				return nil
			elseif player:GetTrinket(1) == mod.RepmTypes.TRINKET_FROZEN_POLAROID and player:GetTrinket(0) ~= 0 then
				local trinketDrop = player:GetTrinket(0)
				player:TryRemoveTrinket(trinketDrop)
				Isaac.Spawn(
					EntityType.ENTITY_PICKUP,
					PickupVariant.PICKUP_TRINKET,
					trinketDrop,
					player.Position,
					Vector(0, 0),
					nil
				)
				return nil
			else
				return nil
			end
		else
			return false
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.stickyTrinket, PickupVariant.PICKUP_TRINKET)
	
	function mod:tryOpenDoor_Fro_Polaroid(player)
		--and player:CollidesWithGrid()
		if
			(
				game:GetLevel():GetStage() == 6
				or (game:GetLevel():GetStage() == 5 and Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0)
			)
			and game:GetLevel():GetStageType() <= 2
			and player.Position.Y < 151
			and player.Position:Distance(Vector(320, 150)) <= 26
			and game:GetLevel():GetCurrentRoomIndex() == 84
			and player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
		then
			local door = game:GetRoom():GetDoor(1)
			if not door:IsOpen() then
				door:TryUnlock(player, true)
				player:TryRemoveTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
				mod.saveTable.repM_FrostyUnlock = true
			end
		end
		if
			player:GetLastActionTriggers() & ActionTriggers.ACTIONTRIGGER_ITEMSDROPPED
			== ActionTriggers.ACTIONTRIGGER_ITEMSDROPPED
		then
			local trinkets = Isaac.FindByType(5, 350, mod.RepmTypes.TRINKET_FROZEN_POLAROID)
			local respawnPolaroid = false
			for i, trinket in ipairs(trinkets) do
				if trinket.FrameCount == 0 then
					trinket:Remove()
					respawnPolaroid = true
					break
				end
			end -- not a great solution but let's see
			if respawnPolaroid then
				player:AddTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.tryOpenDoor_Fro_Polaroid)
	--5 350 195
	function mod:DebugText()
		local player = Isaac.GetPlayer(0) --this one is OK
		local coords = (player.Position):Distance(Vector(320, 150))
		--local coords = player.Position
		local debug_str = tostring(player.Position)
		--26
		Isaac.RenderText(debug_str, 100, 60, 1, 1, 1, 255)
	end
	--mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.DebugText)
	
	local BasegameSegmentedEnemies = {
		[35 .. " " .. 0] = true, -- Mr. Maw (body)
		[35 .. " " .. 1] = true, -- Mr. Maw (head)
		[35 .. " " .. 2] = true, -- Mr. Red Maw (body)
		[35 .. " " .. 3] = true, -- Mr. Red Maw (head)
		[89] = true, -- Buttlicker
		[216 .. " " .. 0] = true, -- Swinger (body)
		[216 .. " " .. 1] = true, -- Swinger (head)
		[239] = true, -- Grub
		[244 .. " " .. 2] = true, -- Tainted Round Worm
	
		[19 .. " " .. 0] = true, -- Larry Jr.
		[19 .. " " .. 1] = true, -- The Hollow
		[19 .. " " .. 2] = true, -- Tuff Twins
		[19 .. " " .. 3] = true, -- The Shell
		[28 .. " " .. 0] = true, -- Chub
		[28 .. " " .. 1] = true, -- C.H.A.D.
		[28 .. " " .. 2] = true, -- The Carrion Queen
		[62 .. " " .. 0] = true, -- Pin
		[62 .. " " .. 1] = true, -- Scolex
		[62 .. " " .. 2] = true, -- The Frail
		[62 .. " " .. 3] = true, -- Wormwood
		[79 .. " " .. 0] = true, -- Gemini
		[79 .. " " .. 1] = true, -- Steven
		[79 .. " " .. 10] = true, -- Gemini (baby)
		[79 .. " " .. 11] = true, -- Steven (baby)
		[92 .. " " .. 0] = true, -- Heart
		[92 .. " " .. 1] = true, -- 1/2 Heart
		[93 .. " " .. 0] = true, -- Mask
		[93 .. " " .. 1] = true, -- Mask II
		[97] = true, -- Mask of Infamy
		[98] = true, -- Heart of Infamy
		[266] = true, -- Mama Gurdy
		[912 .. " " .. 0 .. " " .. 0] = true, -- Mother (phase one)
		[912 .. " " .. 0 .. " " .. 2] = true, -- Mother (left arm)
		[912 .. " " .. 0 .. " " .. 3] = true, -- Mother (right arm)
		[918 .. " " .. 0] = true, -- Turdlet
	}
	
	function mod:isBasegameSegmented(entity)
		return BasegameSegmentedEnemies[entity.Type]
			or BasegameSegmentedEnemies[entity.Type .. " " .. entity.Variant]
			or BasegameSegmentedEnemies[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
	end
	
	local function checkEntityForChampionizing(entity)
		return not entity:IsChampion()
			and not entity:IsBoss()
			and globalRng:RandomInt(8) == 1
			and not mod:isBasegameSegmented(entity)
			and entity.Type ~= EntityType.ENTITY_FIREPLACE
	end
	
	function mod:OnEntitySpawn_Polar(npc)
		local chosenPlayer
		mod:AnyPlayerDo(function(player)
			if player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) then
				chosenPlayer = player
			end
		end)
		if chosenPlayer ~= nil then
			if checkEntityForChampionizing(npc) == true then
				npc:MakeChampion(globalRng:GetSeed())
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.OnEntitySpawn_Polar)
	
	function mod:OnTakeHit_Polar(entity, amount, damageflags, source, countdownframes)
		local player = entity:ToPlayer()
		if player == nil then
			return
		end
		local data = mod:repmGetPData(player)
		if amount == 1 and player:HasTrinket(mod.RepmTypes.TRINKET_FROZEN_POLAROID) and not data.inPolaroidDamage then
			data.inPolaroidDamage = true
			return {Damage = amount+1,
			DamageFlags = damageflags,
			DamageCountdown = countdownframes}
		end
		data.inPolaroidDamage = nil
	end
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakeHit_Polar, EntityType.ENTITY_PLAYER)
	-----------------------------------------------------------------
	--frosty unlock
	------------------------------------------------------------------
	local iceCard = Isaac.GetCardIdByName("Icicle")
	
	function mod:OnBossDefeat_Frosty(rng, spawn)
			FrostyAchId = Isaac.GetAchievementIdByName("Frosty")
			if
				not Isaac.GetPersistentGameData():Unlocked(FrostyAchId)
				and Isaac.GetPersistentGameData():Unlocked(635)
				and game:GetRoom():GetType() == RoomType.ROOM_BOSS
				and game:GetLevel():GetStage() == 1
				and game:GetLevel():GetStageType() <= 2
				and mod.saveTable.repm_picSpawned ~= true
			then
				local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetCenterPos())
				Isaac.Spawn(5, 350, mod.RepmTypes.TRINKET_FROZEN_POLAROID, spawnPos, Vector.Zero, nil)
				mod.saveTable.repm_picSpawned = true
			end
		mod.saveTable.Repm_Iced = false
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnBossDefeat_Frosty)
	
	function mod:OnEnterSecretExit()
		mod.saveTable.Repm_Iced = false
		local room = game:GetRoom()
		if
			room:GetType() == RoomType.ROOM_SECRET_EXIT
			and game:GetLevel():GetStage() == 6
			and game:GetLevel():GetStageType() <= 2
			and REPENTOGON
			and mod.saveTable.repM_FrostyUnlock
		then
			--room:SetBackdropType(BackdropType.BLUE_WOMB_PASS, 3)
			for i = 1, room:GetGridSize() do
				local ge = room:GetGridEntity(i)
				if ge and ge.Desc.Type ~= 16 then
					room:RemoveGridEntity(i, 0)
				end
			end
			if room:IsFirstVisit() then
				local items = Isaac.FindByType(5, 100)
				for i, item in ipairs(items) do
					item:Remove()
				end
				Isaac.Spawn(6, 14, 0, room:GetCenterPos(), Vector.Zero, nil)
			end
	
			local frosties = Isaac.FindByType(6, 14)
			for i, dude in ipairs(frosties) do
				dude:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_frosty.png")
				dude:GetSprite():LoadGraphics()
			end
			--elseif game:GetRoom():GetType() == RoomType.ROOM_BOSS and game:GetLevel():GetStage() == 6 and mod.saveTable.repM_FrostyUnlock then
			--room:TrySpawnBossRushDoor()
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnEnterSecretExit)
	
	function mod:UseIcicle(card, player, useflags)
		if
			game:GetRoom():GetType() == RoomType.ROOM_BOSS
			and game:GetLevel():GetStage() == 6
			and REPENTOGON
			and not room:IsClear()
		then
			mod.saveTable.repM_FrostyUnlock = true
			local entities = Isaac.GetRoomEntities()
			for i, npc in ipairs(entities) do
				if npc:IsVulnerableEnemy() and npc:IsBoss() then
					npc:TakeDamage(9999, 0, EntityRef(player), 1)
				elseif npc:IsVulnerableEnemy() then
					npc:AddEntityFlags(EntityFlag.FLAG_ICE)
					npc:TakeDamage(9999, 0, EntityRef(player), 1)
				end
			end
			game:GetRoom():TrySpawnBossRushDoor()
		elseif not room:IsClear() then
			mod.saveTable.Repm_Iced = true
		end
	end
	--mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.UseIcicle, iceCard)
	
	--MC_PRE_PLAYER_COLLISION
	
	function mod:onCollisionSecret(player, collider, low)
		if collider.Type == 6 and collider.Variant == 14 and game:GetRoom():GetType() == RoomType.ROOM_SECRET_EXIT then
			FrostyAchId = Isaac.GetAchievementIdByName("Frosty")
			Isaac.GetPersistentGameData():TryUnlock(FrostyAchId)
			Isaac.GetPersistentGameData():TryUnlock(FrozenHeartsAchId)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.onCollisionSecret)
	
	----------------------------------------------------------
	function mod:whenSpawningCreep_IceHeart(player)
		local pdata = mod:repmGetPData(player)
		if pdata.isIceheartCrept and game:GetFrameCount() % 3 == 0 then
			local creep = Isaac.Spawn(1000, 54, 0, player.Position, Vector.Zero, player):ToEffect()
			creep.Scale = 0.65
			--creep:SetTimeout(15)
			creep:Update()
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.whenSpawningCreep_IceHeart)
	
	function mod:disableCreepRoom()
		mod:AnyPlayerDo(function(player)
			local pdata = mod:repmGetPData(player)
			pdata.isIceheartCrept = nil
			pdata.EnhSpeedBonus = 0
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
		end)
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.disableCreepRoom)
	
	----------------------------------------------------------
	
	function mod:onGreedUpdate_RepM()
		if game:IsGreedMode() and mod.saveTable.REPM_GreedWave ~= game:GetLevel().GreedModeWave then
			mod:AnyPlayerDo(function(player)
				if player:GetPlayerType() == frostType or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
					local pdata = repmGetPData(player)
					pdata.FrostDamageDebuff = (pdata.FrostDamageDebuff or 0) + 1
				end
			end)
			mod.saveTable.REPM_GreedWave = game:GetLevel().GreedModeWave
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onGreedUpdate_RepM)
	
	----------------------------------------------------------
	--FOUNTAIN
	----------------------------------------------------------
	local fountainType = Isaac.GetEntityVariantByName("Fountain of Confession")
	local fountainSound = Isaac.GetSoundIdByName("fountain")
	
	local function playerToNum(player)
		for num = 0, game:GetNumPlayers() - 1 do
			if GetPtrHash(player) == GetPtrHash(Isaac.GetPlayer(num)) then
				return num
			end
		end
	end
	
	local function killFount(fount)
		fount:GetSprite():Play("Death")
	end
	
	function mod:numToPlayer(num)
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			if GetPtrHash(player) == GetPtrHash(Isaac.GetPlayer(num)) then
				return player
			end
		end
	end
	
	local isFountPlaying = false
	
	function mod:fountUpdate()
		local founts = Isaac.FindByType(EntityType.ENTITY_SLOT, fountainType)
		local anyInRadius = false
		for _, fount in pairs(founts) do
			if fount:GetSprite():IsFinished("Initiate") then
				fount:GetSprite():Play("Wiggle")
			end
			if fount:GetSprite():IsFinished("Wiggle") then
				fount:GetSprite():Play("Prize")
			end
			if fount:GetSprite():IsFinished("Death") then
				fount:GetSprite():Play("Broken")
				fount:Die()
			end
			if fount:GetSprite():IsFinished("Prize") then
				local dropRNG = fount:GetDropRNG()
				local breakOutcome = dropRNG:RandomInt(100)
				if breakOutcome <= 15 then
					fount:GetSprite():Play("Death")
				else
					fount:GetSprite():Play("Idle")
				end
				fount:GetData()["Playing Player"] = nil
			end
	
			if fount:GetSprite():IsEventTriggered("Explosion") then
				local exp = Isaac.Spawn(1000, 1, 0, fount.Position, Vector.Zero, fount)
				exp:GetData().FountCaused_REPM = true
			end
	
			if fount:GetSprite():IsEventTriggered("Prize") then
				local outcome = fount:GetData().Slot_Outcome or 99
				if outcome <= 5 then
					sfx:Play(SoundEffect.SOUND_LUCKYPICKUP, 1.0, 0, false, 1.0)
					Isaac.Spawn(5, 300, 20, fount.Position, Vector(0, 1), fount)
				elseif outcome <= 15 then
					local player = mod:numToPlayer(fount:GetData()["Playing Player"])
					--player:AddSoulHearts(2)
					--SfxManager:Play(SoundEffect.SOUND_THUMBSUP, 2)
					--player:AnimateHappy()
					local pdata = mod:repmGetPData(player)
					pdata.repMBonusDamage = (pdata.repMBonusDamage or 0) + 0.5
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
					player:EvaluateItems()
					player:AnimateHappy()
					sfx:Play(SoundEffect.SOUND_THUMBSUP, 2)
				else
					local player = mod:numToPlayer(fount:GetData()["Playing Player"])
					local pdata = mod:repmGetPData(player)
					pdata.repMBonusLuck = (pdata.repMBonusLuck or 0) + 0.5
					player:AddCacheFlags(CacheFlag.CACHE_LUCK)
					player:EvaluateItems()
					player:AnimateHappy()
					sfx:Play(SoundEffect.SOUND_THUMBSUP, 2)
				end
			end
			if fount:GetSprite():IsEventTriggered("Disappear") then
				fount.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			end
	
			local players = Isaac.FindInRadius(fount.Position, 100)
			for i, player in ipairs(players) do
				if player:ToPlayer() ~= nil and fount:GetSprite():GetAnimation() ~= "Broken" then
					anyInRadius = true
					if not isFountPlaying then
						isFountPlaying = true
						sfx:Play(fountainSound, 1, 30, true)
					end
				end
			end
		end
		if anyInRadius == false and isFountPlaying then
			isFountPlaying = false
			sfx:Stop(fountainSound)
		end
		local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
		for _, plosion in pairs(explosions) do
			local frame = plosion:GetSprite():GetFrame()
			if frame < 3 then -- I'm afraid of 60 vs 30 breaking an exact check
				local size = plosion.SpriteScale.X -- default is 1, can be increased
				local nearby = Isaac.FindInRadius(plosion.Position, 75 * size)
				for _, v in pairs(nearby) do
					if
						v.Type == EntityType.ENTITY_SLOT
						and v.Variant == fountainType
						and v:GetSprite():GetAnimation() ~= "Broken"
						and v:GetSprite():GetAnimation() ~= "Death"
						and plosion:GetData().FountCaused_REPM ~= true
					then
						killFount(v)
					end
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.fountUpdate)
	
	function mod:donationFount(player, fount, low)
		if fount.Type == EntityType.ENTITY_SLOT and fount.Variant == fountainType then
			if
				fount:GetSprite():IsPlaying("Idle")
				and player:GetNumCoins() > 4
				and (not REPENTOGON or fount:ToSlot():GetState() ~= -1)
			then
				player:AddCoins(-5)
				SFXManager():Play(SoundEffect.SOUND_SCAMPER, 1.0, 0, false, 1.0)
				fount:GetSprite():Play("Initiate")
				fount:GetData()["Playing Player"] = playerToNum(player)
				if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
					fount:GetData()["Playing Player"] = playerToNum(player:GetMainTwin())
				end
				local droprng = fount:GetDropRNG()
				fount:GetData().Slot_Outcome = droprng:RandomInt(100)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.donationFount)
	
	function mod:updateCache_Fountain(player, cacheFlag)
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			local pdata = mod:repmGetPData(player)
			player.Damage = player.Damage + (pdata.repMBonusDamage or 0)
		elseif cacheFlag == CacheFlag.CACHE_LUCK then
			local pdata = mod:repmGetPData(player)
			player.Luck = player.Luck + (pdata.repMBonusLuck or 0)
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.updateCache_Fountain)
	
	function mod:spawnFountBehavior()
		local room = game:GetRoom()
		if room:IsFirstVisit() then
			local confessionals = Isaac.FindByType(EntityType.ENTITY_SLOT, 17)
			for i, confess in ipairs(confessionals) do
				local rng = confess:GetDropRNG()
				if rng:RandomInt(100) + 1 <= 50 then
					local pos = confess.Position
					confess:Remove()
					Isaac.Spawn(6, fountainType, 0, pos, Vector.Zero, nil)
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.spawnFountBehavior)
	
	----------------------------------------------------------
	--RED LIGHT GREEN LIGHT
	----------------------------------------------------------
	local redLightChallenge = Isaac.GetChallengeIdByName("Traffic Light")
	
	function mod:trafficRender()
		if Isaac.GetChallenge() == redLightChallenge then
			if not mod.saveTable.RedLightSprite then
				mod.saveTable.RedLightSprite = Sprite()
				mod.saveTable.RedLightSprite:Load("gfx/trafficlight.anm2", true)
				mod.saveTable.RedLightSprite:LoadGraphics()
			end
			if not mod.saveTable.RedLightSign then
				return
			end
			if mod.saveTable.RedLightSprite:GetAnimation() ~= mod.RedLightSign then
				mod.saveTable.RedLightSprite:Play(mod.saveTable.RedLightSign)
			end
			local horiz, vert
			if REPENTOGON then -- probably a useless split but maybe we'll make this work with the map size later
				horiz = 115
				vert = 45
			else
				horiz = 115
				vert = 45
			end
	
			mod.saveTable.RedLightSprite:Render(Vector(horiz, vert))
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.trafficRender)
	
	--local saveTimer
	
	local function IsMoving(player)
		local index = player.ControllerIndex
		return Input.IsActionPressed(ButtonAction.ACTION_LEFT, index)
			or Input.IsActionPressed(ButtonAction.ACTION_RIGHT, index)
			or Input.IsActionPressed(ButtonAction.ACTION_UP, index)
			or Input.IsActionPressed(ButtonAction.ACTION_DOWN, index)
	end
	
	function mod:changeLights()
		local frame = game:GetFrameCount()
		if Isaac.GetChallenge() == redLightChallenge then
			if not mod.saveTable.saveTimer then
				mod.saveTable.saveTimer = 0
				if not mod.saveTable.RedLightSign or mod.saveTable.RedLightSign == "GreenLight" then
					mod.saveTable.RedLightSign = "RedLight"
				elseif mod.saveTable.RedLightSign == "YellowLight" then
					mod.saveTable.RedLightSign = "GreenLight"
				else
					mod.saveTable.RedLightSign = "YellowLight"
				end
			end
			if frame > mod.saveTable.saveTimer then
				if mod.saveTable.RedLightSign == "RedLight" then
					mod.saveTable.saveTimer = frame + globalRng:RandomInt(1350) + 300
					mod.saveTable.RedLightSign = "GreenLight"
				elseif mod.saveTable.RedLightSign == "YellowLight" then
					mod.saveTable.saveTimer = frame + globalRng:RandomInt(300) + 30
					mod.saveTable.RedLightSign = "RedLight"
					sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 2)
				else
					mod.saveTable.saveTimer = frame + 30
					mod.saveTable.RedLightSign = "YellowLight" --SOUND_TOOTH_AND_NAIL_TICK
					sfx:Play(469, 2)
				end
			end
			mod:AnyPlayerDo(function(player)
				if mod.saveTable.RedLightSign == "RedLight" and IsMoving(player) then
					local pdata = mod:repmGetPData(player)
					if not pdata.redLightFrame or pdata.redLightFrame < frame then
						pdata.redLightFrame = frame + 30
						player:TakeDamage(1, 0, EntityRef(player), 2)
					end
				end
				if frame == 0 then
					pdata.redLightFrame = nil
				end
			end)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.changeLights)
	
	----------------------------------------------------------
	--FRIENDLY ROCKS
	----------------------------------------------------------
	function mod:onRockBreak(rockSubtype, position) --probably could make a callback but nah
		local hasIt = false
		local rockRNG = nil
		mod:AnyPlayerDo(function(player)
			if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS) then
				hasIt = true
				rockRNG = player:GetCollectibleRNG(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS)
			end
		end)
		if hasIt and rockRNG:RandomInt(10) ~= 1 then
			Isaac.Spawn(3, 201, 12, position, Vector.Zero, nil)
		end
	end
	
	local function rockIsBroken(position)
		local room = game:GetRoom()
		local rock = room:GetGridEntity(position)
		if not rock then
			return true
		elseif rock:ToRock() and rock.State == 2 then
			return true
		--elseif rock:ToPoop() and rock.State == 1000 then
		--return true
		else
			return false
		end
	end
	
	function mod:CheckRocksBreak()
		local room = game:GetRoom()
		local level = game:GetLevel()
		local newRoom = false
		if mod.saveTable.scanRockRoom ~= level:GetCurrentRoomIndex() then
			newRoom = true
			mod.saveTable.scanRockRoom = level:GetCurrentRoomIndex()
		end
		if not mod.saveTable.scanRockMap then
			mod.saveTable.scanRockMap = {}
		end
	
		for i = 1, room:GetGridSize(), 1 do
			local rock = room:GetGridEntity(i)
			if newRoom then
				if rock and not rockIsBroken(i) then
					mod.saveTable.scanRockMap[i] = rock:GetType()
				else
					mod.saveTable.scanRockMap[i] = nil
				end
			else
				if rock and mod.saveTable.scanRockMap[i] ~= nil and rockIsBroken(i) then
					mod:onRockBreak(mod.saveTable.scanRockMap[i], rock.Position)
					mod.saveTable.scanRockMap[i] = nil
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.CheckRocksBreak)
	
	----------------------------------------------------------
	--LIKE (Item)
	----------------------------------------------------------
	local likeFrame = -5
	
	function mod:onPlayerUpdate_Like(player)
		if
			player:HasCollectible(mod.RepmTypes.COLLECTIBLE_LIKE)
			and player:GetSprite():GetAnimation() == "Happy"
			and player:GetSprite():GetFrame() == 6
		then
			local pdata = mod:repmGetPData(player)
			pdata.Like_AllBonus = (pdata.Like_AllBonus or 0) + 0.5
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate_Like)
	
	function mod:likeCache(player, cacheFlag)
		local pdata = mod:repmGetPData(player)
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage
				+ (0.4 * (pdata.Like_AllBonus or 0))
				+ player:GetCollectibleNum(mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD)
		elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
			local tearstoadd = (0.4 * (pdata.Like_AllBonus or 0))
			player.MaxFireDelay = tearsUp(player.MaxFireDelay, tearstoadd)
		elseif cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + (0.4 * (pdata.Like_AllBonus or 0))
		elseif cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + (0.4 * (pdata.Like_AllBonus or 0))
			player.MoveSpeed = player.MoveSpeed + (pdata.EnhSpeedBonus or 0) * 0.2
		elseif cacheFlag == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange + (40 * (pdata.Like_AllBonus or 0))
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.likeCache)
	
	----------------------------------------------------------
	--LOCUST KING
	----------------------------------------------------------
	
	function mod:collideItemPedestalAbs(pickup, collider, low)
		local player = collider:ToPlayer()
		if
			player
			and Isaac.GetChallenge() == mod.RepmTypes.CHALLENGE_LOCUST_KING
			and pickup.SubType ~= 0
			and not Isaac.GetItemConfig():GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST)
			and pickup.SubType ~= CollectibleType.COLLECTIBLE_MORE_OPTIONS
		then
			sfx:Play(SoundEffect.SOUND_FART, 2)
			local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
			local pickupindex = pickup:ToPickup().OptionsPickupIndex
			for i, item in ipairs(items) do
				if item:ToPickup().OptionsPickupIndex == pickupindex and pickupindex ~= 0 then
					item:Remove()
				end
			end
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector(0, 0), nil)
			pickup:Remove()
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.collideItemPedestalAbs, PickupVariant.PICKUP_COLLECTIBLE)
	
	local function doesAnyoneHave(trinket)
		local hasIt = false
		mod:AnyPlayerDo(function(player)
			if player:HasTrinket(trinket) then
				hasIt = true
			end
		end)
		return hasIt
	end
	
	function mod:onLevelStart_Locust()
		Isaac.GetItemConfig():GetCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE).MaxCharges = 1
		local hasIt = false
		--mod:AnyPlayerDo(function(player)
		--if player:HasCollectible(CollectibleType.COLLECTIBLE_MORE_OPTIONS) then
		--hasIt = true
		--end
		--end)
		if Isaac.GetChallenge() == mod.RepmTypes.CHALLENGE_LOCUST_KING then
			--if not hasIt then
			local itemHere = Isaac.Spawn(5, 10, 11, Vector(160, 225), Vector.Zero, nil)
			itemHere:ToPickup().ShopItemId = -1
			itemHere:ToPickup().AutoUpdatePrice = false
			itemHere:ToPickup().Price = 4
			--end
	
			if not doesAnyoneHave(186) then
				Isaac.Spawn(5, 350, 186, Vector(480, 225), Vector.Zero, nil)
			elseif not doesAnyoneHave(115) then
				Isaac.Spawn(5, 350, 115, Vector(480, 225), Vector.Zero, nil)
			elseif not doesAnyoneHave(114) then
				Isaac.Spawn(5, 350, 114, Vector(480, 225), Vector.Zero, nil)
			elseif not doesAnyoneHave(113) then
				Isaac.Spawn(5, 350, 113, Vector(480, 225), Vector.Zero, nil)
			elseif not doesAnyoneHave(116) then
				Isaac.Spawn(5, 350, 116, Vector(480, 225), Vector.Zero, nil)
			elseif not doesAnyoneHave(117) then
				Isaac.Spawn(5, 350, 117, Vector(480, 225), Vector.Zero, nil)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onLevelStart_Locust)
	
	function mod:ChallengeMarblesInit(player)
		if player and Isaac.GetChallenge() == mod.RepmTypes.CHALLENGE_LOCUST_KING then
			player:AddCollectible(CollectibleType.COLLECTIBLE_MARBLES, 0, false)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.ChallengeMarblesInit)
	
	----------------------------------------------------------
	--ACHIEVEMENT
	----------------------------------------------------------
	function mod:onSatanFrostyKill()
		local isFrosty = false
		if
			game:GetLevel():GetStage() ~= 10
			or game:GetLevel():GetStageType() ~= StageType.STAGETYPE_ORIGINAL
			or game:IsGreedMode()
			or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
			or game:GetRoom():GetBossID() ~= 24
		then
			return
		end
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == frostType then
				isFrosty = true
			end
		end)
		if isFrosty then
			Isaac.GetPersistentGameData():TryUnlock(DeathCardAchId)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onSatanFrostyKill)
	
	function mod:onBlueBabyFrostyKill(entity)
		local isFrosty = false
		if
			game:GetLevel():GetStage() ~= 11
			or game:GetLevel():GetStageType() ~= StageType.STAGETYPE_WOTL
			or game:IsGreedMode()
			or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
			or game:GetRoom():GetBossID() ~= 40
		then
			return
		end
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == frostType then
				isFrosty = true
			end
		end)
		if isFrosty then
			Isaac.GetPersistentGameData():TryUnlock(NumbHeartAchId)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onBlueBabyFrostyKill)
	
	function mod:onSimDeliriumKill(entity)
		local isSim = false
		if game:GetLevel():GetStage() ~= 12 or game:GetRoom():GetBossID() ~= 70 then
			return
		end
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == SimType then
				isSim = true
			end
		end)
		if isSim then
			Isaac.GetPersistentGameData():TryUnlock(SimDeliriumId)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onSimDeliriumKill)
	
	function mod:onSimMotherKill(entity)
		local isSim = false
		if game:GetLevel():GetStage() ~= 8 or game:GetRoom():GetBossID() ~= 72 then
			return
		end
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == SimType then
				isSim = true
			end
		end)
		if isSim then
			Isaac.GetPersistentGameData():TryUnlock(RotAchId)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onSimMotherKill)
	
	function mod:onMomHeartKill(entity)
		local FrostyDone = false
		local SimDone = false
		--local MinusIsaacDone = false
	
		if
			game:GetLevel():GetStage() ~= 8
			or game:IsGreedMode()
			or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS
			or (game:GetRoom():GetBossID() ~= 8 and game:GetRoom():GetBossID() ~= 25)
		then
			return
		end
	
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == frostType or Isaac.GetCompletionMark(frostType, 0) then
				FrostyDone = true
			end
			if player:GetPlayerType() == SimType or Isaac.GetCompletionMark(SimType, 0) then
				SimDone = true
			end
			--if player:GetPlayerType() == Minusaac or Isaac.GetCompletionMark(Minusaac, 0) then
			--MinusIsaacDone = true
			--end
		end)
		if FrostyDone and SimDone then
			Isaac.GetPersistentGameData():TryUnlock(ImprovedCardsAchId)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onMomHeartKill)
	--mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onMomHeartKill, EntityType.ENTITY_MOMS_HEART)
	
	----------------------------------------------------------
	--ENHANCED CARDS
	----------------------------------------------------------
	function mod:OnEnhancedTwoHearts(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			player:AddBlueFlies(12, player.Position, nil)
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedTwoHearts, Card.CARD_HEARTS_2)
	
	function mod:OnEnhancedHierophant(card, player, useflags)
		local room = game:GetRoom()
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
		then
			--player:AddBlueFlies(12, player.Position, nil)
	
			Isaac.Spawn(5, 20, 2, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			Isaac.Spawn(5, 20, 2, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			player:AnimateCard(card)
			return true
		end
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			if Isaac.GetPersistentGameData():Unlocked(293) then
				Isaac.Spawn(5, 300, 51, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
				Isaac.Spawn(5, 300, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			else
				player:AddBlueFlies(10, player.Position, nil)
			end
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedHierophant, Card.CARD_HIEROPHANT)
	
	function mod:OnEnhancedLovers(card, player, useflags)
		local room = game:GetRoom()
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
		then
			--player:AddBlueFlies(12, player.Position, nil)
	
			Isaac.Spawn(5, 20, 1, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			Isaac.Spawn(5, 20, 1, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			player:AnimateCard(card)
			return true
		end
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			if Isaac.GetPersistentGameData():Unlocked(293) then
				Isaac.Spawn(5, 300, 51, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			else
				player:AddBlueFlies(5, player.Position, nil)
			end
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedLovers, Card.CARD_LOVERS)
	
	function mod:OnEnhancedTemperance(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			local room = game:GetRoom()
			sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)
			local slot = Isaac.Spawn(6, 3, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, slot.Position, Vector(0, 0), nil)
			player:AnimateCard(card)
			return true
		end
	end -- to do, add a poof and spawn sound
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedTemperance, Card.CARD_TEMPERANCE)
	
	function mod:OnEnhancedDagaz(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
		then
			local room = game:GetRoom()
			Isaac.Spawn(5, 20, 2, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
		end
	end -- to do, add a poof and spawn sound
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedDagaz, Card.RUNE_DAGAZ)
	
	function mod:OnEnhancedHierophantB(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
		then
			--player:AddBlueFlies(12, player.Position, nil)
			local room = game:GetRoom()
			Isaac.Spawn(5, 20, 3, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			player:AnimateCard(card)
			return true
		end
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			player:AddBlueFlies(8, player.Position, nil)
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedHierophantB, Card.CARD_REVERSE_HIEROPHANT)
	
	function mod:OnEnhancedQueenHearts(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			local amountTotal = globalRng:RandomInt(39) + 2
			local amountSpiders = globalRng:RandomInt(amountTotal)
			player:AddBlueFlies(amountTotal - amountSpiders, player.Position, nil)
			for i = 1, amountSpiders, 1 do
				player:AddBlueSpider(player.Position)
			end
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedQueenHearts, Card.CARD_QUEEN_OF_HEARTS)
	
	function mod:OnEnhancedEmpressB(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B)
		then
			local room = game:GetRoom()
			Isaac.Spawn(5, 20, 3, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			Isaac.Spawn(5, 20, 3, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
			player:AnimateCard(card)
			return true
		end
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			player:AddBlueFlies(8, player.Position, nil)
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedEmpressB, Card.CARD_REVERSE_EMPRESS)
	
	function mod:OnEnhancedJudgement(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			local entities = Isaac.FindByType(6, 5, -1)
			for i, entity in ipairs(entities) do
				if entity.FrameCount <= 15 then
					local oldPos = entity.Position
					entity:Remove()
					Isaac.Spawn(6, 4, 0, oldPos, Vector.Zero, nil)
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnEnhancedJudgement, Card.CARD_JUDGEMENT)
	
	function mod:OnEnhancedStrengthB(card, player, useflags)
		if
			Isaac.GetPersistentGameData():Unlocked(ImprovedCardsAchId)
			and (
				player:GetPlayerType() == PlayerType.PLAYER_THELOST
				or player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			)
		then
			local pdata = mod:repmGetPData(player)
			pdata.EnhSpeedBonus = (pdata.EnhSpeedBonus or 0) + 1
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
			player:AnimateCard(card)
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, mod.OnEnhancedStrengthB, Card.CARD_REVERSE_STRENGTH)
	
	----------------------------------------------------------
	--SIREN HORNS
	----------------------------------------------------------
	
	local chargebarFramesSiren = 235
	local SirenHud = Sprite()
	SirenHud:Load("gfx/chargebar_siren.anm2", true)
	local sirenframesToCharge = 141
	--local framesToCharge = 235
	--local framesToCharge = 20
	local sirenRenderedPosition = Vector(21, -12)
	
	function mod:renderSirenCharge(player)
		if player:HasCollectible(mod.RepmTypes.Collectible_SIREN_HORNS) then
			local data = player:GetData()
			data.RepM_SirenChargeFrames = data.RepM_SirenChargeFrames or 0
			local maxThreshold = data.RepM_SirenChargeFrames
			local aim = player:GetAimDirection()
			local isAim = aim:Length() > 0.01
	
			if isAim and not (player:GetData().repM_fireSiren and player:GetData().repM_fireSiren > 0) then
				data.RepM_SirenChargeFrames = (data.RepM_SirenChargeFrames or 0) + 1
			elseif not game:IsPaused() then
				data.RepM_SirenChargeFrames = 0
			end
	
			if maxThreshold > sirenframesToCharge and data.RepM_SirenChargeFrames == 0 then
				data.repM_fireSiren = -1
			end
	
			if data.RepM_SirenChargeFrames > 0 and data.RepM_SirenChargeFrames <= sirenframesToCharge then
				local frameToSet = math.floor(math.min(data.RepM_SirenChargeFrames * (100 / sirenframesToCharge), 100))
				SirenHud:SetFrame("Charging", frameToSet)
				SirenHud:Render(Isaac.WorldToScreen(player.Position) + sirenRenderedPosition)
			elseif data.RepM_SirenChargeFrames > sirenframesToCharge then
				local frameToSet = math.floor((data.RepM_SirenChargeFrames - sirenframesToCharge) / 2) % 6
				SirenHud:SetFrame("Charged", frameToSet)
				SirenHud:Render(Isaac.WorldToScreen(player.Position) + sirenRenderedPosition)
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.renderSirenCharge)
	
	local lastFiredFrame = 0
	function mod:waitFireSiren(player)
		if player:GetData().repM_fireSiren == -1 then
			player:GetData().repM_fireSiren = game:GetFrameCount() + 90
			sfx:Play(mod.RepmTypes.SFX_SIREN)
			local entities = Isaac.GetRoomEntities()
			local sirenRNG = player:GetCollectibleRNG(mod.RepmTypes.Collectible_SIREN_HORNS)
			player:AddNullCostume(mod.RepmTypes.SIREN_COSTUME)
			for i, entity in ipairs(entities) do
				if entity:IsVulnerableEnemy() then
					if sirenRNG:RandomInt(5) == 0 then
						entity:AddCharmed(EntityRef(player), 9999)
					else
						entity:AddConfusion(EntityRef(player), 150, false)
					end
				end
			end
		elseif
			player:GetData().repM_fireSiren
			and player:GetData().repM_fireSiren > 0
			and game:GetFrameCount() > player:GetData().repM_fireSiren
		then
			player:GetData().repM_fireSiren = nil
			player:TryRemoveNullCostume(mod.RepmTypes.SIREN_COSTUME)
		elseif player:GetData().repM_fireSiren and player:GetData().repM_fireSiren > 0 then
			if game:GetFrameCount() % 5 == 0 and game:GetFrameCount() ~= lastFiredFrame then
				Isaac.Spawn(1000, 164, 0, player.Position, Vector.Zero, nil)
				lastFiredFrame = game:GetFrameCount()
			end
			player.FireDelay = 1
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.waitFireSiren)
	
	----------------------------------------------------------
	--HOW TO DIG
	----------------------------------------------------------
	function mod:useHowToDig(collectibletype, rng, player, useflags, slot, vardata)
		local data = player:GetData()
		if data.REPM_InDigState == nil then
			data.REPM_InDigState = game:GetFrameCount()
			player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
		end
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useHowToDig, mod.RepmTypes.Collectible_HOW_TO_DIG)
	
	local points = {}
	local lastRoomIndex
	
	local sinkFrame = nil
	local lastParticleFrame = nil
	function mod:HowDigUpdate(player)
		if player:GetData().REPM_InDigState ~= nil then
			if game:GetFrameCount() ~= sinkFrame and player:GetData().REPM_InDigState + 20 == game:GetFrameCount() then
				player:GetSprite().Color = Color(1, 1, 1, 0, 1, 1, 1)
				player:GetSprite():LoadGraphics()
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
				hiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_LEO)
				sinkFrame = game:GetFrameCount()
				lastParticleFrame = game:GetFrameCount()
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, Options.SFXVolume * 2)
				Isaac.Spawn(1000, 62, 0, player.Position, Vector.Zero, entity)
				for i = 1, 3 do
					Isaac.Spawn(
						1000,
						4,
						0,
						game:GetRoom():GetGridPosition(game:GetRoom():GetGridIndex(player.Position)),
						RandomVector() * math.random() * 5,
						player
					)
				end
			elseif
				player:GetData().REPM_EscapeDig == true or game:GetFrameCount() > player:GetData().REPM_InDigState + 600
			then
				player:GetData().REPM_EscapeDig = nil
				player:GetSprite().Color = Color(1, 1, 1, 1, 0, 0, 0)
				player:GetSprite():LoadGraphics()
				player:GetData().REPM_InDigState = nil
	
				for i = 1, 3 do
					Isaac.Spawn(
						1000,
						4,
						0,
						game:GetRoom():GetGridPosition(game:GetRoom():GetGridIndex(player.Position)),
						RandomVector() * math.random() * 5,
						player
					)
				end
				player:AddCacheFlags(CacheFlag.CACHE_SPEED)
				player:EvaluateItems()
				sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, Options.SFXVolume * 2)
				Isaac.Spawn(1000, 62, 0, player.Position, Vector.Zero, entity)
				player:UseActiveItem(CollectibleType.COLLECTIBLE_HOW_TO_JUMP)
				hiddenItemManager:Remove(player, CollectibleType.COLLECTIBLE_LEO, hiddenItemManager.kDefaultGroup)
				if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
					table.insert(points, { point = player, dmg = player.Damage })
				end
			elseif game:GetFrameCount() ~= sinkFrame and player:GetData().REPM_InDigState + 20 <= game:GetFrameCount() then
				player.FireDelay = 1
				if game:GetFrameCount() == lastParticleFrame + 4 then
					lastParticleFrame = lastParticleFrame + 4
					sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, Options.SFXVolume / 3)
					Isaac.Spawn(1000, 62, 0, player.Position, Vector.Zero, entity)
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.HowDigUpdate)
	
	function mod:OnPlayerCollide_Dig(player, collider)
		if player:GetData().REPM_InDigState and player:GetData().REPM_InDigState + 20 <= game:GetFrameCount() then
			return true
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.OnPlayerCollide_Dig)
	
	function mod:OnPlayerDamage_Dig(entity, amount, damageflags, source, countdownframes)
		local player = entity:ToPlayer()
		if player == nil then
			return
		end
	
		if player:GetData().REPM_InDigState and player:GetData().REPM_InDigState + 20 <= game:GetFrameCount() then
			return false
		end
	end
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPlayerDamage_Dig, EntityType.ENTITY_PLAYER)
	
	function mod:DoorUpdateDig(door)
		local entities = Isaac.FindInRadius(door.Position, 30)
		if not door:IsOpen() and door:CanBlowOpen() then
			for i, entity in ipairs(entities) do
				if
					entity
					and entity:ToPlayer() ~= nil
					and entity:ToPlayer():GetData().REPM_InDigState
					and entity:ToPlayer():GetData().REPM_InDigState + 20 <= game:GetFrameCount()
				then
					door:TryBlowOpen(false, entity:ToPlayer())
					sfx:Play(SoundEffect.SOUND_WOOD_PLANK_BREAK)
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, mod.DoorUpdateDig)
	
	function mod:HowDigRender(player)
		if
			player:GetData().REPM_InDigState ~= nil
			and player:GetData().REPM_InDigState ~= game:GetFrameCount()
			and not player:GetData().REPM_EscapeDig
			and Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex)
		then
			player:GetData().REPM_EscapeDig = true
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.HowDigRender)
	
	function mod:digSlowdown(player, cacheFlag)
		local data = player:GetData()
		if data.REPM_InDigState and data.REPM_InDigState + 20 <= game:GetFrameCount() then
			if cacheFlag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed * 0.5
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.digSlowdown)
	
	local directions = {
		Vector(1, 0),
		Vector(0, 1),
		Vector(-1, 0),
		Vector(0, -1),
	}
	
	local function onUpdate(_mod, npc)
		local ply = Isaac.GetPlayer(0)
		local ents = Isaac.GetRoomEntities()
		local level = game:GetLevel()
	
		if lastRoomIndex ~= level:GetCurrentRoomIndex() then
			lastRoomIndex = level:GetCurrentRoomIndex()
			points = {}
		end
	
		local room = game:GetRoom()
		local width = room:GetGridWidth()
		local height = room:GetGridHeight()
	
		local dmgTiles = {}
		for k, v in pairs(points) do
			local point = v.point
	
			if not v.i then
				v.i = 3
				v.pos = point.Position
			end
	
			if v.i then
				v.i = v.i + 1
				local i = v.i
				local flag = false
				local index = room:GetGridIndex(v.pos)
				local gridpos = Vector(index % width, math.floor(index / width))
	
				if i % 4 == 0 then
					for _, dir in pairs(directions) do
						--local index = index + dir.X*i/4 + dir.Y*width*i/4
						local gridpos = gridpos + dir * i / 4
						local index = gridpos.X + gridpos.Y * width
						if gridpos.X > 0 and gridpos.X < width and gridpos.Y > 0 and gridpos.Y < height then
							local pos2 = room:GetGridPosition(index, 1)
	
							if room:IsPositionInRoom(pos2, 0) then
								local rock = Isaac.Spawn(
									EntityType.ENTITY_EFFECT,
									EffectVariant.ROCK_EXPLOSION,
									0,
									pos2,
									Vector(0, 0),
									point
								)
								room:DestroyGrid(index)
								if not dmgTiles[index] or dmgTiles[index].dmg < v.dmg then
									dmgTiles[index] = v
								end
								flag = true
							end
						end
					end
	
					if not flag then
						points[k] = nil
					end
				end
			end
		end
	
		for k, v in pairs(ents) do
			local dat = dmgTiles[room:GetGridIndex(v.Position)]
			if dat and (v:IsVulnerableEnemy()) then
				v:TakeDamage(
					(v.Type == 1 and 0.5 or dat.dmg * 5 + ply.Damage * 2),
					DamageFlag.DAMAGE_EXPLOSION,
					EntityRef(dat.point),
					2
				)
			end
		end
	end
	
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, onUpdate)
	-----------------------------------------------------------
	--TAINTED FROSTY
	-----------------------------------------------------------
	
	function mod:onTaintedFrostyStart(player)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
			mod:repmGetPData(player).TFrosty_FreezeTimer = 3000
			player:SetPocketActiveItem(mod.RepmTypes.Collectible_BATTERED_LIGHTER, ActiveSlot.SLOT_POCKET, true)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.onTaintedFrostyStart)

	function mod:onTaintedFrostyStart2(player)
		RepMMod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and RepMMod:repmGetPData(player).TFrosty_FreezeTimer == nil then
				RepMMod:repmGetPData(player).TFrosty_FreezeTimer = 3000
			end
		end)
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onTaintedFrostyStart2)
	
	function mod:baseFrostyCache(player, cacheFlag)
		if
			player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B
			or player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C
		then
			local pdata = mod:repmGetPData(player)
			if cacheFlag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck - 3
			end
			if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + 0.15
			end
			if cacheFlag == CacheFlag.CACHE_TEARFLAG and player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_C then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_ICE
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.baseFrostyCache)
	
	function mod:onEnterRoomTFrost()
		local room = game:GetRoom()
		mod:AnyPlayerDo(function(player)
			local pdata = mod:repmGetPData(player)
			if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and not room:IsClear() then
				pdata.TFrosty_Lit = false
				local destPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(10))
				local fire = Isaac.Spawn(33, 1, 0, destPos, Vector(0, 0), nil)
				fire:Die()
				sfx:Stop(SoundEffect.SOUND_FIREDEATH_HISS)
				mod.saveTable.BlizzFade = game:GetFrameCount() + 125
				sfx:Play(mod.RepmTypes.SFX_WIND)
			end
		end)
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onEnterRoomTFrost)
	
	function mod:useBatteredLighter(collectibletype, rng, player, useflags, slot, vardata)
		local fireplaces = Isaac.FindInRadius(player.Position, 150)
		local fireplacesTotal = Isaac.FindByType(33)
		local pdata = mod:repmGetPData(player)
		sfx:Play(mod.RepmTypes.SFX_LIGHTER)
		for i, place in ipairs(fireplacesTotal) do
			if place.Position:Distance(player.Position) < 100 then
				local pos = place.Position
				place:Remove()
				Isaac.Spawn(33, 2, 0, pos, Vector.Zero, nil)
				if pdata.TFrosty_FreezeTimer <= 250 then
					pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 1500
				elseif pdata.TFrosty_FreezeTimer <= 500 then
					pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 1000
				elseif pdata.TFrosty_FreezeTimer <= 1000 then
					pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 500
				else
					pdata.TFrosty_FreezeTimer = pdata.TFrosty_FreezeTimer + 250
				end
				sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
				break
			end
		end
	
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useBatteredLighter, mod.RepmTypes.Collectible_BATTERED_LIGHTER)
	
	function mod:tFrostyClearRoom()
		mod:AnyPlayerDo(function(player)
			local pdata = mod:repmGetPData(player)
			if pdata.TFrosty_Lit == false and player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B then
				pdata.TFrosty_Unlit_Count = math.min((pdata.TFrosty_Unlit_Count or 0) + 1, 5)
				if pdata.TFrosty_Unlit_Count == 4 then
					pdata.TFrosty_Unlit_Count = 5
					pdata.TFrosty_StartPoint = game:GetFrameCount()
					pdata.TFrosty_FreezePoint = game:GetFrameCount() + 7200
					player:AnimateSad()
					player:SetPocketActiveItem(mod.RepmTypes.Collectible_HOLY_LIGHTER, ActiveSlot.SLOT_POCKET, false)
					player:DischargeActiveItem(ActiveSlot.SLOT_POCKET)
				end
			end
			if player:HasCollectible(mod.RepmTypes.Collectible_HOLY_LIGHTER) then
				local rng = player:GetCollectibleRNG(mod.RepmTypes.Collectible_HOLY_LIGHTER)
				if rng:RandomInt(100) < 15 then
					player:SetActiveCharge(
						math.min(12, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 1),
						ActiveSlot.SLOT_POCKET
					)
					sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
				end
			end
		end)
	end
	--mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.tFrostyClearRoom)
	
	function mod:tfrosty_OnNewLevel()
		mod:AnyPlayerDo(function(player)
			if player and player:HasCollectible(mod.RepmTypes.Collectible_HOLY_LIGHTER) then
				local rng = player:GetCollectibleRNG(mod.RepmTypes.Collectible_HOLY_LIGHTER)
				player:SetActiveCharge(
					math.min(12, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 4 + rng:RandomInt(3)),
					ActiveSlot.SLOT_POCKET
				)
				sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
			end
		end)
	end
	--mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.tfrosty_OnNewLevel)

	function mod:useHolyLighter(collectibletype, rng, player, useflags, slot, vardata)
		local pdata = mod:repmGetPData(player)
		local wispcount = 0
		sfx:Play(mod.RepmTypes.SFX_LIGHTER)
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT)
		local Effect =
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 0, player.Position, Vector(0, 0), player)
				:ToEffect()
		Effect:SetDamageSource(EntityType.ENTITY_PLAYER)
		Effect:SetTimeout(300)
		local entities = Isaac:GetRoomEntities()
		for i = 1, #entities do
			local entity = entities[i]
			if
				entity
				and entity.Type == EntityType.ENTITY_FAMILIAR
				and entity.Variant == FamiliarVariant.WISP
				and entity.SubType == mod.RepmTypes.Collectible_HOLY_LIGHTER
			then
				wispcount = wispcount + 1
			end
		end
		if wispcount >= 8 then
			for i = 1, #entities do
				local entity = entities[i]
				if
					entity
					and entity.Type == EntityType.ENTITY_FAMILIAR
					and entity.Variant == FamiliarVariant.WISP
					and entity.SubType == mod.RepmTypes.Collectible_HOLY_LIGHTER
				then
					entity:Remove()
				end
			end
			pdata.TFrosty_FreezeTimer = 3000
			player:ChangePlayerType(Isaac.GetPlayerTypeByName("Tainted Frosty", true))
			player:SetPocketActiveItem(mod.RepmTypes.Collectible_BATTERED_LIGHTER, ActiveSlot.SLOT_POCKET, false)
			player.CanFly = false
		elseif wispcount <= 3 then
			player:AddWisp(mod.RepmTypes.Collectible_HOLY_LIGHTER, player.Position, true, false)
		end
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end
	mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useHolyLighter, mod.RepmTypes.Collectible_HOLY_LIGHTER)
	
	function mod:OnRoomEntryTFrosty()
		local hasIt = false
		mod:AnyPlayerDo(function(player)
			if player:GetPlayerType() == frostType then
				hasIt = true
			end
		end)
	
		if hasIt and game:GetLevel():GetStage() == 13 then
			local roomdesc = game:GetLevel():GetRoomByIdx(game:GetLevel():GetCurrentRoomIndex())
			if
				roomdesc
				and roomdesc.Flags
				and (roomdesc.Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM)
				and not Isaac.GetPersistentGameData():Unlocked(TFrostyUnlockAch)
			then
				if game:GetRoom():IsFirstVisit() then
					local items = Isaac.FindByType(5, 100)
					for i, item in ipairs(items) do
						item:Remove()
					end
					Isaac.Spawn(6, 14, 0, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
				end
	
				local frosties = Isaac.FindByType(6, 14)
				for i, dude in ipairs(frosties) do
					dude:GetSprite():ReplaceSpritesheet(0, "gfx/characters/costumes/character_frosty_b.png")
					dude:GetSprite():LoadGraphics()
				end
			end
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnRoomEntryTFrosty)
	
	function mod:onCollisionSecret_Tainted(player, collider, low)
		if collider.Type == 6 and collider.Variant == 14 and game:GetLevel():GetStage() == 13 then
			Isaac.GetPersistentGameData():TryUnlock(TFrostyUnlockAch)
		end
	end
	mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.onCollisionSecret_Tainted)
	
	function mod:OnTearLaunchTFrosty(tear)
		local player = mod:GetPlayerFromTear(tear)
		if player:GetPlayerType() == mod.RepmTypes.CHARACTER_FROSTY_B and tear.Variant == 0 then
			tear:ChangeVariant(1)
		end
	end
	mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.OnTearLaunchTFrosty)

--#region Saw Shield

local shieldStates = {
	IDLE = 0,
	NO_BOUNCES = 1,
	BOUNCES = 2,
	RETURNING = 3,
	IMPALED = 4
}

---@param player EntityPlayer
---@param cache CacheFlag | integer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cache)
    local num = (player:HasCollectible(mod.RepmTypes.Collectible_SAW_SHIELD) and player:GetData().HoldsSawShield == nil) and 1 or 0
    player:CheckFamiliar(sawShieldFamiliar, num, player:GetCollectibleRNG(mod.RepmTypes.Collectible_SAW_SHIELD), Isaac.GetItemConfig():GetCollectible(mod.RepmTypes.Collectible_SAW_SHIELD))
end, CacheFlag.CACHE_FAMILIARS)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for _, shield in ipairs(Isaac.FindByType(3, sawShieldFamiliar)) do
		shield:ToFamiliar().State = shieldStates.IDLE
		shield:ToFamiliar().FireCooldown = 0
		shield.PositionOffset.Y = 0
		shield.Velocity = Vector.Zero
		shield:GetSprite():Stop()
		
	end
end)

---@param fam EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_,fam)
    fam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    fam:RemoveFromDelayed()
    fam:RemoveFromFollowers()
    fam:RemoveFromOrbit()
    fam.State = shieldStates.IDLE
    fam:GetSprite().PlaybackSpeed = 0
    local d = fam:GetData()
    d.Bounces = 5
    d.CollidesWithEntity = false
    d.Speed = d.Speed or 0
    d.ReturnCooldown = 300
    d.CustomShieldFlags = d.CustomShieldFlags or 0
    d.ThrowPlayer = d.ThrowPlayer or fam.Player
    fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
end, sawShieldFamiliar)

local function CollisionWithEntity(fam)
    return fam:GetData().CollidesWithEntity and 2 or 1
end

---@param shield EntityFamiliar
---@param player any
mod:AddCallback("ON_SAW_SHIELD_UPDATE", function(shield, player)
    if shield.FrameCount % shield:GetDropRNG():RandomInt(2,5) == 0 then
        local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, shield.Position, Vector.Zero, shield):ToEffect()
        eff:GetSprite():Play("SmallBlood0"..eff:GetDropRNG():RandomInt(1, 6), true)
        eff.Timeout = 90
	    eff:SetTimeout(90)
    end
end, TearFlags.TEAR_GISH)

---@param fam EntityFamiliar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
    local d = fam:GetData()
    local player = d.ThrowPlayer or fam.Player
    fam.FireCooldown = math.max(0, fam.FireCooldown - 1)
    if d.CustomShieldFlags > 0 then
        for _,callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_UPDATE")) do
            if callback.Param > 0 and d.CustomShieldFlags & callback.Param > 0 then
                callback.Function(fam, player)
            end
        end
    end
    if fam.State ~= shieldStates.RETURNING and fam.State ~= shieldStates.IMPALED then
        if fam.State ~= shieldStates.BOUNCES then
            d.Speed = math.max(0, d.Speed - 0.15)
			fam.PositionOffset.Y = lerp(fam.PositionOffset.Y, 0, 0.03)
        end
        
		if fam.PositionOffset.Y >= -8 and fam.Velocity:Length() > 10 and (fam.State == shieldStates.NO_BOUNCES or fam.State == shieldStates.BOUNCES) then
			fam.State = shieldStates.IMPALED
			sprite:Play("HitSide", true)
			sfx:Play(mod.RepmTypes.SFX_SAW_SHIELD_CRASH)
			d.Speed = 0
			sprite.Rotation = fam.Velocity:GetAngleDegrees()
			fam.Velocity = Vector.Zero
			fam.PositionOffset.Y = 0
			if d.CustomShieldFlags > 0 then
				for _,callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_CRASH")) do
					if callback.Param > 0 and d.CustomShieldFlags & callback.Param > 0 then
						callback.Function(fam, fam:GetDropRNG(), player)
					end
				end
			end
			return
		end

		if fam.Velocity:Length() < 0.1 then
			d.ReturnCooldown = math.max(0, d.ReturnCooldown - 1)
			if fam.State ~= shieldStates.IDLE then
				fam.State = shieldStates.IDLE
			end
		end
        
        fam.Velocity = fam.Velocity:Resized(d.Speed / CollisionWithEntity(fam))
        sprite.PlaybackSpeed = math.min(1.5, d.Speed)
        if d.Bounces <= 0 and fam.State == shieldStates.BOUNCES then
            fam.State = shieldStates.NO_BOUNCES
        end
        if fam:CollidesWithGrid() then
            if fam.Velocity:Length() > 0.1 then
                SFXManager():Play(mod.RepmTypes.SFX_SAW_SHIELD_BOUNCE, 0.7, 0)
            end
            if d.Bounces > 0 then
                d.Bounces = d.Bounces - 1
            else
                d.Speed = d.Speed * 0.85
            end
        end
        if d.ReturnCooldown <= 0 then
            fam.State = shieldStates.RETURNING
        end
        fam.CollisionDamage = 0.3 * d.Speed
    elseif fam.State == shieldStates.RETURNING then
        local speed = (player.Position - fam.Position):Resized(30)
        fam.Velocity = lerp(fam.Velocity, speed, 0.1)
        fam.PositionOffset.Y = -math.max(0, fam.Velocity:Length())
        fam.CollisionDamage = 0
        fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	elseif sprite:IsFinished("HitSide") then
		fam.State = shieldStates.IDLE
		sprite.Rotation = 0
		sprite:Play(sprite:GetDefaultAnimation(), true)
	end
    d.CollidesWithEntity = false
end, sawShieldFamiliar)

---@param shield EntityFamiliar
---@param sprite Sprite
mod:AddCallback("ON_SAW_SHIELD_RENDER", function(shield, sprite)
    sprite.Color:SetColorize(0, 1, 0, 1.2)
end, TearFlags.TEAR_POISON)

---@param shield EntityFamiliar
mod:AddCallback("ON_SAW_SHIELD_INIT", function(shield)
    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, sawShieldFamiliarFire, 0, shield.Position, Vector.Zero, shield):ToEffect()
    effect.Parent = shield
    effect:FollowParent(shield)
end, TearFlags.TEAR_BURN)

---@param effect EntityEffect
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    local shield = effect.SpawnerEntity
    if not shield or shield:ToFamiliar() and (shield.Variant ~= sawShieldFamiliar or shield:ToFamiliar().State == shieldStates.IMPALED) then
        effect:Remove()
        return
    end
    shield = shield:ToFamiliar()
    effect.SpriteRotation = shield.Velocity:Length() > 0.2 and (shield.Velocity):GetAngleDegrees() or lerp(effect.SpriteRotation, 90, 0.2)
    effect.SpriteScale = Vector(1.5, 1.5)
    effect.DepthOffset = -1
    --effect.SpriteOffset = Vector(0, -5)
end, sawShieldFamiliarFire)

---@param fam EntityFamiliar
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, fam, offset)
	local famSprite = fam:GetSprite()
    local d = fam:GetData()
    if d.CustomShieldFlags and d.CustomShieldFlags > 0 then
        for _,callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_RENDER")) do
            if callback.Param > 0 and d.CustomShieldFlags & callback.Param > 0 then
                callback.Function(fam, famSprite)
            end
        end
    end
end, sawShieldFamiliar)

---@param ent Entity
---@param damage integer
---@param flags DamageFlag | integer
---@param source EntityRef
---@param cd integer
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, cd)
    if source and source.Entity and source.Entity.Type == EntityType.ENTITY_FAMILIAR and source.Entity.Variant == sawShieldFamiliar then
        sfx:Play(mod.RepmTypes.SFX_SAW_SHIELD_DAMAGE, 1, 0)
        local shield = source.Entity:ToFamiliar()
        local player = shield:GetData().ThrowPlayer or shield.Player
        --ent:AddBleeding(source, 30)
        local d = shield:GetData()
        local shlFlags = d.CustomShieldFlags or 0
        local rng = RNG()
        rng:SetSeed(ent.InitSeed, 35)
        if shlFlags > 0 then
            for _,callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_HIT")) do
                if callback.Param > 0 and shlFlags & callback.Param > 0 then
                    callback.Function(ent, rng, shield, player)
                end
            end
            if ent:HasMortalDamage()  then
                for _,callback in ipairs(Isaac.GetCallbacks("ON_SAW_SHIELD_DEATH")) do
                    if callback.Param > 0 and shlFlags & callback.Param > 0 then
                        callback.Function(ent, rng, shield, player)
                    end
                end
            end
        end
    end
end)

mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
    entity:AddPoison(EntityRef(player), 30, player.Damage / 4)
end, TearFlags.TEAR_POISON)

mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
    entity:AddSlowing(EntityRef(player), 30, 0.2, Color(0.3, 0.3, 0.3, 1))
end, TearFlags.TEAR_GISH)

mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
    entity:AddBurn(EntityRef(player), 30, player.Damage / 4)
end, TearFlags.TEAR_BURN)

mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
    entity:AddSlowing(EntityRef(player), 30, 0.5, Color(0.9, 0.9, 0.9, 1))
end, TearFlags.TEAR_SLOW)

mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
    entity:AddMagnetized(EntityRef(player), 30)
end, TearFlags.TEAR_MAGNETIZE)

mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
    entity:AddBleeding(EntityRef(player), 10)
end, TearFlags.TEAR_NEEDLE)

mod:AddCallback("ON_SAW_SHIELD_DEATH", function(entity, rng, shield, player)
    if rng:RandomFloat() <= 0.1 then
        Isaac.Explode(entity.Position, player, 100)
        rng:Next()
    end
end, TearFlags.TEAR_EXPLOSIVE)

mod:AddCallback("ON_SAW_SHIELD_CRASH", function(shield, rng, player)
	player = player or shield.Player
    if rng:RandomFloat() <= 0.1 then
        Isaac.Explode(shield.Position, player, 100)
        rng:Next()
    end
end, TearFlags.TEAR_EXPLOSIVE)

mod:AddCallback("ON_SAW_SHIELD_DEATH", function(entity, rng, shield, player)
    if rng:RandomFloat() <= 0.2 then
        for _, angle in ipairs({0, 90, 180, 270}) do
            local laser = EntityLaser.ShootAngle(LaserVariant.THICK_RED, entity.Position, angle, 30, Vector.FromAngle(angle):Resized(10), player)
            laser.DisableFollowParent = true
        end
        rng:Next()
    end
end, TearFlags.TEAR_BRIMSTONE_BOMB)

mod:AddCallback("ON_SAW_SHIELD_GRID_COLLISION", function(grid, rng, shield, player)
    if rng:RandomFloat() <= 0.2 then
       grid:Destroy(true)
    end
end, TearFlags.TEAR_ACID)


mod:AddCallback("ON_SAW_SHIELD_COLLISION", function(shield, entity)
	if entity:ToProjectile() then
		entity:Die()
	end
end, TearFlags.TEAR_SHIELDED)

---@param fam EntityFamiliar
---@param gridIdx integer
---@param grid GridEntity
---@return boolean | nil
mod:AddCallback(ModCallbacks.MC_FAMILIAR_GRID_COLLISION, function(_, fam, gridIdx, grid)
    if fam.Variant == sawShieldFamiliar then
        if grid and fam.Velocity:Length() > 0.1 and fam.State < shieldStates.RETURNING and fam.State > shieldStates.IDLE then
            if grid:ToPoop() then
                grid:Hurt(4)
            end
			if grid:ToTNT() then
				grid:ToTNT():Destroy()
			end
            if fam:GetData().CustomShieldFlags and fam:GetData().CustomShieldFlags > 0 then
                for _,callback in ipairs(Isaac.GetCallbacks("ON_SAW_SHIELD_GRID_COLLISION")) do
                    if callback.Param > 0 and fam:GetData().CustomShieldFlags & callback.Param > 0 then
                        callback.Function(grid, fam:GetDropRNG(), fam, player)
                    end
                end
            end
        end
    end
end)

---@param fam EntityFamiliar
---@param coll Entity
---@param low boolean
---@return boolean | nil
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, coll, low)
    if coll then
        if coll:ToPlayer() then
            local player = coll:ToPlayer()
            ---@cast player EntityPlayer
            if player:GetHeldEntity() == nil and not player:IsHoldingItem() and player:IsExtraAnimationFinished() and fam.FireCooldown <= 0
			and fam.State ~= shieldStates.IMPALED then
                -- Isaac Rebalanced code part from Mom's Bracelet
                local helper = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GRID_ENTITY_PROJECTILE_HELPER, 0, fam.Position, Vector.Zero, player)
                helper.Parent = player
                local helperSp = helper:GetSprite()
                local famSp = fam:GetSprite()
                player:TryHoldEntity(helper)
                player:GetData().HoldsSawShield = {
                    Type = 3,
                    Variant = sawShieldFamiliar,
                    Frame = famSp:GetFrame()
                }
                helperSp:Load(famSp:GetFilename(), true)
                helperSp:SetFrame(famSp:GetAnimation(), famSp:GetFrame())
                helperSp.PlaybackSpeed = 0
                --helper.PositionOffset = fam.PositionOffset
                for i, layer in ipairs(helperSp:GetAllLayers()) do
                    helperSp:ReplaceSpritesheet(i - 1, layer:GetSpritesheetPath())
                end
                helperSp:LoadGraphics()
                fam:Remove()
                sfx:Play(mod.RepmTypes.SFX_PICKUP_SAW_SHIELD, 0.7, 0)
                return true
            end
        end
        fam:GetData().CollidesWithEntity = coll:IsEnemy() and coll:IsActiveEnemy() and coll:IsVulnerableEnemy() and fam.Velocity:Length() > 0.1
    end
end, sawShieldFamiliar)

---@param fam EntityFamiliar
---@param coll Entity
---@param low boolean
---@return boolean | nil
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, function(_, fam, coll, low)
    if coll then
		if fam:GetData().CustomShieldFlags and fam:GetData().CustomShieldFlags > 0 then
			for _,callback in ipairs(Isaac.GetCallbacks("ON_SAW_SHIELD_COLLISION")) do
				if callback.Param > 0 and fam:GetData().CustomShieldFlags & callback.Param > 0 then
					callback.Function(fam, coll)
				end
			end
		end
    end
end, sawShieldFamiliar)

---@param player EntityPlayer
---@param ent Entity
---@param vel Vector
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_THROW, function(_, player, ent, vel)
    local d = player:GetData().HoldsSawShield
    if d ~= nil and d.Type == EntityType.ENTITY_FAMILIAR and d.Variant == sawShieldFamiliar then
        local shl = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, sawShieldFamiliar, 0, ent.Position, vel, player):ToFamiliar()
        shl.FireCooldown = 40
        local shlData = shl:GetData()
        shl:GetSprite():SetFrame(d.Frame)
        player:GetData().HoldsSawShield = nil
        if vel:Length() > 0.2 then
            shlData.Speed = 25
            shl.State = shieldStates.BOUNCES
        else
            shlData.Speed = vel:Length()
            shl.State = shieldStates.NO_BOUNCES
        end
        shlData.ThrowPlayer = player
        shlData.CustomShieldFlags = 0
        
        if player:HasPlayerForm(PlayerForm.PLAYERFORM_BOB) then
            shlData.CustomShieldFlags = shlData.CustomShieldFlags | TearFlags.TEAR_POISON
        end

        for col, flag in pairs(customShieldFlags) do
            if player:HasCollectible(col) then
                shlData.CustomShieldFlags = shlData.CustomShieldFlags | flag
            end
        end
        if shlData.CustomShieldFlags > 0 then
            for _,callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_INIT")) do
                if callback.Param > 0 and shlData.CustomShieldFlags & callback.Param > 0 then
                    callback.Function(shl)
                end
            end
        end
        shl.PositionOffset = ent.PositionOffset
        ent:Remove()
    end
end)
--#endregion
	
	--mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.onShaderParams)
	----------------------------------------------------------
	--EID, keep this at the bottom!!
	----------------------------------------------------------
	
	if EID then
	EID:addCollectible(mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY, "Spawns two fly orbitals that deflect projectiles#Deflected shots become homing, and freeze any non-boss enemy they touch.", "Frozen Flies" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS, "Friendly Stone Dips will have a 20% chance to spawn out of rocks when they are broken.", "Friendly Rocks" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_NUMB_HEART, "On use, adds 1 frozen heart.", "Numb Heart" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_LIKE, "When Isaac play Like animation add stats.",{{ArrowUp}}, "Like" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BOOK_OF_TAILS, "Guaranteed to create a crawlspace `I am error` room #Lowers the chance of the devil and angel deal.", "book of tails" )
    --EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER, "Leaves fire on the place of the enemy after shooting it long enough.", "PRObackstabber" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PRO_KAMIKAZE, "Spews fire, depending on the number of enemies in the room.", "PROkamikadze" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE, "Upon use, you swing around an axe, dealing damage to enemies.", "Sim's Axe" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART, "On use, spawns almost all types of hearts.", "Curious Heart" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK, "Creates puddles when fired #If an enemy steps on a puddle, he will turn into stone#Bosses get the slowness effect.", "strawberry milk" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_SHELL, "When fully charged, Isaac fires 4 holy beams.", "Holy shell" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET, "Sometimes creates a puddle of holy water under Isaac.", "Leaky Bucket" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH, "Changes your tears into random lasers of tech items # The lasers come with a random modifier, and the lasers change sometimes.", "Delirious tech" )
   -- EID:addCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM, "Gives 5,25 range#Have a chance to shoot a boomerang tear that deals damage to enemies.", "vacuum" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BEEG_MINUS, "Kills player on pick up#Thats litteraly it.", "Minus" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PINK_STRAW, "When used, applies negative effects to enemies.", "Pink straw" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE, "On use, spawns 3 random familiers on 1 room.", "Pixelated cube" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_110V, "Gives 2 charges for the active item, instead of 1#Damages the player when using the active item.", "110V" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE, "Make your tears fragmented.", "Delirium eye" )
    EID:addCollectible(mod.RepmTypes.Collectible_HOLY_OTMICHKA, "There is a chance to create a eternal chest after clearing a room.", "Holy master key" )
    EID:addCollectible(mod.RepmTypes.Collectible_FLOWER_TEA, {{ArrowUp}},"Gives 0.60 damage, 0.50 range#Lowers shot speed by 0.20.", "Flower tea" )
    EID:addCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH, "Gives 1 damage, 5 luck, 0.61 tears, 0.30 speed, lowers shot speed on 0.10, gives flight and spectral tears# kills you in one hit if you got hit.", "Deal of the death" )
    EID:addCollectible(mod.RepmTypes.Collectible_SANDWICH, {{ArrowUp}},"Gives 0.50 damage and 0.09 tears.", "sandwich" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER, "On use, spawns any charmed skeleton enemies.", "Book of necromancer" )    
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_VHS, "Gives the screen a vhs effect for the rest of the run.", "VHS cassette" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_ROT, "When entering a room, the player leaves a poisonous clouds that follows him#Effect last for 6 seconds.", "Rot" )
    EID:addCollectible(mod.RepmTypes.Collectible_BLOODY_NEGATIVE, "On use, removes 1 heart container, but in return it gives +0.15 speed, 0.20 tears, 0.20 damage and range#If you use the active again, the added characteristics are multiplied by 2.", "Bloddy negative" )
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD, "+1 Frozen heart.", "Frozen Food" )
    EID:addCollectible(mod.RepmTypes.Collectible_SIREN_HORNS, "When fully charged, Isaac begins to scream, stunning enemies.", "Siren Horns" )
    EID:addCollectible(mod.RepmTypes.Collectible_HOW_TO_DIG, "Isaac burrows underground with the ability to break stones and doors #Monsters cannot attack him.", "How To Dig" )
    EID:addCollectible(mod.RepmTypes.Collectible_BATTERED_LIGHTER, "Lights fires if Isaac is near him", "Battered Lighter" )
    EID:addCollectible(mod.RepmTypes.Collectible_HOLY_LIGHTER, "Reverse transformation.", "Holy Lighter" )
    EID:addCollectible(Isaac.GetItemIdByName("Portal D6"), "When used, it sucks in all pickups and objects", "Portal D6" )
    EID:addCollectible(Isaac.GetItemIdByName("Portal D6 "), "All items previosly affected Portal D6 will back, but rerolled on another pool of room in this stage", "Portal D6" )
--ru
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_TSUNDERE_FLY, "Создает двух орбитальных мух, которые отражают снаряды.#Отражённые выстрелы становятся самонаводящимися и замораживают любого врага (кроме боссов), которого они касаются.", "Морозные мухи", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_FRIENDLY_ROCKS, "Дружелюбные камни-какашки, могут появится из разрушенных камней с вероятностью 20%.", "Дружелюбные камни", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_NUMB_HEART, "При использовании даёт 1 замороженное сердце.", "Онемевшее сердце", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_LIKE, "Когда Айзек проигрывает 'Like' анимацию дает прибавку к характеристикам.",{{ArrowUp}}, "Лайк", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BOOK_OF_TAILS, "Гарантировано создаёт подполье с комнатой: «Я ошибка». # Снижает вероятность сделки дьявола и ангела.", "Книга сказок", "ru")
    --EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PRO_BACKSTABBER, "Оставляет огонь на месте врага после долгой стрельбы.", "ПРО Предатель", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PRO_KAMIKAZE, "Извергает огонь от Айзека в зависимости от количества врагов в комнате.", "ПРО Камикадзе", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_AXE_ACTIVE, "При использовании вы размахиваете топором.", "Топор Сима", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_CURIOUS_HEART, "При использовании создает почти все типы сердец.", "Любопытное сердце", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_STRAWBERRY_MILK, "Создает лужи при выстреле#Если враг наступит на лужу, то он превратится в камень#Боссы получат эффект замедления", "Клубничное молоко", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_HOLY_SHELL, "При полной зарядке Айзек выпускает 4 святых луча", "Святая оболочка", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_LEAKY_BUCKET, "Иногда создает лужу святой воды под Айзеком.", "Дырявое ведро", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_DELIRIOUS_TECH, "Превращает ваши слезы в случайные лазеры технологий # Лазеры имеют случайный модификатор .", "Технология сумашествия", "ru")
    --EID:addCollectible(mod.RepmTypes.COLLECTIBLE_VACUUM, "Дает дальность 5,25 # Есть шанс выстрелить слезой-бумерангом.", "Вакуум", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BEEG_MINUS, "Убивает игрока при поднятии #Буквально", "Минус", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PINK_STRAW, "При использовании накладывает на врагов отрицательные эффекты.", "Pink straw", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_PIXELATED_CUBE, "При использовании создает 3 случайных фамильяров в 1 комнате.", "Пиксилизированый куб", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_110V, "Заряжает предмет на 2 деления вместо 1#Наносит урон игроку при использовании активного предмета.", "110 Вольт", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_DILIRIUM_EYE, "При подборе дает 1 треснутое сердце {{BrokenHeart}}, и случайный тип слезы со случайным эффектом #{{Warning}}Всего 3 раза{{Warning}} ", "Глаз сумашествия", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_HOLY_OTMICHKA, "Есть шанс создать вечный сундук после зачистки комнаты.", "Святая отмычка", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_FLOWER_TEA, {{ArrowUp}},"Дает 0,60 урона, дальность 0,50 #{{ArrowDown}}, Снижает скорострельность на 0,20.", "Цветочный чай", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_DEAL_OF_THE_DEATH, "Дает 1 к урону, 5 удачи, 0,61 слезы, 0,30 скорости, снижает скорострельность на 0,10, дает полет и призрачные слезы# убивает вас при получении любого урона.", "Сделка со смертью", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_SANDWICH, {{ArrowUp}},"Дает 0,50 урона и 0,09 слез.", "Бутерброд", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_BOOK_OF_NECROMANCER, "При использовании создает дружелюбных скелетов.", "Книга некроманта", "ru")    
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_VHS, "Придает экрану эффект Кассеты до конца забега", "ВХС Кассета", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_ROT, "При входе в комнату игрок оставляет за собой ядовитые облака #Эффект длится 6 секунд.", "Гниль", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_BLOODY_NEGATIVE, "При использовании убирает 1 контейнер сердца, но взамен дает +0,15 скорости, 0,20 слезы, 0,20 урона и дальности действия.#При повторном использовании актива добавленные характеристики умножаются на 2.", "Кровавый минус", "ru")
    EID:addCollectible(mod.RepmTypes.COLLECTIBLE_FROZEN_FOOD, "+1 Лдеяное сердце", "Замороженная еда", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_SIREN_HORNS, "При полной зарядке Айзек начинает кричать, оглушая врагов.", "Рога сирены", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_HOW_TO_DIG, "Айзек закапывается под землю с возможностью ломать камни и двери #Монстры не могут на него напасть.", "Как копать", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_BATTERED_LIGHTER, "Зажигает костры, если Айзек рядом с ним", "Потрепанная зажигалка", "ru")
    EID:addCollectible(mod.RepmTypes.Collectible_HOLY_LIGHTER, "Обратная трансформация", "Святая зажигалка", "ru")
    EID:addCollectible(Isaac.GetItemIdByName("Portal D6"), "При использовании засасывает все пикапы и предметы", "Портальный Д6", "ru")
    EID:addCollectible(Isaac.GetItemIdByName("Portal D6 "), "Все ранее всосанные предметы появятся в этой комнате, но будут переролены в другой предмет другого пула одной из комнат на этаже", "Портальный Д6", "ru")
   
   
--trinkets
    EID:addCollectible(Isaac.GetTrinketIdByName("Pocket Technology"), "Increases damage taken by champion monsters", "Pocket Technology")
    EID:addCollectible(Isaac.GetTrinketIdByName("Micro Amplifier"), "Each new floor adds 1 characteristic #Only 1 characteristic changes", "Micro Amplifier")
    EID:addCollectible(Isaac.GetTrinketIdByName("Frozen Polaroid"), "???", "Frozen Polaroid")
    EID:addCollectible(Isaac.GetTrinketIdByName("Burnt Clover"), "{{Warning}}Disposable{{Warning}}#When entering the treasure room{{TreasureRoom}}, the item is replaced with an item with quality{{Quality4}}", "Burnt Clover")
    EID:addCollectible(Isaac.GetTrinketIdByName("MORE OPTIONS"), "Creates a special item next to goods for 30 cents in the shop{{Shop}}", "MORE OPTIONS")
    EID:addCollectible(Isaac.GetTrinketIdByName("Hammer"), "Аllows you to destroy stones using tears", "Hammer")
--ru
    EID:addCollectible(Isaac.GetTrinketIdByName("Pocket Technology"), "Увеличивает получаемый урон монстрам-чемпионам", "Карманная технология", "ru")
    EID:addCollectible(Isaac.GetTrinketIdByName("Micro Amplifier"), "Каждый новый этаж прибавляет 1 характеристику #Меняется только 1 характеристика", "Микро усилитель", "ru")
    EID:addCollectible(Isaac.GetTrinketIdByName("Frozen Polaroid"), "???", "Замороженный полароид", "ru")
    EID:addCollectible(Isaac.GetTrinketIdByName("Burnt Clover"), "{{Warning}}Одноразовый{{Warning}}#При входе в сокровищницу{{TreasureRoom}} предмет заменяется предметом с качеством{{Quality4}}", "Жженый клевер", "ru")
    EID:addCollectible(Isaac.GetTrinketIdByName("MORE OPTIONS"), "Cоздает рядом с товарами особый предмет за 30 центов в магазине{{Shop}}", "БОЛЬШЕ ОПЦИЙ", "ru")
    EID:addCollectible(Isaac.GetTrinketIdByName("Hammer"), "Позволяет разрушать камни с помощью слез", "Молоточек", "ru")
		local iceHud = Sprite()
		iceHud:Load("gfx/cards_2_icicle.anm2", true)
		EID:addIcon("Card" .. tostring(iceCard), "HUDSmall", 0, 16, 16, 6, 6, iceHud)
	end
	
	local ItemTranslate = include("lua.lib.translation.ItemTranslation")
	ItemTranslate("RepMinus")
	
	local translations = {
		"ru",
	}
	for i = 1, #translations do
		local module = include("lua.lib.translation." .. translations[i])
		module(mod)
	end
	
	--example:
	--EID:addCollectible(id of the item, "description of the item", "item name", "en_us(language)")