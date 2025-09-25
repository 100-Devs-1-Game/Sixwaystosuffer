class_name ShoppingState
extends StateAsync

@export var player: Player
@export var dealer: Dealer
@export var slot_machine: SlotMachine
@export var shop_animation: AnimationPlayer
@export var player_hud: PlayerHUD

var is_tooltip_shown: bool = false
var is_tooltip_needed: bool = false

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

func process(_delta: float) -> void:
	if (not is_tooltip_needed or not player.is_idle()) and is_tooltip_shown:
		is_tooltip_shown = false
		player_hud.hide_shop_tooltip()
	elif is_tooltip_needed and player.is_idle() and not is_tooltip_shown:
		is_tooltip_shown = true
		player_hud.show_shop_tooltip()

func enter_async() -> void:
	if dealer.current_face != Dealer.DealerFace.NEUTRAL:
		dealer.change_face(Dealer.DealerFace.NEUTRAL)
		await pause(1.4)
	
	shop_animation.play("show")
	await current_animation_ended(shop_animation)
	is_tooltip_needed = true
	slot_machine.clickable_area_3d.enable()
	slot_machine.clickable_area_3d.clicked.connect(_on_slot_machine_clicked)
	slot_machine.enable()

func exit_async() -> void:
	shop_animation.play("hide")
	slot_machine.clickable_area_3d.clicked.disconnect(_on_slot_machine_clicked)
	slot_machine.clickable_area_3d.disable()
	slot_machine.disable()
	is_tooltip_needed = false
	await current_animation_ended(shop_animation)

func _on_slot_machine_clicked() -> void:
	slot_machine.clickable_area_3d.disable()
	await player.to_shopping(slot_machine)
