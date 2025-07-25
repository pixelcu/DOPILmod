local Mod = RepMMod

local shieldStates = {
	NO_BOUNCES = 0,
	BOUNCES = 1,
	SHREDDING = 2,
	RETURNING = 3,
}

local shieldSpeed = 40
local shieldCooldown = 70

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

function Mod:AddCustomSawShieldFlag(collectible, flag)
	if not customShieldFlags[collectible] then
		customShieldFlags[collectible] = 0
	end
	customShieldFlags[collectible] = customShieldFlags[collectible] | flag
end

--[[-@param player EntityPlayer
---@param cache CacheFlag | integer
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cache)
	local num = (player:HasCollectible(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD) and player:GetData().HoldsSawShield == nil)
			and 1
		or 0
	player:CheckFamiliar(
		Mod.RepmTypes.FAMILIAR_SAW_SHIELD,
		num,
		player:GetCollectibleRNG(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD),
		Mod.ItemConfig:GetCollectible(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD)
	)
end, CacheFlag.CACHE_FAMILIARS)]]

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for _, shield in ipairs(Isaac.FindByType(3, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)) do
		shield:Remove()
	end
end)

---@param fam EntityFamiliar
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
	fam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	fam:RemoveFromDelayed()
	fam:RemoveFromFollowers()
	fam:RemoveFromOrbit()
	fam.State = shieldStates.BOUNCES
	fam:GetSprite().PlaybackSpeed = 0
	local d = fam:GetData()
	d.Bounces = Mod.sawShieldBounces
	fam.FireCooldown = shieldCooldown
	d.Speed = d.Speed or 0
	d.ReturnCooldown = Mod.sawShieldReturnCooldown
	d.CustomShieldFlags = d.CustomShieldFlags or 0
	fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
end, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)

local function CollisionWithEntity(fam)
	return type(fam:GetData().ShreddedEnemy) ~= "nil" and not fam:GetData().ShreddedEnemy:IsDead()
end

---@param shield EntityFamiliar
---@param player any
Mod:AddCallback("ON_SAW_SHIELD_UPDATE", function(shield, player)
	if shield.FrameCount % shield:GetDropRNG():RandomInt(2, 5) == 0 then
		local eff = Isaac.Spawn(
			EntityType.ENTITY_EFFECT,
			EffectVariant.PLAYER_CREEP_BLACK,
			0,
			shield.Position,
			Vector.Zero,
			shield
		):ToEffect()
		eff:GetSprite():Play("SmallBlood0" .. eff:GetDropRNG():RandomInt(1, 6), true)
		eff.Timeout = 90
		eff:SetTimeout(90)
	end
end, TearFlags.TEAR_GISH)

---@param fam EntityFamiliar
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local sprite = fam:GetSprite()
	local d = fam:GetData()
	local player = fam.Player
	fam.FireCooldown = math.max(fam.State == shieldStates.SHREDDING and 0 or shieldCooldown / 2, fam.FireCooldown - 1)
	if d.CustomShieldFlags > 0 then
		for _, callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_UPDATE")) do
			if callback.Param > 0 and d.CustomShieldFlags & callback.Param > 0 then
				callback.Function(fam, player)
			end
		end
	end
	if fam.State ~= shieldStates.RETURNING then
		if CollisionWithEntity(fam) and fam.State ~= shieldStates.SHREDDING then
			fam.State = shieldStates.SHREDDING
		end
		if fam.State == shieldStates.SHREDDING then
			if CollisionWithEntity(fam) and fam.FireCooldown > 0 then
				fam.Position = fam:GetData().ShreddedEnemy.Position
				fam.Velocity = Vector.Zero
			else
				fam.State = shieldStates.RETURNING
			end
			return
		end
		if fam.State ~= shieldStates.BOUNCES then
			d.Speed = math.max(0, d.Speed - 0.15)
			fam.PositionOffset.Y = Mod.Lerp(fam.PositionOffset.Y, 0, 0.03)
		end

		if fam.Velocity:Length() < 0.1 then
			d.ReturnCooldown = math.max(0, d.ReturnCooldown - 1)
		end

		fam.Velocity = fam.Velocity:Resized(d.Speed)
		sprite.PlaybackSpeed = math.min(1.5, d.Speed)
		if d.Bounces <= 0 and fam.State == shieldStates.BOUNCES then
			fam.State = shieldStates.NO_BOUNCES
		end
		if fam:CollidesWithGrid() then
			if fam.Velocity:Length() > 0.1 then
				SFXManager():Play(Mod.RepmTypes.SFX_SAW_SHIELD_BOUNCE, 0.7, 0)
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
	elseif fam.State == shieldStates.RETURNING then
		local speed = (player.Position - fam.Position):Resized(30)
		fam.Velocity = Mod.Lerp(fam.Velocity, speed, 0.1)
		fam.PositionOffset.Y = -math.max(0, fam.Velocity:Length())
		fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	end
	fam.CollisionDamage = (fam.State ~= shieldStates.RETURNING) and player.Damage / 2 or 0
end, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)

---@param shield EntityFamiliar
---@param sprite Sprite
Mod:AddCallback("ON_SAW_SHIELD_RENDER", function(shield, sprite)
	sprite.Color:SetColorize(0, 1, 0, 1.2)
end, TearFlags.TEAR_POISON)

---@param shield EntityFamiliar
Mod:AddCallback("ON_SAW_SHIELD_INIT", function(shield)
	local effect = Isaac.Spawn(
		EntityType.ENTITY_EFFECT,
		Mod.RepmTypes.EFFECT_SAW_SHIELD_FIRE,
		0,
		shield.Position,
		Vector.Zero,
		shield
	):ToEffect()
	effect.Parent = shield
	effect:FollowParent(shield)
end, TearFlags.TEAR_BURN)

---@param effect EntityEffect
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local shield = effect.SpawnerEntity
	if not shield or shield:ToFamiliar() and (shield.Variant ~= Mod.RepmTypes.FAMILIAR_SAW_SHIELD) then
		effect:Remove()
		return
	end
	shield = shield:ToFamiliar()
	effect.SpriteRotation = shield.Velocity:Length() > 0.2 and (shield.Velocity):GetAngleDegrees()
		or Mod.Lerp(effect.SpriteRotation, 90, 0.2)
	effect.SpriteScale = Vector(1.5, 1.5)
	effect.DepthOffset = -1
	--effect.SpriteOffset = Vector(0, -5)
end, Mod.RepmTypes.EFFECT_SAW_SHIELD_FIRE)

---@param fam EntityFamiliar
Mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, fam, offset)
	local famSprite = fam:GetSprite()
	local d = fam:GetData()
	if d.CustomShieldFlags and d.CustomShieldFlags > 0 then
		for _, callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_RENDER")) do
			if callback.Param > 0 and d.CustomShieldFlags & callback.Param > 0 then
				callback.Function(fam, famSprite)
			end
		end
	end
end, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)

