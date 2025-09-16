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

func add(patron: Patron) -> void:
	var index := get_free_index()
	var patron_position := positions[index]
	bullets[index] = patron
	patron.on_table_index = index
	patron.on_table_position = patron_position.global_position
	patron.on_table_rotation = patron_position.global_rotation
	patron_position.add_child(patron)

func return_patron(patron: Patron) -> void:
	if bullets[patron.on_table_index]:
		printerr("Already has bullets in this index!")
	
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
