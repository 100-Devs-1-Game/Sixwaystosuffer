class_name PlayerReloadRevolverState
extends StateAsync

@export var player_hand_animation: AnimationPlayer
@export var revolver: Revolver
@export var revolver_interact: ClickableArea3D
@export var patron_pickup: PatronPickup

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		state_machine.switch_to(PlayerIdleState)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			revolver.spin_up()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			revolver.spin_down()

func enter_async() -> void:
	player_hand_animation.play("open_drum")
	await current_animation_ended(player_hand_animation)
	revolver_interact.clicked.connect(_on_revolver_clicked)
	revolver_interact.enable()
	patron_pickup.enable_patrons_interaction()

func exit_async() -> void:
	patron_pickup.disable_patrons_interaction()
	revolver_interact.clicked.disconnect(_on_revolver_clicked)
	revolver_interact.disable()
	player_hand_animation.play("close_drum")
	await current_animation_ended(player_hand_animation)

func _on_revolver_clicked() -> void:
	state_machine.switch_to(PlayerIdleState)
