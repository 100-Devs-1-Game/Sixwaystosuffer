class_name GameplayState
extends State

@export var choices: ChoiceLabels

@export var dealer: Dealer
@export var player: Player

@export var monitor_controller: MonitorController
@export var session: GameSession

var is_first_dealer_apperence: bool = true
var is_second_shoot: bool

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and player.is_aiming():
		return_to_select_target()

func process(delta: float) -> void:	
	if choices.is_visible and not is_player_can_shoot():
		choices.hide_labels()
	elif not choices.is_visible and is_player_can_shoot():
		choices.show_labels()
		
		if is_first_dealer_apperence:
			entry_dealer()
		
		if is_second_shoot:
			monitor_controller.show_current_score(session.get_score_line())

func is_player_can_shoot() -> bool:
	return player.is_idle() and player.revolver.has_patrons()

func entry_dealer() -> void:
	dealer.entry()
	monitor_controller.show_target_reach()
	is_first_dealer_apperence = false

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
	monitor_controller.show_sad()
	await player.to_target_aiming()

func _on_self_clicked() -> void:
	choices.hide_labels()
	dealer.change_face(Dealer.DealerFace.HYPED)
	monitor_controller.show_good_luck()
	await player.to_self_aiming()

func return_to_select_target() -> void:
	monitor_controller.show_target_reach()
	choices.show_labels()
	dealer.change_face(Dealer.DealerFace.SAD)
	await player.to_idle()

func _on_player_shooted(patron: Patron, to_dealer: bool) -> void:
	session.make_shot(patron, player.revolver, to_dealer)
	is_second_shoot = true
	
	if to_dealer:
		process_dealer_shooting(patron)
	else:
		process_self_shooting(patron)

func process_self_shooting(patron: Patron) -> void:
	if patron:
		await state_machine.switch_to(GameOverState)
		player.block()
		return
	monitor_controller.show_current_score(session.get_score_line())
	await pause_async(0.15)
	end_player_turn()

func process_dealer_shooting(patron: Patron) -> void:
	monitor_controller.show_current_score(session.get_score_line())
	await pause_async(0.15)
	if patron:
		dealer.take_damage()
	end_player_turn()

func end_player_turn() -> void:
	var dropped_bullets: int = await player.drop_bullets()
	session.dropped_bullets += dropped_bullets
	await player.to_idle()

func pause_async(duration: float) -> void:
	await get_tree().create_timer(0.15).timeout
