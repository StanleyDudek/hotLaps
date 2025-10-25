
local M = {}

local vehiclesLookup = {
	atv = { model = "Wydra", make = "FPU" },
	autobello = { model = "Piccolina", make = "Autobello" },
	barstow = { model = "Barstow", make = "Gavril" },
	bastion = { model = "Bastion", make = "Bruckell" },
	bluebuck = { model = "Bluebuck", make = "Gavril" },
	bolide = { model = "Bolide", make = "Civetta" },
	burnside = { model = "Special", make = "Burnside" },
	bx = { model = "BX-Series", make = "Ibishu" },
	cannon = { model = "Old Cannon", make = "BeamNG" },
	citybus = { model = "DT40L", make = "Wentward" },
	covet = { model = "Covet", make = "Ibishu" },
	etk800 = { model = "800-Series", make = "ETK" },
	etkc = { model = "K-Series", make = "ETK" },
	etki = { model = "I-Series", make = "ETK" },
	fullsize = { model = "Grand Marshal", make = "Gavril" },
	hopper = { model = "Hopper", make = "Ibishu" },
	lansdale = { model = "Lansdale", make = "Soliad" },
	legran = { model = "LeGran", make = "Bruckell" },
	midsize = { model = "Pessima '96-'00", make = "Ibishu" },
	midtruck = { model = "Stambecco", make = "Autobello" },
	miramar = { model = "Miramar", make = "Ibishu" },
	moonhawk = { model = "Moonhawk", make = "Bruckell" },
	pessima = { model = "Pessima '88-'91", make = "Ibishu" },
	pickup = { model = "D-Series", make = "Gavril" },
	pigeon = { model = "Pigeon", make = "Ibishu" },
	racetruck = { model = "Dunekicker", make = "SP" },
	roamer = { model = "Roamer", make = "Gavril" },
	rockbouncer = { model = "Rockbasher", make = "SP" },
	sbr = { model = "SBR4", make = "Hirochi" },
	scintilla = { model = "Scintilla", make = "Civetta" },
	sunburst = { model = "Sunburst", make = "Hirochi" },
	unicycle = { model = "Player Model", make = "BeamNG" },
	us_semi = { model = "T-Series", make = "Gavril"	},
	utv = { model = "Aurata", make = "Hirochi" },
	van = {	model = "H-Series",	make = "Gavril"	},
	vivace = { model = "FCV", make = "Cherrier"	},
	wendover = { model = "Wendover", make = "Soliad" },
	wigeon = { model = "Wigeon", make = "Ibishu" }
}

-- Extract data and sort it
local sortedVehicles = {}
for genericName, vehicleData in pairs(vehiclesLookup) do
	table.insert(sortedVehicles, {genericName = genericName, make = vehicleData.make, model = vehicleData.model})
end

table.sort(sortedVehicles, function(a, b)
	if a.make == b.make then
		return a.model < b.model
	else
		return a.make < b.make
	end
end)

local hotLaps_VERSION = "0.0.2"

local gui_module = require("ge/extensions/editor/api/gui")
local gui = {setupEditorGuiTheme = nop}

local im = ui_imgui

local windowOpen = im.BoolPtr(true)

local ffi = require('ffi')

local levelIdentifier
local trackIdentifier = "long"

local checkpointCount = 0

local penaltyCount = 0

local lapActive = false
local splitTime
local stopTime
local lapStart
local lapSplit
local lapTime
local lapSplits = {}
local checkpointTimes = {}
local verifySplits = {}

local timer = 0

local function tableLength(t)
	local counter = 0
	for _ in pairs(t) do
		counter = counter + 1
	end
	return counter
end

local checkPoints = {}

local checkPointsData = {
	levels = {
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
}

local function prettyTime(seconds)
	local thousandths = seconds * 1000
	local mm = math.floor((thousandths / (60 * 1000))) % 60
	local ss = math.floor(thousandths / 1000) % 60
	local ms = math.floor(thousandths % 1000)
	return string.format("%02d:%02d.%03d", mm, ss, ms)
end

local function prettySeconds(seconds)
	local thousandths = seconds * 1000
	local ss = math.floor(thousandths / 1000) % 60
	local ms = math.floor(thousandths % 1000)
	return string.format("%02d.%03d", ss, ms)
end

local theLeaderBoard = {}
theLeaderBoard.levels = {}

local syncRequested = false

local function rxLeaderBoard(data)
	local recievedData = jsonDecode(data)
	if recievedData.overallBestTime then
		theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier].overallBestTime = recievedData.overallBestTime
	elseif recievedData.data then
		theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][recievedData.model] = {
			entries = recievedData.data.entries,
			overallBestTime = recievedData.data.overallBestTime
			}
	end
