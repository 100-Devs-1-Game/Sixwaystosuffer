class_name IntroState
extends StateAsync

@export var initial_revolver_position: Node3D
@export var initial_revolver_area3d: ClickableArea3D

@export var dealer: Dealer
@export var player: Player

@export var main_theme_audio: SmoothAudioStreamPlayer
@export var player_patrons: PlayerPatrons

func _ready() -> void:
	initial_revolver_area3d.clicked.connect(_on_revolver_clicked)

func enter_async() -> void:
	player_patrons.add(load("res://revolver/bullets/patron.tscn").instantiate())
	player_patrons.add(load("res://revolver/bullets/patron.tscn").instantiate())
	player_patrons.add(load("res://revolver/bullets/patron.tscn").instantiate())
	
	main_theme_audio.smooth_play()
	await pause(1.0)
	dealer.entry()
	await current_animation_ended(dealer.animation_player)
	state_machine.switch_to(SelectTargetState)

func _on_revolver_clicked() -> void:
	await player.take_revolver_from(initial_revolver_position)
	initial_revolver_position.queue_free()
	await player.to_idle()
