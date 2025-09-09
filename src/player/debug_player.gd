class_name DebugPlayer
extends Node

@export var state_machine: StateMachine
@export var revolver: Revolver
@export var pickup: PatronPickup
@export var debug_patron: Patron

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_load"):
		#pickup.load_patron(debug_patron)
		state_machine.switch_to(PlayerTargetAimingState)
		
	
	if event.is_action_pressed("debug_back") and state_machine.current_state is PlayerIdleState:
		state_machine.switch_to(PlayerTakeRevolver)
	
	if event.is_action_pressed("debug_interact"):
		if state_machine.current_state is PlayerReloadRevolverState:
			state_machine.switch_to(PlayerIdleState)
		else:
			state_machine.switch_to(PlayerReloadRevolverState)
	
	if event.is_action_pressed("debug_fire"):
		revolver.fire()
	
	if event.is_action_pressed("debug_self_aim"):
		state_machine.switch_to(PlayerSelfAimingState)
