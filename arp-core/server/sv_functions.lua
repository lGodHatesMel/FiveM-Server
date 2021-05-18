ARP.Events = ARP.Events or {}
ARP.RegisteredEvent = ARP.RegisteredEvent or {}
ARP.Commands = {}
ARP.RegisterCommands =  {}

function ARP.Events.AddEvent(self, module, func, name)
    ARP.RegisteredEvent[name] = { mod = module, f = func }
end

--??
function ARP.Core.ConsoleLog(self, msg, mod, ply)
	if not tostring(msg) then return end
	if not tostring(mod) then mod = "No Module" end

	local pMsg = string.format("^3[ARP LOG - %s]^7 %s", mod, msg)
	if not pMsg then return end
	if ply and tonumber(ply) then
		TriggerClientEvent("arp-base:logs", ply, msg, mod)
	end
end

function ARP.Commands.AddCommand(self, command, suggestion, source, cb, args)
	if ARP.RegisterCommands[command] then return end
	table.insert(ARP.RegisterCommands, { ['command'] = command, ['suggestion'] = suggestion, ['args'] = args })
	ARP.RegisterCommands[command] = true
	cb(ok)
end

function ARP.Commands.RemoveCommand(self, command, suggestion, source, cb, args)
	if not ARP.RegisterCommands[command] or nil then return end
	ARP.RegisterCommands[command] = false
	cb(ok)
end

AddEventHandler("arp-base:exportsReady", function()
	addModule("Commands", ARP.Commands)
end)

RegisterServerEvent("arp-base:listenForEvent")
AddEventHandler("arp-base:listenForEvent", function(id, name, args)
    local src = source
    if not ARP.RegisteredEvent[name] then return end
    ARP.RegisteredEvent[name].f(ARP.RegisteredEvent[name].mod, args, src, function(data)
        TriggerClientEvent("arp-base:listenForEvent", src, id, data)
    end)
end)
