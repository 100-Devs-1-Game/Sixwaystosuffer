class_name Revolver
extends Node3D

signal shoot_happened(patron: Patron)
signal loaded(patron: Patron)
signal unloaded(patron: Patron)

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

func load_patron(patron: Patron) -> void:
	chamber.load_patron(patron)
	animation_player.play("load")
	loaded.emit(patron)

func unload_patron(patron: Patron) -> void:
	chamber.unload_patron(patron)
	animation_player.play("load")
	unloaded.emit(patron)

func can_load_on_current_point() -> bool:
	return chamber.is_hovered_position_empty()

func has_patrons() -> bool:
	return chamber.has_patrons()

func get_current_patron() -> Patron:
	return chamber.get_current_patron()

func has_hovered_patron() -> bool:
	return chamber.get_hovered_patron() != null

func get_hovered_patron() -> Patron:
	return chamber.get_hovered_patron()

func spin_up() -> void:
	chamber.spin_up()

func spin_down() -> void:
	chamber.spin_down()

func fire() -> void:
	chamber.spin_down()
	
	if not chamber.has_current_patron():
		shoot_happened.emit(get_current_patron())
		animation_player.play("fire_empty")
	else:
		var patron := get_current_patron()
		
		if patron.effect.is_dummy:
			animation_player.play("fire_empty")
		else:
			animation_player.play("fire")
		
		shoot_happened.emit(patron)

func open_drum() -> void:
	animation_player.play("drum_open")

func close_drum() -> void:
	animation_player.play("drum_close")
