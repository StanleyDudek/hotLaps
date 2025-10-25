
local jsonPath = "Resources/Server/hotLaps/json/"

local levelsPath = jsonPath .. "levels/levels.json"

local leaderBoardPath = jsonPath .. "leaderboard/leaderboard.json"

local playersPath = jsonPath .. "players/"
local playerJsons

local vehiclesPath = jsonPath .. "vehicles/vehicles.json"

local currentTrack = "long"
local currentLevel = "smallgrid"

Players = {}

Vehicles = {}

Levels = {}

Board = {}

theLeaderBoard = {}

local Leaderboard = {}
Leaderboard.__index = Leaderboard

function Leaderboard.new(data)
    local self = setmetatable({}, Leaderboard)
    if not data then
        self.levels = {
            automation_test_track = { tracks = { long = {} } },
            derby = { tracks = { long = {} } },
            driver_training = { tracks = { long = {} } },
            east_coast_usa = { tracks = { long = {} } },
            gridmap = { tracks = { long = {} } },
            gridmap_v2 = { tracks = { long = {} } },
            hirochi_raceway = { tracks = { long = {} } },
            industrial = { tracks = { long = {} } },
            italy = { tracks = { long = {} } },
            johnson_valley = { tracks = { long = {} } },
            jungle_rock_island = { tracks = { long = {} } },
            small_island = { tracks = { long = {} } },
            smallgrid = { tracks = { long = {} } },
            utah = { tracks = { long = {} } },
            west_coast_usa = { tracks = { long = {} } }
        }
    else
        self.levels = data.levels
    end
    return self
end

function Leaderboard:addLapTime(data)
    local dataEntry = {
        name = data.name,
		model = data.model,
        owner = data.owner,
        config = data.config,
        lapTime = data.lapTime,
        lapSplits = data.lapSplits,
		penalties = data.penalties
    }

    if not self.levels[data.level].tracks[data.track] then
        self.levels[data.level].tracks[data.track] = {
            overallBestTime = {}
        }
    end

    if not self.levels[data.level].tracks[data.track] then
        self.levels[data.level].tracks[data.track] = {}
        self.levels[data.level].tracks[data.track][data.model] = {
            entries = {}
        }
    end

    if not self.levels[data.level].tracks[data.track][data.model] then
        self.levels[data.level].tracks[data.track][data.model] = {
            entries = {}
        }
    end

    local levelEntries = self.levels[data.level].tracks[data.track][data.model].entries

    local updated = false
    for i, entry in ipairs(levelEntries) do
        if entry.owner == data.owner then
            if data.lapTime < entry.lapTime then
                levelEntries[i] = dataEntry
            end
            updated = true
            break
        end
    end

    if not updated then
        table.insert(levelEntries, dataEntry)
    end

    table.sort(levelEntries, function(a, b) return a.lapTime < b.lapTime end)

    for i = #levelEntries, 2, -1 do
        if levelEntries[i].owner == levelEntries[i - 1].owner then
            table.remove(levelEntries, i)
        end
    end

    self.levels[data.level].tracks[data.track][data.model].overallBestTime = levelEntries[1]

    local overallBestTime = self.levels[data.level].tracks[data.track].overallBestTime
    if not overallBestTime or data.lapTime < overallBestTime.lapTime then
        self.levels[data.level].tracks[data.track].overallBestTime = dataEntry
    end

    WriteJSON(leaderBoardPath, self)

	for vehicle, vehicleBoard in pairs(theLeaderBoard.levels[currentLevel].tracks[currentTrack]) do
		local transmitData = {}
		if vehicle == "overallBestTime" then
			transmitData.track = vehicle
			transmitData.overallBestTime = vehicleBoard
		else
			transmitData.model = vehicle
			transmitData.data = vehicleBoard
		end
		MP.TriggerClientEventJson(-1, "rxLeaderBoard", transmitData)
	end

end

