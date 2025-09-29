class_name Player
extends Node3D

signal shooted(bullet: Bullet, to_dealer: bool)
signal chamber_updated(revolver: Revolver)

@export var bullets: PlayerBullets

@onready var state_machine: StateMachine = %StateMachine
@onready var revolver: Revolver = %Revolver
@onready var bullet_pickup: BulletPickup = %"Bullet Pickup"

@onready var camera_shaker: CameraShaker = %CameraShaker

@onready var player_idle_state: PlayerIdleState = %PlayerIdleState
@onready var player_self_aiming_state: PlayerSelfAimingState = %PlayerSelfAimingState
@onready var player_target_aiming_state: PlayerTargetAimingState = %PlayerTargetAimingState

var initial_revolver_position: Node3D

func _ready() -> void:
	revolver.loaded.connect(func(_b): chamber_updated.emit(revolver))
	revolver.unloaded.connect(func(_b): chamber_updated.emit(revolver))
	
	player_self_aiming_state.shooted.connect(func(): shooted.emit(revolver.get_current_bullet(), false))
	player_target_aiming_state.shooted.connect(_on_shoot_happened)
	player_target_aiming_state.shooted.connect(func(): shooted.emit(revolver.get_current_bullet(), true))

func _on_shoot_happened() -> void:
	var bullet := revolver.get_current_bullet()
	if bullet != null and not bullet.effect.is_dummy:
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
	return is_idle() and revolver.has_bullets()

func can_make_turn() -> bool:
	return revolver.has_bullets() or bullets.has_bullets()

func drop_bullets() -> int:
	var dropped_bullets := revolver.chamber.get_bullet_count()
	await state_machine.switch_to(PlayerDropBullets)
	return dropped_bullets

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
	return (revolver.chamber.get_worth() + bullets.get_passive_income()) * revolver.chamber.get_modifier()
