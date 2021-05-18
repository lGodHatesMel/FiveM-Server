ARP.Player = {}
ARP.Players = {}
local position = {}

RegisterServerEvent('arp-base:updatecoords')
AddEventHandler('arp-base:updateCoords', function(x,y,z)
    local _source = source
    position[_source] = {x,y,z}
end)

AddEventHandler("playerDropped", function(reason)
    local _source = source
    if reason == nil then reason = "Unknown" end
    local player = ARP.Player:GetPlayerData(_source)
    local posE = json.encode(position[_source])
    position[_source] = nil
    if user then exports["arp-logs"]:AddLog("Player Left", player, player:getVar("name").." Has left the server") end

    ARP.Players[_source] = nil

    TriggerEvent('arp-base:playerDropped', _source, player)
end)

-- CHNAGE THIS STUFF UP

function ARP.Player.GetPlayerData(self, id)
    return ARP.Players[id] and ARP.Players[id] or false
end

function ARP.Player.GetPlayers(self)
    local tmp = {}
    for k, v in pairs(ARP.Players) do
        tmp[#tmp+1]= k
    end

    return tmp
end

local function GetPlayerData(user)
    return ARP.Players[user.source]
end

local function AddMethod(player)
    function player.getVar(self, var)
        return GetPlayerData(self)[var]
    end

    function player.setVar(self, var, data)
        GetPlayerData(self)[var] = data
    end
    
    function player.networkVar(self, var, data)
        self:setVar(var, data)
        TriggerClientEvent("arp-base:networkVar", GetPlayerData(self):getVar("source"), var, data)
    end

    function player.getRank(self)
        return GetPlayerData(self).rank
    end

    function player.setRank(self, rank)
        GetPlayerData(self).rank = rank
        self:networkVar("rank", rank)
    end

    function player.setCharacters(self, data)
        GetPlayerData(self).characters = data
    end

    function player.setCharacter(self, data)
        GetPlayerData(self).character = data
    end

    function player.getCash(self)
        return GetPlayerData(self).character.cash
    end

    function player.getBalance(self)
        return GetPlayerData(self).character.bank
    end

    function player.getGangType(self)
        return GetPlayerData(self).character.gang_type
    end

    function player.getStressLevel(self)
        return GetPlayerData(self).character.stress_level
    end

    function player.getJudgeType(self)
        return GetPlayerData(self).character.judge_type
    end

    function player.alterStressLevel(self, amt)
        local characterid = GetPlayerData(self).character.id
        GetPlayerData(self).character.stress_level = amt
        ARP.DataBase:UpdateCharacterStressLevel(GetPlayerData(self), characterId, amt, function(updatedMoney, err)
            if updatedMoney then
                --We are good here.
            end
        end)
    end

    function player.addMoney(self, amt)
        if not amt or type(amt) ~= "number" then return end
        local cash = GetPlayerData(self):getCash() + amt
        local characterId = GetPlayerData(self).character.id
        local src = GetPlayerData(self).source
        amt = math.floor(amt)
        GetPlayerData(self).character.cash = cash
        ARP.DataBase:UpdateCharacterMoney(GetPlayerData(self), characterId, cash, function(updatedMoney, err) 
            if updatedMoney then
                TriggerClientEvent("banking:addCash", GetPlayerData(self).source, amt)
                TriggerClientEvent("banking:updateCash", GetPlayerData(self).source, GetPlayerData(self):getCash(), amt)
                exports["arp-logs"]:AddLog("Cash Added", GetPlayerData(self), "Money added to user, amount: " .. tostring(amt))
            end
        end)
    end

    function player.removeMoney(self, amt)
        if not amt or type(amt) ~= "number" then return end
        local cash = GetPlayerData(self):getCash() - amt
        local characterId = GetPlayerData(self).character.id
        local src = GetPlayerData(self).source
        amt = math.floor(amt)
        GetPlayerData(self).character.cash = GetPlayerData(self).character.cash - amt
        ARP.DataBase:UpdateCharacterMoney(GetPlayerData(self), characterId, cash, function(updatedMoney, err) 
            if updatedMoney then
                TriggerClientEvent("banking:removeCash", GetPlayerData(self).source, amt)
                TriggerClientEvent("banking:updateCash", GetPlayerData(self).source, GetPlayerData(self):getCash(), amt * -1)
                exports["arp-logs"]:AddLog("Cash Removed", GetPlayerData(self), "Money removed from user, amount: " .. tostring(amt))
            end
        end)
    end

    function player.removeBank(self, amt)
        if not amt or type(amt) ~= "number" then return end
        local bank = GetPlayerData(self):getBalance() - amt
        local characterId = GetPlayerData(self).character.id
        local src = GetPlayerData(self).source
        amt = math.floor(amt)
        GetPlayerData(self).character.bank = GetPlayerData(self).character.bank - amt
        ARP.DataBase:UpdateCharacterBank(GetPlayerData(self), characterId, bank, function(updatedMoney, err) 
            if updatedMoney then
                TriggerClientEvent("banking:removeBalance", GetPlayerData(self).source, amt)
                TriggerClientEvent("banking:updateBalance", GetPlayerData(self).source, GetPlayerData(self):getBalance(), amt * -1)
                exports["arp-logs"]:AddLog("Bank Removed", GetPlayerData(self), "Bank removed from user, amount: " .. tostring(amt))
            end
        end)
    end

    function player.addBank(self, amt)
        if not amt or type(amt) ~= "number" then return end
        local bank = GetPlayerData(self):getBalance() + amt
        local characterId = GetPlayerData(self).character.id
        local src = GetPlayerData(self).source
        amt = math.floor(amt)
        GetPlayerData(self).character.bank = bank
        ARP.DataBase:UpdateCharacterBank(GetPlayerData(self), characterId, bank, function(updatedMoney, err) 
            if updatedMoney then
                TriggerClientEvent("banking:addBalance", GetPlayerData(self).source, amt)
                TriggerClientEvent("banking:updateBalance", GetPlayerData(self).source, GetPlayerData(self):getBalance(), amt)
                exports["arp-logs"]:AddLog("Bank Added", GetPlayerData(self), "Bank added to user, amount: " .. tostring(amt))
            end
        end)
    end

    function player.getNumCharacters(self)
        if not GetPlayerData(self).charactersLoaded or not GetPlayerData(self).characters then return 0 end
        return #GetPlayerData(self).characters
    end

    function player.ownsCharacter(self, id)
        if not GetPlayerData(self).charactersLoaded or not GetPlayerData(self).characters or GetPlayerData(self):getNumCharacters() <= 0 then return false end

        for k,v in ipairs(GetPlayerData(self).characters) do 
            if v.id == id then return true end 
        end

        return false
    end

    function player.getGender(self)
        if not GetPlayerData(self).charactersLoaded or not GetPlayerData(self).characters or not GetPlayerData(self).characterLoaded then return false end

        return GetPlayerData(self).character.gender
    end
        
    function player.getCharacters(self)
        return GetPlayerData(self).characters
    end

    function player.getCharacter(self, id)
        if not GetPlayerData(self).charactersLoaded or not GetPlayerData(self).characters or GetPlayerData(self):getNumCharacters() <= 0 then return false end
        if not GetPlayerData(self):ownsCharacter(id) then return false end
        for k,v in ipairs(GetPlayerData(self).characters) do 
            if v.id == id then return v end
        end

        return false
    end

    function player.getCurrentCharacter(self)
        if not GetPlayerData(self).charactersLoaded or not GetPlayerData(self).characterLoaded or GetPlayerData(self):getNumCharacters() <= 0 then return false end
        return GetPlayerData(self).character
    end

    return player
end

local function CreatePlayer(src)
    local self = {}
    self.source = src
    self.name = GetPlayerName(src)
    self.hexid = ARP.Util:GetHexId(src)
    if not self.hexid then
        DropPlayer(src, "Error fetching steamid")
        return
    end
    self.comid = ARP.Util:HexIdToComId(self.hexid)
    self.steamid = ARP.Util:HexIdToSteamId(self.hexid)
    self.license = ARP.Util:GetLicense(src)
    self.ip = GetPlayerEP(src)
    self.rank = "user"
    self.characters = {}
    self.character = {}
    self.charactersLoaded = false
    self.characterLoaded = false
    local methods = AddMethod(self)
    ARP.Players[src] = methods
    return methods
end


function ARP.Player.CreatePlayer(self, src, recrate)
    if recreate then ARP.Players[src] = nil end
    if ARP.Players[src] then return ARP.Players[src] end

    return CreatePlayer(src)
end

function ARP.Core.LoginPlayer(self, args, src, callback)
    TriggerEvent("arp-base:playerAttemptLogin", src)

    local user = ARP.Player:CreatePlayer(src, false)
    if not user then
        user = ARP.Player:CreatePlayer(src, false)

        if not user then DropPlayer(src, "There was an error while creating your player object, if this persists, contact an administrator") return end
    end

    local function fetchData(_err)
        if _err and type(_err) == "string" then
            local errmsg = _err
            _err = {
                err = true,
                msg = errmsg
            }
            
            callback(_err)
            return
        end

        ARP.DataBase:FetchPlayerData(src, function(data, err)
            if err then
                data = {
                    err = true,
                    msg = "Error fetching player data, there is a problem with the database"
                }
            end

            user:setRank(data.rank)

            callback(data)

            if not err then TriggerEvent("arp-base:playerLoggedIn", user) TriggerClientEvent("arp-base:playerLoggedIn", src) end
        end)
    end

	ARP.DataBase:PlayerExistsDB(src, function(exists, err)
		if err then
			fetchData("Error checking player existence, there is a problem with the database")
			return
		end

		if not exists then
			ARP.DataBase:CreateNewPlayer(src, function(created)
				if not created then
					fetchData("Error creating new user, there is a problem with the database")
					return
				end

				if created then fetchData() return end
			end)

			return
		end

		fetchData()
	end)
end
ARP.Events:AddEvent(ARP.Core, ARP.Core.LoginPlayer, "arp-base:loginPlayer")

function ARP.Core.FetchPlayerCharacters(self, args, src, callback)
	local user = ARP.Player:GetPlayerData(src)
	if not user then return end

	ARP.DataBase:FetchCharacterData(user, function(data, err)
		if err then
			data = {
				err = true,
				msg = "Error fetching player character data, there is a problem with the database"
			}
		else
			user:setCharacters(data)
			user:setVar("charactersLoaded", true)
			TriggerEvent("arp-base:charactersLoaded", user, data)
			TriggerClientEvent("arp-base:charactersLoaded", src, data)
		end

		callback(data)
	end)
end
ARP.Events:AddEvent(ARP.Core, ARP.Core.FetchPlayerCharacters, "arp-base:fetchPlayerCharacters")

function ARP.Core.CreatePhoneNumber(self, src, callback)
	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(1000)
			math.randomseed(GetGameTimer())

			local areaCode = math.random(50) > 25 and 415 or 628
			local phonenumber = {}
			local numBase2 = math.random(100,999)
			local numBase3 = math.random(1000,9999)
			phoneNumber = string.format(areaCode .. "" .. numBase2 .. "" .. numBase3)

			local querying = true
			local success = false
			if phoneNumber then
				phoneNumber = tostring(phoneNumber)
				if phoneNumber then
					ARP.DataBase:PhoneNumberExists(src, phoneNumber, function(exists, err)
						if err then callback(false, true) success = true querying = false print('phone number does not exist') return end
						if not exists then callback(phoneNumber) success = true print('sucess') end
						querying = false
					end)
				end
			end

			while querying do Citizen.Wait(0) end

			if success then return end
		end 
	end)