function Leaderboard:removeLapTime(data)

    local entries = self.levels[data.level].tracks[data.track][data.model].entries

    for i, entry in ipairs(entries) do
        if entry.owner == data.owner then
            table.remove(entries, i)
            break
        end
    end

end

local Player = {}
Player.__index = Player

function Player.new(player_name, role, is_guest, identifiers)
    local self = setmetatable({}, Player)
    self.player_name = player_name
    self.role = role
    self.is_guest = is_guest
    self.identifiers = identifiers
    self.vehicles = {}
    self.levels = {}
    return self
end

function Player:update(...)
    local args = {...}
    for i = 1, #args, 2 do
        self[args[i]] = args[i + 1]
    end
end

function Player:disconnect()
    self.player_id = nil
end

function Player.findByName(Players, player_name)
    for _, player in ipairs(Players) do
        if player.player_name == player_name then
            return player
        end
    end
    return nil
end

function Player:addVehicle(vehicle)
    table.insert(self.vehicles, vehicle)
end

function Player:getVehicleById(vehicle_id)
    for _, vehicle in ipairs(self.vehicles) do
        if vehicle.vehicle_id == vehicle_id then
            return vehicle
        end
    end
    return nil
end

function Player:removeVehicleById(vehicle_id)
    for i, vehicle in ipairs(self.vehicles) do
        if vehicle.vehicle_id == vehicle_id then
            table.remove(self.vehicles, i)
            break
        end
    end
end

local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle.new(player_name, vehicle_id, vehicle_data)
    local self = setmetatable({}, Vehicle)
    self.vehicle_id = vehicle_id
    self.vehicle_data = vehicle_data
    self.owner = player_name
    self.lapTimes = vehicle_data.laptimes or {}
    self.checkPointTimes = vehicle_data.checkPointTimes or {}
    return self
end

function Vehicle:update(vehicle_data)
    self.vehicle_data = vehicle_data
end

function Vehicle:addLapTime(data, beammp)
    table.insert(self.lapTimes, data)

    local isNewBest = not self.bestTime or data.lapTime < self.bestTime
    if isNewBest then
        if self.bestTime then
            theLeaderBoard:removeLapTime({
                level = data.level,
                track = data.track,
                model = self.vehicle_data.jbm,
                owner = self.owner
            })
        end

        self.bestTime = data.lapTime
		if #self.lapTimes > 1 then
			table.remove(self.lapTimes, 1)
		end

        MP.TriggerClientEvent(MP.GetPlayerIDByName(self.owner), "rxPersonalBest", tostring(self.bestTime))
    else
		table.remove(self.lapTimes)
        MP.TriggerClientEvent(MP.GetPlayerIDByName(self.owner), "rxCurentLap", tostring(data.lapTime))
    end

    theLeaderBoard:addLapTime({
        level = data.level,
        track = data.track,
        model = self.vehicle_data.jbm,
        owner = self.owner,
        name = Vehicles[self.vehicle_data.jbm],
        config = string.match(self.vehicle_data.vcf.partConfigFilename, ".*/(.*)%.pc"),
        lapTime = data.lapTime,
        lapSplits = data.lapSplits,
		penalties = data.penalties
    })

    local playerJsonPath = playersPath .. beammp .. ".json"
    local playerData = ReadJSON(playerJsonPath)
    if playerData then
        playerData.savedVehicles.levels[currentLevel].tracks[data.track][self.vehicle_data.jbm] = {
            entries = {
                name = Vehicles[self.vehicle_data.jbm],
                config = string.match(self.vehicle_data.vcf.partConfigFilename, ".*/(.*)%.pc"),
                lapTimes = self.lapTimes
            },
            bestTime = self.bestTime
        }
        WriteJSON(playerJsonPath, playerData)
    end
end

