class_name PlayerSelfAimingState
extends PlayerAimingState

@export var player_hand_animation: AnimationPlayer
@export var tremor_animation: AnimationPlayer
@export var woosh_audo_player: AudioStreamPlayer

func enter_async() -> void:
	player_hand_animation.play("self_aim")
	tremor_animation.play("tremor")
	woosh_audo_player.play()
	await current_animation_ended(player_hand_animation)
	is_ready_to_fire = true

func exit_async() -> void:
	is_ready_to_fire = false
	# TODO: make unique animation?
	player_hand_animation.play_backwards("self_aim")
	tremor_animation.play("idle")
	woosh_audo_player.play()
	await current_animation_ended(player_hand_animation)
