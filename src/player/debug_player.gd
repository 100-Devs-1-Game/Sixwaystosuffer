class_name DebugPlayer
extends Node

@export var pickup: PatronPickup
@export var debug_patron: Patron

func _ready() -> void:
	debug_patron.clicked.connect(_on_patron_clicked)

func _on_patron_clicked(patron: Patron) -> void:
	var duplicated_patron := debug_patron.duplicate()
	debug_patron.get_parent().add_child(duplicated_patron)
	pickup.load_patron(duplicated_patron)