local function initializePlayerData(playerData, vehicle_data, level, track)
	playerData.savedVehicles = playerData.savedVehicles or {}
	playerData.savedVehicles.levels = playerData.savedVehicles.levels or {}
	playerData.savedVehicles.levels[currentLevel] = playerData.savedVehicles.levels[currentLevel] or {}
	playerData.savedVehicles.levels[currentLevel].tracks = playerData.savedVehicles.levels[currentLevel].tracks or {}
	playerData.savedVehicles.levels[currentLevel].tracks[currentTrack] = playerData.savedVehicles.levels[currentLevel].tracks[currentTrack] or {}
	playerData.savedVehicles.levels[currentLevel].tracks[currentTrack][vehicle_data.jbm] = playerData.savedVehicles.levels[currentLevel].tracks[currentTrack][vehicle_data.jbm] or {}
	playerData.savedVehicles.levels[currentLevel].tracks[currentTrack][vehicle_data.jbm].entries = playerData.savedVehicles.levels[currentLevel].tracks[currentTrack][vehicle_data.jbm].entries or {}
end

local function processVehicleData(player_id, vehicle_id, data)
	local separator = data:find('%{')
	local raw_data = data:sub(separator)
	local vehicle_data = Util.JsonDecode(raw_data)
	vehicle_data.serverVID = player_id .. "-" .. vehicle_id
	return vehicle_data
end

local function addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
    print(" Adding " .. vehicle_data.jbm .. " for " .. player.player_name .. "!")
    initializePlayerData(playerData, vehicle_data, currentLevel, currentTrack)
    WriteJSON(playerJsonPath, playerData)
    local spawnVehicle = Vehicle.new(player.player_name, vehicle_id, vehicle_data)
    player:addVehicle(spawnVehicle)
end

local function loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
    local vehicleEntry = playerData.savedVehicles.levels[currentLevel].tracks[currentTrack][vehicle_data.jbm]
    local existingVehicle = Vehicle.new(player.player_name, vehicle_id, vehicle_data)
    existingVehicle.bestTime = vehicleEntry.bestTime
	if vehicleEntry.entries then
    	existingVehicle.lapTimes = vehicleEntry.entries.lapTimes
	end
    player:addVehicle(existingVehicle)
    print(" Loading existing vehicle " .. vehicle_data.jbm .. " for " .. player.player_name .. "!")
end

