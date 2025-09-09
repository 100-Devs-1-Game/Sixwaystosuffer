class_name StateMachine
extends Node

@export var initial_state: State

var state_mapping: Dictionary[GDScript, State]
var current_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			var script: GDScript = child.get_script()
			state_mapping[script] = child
			child.state_machine = self
	
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func switch_to(target_state: GDScript) -> void:
	if not state_mapping.has(target_state):
		printerr("State %s not found in state machine %s" % [target_state.get_global_name(), get_path()])
		return
	
	if current_state != null:
		if current_state is StateAsync:
			await current_state.exit_async()
		else:
			current_state.exit()
	
	var next_state := state_mapping[target_state]
	current_state = next_state
	
	if current_state is StateAsync:
		await current_state.enter_async()
	else:
		current_state.enter()
