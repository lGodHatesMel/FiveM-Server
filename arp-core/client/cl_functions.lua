ARP.Events = ARP.Events or {}
ARP.Events.Total = 0
ARP.Events.Active = {}

local insidePrison = false
local removePedsFromLoc = PolyZone:Create({
        vector2(1848.3560791016, 2585.8767089844),
        vector2(1851.9969482422, 2701.5397949219),
        vector2(1775.2449951172, 2766.1599121094),
        vector2(1647.9683837891, 2762.3049316406),
        vector2(1566.775390625, 2682.4233398438),
        vector2(1531.1402587891, 2586.3283691406),
        vector2(1537.3836669922, 2468.1098632812),
        vector2(1659.0677490234, 2390.9916992188),
        vector2(1763.5603027344, 2407.3283691406),
        vector2(1827.6236572266, 2474.3251953125),
        vector2(1840.548828125, 2521.0629882812),
        vector2(1846.2946777344, 2545.7502441406)
    }, {
    name="prison",
    debugGrid = true,
    maxZ = 47.00,
})

local scenariosList = {
    "WORLD_VEHICLE_DRIVE_SOLO",
    "WORLD_GULL_STANDING",
    "WORLD_HUMAN_CLIPBOARD",
    "WORLD_HUMAN_SEAT_LEDGE",
    "WORLD_HUMAN_SEAT_LEDGE_EATING",
    "WORLD_HUMAN_STAND_MOBILE",
    "WORLD_HUMAN_HANG_OUT_STREET",
    "WORLD_HUMAN_SMOKING",
    "WORLD_HUMAN_DRINKING",
    "WORLD_GULL_FEEDING",
    "WORLD_HUMAN_GUARD_STAND",
    "WORLD_HUMAN_SEAT_STEPS",
    "WORLD_HUMAN_STAND_IMPATIENT",
    "WORLD_HUMAN_SEAT_WALL_EATING",
    "WORLD_HUMAN_WELDING",
}

local function GameLoops()
    Citizen.CreateThread(function()
        while true do
            local Ped = PlayerPedId()
            local coords = GetPedBoneCoords(Ped, HeadBone)
            local inZone = removePedsFromLoc:isPointInside(coord)
            if inZone and not insidePrison then
                insidePrison = true
                ClearAreaOfPeds(1735.83,2554.44,45.55, 100.0, 1)
                setScenario(false)
            elseif not inZone and insidePrison then
                insidePrison = false
                setScenario(true)
            end
            Citizen.Wait(500)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            SetWeaponDrops()
        end
    end)

    Citizen.CreateThread(function()
        for i = 1, 25 do
            EnableDispatchService(i, false)
        end
        for i = 0, 255 do
            if NetworkIsPlayerConnected(i) then
                if NetworkIsPlayerConnected(i) and GetPlayerPed(i) ~= nil then
                    SetCanAttackFriendly(GetPlayerPed(i), true, true)
                end
            end
        end
        NetworkSetFriendlyFireOption(true)
        DisablePlayerVehicleRewards(PlayerId())
        while true do
            Citizen.Wait(0)
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)            
            local timer = 0
            if IsPedInAnyVehicle(ped, false) then
                if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
                    if GetIsTaskActive(ped, 165) then
                    --    SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
                    end
                end

                timer = 0
            else
                if IsPedWearingHelmet(ped) then
                    timer = timer + 1
                    if timer >= 5000 and not IsPedInAnyVehicle(ped, true) then
                        RemovePedHelmet(ped, false)
                        timer = 0
                    end
                end
            end
        end
    end)

    --Citizen.CreateThread(function()
    --    while true do
    --        Wait(1000)
    --        local id = PlayerId()
    --        if allowpolice == 0 then
    --            SetPlayerWantedLevel(id, 0, false)
    --            SetPlayerWantedLevelNow(id, false)
    --        else
    --            if allowpolice == 1 then
    --                for i = 1, 25 do
    --                    EnableDispatchService(i, false)
    --                end
    --            else
    --                for i = 1, 25 do
    --                    EnableDispatchService(i, true)
    --                end
    --            end
    --            SetPlayerWantedLevel(id, 2, false)
    --            SetPlayerWantedLevelNoDrop(id, 2, false)
    --            SetPlayerWantedLevelNow(id)
    --            print(GetPlayerWantedLevel(id))
    --        end
    --    end
    --end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local pos = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2729.47, 1514.56, 23.79,false)
            if dist > 150.0 then
                ClearAreaOfCops(pos, 400.0)
            else
                Wait(5000)
            end
        end
    end)
