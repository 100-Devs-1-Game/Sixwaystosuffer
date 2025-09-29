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
var _bullets: Array[Bullet]
var _current_index: int = 0
var _tween: Tween

var _random := RandomNumberGenerator.new()
var _target_rotation: float

func _ready() -> void:
	for child in chamber.get_children():
		_chamber_position.append(child)
	_bullets.resize(MAX_BULLETS_IN_CHAMBER)

func get_bullets() -> Array[Bullet]:
	var bullets: Array[Bullet]
	for bullet in _bullets:
		if bullet is Bullet:
			bullets.append(bullet)
	return bullets

func get_worth() -> int:
	var result: int = 0
	for bullet in get_bullets():
		result += bullet.effect.load_bonus
	return result

func get_modifier() -> int:
	var result: int = 1
	for bullet in get_bullets():
		result *= bullet.effect.load_modifier
	return result

func get_bullet_count() -> int:
	var counter := 0
	for bullet in _bullets:
		if bullet != null:
			counter += 1
	return counter

func drop_bullets() -> int:
	var dropped_bullets_count: int = 0
	for bullet in _bullets:
		if bullet != null:
			bullet.queue_free()
			dropped_bullets_count += 1
	_bullets.clear()
	_bullets.resize(MAX_BULLETS_IN_CHAMBER)
	_update_position_hover()
	return dropped_bullets_count

func get_current_chamber_position() -> Node3D:
	return _chamber_position[_current_index]

func load_bullet(bullet: Bullet) -> void:
	var load_index := (_current_index - 1) % MAX_BULLETS_IN_CHAMBER
	_bullets[load_index] = bullet
	_update_position_hover()

func unload_bullet(bullet: Bullet) -> void:
	var index := _bullets.find(bullet)
	
	if index == -1:
		return
	
	_bullets[index] = null
	_update_position_hover()

func has_bullets() -> bool:
	for bullet in _bullets:
		if bullet != null:
			return true
	return false

func has_current_bullet() -> bool:
	return _bullets[_current_index] != null

func is_hovered_position_empty() -> bool:
	return get_hovered_bullet() == null

func get_hovered_bullet() -> Bullet:
	var load_index := (_current_index - 1) % MAX_BULLETS_IN_CHAMBER
	return _bullets[load_index]

func is_dummy_bullet_now() -> bool:
	var current_bullet := get_current_bullet()
	return current_bullet != null and current_bullet.effect.is_dummy

func get_current_bullet() -> Bullet:
	return _bullets[_current_index]

func spin_random(min_steps: int = 7, max_steps: int = 13) -> void:
	var offset := _random.randi_range(min_steps, max_steps)
	spin(-offset)

func spin_down() -> void:
	spin(-1)

func spin_up() -> void:
	spin(1)

func spin(count: int) -> void:
	if _tween != null and _tween.is_running():
		_tween.kill()
		chamber.rotation.z = _target_rotation
	
	_target_rotation = chamber.rotation.z + deg_to_rad(chamber_rotate_angle * count)
	var duration := minf(abs(SPIN_CHAMBER_DURATION * count), MAX_SPIN_CHAMBER_DURATION)
	_tween = create_tween()
	_tween.tween_property(chamber, "rotation:z", _target_rotation, duration).set_trans(Tween.TRANS_CUBIC)
	
	_current_index = (_current_index + count) % MAX_BULLETS_IN_CHAMBER
	_update_position_hover()
	
	#spin_audio.play()

func _update_position_hover() -> void:
	if is_hovered_position_empty():
		position_hover.make_valid()
	else:
		position_hover.make_invalid()
