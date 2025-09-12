class_name Rail
extends Control

const CIRCLE_COLOR := Color(1.0, 1.0, 1.0)
const LINE_COLOR := Color(0.4, 0.4, 0.4)

@export var circle_radius := 320.0 # px
@export var rotate_speed := 1.0 # rotates / sec
@export var holder_count := 4

@export var chips_parent: Control

@export var chip_scene: PackedScene

var _tween_rotate: Tween


func _ready() -> void:
    set_holders()
    start_rotate()


func _draw():
    draw_line(Vector2(0, circle_radius * -1), Vector2(1280, circle_radius * -1), LINE_COLOR)
    draw_circle(Vector2.ZERO, circle_radius, CIRCLE_COLOR, false)


func set_holders() -> void:
    for i in holder_count:
        var rad := PI * 2 / holder_count * (i + 1)
        var pos := Vector2(cos(rad) * circle_radius, sin(rad) * circle_radius)
        var chip: Chip = chip_scene.instantiate() # debug
        chip.position = pos - chip.custom_minimum_size / 2 # debug
        chips_parent.add_child(chip)


func start_rotate() -> void:
    var duration := 1.0 / rotate_speed
    _tween_rotate = create_tween()
    _tween_rotate.set_loops()
    _tween_rotate.tween_property(chips_parent, "rotation_degrees", 360.0, duration)
    _tween_rotate.tween_property(chips_parent, "rotation_degrees", 0.0, 0)