end

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false
	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end

function setScenario(pToggle)
    for i = 1, #scenariosList do
        SetScenarioTypeEnabled(scenariosList[i], pToggle)
    end
end

function ARP.Events.Trigger(self, event, args, callback)
    local id = ARP.Events.Total + 1
    ARP.Events.Total = id
    id = event .. ":" .. id
    if ARP.Events.Active[id] then return end
    ARP.Events.Active[id] = {cb = callback}
    TriggerServerEvent("arp-base:listenForEvent", id, event, args)
end

function GetVehicles()
	local vehicles = {}
	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end
	return vehicles
end

function FetchVehProps(vehicle)	
    local color1, color2 = GetVehicleColours(vehicle)	
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)	
	local extras = {}	
	local model2 = GetEntityModel(vehicle)
	local vehname = GetDisplayNameFromVehicleModel(model2)
	for id=0, 12 do	
		if DoesExtraExist(vehicle, id) then	
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1	
			extras[tostring(id)] = state	
		end	
	end	

	return {	
		model             = GetDisplayNameFromVehicleModel(model2),	
		plate             = GetVehicleNumberPlateText(vehicle),	
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),	
		bodyHealth        = tonumber(string.format("%." .. (1 or 0) .. "f", GetVehicleBodyHealth(vehicle))),	
		engineHealth      = tonumber(string.format("%." .. (1 or 0) .. "f", GetVehicleEngineHealth(vehicle))),	
		fuelLevel         = tonumber(string.format("%." .. (1 or 0) .. "f", GetVehicleFuelLevel(vehicle))),	
		dirtLevel         = tonumber(string.format("%." .. (1 or 0) .. "f", GetVehicleDirtLevel(vehicle))),	
		color1            = color1,	
		color2            = color2,	
		pearlescentColor  = pearlescentColor,	
		wheelColor        = wheelColor,	
		wheels            = GetVehicleWheelType(vehicle),	
		windowTint        = GetVehicleWindowTint(vehicle),	
		neonEnabled       = {	
			IsVehicleNeonLightEnabled(vehicle, 0),	
			IsVehicleNeonLightEnabled(vehicle, 1),	
			IsVehicleNeonLightEnabled(vehicle, 2),	
			IsVehicleNeonLightEnabled(vehicle, 3)	
		},	
		extras            = extras,	
		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),	
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),	
		modSpoilers       = GetVehicleMod(vehicle, 0),	
		modFrontBumper    = GetVehicleMod(vehicle, 1),	
		modRearBumper     = GetVehicleMod(vehicle, 2),	
		modSideSkirt      = GetVehicleMod(vehicle, 3),	
		modExhaust        = GetVehicleMod(vehicle, 4),	
		modFrame          = GetVehicleMod(vehicle, 5),	
		modGrille         = GetVehicleMod(vehicle, 6),	
		modHood           = GetVehicleMod(vehicle, 7),	
		modFender         = GetVehicleMod(vehicle, 8),	
		modRightFender    = GetVehicleMod(vehicle, 9),	
		modRoof           = GetVehicleMod(vehicle, 10),	
		modEngine         = GetVehicleMod(vehicle, 11),	
		modBrakes         = GetVehicleMod(vehicle, 12),	
		modTransmission   = GetVehicleMod(vehicle, 13),	
		modHorns          = GetVehicleMod(vehicle, 14),	
		modSuspension     = GetVehicleMod(vehicle, 15),	
		modArmor          = GetVehicleMod(vehicle, 16),	
		modTurbo          = IsToggleModOn(vehicle, 18),	
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),	
		modXenon          = IsToggleModOn(vehicle, 22),	
		modFrontWheels    = GetVehicleMod(vehicle, 23),	
		modBackWheels     = GetVehicleMod(vehicle, 24),	
		modPlateHolder    = GetVehicleMod(vehicle, 25),	
		modVanityPlate    = GetVehicleMod(vehicle, 26),	
		modTrimA          = GetVehicleMod(vehicle, 27),	
		modOrnaments      = GetVehicleMod(vehicle, 28),	
		modDashboard      = GetVehicleMod(vehicle, 29),	
		modDashboardColour = GetVehicleDashboardColour(vehicle),	
		modInteriorColour = GetVehicleInteriorColour(vehicle),	
		modXenonColour = GetVehicleHeadlightsColour(vehicle),	
		modDial           = GetVehicleMod(vehicle, 30),	
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),	
		modSeats          = GetVehicleMod(vehicle, 32),	
		modSteeringWheel  = GetVehicleMod(vehicle, 33),	
		modShifterLeavers = GetVehicleMod(vehicle, 34),	
		modAPlate         = GetVehicleMod(vehicle, 35),	
		modSpeakers       = GetVehicleMod(vehicle, 36),	
		modTrunk          = GetVehicleMod(vehicle, 37),	
		modHydrolic       = GetVehicleMod(vehicle, 38),	
		modEngineBlock    = GetVehicleMod(vehicle, 39),	
		modAirFilter      = GetVehicleMod(vehicle, 40),	
		modStruts         = GetVehicleMod(vehicle, 41),	
		modArchCover      = GetVehicleMod(vehicle, 42),	
		modAerials        = GetVehicleMod(vehicle, 43),	
		modTrimB          = GetVehicleMod(vehicle, 44),	
		modTank           = GetVehicleMod(vehicle, 45),	
		modWindows        = GetVehicleMod(vehicle, 46),	
		modLivery         = GetVehicleMod(vehicle, 48),	
		modoldLivery      = GetVehicleLivery(vehicle)	
	}	