---@param ent Entity
---@param damage integer
---@param flags DamageFlag | integer
---@param source EntityRef
---@param cd integer
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, cd)
	if
		source
		and source.Entity
		and source.Entity.Type == EntityType.ENTITY_FAMILIAR
		and source.Entity.Variant == Mod.RepmTypes.FAMILIAR_SAW_SHIELD
	then
		SFXManager():Play(Mod.RepmTypes.SFX_SAW_SHIELD_DAMAGE, 1, 0)
		local shield = source.Entity:ToFamiliar()
		local player = shield.Player
		local d = shield:GetData()
		local shlFlags = d.CustomShieldFlags or 0
		local rng = RNG()
		rng:SetSeed(ent.InitSeed, 35)
		local fullCharge = 0
		local stopCharging = false
		for i = 0, 2 do
			if player:GetActiveItem(i) == Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD then
				if not stopCharging and player:GetActiveCharge(i) < player:GetActiveMaxCharge(i) then
					player:SetActiveCharge(math.min(player:GetActiveCharge(i) + math.ceil(math.min(damage, ent.HitPoints) / 2), player:GetActiveMaxCharge(i)), i)
					stopCharging = true
				end
				fullCharge = player:GetActiveCharge(i)
			end
		end
		if fullCharge >= Mod.ItemConfig:GetCollectible(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD).MaxCharges * player:GetCollectibleNum(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD) then
			source.Entity:ToFamiliar().State = shieldStates.RETURNING
		end
		if shlFlags > 0 then
			for _, callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_HIT")) do
				if callback.Param > 0 and shlFlags & callback.Param > 0 then
					callback.Function(ent, rng, shield, player)
				end
			end
			if ent:HasMortalDamage() then
				for _, callback in ipairs(Isaac.GetCallbacks("ON_SAW_SHIELD_DEATH")) do
					if callback.Param > 0 and shlFlags & callback.Param > 0 then
						callback.Function(ent, rng, shield, player)
					end
				end
			end
		end
		if shield:GetDropRNG():RandomInt(25) == 1 then
			ent:AddBleeding(EntityRef(shield), 150)
		end
	end
end)

Mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
	entity:AddPoison(EntityRef(player), 30, player.Damage / 4)
end, TearFlags.TEAR_POISON)

Mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
	entity:AddSlowing(EntityRef(player), 30, 0.2, Color(0.3, 0.3, 0.3, 1))
end, TearFlags.TEAR_GISH)

Mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
	entity:AddBurn(EntityRef(player), 30, player.Damage / 4)
end, TearFlags.TEAR_BURN)

Mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
	entity:AddSlowing(EntityRef(player), 30, 0.5, Color(0.9, 0.9, 0.9, 1))
end, TearFlags.TEAR_SLOW)

Mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
	entity:AddMagnetized(EntityRef(player), 30)
end, TearFlags.TEAR_MAGNETIZE)

Mod:AddCallback("ON_SAW_SHIELD_HIT", function(entity, rng, shield, player)
	entity:AddBleeding(EntityRef(player), 10)
end, TearFlags.TEAR_NEEDLE)

Mod:AddCallback("ON_SAW_SHIELD_DEATH", function(entity, rng, shield, player)
	if rng:RandomFloat() <= 0.1 then
		Isaac.Explode(entity.Position, player, 100)
		rng:Next()
	end
end, TearFlags.TEAR_EXPLOSIVE)

Mod:AddCallback("ON_SAW_SHIELD_DEATH", function(entity, rng, shield, player)
	if rng:RandomFloat() <= 0.2 then
		for _, angle in ipairs({ 0, 90, 180, 270 }) do
			local laser = EntityLaser.ShootAngle(
				LaserVariant.THICK_RED,
				entity.Position,
				angle,
				30,
				Vector.FromAngle(angle):Resized(10),
				player
			)
			laser.DisableFollowParent = true
		end
		rng:Next()
	end
end, TearFlags.TEAR_BRIMSTONE_BOMB)

Mod:AddCallback("ON_SAW_SHIELD_GRID_COLLISION", function(grid, rng, shield, player)
	if rng:RandomFloat() <= 0.2 then
		grid:Destroy(true)
	end
end, TearFlags.TEAR_ACID)

Mod:AddCallback("ON_SAW_SHIELD_COLLISION", function(shield, entity)
	if entity:ToProjectile() then
		entity:Die()
	end
end, TearFlags.TEAR_SHIELDED)

