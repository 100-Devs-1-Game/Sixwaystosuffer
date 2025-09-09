class_name PlayerSelfAimingState
extends PlayerAimingState

@export var player_hand_animation: AnimationPlayer

func enter_async() -> void:
	player_hand_animation.play("self_aim")
	await current_animation_ended(player_hand_animation)
	is_ready_to_fire = true

func exit_async() -> void:
	is_ready_to_fire = false
	# TODO: make unique animation?
	player_hand_animation.play_backwards("self_aim")
	await current_animation_ended(player_hand_animation)
