class_name PlayerSelfAimingState
extends State

@export var player_hand_animation: AnimationPlayer

func enter() -> void:
	player_hand_animation.play("self_aim")

func exit() -> void:
	# TODO: make unique animation for cancel aiming
	player_hand_animation.play_backwards("self_aim")
