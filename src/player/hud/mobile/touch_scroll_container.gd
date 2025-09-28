class_name TouchScrollContainer
extends ScrollContainer

var touch_scroll_speed := 1.5
var touch_prev_position := Vector2()

func _input(event: InputEvent):
	var focused_node = get_viewport().gui_get_focus_owner()
	
	if focused_node:
		if not is_ancestor_of(focused_node):
			return
	
	if event is InputEventScreenDrag:
		var delta = event.position - touch_prev_position
		set_v_scroll(get_v_scroll() - delta.y * touch_scroll_speed)
		touch_prev_position = event.position
	elif event is InputEventScreenTouch and event.pressed:
		touch_prev_position = event.position
