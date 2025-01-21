local mod = RepMMod

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	mod:AnyPlayerDo(function(player)
		local pData = mod:repmGetPData(player)
		pData.RepSSDamageBoost = nil
		pData.RepSSDamageD = nil
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_COLOR, true)
	end)
end)

---@param player EntityPlayer
---@param cache CacheFlag | integer
local function StrongSpiritCache(_, player, cache)
	local pdata = mod:repmGetPData(player)
	if pdata.RepSSDamageBoost ~= nil and pdata.RepSSDamageBoost >= 0 then
		if cache == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + (5 / 600 * pdata.RepSSDamageBoost)
		elseif cache == CacheFlag.CACHE_COLOR then
			local col = player.Color
			col.BO = (1 / 600 * pdata.RepSSDamageBoost)
			player.Color = col
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, StrongSpiritCache)

local function StrongSpiritUpdate(_, player)
	local pdata = mod:repmGetPData(player)
	if pdata.RepSSDamageBoost ~= nil and pdata.RepSSDamageBoost >= 0 then
		pdata.RepSSDamageBoost = pdata.RepSSDamageBoost - 1
		if pdata.RepSSDamageBoost == 0 then
			pdata.RepSSDamageBoost = nil
		end
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_COLOR, true)
	end
	if player:HasCollectible(mod.RepmTypes.COLLECTIBLE_STRONG_SPIRIT, true) then
		local data = mod:GetData(player)
		if data.StrongSpiritSS == nil then
			data.StrongSpiritSS = setmetatable({
				Render = function(self, pos, crop_min, crop_max)
					crop_min = crop_min or Vector.Zero
					crop_max = crop_max or Vector.Zero
					self.spr:Update()
					if self.spr:IsFinished("Fade") then
						return
					end
					if self.Damage == true then
						if not self.spr:IsPlaying("Fade") then
							self.spr:Play("Fade", true)
						end
					elseif not self.spr:IsPlaying("Idle") then
						self.spr:Play("Idle", true)
					end
					if Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
						self.spr:Render(pos, crop_min, crop_max)
					end
				end,
			}, {
				__call = function(self)
					local c = setmetatable({
						Damage = false,
						spr = Sprite("gfx/SSStatus.anm2", true),
					}, { __index = self })
					return c
				end,
			})()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, StrongSpiritUpdate)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, amount, DamageFlag)
	player = player:ToPlayer()
	---@cast player EntityPlayer
	if
		player:GetHearts() + player:GetBoneHearts() + player:GetSoulHearts() + player:GetRottenHearts() <= amount
		and player:HasCollectible(mod.RepmTypes.COLLECTIBLE_STRONG_SPIRIT, true)
	then
		local Data = mod:repmGetPData(player)
		if
			Data == nil
			or Data.RepSSDamaged
		then
			return
		end
		Data.RepSSDamaged = true
		--Data.StrongSpiritSS.Sprite:Play("Damaged", true)
		Game():ShakeScreen(50)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, false, false, true, false, -1, 0)
		player:AddHearts(4)
		player:AddSoulHearts(2)
		Data.RepSSDamageBoost = 600
		Data.RepSSDamaged = true
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_COLOR, true)
		--print(Data.RepSSDamageBoost)
		return false
	end
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
	local Data = mod:GetData(player)
	local pData = mod:repmGetPData(player)
	if Data ~= nil and Data.StrongSpiritSS ~= nil and pData.RepSSDamageBoost then
		Data.StrongSpiritSS:Render(Isaac.WorldToScreen(player.Position))
	end
end)
