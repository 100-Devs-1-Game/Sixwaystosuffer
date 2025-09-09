class_name PlayerReloadRevolverState
extends StateAsync

@export var player_hand_animation: AnimationPlayer
@export var revolver: Revolver

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			revolver.spin_up()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			revolver.spin_down()

func enter_async() -> void:
	player_hand_animation.play("open_drum")
	await current_animation_ended(player_hand_animation)

func exit_async() -> void:
	player_hand_animation.play("close_drum")
	await current_animation_ended(player_hand_animation)
