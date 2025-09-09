class_name StateAsync
extends State

func enter_async() -> void:
	pass

func exit_async() -> void:
	pass

func pause(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func current_animation_ended(animation_player: AnimationPlayer) -> void:
	await pause(animation_player.current_animation_length)
