class_name ChipData
extends Node

enum Type {
    NONE,
    ACCOUNT,
}

## { <Type>: [ <Label>, <Color>, <Price>, <Score> ], ... }
const DATA := {
    Type.NONE:      ["", Color(0.2, 0.2, 0.2, 0.2), 0, 0],
    Type.ACCOUNT:   ["★", Color(0.8, 0.8, 0.8), 0, 0],
}
