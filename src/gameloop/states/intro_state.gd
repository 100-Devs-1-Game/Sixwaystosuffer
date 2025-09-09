class_name IntroState
extends StateAsync

@export var initial_revolver_position: Node3D
@export var clicked_on_revolver: ClickedOnArea3D
@export var player: Player

func enter_async() -> void:
	await clicked_on_revolver.clicked
	await player.take_revolver_from(initial_revolver_position)
	state_machine.switch_to(SelectTargetState)
