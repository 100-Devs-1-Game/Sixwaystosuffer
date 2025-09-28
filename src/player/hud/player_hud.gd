class_name PlayerHUD
extends CanvasLayer

const MOBILE_EXTRA_UI := preload("res://player/hud/mobile/mobile_device_ui.tscn")

@export var player: Player

@onready var curtain: ColorRect = %Curtain
@onready var statistic_panel: StatisticPanel = %"Statistic Panel"
@onready var global_tooltip_container: PanelContainer = $"Global Tooltip Container"

var mobile_device_ui: MobileDeviceUI

func _ready() -> void:
	await get_tree().physics_frame
	
	if is_mobile():
		mobile_device_ui = MOBILE_EXTRA_UI.instantiate()
		add_child(mobile_device_ui)
		mobile_device_ui.initialize(player)

func is_mobile() -> bool:
	return OS.has_feature("web_android") or OS.has_feature("web_ios")

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
	if is_mobile():
		mobile_device_ui.show_skip_shop_button()
		return
	
	global_tooltip_container.modulate.a = 0
	global_tooltip_container.show()
	_tween_alpha(global_tooltip_container, 0.8, 0.25)

func hide_shop_tooltip() -> void:
	if is_mobile():
		mobile_device_ui.hide_skip_shop_button()
		return
	
	_tween_alpha(global_tooltip_container, 0, 0.25).tween_callback(global_tooltip_container.hide)

func _tween_alpha(target: Object, target_value: float, duration: float) -> Tween:
	var tween := create_tween()
	tween.tween_property(target, "modulate:a", target_value, duration)
	return tween
