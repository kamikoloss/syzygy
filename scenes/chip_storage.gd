class_name ChipStorage
extends Control

@export var _label_price: Label
@export var _chips_parent: GridContainer

var price := 0:
    set(v):
        price = v
        _label_price.text = str(price)


func add_chip(chip: Chip) -> void:
    _chips_parent.add_child(chip)
