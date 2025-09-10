class_name IntroState
extends StateAsync

@export var initial_revolver_position: Node3D
@export var clicked_on_revolver: ClickedOnArea3D

@export var dealer: Dealer
@export var player: Player

func _ready() -> void:
	clicked_on_revolver.clicked.connect(_on_revolver_clicked)

func enter_async() -> void:
	await pause(1.0)
	dealer.entry()
	await current_animation_ended(dealer.animation_player)

func _on_revolver_clicked(_area: Area3D) -> void:
	await player.take_revolver_from(initial_revolver_position)
	await pause(1.0)
	state_machine.switch_to(SelectTargetState)
