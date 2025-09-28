class_name StateMachine
extends Node

signal processing_started(target: GDScript)
signal state_entered(target: GDScript)

@export var initial_state: State

var state_mapping: Dictionary[GDScript, State]
var current_state: State
var is_processing: bool

func _ready() -> void:
	for child in get_children():
		if child is State:
			var script: GDScript = child.get_script()
			state_mapping[script] = child
			child.state_machine = self
	
	switch_to(initial_state.get_script())

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func switch_to(target_state: GDScript) -> void:
	if is_processing:
		return
	
	if not state_mapping.has(target_state):
		printerr("State %s not found in state machine %s" % [target_state.get_global_name(), get_path()])
		return
	
	is_processing = true
	processing_started.emit(target_state)
	
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
	
	state_entered.emit(target_state)
	is_processing = false
