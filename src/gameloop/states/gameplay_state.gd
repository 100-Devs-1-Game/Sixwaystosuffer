class_name GameplayState
extends State

@export var choices: ChoiceLabels

@export var dealer: Dealer
@export var player: Player

@export var monitor_3d: Monitor3D

var max_rounds: int = 3
var current_round: int = 0
var round_goal: int = 100
var total_worth: int = 0

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and player.is_aiming():
		return_to_select_target()

func process(delta: float) -> void:
	if choices.is_visible and not (player.is_idle() and player.revolver.has_patrons()):
		choices.hide_labels()
	elif player.is_idle() and not choices.is_visible:
		choices.show_labels()

func enter() -> void:
	choices.dealer_label.clicked.connect(_on_dealer_clicked)
	choices.you_label.clicked.connect(_on_self_clicked)
	player.shooted.connect(_on_player_shooted)

func exit() -> void:
	choices.dealer_label.clicked.disconnect(_on_dealer_clicked)
	choices.you_label.clicked.disconnect(_on_self_clicked)
	player.shooted.disconnect(_on_player_shooted)

func _on_dealer_clicked() -> void:
	choices.hide_labels()
	dealer.change_face(Dealer.DealerFace.HAPPY)
	await player.to_target_aiming()

func _on_self_clicked() -> void:
	choices.hide_labels()
	dealer.change_face(Dealer.DealerFace.HYPED)
	await player.to_self_aiming()

func return_to_select_target() -> void:
	choices.show_labels()
	dealer.change_face(Dealer.DealerFace.SAD)
	await player.to_idle()

func _on_player_shooted(patron: Patron, to_dealer: bool) -> void:
	var modifier: int = 1 if to_dealer else 10
	var worth := player.get_chamber_worth()
	var result := modifier * worth
	total_worth += result
	#monitor_3d.setup_phrase(["%s$/100$" % total_worth, "round:%s/3" % current_round])
	
	if not patron:
		await pause_async(0.15)
		await player.to_idle()
		return
	
	if not to_dealer:
		await state_machine.switch_to(GameOverState)
		player.block()
	else:
		await pause_async(0.15)
		dealer.take_damage()
		await player.to_idle()

func pause_async(duration: float) -> void:
	await get_tree().create_timer(0.15).timeout
