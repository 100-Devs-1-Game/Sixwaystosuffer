class_name GameReloadState
extends State

func enter() -> void:
	reload_root.call_deferred()

func exit() -> void:
	pass

func reload_root() -> void:
	get_tree().reload_current_scene()
