class_name GameOverState
extends StateAsync

@export var curtain: ColorRect
@export var fade_in: Color
@export var audio: AudioStreamPlayer

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		## TODO: restart game
		state_machine.switch_to(IntroState)
		pass

func enter_async() -> void:
	curtain.show()
	var tween := create_tween()
	tween.tween_property(curtain, "color:a", 1, 0.05)
	audio.play()

func exit_async() -> void:
	curtain.color.a = 0
	curtain.hide()
