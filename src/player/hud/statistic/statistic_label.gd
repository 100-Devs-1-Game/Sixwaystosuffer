@tool
class_name StatisticLabel
extends MarginContainer

@export var title: String:
	set(value):
		title = value
		%"Title Label".text = value

@export var content: String:
	set(value):
		content = value
		%"Content Label".text = value
