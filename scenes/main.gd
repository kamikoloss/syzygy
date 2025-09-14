extends Control

const PLAY_STOP_DURATION = 0.2

@export var button_play: Button
@export var button_stop: Button

@export var objects: Control
@export var chip_storage: GridContainer
@export var label_score_total: Label


var score := 0:
    set(v):
        score = v
        label_score_total.text = "%s" % [score]


func _ready() -> void:
    GlobalSignal.chip_entered_chip_sensor.connect(_on_chip_entered_chip_sensor)
    GlobalSignal.chip_fallen.connect(_on_chip_fallen)
    button_play.pressed.connect(_on_button_play_pressed)
    button_stop.pressed.connect(_on_button_stop_pressed)

    score = 0


func _on_chip_entered_chip_sensor(chip: Chip) -> void:
    # debug
    score += chip.score


func _on_chip_fallen(chip: Chip) -> void:
    # ストレージの Chip を元に戻す
    chip_storage.add_child(chip.duplicate())


func _on_button_play_pressed() -> void:
    print("[Main] play.")


func _on_button_stop_pressed() -> void:
    print("[Main] stop.")
