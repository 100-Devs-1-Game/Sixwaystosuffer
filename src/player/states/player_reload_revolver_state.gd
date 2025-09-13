class_name PlayerReloadRevolverState
extends StateAsync

@export var player_hand_animation: AnimationPlayer
@export var revolver: Revolver
@export var revolver_interact: ClickableArea3D
@export var patron_pickup: PatronPickup

func handle_input(event: InputEvent) -> void:
	if patron_pickup.is_working:
		return
	
	if event.is_action_pressed("spin_up"):
		revolver.spin_up()
	elif event.is_action_pressed("spin_down"):
		revolver.spin_down()
	elif event.is_action_pressed("back"):
		patron_pickup.unload_patron(revolver.get_hovered_patron())

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
	if patron_pickup.is_working:
		return
	
	state_machine.switch_to(PlayerIdleState)
