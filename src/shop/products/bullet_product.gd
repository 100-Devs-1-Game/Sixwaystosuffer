class_name BulletProduct
extends ShopProduct

@export var quantity: int
@export var scene: PackedScene
@export var effect: BulletEffectResource

func get_description() -> String:
	if effect == null:
		return super()
	return effect.get_description()
