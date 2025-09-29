class_name Bullet
extends Node3D

signal clicked(patron: Bullet)
signal hovered(patron: Bullet)
signal unhovered(patron: Bullet)

@export var effect: BulletEffectResource

@onready var interact_area_3d: ClickableArea3D = %"Interact Area3d"
@onready var raise_on_hover: RaiseOnHover = %RaiseOnHover
@onready var chamber_position: Node3D = $"Chamber Position"

var on_table_index: int

var on_table_position: Vector3
var on_table_rotation: Vector3

func _ready() -> void:
	interact_area_3d.clicked.connect(func(): clicked.emit(self))
	interact_area_3d.mouse_entered.connect(func(): hovered.emit(self))
	interact_area_3d.mouse_exited.connect(func(): unhovered.emit(self))

func update_on_table(index: int, position_node: Node3D) -> void:
	on_table_index = index
	on_table_position = position_node.global_position
	on_table_rotation = position_node.global_rotation
	raise_on_hover.setup_init_position(on_table_position)

func enable() -> void:
	interact_area_3d.enable()
	raise_on_hover.is_enabled = true

func disable() -> void:
	interact_area_3d.disable()
	raise_on_hover.is_enabled = false
	raise_on_hover.reset()

func get_short_description() -> String:
	return effect.get_short_description()

func get_description() -> String:
	return effect.description
