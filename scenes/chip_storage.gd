class_name ChipStorage
extends Control

const LOCKED_COLOR := Color(0.4, 0.4, 0.4)

@export var _label_price: Label
@export var _chips_parent: GridContainer

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


func add_chip(chip: Chip) -> void:
    _chips_parent.add_child(chip)
