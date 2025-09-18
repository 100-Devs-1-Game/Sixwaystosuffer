class_name ChamberAudioScroll
extends Node

const ANGLE_ROTATION_FOR_SOUND: float = 55

@export var chamber: Node3D
@export var chamber_audio_player: AudioStreamPlayer

var previous_rotation: float

func _ready() -> void:
	previous_rotation = chamber.rotation.z

func _physics_process(_delta: float) -> void:
	var diff = abs(chamber.rotation.z - previous_rotation)
	
	if diff > deg_to_rad(ANGLE_ROTATION_FOR_SOUND):
		previous_rotation = chamber.rotation.z
		chamber_audio_player.play()
