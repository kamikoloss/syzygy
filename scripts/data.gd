class_name Data
extends Node

enum ChipType {
    NONE,
    ACCOUNT,
    ADD_1, ADD_2, ADD_3, ADD_4, ADD_5, ADD_6, ADD_7,
    CLEAR,
    SPEED_1, SPEED_2, SPEED_3, SPEED_4, SPEED_5, SPEED_6, SPEED_7,
    SPEED_S_1, SPEED_S_2, SPEED_S_3, SPEED_S_4,
    TIME_1, TIME_2, TIME_3, TIME_4, TIME_5, TIME_6, TIME_7,
    TIME_S_1, TIME_S_2, TIME_S_3, TIME_S_4,
}

const CHIP_TYPES_ADD := [
    ChipType.ADD_1, ChipType.ADD_2, ChipType.ADD_3, ChipType.ADD_4,
    ChipType.ADD_5, ChipType.ADD_6, ChipType.ADD_7,
]
const CHIP_TYPES_SPEED := [
    ChipType.SPEED_1, ChipType.SPEED_2, ChipType.SPEED_3, ChipType.SPEED_4,
    ChipType.SPEED_5, ChipType.SPEED_6, ChipType.SPEED_7,
]
const CHIP_TYPES_SPEED_S := [
    ChipType.SPEED_S_1, ChipType.SPEED_S_2, ChipType.SPEED_S_3, ChipType.SPEED_S_4,
]
const CHIP_TYPES_TIME := [
    ChipType.TIME_1, ChipType.TIME_2, ChipType.TIME_3, ChipType.TIME_4,
    ChipType.TIME_5, ChipType.TIME_6, ChipType.TIME_7,
]
const CHIP_TYPES_TIME_S := [
    ChipType.TIME_S_1, ChipType.TIME_S_2, ChipType.TIME_S_3, ChipType.TIME_S_4,
]

## { ChipType: [ <Label>, <Color>, <score> ], ... }
## ref. https://v3.tailwindcss.com/docs/customizing-colors
const CHIP_DATA := {
    ChipType.NONE:      ["",    Color("#374151"), -1], # gray-700
    ChipType.ACCOUNT:   ["S",   Color("#374151"), -1], # gray-700
    ChipType.ADD_1:     ["+1",  Color("#fee2e2"), 1],
    ChipType.ADD_2:     ["+2",  Color("#fecaca"), 2],
    ChipType.ADD_3:     ["+3",  Color("#fca5a5"), 3],
    ChipType.ADD_4:     ["+5",  Color("#f87171"), 5],
    ChipType.ADD_5:     ["+8",  Color("#ef4444"), 8],
    ChipType.ADD_6:     ["+13", Color("#dc2626"), 13],
    ChipType.ADD_7:     ["+21", Color("#b91c1c"), 21],
    ChipType.CLEAR:     ["!!!", Color("#ffffff"), -1], # Rainbow
    ChipType.SPEED_1:   [">2",  Color("#eff6ff"), 2],
    ChipType.SPEED_2:   [">3",  Color("#dbeafe"), 3],
    ChipType.SPEED_3:   [">4",  Color("#93c5fd"), 4],
    ChipType.SPEED_4:   [">5",  Color("#60a5fa"), 5],
    ChipType.SPEED_5:   [">6",  Color("#3b82f6"), 6],
    ChipType.SPEED_6:   [">7",  Color("#2563eb"), 7],
    ChipType.SPEED_7:   [">8",  Color("#1d4ed8"), 8],
    ChipType.SPEED_S_1: ["S<2", Color("#fef9c3"), 2],
    ChipType.SPEED_S_2: ["S<3", Color("#fef08a"), 3],
    ChipType.SPEED_S_3: ["S<4", Color("#fde047"), 4],
    ChipType.SPEED_S_4: ["S<5", Color("#facc15"), 5],
    ChipType.TIME_1:    ["x2",  Color("#dcfce7"), 2],
    ChipType.TIME_2:    ["x3",  Color("#bbf7d0"), 3],
    ChipType.TIME_3:    ["x4",  Color("#86efac"), 4],
    ChipType.TIME_4:    ["x5",  Color("#4ade80"), 5],
    ChipType.TIME_5:    ["x6",  Color("#22c55e"), 6],
    ChipType.TIME_6:    ["x7",  Color("#16a34a"), 7],
    ChipType.TIME_7:    ["x8",  Color("#15803d"), 8],
    ChipType.TIME_S_1:  ["Sx2", Color("#f3e8ff"), 2],
    ChipType.TIME_S_2:  ["Sx3", Color("#e9d5ff"), 3],
    ChipType.TIME_S_3:  ["Sx4", Color("#d8b4fe"), 4],
    ChipType.TIME_S_4:  ["Sx5", Color("#c084fc"), 5],
}

## { <price>: [ [ ChipType, <Amount> ], ... ], ... }
const CHIP_STORAGE_DATA := {
    0: [
        [ChipType.ADD_1, 4],
        [ChipType.TIME_1, 4],
        [ChipType.SPEED_1, 4],
    ],
    10: [
        [ChipType.ADD_2, 4],
        [ChipType.TIME_2, 4],
        [ChipType.SPEED_2, 4],
    ],
    100: [
        [ChipType.ADD_3, 4],
        [ChipType.TIME_3, 4],
        [ChipType.SPEED_3, 4],
    ],
    1_000: [
        [ChipType.ADD_4, 4],
        [ChipType.TIME_4, 4],
        [ChipType.SPEED_4, 4],
        [ChipType.TIME_S_1, 2],
        [ChipType.SPEED_S_1, 2],
    ],
    10_000: [
        [ChipType.ADD_5, 4],
        [ChipType.TIME_5, 4],
        [ChipType.SPEED_5, 4],
        [ChipType.TIME_S_2, 2],
        [ChipType.SPEED_S_2, 2],
    ],
    100_000: [
        [ChipType.ADD_6, 4],
        [ChipType.TIME_6, 4],
        [ChipType.SPEED_6, 4],
        [ChipType.TIME_S_3, 2],
        [ChipType.SPEED_S_3, 2],
    ],
    1_000_000: [
        [ChipType.ADD_7, 4],
        [ChipType.TIME_7, 4],
        [ChipType.SPEED_7, 4],
        [ChipType.TIME_S_4, 2],
        [ChipType.SPEED_S_4, 2],
    ],
    999_999_999: [
        [ChipType.CLEAR, 1],
    ],
}

## { <rail_number>: [ <circle_radius>, <rotate_speed>, <holder_count> ], ... }
const RAIL_DATA := {
    0: [320.0, 0.02, 32],
    1: [280.0, 0.04, 24],
    2: [240.0, 0.06, 16],
    3: [200.0, 0.10, 8],
    4: [160.0, 0.16, 4],
    5: [120.0, 0.26, 2],
    6: [80.0, 0.42, 1],
}
