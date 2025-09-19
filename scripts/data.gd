class_name Data
extends Node

enum ChipType {
    NONE,
    ACCOUNT,
    PLUS_1, PLUS_2, PLUS_3, PLUS_4, PLUS_5, PLUS_6, PLUS_7, PLUS_8, PLUS_9,
}

## { <Type>: [ <Label>, <Color>, <Score> ], ... }
## ref. https://v3.tailwindcss.com/docs/customizing-colors
const CHIP_DATA := {
    ChipType.NONE:      ["",    Color("#374151"), -1],
    ChipType.ACCOUNT:   ["X",   Color("#374151"), -1],
    ChipType.PLUS_1:    ["+1",  Color("#fee2e2"), 1],
    ChipType.PLUS_2:    ["+2",  Color("#fecaca"), 2],
    ChipType.PLUS_3:    ["+3",  Color("#fca5a5"), 3],
    ChipType.PLUS_4:    ["+5",  Color("#f87171"), 5],
    ChipType.PLUS_5:    ["+8",  Color("#ef4444"), 8],
    ChipType.PLUS_6:    ["+13", Color("#dc2626"), 13],
    ChipType.PLUS_7:    ["+21", Color("#b91c1c"), 21],
    ChipType.PLUS_8:    ["+34", Color("#991b1b"), 34],
    ChipType.PLUS_9:    ["+55", Color("#7f1d1d"), 55],
}

## { <Price>: [ [ Data.ChipType, <Amount> ], ... ], ... }
const CHIP_STORAGE_DATA := {
    0: [
        [ChipType.PLUS_1, 4],
    ],
    10: [
        [ChipType.PLUS_2, 4],
    ],
    100: [
        [ChipType.PLUS_3, 4],
    ],
    1000: [
        [ChipType.PLUS_4, 4],
    ],
    10000: [
        [ChipType.PLUS_5, 4],
    ],
}
