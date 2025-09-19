class_name ShaderWarmupState
extends StateAsync

func enter_async() -> void:
	await pause(0.5)
	for child in get_children():
		if child is Node3D:
			child.visible = false
	
	state_machine.switch_to.call_deferred(IntroState)

func exit_async() -> void:
	pass
