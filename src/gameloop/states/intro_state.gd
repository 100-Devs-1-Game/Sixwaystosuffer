class_name IntroState
extends StateAsync

@export var initial_revolver_position: Node3D
@export var initial_revolver_area3d: ClickableArea3D

@export var dealer: Dealer
@export var player: Player

func _ready() -> void:
	initial_revolver_area3d.clicked.connect(_on_revolver_clicked)

func enter_async() -> void:
	await pause(1.0)
	dealer.entry()
	await current_animation_ended(dealer.animation_player)

func _on_revolver_clicked() -> void:
	await player.take_revolver_from(initial_revolver_position)
	initial_revolver_position.queue_free()
	await player.to_idle()

func process(delta: float) -> void:
	if player.is_idle() and player.revolver.has_patrons():
		state_machine.switch_to(SelectTargetState)