function onInit()

	if not FS.IsDirectory(jsonPath) then
		FS.CreateDirectory(jsonPath)
	end

	Levels = ReadJSON(levelsPath)
	if not Levels then
		if not FS.IsDirectory(jsonPath .. "levels/") then
			print(" levels directory not found or empty. Creating levels directory!")
			FS.CreateDirectory(jsonPath .. "levels/")
		end
		Levels = {
			hirochi_raceway = {
				tracks = {
					long = {
						checkPoints = {
							startStop = {
								rot = {
									[1] = 0.535,
									[2] = -0.844,
									[3] = 0,
									[4] = 0.844,
									[5] = 0.535,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "startStop",
								scale = {
									y = 22,
									z = 10,
									x = 2,
								},
								pos = {
									y = 245.12,
									z = 24.99,
									x = -402.26,
								},
								color = {
									a = 33,
									b = 0,
									g = 0,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit1 = {
								rot = {
									[1] = 0.837,
									[2] = 0.547,
									[3] = 0,
									[4] = -0.547,
									[5] = 0.837,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit1",
								scale = {
									y = 30,
									z = 10,
									x = 2,
								},
								pos = {
									y = 121.053,
									z = 25.085,
									x = -157.732,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit2 = {
								rot = {
									[1] = 0.999,
									[2] = -0.01,
									[3] = 0,
									[4] = 0.01,
									[5] = 0.999,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit2",
								scale = {
									y = 20,
									z = 10,
									x = 2,
								},
								pos = {
									y = 257.934,
									z = 28.771,
									x = 60.874,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit3 = {
								rot = {
									[1] = 0.455,
									[2] = 0.89,
									[3] = 0,
									[4] = -0.89,
									[5] = 0.455,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit3",
								scale = {
									y = 25,
									z = 10,
									x = 2,
								},
								pos = {
									y = -138.042,
									z = 35.339,
									x = 390.554,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit4 = {
								rot = {
									[1] = 0.813,
									[2] = 0.581,
									[3] = 0,
									[4] = -0.581,
									[5] = 0.813,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit4",
								scale = {
									y = 25,
									z = 10,
									x = 2,
								},
								pos = {
									y = -468.355,
									z = 39.266,
									x = 303.267,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit5 = {
									rot = {
										[1] = 0.394,
										[2] = -0.918,
										[3] = 0,
										[4] = 0.918,
										[5] = 0.394,
										[6] = 0,
										[7] = 0,
										[8] = 0,
										[9] = 1,
									},
									debug = "1",
									name = "lapSplit5",
									scale = {
										y = 20,
										z = 10,
										x = 2,
									},
									pos = {
										y = -145.063,
										z = 25.486,
										x = 26.483,
									},
									color = {
										a = 33,
										b = 0,
										g = 255,
										r = 255,
									},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit6 = {
								rot = {
									[1] = 0.29,
									[2] = 0.956,
									[3] = 0,
									[4] = -0.956,
									[5] = 0.29,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit6",
								scale = {
									y = 25,
									z = 10,
									x = 2,
								},
								pos = {
									y = 257.461,
									z = 31.087,
									x = -155.308,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit7 = {
								rot = {
									[1] = 0.994,
									[2] = -0.105,
									[3] = 0,
									[4] = 0.105,
									[5] = 0.994,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit7",
								scale = {
									y = 33,
									z = 10,
									x = 2,
								},
								pos = {
									y = 426.423,
									z = 30.682,
									x = -355.912,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit8 = {
								rot = {
									[1] = 0.431,
									[2] = -0.902,
									[3] = 0,
									[4] = 0.902,
									[5] = 0.431,
									[6] = 0,
									[7] = 0,
									[8] = 0,
									[9] = 1,
								},
								debug = "1",
								name = "lapSplit8",
								scale = {
									y = 30,
									z = 10,
									x = 2,
								},
								pos = {
									y = 396.407,
									z = 25.134,
									x = -499.912,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							}
						}
					}
				}
			},
			smallgrid = {
				tracks = {
					long = {
						checkPoints = {
							startStop = {
								debug = "1",
								name = "startStop",
								scale = {
									y = 22,
									z = 10,
									x = 2,
								},
								pos = {
									y = 0,
									z = 0,
									x = 5,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 0,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit1 = {
								debug = "1",
								name = "lapSplit1",
								scale = {
									y = 22,
									z = 10,
									x = 2,
								},
								pos = {
									y = 0,
									z = 0,
									x = 10,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							lapSplit2 = {
								debug = "1",
								name = "lapSplit2",
								scale = {
									y = 22,
									z = 10,
									x = 2,
								},
								pos = {
									y = 0,
									z = 0,
									x = 15,
								},
								color = {
									a = 33,
									b = 0,
									g = 255,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							},
							outOfBounds1 = {
								debug = "1",
								name = "outOfBounds1",
								scale = {
									y = 22,
									z = 10,
									x = 2,
								},
								pos = {
									y = 0,
									z = 0,
									x = 20,
								},
								color = {
									a = 33,
									b = 0,
									g = 0,
									r = 255,
								},
								test = "Race corners",
								mode = "Overlaps",
								type = "Box",
							}
						}
					}
				}
			}
		}
		WriteJSON(levelsPath, Levels)
	end

	theLeaderBoard = ReadJSON(leaderBoardPath)
	if not theLeaderBoard then
		if not FS.IsDirectory(jsonPath .. "leaderboard/") then
			print(" leaderboard directory not found. Creating leaderboard directory!")
			FS.CreateDirectory(jsonPath .. "leaderboard/")
		end
		theLeaderBoard = Leaderboard.new()
		WriteJSON(leaderBoardPath, theLeaderBoard)
	else
		theLeaderBoard = Leaderboard.new(theLeaderBoard)
	end
	--print(theLeaderBoard)
	if not FS.IsDirectory(playersPath) then
		print(" players directory not found. Creating players directory!")
		FS.CreateDirectory(playersPath)
	end
	playerJsons = FS.ListFiles(playersPath)
	if #playerJsons == 0 then
		print(" players directory empty. Creating dummy player!")
		local dummy = Player.new("dummy", "USER", false, { ip = "0.0.0.0", beammp = 0 })
		table.insert(Players, dummy)
		WriteJSON(playersPath .. dummy.identifiers.beammp .. ".json", dummy)
	else
		for _, playerJson in pairs(playerJsons) do
			local player
			local playerJsonPath = playersPath .. playerJson
			player = ReadJSON(playerJsonPath)
			if player then
				print(" Loading Existing Player: " .. player.player_name)
				local existingPlayer = Player.new(player.player_name, player.role, player.is_guest, player.identifiers)
				table.insert(Players, existingPlayer)
			end
		end
	end

	Vehicles = ReadJSON(vehiclesPath)
	if not Vehicles then
		if not FS.IsDirectory(jsonPath .. "vehicles/") then
			print(" vehicles directory not found or empty. Creating vehicles directory!")
			FS.CreateDirectory(jsonPath .. "vehicles/")
			Vehicles = {
				atv = "Wydra",
				autobello = "Piccolina",
				barstow = "Barstow",
				bastion = "Bastion",
				bluebuck = "Bluebuck",
				bolide = "Bolide",
				burnside = "Burnside",
				bx = "BX",
				cannon = "Cannon",
				citybus = "City Bus",
				covet = "Covet",
				etk800 = "ETK 800-Series",
				etkc = "ETK K-Series",
				etki = "ETK I-Series",
				fullsize = "Grand Marshal",
				hopper = "Hopper",
				lansdale = "Lansdale",
				legran = "LeGran",
				midsize = "Pessima '96-'00",
				midtruck = "Stambecco",
				miramar = "Miramar",
				moonhawk = "Moonhawk",
				pessima = "Pessima '88-'91",
				pickup = "D-Series",
				pigeon = "Pigeon",
				racetruck = "Dunekicker",
				roamer = "Roamer",
				rockbouncer = "Rockbasher",
				sbr = "SBR4",
				scintilla = "Scintilla",
				sunburst = "Sunburst",
				unicycle = "Player Model",
				us_semi = "T-Series",
				utv = "Hirochi Aurata",
				van = "H-Series",
				vivace = "FCV",
				wendover = "Wendover",
				wigeon = "Wigeon"
			}
			WriteJSON(vehiclesPath, Vehicles)
		end
	end

    MP.RegisterEvent("onPlayerAuth","onPlayerAuthHandler")

    MP.RegisterEvent("onPlayerConnecting","onPlayerConnectingHandler")
    MP.RegisterEvent("onPlayerDisconnect","onPlayerDisconnectHandler")

	MP.RegisterEvent("onVehicleSpawn","onVehicleSpawnHandler")
    MP.RegisterEvent("onVehicleEdited","onVehicleEditedHandler")
    MP.RegisterEvent("onVehicleDeleted","onVehicleDeletedHandler")

    MP.RegisterEvent("onLapStart","onLapStart")
	MP.RegisterEvent("onLapStop","onLapStop")
	MP.RegisterEvent("onLapSplit","onLapSplit")

	MP.RegisterEvent("requestHotLapsSync","requestHotLapsSync")

	print(" hotLaps Loaded!")

end

function onLapStart(player_id, data)

end

function onLapSplit(player_id, data)
	local splitData = Util.JsonDecode(data)
	local player = nil
    for i, p in ipairs(Players) do
        if p.player_id == player_id then
            player = p
            break
        end
    end

	local splitState = "neutral"

	if player then
		local vehicle = player:getVehicleById(tonumber(string.sub(splitData.serverVehicleID, -1)))
		if vehicle then
			if vehicle.lapTimes then
				if vehicle.lapTimes[1] then
					if vehicle.lapTimes[1].lapSplits then
						if vehicle.lapTimes[1].lapSplits[splitData.splitTimeID] then
							if vehicle.lapTimes[1].lapSplits[splitData.splitTimeID] < splitData.lapSplit then
								splitState = "loss"
							end
							if vehicle.lapTimes[1].lapSplits[splitData.splitTimeID] > splitData.lapSplit then
								splitState = "gain"
							end
						end
					end
				end
			end
		end
	end

	if splitState then
		if splitState == "gain" then
			if player then
				local vehicle = player:getVehicleById(tonumber(string.sub(splitData.serverVehicleID, -1)))
				if vehicle then
					local sendData = {
						time = splitData.lapSplit,
						difference = vehicle.lapTimes[1].lapSplits[splitData.splitTimeID] - splitData.lapSplit,
						splitTimeID = splitData.splitTimeID,
						checkpointCount = splitData.checkpointCount,
						triggerName = splitData.triggerName
					}
					MP.TriggerClientEventJson(MP.GetPlayerIDByName(vehicle.owner), "rxGain", sendData)
				end
			end
		end


		if splitState == "loss" then
			if player then
				local vehicle = player:getVehicleById(tonumber(string.sub(splitData.serverVehicleID, -1)))
				if vehicle then
					local sendData = {
						time = splitData.lapSplit,
						difference =  splitData.lapSplit - vehicle.lapTimes[1].lapSplits[splitData.splitTimeID],
						splitTimeID = splitData.splitTimeID,
						checkpointCount = splitData.checkpointCount,
						triggerName = splitData.triggerName
					}
					MP.TriggerClientEventJson(MP.GetPlayerIDByName(vehicle.owner), "rxLoss", sendData)
				end
			end
		end

		if splitState == "neutral" then
			if player then
				local vehicle = player:getVehicleById(tonumber(string.sub(splitData.serverVehicleID, -1)))
				if vehicle then
					local sendData = {
						time = splitData.lapSplit,
						splitTimeID = splitData.splitTimeID,
						checkpointCount = splitData.checkpointCount,
						triggerName = splitData.triggerName
					}
					MP.TriggerClientEventJson(MP.GetPlayerIDByName(vehicle.owner), "rxNeutral", sendData)
				end
			end
		end
	end

end

function onLapStop(player_id, data)
	local lapData = Util.JsonDecode(data)
    local player = nil
    for i, p in ipairs(Players) do
        if p.player_id == player_id then
            player = p
            break
        end
    end
	if player then
		local vehicle = player:getVehicleById(tonumber(string.sub(lapData.serverVehicleID, -1)))
		if vehicle then
			local dataEntry = {
				lapTime = lapData.lapTime,
				lapSplits = lapData.lapSplits,
				level = lapData.level,
				track = lapData.track,
				penalties = lapData.penalties
			}
			vehicle:addLapTime(dataEntry, player.identifiers.beammp)
		end
	end
end

function onPlayerAuthHandler(player_name, role, is_guest, identifiers)
	if identifiers.beammp then
        local playerTable
        local playerJsonPath = playersPath .. identifiers.beammp .. ".json"
        playerTable = ReadJSON(playerJsonPath)
        if not playerTable then
            print(" Creating file for " .. player_name .. "!")
            local playerData = {}
            playerData.player_name = player_name
            playerData.role = role
            playerData.identifiers = identifiers
            WriteJSON(playerJsonPath, playerData)
        end
		local player = Player.findByName(Players, player_name)
		if not player then
			local authPlayer = Player.new(player_name, role, is_guest, identifiers)
			table.insert(Players, authPlayer)
		end
	end
end

function onPlayerConnectingHandler(player_id)
    local player_name = MP.GetPlayerName(player_id)
    local player = Player.findByName(Players, player_name)
    if player then
        player:update("player_id", player_id)
    else
        MP.DropPlayer(player_id, "Connection Fault: Please Reconnect!")
    end
end

function onPlayerDisconnectHandler(player_id)
    for i, player in ipairs(Players) do
        if player.player_id == player_id then
            for _, vehicle in pairs(player.vehicles) do
                player:removeVehicleById(vehicle.vehicle_id)
            end
            player:disconnect()
            break
        end
    end
end

local function findPlayer(player_id)
    for _, player in ipairs(Players) do
        if player.player_id == player_id then
            return player
        end
    end
    return nil
end

function onVehicleSpawnHandler(player_id, vehicle_id, data)
    local player = findPlayer(player_id)
    if not player then return end
    local vehicle_data = processVehicleData(player_id, vehicle_id, data)
    local playerJsonPath = playersPath .. player.identifiers.beammp .. ".json"
    local playerData = ReadJSON(playerJsonPath)
    if playerData then
        local trackData = playerData.savedVehicles and
                          playerData.savedVehicles.levels[currentLevel] and
                          playerData.savedVehicles.levels[currentLevel].tracks[currentTrack]

        if not trackData or not trackData[vehicle_data.jbm] then
            addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
        else
            loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
        end
    end
end

function onVehicleEditedHandler(player_id, vehicle_id, data)
    local player = findPlayer(player_id)
    if not player then return end
    local vehicle_data = processVehicleData(player_id, vehicle_id, data)
    local playerJsonPath = playersPath .. player.identifiers.beammp .. ".json"
    local playerData = ReadJSON(playerJsonPath)
    if playerData then
        local vehicle = player:getVehicleById(vehicle_id)
        if vehicle then
            if vehicle.vehicle_data.jbm ~= vehicle_data.jbm then
                player:removeVehicleById(vehicle_id)
                local trackData = playerData.savedVehicles and
                                  playerData.savedVehicles.levels[currentLevel] and
                                  playerData.savedVehicles.levels[currentLevel].tracks[currentTrack]
                if not trackData or not trackData[vehicle_data.jbm] then
                    addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
                else
                    loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
                end
            elseif vehicle.vehicle_data.vcf.partConfigFilename ~= vehicle_data.vcf.partConfigFilename then
				player:removeVehicleById(vehicle_id)
                local trackData = playerData.savedVehicles and
                                  playerData.savedVehicles.levels[currentLevel] and
                                  playerData.savedVehicles.levels[currentLevel].tracks[currentTrack]
                if not trackData or not trackData[vehicle_data.jbm] then
                    addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
                else
                    loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
                end
			end
        end
    end
end

function onVehicleDeletedHandler(player_id, vehicle_id)
    local player = nil
    for i, p in ipairs(Players) do
        if p.player_id == player_id then
            player = p
            break
        end
    end
    if player then
        player:removeVehicleById(vehicle_id)
    end
end

function ReadJSON(path)
	if not FS.Exists(path) then
		print(" " .. path .. " does not exist!")
		return
	end
	local JSONfile = io.open(path,"r")
    if JSONfile then
        local JSONtext = JSONfile:read("*a")
        JSONfile:close()
        local data = Util.JsonDecode(JSONtext)
        return data
    else
        print(" " .. path .. " does not exist!")
		return
    end
end

function WriteJSON(path, data)
	local JSONfile = io.open(path,"w")
    if JSONfile then
        JSONfile:write(Util.JsonPrettify(Util.JsonEncode(data or {})))
        JSONfile:close()
        return true
    else
        print(" " .. path .. " does not exist!")
		return
    end
end

function requestHotLapsSync(player_id)
	for vehicle, vehicleBoard in pairs(theLeaderBoard.levels[currentLevel].tracks[currentTrack]) do
		local transmitData = {}
		if vehicle == "overallBestTime" then
			transmitData.track = vehicle
			transmitData.overallBestTime = vehicleBoard
		else
			transmitData.model = vehicle
			transmitData.data = vehicleBoard
		end
		MP.TriggerClientEventJson(player_id, "rxLeaderBoard", transmitData)
	end
end
