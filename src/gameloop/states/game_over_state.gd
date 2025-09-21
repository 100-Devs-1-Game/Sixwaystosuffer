class_name GameOverState
extends StateAsync

@export var session: GameSession

@export var player_hud: PlayerHUD

@export var selfshot_audio: AudioStreamPlayer
@export var main_theme_audio: AudioStreamPlayer

func enter_async() -> void:
	session.stop()
	player_hud.statistic_panel.update(session)
	selfshot_audio.play()
	main_theme_audio.stop()
	await pause(0.2)
	player_hud.show_curtain(0.05)
	await pause(1.0)
	player_hud.show_statistic(2.0)
	player_hud.statistic_panel.retry_pressed.connect(_on_reload)

func _on_reload() -> void:
	state_machine.switch_to(GameReloadState)
