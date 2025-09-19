class_name FloatingControl
extends Control

@export var amplitude: float
@export var scaling: float = 1.0
@export var speed: float

var base_position: Vector2
var base_scale: Vector2
var elapsed_time: float

func _ready() -> void:
	base_position = position
	base_scale = scale

func _process(delta: float) -> void:
	elapsed_time += delta
	var period := sin(elapsed_time * speed)
	var offset := amplitude * period
	position = base_position + offset * Vector2.UP
	scale = base_scale + scaling * period * Vector2.ONE
