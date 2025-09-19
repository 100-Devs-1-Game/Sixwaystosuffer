class_name ShoppingState
extends StateAsync

@export var player: Player
@export var slot_machine: SlotMachine
@export var shop_animation: AnimationPlayer

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		if not player.is_idle():
			slot_machine.clickable_area_3d.enable()
			slot_machine.disable()
			await player.to_idle()
		else:
			await state_machine.switch_to(GameplayState)

func enter_async() -> void:
	await get_tree().create_timer(1.0).timeout
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
