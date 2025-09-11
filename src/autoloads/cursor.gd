extends Node

func make_interaction() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func clear() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
