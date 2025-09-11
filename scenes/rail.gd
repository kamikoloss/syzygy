class_name Rail
extends Control

@export var circle_radius := 320.0
@export var chip_scene: PackedScene

var _tween_rotate: Tween


func _ready() -> void:
    start_rotate()

    # debug
    for vec in [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]:
        var chip: Chip = chip_scene.instantiate()
        chip.position = vec * circle_radius
        add_child(chip)


func _draw():
    draw_circle(Vector2.ZERO, circle_radius, Color.WHITE, false, -1.0, false)


func start_rotate() -> void:
    # 320 が1周する間に 80 は4周
    var duration := 320 / circle_radius

    _tween_rotate = create_tween()
    _tween_rotate.set_loops()
    _tween_rotate.tween_property(self, "rotation_degrees", 360.0, 320 / circle_radius)
    _tween_rotate.tween_callback(func(): rotation_degrees = 0.0)
