class_name PlayerTargetAimingState
extends StateAsync

@export var player_hand_animation: AnimationPlayer

func enter_async() -> void:
	player_hand_animation.play("target_aim")
	await current_animation_ended(player_hand_animation)

func exit_async() -> void:
	# TODO: make specific animation for exit from state?
	player_hand_animation.play_backwards("target_aim")
	await current_animation_ended(player_hand_animation)
