class_name Rail
extends Control

const RAIL_NUMBER_SUM = 6
const START_STOP_DURATION = 1.0
const CHANGE_SPEED_DURATION = 1.0
const LINE_COLOR_PRIMARY := Color(1.0, 1.0, 1.0)
const LINE_COLOR_SECONDARY := Color(0.4, 0.4, 0.4)
const LINE_COLOR_STACK := Color(0.2, 0.2, 0.2, 1.0)

@export var chip_holders_parent: Control

@export var chip_scene: PackedScene
@export var chip_holder_scene: PackedScene

var rail_number := 0
var circle_radius := 320.0 # px
var rotate_speed_default := 1.0 # rotates / sec
var rotate_speed := 1.0 # rotates / sec
var holder_count := 4


func _ready() -> void:
    if rail_number == RAIL_NUMBER_SUM:
        _init_chips()
    else:
        _init_chip_holders()


func _process(delta: float) -> void:
    chip_holders_parent.rotation_degrees += 360.0 * rotate_speed * delta
    if 360.0 < chip_holders_parent.rotation_degrees:
        chip_holders_parent.rotation_degrees -= 360.0


func _draw():
    draw_line(Vector2(0, circle_radius * -1), Vector2(1280, circle_radius * -1), LINE_COLOR_SECONDARY)
    draw_circle(Vector2.ZERO, circle_radius, LINE_COLOR_PRIMARY, false)


func start_rotate() -> void:
    var tween := create_tween()
    tween.tween_method(func(v): rotate_speed = v, 0.0, rotate_speed_default, START_STOP_DURATION)


func stop_rotate() -> void:
    var tween := create_tween()
    tween.tween_method(func(v): rotate_speed = v, rotate_speed_default, 0.0, START_STOP_DURATION)


func change_speed_rotate(ratio: float) -> void:
    var tween := create_tween()
    tween.tween_method(func(v): rotate_speed = v, rotate_speed_default * ratio, rotate_speed_default, CHANGE_SPEED_DURATION)


func _init_chip_holders() -> void:
    for i in holder_count:
        var rad := PI * 2 / holder_count * (i + 1)
        var pos := Vector2(cos(rad) * circle_radius, sin(rad) * circle_radius)
        var chip_holder: ChipHolder = chip_holder_scene.instantiate()
        chip_holder.position = pos
        chip_holder.rail_number = rail_number
        chip_holders_parent.add_child(chip_holder)
        #print("_init_chip_holders() %s/%s -> %s" % [i, holder_count, pos])


func _init_chips() -> void:
    # ChipType.ACCOUNT
    var chip: Chip = chip_scene.instantiate()
    chip.type = Data.ChipType.ACCOUNT
    chip.is_locked = true
    chip.is_placed = true
    chip_holders_parent.add_child(chip)
    # NOTE: MUST after add_child()
    var rad := PI * 2 / holder_count
    var pos := Vector2(cos(rad) * circle_radius, sin(rad) * circle_radius)
    chip.position = pos - chip.center_offset
