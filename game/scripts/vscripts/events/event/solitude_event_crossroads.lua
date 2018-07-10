local function CheckPlayerChoices(self)
	for pID, choice in pairs( self._playerChoices ) do
		if not choice then
			return false
		end
	end
	self:EndEvent(true)
	return true
end

local function FirstChoice(self, userid, event)
	local hero = PlayerResource:GetSelectedHeroEntity( event.pID )
	hero:AddCurse("event_buff_crossroads")
	
	local relicTable = {}
	local relic = ""
	local roll = RandomInt(1, 5)
	if roll == 1 then
		relic = RelicManager:RollRandomUniqueRelicForPlayer(event.pID)
	elseif roll == 2 then
		relic = RelicManager:RollRandomCursedRelicForPlayer(event.pID)
	else
		relic = RelicManager:RollRandomGenericRelicForPlayer(event.pID)
	end
	table.insert(relicTable, relic)
	RelicManager:PushCustomRelicDropsForPlayer(event.pID, relicTable)
	
	self._playerChoices[event.pID] = true
	CheckPlayerChoices(self)
end

local function SecondChoice(self, userid, event)
	local hero = PlayerResource:GetSelectedHeroEntity( event.pID )
	self._playerChoices[event.pID] = true
	CheckPlayerChoices(self)
end

local function StartEvent(self)
	CustomGameEventManager:Send_ServerToAllClients("boss_hunters_event_has_started", {event = "solitude_event_crossroads", choices = 2})
	self._vEventHandles = {
		CustomGameEventManager:RegisterListener('player_selected_event_choice_1', Context_Wrap( self, 'FirstChoice') ),
		CustomGameEventManager:RegisterListener('player_selected_event_choice_2', Context_Wrap( self, 'SecondChoice') ),
	}
	self.timeRemaining = 30
	self.eventEnded = false
	Timers:CreateTimer(1, function()
		CustomGameEventManager:Send_ServerToAllClients("updateQuestPrepTime", {prepTime = self.timeRemaining})
		if self.timeRemaining >= 0 then
			self.timeRemaining = self.timeRemaining - 1
			return 1
		elseif not self.eventEnded then
			self:EndEvent(true)
		end
	end)
	
	self._playerChoices = {}
	for i = 0, GameRules.BasePlayers do
		if PlayerResource:IsValidPlayerID(i) and PlayerResource:GetPlayer(i) then
			self._playerChoices[i] = false
		end
	end
	LinkLuaModifier("event_buff_crossroads", "events/modifiers/event_buff_crossroads", LUA_MODIFIER_MOTION_NONE)
end

local function EndEvent(self, bWon)
	for _, eID in pairs( self._vEventHandles ) do
		CustomGameEventManager:UnregisterListener( eID )
	end
	self.eventEnded = true
	self.timeRemaining = -1
	Timers:CreateTimer(3, function() RoundManager:EndEvent(true) end)
end

local function PrecacheUnits(self, context)
	return true
end

local funcs = {
	["StartEvent"] = StartEvent,
	["EndEvent"] = EndEvent,
	["PrecacheUnits"] = PrecacheUnits,
	["FirstChoice"] = FirstChoice,
	["SecondChoice"] = SecondChoice,
}

return funcs