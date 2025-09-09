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
    draw_ring(circle_radius, 64, Color.WHITE, -1.0)


# ref. https://www.reddit.com/r/godot/comments/3ktq39/drawing_empty_circles_and_curves/
func draw_ring(radius: float, resolution: int, color: Color, width: float, offset: Vector2 = Vector2.ZERO) -> void:
    var increments := 2 * PI / resolution
    var rad := 0.0
    var to := Vector2.ZERO
    var from := Vector2(cos(rad) * radius, sin(rad) * radius)
    for i in resolution:
        rad = increments * (i + 1)
        to = Vector2(cos(rad) * radius, sin(rad) * radius)
        draw_line(offset + from, offset + to, color, width)
        from = to


func start_rotate() -> void:
    # 320 が1周する間に 80 は4周
    var duration := 320 / circle_radius

    _tween_rotate = create_tween()
    _tween_rotate.set_loops()
    _tween_rotate.tween_property(self, "rotation_degrees", 360.0, 320 / circle_radius)
    _tween_rotate.tween_callback(func(): rotation_degrees = 0.0)
