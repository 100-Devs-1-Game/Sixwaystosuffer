class_name Patron
extends Node3D

@onready var interactable: Area3D = %Interactable
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	interactable.mouse_entered.connect(_on_mouse_entered)
	interactable.mouse_exited.connect(_on_mouse_exited)
	interactable.input_event.connect(_on_input_event)

func _on_mouse_entered() -> void:
	animation_player.play("hover")

func _on_mouse_exited() -> void:
	animation_player.play_backwards("hover")

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	pass