end

function ARP.Core.CreateCharacter(self, charData, src, callback)
	local user = ARP.Player:GetPlayerData(src)

	if not user or not user:getVar("charactersLoaded") then return end
	if user:getNumCharacters() >= 8 then return end

	local fn = charData.firstname
	local ln = charData.lastname
	exports.ghmattimysql:execute("SELECT first_name FROM fivem_characters WHERE first_name = @fn AND last_name = @ln", {
		["fn"] = fn, 
		["ln"] = ln
	}, function(result)
		if result[1] ~= nil then 
			created = {
				err = true,
				msg = "This name is already in use, pick another."
			}
			callback(created)
			return
		else
			self:CreatePhoneNumber(src, function(phoneNumber, err)
				if err then
					created = {
						err = true,
						msg = "There was an error when trying to create a phone number"
					}
					callback(created)
					return
				end
				local hexId = user:getVar("hexid")
				charData.phonenumber = phoneNumber

				ARP.DataBase:CreateNewCharacter(user, charData, hexId, phoneNumber, function(created, err)
					if not created or err then
						created = {
							err = true,
							msg = "There was a problem creating your character, contact an administrator if this persists"
						}
					end

					callback(created)
				end)
			end)
		end
	end)
end
ARP.Events:AddEvent(ARP.Core, ARP.Core.CreateCharacter, "arp-base:createCharacter")

