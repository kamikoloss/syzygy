extends Control

const PLAY_STOP_DURATION = 0.2


@export var objects: Control
@export var chip_storage: GridContainer

@export var button_play: Button
@export var button_stop: Button

@export var _label_version: Label
@export var _label_score_total: Label


var total_score := 0:
    set(v):
        total_score = v
        _label_score_total.text = "%s" % [total_score]


func _ready() -> void:
    GlobalSignal.chip_entered_chip_sensor.connect(_on_chip_entered_chip_sensor)
    GlobalSignal.chip_fallen.connect(_on_chip_fallen)
    button_play.pressed.connect(_on_button_play_pressed)
    button_stop.pressed.connect(_on_button_stop_pressed)

    _label_version.text = ProjectSettings.get_setting("application/config/version")

    total_score = 0


func _on_chip_entered_chip_sensor(chip: Chip) -> void:
    # debug
    total_score += chip.score


func _on_chip_fallen(chip: Chip) -> void:
    # ストレージの Chip を元に戻す
    chip_storage.add_child(chip.duplicate())


func _on_button_play_pressed() -> void:
    print("[Main] play.")
    # TODO


func _on_button_stop_pressed() -> void:
    print("[Main] stop.")
    # TODO
