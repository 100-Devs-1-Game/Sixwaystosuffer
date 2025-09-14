class_name Chamber
extends Node

const MAX_BULLETS_IN_CHAMBER: int = 6
const SPIN_CHAMBER_DURATION: float = 0.25
const MAX_SPIN_CHAMBER_DURATION: float = 1.5

@export var chamber: Node3D
@export var chamber_rotate_angle: float = 60.0
@export var position_hover: CurrentPositionHover
@export var spin_audio: AudioStreamPlayer

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
	var load_index := (_current_index - 1) % MAX_BULLETS_IN_CHAMBER
	_partons[load_index] = patron
	_update_position_hover()

func unload_patron(patron: Patron) -> void:
	var index := _partons.find(patron)
	
	if index == -1:
		return
	
	_partons[index] = null
	_update_position_hover()

func has_patrons() -> bool:
	for patron in _partons:
		if patron != null:
			return true
	return false

func has_current_patron() -> bool:
	return _partons[_current_index] != null

func is_hovered_position_empty() -> bool:
	return get_hovered_patron() == null

func get_hovered_patron() -> Patron:
	var load_index := (_current_index - 1) % MAX_BULLETS_IN_CHAMBER
	return _partons[load_index]

func is_live_patron_now() -> bool:
	var current_patron := get_current_patron()
	return current_patron != null and current_patron.is_live

func get_current_patron() -> Patron:
	return _partons[_current_index]

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
	
	var duration := minf(abs(SPIN_CHAMBER_DURATION * count), MAX_SPIN_CHAMBER_DURATION)
	_tween = create_tween()
	_tween.tween_property(chamber, "rotation:z", chamber.rotation.z + deg_to_rad(chamber_rotate_angle * count), duration).set_trans(Tween.TRANS_CUBIC)
	
	_current_index = (_current_index + count) % MAX_BULLETS_IN_CHAMBER
	_update_position_hover()
	
	#spin_audio.play()

func _update_position_hover() -> void:
	if is_hovered_position_empty():
		position_hover.make_valid()
	else:
		position_hover.make_invalid()
