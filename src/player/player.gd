class_name Player
extends Node3D

@onready var state_machine: StateMachine = %StateMachine
@onready var revolver: Revolver = %Revolver
@onready var camera_shaker: CameraShaker = %CameraShaker

var initial_revolver_position: Node3D

func _ready() -> void:
	revolver.shoot_happened.connect(_on_shoot_happened)

func _on_shoot_happened(patron: Patron) -> void:
	camera_shaker.shake(0.05)

func take_revolver_from(initial_position: Node3D) -> void:
	initial_revolver_position = initial_position
	await state_machine.switch_to(PlayerTakeRevolver)

func to_target_aiming() -> void:
	await state_machine.switch_to(PlayerTargetAimingState)

func to_self_aiming() -> void:
	await state_machine.switch_to(PlayerSelfAimingState)

func to_idle() -> void:
	await state_machine.switch_to(PlayerIdleState)

func is_idle() -> bool:
	return state_machine.current_state is PlayerIdleState

func to_revolver_loading() -> void:
	await state_machine.switch_to(PlayerReloadRevolverState)

func is_aiming() -> bool:
	return state_machine.current_state is PlayerAimingState
