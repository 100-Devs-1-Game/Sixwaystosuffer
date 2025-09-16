@tool
class_name TableLabel
extends Node3D

signal mouse_entered()
signal mouse_exited()
signal clicked()

@export_multiline var text: String:
	set(value):
		text = value
		%Label3D.text = value

@export var hovered_color: Color
@export var normal_color: Color
@export var hover_duration: float = 0.2

@onready var label_3d: Label3D = %Label3D
@onready var clickable_area_3d: ClickableArea3D = %"Clickable Area3d"

var tween: Tween

func _on_mouse_entered() -> void:
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate", hovered_color, hover_duration)
	tween.parallel().tween_property(label_3d, "scale", Vector3.ONE * 1.1, hover_duration)
	mouse_entered.emit()

func _on_mouse_exited() -> void:
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate", normal_color, hover_duration)
	tween.parallel().tween_property(label_3d, "scale", Vector3.ONE, hover_duration)
	mouse_exited.emit()

func _on_clicked() -> void:
	clicked.emit()

func smooth_show() -> void:
	label_3d.modulate = normal_color
	label_3d.scale = Vector3.ONE
	
	clickable_area_3d.enable()
	clickable_area_3d.mouse_entered.connect(_on_mouse_entered)
	clickable_area_3d.mouse_exited.connect(_on_mouse_exited)
	clickable_area_3d.clicked.connect(_on_clicked)
	
	label_3d.modulate.a = 0
	show()
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate:a", 0.4, hover_duration * 3)

func smooth_hide() -> void:
	clickable_area_3d.disable()
	clickable_area_3d.mouse_entered.disconnect(_on_mouse_entered)
	clickable_area_3d.mouse_exited.disconnect(_on_mouse_exited)
	clickable_area_3d.clicked.disconnect(_on_clicked)
	
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate:a", 0.0, hover_duration * 3)
	
	tween.tween_callback(hide)

func _stop_tween_if_needed() -> void:
	if not tween:
		return
	tween.kill()
	tween = null
