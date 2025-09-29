class_name Revolver
extends Node3D

signal shoot_happened(bullet: Bullet)
signal loaded(bullet: Bullet)
signal unloaded(bullet: Bullet)

@onready var chamber: Chamber = %Chamber
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_position_hover: CurrentPositionHover = %"Current Position Hover"

func show_hover_position() -> void:
	current_position_hover.show()

func hide_hover_position() -> void:
	current_position_hover.hide()

func drop_bullets() -> int:
	return chamber.drop_bullets()

func get_current_chamber_position() -> Node3D:
	return chamber.get_current_chamber_position()

func load_bullet(bullet: Bullet) -> void:
	chamber.load_bullet(bullet)
	animation_player.play("load")
	loaded.emit(bullet)

func unload_bullet(bullet: Bullet) -> void:
	chamber.unload_bullet(bullet)
	animation_player.play("load")
	unloaded.emit(bullet)

func can_load_on_current_point() -> bool:
	return chamber.is_hovered_position_empty()

func has_bullets() -> bool:
	return chamber.has_bullets()

func get_current_bullet() -> Bullet:
	return chamber.get_current_bullet()

func has_hovered_bullet() -> bool:
	return chamber.get_hovered_bullet() != null

func get_hovered_bullet() -> Bullet:
	return chamber.get_hovered_bullet()

func spin_up() -> void:
	chamber.spin_up()

func spin_down() -> void:
	chamber.spin_down()

func fire() -> void:
	chamber.spin_down()
	
	if not chamber.has_current_bullet():
		shoot_happened.emit(get_current_bullet())
		animation_player.play("fire_empty")
	else:
		var bullet := get_current_bullet()
		
		if bullet.effect.is_dummy:
			animation_player.play("fire_empty")
		else:
			animation_player.play("fire")
		
		shoot_happened.emit(bullet)

func open_drum() -> void:
	animation_player.play("drum_open")

func close_drum() -> void:
	animation_player.play("drum_close")
