ARP.Spawn = {}
ARP.Core.hasPlayerLoaded = false

function ARP.Core.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent("arp-base:playerSessionStarted")
                TriggerServerEvent("arp-base:playerSessionStarted")
                break
            end
        end
    end)
end
ARP.Core:Initialize()

Citizen.CreateThread( function()
    TriggerEvent("arp-base:disableLoading")
end)

function ARP.Spawn.Initialize(self)
    Citizen.CreateThread(function()
        FreezeEntityPosition(PlayerPedId(), true)
        TransitionToBlurred(500)
        DoScreenFadeOut(500)

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamRot(cam, 0.0, 0.0, -45.0, 2)
        SetCamCoord(cam, -682.0, -1092.0, 226.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)
        SetEntityVisible(ped, false)
        DoScreenFadeIn(10000)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end

        Citizen.Wait(10000)

        TriggerEvent("arp-base:spawnInitialized") -- -- in arp-spawn
        TriggerServerEvent("arp-base:spawnInitialized")
    end)
end

function ARP.Spawn.InitialSpawn(self)
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local character = ARP.LocalPlayer:getCurrentCharacter()

        DisableAllControlActions(0)
        DoScreenFadeOut(10)

        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end

        TriggerEvent("arp-base:initialSpawnModelLoaded")

        SetEntityVisible(ped, true)
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        EnableAllControlActions(0)
        TriggerEvent("character:finishedLoadingChar")
    end)
end

AddEventHandler("arp-base:playerSessionStarted", function()
    while not ARP.Core.hasPlayerLoaded do
        Wait(100)
    end
    ShutdownLoadingScreen()
    ARP.SpawnManager:Initialize()
end)

AddEventHandler("arp-base:firstSpawn", function()
    local ped = PlayerPedId()
    ARP.Spawn:InitialSpawn()
    Citizen.CreateThread(function()
        Citizen.Wait(600)
        FreezeEntityPosition(ped, false)
    end)
end)

RegisterNetEvent("arp-base:waitForExports")
AddEventHandler("arp-base:waitForExports", function()
    if not ARP.Core.ExportsReady then return end
    while true do
        Citizen.Wait(0)
        if exports and exports["arp-base"] then
            TriggerEvent("arp-base:exportsReady")
            return
        end
    end
end)

--NEED TO CHANGE SCRIPT TO THIS EVENT FROM "arp-base:clearStates"
RegisterNetEvent('arp-base:playerLoggedOut')
AddEventHandler('arp-base:playerLoggedOut', function()
    TriggerEvent("isJudgeOff")
    TriggerEvent("nowCopSpawnOff")
    TriggerEvent("nowEMSDeathOff")
    TriggerEvent("police:noLongerCop")
    TriggerEvent("nowCopDeathOff")
    TriggerEvent("ResetFirstSpawn")
    TriggerEvent("stopSpeedo")
    TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
    TriggerEvent("wk:disableRadar")
end)

RegisterNetEvent("arp-base:disableLoading")
AddEventHandler("arp-base:disableLoading", function()
    print("player has spawned ")
    if not ARP.Core.hasPlayerLoaded then
        ARP.Core.hasPlayerLoaded = true
    end
end)


-- CHECK TO CHANGE THIS STUFF
RegisterNetEvent("customNotification")
AddEventHandler("customNotification", function(msg, length, type)
	TriggerEvent("chatMessage","SYSTEM",4,msg)
end)