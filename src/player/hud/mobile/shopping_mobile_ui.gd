class_name ShoppingMobileUI
extends PanelContainer

@export var state_machine: StateMachine

var desired_states = [
	PlayerShoppingState,
	PlayerSelfAimingState,
	PlayerTargetAimingState
]

func initialize() -> void:
	state_machine.processing_started.connect(_on_processing_started)
	state_machine.state_entered.connect(_on_state_entered)

func _on_processing_started(_target: GDScript) -> void:
	hide()

func _on_state_entered(target: GDScript) -> void:
	if desired_states.has(target):
		show()