end



local function rxLeaderBoardUpdate(data)



end



local function rxNewEntry()



end



local function rxPersonal()



end



local function rxPersonalBest(time)
	guihooks.trigger('toastrMsg', {type="success", title = "New Best Time!!!", msg = "Your Lap Time was: " .. prettyTime(time), config = {timeOut = 10000 }})
	guihooks.trigger('ScenarioFlashMessage', {{"New Best: " .. prettyTime(time), 5, "Engine.Audio.playOnce('AudioGui', 'event:UI_CountdownGo')", false}})
end

local function rxCurentLap(time)
	guihooks.trigger('toastrMsg', {type="warning", title = "Great Lap!", msg = "Your Lap Time was: " .. prettyTime(time), config = {timeOut = 5000 }})
	guihooks.trigger('ScenarioFlashMessage', {{prettyTime(time), 5, "Engine.Audio.playOnce('AudioGui', 'event:UI_CountdownGo')", false}})
end

local function rxGain(data)
	local splitData = jsonDecode(data)
	local prettyDifference
	local time
	if splitData.difference > 60 then
		prettyDifference = prettyTime(splitData.difference)
	else
		prettyDifference = prettySeconds(splitData.difference)
	end
	if splitData.time > 60 then
		time = prettyTime(splitData.time)
	else
		time = prettySeconds(splitData.time)
	end
	guihooks.trigger('toastrMsg', {type="success", title = "-" .. prettyDifference .. " || " .. time, msg = splitData.triggerName .. " (" .. splitData.splitTimeID .. "/" .. splitData.checkpointCount .. ")", config = {timeOut = 5000 } })
	guihooks.trigger('ScenarioFlashMessage', {{"-" .. prettyDifference, 5, "Engine.Audio.playOnce('AudioGui', 'event:UI_CountdownGo')", false}})
end

local function rxLoss(data)
	local splitData = jsonDecode(data)
	local prettyDifference
	local time
	if splitData.difference > 60 then
		prettyDifference = prettyTime(splitData.difference)
	else
		prettyDifference = prettySeconds(splitData.difference)
	end
	if splitData.time > 60 then
		time = prettyTime(splitData.time)
	else
		time = prettySeconds(splitData.time)
	end
	guihooks.trigger('toastrMsg', {type="error", title = "+" .. prettyDifference .. " || " .. time, msg = splitData.triggerName .. " (" .. splitData.splitTimeID .. "/" .. splitData.checkpointCount .. ")", config = {timeOut = 5000 } })
	guihooks.trigger('ScenarioFlashMessage', {{"+" .. prettyDifference, 5, "Engine.Audio.playOnce('AudioGui', 'event:UI_CountdownGo')", false}})
end

local function rxNeutral(data)
	local splitData = jsonDecode(data)
	local time
	if splitData.time > 60 then
		time = prettyTime(splitData.time)
	else
		time = prettySeconds(splitData.time)
	end
	guihooks.trigger('toastrMsg', {type="warning", title = time , msg = splitData.triggerName .. " (" .. splitData.splitTimeID .. "/" .. splitData.checkpointCount .. ")", config = {timeOut = 5000 } })
	guihooks.trigger('ScenarioFlashMessage', {{time, 5, "Engine.Audio.playOnce('AudioGui', 'event:UI_CountdownGo')", false}})
end

