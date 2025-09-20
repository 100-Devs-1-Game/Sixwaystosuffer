class_name RaiseOnHover
extends Node

@export var target: Node3D
@export var monitor: Area3D
@export var height: float = 0.1
@export var duration: float = 0.4
@export var use_global_position: bool = true
@export var is_enabled: bool = true

var init_position: Vector3
var tween: Tween

func _ready() -> void:
	init_position = target.global_position if use_global_position else target.position
	monitor.mouse_entered.connect(_on_mouse_entered)
	monitor.mouse_exited.connect(_on_mouse_exited)

func setup_init_position(new_position: Vector3) -> void:
	init_position = new_position

func reset() -> void:
	_stop_tween_if_needed()
	target.global_position = init_position

func _on_mouse_entered() -> void:
	if not is_enabled:
		return
	
	_stop_tween_if_needed()
	tween = create_tween()
	var property := "global_position"  if use_global_position else "position"
	tween.tween_property(target, property, init_position + Vector3.UP * height, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func _on_mouse_exited() -> void:
	if not is_enabled:
		return
	
	_stop_tween_if_needed()
	tween = create_tween()
	var property := "global_position"  if use_global_position else "position"
	tween.tween_property(target, property, init_position, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func _stop_tween_if_needed() -> void:
	if not tween:
		return
	
	tween.kill()
	tween = null
