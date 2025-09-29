class_name DebugPlayer
extends Node

@export var pickup: BulletPickup
@export var debug_bullet: Bullet

func _ready() -> void:
	debug_bullet.clicked.connect(_on_bullet_clicked)

func _on_bullet_clicked(bullet: Bullet) -> void:
	var duplicated_bullet := debug_bullet.duplicate()
	debug_bullet.get_parent().add_child(duplicated_bullet)
	pickup.load_bullet(duplicated_bullet)
