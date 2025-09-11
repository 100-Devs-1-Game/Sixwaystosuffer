class_name SmoothAudioStreamPlayer
extends AudioStreamPlayer

@export var smooth_duration: float = 2.0
@export var initial_db: float = -60.0
@export var target_db: float = 0.0

var _smoothing: Tween

func smooth_play() -> void:
	if _smoothing:
		_smoothing.kill()
		_smoothing = null
	
	volume_db = initial_db
	play()
	
	_smoothing = create_tween()
	_smoothing.tween_property(self, "volume_db", target_db, smooth_duration)
