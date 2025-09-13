extends Control

@export var button_play: Button
@export var button_stop: Button

@export var grid_container: GridContainer
@export var label_score_total: Label


var score := 0:
    set(v):
        score = v
        label_score_total.text = "%s" % [score]


func _ready() -> void:
    GlobalSignal.chip_entered_chip_sensor.connect(_on_chip_entered_chip_sensor)
    GlobalSignal.chip_dropped.connect(_on_chip_dropped)
    score = 0


func _on_chip_entered_chip_sensor(chip: Chip) -> void:
    # debug
    score += chip.score


func _on_chip_dropped(chip: Chip) -> void:
    grid_container.add_child(chip.duplicate())
