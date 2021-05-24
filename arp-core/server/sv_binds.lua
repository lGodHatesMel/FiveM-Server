RegisterServerEvent("arp-base::setPlayerBinds")
AddEventHandler("arp-base::setPlayerBinds", function(controlsTable)
    local _source = source
    ARP.DataBase:UpdateControls(_source, controlsTable, function(UpdateControls, err)
        if UpdateControls then
            print('updated controls')
        end
    end)
end)

RegisterServerEvent("arp-base::playerBinds")
AddEventHandler("arp-base::playerBinds", function()
    local _source = source
    ARP.DataBase:GetControls(_source, function(loadedControls, err)
        if loadedControls ~= nil then
            TriggerClientEvent("arp-base:playerBinds", _source, loadedControls)
        else
            TriggerClientEvent("arp-base:playerBinds", _source, nil)
            print('controls fucked') 
        end
    end)
end)
