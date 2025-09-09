class_name Player
extends Node3D

@onready var state_machine: StateMachine = %StateMachine

var initial_revolver_position: Node3D

func take_revolver_from(initial_position: Node3D) -> void:
	initial_revolver_position = initial_position
	await state_machine.switch_to(PlayerTakeRevolver)

func to_target_aiming() -> void:
	await state_machine.switch_to(PlayerTargetAimingState)

func to_self_aiming() -> void:
	await state_machine.switch_to(PlayerSelfAimingState)

func to_idle() -> void:
	await state_machine.switch_to(PlayerIdleState)
