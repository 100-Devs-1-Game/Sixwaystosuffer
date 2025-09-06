class_name PatronPickup
extends Node

@export var target_point: Node3D
@export var revolver: Revolver

func _on_patron_picked(patron: Patron) -> void:
	patron.get_parent().remove_child(patron)
	revolver.drum.add_child(patron)
	_animate_bullet_to_drum(patron, revolver.get_current_drum_position())

func _animate_bullet_to_drum(patron: Patron, target_position: Node3D) -> void:
	var tween := create_tween()
	tween.tween_method(
		_update_bullet_position.bind(patron.position, target_position, patron), 
		0.0, 
		1.0, 
		0.5)

func _update_bullet_position(
	progress: float,
	start_position: Vector3,
	target: Node3D,
	patron: Patron) -> void:
	
	var cp1 = start_position + Vector3.UP / 4 + Vector3.LEFT / 4
	var cp2 = target.global_position + Vector3.LEFT / 4 + Vector3.BACK / 4
	
	var position = start_position * pow(1 - progress, 3) + \
	cp1 * 3 * pow(1 - progress, 2) * progress + \
	cp2 * 3 * (1 - progress) * pow(progress, 2) + \
	target.global_position * pow(progress, 3) 
	
	patron.global_position = position
	patron.global_rotation = target.global_rotation
