class_name GameSession
extends Node

var start_time: int
var end_time: int

@export var initial_bullets_count: int = 4
@export var max_rounds: int = 10
@export var target_worth: int = 999

var total_worth: int
var worth_spent: int

var round_record_worth: int

var dropped_bullets: int
var total_shots: int
var self_aiming_count: int
var dealer_aiming_count: int
var slot_machine_rolls: int

func start() -> void:
	start_time = int(Time.get_unix_time_from_system())

func stop() -> void:
	end_time = int(Time.get_unix_time_from_system())

func get_playtime_line() -> String:
	var unix_time := end_time - start_time
	var dt := Time.get_datetime_dict_from_unix_time(unix_time)
	return "%02d:%02d:%02d" % [dt.hour, dt.minute, dt.second]

func make_shot(patron: Patron, revolver: Revolver, to_dealer: bool) -> int:
	var modifier: int = 1 if to_dealer else 10
	var worth := revolver.chamber.get_worth()
	var result := modifier * worth
	total_worth += result
	
	_update_statistic(patron, result, to_dealer)
	return result

func make_roll() -> void:
	slot_machine_rolls += 1

func can_purchase(cost: int) -> bool:
	return total_worth >= cost

func make_purchase(cost: int) -> void:
	total_worth -= cost
	worth_spent += cost

func get_score_line() -> String:
	return "%s/%s$" % [total_worth, target_worth]

func _update_statistic(patron: Patron, worth: int,  to_dealer: bool) -> void:
	if worth > round_record_worth:
		round_record_worth = worth
	
	if patron:
		total_shots += 1
	
	if to_dealer:
		dealer_aiming_count += 1
	else:
		self_aiming_count += 1
