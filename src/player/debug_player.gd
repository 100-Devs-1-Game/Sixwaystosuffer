class_name DebugPlayer
extends Node

@export var state_machine: StateMachine
@export var revolver: Revolver
@export var pickup: PatronPickup
@export var debug_patron: Patron
@export var camera_shaker: CameraShaker

func _unhandled_input(event: InputEvent) -> void:	
	if event.is_action_pressed("debug_fire"):
		var duplicated_patron := debug_patron.duplicate()
		debug_patron.get_parent().add_child(duplicated_patron)
		pickup.load_patron(duplicated_patron)
