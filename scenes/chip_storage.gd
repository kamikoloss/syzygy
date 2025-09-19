class_name ChipStorage
extends Control

const LOCKED_COLOR := Color(0.4, 0.4, 0.4)

@export var chips_parent: GridContainer

@export var _label_price: Label

var price := 0:
    set(v):
        price = v
        _label_price.text = str(price)
var locked := false:
    set(v):
        locked = v
        if locked:
            modulate = LOCKED_COLOR
        else:
            modulate = Color.WHITE
