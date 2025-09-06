class_name Player
extends Node3D

@onready var animation_player: AnimationPlayer = $"Player Hand/AnimationPlayer"
@onready var revolver: Revolver = %Revolver

var is_opened: bool

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_interact"):
		if not is_opened:
			animation_player.play("open_drum")
		else:
			animation_player.play("close_drum")
		is_opened = !is_opened
	
	if event.is_action_pressed("debug_fire"):
		revolver.fire()
	
	if event.is_action_pressed("debug_self_aim"):
		animation_player.play("self_aim")
