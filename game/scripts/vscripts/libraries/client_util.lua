function GetClientSync(key)
	local value = CustomNetTables:GetTableValue( "syncing_purposes", key).value
	return value
end

function MergeTables( t1, t2 )
    for name,info in pairs(t2) do
		if type(info) == "table"  and type(t1[name]) == "table" then
			MergeTables(t1[name], info)
		else
			t1[name] = info
		end
	end
end

function AddTableToTable( t1, t2)
	for k,v in pairs(t2) do
		table.insert(t1, v)
	end
end

function TernaryOperator(value, bCheck, default)
	if bCheck then 
		return value 
	else 
		return default
	end
end

function GetTableLength(rndTable)
	local counter = 0
	for k,v in pairs(rndTable) do
		counter = counter + 1
	end
	return counter
end

function PrintAll(t)
	for k,v in pairs(t) do
		print(k,v)
	end
end

AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
MergeTables(AbilityKV, LoadKeyValues("scripts/npc/npc_abilities_override.txt"))
MergeTables(AbilityKV, LoadKeyValues("scripts/npc/npc_items_custom.txt"))
MergeTables(AbilityKV, LoadKeyValues("scripts/npc/items.txt"))
UnitKV = LoadKeyValues("scripts/npc/npc_heroes.txt")
MergeTables(UnitKV, LoadKeyValues("scripts/npc/npc_heroes_custom.txt"))

function C_DOTA_BaseNPC:IsSameTeam(unit)
	return (self:GetTeamNumber() == unit:GetTeamNumber())
end

function C_DOTA_BaseNPC:GetThreat()
	local data = CustomNetTables:GetTableValue("hero_properties", unit:GetUnitName()..unit:entindex() ) or {}
	local threat = data.threat or 0
	return self.threat
end

function C_DOTA_BaseNPC:HasTalent(talentName)
	local data = CustomNetTables:GetTableValue("talents", tostring(self:entindex())) or {}
	if data and data[talentName] then
		return true 
	end
	return false
end

function C_DOTA_BaseNPC:FindTalentValue(talentName, valname)
	local value = valname or "value"
	if self:HasTalent(talentName) and AbilityKV[talentName] then  
		local specialVal = AbilityKV[talentName]["AbilitySpecial"]
		for l,m in pairs(specialVal) do
			if m[value] then
				return m[value]
			end
		end
	end    
	return 0
end

function C_DOTABaseAbility:GetAbilityTextureName()
	if AbilityKV[self:GetName()] and AbilityKV[self:GetName()]["AbilityTextureName"] then
		return AbilityKV[self:GetName()]["AbilityTextureName"]
	end
	return nil
end

function C_DOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = AbilityKV[self:GetName()]["AbilitySpecial"]
	local valname = "value"
	local multiply = false
	if kv then
		for k,v in pairs(kv) do -- trawl through keyvalues
			if v[value] then
				talentName = v["LinkedSpecialBonus"]
				if v["LinkedSpecialBonusField"] then valname = v["LinkedSpecialBonusField"] end
				if v["LinkedSpecialBonusOperation"] and v["LinkedSpecialBonusOperation"] == "SPECIAL_BONUS_MULTIPLY" then multiply = true end
				break
			end
		end
	end
	if talentName and self:GetCaster():HasTalent(talentName) then 
		if multiply then
			base = base * self:GetCaster():FindTalentValue(talentName, valname) 
		else
			base = base + self:GetCaster():FindTalentValue(talentName, valname) 
		end
	end
	return base
end

function C_DOTA_BaseNPC:HealDisabled()
	if self:HasModifier("Disabled_silence") or 
		 self:HasModifier("primal_avatar_miss_aura") or 
		 self:HasModifier("modifier_reflection_invulnerability") or 
		 self:HasModifier("modifier_elite_burning_health_regen_block") or 
		 self:HasModifier("modifier_elite_entangling_health_regen_block") or 
		 self:HasModifier("modifier_plague_damage") or 
		 self:HasModifier("modifier_rupture_datadriven") or 
		 self:HasModifier("fire_aura_debuff") or 
		 self:HasModifier("item_sange_and_yasha_4_debuff") or 
		 self:HasModifier("cursed_effect") then
	return true
	else return false end
end

function C_DOTA_Modifier_Lua:GetSpecialValueFor(specVal)
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor(specVal)
	end
	return 0
end

