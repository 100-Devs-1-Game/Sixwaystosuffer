class_name ShopBox
extends Node3D

@export var open_offset: float = 0.42
@export var switch_duration: float = 0.25
@export var is_blocked: bool = false

var base_offset: float
var is_opened: bool

var _tween: Tween

func _ready() -> void:
	base_offset = position.z

func open() -> void:
	_stop_tween_if_needed()
	
	if is_blocked:
		return
	
	_tween = _create_box_tween(open_offset, switch_duration, Tween.EASE_OUT)
	is_opened = true

func close() -> void:
	_stop_tween_if_needed()
	
	if is_blocked:
		return
	
	_tween = _create_box_tween(base_offset, switch_duration, Tween.EASE_IN)
	is_opened = false

func _create_box_tween(target_position: float, duration: float, easing: Tween.EaseType) -> Tween:
	var tween := create_tween()
	tween.tween_property(self, "position:z", target_position, duration).set_trans(Tween.TRANS_BACK).set_ease(easing)
	return tween

func _stop_tween_if_needed() -> void:
	if _tween != null and _tween.is_running():
		_tween.kill()
		_tween = null
