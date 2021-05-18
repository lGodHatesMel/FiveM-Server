ARP.DataBase = ARP.DataBase or {}

function ARP.DataBase.CreateNewPlayer(self, src, callback)
    local hexid = ARP.Util:GetHexId(src)
    callback = callback and callback or function() return end

    local data = {
        hexid = hexid,
        communityid = ARP.Util:HexIdToComId(hexid),
        steamid = ARP.Util:HexIdToSteamId(hexid),
        license = ARP.Util:GetLicense(src),
        name = GetPlayerName(src),
        ip = "0.0.0.0",
        rank = "user"
    }

    for k,v in pairs(data) do
        if not v or v == "" then
            callback(false, true)
            return
        end
    end

    local q = [[INSERT INTO fivem_users (hex_id, steam_id, community_id, license, ip, name, rank) VALUES(@hexid, @steamid, @comid, @license, @ip, @name, @rank);]]
    local v = {
        ["hexid"] = data.hexid,
        ["steamid"] = data.steamid,
        ["comid"] = data.communityid,
        ["license"] = data.license,
        ["ip"] = data.ip,
        ["rank"] = data.rank,
        ["name"] = data.name
    }    

    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged or not rowsChanged.changedRows then callback(false, true) return end

        local created = rowsChanged and true or false
        callback(created)
    end)
end
function ARP.DataBase.CreateNewCharacter(self, src, data2, hexid, ph, callback)
    local hexid = hexid
    callback = callback and callback or function() return end

    local data = data2
    for k,v in pairs(data) do
        if not v or v == "" then
            callback(false, true)
            return
        end
    end

    local q = [[INSERT INTO fivem_characters (owner, first_name, last_name, dob, gender, phone_number) VALUES(@owner, @first_name, @last_name, @dob, @gender, @phone_number);]]
    local v = {
        ["owner"] = hexid,
        ["first_name"] = data.firstname,
        ["last_name"] = data.lastname,
        ["dob"] = data.dob,
        ["gender"] = data.gender,
        ["phone_number"] = ph
    }

    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged or not rowsChanged.changedRows then callback(false, true) return end
        local created = rowsChanged and true or false
        callback(created)
    end)
end

function ARP.DataBase.PlayerExistsDB(self, src, callback)
    local hexId = ARP.Util:GetHexId(src)
    callback = callback and callback or function() return end
    if not hexId or hexId == "" then callback(false, true) return end
    local q = [[SELECT hex_id FROM fivem_users WHERE hex_id = @id LIMIT 1;]]
    local v = {["id"] = hexId}

    exports.ghmattimysql:execute(q, v, function(results)
        if not results then callback(false, true) return end
        local exists = (results and results[1]) and true or false
        callback(exists)
    end)
end

function ARP.DataBase.PhoneNumberExists(self, src, phone_number, callback)
    local user = exports["arp-base"]:getModule("Player"):GetPlayerData(src)
    callback = callback and callback or function() return end
    if not user then callback(false, true) print("error error EXORTS SOSIS addition") return end
    local hexId = user:getVar("hexid")
    if not hexId or hexid == "" then callback(false, true) print('another error') return end
    local q = [[SELECT phone_number FROM fivem_characters WHERE owner = @id;]]
    local v = {
        ["id"] = hexid,
        ["phone_number"] = phone_number
    }
    exports.ghmattimysql:execute(q, v, function(results)
        if not results then callback(false, true) print('error error EXORTS') return end
        local exists = (results and results[1]) and true or false
        callback(exists)
    end)
end

function ARP.DataBase.FetchPlayerData(self, src, callback)
    local hexId = ARP.Util:GetHexId(src)
    callback = callback and callback or function() return end
    if not hexId or hexId == "" then callback(false, true) return end
    local q = [[SELECT id, hex_id, steam_id, community_id, name, ip, rank FROM fivem_users WHERE hex_id = @id;]]
    local v = {["id"] = hexId}
    exports.ghmattimysql:execute(q, v, function(results)
        if not results then callback(false, true) return end
        results = results[1] and results or {}
        local fetched = (results and results[1]) and results[1] or false
        callback(fetched)
    end)
