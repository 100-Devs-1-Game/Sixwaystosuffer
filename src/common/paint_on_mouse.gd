class_name PaintOnMouse
extends Node

@export var target: Control

@export var normal_color: Color
@export var mouse_color: Color
@export var duration: float = 0.2

var _tween: Tween

func _ready() -> void:
	target.mouse_entered.connect(_on_mouse_entered)
	target.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	_stop_tween_if_needed()
	_tween = create_tween()
	_tween.tween_property(target, "modulate", mouse_color, duration)

func _on_mouse_exited() -> void:
	_stop_tween_if_needed()
	_tween = create_tween()
	_tween.tween_property(target, "modulate", normal_color, duration)

func _stop_tween_if_needed() -> void:
	if _tween != null:
		_tween.kill()
		_tween = null
