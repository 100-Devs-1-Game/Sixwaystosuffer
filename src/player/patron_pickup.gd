class_name PatronPickup
extends Node

@export var target_point: Node3D
@export var drum_target_point: Node3D
@export var revolver: Revolver

@export var chamber_node: Node3D

@export var patrons_node: Node3D
@export var tremor_animation: AnimationPlayer

@export var trajectories_node: Node3D
@export var process_audio: AudioStreamPlayer

var tween: Tween
var follow: PathFollow3D
var trajectories: Array[Path3D]

var is_working: bool

func _ready() -> void:
	follow = PathFollow3D.new()
	add_child(follow)
	
	for child in trajectories_node.get_children():
		if child is Path3D:
			trajectories.append(child)

func load_patron(target: Patron) -> void:
	if tween != null and tween.is_running():
		return
	
	if not revolver.can_load_on_current_point():
		tremor_animation.play("invalid_action")
		return
	
	target.disable()
	is_working = true
	
	var path: Path3D = trajectories.pick_random()
	follow.reparent(path, false)
	follow.progress_ratio = 1
	
	var position_on_path := target.global_position - path.global_position
	path.curve.set_point_position(2, position_on_path)
	target.reparent(follow)
	
	process_audio.play()
	
	tween = create_tween()
	tween.tween_property(follow, "progress_ratio", 0.0, 0.6)
	var chamber_point := revolver.get_current_chamber_position()
	tween.parallel().tween_property(target, "global_rotation", drum_target_point.global_rotation, 0.6)
	tween.tween_callback(_on_start_loading_to_chamber.bind(target))
	#tween.tween_property(target, "global_position", chamber_point.global_position, 0.3)
	tween.tween_callback(_on_setup_target_point.bind(target, chamber_point))

func _on_start_loading_to_chamber(patron: Patron) -> void:
	patron.reparent(chamber_node)
	revolver.load_patron(patron)

func _on_setup_target_point(patron: Patron, target_point: Node3D) -> void:
	patron.global_position = target_point.global_position
	is_working = false

func enable_patrons_interaction() -> void:
	for child in patrons_node.get_children():
		if child is Patron:
			child.enable()
			child.clicked.connect(load_patron)

func disable_patrons_interaction() -> void:
	for child in patrons_node.get_children():
		if child is Patron:
			child.disable()
			child.clicked.disconnect(load_patron)
