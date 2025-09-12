extends Control

@export var button_play: Button
@export var button_stop: Button

@export var label_score_total: Label


var score := 0:
    set(v):
        score = v
        label_score_total.text = "%s" % [score]


func _ready() -> void:
    GlobalSignal.chip_entered_chip_sensor.connect(_on_chip_entered_chip_sensor)
    score = 0


func _on_chip_entered_chip_sensor(chip: Chip) -> void:
    score += chip.score
