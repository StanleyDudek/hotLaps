--hotLaps (CLIENT) by Dudekahedron, 2025

local levelIdentifier
local trackIdentifier = "long"

local prefabIdentifier = "/gameplay/missions/hirochi_raceway/timeTrial/005-longcourse/mainPrefab.prefab.json"

local originalMPUILayout = jsonReadFile("settings/ui_apps/layouts/default/multiplayer.uilayout.json")

local M = {}

local hotLaps_VERSION = "v0.0.3"

local gui_module = require("ge/extensions/editor/api/gui")
local gui = {setupEditorGuiTheme = nop}
local im = ui_imgui

local syncRequested = false
local prefabRequested = false

local penaltyTimer = 0
local penaltyTimeout = 3
local penaltySeconds = 3
local out

local trackData

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
    md_series = { model = "MD-Series", make = "Gavril" },
    midsize = { model = "Pessima '96-'00", make = "Ibishu" },
    midtruck = { model = "Stambecco", make = "Autobello" },
    miramar = { model = "Miramar", make = "Ibishu" },
    moonhawk = { model = "Moonhawk", make = "Bruckell" },
    nine = { model = "Nine", make = "Bruckell" },
    pessima = { model = "Pessima '88-'91", make = "Ibishu" },
    pickup = { model = "D-Series", make = "Gavril" },
    pigeon = { model = "Pigeon", make = "Ibishu" },
    racetruck = { model = "Dunekicker", make = "SP" },
    roamer = { model = "Roamer", make = "Gavril" },
    rockbouncer = { model = "Rockbasher", make = "SP" },
    sbr = { model = "SBR4", make = "Hirochi" },
    scintilla = { model = "Scintilla", make = "Civetta" },
    simple_traffic = { model = "Simple Traffic", make = "BeamNG" },
    sunburst2 = { model = "Sunburst", make = "Hirochi" },
    unicycle = { model = "Player Model", make = "BeamNG" },
    us_semi = { model = "T-Series", make = "Gavril"    },
    utv = { model = "Aurata", make = "Hirochi" },
    van = {    model = "H-Series",    make = "Gavril"    },
    vivace = { model = "FCV", make = "Cherrier"    },
    wendover = { model = "Wendover", make = "Soliad" },
    wigeon = { model = "Wigeon", make = "Ibishu" }
}

local sortedVehicles = {}

local chronLeaders = {}

local checkpointCount = 0

local penaltyCount = 0

local lapsActive = false
local lapsContinue = false
local splitTime
local stopTime
local lapStart
local lapSplit
local lapTime
local lapTimer = 0
local lapSplits = {}
local checkpointTimes = {}
local verifySplits = {}