end	

function SetVehProps(vehicle, props)	
    SetVehicleModKit(vehicle, 0)	

	if props.plate ~= nil then	
		SetVehicleNumberPlateText(vehicle, props.plate)	
	end	

	if props.plateIndex ~= nil then	
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)	
	end	

	if props.bodyHealth ~= nil then	
		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)	
	end	

	if props.engineHealth ~= nil then	
		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)	
	end	

	if props.fuelLevel ~= nil then	
		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)	
	end	

	if props.dirtLevel ~= nil then	
		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)	
	end	

	if props.color1 ~= nil then	
		local color1, color2 = GetVehicleColours(vehicle)	
		SetVehicleColours(vehicle, props.color1, color2)	
	end	

	if props.color2 ~= nil then	
		local color1, color2 = GetVehicleColours(vehicle)	
		SetVehicleColours(vehicle, color1, props.color2)	
	end	

	if props.pearlescentColor ~= nil then	
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)	
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)	
	end	

	if props.wheelColor ~= nil then	
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)	
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)	
	end	

	if props.wheels ~= nil then	
		SetVehicleWheelType(vehicle, props.wheels)	
	end	

	if props.windowTint ~= nil then	
		SetVehicleWindowTint(vehicle, props.windowTint)	
	end	

	if props.neonEnabled ~= nil then	
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])	
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])	
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])	
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])	
	end	

	if props.extras ~= nil then	
		for id,enabled in pairs(props.extras) do	
			if enabled then	
				SetVehicleExtra(vehicle, tonumber(id), 0)	
			else	
				SetVehicleExtra(vehicle, tonumber(id), 1)	
			end	
		end	
	end	

	if props.neonColor ~= nil then	
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])	
	end	

	if props.modSmokeEnabled ~= nil then	
		ToggleVehicleMod(vehicle, 20, true)	
	end	

	if props.tyreSmokeColor ~= nil then	
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])	
	end	

	if props.modSpoilers ~= nil then	
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)	
	end	

	if props.modFrontBumper ~= nil then	
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)	
	end	

	if props.modRearBumper ~= nil then	
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)	
	end	

	if props.modSideSkirt ~= nil then	
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)	
	end	

	if props.modExhaust ~= nil then	
		SetVehicleMod(vehicle, 4, props.modExhaust, false)	
	end	

	if props.modFrame ~= nil then	
		SetVehicleMod(vehicle, 5, props.modFrame, false)	
	end	

	if props.modGrille ~= nil then	
		SetVehicleMod(vehicle, 6, props.modGrille, false)	
	end	

	if props.modHood ~= nil then	
		SetVehicleMod(vehicle, 7, props.modHood, false)	
	end	

	if props.modFender ~= nil then	
		SetVehicleMod(vehicle, 8, props.modFender, false)	
	end	

	if props.modRightFender ~= nil then	
		SetVehicleMod(vehicle, 9, props.modRightFender, false)	
	end	

	if props.modRoof ~= nil then	
		SetVehicleMod(vehicle, 10, props.modRoof, false)	
	end	

	if props.modEngine ~= nil then	
		SetVehicleMod(vehicle, 11, props.modEngine, false)	
	end	

	if props.modBrakes ~= nil then	
		SetVehicleMod(vehicle, 12, props.modBrakes, false)	
	end	

	if props.modTransmission ~= nil then	
		SetVehicleMod(vehicle, 13, props.modTransmission, false)	
	end	

	if props.modHorns ~= nil then	
		SetVehicleMod(vehicle, 14, props.modHorns, false)	
	end	

	if props.modSuspension ~= nil then	
		SetVehicleMod(vehicle, 15, props.modSuspension, false)	
	end	

	if props.modArmor ~= nil then	
		SetVehicleMod(vehicle, 16, props.modArmor, false)	
	end	

	if props.modTurbo ~= nil then	
		ToggleVehicleMod(vehicle,  18, props.modTurbo)	
	end	

	if props.modXenon ~= nil then	
		ToggleVehicleMod(vehicle,  22, props.modXenon)	
	end	

	if props.modFrontWheels ~= nil then	
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)	
	end	

	if props.modBackWheels ~= nil then	
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)	
	end	

	if props.modPlateHolder ~= nil then	
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)	
	end	

	if props.modVanityPlate ~= nil then	
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)	
	end	

	if props.modTrimA ~= nil then	
		SetVehicleMod(vehicle, 27, props.modTrimA, false)	
	end	

	if props.modOrnaments ~= nil then	
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)	
	end	

	if props.modDashboard ~= nil then	
		SetVehicleMod(vehicle, 29, props.modDashboard, false)	
	end	

	if props.modDashboardColour ~= nil then	
		SetVehicleDashboardColour(vehicle, props.modDashboardColour)	
	end	

	if props.modInteriorColour ~= nil then	
		SetVehicleInteriorColour(vehicle, props.modInteriorColour)	
	end	

	if props.modXenonColour ~= nil then	
		SetVehicleHeadlightsColour(vehicle, props.modXenonColour)	
	end	

	if props.modDial ~= nil then	
		SetVehicleMod(vehicle, 30, props.modDial, false)	
	end	

	if props.modDoorSpeaker ~= nil then	
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)	
	end	

	if props.modSeats ~= nil then	
		SetVehicleMod(vehicle, 32, props.modSeats, false)	
	end	

	if props.modSteeringWheel ~= nil then	
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)	
	end	

	if props.modShifterLeavers ~= nil then	
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)	
	end	

	if props.modAPlate ~= nil then	
		SetVehicleMod(vehicle, 35, props.modAPlate, false)	
	end	

	if props.modSpeakers ~= nil then	
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)	
	end	

	if props.modTrunk ~= nil then	
		SetVehicleMod(vehicle, 37, props.modTrunk, false)	
	end	

	if props.modHydrolic ~= nil then	
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)	
	end	

	if props.modEngineBlock ~= nil then	
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)	
	end	

	if props.modAirFilter ~= nil then	
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)	
	end	

	if props.modStruts ~= nil then	
		SetVehicleMod(vehicle, 41, props.modStruts, false)	
	end	

	if props.modArchCover ~= nil then	
		SetVehicleMod(vehicle, 42, props.modArchCover, false)	
	end	

	if props.modAerials ~= nil then	
		SetVehicleMod(vehicle, 43, props.modAerials, false)	
	end	

	if props.modTrimB ~= nil then	
		SetVehicleMod(vehicle, 44, props.modTrimB, false)	
	end	

	if props.modTank ~= nil then	
		SetVehicleMod(vehicle, 45, props.modTank, false)	
	end	

	if props.modWindows ~= nil then	
		SetVehicleMod(vehicle, 46, props.modWindows, false)	
	end	

	if props.modLivery ~= nil then	
		SetVehicleMod(vehicle, 48, props.modLivery, false)	
		SetVehicleLivery(vehicle, props.modLivery)	
	end	

	if props.modoldLivery ~= nil then	
		SetVehicleLivery(vehicle, props.modoldLivery)	
	end	
