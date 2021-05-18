ARP.BlipManager = ARP.BlipManager or {}
ARP.Blips = ARP.Blips or {}

local blips = {
    {id = "casino1", name = "Casino", color = 0.7, sprite = 207, x = 925.329, y = 46.152, z = 80.908 },
    {id = "hosp1", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = 1839.6, y= 3672.93, z= 34.28},
    {id = "hosp2", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = -247.76, y= 6331.23, z=32.43},
    {id = "hosp3", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = -449.67, y= -340.83, z= 34.50},
    {id = "hosp4", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = 357.43, y= -593.36, z= 28.79},
    {id = "hosp5", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = 295.83, y= -1446.94, z= 29.97},
    {id = "hosp6", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = -676.98, y= 310.68, z= 83.08},
    {id = "hosp7", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = 1151.21, y= -1529.62, z= 35.37},
    {id = "hosp8", name = "Hospital", scale = 0.7, color = 2, sprite = 61, x = -874.64, y= -307.71, z= 39.58},
    {id = "cloth1", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = 425.236, y=-806.008, z=29.491},
    {id = "cloth2", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -162.658, y=-303.397, z=39.733},
    {id = "cloth3", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = 75.950, y=-1392.891, z=29.376},
    {id = "cloth4", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -822.194, y=-1074.134, z=11.328},
    {id = "cloth5", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -1450.711, y=-236.83, z=49.809},
    {id = "cloth6", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = 4.254, y=6512.813, z=31.877},
    {id = "cloth7", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = 615.180, y=2762.933, z=44.088},
    {id = "cloth8", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = 1196.785, y=2709.558, z=38.222},
    {id = "cloth9", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -3171.453, y=1043.857, z=20.863},
    {id = "cloth10", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -1100.959, y=2710.211, z=19.107},
    {id = "cloth11", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -1192.9453125, y=-772.62481689453, z=17.3254737854},
    {id = "cloth12", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -707.33416748047, y=-155.07914733887, z=37.415187835693},
    {id = "cloth13", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = 1683.45667, y=4823.17725, z=42.1631294},
    {id = "cloth14", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -712.215881, y=-155.352982, z=37.4151268},
    {id = "cloth15", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x =121.76, y=-224.6, z=54.56},
    {id = "cloth16", name = "Clothing", scale = 0.7, color = 3, sprite = 73, x = -1207.5267333984, y=-1456.9530029297, z=4.3763856887817},
    {id = "recycling", name = "Recycling plant", scale = 0.7, color = 17, sprite = 304, x = 746.75518798828, y=-1400.094482421, z=26.570837020874},
    --{id = "Smelting", name = "Smelting", color = 17, sprite = 52, x = 1098.10168457031, y=-1999.86364746094, z=30.3807010650635},
    {id = "truckjob1", name = "Delivery Garage", scale = 0.7, color = 17, sprite = 67, x =165.22, y=-28.38, z=67.94},
    {id = "truckjob2", name = "Delivery Garage", scale = 0.7, color = 17, sprite = 67, x = -627.99, y= -1649.99, z= 25.83},
    {id = "ttruckgarage", name = "Auto Exotic", scale = 0.7, color = 30, sprite = 147, x = 531.81506347656, y = -176.94529724121, z = 54.750310516357},
    {id = "bar1", name = "Bahama Mamas", scale = 0.7, sprite = 93, x = -1388.53430175781, y=-586.615295410156, z=29.2186660766602},
    {id = "pcenter", name = "Payments & Internet Center", scale = 0.7, sprite = 351, color = 17, x=-1081.8293457031, y=-248.12872314453, z=37.763294219971},
    {id = "jcenter", name = "Job Center", scale = 0.7, sprite = 351, color = 17, x=172.78, y=-26.89, z=68.35},
    {id = "ttruckjob", name = "Impound Lot", scale = 0.7, color = 17, sprite = 68, x = 549.47796630859, y = -55.197559356689, z = 71.069190979004},
    {id = "ttruckjob2", name = "Impound Lot", scale = 0.7, color = 17, sprite = 68, x = 1732.1655273438, y = 3307.6025390625, z = 41.22350692749},
    {id = "ttruckjob3", name = "Impound Lot", scale = 0.7, color = 17, sprite = 68, x = -195.68403625488, y = 6219.8081054688, z = 31.491077423096},
    --{id = "ttruckgarage", name = "Stroke Masters", color = 27, sprite = 147, x = 531.81506347656, y = -176.94529724121, z = 54.750310516357},
    --{id = "gopostal", name = "Go Postal", scale = 0.7, color = 17, sprite = 411, x = 63.463, y = 126.000, z = 79.1902},
    {id = "fishingsales", name = "Fish Sales", scale = 0.7, color = 7, sprite = 304, x=-1038.4649658203, y=-1396.7390136719, z=5.5531921386719},
    {id = "fishingprocess", name = "Process Fish", scale = 0.7, color = 7, sprite = 304, x=1000.46, y=-2170.23, z=29.48},
    {id = "cc", name = "Comedy Club", scale = 0.7, color = 7, sprite = 102, x=-431.235299, y=259.939819, z=82.9778519},
    {id = 'TaxiRank', name = 'Taxi Rank', scale = 0.7, color = 5, sprite = 56, x = -12.72, y = -143.3, z = 56.26},
    --{id = 'TowTruckParking', name = 'Choppers Jobs', scale = 0.7, color = 5, sprite = 68, x = 536.48, y = -239.46, z = 49.16},
    {id = 'winery', name = 'The Winery', scale = 0.7, color = 6, sprite = 478, x = -1889.86, y = 2036.54, z = 140.83},
    {id = 'HarmonyRepairs', name = 'Harmony Repairs', scale = 0.7, color = 12, sprite = 478, x = 1183.18, y = 2651.66, z = 37.81},
    {id = "repo", name = "Govt Vehicle Repo", scale = 0.7, color = 8, sprite = 147, x = 400.85, y = -1632.37, z = 29.3},
    {id = "burgies", name = "Burger Shot", scale = 0.7, color = 8, sprite = 106, x = -1199.61, y = -899.79, z = 14.0},
    {id = "drift_school", name = "Overboost DriftSchool", scale = 0.7, color = 4, sprite = 52, x = -52.61, y= -2524.91, z= 7.41},
}

