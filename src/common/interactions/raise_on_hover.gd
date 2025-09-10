class_name RaiseOnHover
extends Node

@export var target: Node3D
@export var monitor: Area3D
@export var height: float = 0.1
@export var duration: float = 0.4

var init_position: Vector3
var tween: Tween

func _ready() -> void:
	reset()
	monitor.mouse_entered.connect(_on_mouse_entered)
	monitor.mouse_exited.connect(_on_mouse_exited)

func reset() -> void:
	_stop_tween_if_needed()
	target.position = init_position

func _on_mouse_entered() -> void:
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(target, "position", init_position + Vector3.UP * height, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func _on_mouse_exited() -> void:
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(target, "position", init_position, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func _stop_tween_if_needed() -> void:
	if not tween:
		return
	
	tween.kill()
	tween = null
