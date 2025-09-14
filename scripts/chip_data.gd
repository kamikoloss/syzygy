class_name ChipData
extends Node

enum Type {
    NONE,
    ACCOUNT,
    PLUS_1, PLUS_2, PLUS_3, PLUS_4,
    PLUS_5, PLUS_6, PLUS_7, PLUS_8, PLUS_9,
}

## { <Type>: [ <Label>, <Color>, <Price>, <Score> ], ... }
const DATA := {
    Type.NONE:      ["", Color(0.1, 0.1, 0.1), 0, 0],
    Type.ACCOUNT:   ["★", Color(0.2, 0.2, 0.2), 0, 0],
    Type.PLUS_1:    ["+1", Color(0.8, 0.8, 0.8), 0, 1],
    Type.PLUS_2:    ["+2", Color(0.8, 0.8, 0.8), 10, 2],
    Type.PLUS_3:    ["+3", Color(0.8, 0.8, 0.8), 100, 3],
    Type.PLUS_4:    ["+5", Color(0.8, 0.8, 0.8), 1000, 5],
    Type.PLUS_5:    ["+8", Color(0.8, 0.8, 0.8), 10000, 8],
    Type.PLUS_6:    ["+13", Color(0.8, 0.8, 0.8), 10, 13],
    Type.PLUS_7:    ["+21", Color(0.8, 0.8, 0.8), 10, 21],
    Type.PLUS_8:    ["+34", Color(0.8, 0.8, 0.8), 10, 34],
    Type.PLUS_9:    ["+55", Color(0.8, 0.8, 0.8), 10, 55],
}