local function pushStyle()
    local colors = {
        {im.Col_Border, im.ImVec4(1.0, 0.25, 0.25, 0.5)},
        {im.Col_ResizeGrip, im.ImVec4(0.75, 0.15, 0.15, 0.5)},
        {im.Col_ResizeGripHovered, im.ImVec4(0.66, 0.15, 0.15, 0.5)},
        {im.Col_ResizeGripActive, im.ImVec4(0.95, 0.15, 0.15, 0.5)},
        {im.Col_TitleBg, im.ImVec4(0.75, 0.15, 0.15, 0.888)},
        {im.Col_TitleBgActive, im.ImVec4(0.5, 0.05, 0.05, 0.5)},
        {im.Col_TitleBgCollapsed, im.ImVec4(0.33, 0, 0, 0.5)},
        {im.Col_Tab, im.ImVec4(1.0, 0.33, 0.33, 0.5)},
        {im.Col_TabHovered, im.ImVec4(1.0, 0.50, 0.50, 0.5)},
        {im.Col_TabActive, im.ImVec4(1.0, 0.125, 0.125, 0.5)},
        {im.Col_FrameBg, im.ImVec4(0.33, 0, 0, 0.5)},
        {im.Col_FrameBgHovered, im.ImVec4(0.44, 0, 0, 0.5)},
        {im.Col_FrameBgActive, im.ImVec4(0.22, 0, 0, 0.5)},
        {im.Col_Header, im.ImVec4(0.5, 0.25, 0.25, 0.5)},
        {im.Col_HeaderHovered, im.ImVec4(0.66, 0.33, 0.33, 0.5)},
        {im.Col_HeaderActive, im.ImVec4(0.77, 0.4, 0.4, 0.5)},
        {im.Col_Separator, im.ImVec4(0.95, 0.66, 0.66, 0.75)},
        {im.Col_SeparatorHovered, im.ImVec4(0.95, 0.77, 0.77, 0.75)},
        {im.Col_SeparatorActive, im.ImVec4(0.95, 0.4, 0.4, 0.5)},
        {im.Col_Button, im.ImVec4(0.75, 0.15, 0.15, 0.333)},
        {im.Col_ButtonHovered, im.ImVec4(0.69, 0.1, 0.1, 0.5)},
        {im.Col_ButtonActive, im.ImVec4(0.55, 0.05, 0.05, 0.999)}
    }
    for _, color in ipairs(colors) do
        im.PushStyleColor2(color[1], color[2])
    end
	im.SetNextWindowBgAlpha(0.888)
end

