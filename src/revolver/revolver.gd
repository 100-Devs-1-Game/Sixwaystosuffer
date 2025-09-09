class_name Revolver
extends Node3D

const MAX_BULLETS_IN_CHAMBER: int = 6

@export var drum: Node3D
@export var chamber_rotate_angle: float = 60.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_position_hover: Node3D = %"Current Position Hover"

@onready var chamber: MeshInstance3D = $"Revolver Hand/revolver/revolver_chamber"

var _chamber_position: Array[Node3D]
var _partons: Array[Patron]
var _current_index: int = 0
var _tween: Tween

func _ready() -> void:
	for child in chamber.get_children():
		_chamber_position.append(child)
	_partons.resize(MAX_BULLETS_IN_CHAMBER)

func get_current_chamber_position() -> Node3D:
	return _chamber_position[_current_index]

func load_patron(patron: Patron) -> void:
	_partons[_current_index] = patron
	animation_player.play("load")

func spin_down() -> void:
	if _tween != null and _tween.is_running():
		return
	
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:z", drum.rotation.z - deg_to_rad(chamber_rotate_angle), 0.25).set_trans(Tween.TRANS_CUBIC)
	_current_index = (_current_index - 1) % MAX_BULLETS_IN_CHAMBER

func spin_up() -> void:
	if _tween != null and _tween.is_running():
		return
	
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:z", drum.rotation.z + deg_to_rad(chamber_rotate_angle), 0.25).set_trans(Tween.TRANS_CUBIC)
	_current_index = (_current_index + 1) % MAX_BULLETS_IN_CHAMBER

func fire() -> void:
	animation_player.play("fire")
	spin_down()

func open_drum() -> void:
	animation_player.play("drum_open")

func close_drum() -> void:
	animation_player.play("drum_close")
