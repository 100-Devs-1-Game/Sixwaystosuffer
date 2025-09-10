class_name Patron
extends Node3D

signal clicked(patron: Patron)

@onready var interact_area_3d: ClickableArea3D = %"Interact Area3d"
@onready var raise_on_hover: RaiseOnHover = %RaiseOnHover
@onready var chamber_position: Node3D = $"Chamber Position"


func _ready() -> void:
	interact_area_3d.clicked.connect(func(): clicked.emit(self))

func enable() -> void:
	interact_area_3d.monitorable = true

func disable() -> void:
	raise_on_hover.reset()
	interact_area_3d.monitorable = false
