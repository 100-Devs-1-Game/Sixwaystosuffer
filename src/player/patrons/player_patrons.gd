class_name PlayerPatrons
extends Node3D

signal clicked(patron: Patron)
signal hovered(patron: Patron)
signal unhovered(patron: Patron)

var positions: Array[Node3D]
var bullets: Array[Patron]

func _ready() -> void:
	positions.resize(get_child_count())
	bullets.resize(get_child_count())
	for index in positions.size():
		positions[index] = get_child(index)

func get_free_position() -> Node3D:
	var index := get_free_index()
	return positions[index] if index >= 0 else null

func get_free_index() -> int:
	for index in bullets.size():
		if bullets[index] == null:
			return index
	return -1

func get_available_space() -> int:
	var space: int = 0
	for bullet in bullets:
		if bullet == null:
			space += 1
	return space

func has_bullets() -> bool:
	return get_available_space() < 13

func get_bullets() -> Array[Patron]:
	var result: Array[Patron]
	for item in bullets:
		if item != null:
			result.append(item)
	return result

func add(patron: Patron) -> void:
	var index := get_free_index()
	var patron_position := positions[index]
	patron_position.add_child(patron)
	patron.update_on_table(index, patron_position)
	bullets[index] = patron

func get_passive_income() -> int:
	var total_income := 0
	for bullet in get_bullets():
		total_income += bullet.effect.on_table_income
	return total_income

func setup_free_position(patron: Patron) -> void:
	var target_index := patron.on_table_index
	
	if bullets[target_index]:
		target_index = get_free_index()
		patron.update_on_table(target_index, positions[target_index])

func return_patron(patron: Patron) -> void:
	if bullets[patron.on_table_index]:
		printerr("it's position used!")
		return
	
	bullets[patron.on_table_index] = patron

func remove(patron: Patron) -> void:
	var index := bullets.find(patron)
	
	if index == -1:
		return
	
	bullets[index] = null

func enable_patrons_interaction() -> void:
	for bullet in bullets:
		if bullet == null:
			continue
		
		bullet.enable()
		bullet.clicked.connect(_on_patron_clicked)
		bullet.hovered.connect(_on_patron_hovered)
		bullet.unhovered.connect(_on_patron_unhovered)

func disable_patrons_interaction() -> void:
	for bullet in bullets:
		if bullet == null:
			continue
		
		bullet.disable()
		bullet.clicked.disconnect(_on_patron_clicked)
		bullet.hovered.disconnect(_on_patron_hovered)
		bullet.unhovered.disconnect(_on_patron_unhovered)

func _on_patron_clicked(patron: Patron) -> void:
	clicked.emit(patron)

func _on_patron_hovered(patron: Patron) -> void:
	hovered.emit(patron)

func _on_patron_unhovered(patron: Patron) -> void:
	unhovered.emit(patron)
