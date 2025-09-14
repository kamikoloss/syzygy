class_name Chip
extends Control

signal hovered # (on: bool)
signal dragged # (on: bool)

const OUTLINE_COLOR_HOVER := Color.WHITE
const OUTLINE_COLOR_CAN_RIDE := Color.GREEN
const OUTLINE_COLOR_CAN_NOT_RIDE := Color.RED

@export var type := ChipData.Type.NONE:
    set(v):
        type = v
        refresh_view()

@export var area: Area2D

@export var _texture_rect_main: TextureRect
@export var _texture_rect_outline: TextureRect
@export var _label_main: Label
@export var _label_price: Label

var price := 0
var score := 0
var rail_number := 0
var is_locked := false
var is_hovering := false
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
            if type != ChipData.Type.NONE:
                dragged.emit(event.pressed)
                _drag(event.pressed)


func refresh_view() -> void:
    # Type
    var data = ChipData.DATA[type] # [ <Label>, <Color>, <Price>, <Score> ]
    _label_main.text = data[0] # "+%s" % [score]
    _texture_rect_main.modulate = data[1]
    price = data[2]
    _label_price.text = "%s" % [data[2]]
    score = data[3]

    # Locked
    _label_price.visible = is_locked

    # Outline
    _texture_rect_outline.visible = is_hovering or is_dragging
    if is_dragging:
        if is_overlapping and _overrapping_holder and not _overrapping_holder.is_placed:
            _texture_rect_outline.modulate = OUTLINE_COLOR_CAN_RIDE
        else:
            _texture_rect_outline.modulate = OUTLINE_COLOR_CAN_NOT_RIDE
    else:
        _texture_rect_outline.modulate = OUTLINE_COLOR_HOVER


func flash() -> void:
    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
    tween.tween_property(self, "modulate", Color.RED, 0.0)
    tween.tween_property(self, "modulate", Color.WHITE, 1.0)


func _on_mouse_entered() -> void:
    is_hovering = true
    hovered.emit(true)
    refresh_view()


func _on_mouse_exited() -> void:
    is_hovering = false
    hovered.emit(false)
    refresh_view()


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


func _on_entered_chip_sensor(chip_sensor: ChipSensor) -> void:
    GlobalSignal.chip_sensed.emit(self)
    flash()


func _on_entered_chip_holder(chip_holder: ChipHolder) -> void:
    is_overlapping = true
    chip_holder.is_overlapped = true
    _overrapping_holder = chip_holder
    refresh_view()


func _on_exited_chip_sensor(sensor: ChipSensor) -> void:
    pass


func _on_exited_chip_holder(holder: ChipHolder) -> void:
    is_overlapping = false
    holder.is_overlapped = false
    refresh_view()


func _drag(on: bool) -> void:
    #print("_on_dragged(on: %s)" % [on])
    top_level = on
    rail_number = -1
    is_dragging = on
    refresh_view()

    if _placed_holder:
        _placed_holder.is_placed = false

    if on:
        print("[Chip %s] drag and..." % [get_instance_id()])
        pass
    else:
        # ChipHolder に配置する
        if is_overlapping and _overrapping_holder and not _overrapping_holder.is_placed:
            print("[Chip %s] drag and place." % [get_instance_id()])
            _placed_holder = _overrapping_holder
            _placed_holder.is_placed = true
            reparent(_placed_holder.chips_parent)
            position = Vector2.ZERO - _center_offset # NOTE: reparent() の後に書くこと
            rail_number = _placed_holder.rail_number
            GlobalSignal.chip_placed.emit(self, _placed_holder)
        # ストレージに戻る
        else:
            print("[Chip %s] drag and fall." % [get_instance_id()])
            GlobalSignal.chip_fallen.emit(self)
            # TODO: 枠
            queue_free()
