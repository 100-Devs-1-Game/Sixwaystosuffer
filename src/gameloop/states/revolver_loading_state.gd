class_name RevolverLoadingState
extends StateAsync

@export var player: Player

func enter_async() -> void:
	await player.to_revolver_loading()

func exit_async() -> void:
	pass
