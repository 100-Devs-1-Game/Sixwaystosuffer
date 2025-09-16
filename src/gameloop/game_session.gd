class_name GameSession
extends Node

signal updated

var start_time: int
var end_time: int

var target_rounds: int = 10
var total_worth: int

var target_worth: int = 999

func start() -> void:
	start_time = Time.get_unix_time_from_system()

func stop() -> void:
	end_time = Time.get_unix_time_from_system()

func get_playtime() -> int:
	return end_time - start_time

func make_shot(revolver: Revolver, to_dealer: bool) -> void:
	var modifier: int = 1 if to_dealer else 10
	var worth := revolver.chamber.get_worth()
	var result := modifier * worth
	total_worth += result
	updated.emit()

func get_score_line() -> String:
	return "%s$/%s$" % [total_worth, target_worth]
