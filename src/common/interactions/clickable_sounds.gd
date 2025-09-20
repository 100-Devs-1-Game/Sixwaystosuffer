class_name ClickableSounds
extends Node

@export var target: ClickableArea3D

@export var entered: AudioStreamPlayer
@export var exited: AudioStreamPlayer
@export var clicked: AudioStreamPlayer

@export var is_enabled: bool = true

func _ready() -> void:
	target.mouse_entered.connect(_play.bind(entered))
	target.mouse_exited.connect(_play.bind(exited))
	target.clicked.connect(_play.bind(clicked))

func _play(stream: AudioStreamPlayer) -> void:
	if stream == null or not is_enabled:
		return
		
	stream.play()
