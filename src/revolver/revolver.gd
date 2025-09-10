class_name Revolver
extends Node3D

const MAX_BULLETS_IN_CHAMBER: int = 6
const SPIN_CHAMBER_DURATION: float = 0.25
const MAX_SPIN_CHAMBER_DURATION: float = 1.5

@export var drum: Node3D
@export var chamber_rotate_angle: float = 60.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_position_hover: Node3D = %"Current Position Hover"

@onready var chamber: MeshInstance3D = $"Revolver Hand/revolver/revolver_chamber"

@onready var chamber_scrolling_audio_player: AudioStreamPlayer = %"Chamber Scrolling Audio Player"

var _chamber_position: Array[Node3D]
var _partons: Array[Patron]
var _current_index: int = 0
var _tween: Tween

var _random := RandomNumberGenerator.new()

func _ready() -> void:
	for child in chamber.get_children():
		_chamber_position.append(child)
	_partons.resize(MAX_BULLETS_IN_CHAMBER)

func get_current_chamber_position() -> Node3D:
	return _chamber_position[_current_index]

func load_patron(patron: Patron) -> void:
	_partons[_current_index] = patron
	animation_player.play("load")

func has_current_patron() -> bool:
	return _partons[_current_index] != null

func spin_random(min: int = 7, max: int = 21) -> void:
	var offset := _random.randi_range(min, max)
	spin(offset)

func spin_down() -> void:
	spin(-1)

func spin_up() -> void:
	spin(1)

func spin(count: int) -> void:
	if _tween != null and _tween.is_running():
		return
	
	var duration := minf(SPIN_CHAMBER_DURATION * count, MAX_SPIN_CHAMBER_DURATION)
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:z", drum.rotation.z + deg_to_rad(chamber_rotate_angle * count), duration).set_trans(Tween.TRANS_CUBIC)
	
	_current_index = (_current_index + count) % MAX_BULLETS_IN_CHAMBER
	
	chamber_scrolling_audio_player.play()

func fire() -> void:
	spin_down()
	animation_player.play(_get_fire_animation_name())

func _get_fire_animation_name() -> String:
	return &"fire" if has_current_patron() else &"fire_empty"

func open_drum() -> void:
	animation_player.play("drum_open")

func close_drum() -> void:
	animation_player.play("drum_close")