end

function ARP.DataBase.FetchCharacterData(self, user, callback)
    callback = callback and callback or function() return end
    if not user then callback(false, true) return end
    local hexId = user:getVar("hexid")
    if not hexId or hexid == "" then callback(false, true) return end
    local q = [[SELECT id, owner, first_name, last_name, date_created,  cash, bank, phone_number, dob, gender, new, deleted, jail_time, gang_type, jail_time_mobster, stress_level, judge_type, iswjob FROM fivem_characters WHERE owner = @owner]]
    local v = {["owner"] = hexId}
    exports.ghmattimysql:execute(q,v, function(results)
        if not user then callback(false, true) print('we have error') return end
        results = results[1] and results or {}
        callback(results)
    end)
end

function ARP.DataBase.DeleteCharacter(self, user, id, callback)
    callback = callback and callback or function() return end
    if not user then callback(false, true) return end
    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end
    if not id or type(id) ~= "number" then callback(false, true) return end
    local q = [[DELETE FROM fivem_characters WHERE owner = @hexid and id = @id;]]
    local v = {
        ["hexid"] = hexId,
        ["id"] = id
    }
    exports.ghmattimysql:execute(q, v, function(rowsChanged)
    if not rowsChanged.changedRows then callback(false, true) return end
    local deleted = rowsChanged and true or false
    callback(deleted)
    end)
end

function ARP.DataBase.UpdateCharacterStressLevel(self, user, characterId, newLevel, callback)
    callback = callback and callback or function() return end
    if not user then callback(false,true) return end
    if not characterId or type(characterId) ~= "number" then callback(false, true) return end
    if not user:ownsCharacter(characterId) then callback(false, true) return end
    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end
    local q = [[UPDATE fivem_characters SET stress_level = @stress_level WHERE owner = @hexid AND id = @characterId;]]
    local v = {
        ["stress_level"] = newLevel,
        ["hexid"] = hexId,
        ["characterId"] = characterId
    }
    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged.changedRows then callback(true,false) return end
        local updated = rowsChanged and true or false
        callback(updated)
    end)
end

function ARP.DataBase.UpdateCharacterMoney(self, user, characterId, amount, callback)
    callback = callback and callback or function() return end
    if not user then callback(false,true) return end
    if not characterId or type(characterId) ~= "number" then callback(false, true) return end
    if not user:ownsCharacter(characterId) then callback(false, true) return end
    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end
    local q = [[UPDATE fivem_characters SET cash = @cash WHERE owner = @hexid AND id = @characterId;]]
    local v = {
        ["cash"] = amount,
        ["hexid"] = hexId,
        ["characterId"] = characterId
    }
    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged.changedRows then callback(false, true) return end
        local updated = rowsChanged and true or false
        callback(updated)
    end)
end

function ARP.DataBase.UpdateCharacterBank(self, user, characterId, amount, callback)
    callback = callback and callback or function() return end
    if not user then callback(false,true) return end
    if not characterId or type(characterId) ~= "number" then callback(false, true) return end
    if not user:ownsCharacter(characterId) then callback(false, true) return end
    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end
    local q = [[UPDATE fivem_characters SET bank = @bank WHERE owner = @hexid AND id = @characterId;]]
    local v = {
        ["bank"] = amount,
        ["hexid"] = hexId,
        ["characterId"] = characterId
    }
    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged.changedRows then callback(false, true) return end
        local updated = rowsChanged and true or false
        callback(updated)
    end)
end

function ARP.DataBase.UpdateControls(self, src, controlsTable, callback)
    callback = callback and callback or function() return end
    local user = exports["arp-base"]:getModule("Player"):GetPlayerData(src)
    if not user then callback(false,true) return end

    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end

    local q = [[UPDATE fivem_users SET controls = @controls WHERE hex_id = @hexid;]]
    local v = {
        ["controls"] = json.encode(controlsTable),
        ["hexid"] = hexId
    }
    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged.changedRows then callback(false, true) return end
        local updated = rowsChanged and true or false
        callback(updated)
    end)
