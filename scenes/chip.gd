class_name Chip
extends Control

signal hovered # (on: bool)
signal dragged # (on: bool)

const OUTLINE_COLOR_CAN_RIDE := Color.GREEN
const OUTLINE_COLOR_CAN_NOT_RIDE := Color.RED

@export var score := 1

@export var area: Area2D

@export var _texture_rect_main: TextureRect
@export var _texture_rect_outline: TextureRect
@export var _label_main: Label
@export var _label_price: Label

var is_dragging := false
var is_overlapping := false

var _center_offset: Vector2
var _drag_start_global_position: Vector2
var _overrapping_holder: ChipHolder
var _placed_holder: ChipHolder


func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    area.area_entered.connect(_on_area_entered)
    area.area_exited.connect(_on_area_exited)

    _center_offset = custom_minimum_size / 2.0
    refresh_view()


func _process(delta: float) -> void:
    _label_main.rotation = get_global_transform().get_rotation() * -1
    if is_dragging:
        global_position = get_global_mouse_position() - _center_offset


func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            dragged.emit(event.pressed)
            _drag(event.pressed)


func refresh_view() -> void:
    _texture_rect_outline.visible = is_dragging
    if is_overlapping and _overrapping_holder and not _overrapping_holder.is_overlapped:
        _texture_rect_outline.modulate = OUTLINE_COLOR_CAN_RIDE
    else:
        _texture_rect_outline.modulate = OUTLINE_COLOR_CAN_NOT_RIDE

    _label_main.text = "+%s" % [score]


func flash() -> void:
    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
    tween.tween_property(self, "modulate", Color.RED, 0.0)
    tween.tween_property(self, "modulate", Color.WHITE, 1.0)


func _on_mouse_entered() -> void:
    hovered.emit(true)


func _on_mouse_exited() -> void:
    hovered.emit(false)


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
    flash()


func _on_entered_chip_holder(holder: ChipHolder) -> void:
    is_overlapping = true
    _overrapping_holder = holder
    refresh_view()


func _on_exited_chip_sensor(sensor: ChipSensor) -> void:
    pass


func _on_exited_chip_holder(holder: ChipHolder) -> void:
    is_overlapping = false
    refresh_view()


func _drag(on: bool) -> void:
    #print("_on_dragged(on: %s)" % [on])
    top_level = on
    is_dragging = on
    refresh_view()

    if _placed_holder:
        _placed_holder.is_overlapped = false

    if on:
        print("[Chip %s] drag and..." % [get_instance_id()])
        pass
    else:
        # ChipHolder に載る
        if is_overlapping:
            print("[Chip %s] drag and ride." % [get_instance_id()])
            _placed_holder = _overrapping_holder
            _overrapping_holder.is_overlapped = true
            reparent(_placed_holder.chips_parent)
            position = Vector2.ZERO - _center_offset # NOTE: reparent() の後に書くこと
            GlobalSignal.chip_ridden.emit(self, _placed_holder)
        # 元に戻る
        # Main 側で再生成する
        else:
            print("[Chip %s] drag and fall." % [get_instance_id()])
            GlobalSignal.chip_fallen.emit(self)
            queue_free()
