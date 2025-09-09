@tool
class_name TableLabel
extends Node3D

signal clicked()

@export var text: String:
	set(value):
		text = value
		%Label3D.text = value

@export var hovered_color: Color
@export var normal_color: Color
@export var hover_duration: float = 0.2

@onready var label_3d: Label3D = %Label3D
@onready var area_3d: Area3D = %Area3D
@onready var clicked_on_area3d = %ClickedOnArea3D

var tween: Tween

func _on_mouse_entered() -> void:
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate", hovered_color, hover_duration)
	tween.parallel().tween_property(label_3d, "scale", Vector3.ONE * 1.1, hover_duration)

func _on_mouse_exited() -> void:
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate", normal_color, hover_duration)
	tween.parallel().tween_property(label_3d, "scale", Vector3.ONE, hover_duration)

func _on_clicked(_area: Area3D) -> void:
	clicked.emit()

func smooth_show() -> void:
	area_3d.mouse_entered.connect(_on_mouse_entered)
	area_3d.mouse_exited.connect(_on_mouse_exited)
	clicked_on_area3d.clicked.connect(_on_clicked)
	
	label_3d.modulate.a = 0
	show()
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate:a", 0.4, hover_duration * 3)

func smooth_hide() -> void:
	area_3d.mouse_entered.disconnect(_on_mouse_entered)
	area_3d.mouse_exited.disconnect(_on_mouse_exited)
	clicked_on_area3d.clicked.disconnect(_on_clicked)
	
	_stop_tween_if_needed()
	tween = create_tween()
	tween.tween_property(label_3d, "modulate:a", 0.0, hover_duration * 3)
	tween.tween_callback(hide)

func _stop_tween_if_needed() -> void:
	if not tween:
		return
	tween.kill()
	tween = null
