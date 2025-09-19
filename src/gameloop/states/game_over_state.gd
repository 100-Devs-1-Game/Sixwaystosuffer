class_name GameOverState
extends StateAsync

@export var session: GameSession

@export var player_hud: PlayerHUD

@export var selfshot_audio: AudioStreamPlayer
@export var main_theme_audio: AudioStreamPlayer

var is_can_been_restarted: bool

func handle_input(event: InputEvent) -> void:
	if is_can_been_restarted and event.is_action_pressed("interact"):
		state_machine.switch_to(GameReloadState)

func enter_async() -> void:
	session.stop()
	player_hud.statistic_panel.update(session)
	selfshot_audio.play()
	main_theme_audio.stop()
	await pause(0.2)
	player_hud.show_curtain(0.05)
	await pause(1.0)
	player_hud.show_statistic(2.0)
	await pause(2.5)
	is_can_been_restarted = true
