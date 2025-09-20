class_name WiningState
extends StateAsync

@export var dealer: Dealer
@export var player: Player

@export var monitor: QueuedMonitor3D
@export var player_hud: PlayerHUD
@export var game_session: GameSession

@export var main_theme: AudioStreamPlayer
@export var switch_audio_player: AudioStreamPlayer
@export var winning_audio_player: SmoothAudioStreamPlayer

var is_can_been_restarted: bool

func handle_input(event: InputEvent) -> void:
	if is_can_been_restarted and event.is_action_pressed("interact"):
		state_machine.switch_to(GameReloadState)

func enter_async() -> void:
	game_session.game_end_reason = GameSession.Reason.WINNER
	game_session.stop()
	player_hud.statistic_panel.update(game_session)
	
	player.block()
	await pause(0.5)
	monitor.push("[GAMEPLAY_CONGRATS]")
	dealer.change_face(Dealer.DealerFace.HAPPY)
	await pause(2.0)
	switch_audio_player.play()
	await pause(0.1)
	
	winning_audio_player.smooth_duration = 4.0
	winning_audio_player.smooth_play()
	await pause(1.0)
	dealer.quit();
	await pause(3.5)
	switch_audio_player.play()
	await pause(0.1)
	winning_audio_player.stop()
	
	await pause(0.1)
	player_hud.show_curtain(0.05)
	main_theme.stop()
	await pause(1.0)
	player_hud.show_statistic(2.0)
	is_can_been_restarted = true