function ARP.Core.DeleteCharacter(self, id, src, callback)
	local user = ARP.Player:GetPlayerData(src)
	if not user or not user:getVar("charactersLoaded") then return end

	local ownsCharacter = false
	for k,v in pairs(user:getCharacters()) do
		if v.id == id then ownsCharacter = true break end
	end

	if not ownsCharacter then return end

	ARP.DataBase:DeleteCharacter(user, id, function(deleted)
		callback(deleted)
	end)
end
ARP.Events:AddEvent(ARP.Core, ARP.Core.DeleteCharacter, "arp-base:deleteCharacter")

function ARP.Core.SelectCharacter(self, id, src, callback)
	local user = ARP.Player:GetPlayerData(src)
	if not user then callback(false) return end
	if not user:getCharacters() or user:getNumCharacters() <= 0 then callback(false) return end
	if not user:ownsCharacter(id) then callback(false) return end

	local selectedCharacter = user:getCharacter(id)
	selectedCharacter.phone_number = selectedCharacter.phone_number

	user:setCharacter(selectedCharacter)
	user:setVar("characterLoaded", true)

	callback({loggedin = true, chardata = selectedCharacter})

	local cid = selectedCharacter.id
	TriggerClientEvent('updatecid', src, cid)
	TriggerClientEvent('updatecids', src, cid)
	TriggerClientEvent('updateNameClient', src, tostring(selectedCharacter.first_name), tostring(selectedCharacter.last_name))
	TriggerClientEvent('banking:updateBalance', src, selectedCharacter.bank, true)
	TriggerClientEvent('banking:updateCash', src, selectedCharacter.cash, true)
	TriggerClientEvent('arp-base:setcontrols', src)
	TriggerClientEvent('updatepasses', src)
	TriggerEvent("arp-base:characterLoaded", user, selectedCharacter)
	TriggerClientEvent("arp-base:characterLoaded", src, selectedCharacter)
end
ARP.Events:AddEvent(ARP.Core, ARP.Core.SelectCharacter, "arp-base:selectCharacter")