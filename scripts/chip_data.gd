class_name ChipData
extends Node

enum Type {
    NONE,
    ACCOUNT,
    PLUS_1, PLUS_2, PLUS_3, PLUS_4,
    PLUS_5, PLUS_6, PLUS_7, PLUS_8, PLUS_9,
}

## { <Type>: [ <Label>, <Color>, <Price>, <Score> ], ... }
## ref. https://v3.tailwindcss.com/docs/customizing-colors
const DATA := {
    Type.NONE:      ["",    Color("#374151"), 0, 0],
    Type.ACCOUNT:   ["X",   Color("#374151"), 0, 0],
    Type.PLUS_1:    ["+1",  Color("#fee2e2"), 0, 1],
    Type.PLUS_2:    ["+2",  Color("#fecaca"), 10, 2],
    Type.PLUS_3:    ["+3",  Color("#fca5a5"), 100, 3],
    Type.PLUS_4:    ["+5",  Color("#f87171"), 1000, 5],
    Type.PLUS_5:    ["+8",  Color("#ef4444"), 10000, 8],
    Type.PLUS_6:    ["+13", Color("#dc2626"), 10, 13],
    Type.PLUS_7:    ["+21", Color("#b91c1c"), 10, 21],
    Type.PLUS_8:    ["+34", Color("#991b1b"), 10, 34],
    Type.PLUS_9:    ["+55", Color("#7f1d1d"), 10, 55],
}

## { <Price>: [ [ ChipData.Type, <Amount> ], ... ], ... }
const STORAGE_DATA := {
    0: [
        [ChipData.Type.PLUS_1, 4],
    ],
    10: [
        [ChipData.Type.PLUS_2, 4],
    ],
    100: [
        [ChipData.Type.PLUS_3, 4],
    ],
    1000: [
        [ChipData.Type.PLUS_4, 4],
    ],
    10000: [
        [ChipData.Type.PLUS_5, 4],
    ],
    #[ChipData.Type.PLUS_6, 4],
    #[ChipData.Type.PLUS_7, 4],
    #[ChipData.Type.PLUS_8, 4],
    #[ChipData.Type.PLUS_9, 4],
}
