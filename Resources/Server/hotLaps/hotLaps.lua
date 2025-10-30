--hotLaps (SERVER) by Dudekahedron, 2025

local hotLaps_VERSION = "v0.0.3"

local currentTrack = "long"
local currentLevel = "hirochi_raceway"

local jsonPath = "Resources/Server/hotLaps/json/"
local levelsPath = jsonPath .. "levels/levels.json"
local leaderBoardPath = jsonPath .. "leaderboard/leaderboard.json"
local playersPath = jsonPath .. "players/"
local playerJsons
local vehiclesPath = jsonPath .. "vehicles/vehicles.json"

local players = {}

local vehicles = {}

local levels = {}

local defaultVehicles = {
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
    md_series = "MD-Series",
    midsize = "Pessima '96-'00",
    midtruck = "Stambecco",
    miramar = "Miramar",
    moonhawk = "Moonhawk",
    nine = "Nine",
    pessima = "Pessima '88-'91",
    pickup = "D-Series",
    pigeon = "Pigeon",
    racetruck = "Dunekicker",
    roamer = "Roamer",
    rockbouncer = "Rockbasher",
    sbr = "SBR4",
    scintilla = "Scintilla",
    simple_traffic = "Simple Traffic",
    sunburst2 = "Sunburst",
    unicycle = "Player Model",
    us_semi = "T-Series",
    utv = "Hirochi Aurata",
    van = "H-Series",
    vivace = "FCV",
    wendover = "Wendover",
    wigeon = "Wigeon"
}

