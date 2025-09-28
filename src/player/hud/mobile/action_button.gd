class_name ActionButton
extends Button

@export var action_name: String

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Input.parse_input_event(make_pressed_action(action_name))

func make_pressed_action(target_action_name: String) -> InputEvent:
	var event := InputEventAction.new()
	event.action = target_action_name
	event.pressed = true
	return event
