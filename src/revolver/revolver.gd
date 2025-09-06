class_name Revolver
extends Node3D

@export var drum: Node3D
@export var chamber_rotate_angle: float = 60.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_position_hover: Node3D = %"Current Position Hover"

var _tween: Tween

func get_current_drum_position() -> Node3D:
	return current_position_hover

func spin_down() -> void:
	if _tween != null and _tween.is_running():
		return
	
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:z", drum.rotation.z - deg_to_rad(chamber_rotate_angle), 0.25).set_trans(Tween.TRANS_BOUNCE)

func spin_up() -> void:
	if _tween != null and _tween.is_running():
		return
	
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:z", drum.rotation.z + deg_to_rad(chamber_rotate_angle), 0.25).set_trans(Tween.TRANS_BOUNCE)

func fire() -> void:
	animation_player.play("fire")

func open_drum() -> void:
	animation_player.play("drum_open")

func close_drum() -> void:
	animation_player.play("drum_close")
