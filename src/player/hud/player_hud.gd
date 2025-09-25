class_name PlayerHUD
extends CanvasLayer

@onready var curtain: ColorRect = %Curtain
@onready var statistic_panel: StatisticPanel = %"Statistic Panel"
@onready var global_tooltip_container: PanelContainer = $"Global Tooltip Container"

func show_curtain(duration: float = 1.0) -> void:
	curtain.modulate.a = 0
	curtain.show()
	_tween_alpha(curtain, 1.0, duration)

func hide_curtain(duration: float = 1.0) -> void:
	_tween_alpha(curtain, 0, duration).tween_callback(curtain.hide)

func show_statistic(duration: float = 1.0) -> void:
	statistic_panel.modulate.a = 0
	statistic_panel.show()
	_tween_alpha(statistic_panel, 1.0, duration)

func hide_statistic(duration: float = 1.0) -> void:
	_tween_alpha(statistic_panel, 0, duration).tween_callback(statistic_panel.hide)

func show_shop_tooltip() -> void:
	global_tooltip_container.modulate.a = 0
	global_tooltip_container.show()
	_tween_alpha(global_tooltip_container, 0.8, 0.25)

func hide_shop_tooltip() -> void:
	_tween_alpha(global_tooltip_container, 0, 0.25).tween_callback(global_tooltip_container.hide)

func _tween_alpha(target: Object, target_value: float, duration: float) -> Tween:
	var tween := create_tween()
	tween.tween_property(target, "modulate:a", target_value, duration)
	return tween