local theLeaderBoard = {}
theLeaderBoard.levels = {}

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
                        debug = "0",
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
                        debug = "0",
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
                        debug = "0",
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
                        debug = "0",
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
                        debug = "0",
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
                            debug = "0",
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
                        debug = "0",
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
                        debug = "0",
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
                        debug = "0",
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
                        },
                        outOfBounds1 = {
                            rot = {
                                [1] = -0.704,
                                [2] = -0.709,
                                [3] = 0.001,
                                [4] = 0.709,
                                [5] = -0.704,
                                [6] = -0.001,
                                [7] = 0.001,
                                [8] = 0.000,
                                [9] = 0.999,
                            },
                            debug = "0",
                            name = "outOfBounds1",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -353.217,
                                z = 27.391,
                                x = 100.498,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds2 = {
                            rot = {
                                [1] = 0.587,
                                [2] = 0.808,
                                [3] = 0,
                                [4] = -0.808,
                                [5] = 0.587,
                                [6] = 0,
                                [7] = 0,
                                [8] = 0,
                                [9] = 1,
                            },
                            debug = "0",
                            name = "outOfBounds2",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -396.203,
                                z = 29.795,
                                x = 134.004,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds3 = {
                            rot = {
                                [1] = -0.075,
                                [2] = -0.997,
                                [3] = 0.000,
                                [4] = 0.997,
                                [5] = -0.075,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds3",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = 369.824,
                                z = 28.441,
                                x = -252.705,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds4 = {
                            rot = {
                                [1] = -0.258,
                                [2] = -0.966,
                                [3] = 0.001,
                                [4] = 0.966,
                                [5] = -0.258,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds4",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = 391.684,
                                z = 29.630,
                                x = -289.711,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds5 = {
                            rot = {
                                [1] = 0.878,
                                [2] = -0.479,
                                [3] = -0.002,
                                [4] = 0.479,
                                [5] = 0.878,
                                [6] = -0.001,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds5",
                            scale = {
                                y = 15.408,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = 415.068,
                                z = 30.402,
                                x = -346.462,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds6 = {
                            rot = {
                                [1] = -0.413,
                                [2] = -0.911,
                                [3] = 0.001,
                                [4] = 0.911,
                                [5] = -0.413,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds6",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = 448.669,
                                z = 31.903,
                                x = -379.162,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds7 = {
                            rot = {
                                [1] = 0.897,
                                [2] = -0.443,
                                [3] = -0.002,
                                [4] = 0.443,
                                [5] = 0.897,
                                [6] = -0.001,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds7",
                            scale = {
                                y = 47.693,
                                z = 10,
                                x = 15.439,
                            },
                            pos = {
                                y = -119.664,
                                z = 33.700,
                                x = 411.563,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds8 = {
                            rot = {
                                [1] = 0.503,
                                [2] = -0.864,
                                [3] = -0.001,
                                [4] = 0.864,
                                [5] = 0.503,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds8",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -462.263,
                                z = 38.063,
                                x = 291.755,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds9 = {
                            rot = {
                                [1] = 0.762,
                                [2] = -0.648,
                                [3] = -0.001,
                                [4] = 0.648,
                                [5] = 0.762,
                                [6] = -0.001,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds9",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -450.353,
                                z = 38.649,
                                x = 305.431,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds10 = {
                            rot = {
                                [1] = 0.184,
                                [2] = -0.983,
                                [3] = 0.000,
                                [4] = 0.983,
                                [5] = 0.184,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds10",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -467.691,
                                z = 36.872,
                                x = 277.045,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds11 = {
                            rot = {
                                [1] = -0.020,
                                [2] = -1.000,
                                [3] = 0.000,
                                [4] = 1.000,
                                [5] = -0.020,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds11",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -468.697,
                                z = 35.729,
                                x = 262.380,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds12 = {
                            rot = {
                                [1] = 0.894,
                                [2] = -0.449,
                                [3] = -0.002,
                                [4] = 0.449,
                                [5] = 0.894,
                                [6] = -0.001,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds12",
                            scale = {
                                y = 17.981,
                                z = 20,
                                x = 78.399,
                            },
                            pos = {
                                y = 370.405,
                                z = 27.479,
                                x = -182.664,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds13 = {
                            rot = {
                                [1] = 0.405,
                                [2] = -0.914,
                                [3] = 0.000,
                                [4] = 0.914,
                                [5] = 0.405,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.001,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds13",
                            scale = {
                                y = 4.496,
                                z = 10.739,
                                x = 81.265,
                            },
                            pos = {
                                y = -139.141,
                                z = 25.664,
                                x = 14.849,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds14 = {
                            rot = {
                                [1] = 0.302,
                                [2] = -0.953,
                                [3] = 0.000,
                                [4] = 0.953,
                                [5] = 0.302,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.001,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds14",
                            scale = {
                                y = 4.496,
                                z = 10.739,
                                x = 42.264,
                            },
                            pos = {
                                y = -194.899,
                                z = 25.663,
                                x = 37.130,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds15 = {
                            rot = {
                                [1] = 0.476,
                                [2] = -0.880,
                                [3] = -0.001,
                                [4] = 0.880,
                                [5] = 0.476,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds15",
                            scale = {
                                y = 3.504,
                                z = 10.739,
                                x = 16.091,
                            },
                            pos = {
                                y = 391.211,
                                z = 25.029,
                                x = -485.263,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds16 = {
                            rot = {
                                [1] = 0.391,
                                [2] = -0.920,
                                [3] = -0.001,
                                [4] = 0.920,
                                [5] = 0.391,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds16",
                            scale = {
                                y = 2.918,
                                z = 10.739,
                                x = 16.091,
                            },
                            pos = {
                                y = 404.722,
                                z = 25.039,
                                x = -492.084,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds17 = {
                            rot = {
                                [1] = 0.559,
                                [2] = 0.829,
                                [3] = -0.001,
                                [4] = -0.829,
                                [5] = 0.559,
                                [6] = 0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds17",
                            scale = {
                                y = 22.646,
                                z = 10.739,
                                x = 34.586,
                            },
                            pos = {
                                y = 185.163,
                                z = 24.306,
                                x = -87.546,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds18 = {
                            rot = {
                                [1] = 0.993,
                                [2] = 0.120,
                                [3] = 0.000,
                                [4] = -0.120,
                                [5] = 0.993,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds18",
                            scale = {
                                y = 3.622,
                                z = 10,
                                x = 15.464,
                            },
                            pos = {
                                y = 249.663,
                                z = 29.175,
                                x = 55.806,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds19 = {
                            rot = {
                                [1] = 0.876,
                                [2] = -0.483,
                                [3] = 0.000,
                                [4] = 0.483,
                                [5] = 0.876,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds19",
                            scale = {
                                y = 3.622,
                                z = 10,
                                x = 29.117,
                            },
                            pos = {
                                y = 234.648,
                                z = 30.276,
                                x = 116.245,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds20 = {
                            rot = {
                                [1] = 0.924,
                                [2] = -0.383,
                                [3] = 0.000,
                                [4] = 0.383,
                                [5] = 0.924,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds20",
                            scale = {
                                y = 4.614,
                                z = 10,
                                x = 37.097,
                            },
                            pos = {
                                y = 257.190,
                                z = 30.555,
                                x = 103.881,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds21 = {
                            rot = {
                                [1] = 0.834,
                                [2] = -0.552,
                                [3] = 0.000,
                                [4] = 0.552,
                                [5] = 0.834,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds21",
                            scale = {
                                y = 4.614,
                                z = 10,
                                x = 37.097,
                            },
                            pos = {
                                y = 240.338,
                                z = 31.018,
                                x = 136.071,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds22 = {
                            rot = {
                                [1] = -0.311,
                                [2] = -0.950,
                                [3] = 0.001,
                                [4] = 0.950,
                                [5] = -0.311,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds22",
                            scale = {
                                y = 9.054,
                                z = 20,
                                x = 60.400,
                            },
                            pos = {
                                y = 247.298,
                                z = 27.476,
                                x = -169.408,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds23 = {
                            rot = {
                                [1] = 0.610,
                                [2] = 0.792,
                                [3] = -0.001,
                                [4] = -0.792,
                                [5] = 0.610,
                                [6] = 0.001,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds23",
                            scale = {
                                y = 5.921,
                                z = 10.739,
                                x = 19.319,
                            },
                            pos = {
                                y = 154.864,
                                z = 24.413,
                                x = -139.674,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds24 = {
                            rot = {
                                [1] = -0.141,
                                [2] = 0.990,
                                [3] = 0.000,
                                [4] = -0.990,
                                [5] = -0.141,
                                [6] = 0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds24",
                            scale = {
                                y = 5.921,
                                z = 10.739,
                                x = 8.886,
                            },
                            pos = {
                                y = 209.150,
                                z = 31.902,
                                x = -154.395,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds25 = {
                            rot = {
                                [1] = -0.222,
                                [2] = -0.975,
                                [3] = 0.001,
                                [4] = 0.975,
                                [5] = -0.222,
                                [6] = -0.002,
                                [7] = 0.002,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds25",
                            scale = {
                                y = 10,
                                z = 10,
                                x = 10,
                            },
                            pos = {
                                y = -467.018,
                                z = 35.755,
                                x = 248.682,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds26 = {
                            rot = {
                                [1] = 0.989,
                                [2] = 0.147,
                                [3] = 0.000,
                                [4] = -0.147,
                                [5] = 0.989,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds26",
                            scale = {
                                y = 39.359,
                                z = 25,
                                x = 25,
                            },
                            pos = {
                                y = 207.654,
                                z = 24.816,
                                x = -53.438,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds27 = {
                            rot = {
                                [1] = 0.989,
                                [2] = 0.147,
                                [3] = 0.000,
                                [4] = -0.147,
                                [5] = 0.989,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds27",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = 225.813,
                                z = 24.816,
                                x = -56.061,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds28 = {
                            rot = {
                                [1] = -0.994,
                                [2] = -0.111,
                                [3] = 0.000,
                                [4] = 0.111,
                                [5] = -0.994,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds28",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = 240.444,
                                z = 24.816,
                                x = -11.549,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds29 = {
                            rot = {
                                [1] = -0.994,
                                [2] = -0.111,
                                [3] = 0.000,
                                [4] = 0.111,
                                [5] = -0.994,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds29",
                            scale = {
                                y = 39.359,
                                z = 25,
                                x = 25,
                            },
                            pos = {
                                y = 257.778,
                                z = 24.816,
                                x = -13.790,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds30 = {
                            rot = {
                                [1] = -0.933,
                                [2] = -0.360,
                                [3] = 0.000,
                                [4] = 0.360,
                                [5] = -0.933,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds30",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = -36.192,
                                z = 28.007,
                                x = 412.978,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds31 = {
                            rot = {
                                [1] = -0.996,
                                [2] = 0.093,
                                [3] = 0.000,
                                [4] = -0.093,
                                [5] = -0.996,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds31",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = -48.792,
                                z = 28.007,
                                x = 414.774,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds32 = {
                            rot = {
                                [1] = -0.965,
                                [2] = 0.263,
                                [3] = 0.000,
                                [4] = -0.263,
                                [5] = -0.965,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds32",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = -59.052,
                                z = 28.007,
                                x = 412.695,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds33 = {
                            rot = {
                                [1] = -0.336,
                                [2] = 0.942,
                                [3] = 0.000,
                                [4] = -0.942,
                                [5] = -0.336,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds33",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = -171.150,
                                z = 41.820,
                                x = 344.385,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds34 = {
                            rot = {
                                [1] = -0.336,
                                [2] = 0.942,
                                [3] = 0.000,
                                [4] = -0.942,
                                [5] = -0.336,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds34",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = -188.888,
                                z = 46.760,
                                x = 288.346,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds35 = {
                            rot = {
                                [1] = 0.263,
                                [2] = -0.965,
                                [3] = 0.000,
                                [4] = 0.965,
                                [5] = 0.263,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds35",
                            scale = {
                                y = 50.926,
                                z = 25,
                                x = 25,
                            },
                            pos = {
                                y = 307.883,
                                z = 28.771,
                                x = -177.158,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds36 = {
                            rot = {
                                [1] = 0.263,
                                [2] = -0.965,
                                [3] = 0.000,
                                [4] = 0.965,
                                [5] = 0.263,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds36",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = 314.489,
                                z = 28.771,
                                x = -153.884,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
                            type = "Box",
                        },
                        outOfBounds37 = {
                            rot = {
                                [1] = -0.925,
                                [2] = 0.380,
                                [3] = 0.000,
                                [4] = -0.380,
                                [5] = -0.925,
                                [6] = 0.000,
                                [7] = 0.000,
                                [8] = 0.000,
                                [9] = 1.000,
                            },
                            debug = "0",
                            name = "outOfBounds37",
                            scale = {
                                y = 7.953,
                                z = 7.953,
                                x = 7.953,
                            },
                            pos = {
                                y = -203.931,
                                z = 46.760,
                                x = 273.555,
                            },
                            color = {
                                a = 45,
                                b = 255,
                                g = 0,
                                r = 255,
                            },
                            test = "Race corners",
                            mode = "Center",
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
                            mode = "Center",
                            type = "Box",
                        }
                    }
                }
            }
        }
    }
}

local markers = {}
local markersData = {
    {
        name = "startStopMarker",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            -402.754089,244.808746,24.9899998
        },
        color = {
            1,0,0,0.5
        },
        rot = {
            0.846121609,0.53298986,0,-0.53298986,0.846121609,0,0,0,1
        },
        scale = {
            6,1,6
        }
    },
    {
        name = "lapSplitMarker1",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            -158.96373,123.630775,25.0849991
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.430999994,-0.90200001,0,0.90200001,0.430999994,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker2",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            60.8591042,258.479156,28.7709999
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.027320087,-0.999626696,0,0.999626696,0.027320087,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker3",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            388.275726,-136.891632,35.3390007
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.892663538,-0.450723618,0,0.450723618,0.892663538,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker4",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            303.266998,-468.355011,39.2659988
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.580790758,-0.814052999,0,0.814052999,0.580790758,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker5",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            26.7258854,-144.981171,25.4860001
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.947673798,0.319240302,0,-0.319240302,0.947673798,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker6",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            -155.495255,257.525665,31.0869999
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.945201695,-0.326486975,0,0.326486975,0.945201695,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker7",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            -354.82016,432.074066,30.6819992
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.189701498,0.981841743,0,-0.981841743,0.189701498,0,0,0,1
        },
        scale = {
            5,1,5
        }
    },
    {
        name = "lapSplitMarker8",
        shape = "shapes/interface/ringMarker/checkpoint_ring_finish",
        pos = {
            -498.186768,397.248138,25.1340008
        },
        color = {
            1,1,0,0.5
        },
        rot = {
            0.898856461,0.438243121,0,-0.438243121,0.898856461,0,0,0,1
        },
        scale = {
            5.5,1,5.5
        }
    }
}

local function tableLength(table)
    local counter = 0
    for _ in pairs(table) do
        counter = counter + 1
    end
    return counter
end

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

local function readPrefab(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local content = f:read("*all")
    f:close()
    return content
end

local function writePrefab(path, content)
    local f = io.open(path, "w+")
    if not f then
        return
    end
    f:write(content)
    f:close()
end

local function cleanPrefab(content)
    local result = ""
    local inSep = 1
    for _ = 1, #content do
        local outSep = content:find("}\n", inSep)
        if not outSep then
            break
        end
        local block = content:sub(inSep, outSep)
        inSep = content:find("{", outSep)
        if not block:find("BeamNGVehicle", 1) then
            result = result .. block .. "\n"
        end
        if not inSep then
            break
        end
    end
    return result
end

local function processPrefab(path, name)
    local content = readPrefab(path)
    if not content then
        return
    end
    local cleanedPrefab = cleanPrefab(content)
    if cleanedPrefab then
        local ext = ".prefab.json"
        local tempPath = "settings/BeamMP/tempPrefab" .. name .. ext
        writePrefab(tempPath, cleanedPrefab)
        spawnPrefab(name, tempPath, "0 0 0", "0 0 1", "1 1 1")
    end
end

local function rxPrefabSync(data)
    processPrefab(prefabIdentifier, levelIdentifier .. "-" .. trackIdentifier)
    be:reloadCollision()
    be:setDynamicCollisionEnabled(false)
end

local function rxLeaderBoard(data)
    local recievedData = jsonDecode(data)
    local level = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier]
    if recievedData.overallBestTime then
        level.overallBestTime = recievedData.overallBestTime
        return
    end
    if not recievedData.data then
        return
    end
    level[recievedData.model] = {
        entries = recievedData.data.entries,
        overallBestTime = recievedData.data.overallBestTime
    }
    if not recievedData.data.entries then
        return
    end
    for _, j in pairs(recievedData.data.entries) do
        local duplicate
        for _, v in pairs(chronLeaders) do
            if v.owner == j.owner and v.model == j.model and v.lapTime == j.lapTime then
                duplicate = true
                break
            end
        end
        if not duplicate then
            table.insert(chronLeaders, j)
        end
    end
    table.sort(chronLeaders, function(a, b)
        if a.lapTime == b.lapTime then
            return a.lapTime > b.lapTime
        else
            return a.lapTime < b.lapTime
        end
    end)
end

local function rxCourseBest(time)
    guihooks.trigger('toastrMsg', {type="success", title = "Course Best!!!", msg = "Your Lap Time was: " .. prettyTime(time) .. "<br>Penalties: " .. penaltyCount, config = {timeOut = 3000 }})
    guihooks.trigger('ScenarioFlashMessage', {{"Course Best: " .. prettyTime(time) .. "<br>Penalties: " .. penaltyCount, 3, nil, false}})
    Engine.Audio.playOnce('AudioGui', 'event:>UI>Career>Drift_Tier', {volume = 6, unique = true})
    penaltyCount = 0
end

local function rxPersonalBest(time)
    guihooks.trigger('toastrMsg', {type="warning", title = "Personal Best!!", msg = "Your Lap Time was: " .. prettyTime(time) .. "<br>Penalties: " .. penaltyCount, config = {timeOut = 3000 }})
    guihooks.trigger('ScenarioFlashMessage', {{"Personal Best: " .. prettyTime(time) .. "<br>Penalties: " .. penaltyCount, 3, nil, false}})
    Engine.Audio.playOnce('AudioGui', 'event:>UI>Career>Drift_Tier', {volume = 3, unique = true})
    penaltyCount = 0
end

local function rxCurentLap(time)
    guihooks.trigger('toastrMsg', {type="info", title = "Try again!", msg = "Your Lap Time was: " .. prettyTime(time) .. "<br>Penalties: " .. penaltyCount, config = {timeOut = 3000 }})
    guihooks.trigger('ScenarioFlashMessage', {{prettyTime(time) .. "<br>Penalties: " .. penaltyCount, 3, nil, false}})
    Engine.Audio.playOnce('AudioGui', 'event:>UI>Career>Drift_Tier', {volume = 1, unique = true})
    penaltyCount = 0
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
    guihooks.trigger('toastrMsg', {type="success", title = "-" .. prettyDifference .. " || " .. time, msg = splitData.triggerName .. " (" .. splitData.splitTimeID .. "/" .. splitData.checkpointCount .. ")" .. "<br>Penalties: " .. penaltyCount, config = {timeOut = 3000 } })
    guihooks.trigger('ScenarioFlashMessage', {{"-" .. prettyDifference .. " || " .. time .. "<br>Penalties: " .. penaltyCount, 3, nil, false}})
    Engine.Audio.playOnce('AudioGui', "event:UI_CountdownGo", {volume = 2, unique = true})
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
    guihooks.trigger('toastrMsg', {type="error", title = "+" .. prettyDifference .. " || " .. time, msg = splitData.triggerName .. " (" .. splitData.splitTimeID .. "/" .. splitData.checkpointCount .. ")" .. "<br>Penalties: " .. penaltyCount, config = {timeOut = 3000 } })
    guihooks.trigger('ScenarioFlashMessage', {{"+" .. prettyDifference .. " || " .. time .. "<br>Penalties: " .. penaltyCount, 3, nil, false}})
    Engine.Audio.playOnce('AudioGui', "event:UI_Countdown1", {volume = 2, unique = true})
end

local function rxNeutral(data)
    local splitData = jsonDecode(data)
    local time
    if splitData.time > 60 then
        time = prettyTime(splitData.time)
    else
        time = prettySeconds(splitData.time)
    end
    guihooks.trigger('toastrMsg', {type="warning", title = time , msg = splitData.triggerName .. " (" .. splitData.splitTimeID .. "/" .. splitData.checkpointCount .. ")" .. "<br>Penalties: " .. penaltyCount, config = {timeOut = 3000 } })
    guihooks.trigger('ScenarioFlashMessage', {{time .. "<br>Penalties: " .. penaltyCount, 3, nil, false}})
    Engine.Audio.playOnce('AudioGui', 'event:UI_Checkpoint', {volume = 2, unique = true})
end

local function pushStyle()
    local colors = {
        {im.Col_Border,            im.ImVec4(1.00, 0.50, 0.25, 0.50)},
        {im.Col_ResizeGrip,        im.ImVec4(0.75, 0.30, 0.10, 0.50)},
        {im.Col_ResizeGripHovered, im.ImVec4(0.66, 0.26, 0.05, 0.50)},
        {im.Col_ResizeGripActive,  im.ImVec4(0.95, 0.38, 0.00, 0.50)},
        {im.Col_TitleBg,           im.ImVec4(0.33, 0.13, 0.00, 0.50)},
        {im.Col_TitleBgActive,     im.ImVec4(1.00, 0.35, 0.05, 0.88)},
        {im.Col_TitleBgCollapsed,  im.ImVec4(0.75, 0.30, 0.10, 0.50)},
        {im.Col_Tab,               im.ImVec4(1.00, 0.45, 0.15, 0.33)},
        {im.Col_TabHovered,        im.ImVec4(1.00, 0.55, 0.20, 0.50)},
        {im.Col_TabActive,         im.ImVec4(1.00, 0.35, 0.05, 0.88)},
        {im.Col_FrameBg,           im.ImVec4(0.33, 0.13, 0.00, 0.50)},
        {im.Col_FrameBgHovered,    im.ImVec4(0.44, 0.18, 0.00, 0.50)},
        {im.Col_FrameBgActive,     im.ImVec4(0.22, 0.09, 0.00, 0.50)},
        {im.Col_Header,            im.ImVec4(0.50, 0.25, 0.10, 0.50)},
        {im.Col_HeaderHovered,     im.ImVec4(0.66, 0.33, 0.13, 0.50)},
        {im.Col_HeaderActive,      im.ImVec4(0.77, 0.40, 0.15, 0.50)},
        {im.Col_Separator,         im.ImVec4(0.95, 0.60, 0.20, 0.75)},
        {im.Col_SeparatorHovered,  im.ImVec4(0.95, 0.70, 0.25, 0.75)},
        {im.Col_SeparatorActive,   im.ImVec4(0.95, 0.40, 0.10, 0.50)},
        {im.Col_Button,            im.ImVec4(0.75, 0.30, 0.10, 0.33)},
        {im.Col_ButtonHovered,     im.ImVec4(0.69, 0.26, 0.05, 0.50)},
        {im.Col_ButtonActive,      im.ImVec4(0.55, 0.20, 0.05, 0.99)},
    }
    for _, color in ipairs(colors) do
        im.PushStyleColor2(color[1], color[2])
    end
    im.SetNextWindowBgAlpha(0.666)
end

local function drawHotLaps()
    gui.setupWindow("hotLaps")
    pushStyle()
    im.Begin("hotLaps " .. hotLaps_VERSION .. " | " .. levelIdentifier .. " | " .. trackIdentifier)
        im.BeginChild1("Info Area", im.ImVec2(0, 90), true)
            if trackData.overallBestTime then
                if trackData.overallBestTime.lapTime then
                    im.TextColored(im.ImVec4(0.9, 0.9, 0, 1), "Best Lap:")
                    im.SameLine()
                    im.TextColored(im.ImVec4(0, 0.9, 0, 1), prettyTime(trackData.overallBestTime.lapTime))
                    if trackData.overallBestTime.penalties > 0 then
                        im.SameLine()
                        im.Text("(")
                        im.SameLine()
                        im.TextColored(im.ImVec4(0.9, 0, 0, 1), trackData.overallBestTime.penalties)
                        im.SameLine()
                        if trackData.overallBestTime.penalties == 1 then
                            im.Text("penalty )")
                        else
                            im.Text("penalties )")
                        end
                    end
                    im.Separator()
                    im.Indent()
                    im.TextColored(im.ImVec4(0.9, 0, 0.9, 1), "Vehicle:")
                    im.SameLine()
                    im.Text(vehiclesLookup[trackData.overallBestTime.model].make .. " " .. vehiclesLookup[trackData.overallBestTime.model].model .. " (" .. trackData.overallBestTime.config .. ")")
                    im.TextColored(im.ImVec4(0, 0.9, 0.9, 1), "Driver:")
                    im.SameLine()
                    im.Text(trackData.overallBestTime.owner)
                    im.Unindent()
                else
                    im.TextColored(im.ImVec4(0.9, 0.1, 0.1, 1), "No laptimes set, be the first!")
                end
            end
        im.EndChild()
        if im.BeginTabBar("TabBar") then
            if im.BeginTabItem("Track") then
                im.BeginChild1("Track Tab", im.ImVec2(0, 0), true)
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
                    for _, make in ipairs(sortedMakes) do
                        if im.TreeNode1(make) then
                            local models = makes[make]
                            table.sort(models)
                            for _, model in ipairs(models) do
                                local genericName
                                for name, vehicle in pairs(vehiclesLookup) do
                                    if vehicle.model == model then
                                        genericName =  name
                                        break
                                    end
                                end
                                local bestTime = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].overallBestTime
                                if bestTime.lapTime then
                                    if im.TreeNode1(model .. ": " .. prettyTime(bestTime.lapTime)) then
                                        if bestTime.penalties > 0 then
                                            im.SameLine()
                                            im.Text("(")
                                            im.SameLine()
                                            im.Text(bestTime.penalties)
                                            im.SameLine()
                                            if bestTime.penalties == 1 then
                                                im.Text("penalty )")
                                            else
                                                im.Text("penalties )")
                                            end
                                        end
                                        for _, vehicle in pairs(vehiclesLookup) do
                                            if vehicle.model == model then
                                                if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName] then
                                                    if bestTime then
                                                        local pWord = "penalties"
                                                        if bestTime.penalties == 1 then
                                                            pWord = "penalty"
                                                        end
                                                        if im.TreeNode1(bestTime.owner .. ": " .. prettyTime(bestTime.lapTime) .. " ( " .. bestTime.penalties .. " " .. pWord .. " ) - " .. bestTime.config) then
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
                                                                local pWord = "penalties"
                                                                if bestTime.penalties == 1 then
                                                                    pWord = "penalty"
                                                                end
                                                                if im.TreeNode1(entry.owner .. ": " .. prettyTime(entry.lapTime) .. " ( " .. entry.penalties .. " " .. pWord .. " ) - " .. entry.config) then
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
                                    else
                                        if bestTime.penalties > 0 then
                                            im.SameLine()
                                            im.Text("(")
                                            im.SameLine()
                                            im.Text(bestTime.penalties)
                                            im.SameLine()
                                            if bestTime.penalties == 1 then
                                                im.Text("penalty )")
                                            else
                                                im.Text("penalties )")
                                            end
                                        end
                                    end
                                else
                                    if im.TreeNode1(model) then
                                        im.TextColored(im.ImVec4(0.9, 0.1, 0.1, 1), "No laptimes set, be the first!")
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
                im.BeginChild1("Personal Tab", im.ImVec2(0, 0), true)
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
                    for _, make in ipairs(sortedMakes) do
                        if im.TreeNode1(make) then
                            local models = makes[make]
                            table.sort(models)
                            for _, model in ipairs(models) do
                                local genericName
                                for name, vehicle in pairs(vehiclesLookup) do
                                    if vehicle.model == model then
                                        genericName = name
                                        break
                                    end
                                end
                                local playerInfo
                                if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].entries then
                                    for key, entry in pairs(theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].entries) do
                                        if key ~= "overallBestTime" then
                                            if entry.owner == MPConfig.getNickname() then
                                                playerInfo = entry
                                            end
                                        end
                                    end
                                end
                                if playerInfo then
                                    local pWord = "penalties"
                                    if playerInfo.penalties == 1 then
                                        pWord = "penalty"
                                    end
                                    if im.TreeNode1(model .. ": " .. prettyTime(playerInfo.lapTime) .. " ( " .. playerInfo.penalties .. " " .. pWord .. " ) - " .. playerInfo.config) then
                                        for _, vehicle in pairs(vehiclesLookup) do
                                            if vehicle.model == model then
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
                                        im.TextColored(im.ImVec4(0.9, 0.1, 0.1, 1), "No laptimes set for this vehicle!")
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
                im.BeginChild1("Vehicle Tab", im.ImVec2(0, 0), true)
                    if be:getPlayerVehicle(0) then
                        local bestTime = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][be:getPlayerVehicle(0).JBeam].overallBestTime
                        if bestTime.lapTime then
                            local pWord = "penalties"
                            if bestTime.penalties == 1 then
                                pWord = "penalty"
                            end
                            im.Text(vehiclesLookup[be:getPlayerVehicle(0).JBeam].model .. ": " .. prettyTime(bestTime.lapTime) .. " ( " .. bestTime.penalties .. " " .. pWord .. " ) - " .. bestTime.config)
                            for name in pairs(vehiclesLookup) do
                                if name == be:getPlayerVehicle(0).JBeam then
                                    if theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][be:getPlayerVehicle(0).JBeam] then
                                        if bestTime then
                                            if im.TreeNode1(bestTime.owner .. ": " .. prettyTime(bestTime.lapTime) .. " ( " .. bestTime.penalties .. " " .. pWord .. " ) - " .. bestTime.config) then
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
                                                    pWord = "penalties"
                                                    if bestTime.penalties == 1 then
                                                        pWord = "penalty"
                                                    end
                                                    if im.TreeNode1(entry.owner .. ": " .. prettyTime(entry.lapTime) .. " ( " .. entry.penalties .. " " .. pWord .. " ) - " .. entry.config) then
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
                            im.TextColored(im.ImVec4(0.9, 0.1, 0.1, 1), "No laptimes set, be the first!")
                        end
                    else
                        im.Text("No vehicle spawned!")
                    end
                im.EndChild()
                im.EndTabItem()
            end
            if im.BeginTabItem("Chronological") then
                im.BeginChild1("Chronological Tab", im.ImVec2(0, 0), true)
                for i = 1, tableLength(chronLeaders) do
                    local position
                    if chronLeaders[i].owner then
                        if i < 10 then
                            position = "00" .. i
                        elseif i < 100 then
                            position = "0" .. i
                        end
                        if im.TreeNode1(position .. " | " .. prettyTime(chronLeaders[i].lapTime) .. " ( " .. chronLeaders[i].penalties .. "p ) | " .. chronLeaders[i].owner) then
                            im.Indent()
                            im.Indent()
                            im.Text(chronLeaders[i].name .. " - " .. chronLeaders[i].config)
                            im.Unindent()
                            im.Unindent()
                            im.TreePop()
                        end
                    end
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
    checkPoint:setField('debug', 0, data.debug)
    if data.rot then
        checkPoint:setField('rotationMatrix', 0, data.rot[1] .. " " .. data.rot[2] .. " " .. data.rot[3] .. " " .. data.rot[4] .. " " .. data.rot[5] .. " " .. data.rot[6] .. " " .. data.rot[7] .. " " .. data.rot[8] .. " " .. data.rot[9])
    end
    checkPoint:registerObject(data.name)
    checkPoint:setPosition(vec3(data.pos.x, data.pos.y, data.pos.z))
    checkPoint:setScale(vec3(data.scale.x, data.scale.y, data.scale.z))
    checkPoint.canSave = false
    return checkPoint
end

local function createMarker(data)
    local marker =  createObject('TSStatic')
    marker:setField('shapeName', 0, "art/" .. data.shape .. ".dae")
    marker.useInstanceRenderData = true
    marker:setField('instanceColor', 0, data.color[1] .. " " .. data.color[2] .. " " .. data.color[3] .. " " .. data.color[4])
    marker:setField('collisionType', 0, "Collision Mesh")
    marker:setField('decalType', 0, "Collision Mesh")
    marker:setField('playAmbient', 0, "1")
    marker:setField('allowPlayerStep', 0, "1")
    marker:setField('canSave', 0, "0")
    marker:setField('canSaveDynamicFields', 0, "1")
    marker:setField('renderNormals', 0, "0")
    marker:setField('meshCulling', 0, "0")
    marker:setField('originSort', 0, "0")
    marker:setField('forceDetail', 0, "-1")
    if data.rot then
        marker:setField('rotationMatrix', 0, data.rot[1] .. " " .. data.rot[2] .. " " .. data.rot[3] .. " " .. data.rot[4] .. " " .. data.rot[5] .. " " .. data.rot[6] .. " " .. data.rot[7] .. " " .. data.rot[8] .. " " .. data.rot[9])
    end
    marker:registerObject(data.name)
    marker:setPosition(vec3(data.pos[1],data.pos[2],data.pos[3]))
    marker:setScale(vec3(data.scale[1], data.scale[2], data.scale[3]))
    marker.canSave = false
    return marker
end

local function onLapStart(genericName)
    lapTimer = 0
    lapStart = lapTimer
    lapSplits = {}
    checkpointTimes.startStop = lapStart
    checkpointTimes.startTimeStamp = os.time()
    if lapsContinue and not lapsActive then
        lapsActive = true
    elseif not lapsActive then
        lapsActive = true
        lapsContinue = true
        local overallBestTime = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][genericName].overallBestTime
        if overallBestTime then
            if overallBestTime.lapTime then
                guihooks.trigger('toastrMsg', {type = "info", title = "Hotlap Started!", msg = "Fastest " .. overallBestTime.name .. ": " .. prettyTime(overallBestTime.lapTime) .. "<br>Penalties: " .. overallBestTime.penalties  .. "<br>" .. overallBestTime.owner, config = {timeOut = 2500 }})
                guihooks.trigger('ScenarioFlashMessage', {{"Fastest " .. overallBestTime.name .. ": " .. prettyTime(overallBestTime.lapTime) .. "<br>Penalties: " .. overallBestTime.penalties  .. "<br>" .. overallBestTime.owner, 2.5, nil, false}})
                Engine.Audio.playOnce('AudioGui', "event:>UI>Career>Drift_PointsReceived", {volume = 2, unique = true})
            else
                guihooks.trigger('toastrMsg', {type = "info", title = "Hotlap Started!", msg = "No laptimes for this model!<br>Be the first!", config = {timeOut = 2500 }})
                guihooks.trigger('ScenarioFlashMessage', {{"No laptimes for this model!<br>Be the first!", 2.5, nil, false}})
                Engine.Audio.playOnce('AudioGui', "event:>UI>Career>Drift_PointsReceived", {volume = 2, unique = true})
            end
        end
    end
    local data = jsonEncode( { ["startStop"] = checkpointTimes.startStop, ["startTimeStamp"] = checkpointTimes.startTimeStamp } )
    TriggerServerEvent("onLapStart", data)
end

local function onLapSplit(triggerName, gameVehicleID)
    local serverVehicleID = MPVehicleGE.getServerVehicleID(gameVehicleID)
    if lapsActive then
        local splitTimeID = tonumber(triggerName:sub(9))
        triggerName = "Checkpoint " .. string.char(splitTimeID+64)
        verifySplits[triggerName] = 1
        splitTime = lapTimer
        lapSplit = splitTime - lapStart
        if splitTimeID then
            lapSplits[splitTimeID] = lapSplit
        end
        local data = jsonEncode( { serverVehicleID = serverVehicleID, splitTimeID = splitTimeID, lapSplit = lapSplit, level = levelIdentifier, track = trackIdentifier, triggerName = triggerName, checkpointCount = checkpointCount } )
        TriggerServerEvent("onLapSplit", data)
    end
end

local function onLapStop(gameVehicleID)
    local serverVehicleID = MPVehicleGE.getServerVehicleID(gameVehicleID)
    if not lapsActive then
        verifySplits = {}
    else
        local missedCheckpoints = checkpointCount - tableLength(verifySplits)
        if missedCheckpoints == 0 then
            stopTime = lapTimer
            lapTime = stopTime - lapStart + (penaltyCount * penaltySeconds)
            checkpointTimes.startStop = lapTime
            checkpointTimes.stopTimeStamp = os.time()
            verifySplits = {}
            local data = jsonEncode( { serverVehicleID = serverVehicleID, lapTime = lapTime, lapSplits = lapSplits, level = levelIdentifier, track = trackIdentifier, penalties = penaltyCount } )
            TriggerServerEvent("onLapStop", data)
            lapsActive = false
        else
            verifySplits = {}
            guihooks.trigger('toastrMsg', {type = "error", title = "Hotlap Restarted!", msg = "Pass through all checkpoints to log a time!", config = {timeOut = 2500 }})
            guihooks.trigger('ScenarioFlashMessage', {{"Hotlap Restarted!<br>Pass through all checkpoints to log a time!", 2.5, nil, false}})
            Engine.Audio.playOnce('AudioGui', 'event:>UI>Career>Drift_Canceled', {volume = 2, unique = true})
            lapsActive = false
        end
    end
end

local function onLapOutOfBounds(outbound)
    if lapsActive then
        if outbound then
            if not out then
                out = true
                penaltyCount = penaltyCount + 1
                guihooks.trigger('toastrMsg', {type = "error", title = "Track Limits Penalty!", msg = "Penalties: " .. penaltyCount, config = {timeOut = 3000 }})
                guihooks.trigger('ScenarioFlashMessage', {{"Track Limits Penalty!<br>Penalties: " .. penaltyCount, 3, nil, false}})
                Engine.Audio.playOnce('AudioGui', 'event:>UI>Career>Drift_Canceled', {pitch=0.5, volume = 2, unique = true})
            end
        end
    end
end

local function onVehicleResetted(gameVehicleID)
    if MPVehicleGE.isOwn(gameVehicleID) then
        if lapsActive then
            out = false
            lapsActive = false
            lapsContinue = false
            penaltyCount = 0
            guihooks.trigger('toastrMsg', {type = "error", title = "Time Forfeit!", msg = "Lap voided due to reset!", config = {timeOut = 2500 }})
            guihooks.trigger('ScenarioFlashMessage', {{"Time Forfeit!<br>Lap voided due to reset!", 2.5, nil, false}})
            Engine.Audio.playOnce('AudioGui', 'event:>UI>Career>Drift_Canceled', {volume = 2, unique = true})
        end
    end
end

local function onBeamNGTrigger(data)
    if data.triggerName == "startStop" and MPVehicleGE.isOwn(data.subjectID) == true then
        if data.event == "exit" then
            onLapStart(be:getObjectByID(data.subjectID).jbeam)
        elseif data.event == "enter" then
            onLapStop(data.subjectID)
        end
    elseif string.find(data.triggerName,"outOfBounds") and MPVehicleGE.isOwn(data.subjectID) == true then
        if data.event == "enter" then
            onLapOutOfBounds(true)
        elseif data.event == "exit" then
            onLapOutOfBounds(false)
        end
    elseif string.find(data.triggerName,"lapSplit") and data.event == "enter" and MPVehicleGE.isOwn(data.subjectID) == true then
        onLapSplit(data.triggerName, data.subjectID)
    end
end

local function onUpdate(dt)
    lapTimer = lapTimer + dt
    if worldReadyState == 2 then
        if not prefabRequested then
            TriggerServerEvent("requestPreFabSync", "")
            prefabRequested = true
        end
        if out then
            penaltyTimer = penaltyTimer + dt
            if penaltyTimer >= penaltyTimeout then
                penaltyTimer = 0
                out = false
            end
        end
        if not syncRequested then
            levelIdentifier = getCurrentLevelIdentifier()
            if levelIdentifier then
                theLeaderBoard.levels[levelIdentifier] = {}
                theLeaderBoard.levels[levelIdentifier].tracks = {}
                theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier] = {}
                theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier].overallBestTime = {}
                for name in pairs(vehiclesLookup) do
                    theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][name] = {}
                    theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][name].entries = {}
                    theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier][name].overallBestTime = {}
                end
            end
            trackData = theLeaderBoard.levels[levelIdentifier].tracks[trackIdentifier]
            TriggerServerEvent("requestHotLapsSync", "")
            syncRequested = true
        end
        if #checkPoints == 0 then
            if levelIdentifier then
                local tempCount = 0
                for checkpoint in pairs(checkPointsData.levels[levelIdentifier].tracks[trackIdentifier].checkPoints) do
                    if string.find(checkpoint, "lapSplit") then
                        tempCount = tempCount + 1
                    end
                end
                for _, data in pairs(checkPointsData.levels[levelIdentifier].tracks[trackIdentifier].checkPoints) do
                    local newCheckPoint = scenetree.findObject(data.name)
                    if newCheckPoint == nil then
                        log('I', "markerCreation", 'Creating checkpoint ' .. tostring(data.name) )
                        newCheckPoint = createCheckPoint(data)
                    end
                    table.insert(checkPoints, newCheckPoint)
                end
                checkpointCount = tempCount
            end
        end
        if #markers == 0 then
            if levelIdentifier then
                for _, data in pairs(markersData) do
                    local newCheckPointMarker = scenetree.findObject(data.name)
                    if newCheckPointMarker == nil then
                        log('I', "checkPointCreation", 'Creating marker ' .. tostring(data.name) )
                        newCheckPointMarker = createMarker(data)
                    end
                    table.insert(markers, newCheckPointMarker)
                end
            end
        end
        if levelIdentifier then
            drawHotLaps()
        end
    end
end

local function onExtensionLoaded()
    for genericName, vehicleData in pairs(vehiclesLookup) do
        table.insert( sortedVehicles, { genericName = genericName, make = vehicleData.make, model = vehicleData.model } )
    end
    table.sort(
        sortedVehicles, function(a, b)
            if a.make == b.make then
                return a.model < b.model
            else
                return a.make < b.make
            end
        end
    )

    AddEventHandler("rxCourseBest", rxCourseBest)
    AddEventHandler("rxPersonalBest", rxPersonalBest)
    AddEventHandler("rxCurentLap", rxCurentLap)
    AddEventHandler("rxGain", rxGain)
    AddEventHandler("rxLoss", rxLoss)
    AddEventHandler("rxNeutral", rxNeutral)
    AddEventHandler("rxLeaderBoard", rxLeaderBoard)
    AddEventHandler("rxPrefabSync", rxPrefabSync)
    local currentMPUILayout = deepcopy(originalMPUILayout)
    local found
    if currentMPUILayout then
        for _, app in pairs(currentMPUILayout.apps) do
            if app.appName == "raceCountdown" then
                found = true
            end
        end
        if not found then
            local raceCountdown = {
            appName = "raceCountdown",
                placement = {
                    bottom = "",
                    height = "160px",
                    left = 0,
                    margin = "auto",
                    position = "absolute",
                    right = 0,
                    top = "40%",
                    width = "690px"
                }
            }
            table.insert(currentMPUILayout.apps, raceCountdown)
            jsonWriteFile("settings/ui_apps/layouts/default/multiplayer.uilayout.json", currentMPUILayout, 1)
        end
    end
    gui_module.initialize(gui)
    gui.registerWindow("hotLaps", im.ImVec2(300, 500))
    gui.showWindow("hotLaps")
    log('I', "hotLaps", "HotLaps Loaded!")
end

local function onExtensionUnloaded()
    jsonWriteFile("settings/ui_apps/layouts/default/multiplayer.uilayout.json", originalMPUILayout, 1)
    syncRequested = false
    log('I', "hotLaps", "HotLaps Unloaded!")
end

M.onBeamNGTrigger = onBeamNGTrigger

M.onVehicleResetted = onVehicleResetted

M.onUpdate = onUpdate

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded

M.onInit = function() setExtensionUnloadMode(M, "manual") end

return M
