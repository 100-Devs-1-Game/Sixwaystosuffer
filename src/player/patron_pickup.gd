class_name PatronPickup
extends Node

@export var player: Player

@export var drum_target_point: Node3D
@export var revolver: Revolver

@export var chamber_node: Node3D
@export var tremor_animation: AnimationPlayer

@export var trajectories_node: Node3D
@export var process_audio: AudioStreamPlayer

var tween: Tween
var follow: PathFollow3D
var trajectories: Array[Path3D]

var is_working: bool
var previous_trajectory_index: int
var table_patrons: PlayerPatrons

func _ready() -> void:
	table_patrons = player.patrons
	table_patrons.clicked.connect(load_patron)
	
	follow = PathFollow3D.new()
	follow.loop = false
	add_child(follow)
	
	for child in trajectories_node.get_children():
		if child is Path3D:
			trajectories.append(child)

func place_patron_on_random_path(target: Patron, progress: float = 1.0) -> void:
	previous_trajectory_index = (previous_trajectory_index + 1) % trajectories.size()
	var path: Path3D = trajectories[previous_trajectory_index]
	follow.reparent(path, false)
	follow.progress_ratio = progress
	var position_on_path := target.on_table_position - path.global_position
	path.curve.set_point_position(2, position_on_path)
	target.reparent(follow)
	
	process_audio.play()

func load_patron(target: Patron) -> void:
	if tween != null and tween.is_running():
		return
	
	if not revolver.can_load_on_current_point():
		tremor_animation.play("invalid_action")
		return
	
	is_working = true
	target.disable()
	table_patrons.remove(target)
	place_patron_on_random_path(target, 1.0)
	
	tween = create_tween()
	tween.tween_property(follow, "progress_ratio", 0.0, 0.6)
	var chamber_point := revolver.get_current_chamber_position()
	tween.parallel().tween_property(target, "global_rotation", drum_target_point.global_rotation, 0.6)
	tween.tween_callback(_on_start_loading_to_chamber.bind(target))
	tween.tween_callback(_on_setup_target_point.bind(target, chamber_point))

func unload_patron(target: Patron) -> void:
	if target == null:
		return
	
	if tween != null and tween.is_running():
		return
	
	if revolver.get_hovered_patron() == null:
		return
	
	is_working = true
	place_patron_on_random_path(target, 0.0)
	revolver.unload_patron(target)
	
	tween = create_tween()
	tween.tween_property(follow, "progress_ratio", 1.0, 0.6)
	tween.parallel().tween_property(target, "global_rotation", target.on_table_rotation, 0.6)
	tween.tween_callback(_on_unloaded.bind(target))

func _on_unloaded(target: Patron) -> void:
	is_working = false
	target.reparent(table_patrons)
	table_patrons.return_patron(target)
	target.global_position = target.on_table_position
	target.enable()

func _on_start_loading_to_chamber(patron: Patron) -> void:
	patron.reparent(chamber_node)
	revolver.load_patron(patron)

func _on_setup_target_point(patron: Patron, point: Node3D) -> void:
	patron.global_position = point.global_position
	is_working = false

func enable_patrons_interaction() -> void:
	table_patrons.enable_patrons_interaction()

func disable_patrons_interaction() -> void:
	table_patrons.disable_patrons_interaction()
