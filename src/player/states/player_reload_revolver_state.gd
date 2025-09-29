class_name PlayerReloadRevolverState
extends StateAsync

@export var player_hand_animation: AnimationPlayer
@export var revolver: Revolver
@export var revolver_interact: ClickableArea3D
@export var bullet_pickup: BulletPickup

func handle_input(event: InputEvent) -> void:
	if bullet_pickup.is_working:
		return
	
	if player_hand_animation.is_playing():
		return
	
	if event.is_action_pressed("spin_up"):
		revolver.spin_up()
	elif event.is_action_pressed("spin_down"):
		revolver.spin_down()
	elif event.is_action_pressed("back"):
		if revolver.has_hovered_bullet():
			bullet_pickup.unload_bullet(revolver.get_hovered_bullet())
		else:
			state_machine.switch_to(PlayerIdleState)

func enter_async() -> void:
	player_hand_animation.play("open_drum")
	await current_animation_ended(player_hand_animation)
	revolver_interact.clicked.connect(_on_revolver_clicked)
	revolver_interact.enable()
	bullet_pickup.enable_bullets_interaction()

func exit_async() -> void:
	bullet_pickup.disable_bullets_interaction()
	revolver_interact.clicked.disconnect(_on_revolver_clicked)
	revolver_interact.disable()
	player_hand_animation.play("close_drum")
	revolver.chamber.spin_random()
	await current_animation_ended(player_hand_animation)

func _on_revolver_clicked() -> void:
	if bullet_pickup.is_working:
		return
	
	state_machine.switch_to(PlayerIdleState)
