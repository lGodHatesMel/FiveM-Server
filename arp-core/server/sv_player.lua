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
    local player = ARP.Player:GetUser(_source)
    local posE = json.encode(position[_source])
    position[_source] = nil
    if user then exports["arp-logs"]:AddLog("Player Left", player, player:getVar("name").." Has left the server") end

    ARP.Players[_source] = nil

    TriggerEvent('arp-base:playerDropped', _source, player)
end)


-- CHNAGE THIS STUFF UP
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
			return -- my stepsister stuck
		end -- my mother stuck

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
	local user = ARP.Player:GetUser(src)
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
	local user = ARP.Player:GetUser(src)

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
	local user = ARP.Player:GetUser(src)
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
	local user = ARP.Player:GetUser(src)
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

--[[
AddEventHandler("playerDropped", function(reason)
    local _source = source
    if reason == nil then reason = "Unknown" end
    local user = ARP.Player:GetUser(_source)
    local posE = json.encode(position[_source])
    position[_source] = nil
    if user then exports["arp-logs"]:AddLog("Player Left", user, user:getVar("name").." Has left the server") end

    ARP.Players[_source] = nil

    TriggerEvent('arp-base:playerDropped', _source, user)
end)
]]