end	

function GetCurrentMod(id)	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local mod = GetVehicleMod(playerVehicle, id)	
    local modName = GetLabelText(GetModTextLabel(playerVehicle, id, mod))	
    return mod, modName	
end	

function GetCurrentWheel()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local wheel = GetVehicleMod(playerVehicle, 23)	
    local wheelName = GetLabelText(GetModTextLabel(playerVehicle, 23, wheel))	
    local wheelType = GetVehicleWheelType(playerVehicle)	
    return wheel, wheelName, wheelType	
end	

function GetCurrentCustomWheelState()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local state = GetVehicleModVariation(playerVehicle, 23)	
    if state then	
        return 1	
    else	
        return 0	
    end	
end	

function GetOriginalWheel()	
    return originalWheel	
end	

function GetOriginalCustomWheel()	
    return originalCustomWheels	
end	

function GetCurrentWindowTint()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    return GetVehicleWindowTint(playerVehicle)	
end	

function GetCurrentVehicleWheelSmokeColour()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local r, g, b = GetVehicleTyreSmokeColor(playerVehicle)	
    return r, g, b	
end	

function GetCurrentNeonState(id)	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local isEnabled = IsVehicleNeonLightEnabled(playerVehicle, id)	
    if isEnabled then	
        return 1	
    else	
        return 0	
    end	
