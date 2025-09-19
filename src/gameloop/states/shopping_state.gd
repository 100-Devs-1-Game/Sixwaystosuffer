class_name ShoppingState
extends StateAsync

@export var player: Player
@export var dealer: Dealer
@export var slot_machine: SlotMachine
@export var shop_animation: AnimationPlayer

func handle_input(event: InputEvent) -> void:
	if slot_machine.is_working:
		return
	
	if not event.is_action_pressed("back"):
		return
	
	if player.is_shopping():
		slot_machine.clickable_area_3d.enable()
		await player.to_idle()
	elif player.is_idle():
		if player.can_make_turn():
			await state_machine.switch_to(GameplayState)
		else:
			await state_machine.switch_to(DealerForceOverState)

func enter_async() -> void:
	if dealer.current_face != Dealer.DealerFace.NEUTRAL:
		dealer.change_face(Dealer.DealerFace.NEUTRAL)
		await pause(1.4)
	
	shop_animation.play("show")
	await current_animation_ended(shop_animation)
	slot_machine.enable()
	slot_machine.clickable_area_3d.clicked.connect(_on_slot_machine_clicked)

func exit_async() -> void:
	shop_animation.play("hide")
	await current_animation_ended(shop_animation)
	slot_machine.clickable_area_3d.clicked.disconnect(_on_slot_machine_clicked)
	slot_machine.disable()

func _on_slot_machine_clicked() -> void:
	slot_machine.clickable_area_3d.disable()
	await player.to_shopping(slot_machine)
	slot_machine.enable()
