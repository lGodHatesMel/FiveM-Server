ARP.LocalPlayer = ARP.LocalPlayer or {}

local function GetUser()
    return ARP.LocalPlayer
end

function ARP.LocalPlayer.setVar(self, var, data)
    GetUser()[var] = data
end

function ARP.LocalPlayer.getVar(self, var)
    return GetUser()[var]
end

function ARP.LocalPlayer.setCurrentCharacter(self, data)
    if not data then return end
    GetUser():setVar("character", data)
end

function ARP.LocalPlayer.getCurrentCharacter(self)
    return GetUser():getVar("character")
end


-- change this event name ???
RegisterNetEvent("arp-base:networkVar")
AddEventHandler("arp-base:networkVar", function(var, val)
    ARP.LocalPlayer:setVar(var, val)
end)