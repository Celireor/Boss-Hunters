--[[
Broodking AI
]]

require( "ai/ai_core" )

-- function Spawn( entityKeyValues )
	-- thisEntity:SetContextThink( "AIThinker", AIThink, 1 )
	-- thisEntity.density = thisEntity:FindAbilityByName("boss_aether_neutron_density")
	-- thisEntity.well = thisEntity:FindAbilityByName("boss_aether_gravity_well")
	-- thisEntity.shift = thisEntity:FindAbilityByName("boss_aether_phase_shift")
	
	-- thisEntity.wormhole = thisEntity:FindAbilityByName("boss_aether_wormhole")
	-- thisEntity.meteor = thisEntity:FindAbilityByName("boss_aether_meteor_shower")
	-- thisEntity.rift = thisEntity:FindAbilityByName("boss_aether_space_rift")
	-- thisEntity.pool = thisEntity:FindAbilityByName("boss_aether_entropy_pool")
	-- thisEntity.mass = thisEntity:FindAbilityByName("boss_aether_mass_effect")
	-- thisEntity.horizon = thisEntity:FindAbilityByName("boss_aether_event_horizon")
	
	-- Timers:CreateTimer(0.1, function()
		-- if  math.floor(GameRules.gameDifficulty + 0.5) < 2 then 
			-- thisEntity.density:SetLevel(1)
			-- thisEntity.well:SetLevel(1)
			-- thisEntity.shift:SetLevel(1)
			
			-- thisEntity.wormhole:SetLevel(1)
			-- thisEntity.meteor:SetLevel(1)
			-- thisEntity.rift:SetLevel(1)
			-- thisEntity.pool:SetLevel(1)
			-- thisEntity.mass:SetLevel(1)
			-- thisEntity.horizon:SetLevel(1)
		-- elseif  math.floor(GameRules.gameDifficulty + 0.5) > 2 and  math.floor(GameRules.gameDifficulty + 0.5) <= 4 then 
			-- thisEntity.density:SetLevel(2)
			-- thisEntity.well:SetLevel(2)
			-- thisEntity.shift:SetLevel(2)
			
			-- thisEntity.wormhole:SetLevel(2)
			-- thisEntity.meteor:SetLevel(2)
			-- thisEntity.rift:SetLevel(2)
			-- thisEntity.pool:SetLevel(2)
			-- thisEntity.mass:SetLevel(2)
			-- thisEntity.horizon:SetLevel(2)
			
			-- thisEntity:SetBaseMaxHealth(thisEntity:GetMaxHealth()*1.5)
			-- thisEntity:SetMaxHealth(thisEntity:GetMaxHealth()*1.5)
			-- thisEntity:SetHealth(thisEntity:GetMaxHealth())
		-- end
	-- end)
-- end


