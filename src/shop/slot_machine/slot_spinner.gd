class_name SlotSpinner
extends Node

const ITEMS_ON_CYLINDER: int = 9

signal done()

@export var cylinder_1: StepSpinner
@export var cylinder_2: StepSpinner
@export var cylinder_3: StepSpinner
@export var timer: Timer

var random := RandomNumberGenerator.new()

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	done.emit()

func spin() -> void:
	var target_slot := get_random_slot()
	var steps_1 = target_slot + get_random_steps()
	var steps_2 = target_slot + get_random_steps()
	var steps_3 = target_slot + get_random_steps()
	
	cylinder_1.spin(steps_1)
	cylinder_2.spin(steps_2)
	cylinder_3.spin(steps_3)
	
	var timer_duration: int = max(steps_1, steps_2, steps_3)
	timer.start(timer_duration * cylinder_1.duration_per_step + cylinder_1.duration_per_step)

func get_random_slot() -> int:
	return random.randi_range(1, ITEMS_ON_CYLINDER + 1)

func get_random_steps() -> int:
	return random.randi_range(3, 6) * ITEMS_ON_CYLINDER
