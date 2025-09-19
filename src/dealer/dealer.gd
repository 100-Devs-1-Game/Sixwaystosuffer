class_name Dealer
extends Node3D

@export var min_face_time_change: float = 1.3
@export var max_face_time_change: float = 2.1

@onready var cube_head: MeshInstance3D = %Cube_Head
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_animation_player: AnimationPlayer = $"Fire AnimationPlayer"

@onready var head_rotation_audio_player: AudioStreamPlayer = %"Head Rotation Audio Player"
@onready var head_rotation_timer: Timer = %"Head Rotation Timer"

enum DealerFace {
	UNKNOWN = 0,
	NEUTRAL = 1,
	HAPPY = 2,
	SAD = 3,
	HYPED = 4
}

var face_angles: Dictionary[DealerFace, float]
var current_face: DealerFace = DealerFace.NEUTRAL
var face_tweening: Tween

func _ready() -> void:
	head_rotation_timer.timeout.connect(_on_head_rotation_timeout)
	face_angles = {
		DealerFace.NEUTRAL: 0.0,
		DealerFace.HAPPY: 90.0,
		DealerFace.SAD: 180.0,
		DealerFace.HYPED: 270.0
	}

func entry() -> void:
	animation_player.play("entry")
	_tween_head_rotation(face_angles[DealerFace.NEUTRAL], 2.0)

func quit() -> void:
	animation_player.play_backwards("entry")

func fire() -> void:
	fire_animation_player.play("fire")

func take_damage() -> void:
	animation_player.play("take_damage")

func change_face(new_face: DealerFace) -> void:
	if current_face == new_face:
		return
	
	var target_angle := face_angles[new_face]
	var duration := clampf(abs(current_face - new_face), min_face_time_change, max_face_time_change)
	_tween_head_rotation(target_angle, duration)
	current_face = new_face

func _tween_head_rotation(target_angle: float, duration: float) -> void:
	head_rotation_timer.stop()
	
	if face_tweening:
		face_tweening.kill()
		face_tweening = null
	
	face_tweening = create_tween()
	face_tweening.tween_property(cube_head, "rotation:y", deg_to_rad(target_angle), duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	
	head_rotation_timer.wait_time = duration / 3.0
	head_rotation_timer.start()

func _on_head_rotation_timeout() -> void:
	head_rotation_audio_player.play()
