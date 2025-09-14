extends Control

const PLAY_STOP_DURATION = 0.2

@export var objects: Control
@export var chip_storage: GridContainer

@export var chip_scene: PackedScene

@export var _button_play: Button
@export var _button_stop: Button
@export var _label_version: Label
@export var _label_total_score: Label
@export var _label_total_time: Label
@export var _label_line_speed_parent: Control
@export var _label_line_score_parent: Control

var total_score := 0:
    set(v):
        total_score = v
        _label_total_score.text = "%s" % [total_score]
var stack_scores := [0, 0, 0, 0, 0, 0]
var stack_scores_sum := 0
var total_time_sec := 0.0:
    set(v):
        total_time_sec = v
        var min := int(floor(total_time_sec / 60))
        var sec := int(total_time_sec) % 60
        var milli_sec := int(total_time_sec * 1000) % 1000
        _label_total_time.text = "%02d:%02d.%03d" % [min, sec, milli_sec]


func _ready() -> void:
    GlobalSignal.chip_sensed.connect(_on_chip_sensed)
    GlobalSignal.chip_fallen.connect(_on_chip_fallen)
    _button_play.pressed.connect(_on_button_play_pressed)
    _button_stop.pressed.connect(_on_button_stop_pressed)

    _label_version.text = ProjectSettings.get_setting("application/config/version")

    # Score
    total_score = 0
    _reset_stack_scores()

    # Storage
    _init_storage_chips()


func _process(delta: float) -> void:
    # Rail
    var rail_index := 0
    for node in objects.get_children():
        if node is Rail:
            var label: Label = _label_line_speed_parent.get_child(rail_index)
            label.text = "x%1.2f" % [node.rotate_speed]
            rail_index += 1

    # debug
    total_time_sec += delta


func _on_chip_sensed(chip: Chip) -> void:
    if chip.type == ChipData.Type.ACCOUNT:
        total_score += stack_scores_sum
        _reset_stack_scores()
    elif chip.rail_number < Rail.RAIL_NUMBER_SUM and 0 < chip.score:
        var new_score = stack_scores[chip.rail_number] + chip.score
        _set_stack_score(chip.rail_number, new_score)


func _on_chip_fallen(chip: Chip) -> void:
    # ストレージの Chip を元に戻す
    chip_storage.add_child(chip.duplicate())


func _on_button_play_pressed() -> void:
    print("[Main] play.")
    # TODO


func _on_button_stop_pressed() -> void:
    print("[Main] stop.")
    # TODO


func _set_stack_score(rail_number: int, score: int) -> void:
    stack_scores[rail_number] = score
    var label: Label = _label_line_score_parent.get_child(rail_number)
    label.text = "%s" % [stack_scores[rail_number]]

    var sum := 0
    for stack_score in stack_scores:
        sum += stack_score
    stack_scores_sum = sum
    var label_sum: Label = _label_line_score_parent.get_child(Rail.RAIL_NUMBER_SUM)
    label_sum.text = "%s" % [stack_scores_sum]


func _reset_stack_scores() -> void:
    var rail_number := 0
    for stack_score in stack_scores:
        _set_stack_score(rail_number, 0)
        rail_number += 1

    stack_scores_sum = 0


func _init_storage_chips() -> void:
    for chip_data in ChipStorageData.DEFAULT_UNLOCKED_CHIPS:
        for _i in chip_data[1]:
            var chip: Chip = chip_scene.instantiate()
            chip.type = chip_data[0]
            chip.is_locked = false
            chip_storage.add_child(chip)
    for chip_data in ChipStorageData.DEFAULT_LOCKED_CHIPS:
        for _i in chip_data[1]:
            var chip: Chip = chip_scene.instantiate()
            chip.type = chip_data[0]
            chip.is_locked = true
            chip_storage.add_child(chip)
