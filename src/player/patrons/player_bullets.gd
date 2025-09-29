class_name PlayerBullets
extends Node3D

signal updated()

signal clicked(bullet: Bullet)
signal hovered(bullet: Bullet)
signal unhovered(bullet: Bullet)

var positions: Array[Node3D]
var bullets: Array[Bullet]

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

func get_bullets() -> Array[Bullet]:
	var result: Array[Bullet]
	for item in bullets:
		if item != null:
			result.append(item)
	return result

func add(bullet: Bullet) -> void:
	var index := get_free_index()
	var bullet_position := positions[index]
	bullet_position.add_child(bullet)
	bullet.update_on_table(index, bullet_position)
	bullets[index] = bullet
	updated.emit()

func get_passive_income() -> int:
	var total_income := 0
	for bullet in get_bullets():
		total_income += bullet.effect.on_table_income
	return total_income

func setup_free_position(bullet: Bullet) -> void:
	var target_index := bullet.on_table_index
	
	if bullets[target_index]:
		target_index = get_free_index()
		bullet.update_on_table(target_index, positions[target_index])

func return_bullet(bullet: Bullet) -> void:
	if bullets[bullet.on_table_index]:
		printerr("it's position used!")
		return
	
	bullets[bullet.on_table_index] = bullet
	updated.emit()

func remove(bullet: Bullet) -> void:
	var index := bullets.find(bullet)
	
	if index == -1:
		return
	
	bullets[index] = null
	updated.emit()

func enable_bullets_interaction() -> void:
	for bullet in bullets:
		if bullet == null:
			continue
		
		bullet.enable()
		bullet.clicked.connect(_on_bullet_clicked)
		bullet.hovered.connect(_on_bullet_hovered)
		bullet.unhovered.connect(_on_bullet_unhovered)

func disable_bullets_interaction() -> void:
	for bullet in bullets:
		if bullet == null:
			continue
		
		bullet.disable()
		bullet.clicked.disconnect(_on_bullet_clicked)
		bullet.hovered.disconnect(_on_bullet_hovered)
		bullet.unhovered.disconnect(_on_bullet_unhovered)

func _on_bullet_clicked(bullet: Bullet) -> void:
	clicked.emit(bullet)

func _on_bullet_hovered(bullet: Bullet) -> void:
	hovered.emit(bullet)

func _on_bullet_unhovered(bullet: Bullet) -> void:
	unhovered.emit(bullet)
