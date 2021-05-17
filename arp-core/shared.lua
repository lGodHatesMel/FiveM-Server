ARP = ARP or {}
ARP.Util = {}
ARP.Core = {}

--ARP.Util = ARP.Util or {}

ARP.Core.ExportsReady = false

function ARP.Core.ConsoleLog(self, msg, mod)
    if not tostring(msg) then return end
    if not tostring(mod) then mod = "No Module" end
    local pMsg = string.format("[ARP LOG - %s] %s", mod, msg)
    if not pMsg then return end
    print(pMsg)
end

function ARP.Core.WaitForExports(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if exports and exports["arp-base"] then
                TriggerEvent("arp-base:exportsReady")
                ARP.Core.ExportsReady = true
                return
            end
        end
    end)
end

function getModule(module)
    if not ARP[module] then print("Warning: '" .. tostring(module) .. "' module doesn't exist") return false end
    return ARP[module]
end

function addModule(module, tbl)
    if ARP[module] then print("Warning: '" .. tostring(module) .. "' module is being overridden") end
    ARP[module] = tbl
end

function ARP.Util.GetHexId(self, src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 5) == "steam" then
            return v
        end
    end

    return false
end

function ARP.Util.HexIdToSteamId(self, hexid)
    local cid = self:HexIdToComId(hexid)
    local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end

function ARP.Util.HexIdToComId(self, hexid)
    return math.floor(tonumber(string.sub(hexid, 7), 16))
end

function ARP.Util.GetLicense(self, src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 7) == "license" then
            return v
        end
    end

    return false
end

function ARP.Util.GetIdType(self, src, type)
    local len = string.len(type)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, len) == type then
            return v
        end
    end

    return false
end

function ARP.Util.Stringsplit(self, inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end

    return t
end

function ARP.Util.IsSteamId(self, id)
    id = tostring(id)
    if not id then return false end
    if string.match(id, "^STEAM_[01]:[01]:%d+$") then return true else return false end
end

function ARP.Util.CommaValue(self, n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

RegisterNetEvent("arp-base:consoleLog")
AddEventHandler("arp-base:consoleLog", function(msg, mod)
    ARP.Core:ConsoleLog(msg, mod)
end)

exports("getModule", getModule)
exports("addModule", addModule)
ARP.Core:WaitForExports()