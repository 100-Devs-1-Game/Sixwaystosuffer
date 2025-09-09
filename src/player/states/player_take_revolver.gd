class_name PlayerTakeRevolver
extends State

@export var player: Player
@export var revolver: Revolver

func enter() -> void:
	var initial_revolver_position := player.initial_revolver_position
	var start_position := revolver.global_position
	var start_rotation := revolver.global_rotation
	initial_revolver_position.hide()
	revolver.global_position = initial_revolver_position.global_position
	revolver.global_rotation = initial_revolver_position.global_rotation
	tween_taking_revolver(start_position, start_rotation)

func tween_taking_revolver(target_position: Vector3, target_rotation: Vector3) -> void:
	revolver.show()
	var tween := create_tween()
	tween.tween_property(revolver, "global_position", target_position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(revolver, "global_rotation", target_rotation, 1.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

func exit() -> void:
	pass
