class_name PlayerDropBullets
extends StateAsync

@export var player_hand_animation: AnimationPlayer
@export var revolver: Revolver

func enter_async() -> void:
	player_hand_animation.play("drop_bullets")
	await current_animation_ended(player_hand_animation)

func drop_bullets() -> void:
	revolver.drop_bullets()

func exit_async() -> void:
	pass
