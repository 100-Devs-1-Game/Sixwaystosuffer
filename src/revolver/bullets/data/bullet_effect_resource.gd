class_name BulletEffectResource
extends Resource

@export var is_dummy: bool = false
@export var is_marked: bool = false
@export var load_bonus: int = 10
@export var load_modifier: int = 1
@export var on_table_income: int = 0

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
	var line: String = ""
	
	if is_dummy:
		line += "%s\n" % tr("[BULLET_DUMMY]")
	if is_marked:
		line += "%s\n" % tr("[BULLET_MARKED]")
	if load_bonus != 0:
		line += "+%s$ %s\n" % [load_bonus, tr("[BULLET_FOR_LOAD]")]
	if on_table_income != 0:
		line += "+%s$ %s\n" % [on_table_income, tr("[BULLET_IF_NOT_LOAD]")]
	if load_modifier != 1:
		line += "x%s %s\n" % [load_modifier, tr("[BULLET_FOR_LOAD]")]
	
	return line
