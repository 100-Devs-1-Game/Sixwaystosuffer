class_name CurrentPositionHover
extends Node3D

@onready var valid_hover: MeshInstance3D = $"Valid Hover"
@onready var invalid_hover: MeshInstance3D = $"Invalid Hover"

func make_valid() -> void:
	valid_hover.show()
	invalid_hover.hide()

func make_invalid() -> void:
	valid_hover.hide()
	invalid_hover.show()
