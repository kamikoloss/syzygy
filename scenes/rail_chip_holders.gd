extends Control

const POINTS := [
    Vector2(40, 0),
    Vector2(20, -10),
    Vector2(20, 10),
    Vector2(40, 0),
]


func _draw():
    draw_polyline(POINTS, Rail.LINE_COLOR_PRIMARY)
