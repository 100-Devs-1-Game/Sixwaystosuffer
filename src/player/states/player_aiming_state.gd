class_name PlayerAimingState
extends StateAsync

signal shooted()

@export var revolver: Revolver

var is_ready_to_fire: bool

func handle_input(event: InputEvent) -> void:
	if not is_ready_to_fire:
		return
	
	if event.is_action_pressed("interact"):
		revolver.fire()
		shooted.emit()
		is_ready_to_fire = false
