class_name PlayerHead
extends Node3D

@export var mouse_sensitivity: float = 0.002

@export var vertical_limit_angle: float = 15
@export var horizontal_limit_angle: float = 15

@export var smooth_speed: float = 10.0

var target_rotation := Vector2.ZERO
var current_rotation := Vector2.ZERO

func _input(event: InputEvent) -> void:
	return # 
	
	if not event is InputEventMouseMotion:
		return
	
	var motion := event as InputEventMouseMotion
	target_rotation.x -= motion.relative.x * mouse_sensitivity
	target_rotation.y -= motion.relative.y * mouse_sensitivity
	
	var clamp_angle := Vector2(deg_to_rad(horizontal_limit_angle), deg_to_rad(vertical_limit_angle))
	target_rotation = target_rotation.clamp(-clamp_angle, clamp_angle)

func _physics_process(delta: float) -> void:
	current_rotation = current_rotation.lerp(target_rotation, smooth_speed * delta)
	rotation.y = current_rotation.x
	rotation.x = current_rotation.y
