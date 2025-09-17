class_name BoxSpawner
extends Node

@export var box_1: Node3D
@export var box_2: Node3D
@export var box_3: Node3D

@export var box_open_position: float = 4.2
@export var duration: float = 1.0

var is_box_3_blocked: bool
var is_opened: bool

var _tween: Tween
var _base_box_position: float

func _ready() -> void:
	_base_box_position = box_1.position.z

func swith() -> void:
	if is_opened:
		close()
	else:
		open()

func open() -> void:
	_stop_tween_if_needed()
	_tween = _create_box_tween(box_open_position, duration, Tween.EASE_OUT)
	is_opened = true

func close() -> void:
	_stop_tween_if_needed()
	_tween = _create_box_tween(_base_box_position, duration, Tween.EASE_IN)
	is_opened = false

func _create_box_tween(target_position: float, duration: float, easing: Tween.EaseType) -> Tween:
	var tween := create_tween()
	tween.tween_property(box_1, "position:z", target_position, duration).set_trans(Tween.TRANS_BACK).set_ease(easing)
	tween.parallel().tween_property(box_2, "position:z", target_position, duration).set_trans(Tween.TRANS_BACK).set_ease(easing)
	
	if not is_box_3_blocked:
		tween.parallel().tween_property(box_3, "position:z", target_position, duration).set_trans(Tween.TRANS_BACK).set_ease(easing)
	return tween

func _stop_tween_if_needed() -> void:
	if _tween != null and _tween.is_running():
		_tween.kill()
		_tween = null
