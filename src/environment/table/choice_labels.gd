class_name ChoiceLabels
extends Node3D

@export var monitor: QueuedMonitor3D

@onready var dealer_label: TableLabel = %"Dealer Label"
@onready var you_label: TableLabel = %"You Label"

var is_shown: bool

func show_labels() -> void:
	if is_shown:
		return
	
	is_shown = true
	dealer_label.smooth_show()
	you_label.smooth_show()

func hide_labels() -> void:
	if not is_shown:
		return
	
	is_shown = false
	dealer_label.smooth_hide()
	you_label.smooth_hide()
