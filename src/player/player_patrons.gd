class_name PlayerPatrons
extends Node3D

signal clicked(patron: Patron)

func enable_patrons_interaction() -> void:
	for child in get_children():
		if child is Patron:
			child.enable()
			child.clicked.connect(_on_patron_clicked)

func disable_patrons_interaction() -> void:
	for child in get_children():
		if child is Patron:
			child.disable()
			child.clicked.disconnect(_on_patron_clicked)

func _on_patron_clicked(patron: Patron) -> void:
	clicked.emit(patron)
