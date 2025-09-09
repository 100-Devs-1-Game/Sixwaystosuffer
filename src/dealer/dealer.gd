class_name Dealer
extends Node3D

@export var min_face_time_change: float = 1.3
@export var max_face_time_change: float = 2.1

@onready var cube_head: MeshInstance3D = $dealer2/HG_Dealer/Cube_Head
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum DealerFace {
	UNKNOWN = 0,
	NEUTRAL = 1,
	HAPPY = 2,
	HYPED = 3,
	HYPED_TEETH = 4
}

var face_angles: Dictionary[DealerFace, float]
var current_face: DealerFace = DealerFace.NEUTRAL
var face_tweening: Tween

func _ready() -> void:
	face_angles = {
		DealerFace.NEUTRAL: 0.0,
		DealerFace.HAPPY: 90.0,
		DealerFace.HYPED: 180.0,
		DealerFace.HYPED_TEETH: 270.0
	}

func entry() -> void:
	animation_player.play("entry")

func change_face(new_face: DealerFace) -> void:
	if face_tweening:
		face_tweening.kill()
		face_tweening = null
	
	face_tweening = create_tween()
	var angle_in_rads := deg_to_rad(face_angles[new_face])
	var duration := clampf(abs(current_face - new_face), min_face_time_change, max_face_time_change)
	face_tweening.tween_property(cube_head, "rotation:y", angle_in_rads, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	current_face = new_face
