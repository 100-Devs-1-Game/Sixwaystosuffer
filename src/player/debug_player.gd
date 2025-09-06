class_name DebugPlayer
extends Node

@export var state_machine: StateMachine
@export var revolver: Revolver

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_back"):
		state_machine.switch_to(PlayerIdleState)
	
	if event.is_action_pressed("debug_interact"):
		state_machine.switch_to(PlayerReloadRevolverState)
	
	if event.is_action_pressed("debug_fire"):
		revolver.fire()
	
	if event.is_action_pressed("debug_self_aim"):
		state_machine.switch_to(PlayerSelfAimingState)
