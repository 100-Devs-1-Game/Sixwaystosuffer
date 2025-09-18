class_name PlayerShoppingState
extends StateAsync

@export var player_head_animation: AnimationPlayer

func enter_async() -> void:
	player_head_animation.play("to_shop")
	await current_animation_ended(player_head_animation)

func exit_async() -> void:
	player_head_animation.play_backwards("to_shop")
	await current_animation_ended(player_head_animation)
