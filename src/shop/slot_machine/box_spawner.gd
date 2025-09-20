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
	for box in boxes:
		if box.is_blocked:
			continue
		
		var random_product = available_resources.pick_random()
		var instance = random_product.shop_item.instantiate()
		
		if random_product is BulletProduct:
			for child in instance.get_children():
				var bullet = random_product.scene.instantiate()
				child.add_child(bullet)
		
		box.product_position.add_child(instance)
		box.product = random_product

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
