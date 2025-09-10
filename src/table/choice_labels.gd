class_name ChoiceLabels
extends Node3D

signal dealer_selected()
signal self_selected()

@onready var dealer_label: TableLabel = %"Dealer Label"
@onready var you_label: TableLabel = %"You Label"

func show_labels() -> void:
	dealer_label.smooth_show()
	you_label.smooth_show()
	
	dealer_label.clicked.connect(_on_dealer_clicked)
	you_label.clicked.connect(_on_self_clicked)

func hide_labels() -> void:
	dealer_label.clicked.disconnect(_on_dealer_clicked)
	you_label.clicked.disconnect(_on_self_clicked)
	
	dealer_label.smooth_hide()
	you_label.smooth_hide()

func _on_dealer_clicked() -> void:
	dealer_selected.emit()

func _on_self_clicked() -> void:
	self_selected.emit()