function ARP.BlipManager.CreateBlip(self, id, data)
    local blip = AddBlipForCoord(data.x, data.y, data.z)
    if data.sprite then SetBlipSprite(blip, data.sprite) end
    if data.range then SetBlipAsShortRange(blip, data.range) else SetBlipAsShortRange(blip, true) end
    if data.color then SetBlipColour(blip, data.color) end
    if data.display then SetBlipDisplay(blip, data.display) end
    if data.playername then SetBlipNameToPlayerName(blip, data.playername) end
    if data.showcone then SetBlipShowCone(blip, data.showcone) end
    if data.secondarycolor then SetBlipSecondaryColour(blip, data.secondarycolor) end
    if data.friend then SetBlipFriend(blip, data.friend) end
    if data.mission then SetBlipAsMissionCreatorBlip(blip, data.mission) end
    if data.route then SetBlipRoute(blip, data.route) end
    if data.friendly then SetBlipAsFriendly(blip, data.friendly) end
    if data.routecolor then SetBlipRouteColour(blip, data.routecolor) end
    if data.scale then SetBlipScale(blip, data.scale) else SetBlipScale(blip, 0.7) end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)

    ARP.Blips[id] = {blip = blip, data = data}
end

function ARP.BlipManager.RemoveBlip(self, id)
    local blip = ARP.Blips[id]
    if blip then RemoveBlip(blip.blip) end
    ARP.Blips[id] = nil
end

function ARP.BlipManager.HideBlip(self, id, toggle)
    local blip = ARP.Blips[id]
    if not blip then return end
    if toggle then SetBlipAlpha(blip, 0) else SetBlipAlpha(blip, 255) end
end

function ARP.BlipManager.GetBlip(self, id)
    local blip = ARP.Blips[id]
    if not blip then return false end
    return blip
end

AddEventHandler("arp-base:playerSessionStarted", function()
    Citizen.CreateThread(function()
        for k,v in ipairs(blips) do
            ARP.BlipManager:CreateBlip(v.id, v)
        end
    end)
end)


