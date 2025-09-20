class_name BoxSpawner
extends Node

signal hovered(box: ShopBox)
signal unhovered(box: ShopBox)
signal clicked(box: ShopBox)

@export var boxes: Array[ShopBox]

var is_opened: bool = false

func _ready() -> void:
	for box in boxes:
		box.clickable_area_3d.disable()
		box.clickable_area_3d.clicked.connect(func(): clicked.emit(box))
		box.clickable_area_3d.mouse_entered.connect(func(): hovered.emit(box))
		box.clickable_area_3d.mouse_exited.connect(func(): unhovered.emit(box))

func spawn_items(available_resources: Array[ShopProduct]) -> void:
	var weighted_products := initialize_propabilities(available_resources)
	
	for box in boxes:
		if box.is_blocked:
			continue
		
		var random_product = get_weighted_random(weighted_products)
		var instance = random_product.shop_item.instantiate()
		
		if random_product is BulletProduct:
			for child in instance.get_children():
				var bullet = random_product.scene.instantiate()
				child.add_child(bullet)
		
		box.product_position.add_child(instance)
		box.product = random_product

func initialize_propabilities(products: Array[ShopProduct]) -> Array[Array]:
	var weighted_products: Array[Array]
	var total_weight = 0.0
	for product in products:
		total_weight += product.weight
		weighted_products.append([product, total_weight])
	return weighted_products

func get_weighted_random(weighted_products: Array[Array]) -> ShopProduct:
	var total_weight: float = weighted_products.back()[1]
	var roll := randf_range(0, total_weight)
	
	for product in weighted_products:
		var weight = product[1]
		
		if weight >= roll:
			return product[0] as ShopProduct
		
	return null

func clear_items() -> void:
	for box in boxes:
		for child in box.product_position.get_children():
			child.queue_free()

func switch() -> void:
	if not is_opened:
		open()
	else:
		close()

func open() -> void:
	is_opened = true
	for box in boxes:
		box.open()

func close() -> void:
	is_opened = false
	for box in boxes:
		box.close()
