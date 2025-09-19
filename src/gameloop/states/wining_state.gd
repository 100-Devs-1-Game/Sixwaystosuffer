class_name WiningState
extends StateAsync

@export var dealer: Dealer
@export var player: Player

@export var monitor: QueuedMonitor3D
@export var player_hud: PlayerHUD
@export var game_session: GameSession

var is_can_been_restarted: bool

func handle_input(event: InputEvent) -> void:
	if is_can_been_restarted and event.is_action_pressed("interact"):
		reload_root.call_deferred()

func enter_async() -> void:
	game_session.stop()
	player_hud.statistic_panel.update(game_session)
	
	player.block()
	await pause(0.5)
	monitor.push("congrats")
	dealer.change_face(Dealer.DealerFace.HAPPY)
	await pause(2.0)
	dealer.quit();
	await pause(2.0)
	player_hud.show_curtain(0.05)
	await pause(1.0)
	player_hud.show_statistic(2.0)
	await pause(1.0)
	is_can_been_restarted = true

func exit_async() -> void:
	pass

func reload_root() -> void:
	get_tree().reload_current_scene()
