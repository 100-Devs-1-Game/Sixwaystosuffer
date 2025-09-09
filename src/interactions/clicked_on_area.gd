class_name ClickedOnArea3D
extends Node

signal clicked(area: Area3D)

@export var area: Area3D

func _ready() -> void:
	area.input_event.connect(_on_input_event)

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("debug_interact"):
		clicked.emit(area)
