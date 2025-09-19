class_name Player
extends Node3D

signal shooted(patron: Patron, to_dealer: bool)
signal chamber_updated(revolver: Revolver)

@export var patrons: PlayerPatrons

@onready var state_machine: StateMachine = %StateMachine
@onready var revolver: Revolver = %Revolver
@onready var camera_shaker: CameraShaker = %CameraShaker

@onready var player_idle_state: PlayerIdleState = %PlayerIdleState
@onready var player_self_aiming_state: PlayerSelfAimingState = %PlayerSelfAimingState
@onready var player_target_aiming_state: PlayerTargetAimingState = %PlayerTargetAimingState

var initial_revolver_position: Node3D

func _ready() -> void:
	revolver.shoot_happened.connect(_on_shoot_happened)
	revolver.loaded.connect(func(_b): chamber_updated.emit(revolver))
	revolver.unloaded.connect(func(_b): chamber_updated.emit(revolver))
	
	player_self_aiming_state.shooted.connect(func(): shooted.emit(revolver.get_current_patron(), false))
	player_target_aiming_state.shooted.connect(func(): shooted.emit(revolver.get_current_patron(), true))

func _on_shoot_happened(_patron: Patron) -> void:
	camera_shaker.shake(0.2)

func shake() -> void:
	camera_shaker.shake(0.1)

func take_revolver_from(initial_position: Node3D) -> void:
	initial_revolver_position = initial_position
	await state_machine.switch_to(PlayerTakeRevolver)

func to_target_aiming() -> void:
	await state_machine.switch_to(PlayerTargetAimingState)

func to_self_aiming() -> void:
	await state_machine.switch_to(PlayerSelfAimingState)

func to_idle() -> void:
	await state_machine.switch_to(PlayerIdleState)

func can_shoot() -> bool:
	return is_idle() and revolver.has_patrons()

func can_make_turn() -> bool:
	return revolver.has_patrons() or patrons.has_bullets()

func drop_bullets() -> int:
	# TODO: make animation for drop bullets
	return revolver.drop_bullets()

func to_shopping(shop: SlotMachine) -> void:
	await state_machine.switch_to(PlayerShoppingState)

func is_idle() -> bool:
	return state_machine.current_state is PlayerIdleState

func is_shopping() -> bool:
	return state_machine.current_state is PlayerShoppingState

func block() -> void:
	await state_machine.switch_to(PlayerBlockState)

func block_reloading() -> void:
	player_idle_state.is_reloading_blocked = true

func unblock_reloading() -> void:
	player_idle_state.is_reloading_blocked = false

func to_revolver_loading() -> void:
	await state_machine.switch_to(PlayerReloadRevolverState)

func is_aiming() -> bool:
	return state_machine.current_state is PlayerAimingState

func get_chamber_worth() -> int:
	return revolver.chamber.get_worth()
