class_name MonitorController
extends Node

@export var session: GameSession
@export var player: Player
@export var revolver_mockup: ClickableArea3D
@export var bullets: PlayerBullets
@export var monitor_3d: QueuedMonitor3D
@export var choices: ChoiceLabels

@export var profit_timer: Timer

func _ready() -> void:
	revolver_mockup.clicked.connect(_on_revolver_clicked)
	revolver_mockup.mouse_entered.connect(_on_revolver_entered)
	revolver_mockup.mouse_exited.connect(_on_revolver_exited)
	bullets.hovered.connect(_on_bullet_hovered)
	bullets.unhovered.connect(_on_bullet_unhovered)
	player.chamber_updated.connect(_on_chamber_updated)
	choices.dealer_label.mouse_entered.connect(_on_dealer_label_entered)
	choices.dealer_label.mouse_exited.connect(_on_dealer_label_exited)
	
	choices.you_label.mouse_entered.connect(_on_you_label_entered)
	choices.you_label.mouse_exited.connect(_on_you_label_exited)
	profit_timer.timeout.connect(_on_profit_timeout)
	session.worth_changed.connect(_on_worth_changed)
	monitor_3d.push("[TUTOR_TAKE]")

func show_target_reach() -> void:
	var target := "%s$" % session.target_worth
	monitor_3d.clear()
	monitor_3d.push_back("[TUTOR_REACH]", ["[TUTOR_REACH]", target, "[TUTOR_RESCUE]"])

func show_current_score(score: String) -> void:
	monitor_3d.clear()
	monitor_3d.push_back("score", [score])

func _on_worth_changed(_new_worth: int) -> void:
	show_current_score(session.get_score_line())

func show_profit(profit: int) -> void:
	var profit_line := "+%s$" % profit
	monitor_3d.push_back("profit", [profit_line])
	profit_timer.start()

func show_game_end() -> void:
	monitor_3d.push("[GAMEPLAY_SADLY]")

func _on_profit_timeout() -> void:
	monitor_3d.pop_back("profit")

func show_good_luck() -> void:
	monitor_3d.push("[GAMEPLAY_GOOD]")

func show_sad() -> void:
	monitor_3d.push("[GAMEPLAY_SURE]")

func _on_dealer_label_entered() -> void:
	monitor_3d.pop_back("x1")
	monitor_3d.push("x1")

func _on_dealer_label_exited() -> void:
	monitor_3d.pop_back("x1")

func _on_you_label_entered() -> void:
	monitor_3d.pop_back("x1")
	monitor_3d.push_back("self", ["x%s" % session.get_selfshot_modifier()])

func _on_you_label_exited() -> void:
	monitor_3d.pop_back("self")

func _on_revolver_clicked() -> void:
	monitor_3d.pop_back("[TUTOR_TAKE]")
	monitor_3d.push("[TUTOR_RELOAD]")

func _on_revolver_entered() -> void:
	monitor_3d.push("[TUTOR_GOOD]")

func _on_revolver_exited() -> void:
	monitor_3d.pop_back("[TUTOR_GOOD]")

func _on_bullet_hovered(bullet: Bullet) -> void:
	monitor_3d.push_back("bullet", [bullet.get_short_description()])

func _on_bullet_unhovered(_bullet: Bullet) -> void:
	monitor_3d.pop_back("bullet")

func _on_chamber_updated(_revolver: Revolver) -> void:
	monitor_3d.pop_back("chamber")
	var value := player.get_chamber_worth()
	var line := "=%s$" % [value]
	monitor_3d.push_back("chamber", [line])