---@param fam EntityFamiliar
---@param gridIdx integer
---@param grid GridEntity
---@return boolean | nil
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_GRID_COLLISION, function(_, fam, gridIdx, grid)
	if fam.Variant == Mod.RepmTypes.FAMILIAR_SAW_SHIELD then
		if
			grid
			and fam.Velocity:Length() > 0.1
			and fam.State < shieldStates.RETURNING
			and fam.State > shieldStates.NO_BOUNCES
		then
			if grid:ToPoop() then
				grid:Hurt(4)
			end
			if grid:ToTNT() then
				grid:ToTNT():Destroy()
			end
			if fam:GetData().CustomShieldFlags and fam:GetData().CustomShieldFlags > 0 then
				for _, callback in ipairs(Isaac.GetCallbacks("ON_SAW_SHIELD_GRID_COLLISION")) do
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
Mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, coll, low)
	if coll then
		if coll:ToPlayer() then
			local player = coll:ToPlayer()
			---@cast player EntityPlayer
			if
				player:GetHeldEntity() == nil
				and not player:IsHoldingItem()
				and player:IsExtraAnimationFinished()
				and (fam.Velocity:Length() <= 0.1 or fam.State == shieldStates.RETURNING)
			then
				player:AnimateCollectible(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD, "UseItem", "PlayerPickup")
				fam:Remove()
				SFXManager():Play(Mod.RepmTypes.SFX_PICKUP_SAW_SHIELD, 0.7, 0)
				return true
			end
		end
		if coll:IsEnemy() and coll:IsActiveEnemy() and coll:IsVulnerableEnemy() and fam.Velocity:Length() > 0.1
		and type(fam:GetData().ShreddedEnemy) == "nil" then
			fam:GetData().ShreddedEnemy = coll
			
		end
	end
end, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)

---@param fam EntityFamiliar
---@param coll Entity
---@param low boolean
---@return boolean | nil
Mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, function(_, fam, coll, low)
	if coll then
		if fam:GetData().CustomShieldFlags and fam:GetData().CustomShieldFlags > 0 then
			for _, callback in ipairs(Isaac.GetCallbacks("ON_SAW_SHIELD_COLLISION")) do
				if callback.Param > 0 and fam:GetData().CustomShieldFlags & callback.Param > 0 then
					callback.Function(fam, coll)
				end
			end
		end
	end
end, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)

---@param collectible CollectibleType | integer
---@param rng RNG
---@param player EntityPlayer
---@param flags UseFlag | integer
---@param slot ActiveSlot | integer
---@param cvardata integer
---@return boolean | table?
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player, flags, slot, cvardata)
	if flags & UseFlag.USE_CARBATTERY > 0 then
		return { Discharge = false, Remove = false, ShowAnim = false }
	end
	for _, shield in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, Mod.RepmTypes.FAMILIAR_SAW_SHIELD)) do
		shield = shield:ToFamiliar()
		if GetPtrHash(shield.Player) == GetPtrHash(player)
		and shield.State ~= shieldStates.RETURNING and shield.FireCooldown <= shieldCooldown / 2 then
			if CollisionWithEntity(shield) then
				shield:GetData().ShreddedEnemy:TakeDamage(player.Damage * 3, 0, EntityRef(player), 0)
			end
			shield.State = shieldStates.RETURNING
		end
		return { Discharge = false, Remove = false, ShowAnim = false }
	end
	if player:GetItemState() == collectible then
		player:ResetItemState()
		player:GetData().ShieldWaitFrames = 0
		player:GetData().UsedSlot = -1
		player:AnimateCollectible(collectible, "HideItem", "PlayerPickup")
	elseif player:GetItemState() == 0 then
		player:SetItemState(collectible)
		player:GetData().ShieldWaitFrames = 20
		player:GetData().UsedShieldSlot = slot
		SFXManager():Play(Mod.RepmTypes.SFX_PICKUP_SAW_SHIELD, 0.7, 0)
		player:AnimateCollectible(collectible, "LiftItem", "PlayerPickup")
	end
	local sprite = player:GetHeldSprite()
	sprite:Load("gfx/shieldsaw.anm2", true)
	sprite:SetFrame("FloatShootSide", 0)
	sprite:Stop()
	return { Discharge = false, Remove = false, ShowAnim = false }
end, Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD)

