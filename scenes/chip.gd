class_name Chip
extends Control

@export var score := 1

@export var area: Area2D
@export var label: Label


func _ready() -> void:
    area.area_entered.connect(_on_area_entered)
    area.area_exited.connect(_on_area_exited)
    refresh_view()


func _process(delta: float) -> void:
    label.rotation = get_global_transform().get_rotation() * -1


func refresh_view() -> void:
    label.text = "+%s" % [score]


func _on_area_entered(other_area: Area2D) -> void:
    var other_area_parent = other_area.get_parent()
    if other_area_parent is ChipSensor:
        _on_entered_chip_sensor(other_area_parent)
    elif other_area_parent is ChipHolder:
        _on_entered_chip_holder(other_area_parent)


func _on_area_exited(other_area: Area2D) -> void:
    var other_area_parent = other_area.get_parent()
    if other_area_parent is ChipSensor:
        _on_exited_chip_sensor(other_area_parent)
    elif other_area_parent is ChipHolder:
        _on_exited_chip_holder(other_area_parent)


func _on_entered_chip_sensor(sensor: ChipSensor) -> void:
    GlobalSignal.chip_entered_chip_sensor.emit(self)
    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
    tween.tween_property(self, "modulate", Color.RED, 0.0)
    tween.tween_property(self, "modulate", Color.WHITE, 1.0)


func _on_entered_chip_holder(holder: ChipHolder) -> void:
    pass


func _on_exited_chip_sensor(sensor: ChipSensor) -> void:
    pass


func _on_exited_chip_holder(holder: ChipHolder) -> void:
    pass
