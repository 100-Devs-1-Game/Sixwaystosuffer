@tool
class_name Monitor3D
extends Node3D

@export var text: String:
	set(value):
		text = value
		%Label3D.text = value

@export var is_blinking: bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if is_blinking:
		animation_player.play("blinking")
