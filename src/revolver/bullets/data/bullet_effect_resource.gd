class_name BulletEffectResource
extends Resource

@export var is_dummy: bool = false
@export var load_bonus: int = 10
@export var load_modifier: int = 1
@export var on_table_income: int = 0
@export_multiline var description: String

func get_short_description() -> String:
	var line: String = ""
	
	if is_dummy:
		line += "D!"
	
	if load_bonus != 0:
		line += "+%s$" % load_bonus
	
	if load_modifier != 1:
		line += "x%s" % load_modifier
	
	return line

func get_description() -> String:
	return description
