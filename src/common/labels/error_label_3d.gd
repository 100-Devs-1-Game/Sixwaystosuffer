class_name ErrorLabel3D
extends Node

@export var label: Label3D

@export var error_color: Color = Color.RED
@export var outline_color: Color = Color.DARK_RED

var base_color: Color
var base_outline: Color

var _tween: Tween

func _ready() -> void:
	base_color = label.modulate
	base_outline = label.outline_modulate

func alert() -> void:
	if _tween != null and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(label, "modulate", error_color, 0.2)
	_tween.parallel().tween_property(label, "outline_modulate", outline_color, 0.1)
	_tween.tween_interval(0.3)
	_tween.tween_property(label, "modulate", base_color, 0.2)
	_tween.parallel().tween_property(label, "outline_modulate", base_outline, 0.1)
