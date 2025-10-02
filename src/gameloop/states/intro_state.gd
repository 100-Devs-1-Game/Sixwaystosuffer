class_name IntroState
extends StateAsync

const BASE_BULLET_SCENE := preload("res://revolver/bullets/bullet.tscn")

@export var session: GameSession

@export var revolver_table_mockup: ClickableArea3D

@export var player: Player

@export var main_theme_audio: SmoothAudioStreamPlayer
@export var player_bullets: PlayerBullets

@export var player_hud: PlayerHUD
@export var intro_animation: AnimationPlayer

func enter_async() -> void:
	player_hud.hide_curtain(0.2)
	revolver_table_mockup.clicked.connect(_on_revolver_clicked)
	_spawn_start_bullets(session.initial_bullets_count)
	intro_animation.play("intro")
	
	await get_tree().create_timer(0.1).timeout
	session.start()

func exit_async() -> void:
	revolver_table_mockup.clicked.disconnect(_on_revolver_clicked)

func _spawn_start_bullets(count: int) -> void:
	for i in count:
		var instance := BASE_BULLET_SCENE.instantiate() as Bullet
		player_bullets.add(instance)

func _on_revolver_clicked() -> void:
	main_theme_audio.smooth_play()
	revolver_table_mockup.disable()
	revolver_table_mockup.hide()
	
	await player.take_revolver_from(revolver_table_mockup)
	
	await player.to_idle()
	state_machine.switch_to(GameplayState)
