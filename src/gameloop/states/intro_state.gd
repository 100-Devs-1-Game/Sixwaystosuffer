class_name IntroState
extends StateAsync

@export var session: GameSession

@export var initial_revolver_position: Node3D
@export var initial_revolver_area3d: ClickableArea3D

@export var player: Player

@export var main_theme_audio: SmoothAudioStreamPlayer
@export var player_patrons: PlayerPatrons

@export var player_hud: PlayerHUD
@export var intro_animation: AnimationPlayer

func enter_async() -> void:
	player_hud.hide_curtain(0.2)
	initial_revolver_area3d.clicked.connect(_on_revolver_clicked)
	_spawn_start_bullets(session.initial_bullets_count)
	intro_animation.play("intro")
	
	await get_tree().create_timer(0.1).timeout
	session.start()

func exit_async() -> void:
	initial_revolver_area3d.clicked.disconnect(_on_revolver_clicked)

func _spawn_start_bullets(count: int) -> void:
	var base_patron := load("res://revolver/bullets/patron.tscn")
	for i in count:
		var instance := base_patron.instantiate() as Patron
		player_patrons.add(instance)

func _on_revolver_clicked() -> void:
	main_theme_audio.smooth_play()
	
	await player.take_revolver_from(initial_revolver_position)
	initial_revolver_position.queue_free()
	
	await player.to_idle()
	state_machine.switch_to(GameplayState)
