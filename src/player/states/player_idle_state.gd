class_name PlayerIdleState
extends State

@export var revolver_interact: ClickableArea3D
@export var tremor_animation: AnimationPlayer

var is_reloading_blocked: bool

func enter() -> void:
	revolver_interact.enable()
	revolver_interact.clicked.connect(_on_revolver_clicked)

func exit() -> void:
	revolver_interact.clicked.disconnect(_on_revolver_clicked)
	revolver_interact.disable()

func _on_revolver_clicked() -> void:
	if not is_reloading_blocked:
		state_machine.switch_to(PlayerReloadRevolverState)
	else:
		tremor_animation.play("invalid_action")
	