end	

function GetCurrentNeonColour()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local r, g, b = GetVehicleNeonLightsColour(playerVehicle)	
    return r, g, b	
end	

function GetCurrentXenonState()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local isEnabled = IsToggleModOn(playerVehicle, 22)	
    if isEnabled then	
        return 1	
    else	
        return 0	
    end	
end	

function GetCurrentXenonColour()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    return GetVehicleHeadlightsColour(playerVehicle)	
end	

function GetCurrentTurboState()	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    local isEnabled = IsToggleModOn(playerVehicle, 18)	
    if isEnabled then	
        return 1	
    else	
        return 0	
    end	
end	

function GetCurrentExtraState(extra)	
    local Ped = PlayerPedId()	
    local playerVehicle = GetVehiclePedIsIn(Ped, false)	
    return IsVehicleExtraTurnedOn(playerVehicle, extra)	
end

local gamePlayStarted = false
AddEventHandler("arp-base:playerSessionStarted", function()
    if gamePlayStarted then return end
    gamePlayStarted = true
    GameLoops()
end)

RegisterNetEvent("arp-base:listenForEvent")
AddEventHandler("arp-base:listenForEvent", function(id, data)
    local event = ARP.Events.Active[id]
    if event then
        event.cb(data)
        ARP.Events.Active[id] = nil
    end
end)
