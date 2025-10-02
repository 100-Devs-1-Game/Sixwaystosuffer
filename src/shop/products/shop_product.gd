class_name ShopProduct
extends Resource

@export var name: String
@export_multiline var description: String
@export var cost: int
@export var shop_item: PackedScene
@export_range(0, 1) var weight: float

var weight_acc: float

func get_description() -> String:
	return description
