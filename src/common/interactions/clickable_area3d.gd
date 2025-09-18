class_name ClickableArea3D
extends Area3D

signal clicked()

func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		clicked.emit()

func enable() -> void:
	input_ray_pickable = true

func disable() -> void:
	input_ray_pickable = false

func _on_mouse_entered() -> void:
	Cursor.make_interaction()

func _on_mouse_exited() -> void:
	Cursor.clear()
