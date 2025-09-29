class_name GameplayState
extends State

@export var choices: ChoiceLabels

@export var dealer: Dealer
@export var player: Player

@export var monitor_controller: MonitorController
@export var session: GameSession

@export var cash_audio_player: AudioStreamPlayer

var is_first_dealer_apperence: bool = true

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and player.is_aiming():
		return_to_select_target()

func process(_delta: float) -> void:
	process_choices_on_table()

func process_choices_on_table() -> void:
	if choices.is_shown and not player.can_shoot():
		choices.hide_labels()
	elif not choices.is_shown and player.can_shoot():
		choices.show_labels()
		
		if is_first_dealer_apperence:
			entry_dealer()

func entry_dealer() -> void:
	dealer.entry()
	monitor_controller.show_target_reach()
	is_first_dealer_apperence = false

func enter() -> void:
	choices.dealer_label.clicked.connect(_on_dealer_clicked)
	choices.you_label.clicked.connect(_on_self_clicked)
	player.shooted.connect(_on_player_shooted)
	player.chamber_updated.connect(_on_chamber_updated)

func exit() -> void:
	choices.dealer_label.clicked.disconnect(_on_dealer_clicked)
	choices.you_label.clicked.disconnect(_on_self_clicked)
	player.shooted.disconnect(_on_player_shooted)
	player.chamber_updated.disconnect(_on_chamber_updated)

func _on_chamber_updated(revolver: Revolver) -> void:
	session.update_chamber(revolver.chamber)

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

func _on_player_shooted(bullet: Bullet, to_dealer: bool) -> void:
	var profit := session.make_shot(bullet, player, to_dealer)
	monitor_controller.show_current_score(session.get_score_line())
	monitor_controller.show_profit(profit)
	cash_audio_player.play()
	
	if to_dealer:
		process_dealer_shooting(bullet)
	else:
		process_self_shooting(bullet)

func process_self_shooting(bullet: Bullet) -> void:
	if bullet and not bullet.effect.is_dummy:
		session.game_end_reason = GameSession.Reason.SELFSHOT
		await state_machine.switch_to(GameOverState)
		player.block()
		return
	
	await pause_async(0.15)
	dealer.change_face(Dealer.DealerFace.SAD)
	end_player_turn(0.5)

func process_dealer_shooting(bullet: Bullet) -> void:
	await pause_async(0.15)
	if bullet:
		dealer.take_damage()
	else:
		dealer.change_face(Dealer.DealerFace.NEUTRAL)
	end_player_turn(0)

func end_player_turn(pause: float) -> void:
	var dropped_bullets: int = await player.drop_bullets()
	session.dropped_bullets += dropped_bullets
	await player.to_idle()
	await pause_async(pause)
	
	if session.is_target_reached():
		await state_machine.switch_to(WiningState)
	elif not can_continue_game():
		await state_machine.switch_to(DealerForceOverState)
	else:
		await state_machine.switch_to(ShoppingState)

func can_continue_game() -> bool:
	return player.can_make_turn() or session.total_worth > 0

func pause_async(duration: float) -> void:
	await get_tree().create_timer(duration).timeout
