class_name QueuedMonitor3D
extends Node3D

@onready var monitor_3d: Monitor3D = $"Monitor 3D"

var items: Dictionary[String, Array]
var queue: Array[String] 

func clear() -> void:
	items.clear()
	queue.clear()
	monitor_3d.setup_phrase([""])

func push(content: String) -> void:
	push_back(content, [content])

func push_back(id: String, content: Array[String]) -> void:
	items[id] = content
	queue.push_back(id)
	show_last()

func pop_back(id: String) -> void:
	items.erase(id)
	var index := queue.find(id)
	
	if index < 0:
		return
	
	queue.remove_at(index)
	show_last()

func show_last() -> void:
	if queue.size() < 1:
		return
	
	var id = queue.back()
	monitor_3d.setup_phrase(items[id])
