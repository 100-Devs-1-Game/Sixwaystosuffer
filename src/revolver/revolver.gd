class_name Revolver
extends Node3D

@export var drum: Node3D

var _tween: Tween


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			spin_up()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			spin_down()

func spin_down() -> void:
	if _tween != null and _tween.is_running():
		return
	
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:x", drum.rotation.x - deg_to_rad(60), 0.25).set_trans(Tween.TRANS_BOUNCE)

func spin_up() -> void:
	if _tween != null and _tween.is_running():
		return
	
	_tween = create_tween()
	_tween.tween_property(drum, "rotation:x", drum.rotation.x + deg_to_rad(60), 0.25).set_trans(Tween.TRANS_BOUNCE)
