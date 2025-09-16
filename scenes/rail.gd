class_name Rail
extends Control

const RAIL_NUMBER_SUM = 6
const LINE_COLOR_PRIMARY := Color(1.0, 1.0, 1.0)
const LINE_COLOR_SECONDARY := Color(0.4, 0.4, 0.4)
const LINE_COLOR_STACK := Color(0.2, 0.2, 0.2, 1.0)

@export var rail_number := 0
@export var circle_radius := 320.0 # px
@export var rotate_speed := 1.0 # rotates / sec
@export var holder_count := 4

@export var chip_holders_parent: Control

@export var chip_scene: PackedScene
@export var chip_holder_scene: PackedScene

var _tween_rotate: Tween


func _ready() -> void:
    if rail_number == RAIL_NUMBER_SUM:
        _init_chips()
    else:
        _init_chip_holders()

    start_rotate()


func _draw():
    draw_line(Vector2(0, circle_radius * -1), Vector2(1280, circle_radius * -1), LINE_COLOR_SECONDARY)
    draw_circle(Vector2.ZERO, circle_radius, LINE_COLOR_PRIMARY, false)


func start_rotate() -> void:
    var duration := 1.0 / rotate_speed
    _tween_rotate = create_tween()
    _tween_rotate.set_loops()
    _tween_rotate.tween_property(chip_holders_parent, "rotation_degrees", 360.0, duration)
    _tween_rotate.tween_property(chip_holders_parent, "rotation_degrees", 0.0, 0)


func stop_rotate() -> void:
    pass


func _init_chip_holders() -> void:
    for i in holder_count:
        var rad := PI * 2 / holder_count * (i + 1)
        var pos := Vector2(cos(rad) * circle_radius, sin(rad) * circle_radius)
        var chip_holder: ChipHolder = chip_holder_scene.instantiate()
        chip_holder.position = pos
        chip_holder.rail_number = rail_number
        chip_holders_parent.add_child(chip_holder)


func _init_chips() -> void:
    # Type.ACCOUNT
    var chip: Chip = chip_scene.instantiate()
    chip.type = ChipData.Type.ACCOUNT
    chip.is_locked = false
    chip_holders_parent.add_child(chip)
    chip.position = Vector2(0, circle_radius) - chip.center_offset
