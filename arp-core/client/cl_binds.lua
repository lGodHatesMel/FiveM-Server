ARP.DataControls = ARP.DataControls or {}
ARP.Controls = ARP.Controls or {}
ARP.Controls.EventHolder = {}
ARP.Controls.Current = {}

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["INPUTAIM"] = 25
}

ARP.Controls.Default = {
	["tokoptt"] = "CAPS",
	["loudSpeaker"] = "-",
	["distanceChange"] = "G",
	["tokoToggle"] = "LEFTCTRL",
	["handheld"] = "LEFTSHIFT+P",
	["carStereo"] = "LEFTALT+P",
	["switchRadioEmergency"] = "9",
	["actionBar"] = "TAB",
	["generalUse"] = "E",
	["generalPhone"] = "P",
	["generalInventory"] = "K",
	["generalChat"] = "T",
	["generalEscapeMenu"] = "ESC",
	["generalUseSecondary"] = "ENTER",
	["generalUseSecondaryWorld"] = "F",
	["generalUseThird"] = "G",
	["generalTackle"] = "LEFTALT",
	["generalMenu"] = "F1",
	["generalProp"] = "7",
	["generalScoreboard"] = "U",
	["movementCrouch"] = "X",
	["movementCrawl"] = "Z",
	["vehicleCruise"] = "X",
	["vehicleSearch"] = "G",
	["vehicleHotwire"] = "H",
	["vehicleBelt"] = "B",
	["vehicleDoors"] = "L",
	["vehicleSlights"] = "Q",
	["vehicleSsound"] = "LEFTALT",
	["vehicleSnavigate"] = "R",
	["newsTools"] = "H",
	["newsNormal"] = "E",
	["newsMovie"] = "M",
	["housingMain"] = "H",
	["housingSecondary"] = "G",
	["heliCam"] = "E",
	["helivision"] = "INPUTAIM",
	["helirappel"] = "X",
	["helispotlight"] = "G",
	["helilockon"] = "SPACE",
	["showDispatchLog"] = "z",
	["radiovolumedown"] = "[",
	["radiovolumeup"] = "]",
	["radiotoggle"] = ",",
	["devmenu"] = "F5",
	["devnoclip"] = "F2",
	["devcloak"] = "F3",
	["devmarker"] = "F6",
}

ARP.Controls.events = {
	["lowActionItems"] = {
		[0] = {["event"] = "",["bind"] = "",["id"] = 3},
	},
	["general"] = {
		[0] = {["event"] = "police",["bind"] = "vehicleCruise",["id"] = 1,["maxwait"] = 1000},
		[1] = {["event"] = "police",["bind"] = "generalTackle",["id"] = 2,["maxwait"] = 1000},
		[2] = {["event"] = "police",["bind"] = "tokoptt",["id"] = 3,["maxwait"] = 1000},
		[3] = {["event"] = "police",["bind"] = "generalMenu",["id"] = 8,["maxwait"] = 1000}, -- uhm unsure
		-- search and hotwire
		[4] = {["event"] = "hotwire",["bind"] = "vehicleSearch",["id"] = 1,["maxwait"] = 1000},
		[5] = {["event"] = "hotwire",["bind"] = "vehicleHotwire",["id"] = 2,["maxwait"] = 1000},
		-- news action items
		[6] = {["event"] = "newsJob",["bind"] = "newsTools",["id"] = 1,["maxwait"] = 200},
		[7] = {["event"] = "newsJob",["bind"] = "newsNormal",["id"] = 2,["maxwait"] = 200},
		[8] = {["event"] = "newsJob",["bind"] = "newsMovie",["id"] = 3,["maxwait"] = 200},
		--drop propattach 
		[9] = {["event"] = "propAttach",["bind"] = "generalProp",["id"] = 1,["maxwait"] = 1000},
		-- radio
		[10] = {["event"] = "taskBar",["bind"] = "handheld",["id"] = 1,["maxwait"] = 1000},
		-- phone
		[11] = {["event"] = "taskBar",["bind"] = "carStereo",["id"] = 2,["maxwait"] = 1000},
		-- car stereo
		[12] = {["event"] = "taskBar",["bind"] = "generalPhone",["id"] = 3,["maxwait"] = 1000},
		-- inventoryh
		[13] = {["event"] = "taskBar",["bind"] = "generalInventory",["id"] = 4,["maxwait"] = 1000},
		-- escape from gui taskbar
		[14] = {["event"] = "taskBar",["bind"] = "generalEscapeMenu",["id"] = 5,["maxwait"] = 1000},
		-- toggle car door lock
		[15] = {["event"] = "cardoors",["bind"] = "vehicleDoors",["id"] = 1,["maxwait"] = 1000},
		-- toggle belt
		[16] = {["event"] = "vehicleMod",["bind"] = "vehicleBelt",["id"] = 1,["maxwait"] = 1000},
		-- switch emergency radio
		-- ARP CHECK THESE
		[17] = {["event"] = "tokoChangeEmergency",["bind"] = "switchRadioEmergency",["id"] = 1,["maxwait"] = 1000},
		[18] = {["event"] = "police", ["bind"] = "showDispatchLog",["id"] = 9,["maxwait"] = 1000},
		[19] = {["event"] = "tokoChangeVolume",["bind"] = "radiovolumedown",["id"] = 1,["maxwait"] = 200},
		[20] = {["event"] = "tokoChangeVolume",["bind"] = "radiovolumeup",["id"] = 2,["maxwait"] = 200},
		[21] = {["event"] = "tokoRadioToggle",["bind"] = "radiotoggle",["id"] = 1,["maxwait"] = 200},
		[22] = {["event"] = "adminDev",["bind"] = "devmenu",["id"] = 1,["maxwait"] = 200},
		[23] = {["event"] = "adminDev",["bind"] = "devnoclip",["id"] = 2,["maxwait"] = 200},
		[24] = {["event"] = "adminDev",["bind"] = "devcloak",["id"] = 3,["maxwait"] = 200},
		[25] = {["event"] = "adminDev",["bind"] = "devmarker",["id"] = 4,["maxwait"] = 200},
	},
	["general-dist"] = {
		[0] = {["event"] = "distanceCheck",["bind"] = "generalUse",["distanceName"] = "use"},
		[1] = {["event"] = "distanceCheck",["bind"] = "generalUseSecondaryWorld",["distanceName"] = "useSecondary"},
		[2] = {["event"] = "distanceCheck",["bind"] = "generalUseThird",["distanceName"] = "useThird"},
	},
}

