class_name PlayerIdleState
extends State

@export var revolver_interact: ClickableArea3D

func enter() -> void:
	revolver_interact.enable()
	revolver_interact.clicked.connect(_on_revolver_clicked)

func exit() -> void:
	revolver_interact.clicked.disconnect(_on_revolver_clicked)
	revolver_interact.disable()

func _on_revolver_clicked() -> void:
	state_machine.switch_to(PlayerReloadRevolverState)