local function drawHotLaps(dt)
	if not syncRequested then
		return
	end

	pushStyle()

	im.Begin("hotLaps v" .. hotLaps_VERSION)
		im.BeginChild1("Info Area", im.ImVec2(0, 75), true)
			if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier] then
				local trackData = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier]
				local bestTimeData = trackData.overallBestTime
				if bestTimeData then
					if bestTimeData.lapTime then
						im.TextColored(im.ImVec4(1, 1, 0, 1), "Best Lap:")
						im.SameLine()
						im.TextColored(im.ImVec4(0, 1, 0, 1), prettyTime(bestTimeData.lapTime))
						im.SameLine()
						im.Text("P: " .. tostring(bestTimeData.penalties))
						im.Separator()
						im.Indent()
						im.TextColored(im.ImVec4(1, 0, 1, 1), "Vehicle:")
						im.SameLine()
						im.Text(vehiclesLookup[bestTimeData.model].make .. " " .. vehiclesLookup[bestTimeData.model].model .. " (" .. bestTimeData.config .. ")")
						im.TextColored(im.ImVec4(0, 1, 1, 1), "Driver:")
						im.SameLine()
						im.Text(bestTimeData.owner)
						im.Unindent()
					else
						im.TextColored(im.ImVec4(0.9, 0.1, 0.1, 1), "No Laptimes Set! You can be the first!")
					end
				end
			end
		im.EndChild()
		if im.BeginTabBar("TabBar") then
			if im.BeginTabItem("Track") then
				im.BeginChild1("Track Tab", im.ImVec2(0, 0), true, im.ImGuiWindowFlags_AlwaysAutoResize)
					local makes = {}
					for _, vehicle in ipairs(sortedVehicles) do
						if not makes[vehicle.make] then
							makes[vehicle.make] = {}
						end
						table.insert(makes[vehicle.make], vehicle.model)
					end
					local sortedMakes = {}
					for make in pairs(makes) do
						table.insert(sortedMakes, make)
					end
					table.sort(sortedMakes)
					for x, make in ipairs(sortedMakes) do

						if im.TreeNode1(make) then
							local models = makes[make]
							table.sort(models)
							for _, model in ipairs(models) do
								local genericName
								for i, j in pairs(vehiclesLookup) do
									if j.model == model then
										genericName =  i
										break
									end
								end
								local bestTime = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].overallBestTime
								if bestTime.lapTime then
									if im.TreeNode1(model .. ": " .. prettyTime(bestTime.lapTime) .. " - " .. bestTime.config .. " - P: " .. bestTime.penalties) then
										for i, j in pairs(vehiclesLookup) do
											if j.model == model then
												if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName] then
													if bestTime then
														if im.TreeNode1(bestTime.owner .. ": " .. prettyTime(bestTime.lapTime)) then
															im.Indent()
															for index, time in ipairs(bestTime.lapSplits) do
																im.Text(string.char(index+64) .. ": " .. prettyTime(time))
															end
															im.Unindent()
															im.TreePop()
														end
													end
													local entries = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].entries
													if entries then
														for _, entry in pairs(entries) do
															if entry.owner ~= bestTime.owner then
																if im.TreeNode1(entry.owner .. ": " .. prettyTime(entry.lapTime) .. " - " .. entry.config) then
																	im.Indent()
																	for index, time in ipairs(entry.lapSplits) do
																		im.Text(string.char(index+64) .. ": " .. prettyTime(time))
																	end
																	im.Unindent()
																	im.TreePop()
																end
															end
														end
													end
												end
											end
										end
										im.TreePop()
									end
								else
									if im.TreeNode1(model) then
										im.Text("No Laptimes Set! You can be the first!")
										im.TreePop()
									end
								end
							end
							im.TreePop()
						end

					end
				im.EndChild()
				im.EndTabItem()
			end
			if im.BeginTabItem("Personal") then
				im.BeginChild1("Personal Tab", im.ImVec2(0, 0), true, im.ImGuiWindowFlags_AlwaysAutoResize)
					local makes = {}
					for _, vehicle in ipairs(sortedVehicles) do
						if not makes[vehicle.make] then
							makes[vehicle.make] = {}
						end
						table.insert(makes[vehicle.make], vehicle.model)
					end
					local sortedMakes = {}
					for make in pairs(makes) do
						table.insert(sortedMakes, make)
					end
					table.sort(sortedMakes)
					for x, make in ipairs(sortedMakes) do

						if im.TreeNode1(make) then
							local models = makes[make]
							table.sort(models)
							for _, model in ipairs(models) do
								local genericName
								for i, j in pairs(vehiclesLookup) do
									if j.model == model then
										genericName =  i
										break
									end
								end
								local playerInfo
								if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].entries then
									for k,v in pairs(theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].entries) do
										if k ~= "overallBestTime" then
											if v.owner == MPConfig.getNickname() then
												playerInfo = v
											end
										end
									end
								end
								if playerInfo then
									if im.TreeNode1(model .. ": " .. prettyTime(playerInfo.lapTime) .. " - " .. playerInfo.config .. " - P: " .. playerInfo.penalties) then
										for i, j in pairs(vehiclesLookup) do
											if j.model == model then
												if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName] then
													local entries = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].entries
													if entries then
														for _, entry in pairs(entries) do
															if entry.owner == MPConfig.getNickname() then
																for index, time in ipairs(entry.lapSplits) do
																	im.Text(string.char(index+64) .. ": " .. prettyTime(time))
																end
															end
														end
													end
												end
											end
										end
										im.TreePop()
									end
								else
									if im.TreeNode1(model) then
										im.Text("No Laptimes Set!")
										im.TreePop()
									end
								end
							end
							im.TreePop()
						end
					end
				im.EndChild()
				im.EndTabItem()
			end
			if im.BeginTabItem("Vehicle") then
				im.BeginChild1("Vehicle Tab", im.ImVec2(0, 0), true, im.ImGuiWindowFlags_AlwaysAutoResize)
					if be:getPlayerVehicle(0) then
						local bestTime = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][be:getPlayerVehicle(0).JBeam].overallBestTime
						if bestTime.lapTime then
							im.Text(vehiclesLookup[be:getPlayerVehicle(0).JBeam].model .. ": " .. prettyTime(bestTime.lapTime))
							for i, j in pairs(vehiclesLookup) do
								if i == be:getPlayerVehicle(0).JBeam then
									if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][be:getPlayerVehicle(0).JBeam] then
										if bestTime then
											if im.TreeNode1(bestTime.owner .. ": " .. prettyTime(bestTime.lapTime) .. " - " .. bestTime.config .. " - P: " .. bestTime.penalties) then
												im.Indent()
												for index, time in ipairs(bestTime.lapSplits) do
													im.Text(string.char(index+64) .. ": " .. prettyTime(time))
												end
												im.Unindent()
												im.TreePop()
											end
										end
										local entries = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][be:getPlayerVehicle(0).JBeam].entries
										if entries then
											for _, entry in pairs(entries) do
												if entry.owner ~= bestTime.owner then
													if im.TreeNode1(entry.owner .. ": " .. prettyTime(entry.lapTime) .. " - " .. entry.config) then
														im.Indent()
														for index, time in ipairs(entry.lapSplits) do
															im.Text(string.char(index+64) .. ": " .. prettyTime(time))
														end
														im.Unindent()
														im.TreePop()
													end
												end
											end
										end
									end
								end
							end
						else
							im.Text(vehiclesLookup[be:getPlayerVehicle(0).JBeam].model)
							im.Text("No Laptimes Set! You can be the first!")
						end
					else
						im.Text("No Vehicle Spawned!")
					end
				im.EndChild()
				im.EndTabItem()
			end
			im.EndTabBar()
		end
		im.PopStyleColor(22)
	im.End()
