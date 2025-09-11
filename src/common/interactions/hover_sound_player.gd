class_name HoverSoundPlayer
extends AudioStreamPlayer

@export var area: Area3D

func _ready() -> void:
	area.mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	play()
