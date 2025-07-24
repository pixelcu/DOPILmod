local afterimage = {}

---@param entity Entity
---@param amount integer
function afterimage:DoAfterimage(entity, amount)
	amount = math.max(type(amount) == "number" and math.floor(amount) or 3, 3)
	if type(entity) == "userdata" and entity:GetSprite() then
        ---@cast entity Entity
		Isaac.CreateTimer(function()
			local img = Isaac.Spawn(
				EntityType.ENTITY_EFFECT,
				EffectVariant.DEVIL,
				1,
				entity.Position,
				Vector.Zero,
				entity
			):ToEffect()
            ---@cast img EntityEffect
			img:SetTimeout(2)
			img.Timeout = 2
			img.CollisionDamage = 0
            local sprite = img:GetSprite()
            local entitySprite = entity:GetSprite()
            sprite:Load(entitySprite:GetFilename(), true)
			sprite:SetFrame(entitySprite:GetAnimation(), entitySprite:GetFrame())
            if sprite:IsLoaded() then
                sprite:SetFrame(entitySprite:GetAnimation(), entitySprite:GetFrame())
				sprite:SetOverlayFrame(entitySprite:GetOverlayAnimation(), entitySprite:GetOverlayFrame())
            end
			img.Color = Color(1, 1, 1, 0.5)
		end, 0, amount, false)
	end
end

return afterimage