end

local function createCheckPoint(data)
    local checkPoint =  createObject('BeamNGTrigger')
    checkPoint:setField('name', 0, data.name)
    checkPoint:setField('triggerType', 0, data.type)
    checkPoint:setField('triggerMode', 0, data.mode)
    checkPoint:setField('triggerTestType', 0, data.test)
    checkPoint:setField('triggerColor', 0, data.color.r .. " " .. data.color.g .. " " .. data.color.b .. " " .. data.color.a)
    checkPoint:setField('debug', 0, '1')
    if data.rot then
		checkPoint:setField('rotationMatrix', 0, data.rot[1] .. " " .. data.rot[2] .. " " .. data.rot[3] .. " " .. data.rot[4] .. " " .. data.rot[5] .. " " .. data.rot[6] .. " " .. data.rot[7] .. " " .. data.rot[8] .. " " .. data.rot[9])
	end
    checkPoint:registerObject(data.name)
    checkPoint:setPosition(vec3(data.pos.x, data.pos.y, data.pos.z))
    checkPoint:setScale(vec3(data.scale.x, data.scale.y, data.scale.z))
    checkPoint.canSave = false
    return checkPoint
end

local function onLapStart()
	if not lapActive then
		lapActive = true
		timer = 0
		lapStart = timer
		lapSplits = {}
		checkpointTimes.startStop = lapStart
		checkpointTimes.startTimeStamp = os.time()
		guihooks.trigger('toastrMsg', {type="info", title = "Hotlap Started!", msg = "Drive through all checkpoints to log a time!", config = {timeOut = 2500 }})
		local data = jsonEncode( { ["startStop"] = checkpointTimes.startStop, ["startTimeStamp"] = checkpointTimes.startTimeStamp } )
		TriggerServerEvent("onLapStart", data)
	end
end

local function onLapSplit(triggerName, gameVehicleID)
	local serverVehicleID = MPVehicleGE.getServerVehicleID(gameVehicleID)
	if lapActive then
		local splitTimeID = tonumber(triggerName:sub(9))
		triggerName = "Checkpoint " .. string.char(splitTimeID+64)
		verifySplits[triggerName] = 1
		splitTime = timer
		lapSplit = splitTime - lapStart
		if splitTimeID then
			lapSplits[splitTimeID] = lapSplit
		end
		local data = jsonEncode( { serverVehicleID = serverVehicleID, splitTimeID = splitTimeID, lapSplit = lapSplit, level = levelIdentifier, track = trackIdentifier, triggerName = triggerName, checkpointCount = checkpointCount } )
		TriggerServerEvent("onLapSplit", data)
		local prettySplitTime = prettyTime(lapSplit)
	end
end

local function onLapStop(gameVehicleID)
	local serverVehicleID = MPVehicleGE.getServerVehicleID(gameVehicleID)
	if not lapActive then
		verifySplits = {}
	else
		local missedCheckpoints = checkpointCount - tableLength(verifySplits)
		if missedCheckpoints == 0 then
			stopTime = timer
			lapTime = stopTime - lapStart
			checkpointTimes.startStop = lapTime
			checkpointTimes.stopTimeStamp = os.time()
			verifySplits = {}
			lapActive = false
			local data = jsonEncode( { serverVehicleID = serverVehicleID, lapTime = lapTime, lapSplits = lapSplits, level = levelIdentifier, track = trackIdentifier, penalties = penaltyCount } )
			TriggerServerEvent("onLapStop", data)
			local prettyLapTime = prettyTime(lapTime)
			timer = 0
			penaltyCount = 0
		else
			verifySplits = {}
			guihooks.trigger('toastrMsg', {type="error", title = "Hotlap Restarted!", msg = "You must pass through all checkpoints to log a time!", config = {timeOut = 2500 }})
			lapActive = false
			timer = 0
			penaltyCount = 0
		end
	end
