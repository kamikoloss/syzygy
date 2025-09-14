class_name ChipData
extends Node

enum Type {
    NONE,
    ACCOUNT,
    PLUS_1,
    PLUS_2, PLUS_4, PLUS_8, PLUS_16,
    PLUS_32, PLUS_64, PLUS_128, PLUS_256,
}

## { <Type>: [ <Label>, <Color>, <Price>, <Score> ], ... }
const DATA := {
    Type.NONE:      ["", Color(0.1, 0.1, 0.1), 0, 0],
    Type.ACCOUNT:   ["★", Color(0.8, 0.8, 0.8), 0, 0],
    Type.PLUS_1:    ["+1", Color(0.8, 0.8, 0.8), 0, 1],
    Type.PLUS_2:    ["+2", Color(0.8, 0.8, 0.8), 10, 2],
    Type.PLUS_4:    ["+4", Color(0.8, 0.8, 0.8), 10, 4],
    Type.PLUS_8:    ["+8", Color(0.8, 0.8, 0.8), 10, 8],
    Type.PLUS_16:    ["+16", Color(0.8, 0.8, 0.8), 10, 16],
    Type.PLUS_32:    ["+32", Color(0.8, 0.8, 0.8), 10, 32],
    Type.PLUS_64:    ["+64", Color(0.8, 0.8, 0.8), 10, 64],
    Type.PLUS_128:    ["+128", Color(0.8, 0.8, 0.8), 10, 128],
    Type.PLUS_256:    ["+256", Color(0.8, 0.8, 0.8), 10, 256],
}