ARP.Controls.secondaryBinds = {}
ARP.Controls.Distcheck = {}
ARP.Controls.Distcheck.use = {
	[0] ={["pos"] = {123.46,6407.27,31.36},		["r"] = 2,["event"] = "truckerjob",["id"] = 1,["maxwait"] = 300},
	[1] ={["pos"] = {929.36,-3131.95,5.91},		["r"] = 8,["event"] = "truckerjob",["id"] = 2,["maxwait"] = 300},
	[2] ={["pos"] = {-1196.97,-1572.89,4.61,},	["r"] = 1,["event"] = "gym",["id"] = 1,["maxwait"] = 200},--"weights"
	[3] ={["pos"] = {-1199.05,-1574.49,4.60,},	["r"] = 1,["event"] = "gym",["id"] = 2,["maxwait"] = 200},--"weights"
	[4] ={["pos"] = {-1200.58,-1577.50,4.60,},	["r"] = 1,["event"] = "gym",["id"] = 3,["maxwait"] = 200},--"pushUps"
	[5] ={["pos"] = {-1196.01,-1567.36,4.61,},	["r"] = 1,["event"] = "gym",["id"] = 4,["maxwait"] = 200},--"Yoga"
	[6] ={["pos"] = {-1215.02,-1541.68,4.72,},	["r"] = 1,["event"] = "gym",["id"] = 5,["maxwait"] = 200},--"Yoga"
	[7] ={["pos"] = {-1217.59,-1543.16,4.72,},	["r"] = 1,["event"] = "gym",["id"] = 6,["maxwait"] = 200},--"Yoga"
	[8] ={["pos"] = {-1220.84,-1545.02,4.69,},	["r"] = 1,["event"] = "gym",["id"] = 7,["maxwait"] = 200},--"Yoga"
	[9] ={["pos"] = {-1224.69,-1547.24,4.62,},	["r"] = 1,["event"] = "gym",["id"] = 8,["maxwait"] = 200},--"Yoga"
	[10] ={["pos"] = {-1228.49,-1549.42,4.55,},	["r"] = 1,["event"] = "gym",["id"] = 9,["maxwait"] = 200},--"Yoga"
	[11] ={["pos"] = {-1253.41,-1601.65,3.15},	["r"] = 1,["event"] = "gym",["id"] = 10,["maxwait"] = 200},--chinups
	[12] ={["pos"] = {-1252.43,-1603.14,3.13},	["r"] = 1,["event"] = "gym",["id"] = 11,["maxwait"] = 200},--chinups
	[13] ={["pos"] = {-1251.26,-1604.81, 3.14},	["r"] = 1,["event"] = "gym",["id"] = 12,["maxwait"] = 200},--chinups
	[14] ={["pos"] = {-211.55,-1324.55,30.90},	["r"] = 2,["event"] = "bennys",["id"] = 1,["maxwait"] = 200},
	[15] ={["pos"] = {727.74,-1088.95,22.17},	["r"] = 2,["event"] = "bennys",["id"] = 2,["maxwait"] = 200},	
	[16] ={["pos"] = {110.8, 6626.46, 31.89},	["r"] = 2,["event"] = "bennys",["id"] = 3,["maxwait"] = 200},
	[17] ={["pos"] = {401.16,-1631.7,28.4},	["r"] = 15,["event"] = "towgarage",["id"] = 1,["maxwait"] = 300}, -- check
	[18] ={["pos"] = {-626.53,-238.37,38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 1,["maxwait"] = 9000},
	[19] ={["pos"] = {-625.60, -237.52, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 2,["maxwait"] = 9000},
	[20] ={["pos"] = {-626.91, -235.51, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 3,["maxwait"] = 9000},
	[21] ={["pos"] = {-625.67, -234.60, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 4,["maxwait"] = 9000},
	[22] ={["pos"] = {-626.89, -233.08, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 5,["maxwait"] = 9000},
	[23] ={["pos"] = {-627.95, -233.85, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 6,["maxwait"] = 9000},
	[24] ={["pos"] = {-624.52, -231.05, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 7,["maxwait"] = 9000},
	[25] ={["pos"] = {-623.00, -233.08, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 8,["maxwait"] = 9000},
	[26] ={["pos"] = {-620.10, -233.36, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 9,["maxwait"] = 9000},
	[27] ={["pos"] = {-620.29, -234.41, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 10,["maxwait"] = 9000},
	[28] ={["pos"] = {-619.06, -233.56, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 11,["maxwait"] = 9000},
	[29] ={["pos"] = {-617.48, -230.65, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 12,["maxwait"] = 9000},
	[30] ={["pos"] = {-618.36, -229.42, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 13,["maxwait"] = 9000},
	[31] ={["pos"] = {-619.60, -230.55, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 14,["maxwait"] = 9000},
	[32] ={["pos"] = {-620.89, -228.65, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 15,["maxwait"] = 9000},
	[33] ={["pos"] = {-619.79, -227.56, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 16,["maxwait"] = 9000},
	[34] ={["pos"] = {-620.61, -226.44, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 17,["maxwait"] = 9000},
	[35] ={["pos"] = {-623.99, -228.17, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 18,["maxwait"] = 9000},
	[36] ={["pos"] = {-624.88, -227.86, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 19,["maxwait"] = 9000},
	[37] ={["pos"] = {-623.67, -227.00, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 20,["maxwait"] = 9000},
	[38] ={["pos"] = {950.55,-988.65,39.57},  ["r"] = 1,["event"] = "tuner",["id"] = 1,["maxwait"] = 300},
	[39] ={["pos"] = {548.49,-198.69,54.48},  ["r"] = 1,["event"] = "autoshop",["id"] = 1,["maxwait"] = 300},
	[40] ={["pos"] = {-338.58,-135.94,39.00},  ["r"] = 1,["event"] = "bennys",["id"] = 4,["maxwait"] = 300}, --illegal_carshop

	--[38] ={["pos"] = {-1381.52,-477.87,72.04},  ["r"] = 1,["event"] = "jobSystem",["id"] = 1,["maxwait"] = 300},
}

function ARP.DataControls.getBindTable()
	local i = 1
	local controlTable = {}
	for k,v in pairs(ARP.Controls.Current) do
		controlTable[i] = {k,v}
		i = i+1
	end

    return controlTable
end

function ARP.DataControls.encodeSetBindTable(self, bindTable)
	local controlTable = {}
	for k,v in pairs(bindTable) do
		controlTable[v[1]] = v[2]
	end

	ARP.DataControls.setBindTable(controlTable,true)
end

function ARP.DataControls.toUpper(table)
	local controlTable = {}
	for k,v in pairs(table) do
		controlTable[k] = string.upper(v)
	end

    return controlTable
end

function ARP.DataControls.setBindTable(controlTable,shouldSend)
	if controlTable == nil then
		ARP.Controls.Current  = ARP.DataControls.toUpper(ARP.Controls.Default) 
		ARP.DataControls.setSecondaryBindTable(ARP.Controls.Current)
		TriggerServerEvent('arp-base::setPlayerBinds',ARP.Controls.Current)
		ARP.DataControls.checkForMissing()
	else
		if shouldSend then 
			ARP.Controls.Current = ARP.DataControls.toUpper(controlTable)
			ARP.DataControls.setSecondaryBindTable(ARP.Controls.Current)
			TriggerServerEvent('arp-base::setPlayerBinds',ARP.Controls.Current)
			ARP.DataControls.checkForMissing()
		else
			ARP.Controls.Current = ARP.DataControls.toUpper(controlTable)
			ARP.DataControls.setSecondaryBindTable(ARP.Controls.Current)
			ARP.DataControls.checkForMissing()
		end
	end
	TriggerEvent("event:control:update",ARP.DataControls.getTableInKeyNumbers())
end

function ARP.DataControls.setSecondaryBindTable(bindtable)
	ARP.Controls.secondaryBinds = {}
	local i = 0
	for k,v in pairs(bindtable) do
		local keyString = string.upper(v)
		if string.match(keyString, "+")  then
			local result = split(keyString, "+")
			local control1 = Keys[result[1]]
			local control2 = Keys[result[2]]
			local valid = true
			for i=1,#ARP.Controls.secondaryBinds  do
				if ARP.Controls.secondaryBinds[i] and ARP.Controls.secondaryBinds[i][1] == control1 then valid = false end
			end

			if valid then 
				ARP.Controls.secondaryBinds[i] = {}
				ARP.Controls.secondaryBinds[i][1] = control1
				ARP.Controls.secondaryBinds[i][2] = control2
				i = i + 1
			end
		end
	end
end

function ARP.DataControls.getTableInKeyNumbers()
	local controlTable = {}
	for k,v in pairs(ARP.Controls.Current) do
		controlTable[k] = {}
		controlTable[k][1] = Keys[string.upper(v)]
		controlTable[k][2] = string.upper(v)
	end

	return controlTable
end

function ARP.DataControls.getBindByID(bindID)
	local found = "none"
	for k,v in pairs(ARP.Controls.Current) do
		if k == bindID then
			found = v
			break
		end
	end
	return found
end

function ARP.DataControls.distanceCall(distcheckName)
	local distanceTable = ARP.Controls.Distcheck[distcheckName]
	local found = -1
	local pedpos = GetEntityCoords(PlayerPedId()) -- to be changed to player data pos at later date

	for i=0,#distanceTable do
		local table = distanceTable[i]
		local v = table.pos
		local dist = #(vector3(v[1], v[2], v[3]) - vector3(pedpos.x,pedpos.y,pedpos.z)) -- check distance here
		if dist <= table.r and found == -1 then
			found = i
			break
		end
	end

	if found ~= -1 then
		local hasTimer = 99999
		local key = distanceTable[found].event.."_"..distanceTable[found].id
		if ARP.Controls.EventHolder[key] then
			hasTimer = (GetGameTimer()-ARP.Controls.EventHolder[key])
		end
		if  hasTimer >= distanceTable[found].maxwait then
			ARP.Controls.EventHolder[key] = GetGameTimer();
			TriggerEvent("event:control:"..distanceTable[found].event,distanceTable[found].id)
		end
	end
end


function ARP.DataControls.checkForMissing()
	local isMissing = false

	for j,h in pairs(ARP.Controls.Default) do
		if ARP.Controls.Current[j] == nil then
			isMissing = true
			ARP.Controls.Current[j] = h
		end
	end

	if isMissing then
		ARP.DataControls.setSecondaryBindTable(ARP.Controls.Current)
		TriggerServerEvent('arp-base::setPlayerBinds',ARP.Controls.Current)
	end
end

function ARP.DataControls.validEvent(event,id,eventID)
	local v = ARP.Controls.events["general"][eventID]
	local hasTimer = 999999
	local eventKey = event.."_"..id

	if ARP.Controls.EventHolder[eventKey] then
		hasTimer = (GetGameTimer()-ARP.Controls.EventHolder[eventKey])
	end

	if ARP.Controls.EventHolder[eventKey] and hasTimer ~= 999999 then
		if hasTimer >= v.maxwait then
			ARP.Controls.EventHolder[eventKey] = GetGameTimer();
			TriggerEvent("event:control:"..event,id)
		end
	else
		if hasTimer >= 1000 then
			ARP.Controls.EventHolder[eventKey] = GetGameTimer();
			TriggerEvent("event:control:"..event,id)
		end
	end
end

local timer = 0;
local eventTimer = {}
Citizen.CreateThread(function()
	while true do
		
		if ARP.Controls.Current["tokoptt"] then
			for i=0,#ARP.Controls.events["general"] do
				local v = ARP.Controls.events["general"][i]
				local keyString = ARP.Controls.Current[v["bind"]]
				local key = Keys[keyString]

				if key == 199 then
					if IsDisabledControlJustReleased(1,key) then
						local isConflicted = -1
						for i=0,#ARP.Controls.secondaryBinds do
							if IsControlPressed(1,ARP.Controls.secondaryBinds[i][1]) or IsDisabledControlPressed(1,ARP.Controls.secondaryBinds[i][1]) then
								isConflicted = ARP.Controls.secondaryBinds[i][1]
							end
						end

						if isConflicted ~= -1 then
							Wait(100)
							if IsControlPressed(1,isConflicted) or IsDisabledControlPressed(1,isConflicted) then
								local eventBind, idEvent = findBind(key,isConflicted)
								ARP.DataControls.validEvent(eventBind,idEvent,i)
							else
								ARP.DataControls.validEvent(v.event,v.id,i)
							end
						else
							if (GetGameTimer()-timer) > 400 then
								ARP.DataControls.validEvent(v.event,v.id,i)
							end
						end
					end
				else
					if IsControlJustPressed(1,key) and not IsControlJustPressed(1,0) and not IsControlJustPressed(1,nil) then
						if GetLastInputMethod(0) then
							local validTrigger = true
							if key == 39 or key == 40 then 
								if IsControlJustPressed(1,16) or IsControlJustPressed(1,17) or IsControlJustPressed(1,241) or IsControlJustPressed(1,242) then 
									validTrigger = false 
								end  
							end
							if validTrigger then
								local isConflicted = -1
								for i=0,#ARP.Controls.secondaryBinds do
									if IsControlPressed(1,ARP.Controls.secondaryBinds[i][2]) or IsDisabledControlPressed(1,ARP.Controls.secondaryBinds[i][2]) then
										isConflicted = ARP.Controls.secondaryBinds[i][2]
									end
								end

								if isConflicted ~= -1 then
									Wait(100)

									if IsControlPressed(1,isConflicted) or IsDisabledControlPressed(1,isConflicted) then
										local eventBind, idEvent = findBind(key,isConflicted)
										timer = GetGameTimer();
										ARP.DataControls.validEvent(eventBind,idEvent,i)
									else
										ARP.DataControls.validEvent(v.event,v.id,i)
									end
								else
									ARP.DataControls.validEvent(v.event,v.id,i)
								end
							end
						end
					end
				end
			end
		end
		Wait(5)
	end
end)

function findBind(first,last)
	local event = ""
	local id = 0

	if first == nil then return end

	for i=0,#ARP.Controls.events["general"] do
		local firstCorrect = false
		local secondCorrect = false
		local v = ARP.Controls.events["general"][i]
		local keyString = ARP.Controls.Current[v["bind"]]

		if string.match(keyString, "+")  then
			local result = split(keyString, "+")
			local control1 = Keys[result[1]]
			local control2 = Keys[result[2]]

			if control1== first or control2 == first then
				firstCorrect = true
			end

			if control1 == last or control2 == last then
				secondCorrect = true
			end

			if firstCorrect and secondCorrect then
				event = v.event
				id = v.id
			end
		end
	end

	return event,id
end

function split(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then 
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then 
        result[i] = source
    end
    return result
end

Citizen.CreateThread(function()
	while true do
		DisableControlAction(1, 199, true)
		if ARP.Controls.Current["tokoptt"] then
			for i=0,#ARP.Controls.events["general-dist"] do
				local v = ARP.Controls.events["general-dist"][i]
				local key = Keys[ARP.Controls.Current[v["bind"]]]
				local hasTimer = 99999;
				if eventTimer[key] then
					hasTimer = (GetGameTimer()-eventTimer[key])
				end

				if IsControlJustPressed(1,key) and hasTimer > 500 then	
					eventTimer[key] = GetGameTimer();		
					ARP.DataControls.distanceCall(v["distanceName"])
				end	
			end
		end
		Wait(5)
	end
end)

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["INPUTAIM"] = 25
}

RegisterNetEvent('arp-base:setcontrols')
AddEventHandler('arp-base:setcontrols', function()
	TriggerServerEvent('arp-base::playerBinds')
end)

RegisterNetEvent("arp-base:playerBinds")
AddEventHandler("arp-base:playerBinds", function(controlTable)
	ARP.DataControls.setBindTable(controlTable,false)
end)