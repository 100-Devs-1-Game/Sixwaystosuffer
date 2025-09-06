class_name PlayerReloadRevolverState
extends State

@export var player_hand_animation: AnimationPlayer
@export var revolver: Revolver

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			revolver.spin_up()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			revolver.spin_down()

func enter() -> void:
	player_hand_animation.play("open_drum")

func exit() -> void:
	player_hand_animation.play("close_drum")
