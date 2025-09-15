class_name GameSession
extends Node

var start_time: int
var end_time: int

var target_rounds: int = 10
var total_worth: int

func start() -> void:
	start_time = Time.get_unix_time_from_system()

func stop() -> void:
	end_time = Time.get_unix_time_from_system()

func get_playtime() -> int:
	return end_time - start_time