end

local function onLapOutOfBounds()
	if lapActive then
		penaltyCount = penaltyCount + 1
		guihooks.trigger('toastrMsg', {type="error", title = "Out Of Bounds!", msg = "Penalties: " .. penaltyCount, config = {timeOut = 5000 }})
		--lapActive = false
	end
end

local function onVehicleResetted(gameVehicleID)
	if MPVehicleGE.isOwn(gameVehicleID) then
		if lapActive then
			guihooks.trigger('toastrMsg', {type="error", title = "Time Forfeit!", msg = "You may continue but checkpoints are not active for this lap!", config = {timeOut = 2500 }})
			lapActive = false
		end
	end
end

local function onBeamNGTrigger(data)
	if data.triggerName == "startStop" and MPVehicleGE.isOwn(data.subjectID) == true then
		if data.event == "exit" then
			onLapStart()
		elseif data.event == "enter" then
			onLapStop(data.subjectID)
		end
	elseif string.find(data.triggerName,"outOfBounds") and data.event == "enter" and MPVehicleGE.isOwn(data.subjectID) == true then
		onLapOutOfBounds()
	elseif string.find(data.triggerName,"lapSplit") and data.event == "enter" and MPVehicleGE.isOwn(data.subjectID) == true then
		onLapSplit(data.triggerName, data.subjectID)
	end
end

local function onUpdate(dt)
    timer = timer + dt
    if worldReadyState == 2 then
		if not syncRequested then
			levelIdentifier = getCurrentLevelIdentifier()
			if levelIdentifier then
				theLeaderBoard.levels[levelIdentifier] = {}
				theLeaderBoard.levels[levelIdentifier].tracks = {}
				theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier] = {}
				theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier].overallBestTime = {}
				for k,v in pairs(vehiclesLookup) do
					theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][k] = {}
					theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][k].entries = {}
					theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][k].overallBestTime = {}
				end
			end
			TriggerServerEvent("requestHotLapsSync", "")
			syncRequested = true
		end
        if #checkPoints == 0 then
			if levelIdentifier then
				print(levelIdentifier)
				local tempCount = 0
				for k in pairs(checkPointsData.levels[levelIdentifier].tracks[trackIdentifier].checkPoints) do
					if string.find(k, "lapSplit") then
						tempCount = tempCount + 1
					end
				end
				for _, data in pairs(checkPointsData.levels[levelIdentifier].tracks[trackIdentifier].checkPoints) do
					local newCheckPoint = scenetree.findObject(data.name)
					if newCheckPoint == nil then
						log('I', "markerCreation", 'Creating marker ' .. tostring(data.name) )
						newCheckPoint = createCheckPoint(data)
					end
					table.insert(checkPoints, newCheckPoint)
				end
				checkpointCount = tempCount
				print(checkpointCount)
			end
        end
        if windowOpen[0] == true then
            drawHotLaps(dt)
        end
    end
end

local function onExtensionLoaded()
	AddEventHandler("rxPersonalBest", rxPersonalBest)
	AddEventHandler("rxCurentLap", rxCurentLap)
	AddEventHandler("rxGain", rxGain)
	AddEventHandler("rxLoss", rxLoss)
	AddEventHandler("rxNeutral", rxNeutral)
	AddEventHandler("rxLeaderBoard", rxLeaderBoard)
	AddEventHandler("rxLeaderBoardUpdate", rxLeaderBoardUpdate)
	AddEventHandler("rxNewEntry", rxNewEntry)
	AddEventHandler("rxPersonal", rxPersonal)
	gui_module.initialize(gui)
    gui.registerWindow("hotLaps", im.ImVec2(275, 440))
    gui.showWindow("hotLaps")
    gui.setupWindow("hotLaps")
    log('I', "hotLaps", "HotLaps Loaded!")
end

local function onExtensionUnloaded()
    log('I', "hotLaps", "HotLaps Unloaded!")
end

M.onInit = function() setExtensionUnloadMode(M, "manual") end

M.onUpdate = onUpdate

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded

M.onBeamNGTrigger = onBeamNGTrigger

M.onVehicleResetted = onVehicleResetted

return M
