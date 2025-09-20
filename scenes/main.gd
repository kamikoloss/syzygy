extends Control

const PLAY_STOP_DURATION = 0.2
const SCORE_CHANGE_DURATION = 1.0

@export var objects_parent: Control

@export var _chip_storages_parent: Control

@export var _rail_scene: PackedScene
@export var _chip_scene: PackedScene
@export var _chip_storage_scene: PackedScene

@export var _button_play: Button
@export var _button_stop: Button
@export var _label_version: Label
@export var _label_total_score: Label
@export var _label_total_time: Label
@export var _label_line_speed_parent: Control
@export var _label_line_score_parent: Control

var total_score := 0:
    set(v):
        var before = total_score
        total_score = v
        var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
        tween.tween_method(func(x): _label_total_score.text = Util.format_number_with_commas(x), before, total_score, SCORE_CHANGE_DURATION)
        _try_unlock_storages()
var stack_scores_sum := 0:
    set(v):
        var before = stack_scores_sum
        stack_scores_sum = v
        var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
        tween.tween_method(func(x): _label_score_sum.text = Util.format_number_with_commas(x), before, stack_scores_sum, SCORE_CHANGE_DURATION)
var stack_scores := [0, 0, 0, 0, 0, 0]
var total_time_sec := 0.0:
    set(v):
        total_time_sec = v
        _label_total_time.text = "%02d:%02d.%03d" % [
            int(floor(total_time_sec / 60)),
            int(total_time_sec) % 60,
            int(total_time_sec * 1000) % 1000,
        ]

var _label_score_sum: Label


func _ready() -> void:
    GlobalSignal.chip_sensed.connect(_on_chip_sensed)
    GlobalSignal.chip_fallen.connect(_on_chip_fallen)
    _button_play.pressed.connect(_on_button_play_pressed)
    _button_stop.pressed.connect(_on_button_stop_pressed)

    _label_version.text = ProjectSettings.get_setting("application/config/version")
    _label_score_sum = _label_line_score_parent.get_child(Rail.RAIL_NUMBER_SUM)

    # init
    _init_rails()
    _init_chip_storages()

    # Score
    # MUST after _init_chip_storages()
    total_score = 0
    stack_scores_sum = 0
    _reset_stack_scores()


func _process(delta: float) -> void:
    # Rail
    var rail_index := 0
    for node in objects_parent.get_children():
        if node is Rail:
            var label: Label = _label_line_speed_parent.get_child(rail_index)
            label.text = "x%1.2f" % [node.rotate_speed]
            rail_index += 1

    # debug
    total_time_sec += delta


func _on_chip_sensed(chip: Chip) -> void:
    if chip.type == Data.ChipType.ACCOUNT:
        print("[Main] _on_chip_sensed(ACCOUNT) stack_scores: %s" % [stack_scores])
        total_score += stack_scores_sum
        _reset_stack_scores()
    elif chip.type in Data.CHIP_TYPES_ADD:
        var new_score = stack_scores[chip.rail_number] + chip.score
        _set_stack_score(chip.rail_number, new_score)
    elif chip.type in Data.CHIP_TYPES_TIME:
        var new_score = stack_scores[chip.rail_number] * chip.score
        _set_stack_score(chip.rail_number, new_score)


func _on_chip_fallen(chip: Chip) -> void:
    #print("_on_chip_fallen() type: %s, price: %s" % [chip.type, chip.price])
    # ストレージの Chip を元に戻す
    for chip_storage: ChipStorage in _chip_storages_parent.get_children():
        if chip.price == chip_storage.price:
            var new_chip: Chip = _chip_scene.instantiate()
            new_chip.type = chip.type
            new_chip.price = chip.price
            chip_storage.chips_parent.add_child(new_chip)


func _on_button_play_pressed() -> void:
    print("[Main] play.")
    # TODO


func _on_button_stop_pressed() -> void:
    print("[Main] stop.")
    # TODO


func _set_stack_score(rail_number: int, score: int) -> void:
    var before = stack_scores[rail_number]
    stack_scores[rail_number] = score
    var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
    var label: Label = _label_line_score_parent.get_child(rail_number)
    tween.tween_method(func(v): label.text = Util.format_number_with_commas(v), before, stack_scores[rail_number], SCORE_CHANGE_DURATION)

    var sum := 0
    for stack_score in stack_scores:
        sum += stack_score
    stack_scores_sum = sum


func _reset_stack_scores() -> void:
    var rail_number := 0
    for stack_score in stack_scores:
        _set_stack_score(rail_number, 0)
        rail_number += 1
    stack_scores_sum = 0


func _init_rails() -> void:
    for rail_number in Data.RAIL_DATA.keys():
        print("_init_rails() rail_number: %s" % [rail_number])
        var data = Data.RAIL_DATA[rail_number]
        var new_rail: Rail = _rail_scene.instantiate()
        new_rail.position = Vector2(640, 360)
        new_rail.rail_number = rail_number
        new_rail.circle_radius = data[0]
        new_rail.rotate_speed = data[1]
        new_rail.holder_count = data[2]
        objects_parent.add_child(new_rail)


func _init_chip_storages() -> void:
    for price in Data.CHIP_STORAGE_DATA.keys():
        #print("_init_chip_storages() price: %s" % [price])
        var chip_storage: ChipStorage = _chip_storage_scene.instantiate()
        chip_storage.price = price
        for data in Data.CHIP_STORAGE_DATA[price]:
            for i in data[1]:
                var new_chip: Chip = _chip_scene.instantiate()
                new_chip.type = data[0]
                new_chip.price = price
                chip_storage.chips_parent.add_child(new_chip)
        _chip_storages_parent.add_child(chip_storage)
        # MUST after chip_storage.chips_parent.add_child()
        chip_storage.is_locked = true


func _try_unlock_storages() -> void:
    for node in _chip_storages_parent.get_children():
        if node is ChipStorage:
            if node.is_locked and node.price <= total_score:
                node.is_locked = false
