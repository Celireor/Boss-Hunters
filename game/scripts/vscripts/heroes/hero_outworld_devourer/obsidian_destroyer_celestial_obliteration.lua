obsidian_destroyer_celestial_obliteration = class({})

function obsidian_destroyer_celestial_obliteration:GetAOERadius()
	return self:GetTalentSpecialValueFor("radius")
end

function obsidian_destroyer_celestial_obliteration:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse.Cast", caster)
	local vTarget = self:GetCursorPosition()
	local radius = self:GetTalentSpecialValueFor("radius")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), vTarget, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if caster:HasScepter() then
		local imprison = caster:FindAbilityByName("obsidian_destroyer_astral_imprisonment_ebf")
		for _,enemy in pairs(enemies) do
			caster:SetCursorCastTarget(enemy)
			imprison:OnSpellStart()
		end
		caster:CalculateStatBonus()
	end
	if caster:HasTalent("special_bonus_unique_obsidian_destroyer_celestial_obliteration_2") do
		local tDur = caster:FindTalentValue("special_bonus_unique_obsidian_destroyer_celestial_obliteration_2", "duration")
		for i = 0, 18 do
			local ability = caster:GetAbilityByIndex(i)
			if ability and ability ~= self then
				ability:Refresh()
			end
		end
		caster:AddNewModifier(caster, self, "modifier_obsidian_destroyer_celestial_obliteration_talent", {duration = tDur})
	end
	local intDamage = self:GetTalentSpecialValueFor("damage_multiplier") * caster:GetIntellect()
	for _,enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = caster, damage = intDamage, damage_type = self:GetAbilityDamageType(), ability = self})
		enemy:AddNewModifier(caster, self, "modifier_obsidian_destroyer_celestial_obliteration_mindbreak", {duration = self:GetTalentSpecialValueFor("debuff_duration")})
	end
	local eclipse = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(eclipse, 0, vTarget)
	ParticleManager:SetParticleControl(eclipse, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(eclipse, 2, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(eclipse, 3, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(eclipse)
	EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse", caster)
end

LinkLuaModifier( "modifier_obsidian_destroyer_celestial_obliteration_mindbreak", "lua_abilities/heroes/obsidian_destroyer.lua" ,LUA_MODIFIER_MOTION_NONE )
modifier_obsidian_destroyer_celestial_obliteration_mindbreak = class({})

function modifier_obsidian_destroyer_celestial_obliteration_mindbreak:OnCreated()
	if IsServer() then
		EmitSoundOn("DOTA_Item.SilverEdge.Target", self:GetParent())
		EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", self:GetParent())
	end
end

function modifier_obsidian_destroyer_celestial_obliteration_mindbreak:GetEffectName()
	return "particles/obsidian_mindbreak.vpcf"
end

function modifier_obsidian_destroyer_celestial_obliteration_mindbreak:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
	return state
end

LinkLuaModifier( "modifier_obsidian_destroyer_celestial_obliteration_mindbreak", "lua_abilities/heroes/obsidian_destroyer.lua" ,LUA_MODIFIER_MOTION_NONE )
modifier_obsidian_destroyer_celestial_obliteration_mindbreak = class({})