-- function AIThink()
	-- if not thisEntity:IsDominated() and not thisEntity:IsChanneling() then
		-- local target = AICore:GetHighestPriorityTarget(thisEntity)
		-- if thisEntity.wormhole:IsFullyCastable() and AICore:TotalEnemyHeroesInRange( thisEntity, thisEntity:GetAttackRange() ) == 0 then
			-- if target and not target:IsNull() then
				-- ExecuteOrderFromTable({
					-- UnitIndex = thisEntity:entindex(),
					-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					-- Position = target:GetAbsOrigin() + ActualRandomVector(900, 200),
					-- AbilityIndex = thisEntity.wormhole:entindex()
				-- })
				-- return 0.25
			-- end
		-- elseif thisEntity.wormhole:IsFullyCastable() and AICore:TotalEnemyHeroesInRange( thisEntity, thisEntity:GetAttackRange() ) < 2  and RollPercentage(20) then
			-- local target = AICore:GetHighestPriorityTarget(thisEntity)
			-- if target then
				-- ExecuteOrderFromTable({
					-- UnitIndex = thisEntity:entindex(),
					-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					-- Position = target:GetAbsOrigin() + ActualRandomVector(900, 200),
					-- AbilityIndex = thisEntity.wormhole:entindex()
				-- })
				-- return 0.25
			-- end
		-- end
		-- if thisEntity.horizon:IsFullyCastable() and AICore:TotalEnemyHeroesInRange( thisEntity, thisEntity.horizon:GetTalentSpecialValueFor("radius") * 2 ) > 0 and RollPercentage(80) then
			-- if thisEntity.wormhole:IsFullyCastable() and RollPercentage(50) then -- teleport away
				-- ExecuteOrderFromTable({
					-- UnitIndex = thisEntity:entindex(),
					-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					-- Position = thisEntity:GetAbsOrigin() + ActualRandomVector(1200, 500),
					-- AbilityIndex = thisEntity.wormhole:entindex()
				-- })
				-- return 0.25
			-- else -- stand still
				-- ExecuteOrderFromTable({
					-- UnitIndex = thisEntity:entindex(),
					-- OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					-- AbilityIndex = thisEntity.horizon:entindex()
				-- })
				-- return 2
			-- end
		-- end
		-- if thisEntity.pool:IsFullyCastable() and AICore:TotalEnemyHeroesInRange( thisEntity, thisEntity.pool:GetTalentSpecialValueFor("pool_spawn_range") ) > 0 and RollPercentage(50) then
			-- ExecuteOrderFromTable({
				-- UnitIndex = thisEntity:entindex(),
				-- OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				-- AbilityIndex = thisEntity.pool:entindex()
			-- })
			-- return 0.25
		-- end
		-- if thisEntity.meteor:IsFullyCastable() and RollPercentage(35) then
			-- ExecuteOrderFromTable({
				-- UnitIndex = thisEntity:entindex(),
				-- OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				-- AbilityIndex = thisEntity.meteor:entindex()
			-- })
			-- return 0.25
		-- end
		-- if thisEntity.mass:IsFullyCastable() and AICore:TotalEnemyHeroesInRange( thisEntity, thisEntity.mass:GetTrueCastRange() ) > 0 then
			-- local distCheck = CalculateDistance( thisEntity, target )
			-- local position = target:GetAbsOrigin()
			-- if distCheck > thisEntity.mass:GetTrueCastRange() and AICore:NearestEnemyHeroInRange( thisEntity, thisEntity.mass:GetTrueCastRange() , true ) then
				-- position = AICore:NearestEnemyHeroInRange( thisEntity, thisEntity.mass:GetTrueCastRange() , true ):GetAbsOrigin()
			-- end
			-- ExecuteOrderFromTable({
				-- UnitIndex = thisEntity:entindex(),
				-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				-- Position = position,
				-- AbilityIndex = thisEntity.mass:entindex()
			-- })
			-- return 0.25
		-- end
		-- if thisEntity.rift:IsFullyCastable() and AICore:TotalEnemyHeroesInRange( thisEntity, thisEntity.rift:GetTrueCastRange() + thisEntity.rift:GetTalentSpecialValueFor("pull_radius") ) > 0 then
			-- local distCheck = CalculateDistance( thisEntity, target )
			-- local position = target:GetAbsOrigin()
			-- if distCheck > thisEntity.rift:GetTrueCastRange() and AICore:NearestEnemyHeroInRange( thisEntity, thisEntity.rift:GetTrueCastRange() + thisEntity.rift:GetTalentSpecialValueFor("pull_radius") , false ) then
				-- position = AICore:NearestEnemyHeroInRange( thisEntity, thisEntity.rift:GetTrueCastRange() + thisEntity.rift:GetTalentSpecialValueFor("pull_radius") , false ):GetAbsOrigin()
			-- end
			-- ExecuteOrderFromTable({
				-- UnitIndex = thisEntity:entindex(),
				-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				-- Position = position,
				-- AbilityIndex = thisEntity.rift:entindex()
			-- })
			-- return 0.25
		-- end
		-- AICore:AttackHighestPriority( thisEntity )
		-- return 0.25
	-- else 
		-- return 0.25 
	-- end
-- end