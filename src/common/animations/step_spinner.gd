class_name StepSpinner
extends Node

@export var target: Node3D
@export var angle_for_step: float
@export var duration_per_step: float

var _tween: Tween

func spin(steps: int) -> void:
	if _tween != null and _tween.is_running():
		_tween.kill()
		return
	
	_tween = create_tween()
	var duration := duration_per_step * steps
	_tween.tween_property(target, "rotation:x", target.rotation.x + deg_to_rad(angle_for_step * steps), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