function C_DOTA_Modifier_Lua:GetTalentSpecialValueFor(specVal)
	return self:GetAbility():GetTalentSpecialValueFor(specVal)
end

function C_DOTA_Modifier_Lua:AddIndependentStack()
	if self:GetStackCount() == 0 then self:GetStackCount(1)
	else self:IncrementStackCount() end
end


function C_DOTA_BaseNPC:GetStrength()
	local netTable = CustomNetTables:GetTableValue("hero_properties", self:GetUnitName()..self:entindex())
	if netTable and netTable.strength then return  math.floor(tonumber(netTable.strength)) end
	return 0
end

function C_DOTA_BaseNPC:GetIntellect()
	local netTable = CustomNetTables:GetTableValue("hero_properties", self:GetUnitName()..self:entindex())
	if netTable and netTable.intellect then return  math.floor(tonumber(netTable.intellect)) end
	return 0
end

function C_DOTA_BaseNPC:GetAgility()
	local netTable = CustomNetTables:GetTableValue("hero_properties", self:GetUnitName()..self:entindex())
	if netTable and netTable.agility then return math.floor(tonumber(netTable.agility)) end
	return 0
end

function C_DOTA_BaseNPC:GetPrimaryAttribute()
	if UnitKV[self:GetUnitName()] then
		attribute = UnitKV[self:GetUnitName()]["AttributePrimary"]
		if attribute then
			if attribute == "DOTA_ATTRIBUTE_STRENGTH" then
				return DOTA_ATTRIBUTE_STRENGTH
			elseif attribute == "DOTA_ATTRIBUTE_INTELLECT" then
				return DOTA_ATTRIBUTE_INTELLECT
			elseif attribute == "DOTA_ATTRIBUTE_AGILITY" then
				return DOTA_ATTRIBUTE_AGILITY
			end
		end
	end
	return -1
end

function C_DOTA_BaseNPC:GetPrimaryStatValue()
	local nPrim = self:GetPrimaryAttribute()
	if nPrim == DOTA_ATTRIBUTE_STRENGTH then
		return self:GetStrength()
	elseif nPrim == DOTA_ATTRIBUTE_AGILITY then
		return self:GetAgility()
	elseif nPrim == DOTA_ATTRIBUTE_INTELLECT then
		return self:GetIntellect()
	end
	return 0
end

function C_DOTA_BaseNPC:GetIllusionOwnerEntindex()
	if self:HasModifier("modifier_illusion_tag") then
		return self:GetModifierStackCount("modifier_illusion_tag", self)
	else
		error("Not an illusion!")
	end
end

function C_DOTA_BaseNPC:InWater()
	return self:HasModifier("modifier_in_water")
end

function C_DOTA_BaseNPC:IsRoundBoss()
	return self:HasModifier("modifier_boss_evasion")
end

function C_BaseEntity:RollPRNG( percentage )
	local internalInt = (100/percentage)
	local startingRoll = internalInt^2
	self.internalPRNGCounter = self.internalPRNGCounter or (1/internalInt)^2
	if RollPercentage(self.internalPRNGCounter * 100) then
		self.internalPRNGCounter = (1/internalInt)^2
		return true
	else
		local internalCount = 1/self.internalPRNGCounter
		self.internalPRNGCounter = 1/( math.max(internalCount - internalInt, 1) )
		return false
	end
end

function C_DOTA_Ability_Lua:RollPRNG( percentage )
	local internalInt = (100/percentage)
	local startingRoll = internalInt^2
	self.internalPRNGCounter = self.internalPRNGCounter or (1/internalInt)^2
	if RollPercentage(self.internalPRNGCounter * 100) then
		self.internalPRNGCounter = (1/internalInt)^2
		return true
	else
		local internalCount = 1/self.internalPRNGCounter
		self.internalPRNGCounter = 1/( math.max(internalCount - internalInt, 1) )
		return false
	end
end

function RollPercentage( percentage )
	return RandomInt(1, 100) <= percentage
end

function C_DOTA_Modifier_Lua:RollPRNG( percentage )
	local internalInt = (100/percentage)
	local startingRoll = internalInt^2
	self.internalPRNGCounter = self.internalPRNGCounter or (1/internalInt)^2
	if RollPercentage(self.internalPRNGCounter * 100) then
		self.internalPRNGCounter = (1/internalInt)^2
		return true
	else
		local internalCount = 1/self.internalPRNGCounter
		self.internalPRNGCounter = 1/( math.max(internalCount - internalInt, 1) )
		return false
	end
end