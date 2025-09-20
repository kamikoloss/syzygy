class_name ChipStorage
extends Control

const LOCKED_COLOR := Color(0.4, 0.4, 0.4)

@export var chips_parent: GridContainer

@export var _label_price: Label

var price := 0:
    set(v):
        price = v
        _label_price.text = Util.format_number_with_commas(price)
var is_locked := false:
    set(v):
        is_locked = v
        if is_locked:
            modulate = LOCKED_COLOR
        else:
            modulate = Color.WHITE
        for node in chips_parent.get_children():
            if node is Chip:
                node.is_locked = is_locked
