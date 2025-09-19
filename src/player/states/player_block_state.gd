class_name PlayerBlockState
extends State

@export var revolver_interact_area3d: ClickableArea3D

func enter() -> void:
	revolver_interact_area3d.disable()

func exit() -> void:
	revolver_interact_area3d.enable()
