class_name SlotSpinner
extends Node

const ITEMS_ON_CYLINDER: int = 9

signal done()

@export var cylinders: Array[StepSpinner]
@export var timer: Timer

var random := RandomNumberGenerator.new()

var max_duration: float

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	done.emit()

func spin() -> void:
	var target_slot := get_random_slot()
	
	for cylinder in cylinders:
		var steps := target_slot + get_random_steps()
		cylinder.spin(steps)
		max_duration = maxf(max_duration, steps * cylinder.duration_per_step)
	
	timer.start(max_duration)

func get_random_slot() -> int:
	return random.randi_range(1, ITEMS_ON_CYLINDER + 1)

func get_random_steps() -> int:
	return random.randi_range(3, 6) * ITEMS_ON_CYLINDER