end


function ARP.DataBase.GetControls(self, src, callback)
    callback = callback and callback or function() return end
    local user = exports["arp-base"]:getModule("Player"):GetPlayerData(src)
    Citizen.Wait(3000)
    if not user then callback(false, true) return end

    local hexId = user:getVar("hexid")

    if not hexId or hexid == "" then callback(false, true) return end

    local q = [[SELECT controls FROM fivem_users WHERE hex_id = @hex_id;]]
    local v = {["hex_id"] = hexid}

    exports.ghmattimysql:execute(q,v, function(results)
        if not user then callback(false, true) return end
        results = results[1] and results or {}
        callback(results)
    end)
end

function ARP.DataBase.UpdateSettings(self, src, settingsTable, callback)
    callback = callback and callback or function() return end
    local user = exports["arp-base"]:getModule("Player"):GetPlayerData(src)
    if not user then callback(false,true) return end

    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end

    local q = [[UPDATE fivem_users SET settings = @settings WHERE hex_id = @hexid;]]
    local v = {
        ["settings"] = json.encode(settingsTable),
        ["hexid"] = hexId
    }
    exports.ghmattimysql:execute(q, v, function(rowsChanged)
        if not rowsChanged.changedRows then callback(false, true) return end
        local updated = rowsChanged and true or false
        callback(updated)
    end)
end


function ARP.DataBase.GetSettings(self, src, callback)
    callback = callback and callback or function() return end
    local user = exports["arp-base"]:getModule("Player"):GetPlayerData(src)
    if not user then callback(false, true) return end

    local hexId = user:getVar("hexid")
    if not hexId or hexid == "" then callback(false, true) return end

    local q = [[SELECT settings FROM fivem_users WHERE hex_id =@id;]]
    local v = {["id"] = hexid}

    exports.ghmattimysql:execute(q,v, function(results)
        if not user then callback(false, true) return end
        results = results[1] and results or {}
        callback(results)
    end)
end


-- 3.0
function ARP.DataBase.Something(self, src, callback)
    callback = callback or function() return end
    local user = exports["arp-base"]:getModule("Player"):GetPlayerData(src)
    if not user then callback(false, true) return end

    local hexId = user:getVar("hexid")
    if not hexId or hexId == "" then callback(false, true) return end

    local q = [[
            SELECT characters.id, characters.owner, characters.first_name, characters.last_name, characters.date_created,
            characters.cash, characters.bank, _character_phone_number.phone_number as 'phone_number', characters.dob,
            characters.gender, characters.new, characters.jail_time, characters.gang_type, 
            characters.jail_time_mobster, characters.judge_type, characters.stress_level, characters.jail_life,
            characters.rehab FROM fivem_characters
            LEFT JOIN _character_phone_number ON characters.id = _chharacter_phone_number.cid AND is_burner = false
            WHERE owner = @id AND deleted = 0 LIMIT 8;
        ]]

    local v = {["id"] = hexId}
    exports.ghmattimysql:execute(q, v, function(results)
    if not results then callback(false, true) return end
        results = results[1] and results or {}
        for i,v in ipairs(results) do
            v.RealJailTime = (v.jail_time - os.time()) / 60
            -- there is more but mussing for now
        end
    end)
end

-- function ARP.DataBase.DeleteCharacter(self, user, id, callback)
--     callback = callback and callback or function() return end

--     if not user then callback(false, true) return end

--     local hexId = user:getVar("hexid")

--     if not hexId or hexId == "" then callback(false, true) return end
--     if not id or type(id) ~= "number" then callback(false, true) return end

--     local q = [[UPDATE fivem_characters SET deleted = 1, deleteion_data = NOW() WHERE owner = @hexid and id = @id;]]
--     local v = {
--         ["hexid"] = hexId,
--         ["id"] = id
--     }

--     exports.ghmattimysql:execute(q, v, function(rowsChanged)
--     if not rowsChanged.changedRows then callback(false, true) return end

--     local deleted = rowsChanged and true or false

--     callback(deleted)
--      end)
-- end
