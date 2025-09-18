class_name BoxSpawner
extends Node

@export var boxes: Array[ShopBox]

var is_opened: bool = false

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
