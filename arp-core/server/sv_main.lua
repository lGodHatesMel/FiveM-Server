ARP.Spawn = {}

RegisterServerEvent('arp-base:spawnInitialized')
AddEventHandler('arp-base:spawnInitialized', function()
    local _source = source
    TriggerClientEvent('arp-base:spawnInitialized', _source)
end)

AddEventHandler("onResourceStart", function(resource)
	TriggerClientEvent("arp-base:waitForExports", -1)
	if not ARP.Core.ExportsReady then return end
	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(0)
			if ARP.Core.ExportsReady then
				TriggerEvent("arp-base:exportsReady")
				return
			else
			end
		end
	end)
end)

RegisterNetEvent("arp-base:playerSessionStarted")
AddEventHandler("arp-base:playerSessionStarted", function()
	local _source = source
	local name = GetPlayerName(_source)
	local player = ARP.Player:GetPlayerData(_source)
	if player then exports["arp-logs"]:AddLog("Player Left", player, player:getVar("name").." Has joined the server") end
	print("^0" .. name .. "^7 spawned into the server")
end)

AddEventHandler("arp-base:characterLoaded", function(user, char)
	local _source = source
	local hexId = user:getVar("hexid")
	if char.phone_number == 0 then
		ARP.Core:CreatePhoneNumber(_source, function(phonenumber, err)	
			local q = [[UPDATE fivem_characters SET phone_number = @phone WHERE owner = @owner and id = @cid]]
			local v = {
				["phone"] = phoneNumber,
				["owner"] = hexId,
				["cid"] = char.id
			}
			exports.ghmattimysql.execute(q, v, function()
				char.phone_number = math.floor(char.phone_number)
				player:setCharacter(char)
			end)
		end)
	end
end)