class_name SlotMachine
extends Node3D

@export var ammo: PlayerPatrons
@export var session: GameSession

func purchase(product: ShopProduct) -> void:
	if product is BulletProduct:
		purchase_bullet(product)

func purchase_bullet(product: BulletProduct) -> void:
	session.total_worth -= product.cost
	
	for i in product.quantity:
		# TODO: make animation?
		var instance = product.scene.instantiate()
		ammo.add(instance)
	
	print("purchased success")