---@param player EntityPlayer
---@param slot ActiveSlot | integer
---@param direction Vector
---@param doDash boolean
local function ShieldThrowDash(player, slot, direction, doDash)
	if doDash or slot == -1 then
		player.Velocity = player:GetAimDirection():Resized(40)
		player:DischargeActiveItem(slot)
	else
		local shl = Isaac.Spawn(
			EntityType.ENTITY_FAMILIAR,
			Mod.RepmTypes.FAMILIAR_SAW_SHIELD,
			0,
			player.Position,
			direction + player:GetMovementVector():Resized(0.3),
			player
		):ToFamiliar()
		local shlData = shl:GetData()

		shlData.Speed = shieldSpeed
		shl.State = shieldStates.BOUNCES

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
			for _, callback in pairs(Isaac.GetCallbacks("ON_SAW_SHIELD_INIT")) do
				if callback.Param > 0 and shlData.CustomShieldFlags & callback.Param > 0 then
					callback.Function(shl)
				end
			end
		end
		shl.PositionOffset = Vector(0, -25 * player.SpriteScale.Y) --ent.PositionOffset
	end
end

Mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, function(_, slot, player, currentMin)
	return 0
end, Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD)

---@param player EntityPlayer
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local d = player:GetData()
	if not d.ShieldWaitFrames then
		d.ShieldWaitFrames = 0
	end
	d.ShieldWaitFrames = math.max(0, d.ShieldWaitFrames - 1)
	if player:GetItemState() == Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD and d.ShieldWaitFrames <= 0 then
		local idx = player.ControllerIndex
		local left = Input.GetActionValue(ButtonAction.ACTION_SHOOTLEFT, idx)
		local right = Input.GetActionValue(ButtonAction.ACTION_SHOOTRIGHT, idx)
		local up = Input.GetActionValue(ButtonAction.ACTION_SHOOTUP, idx)
		local down = Input.GetActionValue(ButtonAction.ACTION_SHOOTDOWN, idx)
		local mouseclick = Input.IsMouseBtnPressed(MouseButton.LEFT)
		local marked = player:GetMarkedTarget()
		if left > 0 or right > 0 or down > 0 or up > 0 or mouseclick or marked then
			local angle
			local reverse = false
			if marked then
				angle = (marked.Position - player.Position):Normalized():GetAngleDegrees()
			elseif mouseclick then
				angle = (Input.GetMousePosition(true) - player.Position):Normalized():GetAngleDegrees()
			else
				angle = Vector(right - left, down - up):Normalized():GetAngleDegrees()
				reverse = true
			end
			local shootVector = Vector.FromAngle(angle)
			if (Mod.Room():IsMirrorWorld() or StageAPI and StageAPI.IsMirrorDimension()) and reverse then
				shootVector = Vector(shootVector.X * -1, shootVector.Y)
			end
			d.ShieldWaitFrames = 0
			local config = Mod.ItemConfig
			local confItem = config:GetCollectible(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD)

			ShieldThrowDash(
				player,
				d.UsedShieldSlot,
				shootVector,
				player:GetActiveCharge(d.UsedShieldSlot) >= confItem.MaxCharges
			)
			--[[if player:HasTrinket(TrinketType.TRINKET_BUTTER) then
			local col = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
				if col > 0 then
					local dropCharge = Helpers.GetCharge(player, ActiveSlot.SLOT_PRIMARY)
					player:RemoveCollectible(col, false, ActiveSlot.SLOT_PRIMARY, false)
					local room = Game():GetRoom()
					local pos = room:FindFreePickupSpawnPosition(player.Position , 40)
					local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, col, pos, Vector.Zero, nil):ToPickup()
					pickup.Touched = true
					pickup.Charge = dropCharge
				end
			end]]

			player:ResetItemState()
			player:AnimateCollectible(Mod.RepmTypes.COLLECTIBLE_SAW_SHIELD, "HideItem", "PlayerPickup")
		end
	end
end, PlayerVariant.PLAYER)
