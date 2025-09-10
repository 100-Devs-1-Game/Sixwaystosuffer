class_name ClickableArea3D
extends Area3D

signal clicked()

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		clicked.emit()

func enable() -> void:
	input_ray_pickable = true

func disable() -> void:
	input_ray_pickable = false