local defaultLevels = {
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

local Player = {}
Player.__index = Player

local Vehicle = {}
Vehicle.__index = Vehicle

local Leaderboard = {}
Leaderboard.__index = Leaderboard

local theLeaderBoard = {}

function Leaderboard.new(data)
    local self = setmetatable({}, Leaderboard)
    if not data then
        self.levels = {
            bathurst = { tracks = { long = {} } },
            ks_brands_hatch = { tracks = { long = {} } },
            hockenheim_ring = { tracks = { long = {} } },
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
    local updateOverallBestTime
    local dataEntry = {
        name = data.name,
        model = data.model,
        owner = data.owner,
        config = data.config,
        lapTime = data.lapTime,
        lapSplits = data.lapSplits,
        penalties = data.penalties
    }
    if not self.levels[data.level] then
        self.levels[data.level] = { tracks = {} }
    end
    if not self.levels[data.level].tracks[data.track] then
        self.levels[data.level].tracks[data.track] = {
            overallBestTime = nil,
            [data.model] = { entries = {} }
        }
    elseif not self.levels[data.level].tracks[data.track][data.model] then
        self.levels[data.level].tracks[data.track][data.model] = { entries = {} }
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
    if not overallBestTime or data.lapTime < (overallBestTime.lapTime or math.huge) then
        self.levels[data.level].tracks[data.track].overallBestTime = dataEntry
        updateOverallBestTime = true
    end
    WriteJSON(leaderBoardPath, self)
    for vehicle, vehicleBoard in pairs(self.levels[currentLevel].tracks[currentTrack]) do
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
    return updateOverallBestTime
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

function Player.findByName(players, player_name)
    for _, player in ipairs(players) do
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
    if not self.lapTimes then
        self.lapTimes = {}
    end
    local lapTypeOutput
    local lapTimeOutput
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
        self.lapTimes.bestEntry = data
        lapTypeOutput = "rxPersonalBest"
        lapTimeOutput = tostring(self.bestTime)
        MP.SendChatMessage(-1, self.owner .. " set a personal best time of " .. prettyTime(self.bestTime))
        MP.SendNotification(-1, self.owner .. " set a personal best time of " .. prettyTime(self.bestTime), 'timer', self.owner .. tostring(os.time))
    else
        lapTypeOutput = "rxCurentLap"
        lapTimeOutput = tostring(data.lapTime)
    end
    if theLeaderBoard:addLapTime(
        {
            level = data.level,
            track = data.track,
            model = self.vehicle_data.jbm,
            owner = self.owner,
            name = vehicles[self.vehicle_data.jbm],
            config = string.match(self.vehicle_data.vcf.partConfigFilename, ".*/(.*)%.pc"),
            lapTime = data.lapTime,
            lapSplits = data.lapSplits,
            penalties = data.penalties
        }
    ) then
        lapTypeOutput = "rxCourseBest"
        lapTimeOutput = tostring(data.lapTime)
        MP.SendChatMessage(-1, self.owner .. " set a course best time of: " .. prettyTime(data.lapTime))
        MP.SendNotification(-1, self.owner .. " set a course best time of: " .. prettyTime(data.lapTime), 'timer', self.owner .. tostring(os.time))
    end
    local playerJsonPath = playersPath .. beammp .. ".json"
    local playerData = ReadJSON(playerJsonPath)
    if playerData then
        if not playerData.savedVehicles.levels[currentLevel] then
            playerData.savedVehicles.levels[currentLevel] = {tracks = {}}
        end
        if not playerData.savedVehicles.levels[currentLevel].tracks[data.track] then
            playerData.savedVehicles.levels[currentLevel].tracks[data.track] = {}
        end
        playerData.savedVehicles.levels[currentLevel].tracks[data.track][self.vehicle_data.jbm] = {
            entries = {
                name = vehicles[self.vehicle_data.jbm],
                config = string.match(self.vehicle_data.vcf.partConfigFilename, ".*/(.*)%.pc"),
                lapTimes = self.lapTimes
            },
            bestTime = self.bestTime
        }
        WriteJSON(playerJsonPath, playerData)
    end
    if lapTypeOutput and lapTimeOutput then
        MP.TriggerClientEvent(MP.GetPlayerIDByName(self.owner), lapTypeOutput, lapTimeOutput)
    end
end

local function preparePlayerData(playerData, vehicle_data, level, track)
    local node = playerData
    for _, key in ipairs( { "savedVehicles", "levels", level, "tracks", track, vehicle_data.jbm, "entries" } ) do
        node[key] = node[key] or {}
        node = node[key]
    end
end

local function processVehicleData(player_id, vehicle_id, data)
    local separator = data:find('%{')
    local raw_data = data:sub(separator)
    local vehicle_data = Util.JsonDecode(raw_data)
    vehicle_data.serverVID = player_id .. "-" .. vehicle_id
    return vehicle_data
end

local function addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
    print("[hotLaps] ----------  Adding " .. vehicle_data.jbm .. " for " .. player.player_name .. "!")
    preparePlayerData(playerData, vehicle_data, currentLevel, currentTrack)
    WriteJSON(playerJsonPath, playerData)
    local spawnVehicle = Vehicle.new(player.player_name, vehicle_id, vehicle_data)
    player:addVehicle(spawnVehicle)
    print("[hotLaps] ----------  Added " .. vehicle_data.jbm .. " for " .. player.player_name .. " successfully!")
end

local function loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
    print("[hotLaps] ----------  Loading existing vehicle " .. vehicle_data.jbm .. " for " .. player.player_name .. "!")
    local vehicleEntry = playerData.savedVehicles.levels[currentLevel].tracks[currentTrack][vehicle_data.jbm]
    local existingVehicle = Vehicle.new(player.player_name, vehicle_id, vehicle_data)
    existingVehicle.bestTime = vehicleEntry.bestTime
    if vehicleEntry.entries then
        if vehicleEntry.entries.lapTimes then
            existingVehicle.lapTimes = vehicleEntry.entries.lapTimes
        else
            existingVehicle.lapTimes = {}
        end
    end
    player:addVehicle(existingVehicle)
    print("[hotLaps] ----------  Loaded existing vehicle " .. vehicle_data.jbm .. " for " .. player.player_name .. " successfully!")
end

local function setupHotlaps()
    if not FS.IsDirectory(jsonPath) then
        FS.CreateDirectory(jsonPath)
    end
    levels = ReadJSON(levelsPath)
    if not levels then
        if not FS.IsDirectory(jsonPath .. "levels/") then
            print("[hotLaps] ----------  levels directory not found or empty. Creating levels directory!")
            FS.CreateDirectory(jsonPath .. "levels/")
        end
        levels = defaultLevels
        WriteJSON(levelsPath, levels)
    end
    theLeaderBoard = ReadJSON(leaderBoardPath)
    if not theLeaderBoard then
        if not FS.IsDirectory(jsonPath .. "leaderboard/") then
            print("[hotLaps] ----------  leaderboard directory not found. Creating leaderboard directory!")
            FS.CreateDirectory(jsonPath .. "leaderboard/")
        end
        theLeaderBoard = Leaderboard.new()
        WriteJSON(leaderBoardPath, theLeaderBoard)
    else
        theLeaderBoard = Leaderboard.new(theLeaderBoard)
    end
    if not FS.IsDirectory(playersPath) then
        print("[hotLaps] ----------  players directory not found. Creating players directory!")
        FS.CreateDirectory(playersPath)
    end
    playerJsons = FS.ListFiles(playersPath)
    if #playerJsons == 0 then
        print("[hotLaps] ----------  players directory empty. Creating dummy player!")
        local dummy = Player.new("dummy", "USER", false, { ip = "0.0.0.0", beammp = 0 })
        table.insert(players, dummy)
        WriteJSON(playersPath .. dummy.identifiers.beammp .. ".json", dummy)
    else
        for _, playerJson in pairs(playerJsons) do
            local player
            local playerJsonPath = playersPath .. playerJson
            player = ReadJSON(playerJsonPath)
            if player then
                print("[hotLaps] ----------  Loading Existing Player: " .. player.player_name)
                local existingPlayer = Player.new(player.player_name, player.role, player.is_guest, player.identifiers)
                table.insert(players, existingPlayer)
            end
        end
    end
    vehicles = ReadJSON(vehiclesPath)
    if not vehicles then
        if not FS.IsDirectory(jsonPath .. "vehicles/") then
            print("[hotLaps] ----------  vehicles directory not found or empty. Creating vehicles directory!")
            FS.CreateDirectory(jsonPath .. "vehicles/")
            vehicles = defaultVehicles
            WriteJSON(vehiclesPath, vehicles)
        end
    end
end

local function findPlayer(player_id)
    for _, player in ipairs(players) do
        if player.player_id == player_id then
            return player
        end
    end
    return nil
end

function onInit()

    setupHotlaps()

    MP.RegisterEvent("requestHotLapsSync","requestHotLapsSyncHandler")
    MP.RegisterEvent("requestPreFabSync","requestPreFabSyncHandler")

    MP.RegisterEvent("onLapStart","onLapStartHandler")
    MP.RegisterEvent("onLapSplit","onLapSplitHandler")
    MP.RegisterEvent("onLapStop","onLapStopHandler")

    MP.RegisterEvent("onVehicleSpawn","onVehicleSpawnHandler")
    MP.RegisterEvent("onVehicleEdited","onVehicleEditedHandler")
    MP.RegisterEvent("onVehicleDeleted","onVehicleDeletedHandler")

    MP.RegisterEvent("onPlayerAuth","onPlayerAuthHandler")
    MP.RegisterEvent("onPlayerConnecting","onPlayerConnectingHandler")
    MP.RegisterEvent("onPlayerDisconnect","onPlayerDisconnectHandler")

    print("[hotLaps] ---------- hotLaps " .. hotLaps_VERSION .. " Loaded!")

end

function requestPreFabSyncHandler(player_id)
    MP.TriggerClientEvent(player_id, "rxPrefabSync", "")
end

function requestHotLapsSyncHandler(player_id)
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

function onLapStartHandler(player_id, data)

end

function onLapSplitHandler(player_id, data)
    local splitData = Util.JsonDecode(data)
    local player
    local sendData
    for _, currentPlayer in ipairs(players) do
        if currentPlayer.player_id == player_id then
            player = currentPlayer
            break
        end
    end
    if player then
        local vehicle = player:getVehicleById(tonumber(string.sub(splitData.serverVehicleID, -1)))
        if vehicle then
            if vehicle.lapTimes then
                if vehicle.lapTimes.bestEntry then
                    if vehicle.lapTimes.bestEntry.lapSplits then
                        if vehicle.lapTimes.bestEntry.lapSplits[splitData.splitTimeID] then
                            if vehicle.lapTimes.bestEntry.lapSplits[splitData.splitTimeID] < splitData.lapSplit then
                                sendData = {
                                    time = splitData.lapSplit,
                                    difference =  splitData.lapSplit - vehicle.lapTimes.bestEntry.lapSplits[splitData.splitTimeID],
                                    splitTimeID = splitData.splitTimeID,
                                    checkpointCount = splitData.checkpointCount,
                                    triggerName = splitData.triggerName
                                }
                                MP.TriggerClientEventJson(player_id, "rxLoss", sendData)
                            elseif vehicle.lapTimes.bestEntry.lapSplits[splitData.splitTimeID] > splitData.lapSplit then
                                sendData = {
                                    time = splitData.lapSplit,
                                    difference = vehicle.lapTimes.bestEntry.lapSplits[splitData.splitTimeID] - splitData.lapSplit,
                                    splitTimeID = splitData.splitTimeID,
                                    checkpointCount = splitData.checkpointCount,
                                    triggerName = splitData.triggerName
                                }
                                MP.TriggerClientEventJson(player_id, "rxGain", sendData)
                            else
                                sendData = {
                                    time = splitData.lapSplit,
                                    splitTimeID = splitData.splitTimeID,
                                    checkpointCount = splitData.checkpointCount,
                                    triggerName = splitData.triggerName
                                }
                                MP.TriggerClientEventJson(player_id, "rxNeutral", sendData)
                            end
                        end
                    end
                else
                    sendData = {
                        time = splitData.lapSplit,
                        splitTimeID = splitData.splitTimeID,
                        checkpointCount = splitData.checkpointCount,
                        triggerName = splitData.triggerName
                    }
                    MP.TriggerClientEventJson(player_id, "rxNeutral", sendData)
                end
            end
        end
    end
end

function onLapStopHandler(player_id, data)
    local lapData = Util.JsonDecode(data)
    local player
    for _, currentPlayer in ipairs(players) do
        if currentPlayer.player_id == player_id then
            player = currentPlayer
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

function onVehicleSpawnHandler(player_id, vehicle_id, data)
    local player = findPlayer(player_id)
    if not player then
        return
    end
    local vehicle_data = processVehicleData(player_id, vehicle_id, data)
    if not defaultVehicles[vehicle_data.jbm] then
        return
    end
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
    if not player then
        return
    end
    local vehicle_data = processVehicleData(player_id, vehicle_id, data)
    if not defaultVehicles[vehicle_data.jbm] then
        return
    end
    local playerJsonPath = playersPath .. player.identifiers.beammp .. ".json"
    local playerData = ReadJSON(playerJsonPath)
    if playerData then
        local trackData = playerData.savedVehicles and
        playerData.savedVehicles.levels[currentLevel] and
        playerData.savedVehicles.levels[currentLevel].tracks[currentTrack]
        local vehicle = player:getVehicleById(vehicle_id)
        if vehicle then
            if vehicle.vehicle_data.jbm ~= vehicle_data.jbm then
                player:removeVehicleById(vehicle_id)
                if trackData and trackData[vehicle_data.jbm] then
                    loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
                else
                    addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
                end
            elseif vehicle.vehicle_data.vcf.partConfigFilename ~= vehicle_data.vcf.partConfigFilename then
                player:removeVehicleById(vehicle_id)
                if trackData and trackData[vehicle_data.jbm] then
                    loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
                else
                    addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
                end
            end
        else
            if trackData and not trackData[vehicle_data.jbm] then
                addNewVehicle(player, playerData, vehicle_id, vehicle_data, playerJsonPath)
            else
                loadExistingVehicle(player, vehicle_id, vehicle_data, playerData)
            end
        end
    end
end

function onVehicleDeletedHandler(player_id, vehicle_id)
    local player = findPlayer(player_id)
    if not player then
        return
    end
    for _, currentPlayer in ipairs(players) do
        if currentPlayer.player_id == player_id then
            player = currentPlayer
            break
        end
    end
    if player then
        player:removeVehicleById(vehicle_id)
    end
end

function onPlayerAuthHandler(player_name, role, is_guest, identifiers)
    if identifiers.beammp then
        local playerTable
        local playerJsonPath = playersPath .. identifiers.beammp .. ".json"
        playerTable = ReadJSON(playerJsonPath)
        if not playerTable then
            print("[hotLaps] ----------  Creating file for " .. player_name .. "!")
            local playerData = {}
            playerData.player_name = player_name
            playerData.role = role
            playerData.identifiers = identifiers
            WriteJSON(playerJsonPath, playerData)
        end
        local player = Player.findByName(players, player_name)
        if not player then
            local authPlayer = Player.new(player_name, role, is_guest, identifiers)
            table.insert(players, authPlayer)
        end
    end
end

function onPlayerConnectingHandler(player_id)
    local player_name = MP.GetPlayerName(player_id)
    local player = Player.findByName(players, player_name)
    if player then
        player:update("player_id", player_id)
    else
        MP.DropPlayer(player_id, "Connection Fault: Rejoin server!")
    end
end

function onPlayerDisconnectHandler(player_id)
    for _, player in ipairs(players) do
        if player.player_id == player_id then
            for _, vehicle in pairs(player.vehicles) do
                player:removeVehicleById(vehicle.vehicle_id)
            end
            player:disconnect()
            break
        end
    end
end

function ReadJSON(path)
    if not FS.Exists(path) then
        print("[hotLaps] ----------  " .. path .. " does not exist!")
        return
    end
    local JSONfile = io.open(path,"r")
    if JSONfile then
        local JSONtext = JSONfile:read("*a")
        JSONfile:close()
        local data = Util.JsonDecode(JSONtext)
        return data
    else
        print("[hotLaps] ----------  " .. path .. " does not exist!")
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
        print("[hotLaps] ----------  " .. path .. " does not exist!")
        return
    end
end

function prettyTime(seconds)
    local thousandths = seconds * 1000
    local mm = math.floor((thousandths / (60 * 1000))) % 60
    local ss = math.floor(thousandths / 1000) % 60
    local ms = math.floor(thousandths % 1000)
    return string.format("%02d:%02d.%03d", mm, ss, ms)
end
