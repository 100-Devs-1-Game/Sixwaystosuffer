class_name PlayerTargetAimingState
extends PlayerAimingState

@export var player_hand_animation: AnimationPlayer
@export var woosh_stream_player: AudioStreamPlayer

func enter_async() -> void:
	player_hand_animation.play("target_aim")
	woosh_stream_player.play()
	await current_animation_ended(player_hand_animation)
	is_ready_to_fire = true

func exit_async() -> void:
	is_ready_to_fire = false
	# TODO: make specific animation for exit from state?
	player_hand_animation.play_backwards("target_aim")
	woosh_stream_player.play()
	await current_animation_ended(player_hand_animation)
