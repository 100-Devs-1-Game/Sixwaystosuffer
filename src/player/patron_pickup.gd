class_name PatronPickup
extends Node

@export var target_point: Node3D
@export var drum_target_point: Node3D
@export var revolver: Revolver

@export var base_path: Path3D
@export var path_follow: PathFollow3D
@export var target_chamber: Node3D

@export var chamber_node: Node3D

func load_patron(target: Patron) -> void:
	path_follow.progress_ratio = 1
	target.reparent(path_follow)
	target.position = Vector3.ZERO
	
	var tween := create_tween()
	tween.tween_property(path_follow, "progress_ratio", 0.0, 1.0)
	var chamber_point := revolver.get_current_chamber_position()
	tween.parallel().tween_property(target, "global_rotation", drum_target_point.global_rotation, 1.0)
	tween.tween_callback(_on_start_loading_to_chamber.bind(target))
	tween.tween_property(target, "global_position", chamber_point.global_position, 0.3)

func _on_start_loading_to_chamber(patron: Patron) -> void:
	patron.reparent(chamber_node)
	revolver.load_patron(patron)
