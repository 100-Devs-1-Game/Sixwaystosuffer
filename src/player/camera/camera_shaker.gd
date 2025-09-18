class_name CameraShaker
extends Node

@export var camera: Camera3D

@export var shake_amount: Curve
@export var shake_duration: Curve
@export var shake_range: Vector2i

func shake(strength: float = 0.1):
	for property in ["h_offset", "v_offset"]:
		shake_value(property, get_random_steps(shake_range), strength)

func get_random_steps(random_range: Vector2i) -> int:
	return randi_range(random_range.x, random_range.y)

func shake_value(property_name: String, step_count: int, vector: float = 1.0):
	var t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	for step in step_count:
		var progress: float = step / float(step_count - 1)
		var inv: int = step % 2
		var v: float = vector if bool(inv) else -vector
		t.tween_property(camera, property_name, v * shake_amount.sample(progress), shake_duration.sample(progress) * 0.2)
