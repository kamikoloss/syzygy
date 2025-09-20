class_name Chip
extends Control

const OUTLINE_COLOR_HOVER := Color.WHITE
const OUTLINE_COLOR_CAN_RIDE := Color.GREEN
const OUTLINE_COLOR_CAN_NOT_RIDE := Color.RED

@export var type := Data.ChipType.NONE:
    set(v):
        type = v
        _refresh_view()

@export var _area: Area2D

@export var _texture_rect_main: TextureRect
@export var _texture_rect_outline: TextureRect
@export var _texture_rect_flash: TextureRect
@export var _label_main: Label

var rail_number := -1
var price := -1
var score := -1
var is_locked := false
var is_hovering := false
var is_dragging := false
var is_placed := false
var center_offset: Vector2

var _overrapping_holders: Array[ChipHolder]
var _placed_holder: ChipHolder


func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    _area.area_entered.connect(_on_area_entered)
    _area.area_exited.connect(_on_area_exited)

    center_offset = custom_minimum_size / 2.0
    _refresh_view()
    if type == Data.ChipType.CLEAR:
        _rainbow()

    _texture_rect_flash.self_modulate = Color.TRANSPARENT
    #print("[Chip %s] ready. (type: %s, price: %s)" % [get_instance_id(), type, price])


func _process(_delta: float) -> void:
    _label_main.rotation = get_global_transform().get_rotation() * -1
    if is_dragging:
        global_position = get_global_mouse_position() - center_offset


func _gui_input(event: InputEvent) -> void:
    if is_locked:
        return
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if type != Data.ChipType.NONE:
                _drag(event.pressed)


func _on_mouse_entered() -> void:
    if is_locked:
        return
    is_hovering = true
    _refresh_view()


func _on_mouse_exited() -> void:
    if is_locked:
        return
    is_hovering = false
    _refresh_view()


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
    if not is_placed:
        return
    GlobalSignal.chip_sensed.emit(self)
    _flash()


func _on_entered_chip_holder(chip_holder: ChipHolder) -> void:
    chip_holder.is_overlapped = true

    # apeend to _overrapping_holders
    if not chip_holder.is_placed:
        #print("_on_entered_chip_holder() id: %s" % [chip_holder.get_instance_id()])
        _overrapping_holders.append(chip_holder)
        #print("_on_entered_chip_holder() size: %s" % [_overrapping_holders.size()])

    _refresh_view()


func _on_exited_chip_sensor(sensor: ChipSensor) -> void:
    pass


func _on_exited_chip_holder(holder: ChipHolder) -> void:
    holder.is_overlapped = false

    # remove from _overrapping_holders
    var index := 0
    for node in _overrapping_holders:
        if node == holder:
            #print("_on_exited_chip_sensor() id: %s" % [node.get_instance_id()])
            _overrapping_holders.remove_at(index)
            #print("_on_exited_chip_holder() size: %s" % [_overrapping_holders.size()])
        index += 1

    _refresh_view()


func _drag(on: bool) -> void:
    #print("_on_dragged(on: %s)" % [on])
    top_level = on
    is_dragging = on

    if _placed_holder:
        _placed_holder.is_placed = false

    if on:
        print("[Chip %s] drag and... (type: %s, price: %s)" % [get_instance_id(), type, price])
        rail_number = -1
        is_placed = false
        _overrapping_holders.clear()
        _refresh_view()
    else:
        # ChipHolder に配置する
        var holder: ChipHolder = _overrapping_holders.get(_overrapping_holders.size() - 1)
        #print("_drag() size: %s, last holder: %s" % [_overrapping_holders.size(), holder])
        if holder and not holder.is_placed:
            print("[Chip %s] drag and place." % [get_instance_id()])
            is_placed = true
            _placed_holder = holder
            _placed_holder.is_placed = true
            reparent(_placed_holder.chips_parent)
            position = Vector2.ZERO - center_offset # NOTE: MUST after reparent()
            rail_number = _placed_holder.rail_number
            GlobalSignal.chip_placed.emit(self, _placed_holder)
        # ストレージに戻る
        else:
            print("[Chip %s] drag and fall." % [get_instance_id()])
            GlobalSignal.chip_fallen.emit(self)
            queue_free()


func _refresh_view() -> void:
    # Type
    var data = Data.CHIP_DATA[type]
    _label_main.text = data[0] # "+%s" % [score]
    if type != Data.ChipType.CLEAR:
        _texture_rect_main.self_modulate = data[1]
    score = data[2]

    # Outline
    _texture_rect_outline.visible = is_hovering or is_dragging
    if is_dragging:
        var holder: ChipHolder = _overrapping_holders.duplicate().pop_back()
        #print("_refresh_view() holder: %s" % [holder])
        if holder and not holder.is_placed:
            _texture_rect_outline.modulate = OUTLINE_COLOR_CAN_RIDE
        else:
            _texture_rect_outline.modulate = OUTLINE_COLOR_CAN_NOT_RIDE
    else:
        _texture_rect_outline.modulate = OUTLINE_COLOR_HOVER


func _flash() -> void:
    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
    tween.tween_property(_texture_rect_flash, "self_modulate", Color.WHITE, 0.0)
    tween.tween_interval(0.1)
    tween.tween_property(_texture_rect_flash, "self_modulate", Color.TRANSPARENT, 1.0)


func _rainbow() -> void:
    var tween := create_tween()
    tween.set_loops()
    tween.tween_method(func(v): _texture_rect_main.self_modulate = Color.from_hsv(v, 1.0, 1.0), 0.0, 1.0, 2.0)
