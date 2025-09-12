class_name Revolver
extends Node3D

signal shoot_happened(patron: Patron)

@onready var chamber: Chamber = %Chamber
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func get_current_chamber_position() -> Node3D:
	return chamber.get_current_chamber_position()

func load_patron(patron: Patron) -> void:
	chamber.load_patron(patron)
	animation_player.play("load")

func unload_patron(patron: Patron) -> void:
	chamber.unload_patron(patron)
	animation_player.play("load")

func can_load_on_current_point() -> bool:
	return chamber.is_hovered_position_empty()

func has_patrons() -> bool:
	return chamber.has_patrons()

func get_current_patron() -> Patron:
	return chamber.get_current_patron()

func get_hovered_patron() -> Patron:
	return chamber.get_hovered_patron()

func spin_up() -> void:
	chamber.spin_up()

func spin_down() -> void:
	chamber.spin_down()

func fire() -> void:
	chamber.spin_down()
	
	if chamber.is_live_patron_now():
		var patron := get_current_patron()
		patron.is_live = false
		shoot_happened.emit(patron)
		animation_player.play("fire")
	else:
		animation_player.play("fire_empty")

func open_drum() -> void:
	animation_player.play("drum_open")

func close_drum() -> void:
	animation_player.play("drum_close")
