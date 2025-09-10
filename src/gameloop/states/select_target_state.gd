class_name SelectTargetState
extends State

@export var choices: ChoiceLabels

@export var dealer: Dealer
@export var player: Player

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and player.is_aiming():
		return_to_select_target()

func process(delta: float) -> void:
	if not player.is_idle() and choices.is_visible:
		choices.hide_labels()
	elif player.is_idle() and not choices.is_visible:
		choices.show_labels()

func enter() -> void:
	choices.show_labels()
	choices.dealer_selected.connect(_on_dealer_clicked)
	choices.self_selected.connect(_on_self_clicked)

func exit() -> void:
	choices.hide_labels()
	choices.dealer_selected.disconnect(_on_dealer_clicked)
	choices.self_selected.disconnect(_on_self_clicked)

func _on_dealer_clicked() -> void:
	choices.hide_labels()
	dealer.change_face(Dealer.DealerFace.HAPPY)
	await player.to_target_aiming()

func _on_self_clicked() -> void:
	choices.hide_labels()
	dealer.change_face(Dealer.DealerFace.HYPED_TEETH)
	await player.to_self_aiming()

func return_to_select_target() -> void:
	choices.show_labels()
	dealer.change_face(Dealer.DealerFace.HYPED)
	await player.to_idle()
