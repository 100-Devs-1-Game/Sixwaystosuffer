@tool
class_name TableLabel
extends Node3D

@export var text: String:
	set(value):
		text = value
		$Label3D.text = value
