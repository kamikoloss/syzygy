class_name Rail
extends Control

@export var circle_radius := 320.0 # px
@export var rotate_speed := 1.0 # rotates / sec
@export var holder_count := 4

@export var chip_scene: PackedScene

var _tween_rotate: Tween


func _ready() -> void:
    set_holders()
    start_rotate()


func _draw():
    draw_circle(Vector2.ZERO, circle_radius, Color.WHITE, false, -1.0, false)


func set_holders() -> void:
    for i in holder_count:
        var rad := PI * 2 / holder_count * (i + 1)
        var pos := Vector2(cos(rad) * circle_radius, sin(rad) * circle_radius)
        var chip: Chip = chip_scene.instantiate()
        chip.position = pos
        add_child(chip)


func start_rotate() -> void:
    var duration := 1.0 / rotate_speed
    _tween_rotate = create_tween()
    _tween_rotate.set_loops()
    _tween_rotate.tween_property(self, "rotation_degrees", 360.0, duration)
    _tween_rotate.tween_callback(func(): rotation_degrees = 0.0)
