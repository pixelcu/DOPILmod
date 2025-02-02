local mod = RepMMod

local lightSprite = Sprite("gfx/trafficlight.anm2", true)
lightSprite:Play("GreenLight", true)

local function trafficRender()
	if Isaac.GetChallenge() == mod.RepmChallenges.CHALLENGE_TRAFFIC_LIGHT
    and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT
	and mod.saveTable.RedLightSign ~= nil then
		if lightSprite:GetAnimation() ~= mod.saveTable.RedLightSign then
			lightSprite:Play(mod.saveTable.RedLightSign)
		end
		local horiz, vert = Isaac.GetScreenWidth() / 2, Isaac.GetScreenHeight() * 0.05
		if not RoomTransition.IsRenderingBossIntro() then
			lightSprite:Render(Vector(horiz, vert) + Vector(0, 12) * Options.HUDOffset)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, trafficRender)

--local saveTimer

local function IsMoving(player)
	local index = player.ControllerIndex
	return Input.IsActionPressed(ButtonAction.ACTION_LEFT, index)
		or Input.IsActionPressed(ButtonAction.ACTION_RIGHT, index)
		or Input.IsActionPressed(ButtonAction.ACTION_UP, index)
		or Input.IsActionPressed(ButtonAction.ACTION_DOWN, index)
end

local function changeLights()
	if Isaac.GetChallenge() == mod.RepmChallenges.CHALLENGE_TRAFFIC_LIGHT  then
		if not mod.saveTable.saveTimer then
			mod.saveTable.saveTimer = mod.RNG:RandomInt(1350) + 300
			mod.saveTable.RedLightSign = "GreenLight"
		end
		if mod.saveTable.saveTimer <= 0 then
			if mod.saveTable.RedLightSign == "RedLight" then
				mod.saveTable.saveTimer = mod.RNG:RandomInt(1350) + 300
				mod.saveTable.RedLightSign = "GreenLight"
				SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 2)
			elseif mod.saveTable.RedLightSign == "YellowLight" then
				mod.saveTable.saveTimer = mod.RNG:RandomInt(300) + 30
				mod.saveTable.RedLightSign = "RedLight"
				SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 2)
			else
				mod.saveTable.saveTimer = 30
				mod.saveTable.RedLightSign = "YellowLight" --SOUND_TOOTH_AND_NAIL_TICK
				SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 2)
			end
		elseif Game():GetRoom():GetAliveEnemiesCount() > 0 then
			mod.saveTable.saveTimer = mod.saveTable.saveTimer - 1
		else
			if mod.saveTable.RedLightSign == "YellowLight"
			or mod.saveTable.saveTimer < 90 and mod.saveTable.RedLightSign == "GreenLight" then
				mod.saveTable.saveTimer = 90
				if mod.saveTable.RedLightSign == "YellowLight" then
					SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 2)
				end
				mod.saveTable.RedLightSign = "GreenLight"
			elseif mod.saveTable.RedLightSign == "RedLight" then
				mod.saveTable.saveTimer = mod.saveTable.saveTimer - 4
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, changeLights)

---@param player EntityPlayer
local function LightPlayer(_, player)
	if Isaac.GetChallenge() ~= mod.RepmChallenges.CHALLENGE_TRAFFIC_LIGHT then
		return
	end
    local pdata = mod:GetData(player)
    if mod.saveTable.RedLightSign == "RedLight" then
		if IsMoving(player) 
		and player:GetDamageCountdown() <= 0 then
			pdata.RedLightDamage = true
			player:TakeDamage(1, DamageFlag.DAMAGE_COUNTDOWN, EntityRef(player), 4)
		end
    else
		pdata.RedLightDamage = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, LightPlayer, PlayerVariant.PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, cd)
	local player = ent:ToPlayer()
	if mod:GetData(player).RedLightDamage and flags & DamageFlag.DAMAGE_COUNTDOWN ~= 0 then
		mod:GetData(player).RedLightDamage = nil
		player:ResetDamageCooldown()
		player:SetMinDamageCooldown(20)
	end
end, EntityType.ENTITY_PLAYER)