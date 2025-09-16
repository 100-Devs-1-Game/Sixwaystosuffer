class_name StatisticPanel
extends PanelContainer

@onready var playtime_label: StatisticLabel = %"Playtime Label"
@onready var reached_worth_label: StatisticLabel = %"Reached Worth Label"
@onready var record_per_shot_label: StatisticLabel = %"Record Per Shot Label"
@onready var bullets_dropped_label: StatisticLabel = %"Bullets Dropped Label"
@onready var total_shots_label: StatisticLabel = %"Total Shots Label"
@onready var self_aimed_label: StatisticLabel = %"Self Aimed Label"
@onready var dealer_aimed_label: StatisticLabel = %"Dealer Aimed Label"

func update(session: GameSession) -> void:
	playtime_label.content = session.get_playtime_line()
	reached_worth_label.content = "%s$" % session.total_worth
	record_per_shot_label.content = "%s$" % session.round_record_worth
	bullets_dropped_label.content = str(session.dropped_bullets)
	total_shots_label.content = str(session.total_shots)
	self_aimed_label.content = str(session.self_aiming_count)
	dealer_aimed_label.content = str(session.dealer_aiming_count)
	
