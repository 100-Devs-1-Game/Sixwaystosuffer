@tool
class_name Monitor3D
extends Node3D

@export var text: String:
	set(value):
		text = value
		%"Digital Label3D".text = value

@export var is_blinking: bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_3d: Label3D = %"Digital Label3D"
@onready var phrase_change_timer: Timer = $"Phrase Change Timer"

var phrases: Array[String]
var phrase_index: int

func _ready() -> void:
	if not Engine.is_editor_hint() and is_blinking:
		animation_player.play("blinking")
		phrase_change_timer.timeout.connect(_on_phrase_change_timeout)

func switch_text(new_text: String) -> void:
	phrase_change_timer.stop()
	animation_player.seek(0)
	label_3d.text = new_text

func setup_phrase(phrase: Array[String], duration: float = 2.0) -> void:
	self.phrases = phrase
	self.phrase_index = 0
	switch_text(phrases[0])
	phrase_change_timer.start(duration)

func _on_phrase_change_timeout() -> void:
	phrase_index = (phrase_index + 1) % phrases.size()
	switch_text(phrases[phrase_index])
	phrase_change_timer.start()
